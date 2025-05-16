class CatBreedEntity {
  final String id;
  final String name;
  final String? temperament;
  final String? origin;
  final String? description;
  final String? lifeSpan;
  final String? wikipediaUrl;
  final String weightImperial;
  final String weightMetric;
  final int? childFriendly;
  final int? dogFriendly;
  final int? energyLevel;

  CatBreedEntity({
    required this.id,
    required this.name,
    this.temperament,
    this.origin,
    this.description,
    this.lifeSpan,
    this.wikipediaUrl,
    required this.weightImperial,
    required this.weightMetric,
    this.childFriendly,
    this.dogFriendly,
    this.energyLevel,
  });
}
