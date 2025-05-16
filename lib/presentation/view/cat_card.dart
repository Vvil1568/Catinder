import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/presentation/view/detailed_info.dart';
import 'package:flutter/material.dart';

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
                  child: Image.network(
                    catImage.url,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey[600]));
                    },
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
