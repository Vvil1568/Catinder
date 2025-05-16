import 'cat_image_entity.dart';

class LikedCat {
  final CatImageEntity catImage;
  final DateTime likedDate;

  LikedCat({
    required this.catImage,
    required this.likedDate,
  });
}
