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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'temperament': temperament,
      'origin': origin,
      'description': description,
      'life_span': lifeSpan,
      'wikipedia_url': wikipediaUrl,
      'weight': {
        'imperial': weightImperial,
        'metric': weightMetric,
      },
      'child_friendly': childFriendly,
      'dog_friendly': dogFriendly,
      'energy_level': energyLevel,
    };
  }

  factory CatBreedEntity.fromJson(Map<String, dynamic> json) {
    return CatBreedEntity(
      id: json['id'],
      name: json['name'],
      temperament: json['temperament'],
      origin: json['origin'],
      description: json['description'],
      lifeSpan: json['life_span'],
      wikipediaUrl: json['wikipedia_url'],
      weightImperial: json['weight']['imperial'],
      weightMetric: json['weight']['metric'],
      childFriendly: json['child_friendly'],
      dogFriendly: json['dog_friendly'],
      energyLevel: json['energy_level'],
    );
  }
}
