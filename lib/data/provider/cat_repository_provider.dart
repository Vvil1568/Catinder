import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/provider/domain_providers.dart';
import '../repository/cat_repository.dart';
import 'package:catinder/domain/repositories/cat_repository_interface.dart';

final catRepositoryProvider = Provider<CatRepositoryInterface>((ref) {
  final database = ref.watch(databaseProvider);
  final connectivity = Connectivity();
  return CatRepository(database: database, connectivity: connectivity);
});
