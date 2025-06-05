import '../../data/local/database.dart';
import '../entities/cat_image_entity.dart';
import '../entities/liked_cat_entity.dart';

class ManageLikedCatsUseCase {
  final AppDatabase database;
  late List<LikedCatEntity> _allLikedCats = [];
  String? _currentBreedFilter;

  ManageLikedCatsUseCase(this.database);

  Future<void> init() async {
    await _loadLikedCats();
  }

  Future<void> _loadLikedCats() async {
    _allLikedCats = (await database.getLikedCats())
        .map((e) => LikedCatEntity(catImage: e.catData, likedDate: e.likedDate))
        .toList();
  }

  List<LikedCatEntity> getFilteredLikedCats() {
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

  Future<void> addCat(CatImageEntity catImage) async {
    if (!_allLikedCats.any((lc) => lc.catImage.id == catImage.id)) {
      final likedCat =
          LikedCatEntity(catImage: catImage, likedDate: DateTime.now());
      _allLikedCats.add(likedCat);
      await database.addLikedCat(likedCat);
    }
  }

  Future<void> removeCat(LikedCatEntity likedCat) async {
    _allLikedCats.removeWhere((lc) => lc.catImage.id == likedCat.catImage.id);
    await database.removeLikedCat(likedCat.catImage.id);
  }

  void filterByBreed(String? breedName) {
    _currentBreedFilter = breedName;
  }
}
