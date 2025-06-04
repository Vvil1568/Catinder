import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catinder/domain/use_cases/manage_liked_cats_use_case.dart';

import '../../data/local/database.dart';
import '../../data/service/network_service.dart';

final manageLikedCatsUseCaseProvider = Provider<ManageLikedCatsUseCase>((ref) {
  final database = ref.watch(databaseProvider);
  return ManageLikedCatsUseCase(database);
});
final networkServiceProvider = Provider((ref) => NetworkService());
final databaseProvider = Provider((ref) => AppDatabase());
