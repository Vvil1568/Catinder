import 'package:catinder/data/model/cat_image.dart';
import 'package:flutter/material.dart';

import 'detailed_info.dart';

class CatCard extends StatelessWidget {
  final CatImage catImage;

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
                  ),
                ),
              ),
              Text(
                "Breed: ${catImage.breeds[0].name}",
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
