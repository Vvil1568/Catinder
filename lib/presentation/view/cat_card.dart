import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/presentation/view/detailed_info.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatCard extends StatelessWidget {
  final CatImageEntity catImage;

  const CatCard({super.key, required this.catImage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BreedDetailsScreen(
                          catImage: catImage,
                        ),
                      ),
                    );
                  },
                  child: RepaintBoundary(
                    key: Key(catImage.id.toString()),
                    child: CachedNetworkImage(
                      imageUrl: catImage.url,
                      cacheKey: catImage.id,
                      useOldImageOnUrlChange: true,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              Text(
                "Breed: ${catImage.breed.name}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
