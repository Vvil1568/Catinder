import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/cat_image_entity.dart';

class BreedDetailsScreen extends StatelessWidget {
  final CatImageEntity catImage;

  const BreedDetailsScreen({super.key, required this.catImage});

  @override
  Widget build(BuildContext context) {
    final breed = catImage.breed;

    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Image.network(
                    catImage.url,
                    fit: BoxFit.cover,
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
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          color: Colors.grey[200],
                          child: Center(
                              child: Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey[600])),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  if (breed.origin != null)
                    Text(
                      'Origin: ${breed.origin}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  SizedBox(height: 8),
                  if (breed.temperament != null)
                    Text(
                      'Temperament: ${breed.temperament}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  if (breed.description != null)
                    Text(
                      'Description: ${breed.description}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  Text(
                    'Weight: ${breed.weightImperial} lbs (${breed.weightMetric} kg)',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 8),
                  if (breed.lifeSpan != null)
                    Text(
                      'Life Span: ${breed.lifeSpan} years',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  if (breed.childFriendly != null)
                    Text(
                      'Child Friendly: ${breed.childFriendly}/5',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  if (breed.dogFriendly != null)
                    Text(
                      'Dog Friendly: ${breed.dogFriendly}/5',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  if (breed.energyLevel != null)
                    Text(
                      'Energy Level: ${breed.energyLevel}/5',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 8),
                  if (breed.wikipediaUrl != null)
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(breed.wikipediaUrl!));
                      },
                      child: Text(
                        'Wikipedia: ${breed.wikipediaUrl}',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
