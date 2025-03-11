import 'dart:async';

import 'package:catinder/data/model/cat_image.dart';
import 'package:catinder/data/service/api_service.dart';

class CatRepository {
  final List<CatImage> _queue = [];
  bool _isLoading = false;
  final int _minThreshold = 5;
  final int _pageSize = 10;

  final List<Completer<CatImage>> _waitingCompleters = [];

  List<CatImage> get queue => List.unmodifiable(_queue);

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

      _queue.addAll(newItems);

      while (_waitingCompleters.isNotEmpty && _queue.isNotEmpty) {
        final completer = _waitingCompleters.removeAt(0);
        completer.complete(_queue.removeAt(0));
      }
    } catch (e) {
      for (final completer in _waitingCompleters) {
        completer.completeError(e);
      }
      _waitingCompleters.clear();
    } finally {
      _isLoading = false;
    }

    if (_queue.length < _minThreshold) {
      await _loadMoreItems();
    }
  }

  FutureOr<CatImage> top({int offset = 0}) {
    if (_queue.length > offset) {
      return _queue[offset];
    } else {
      final completer = Completer<CatImage>();
      _waitingCompleters.add(completer);

      if (!_isLoading) {
        _loadMoreItems();
      }

      return completer.future;
    }
  }

  void pop() {
    if (_queue.isNotEmpty) {
      if (_queue.length < _minThreshold) {
        _loadMoreItems();
      }
      _queue.removeAt(0);
    }
  }

  int size() {
    return queue.length;
  }
}
