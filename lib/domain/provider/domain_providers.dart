import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catinder/domain/use_cases/manage_liked_cats_use_case.dart';

final manageLikedCatsUseCaseProvider = Provider<ManageLikedCatsUseCase>((ref) {
  return ManageLikedCatsUseCase();
});
