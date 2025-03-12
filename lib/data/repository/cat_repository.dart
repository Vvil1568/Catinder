import 'dart:async';

import 'package:catinder/data/model/cat_image.dart';
import 'package:catinder/data/service/api_service.dart';

class CatRepository {
  final List<CatImage> _curBuffer = [];
  int _bufHead = 0;
  bool _isLoading = false;
  final int _bufferPadding = 5;
  final int _pageSize = 10;

  final Map<int, Completer<CatImage>> _waitingCompleters = {};

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
      final newItems = await getCatInfo(pageSize: _pageSize);
      _curBuffer.addAll(newItems);
      for (final entry in _waitingCompleters.entries) {
        if (entry.key < _bufHead + _curBuffer.length) {
          entry.value.complete(_curBuffer[entry.key - _bufHead]);
          _waitingCompleters.remove(entry.key);
        }
      }
      if (_waitingCompleters.isNotEmpty) {
        _loadMoreItems();
      }
    } catch (e) {
      for (final entry in _waitingCompleters.entries) {
        entry.value.completeError(e);
      }
      _waitingCompleters.clear();
    } finally {
      _isLoading = false;
    }
  }

  FutureOr<CatImage> get(int id) {
    if (id > _bufferPadding * 2 + _bufHead) {
      _bufHead += _bufferPadding;
      _curBuffer.removeRange(0, _bufferPadding);
    }
    if (id + _bufferPadding > _curBuffer.length) {
      _loadMoreItems();
    }
    if (_bufHead + _curBuffer.length > id) {
      return _curBuffer[id - _bufHead];
    }
    final completer = Completer<CatImage>();
    _waitingCompleters[id] = completer;
    if (!_isLoading) {
      _loadMoreItems();
    }
    return completer.future;
  }
}
