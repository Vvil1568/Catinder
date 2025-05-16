import 'package:flutter/foundation.dart';
import 'package:catinder/domain/entities/liked_cat.dart';
import 'package:catinder/domain/use_cases/manage_liked_cats_use_case.dart';

import '../../domain/entities/cat_image_entity.dart';

class LikedCatsNotifier extends ChangeNotifier {
  final ManageLikedCatsUseCase _manageLikedCatsUseCase;

  LikedCatsNotifier(this._manageLikedCatsUseCase);

  List<LikedCat> get likedCats =>
      _manageLikedCatsUseCase.getFilteredLikedCats();

  List<String> get uniqueBreeds => _manageLikedCatsUseCase.getUniqueBreeds();

  void addCat(CatImageEntity catImage) {
    _manageLikedCatsUseCase.addCat(catImage);
    notifyListeners();
  }

  void removeCat(LikedCat likedCat) {
    _manageLikedCatsUseCase.removeCat(likedCat);
    notifyListeners();
  }

  void filterByBreed(String? breedName) {
    _manageLikedCatsUseCase.filterByBreed(breedName);
    notifyListeners();
  }
}
