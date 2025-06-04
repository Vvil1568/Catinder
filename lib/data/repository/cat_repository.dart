import 'dart:async';

import 'package:catinder/data/model/cat_image.dart';
import 'package:catinder/data/service/api_service.dart';
import 'package:catinder/domain/repositories/cat_repository_interface.dart';
import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/data/mappers/cat_mappers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import '../local/database.dart';

class CatRepository implements CatRepositoryInterface {
  final AppDatabase database;
  final Connectivity connectivity;
  bool _isOnline = true;

  final List<CatImageEntity> _curBuffer = [];
  int _bufHead = 0;
  bool _isLoading = false;
  final int _bufferPadding = 5;
  final int _pageSize = 10;

  final Map<int, Completer<CatImageEntity>> _waitingCompleters = {};

  bool isInitialized = false;
  final Completer<bool> initialized = Completer();

  CatRepository({required this.database, required this.connectivity}) {
    _initNetworkListener();
    _init();
  }

  void _initNetworkListener() {
    connectivity.onConnectivityChanged.listen((result) {
      _isOnline = !result.contains(ConnectivityResult.none);
      if (_isOnline && _curBuffer.isEmpty) {
        _loadMoreItems();
      }
    });
  }

  Future<void> _init() async {
    final connectivityResult = await connectivity.checkConnectivity();
    _isOnline = !connectivityResult.contains(ConnectivityResult.none);

    if (_isOnline) {
      await _loadMoreItems();
    } else {
      await _loadCachedItems();
    }
    initialized.complete(true);
    isInitialized = true;
  }

  Future<void> _loadCachedItems() async {
    try {
      final cachedCats = await database.getCachedCats();
      _curBuffer.addAll(cachedCats);
    } catch (e) {
      debugPrint('Error loading cached cats: $e');
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    _isLoading = true;

    try {
      if (!isInitialized) {
        await initialized.future;
      }

      if (!_isOnline) {
        await _loadCachedItems();
      } else {
        final List<CatImage> newItemsDto =
            await getCatInfo(pageSize: _pageSize);
        _curBuffer.addAll(
            newItemsDto.map((entity) => CatImageMapper.fromDto(entity)));

        for (final catDto in newItemsDto) {
          try {
            final entity = CatImageMapper.fromDto(catDto);
            database.cacheCat(entity);
          } catch (e) {
            debugPrint('Error caching cat: $e');
          }
        }
      }

      final List<int> keysToProcess = _waitingCompleters.keys.toList();
      for (final key in keysToProcess) {
        if (_waitingCompleters.containsKey(key)) {
          if (key >= _bufHead && key < (_bufHead + _curBuffer.length)) {
            final completer = _waitingCompleters[key]!;
            if (!completer.isCompleted) {
              try {
                final entity = _curBuffer[key - _bufHead];
                completer.complete(entity);
              } catch (e) {
                completer.completeError(e);
              }
            }
            _waitingCompleters.remove(key);
          }
        }
      }

      if (_waitingCompleters.isNotEmpty) {
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
        return _curBuffer[id - _bufHead];
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
