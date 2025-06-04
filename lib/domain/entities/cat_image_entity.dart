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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'breed': breed.toJson(),
    };
  }

  factory CatImageEntity.fromJson(Map<String, dynamic> json) {
    return CatImageEntity(
      id: json['id'],
      url: json['url'],
      breed: CatBreedEntity.fromJson(json['breed']),
    );
  }
}
