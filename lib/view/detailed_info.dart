import 'package:flutter/material.dart';
import 'package:catinder/data/model/cat_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BreedDetailsScreen extends StatelessWidget {
  final CatImage catImage;

  const BreedDetailsScreen({super.key, required this.catImage});

  @override
  Widget build(BuildContext context) {
    final breed = catImage.breeds.isNotEmpty ? catImage.breeds[0] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(breed?.name ?? 'Cat Details'),
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
                  if (breed != null) ...[
                    Text(
                      breed.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Image.network(
                      catImage.url,
                      fit: BoxFit.cover,
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
                      'Weight: ${breed.weight.imperial} lbs (${breed.weight.metric} kg)',
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
                  ] else ...[
                    Text(
                      'No breed information available.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
