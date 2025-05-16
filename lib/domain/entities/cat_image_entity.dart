import 'package:catinder/domain/entities/cat_breed_entity.dart';

class CatImageEntity {
  final String id;
  final String url;
  final CatBreedEntity breed;

  CatImageEntity({
    required this.id,
    required this.url,
    required this.breed,
  });
}
