import 'package:catinder/data/local/database.dart';
import 'package:catinder/domain/entities/cat_breed_entity.dart';
import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/domain/entities/liked_cat_entity.dart';
import 'package:catinder/domain/use_cases/manage_liked_cats_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppDatabase extends Mock implements AppDatabase {}
class FakeLikedCatEntity extends Fake implements LikedCatEntity {}

void main() {
  late MockAppDatabase mockDatabase;
  late ManageLikedCatsUseCase useCase;
  final testCat = CatImageEntity(
    id: 'test1',
    url: 'https://example.com/cat.jpg',
    breed: CatBreedEntity(id: 'beng', name: 'Bengal', weightImperial: '5-7', weightMetric: '3-5'),
  );

  setUpAll(() {
    registerFallbackValue(FakeLikedCatEntity());
  });

  setUp(() {
    mockDatabase = MockAppDatabase();

    when(() => mockDatabase.addLikedCat(any()))
        .thenAnswer((_) async => Future.value());

    when(() => mockDatabase.removeLikedCat(any()))
        .thenAnswer((_) async => Future.value());

    when(() => mockDatabase.getLikedCats())
        .thenAnswer((_) async => []);

    useCase = ManageLikedCatsUseCase(mockDatabase);
  });

  test('Add cat should save to database', () async {
    await useCase.addCat(testCat);
    verify(() => mockDatabase.addLikedCat(any(that: isA<LikedCatEntity>()))).called(1);
  });

  test('Remove cat should delete from database', () async {
    final likedCat = LikedCatEntity(catImage: testCat, likedDate: DateTime.now());
    await useCase.removeCat(likedCat);
    verify(() => mockDatabase.removeLikedCat(testCat.id)).called(1);
  });

  test('Load liked cats on initialization', () async {
    final likedCat = LikedCat(
      id: testCat.id,
      catData: testCat,
      likedDate: DateTime.now(),
    );

    final likedCatEntity = LikedCatEntity(
      catImage: testCat,
      likedDate: DateTime.now(),
    );

    when(() => mockDatabase.getLikedCats())
        .thenAnswer((_) async => [likedCat]);

    final useCase = ManageLikedCatsUseCase(mockDatabase);
    await useCase.init();

    final likedCatRes = useCase.getFilteredLikedCats().first;
    expect(likedCatRes.catImage, likedCatEntity.catImage);
    expect(likedCatRes.likedDate, likedCatEntity.likedDate);
    verify(() => mockDatabase.getLikedCats()).called(1);
  });
}