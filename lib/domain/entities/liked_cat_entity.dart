import 'cat_image_entity.dart';

class LikedCatEntity {
  final CatImageEntity catImage;
  final DateTime likedDate;

  LikedCatEntity({
    required this.catImage,
    required this.likedDate,
  });
}
