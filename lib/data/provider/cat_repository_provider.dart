import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/cat_repository.dart';

final catRepositoryProvider = Provider<CatRepository>((ref) {
  return CatRepository();
});
