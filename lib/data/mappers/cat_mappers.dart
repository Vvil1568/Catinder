import 'package:catinder/data/model/breed.dart';
import 'package:catinder/data/model/cat_image.dart';
import 'package:catinder/domain/entities/cat_breed_entity.dart';
import 'package:catinder/domain/entities/cat_image_entity.dart';

class BreedMapper {
  static CatBreedEntity fromDto(Breed breedDto) {
    return CatBreedEntity(
      id: breedDto.id,
      name: breedDto.name,
      temperament: breedDto.temperament,
      origin: breedDto.origin,
      description: breedDto.description,
      lifeSpan: breedDto.lifeSpan,
      wikipediaUrl: breedDto.wikipediaUrl,
      weightImperial: breedDto.weight.imperial,
      weightMetric: breedDto.weight.metric,
      childFriendly: breedDto.childFriendly,
      dogFriendly: breedDto.dogFriendly,
      energyLevel: breedDto.energyLevel,
    );
  }
}

class CatImageMapper {
  static CatImageEntity fromDto(CatImage catImageDto) {
    if (catImageDto.breeds.isEmpty) {
      throw Exception('CatImage DTO has no breeds, but one is expected.');
    }
    final firstBreedDto = catImageDto.breeds[0];

    return CatImageEntity(
      id: catImageDto.id,
      url: catImageDto.url,
      breed: BreedMapper.fromDto(firstBreedDto),
    );
  }
}
