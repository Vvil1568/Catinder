import 'dart:async';

import '../entities/cat_image_entity.dart';

abstract class CatRepositoryInterface {
  FutureOr<CatImageEntity> get(int id);
}
