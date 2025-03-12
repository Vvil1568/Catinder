import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/cat_image.dart';
import '../data/provider/cat_repository_provider.dart';
import 'cat_card.dart';

class CatCardSwiper extends ConsumerWidget {
  final CardSwiperController controller;
  final Function(CardSwiperDirection) onSwipe;

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
          FutureOr<CatImage> catImage = catRepository.get(index);
          if (catImage is CatImage) {
            return CatCard(catImage: catImage);
          } else {
            return FutureBuilder<CatImage>(
              future: catImage,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final catImage = snapshot.data!;
                  return CatCard(catImage: catImage);
                }
              },
            );
          }
        },
        onSwipe: (prev, cur, dir) {
          onSwipe.call(dir);
          return true;
        },
      ),
    );
  }
}
