import 'dart:async';

import 'package:catinder/data/model/cat_image.dart';
import 'package:catinder/data/service/api_service.dart';
import 'package:catinder/domain/repositories/cat_repository_interface.dart';
import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/data/mappers/cat_mappers.dart';

class CatRepository implements CatRepositoryInterface {
  final List<CatImage> _curBuffer = [];
  int _bufHead = 0;
  bool _isLoading = false;
  final int _bufferPadding = 5;
  final int _pageSize = 10;

  final Map<int, Completer<CatImageEntity>> _waitingCompleters = {};

  CatRepository() {
    _init();
  }

  Future<void> _init() async {
    await _loadMoreItems();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    _isLoading = true;

    try {
      final List<CatImage> newItemsDto = await getCatInfo(pageSize: _pageSize);
      _curBuffer.addAll(newItemsDto);

      final List<int> keysToProcess = _waitingCompleters.keys.toList();
      for (final key in keysToProcess) {
        if (_waitingCompleters.containsKey(key)) {
          if (key >= _bufHead && key < (_bufHead + _curBuffer.length)) {
            final completer = _waitingCompleters[key]!;
            if (!completer.isCompleted) {
              try {
                final entity =
                    CatImageMapper.fromDto(_curBuffer[key - _bufHead]);
                completer.complete(entity);
              } catch (e) {
                completer.completeError(e);
              }
            }
            _waitingCompleters.remove(key);
          }
        }
      }

      if (_waitingCompleters.isNotEmpty && newItemsDto.isNotEmpty) {
        _loadMoreItems();
      }
    } catch (e, stackTrace) {
      final List<Completer<CatImageEntity>> completersToError =
          _waitingCompleters.values.toList();
      for (final completer in completersToError) {
        if (!completer.isCompleted) {
          completer.completeError(e, stackTrace);
        }
      }
      _waitingCompleters.clear();
    } finally {
      _isLoading = false;
    }
  }

  @override
  FutureOr<CatImageEntity> get(int id) {
    if (id < _bufHead) {
      _bufHead = 0;
      _curBuffer.clear();
    }
    if (id > _bufferPadding * 2 + _bufHead) {
      _bufHead += _bufferPadding;
      _curBuffer.removeRange(0, _bufferPadding);
    }
    if (id + _bufferPadding > _curBuffer.length) {
      _loadMoreItems();
    }
    if (_bufHead + _curBuffer.length > id) {
      try {
        return CatImageMapper.fromDto(_curBuffer[id - _bufHead]);
      } catch (e) {
        return Future.error(e);
      }
    }
    final completer = Completer<CatImageEntity>();
    _waitingCompleters[id] = completer;
    if (!_isLoading) {
      _loadMoreItems();
    }
    return completer.future;
  }
}
