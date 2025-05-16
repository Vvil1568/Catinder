import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catinder/data/provider/cat_repository_provider.dart';
import '../../domain/entities/cat_image_entity.dart';
import 'cat_card.dart';

class CatCardSwiper extends ConsumerWidget {
  final CardSwiperController controller;
  final Function(int?, CardSwiperDirection) onSwipe;

  const CatCardSwiper(
      {super.key, required this.controller, required this.onSwipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catRepository = ref.watch(catRepositoryProvider);
    return Expanded(
      child: CardSwiper(
        duration: const Duration(milliseconds: 500),
        controller: controller,
        cardsCount: 0x7FFFFFFFFFFFFFFF,
        numberOfCardsDisplayed: 3,
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
          FutureOr<CatImageEntity> catImageFutureOr = catRepository.get(index);
          if (catImageFutureOr is CatImageEntity) {
            return CatCard(catImage: catImageFutureOr);
          } else {
            return FutureBuilder<CatImageEntity>(
              future: catImageFutureOr,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('Network Error'),
                            content: Text(
                                'Failed to load cat image. Please check your connection.\nDetails: ${snapshot.error}'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text('Error loading cat!',
                          style: TextStyle(color: Colors.red)),
                      Text('Swipe to try next.',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ));
                } else if (snapshot.hasData) {
                  final catImage = snapshot.data!;
                  return CatCard(catImage: catImage);
                } else {
                  return Center(child: Text('No cat data.'));
                }
              },
            );
          }
        },
        onSwipe: (prev, cur, dir) {
          onSwipe.call(prev, dir);
          return true;
        },
      ),
    );
  }
}
