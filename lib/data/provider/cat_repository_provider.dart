import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/cat_repository.dart';
import 'package:catinder/domain/repositories/cat_repository_interface.dart';

final catRepositoryProvider = Provider<CatRepositoryInterface>((ref) {
  return CatRepository();
});
