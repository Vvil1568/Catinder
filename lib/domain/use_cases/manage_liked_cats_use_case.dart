import '../entities/cat_image_entity.dart';
import '../entities/liked_cat.dart';

class ManageLikedCatsUseCase {
  final List<LikedCat> _allLikedCats = [];
  String? _currentBreedFilter;

  List<LikedCat> getFilteredLikedCats() {
    if (_currentBreedFilter == null || _currentBreedFilter!.isEmpty) {
      return List.unmodifiable(_allLikedCats);
    }
    return List.unmodifiable(_allLikedCats
        .where((lc) => lc.catImage.breed.name == _currentBreedFilter)
        .toList());
  }

  List<String> getUniqueBreeds() {
    final breeds = _allLikedCats
        .map((lc) => lc.catImage.breed.name)
        .where((name) => name.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    breeds.sort();
    return breeds;
  }

  void addCat(CatImageEntity catImage) {
    if (!_allLikedCats.any((lc) => lc.catImage.id == catImage.id)) {
      final likedCat = LikedCat(catImage: catImage, likedDate: DateTime.now());
      _allLikedCats.add(likedCat);
    }
  }

  void removeCat(LikedCat likedCat) {
    _allLikedCats.removeWhere((lc) => lc.catImage.id == likedCat.catImage.id);
  }

  void filterByBreed(String? breedName) {
    _currentBreedFilter = breedName;
  }
}
