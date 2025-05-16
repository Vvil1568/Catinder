import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catinder/domain/provider/domain_providers.dart';

import 'package:catinder/presentation/notifier/liked_cats_notifier.dart';

final likedCatsProvider = ChangeNotifierProvider<LikedCatsNotifier>((ref) {
  final manageLikedCatsUseCase = ref.watch(manageLikedCatsUseCaseProvider);
  return LikedCatsNotifier(manageLikedCatsUseCase);
});
