import 'package:catinder/presentation/provider/liked_cats_provider.dart';
import 'package:catinder/presentation/view/detailed_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedCatsScreen extends ConsumerWidget {
  const LikedCatsScreen({super.key});

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedCatsNotifier = ref.watch(likedCatsProvider);
    final likedCats = likedCatsNotifier.likedCats;
    final uniqueBreeds = likedCatsNotifier.uniqueBreeds;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        actions: [
          if (uniqueBreeds.isNotEmpty)
            PopupMenuButton<String?>(
              icon: const Icon(Icons.filter_list),
              tooltip: "Filter by breed",
              onSelected: (String? breed) {
                if (breed == 'all_breeds') {
                  ref.read(likedCatsProvider.notifier).filterByBreed(null);
                } else {
                  ref.read(likedCatsProvider.notifier).filterByBreed(breed);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String?>(
                    value: 'all_breeds',
                    child: Text('All Breeds'),
                  ),
                  ...uniqueBreeds.map((String breed) {
                    return PopupMenuItem<String?>(
                      value: breed,
                      child: Text(breed),
                    );
                  }),
                ];
              },
            ),
        ],
      ),
      body: likedCats.isEmpty
          ? const Center(
              child: Text(
                'You have no liked cats right now',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: likedCats.length,
              itemBuilder: (context, index) {
                final likedCat = likedCats[index];
                final catImage = likedCat.catImage;
                final breedName = catImage.breed.name;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.network(
                        catImage.url,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image,
                              size: 40, color: Colors.grey[400]);
                        },
                      ),
                    ),
                    title: Text(breedName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text('Liked on: ${_formatDate(likedCat.likedDate)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                      tooltip: 'Remove from liked',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text("Remove Cat?"),
                                content: Text(
                                    "Are you sure you want to remove this cat from your liked list?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        ref
                                            .read(likedCatsProvider.notifier)
                                            .removeCat(likedCat);
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: Text("Remove",
                                          style: TextStyle(color: Colors.red)))
                                ],
                              );
                            });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BreedDetailsScreen(catImage: catImage),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
