import 'breed.dart';

class CatImage {
  final String id;
  final int width;
  final int height;
  final String url;
  final List<Breed> breeds;

  CatImage({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.breeds,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    return CatImage(
      id: json['id'],
      width: json['width'],
      height: json['height'],
      url: json['url'],
      breeds: (json['breeds'] as List)
          .map((breed) => Breed.fromJson(breed))
          .toList(),
    );
  }
}
