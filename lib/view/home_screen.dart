import 'package:catinder/view/cat_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../util/particle_utils.dart';
import 'custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var likeCount = 0;
  final CardSwiperController controller = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Catinder'),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        Widget likeCounter = Text(
          "Cats liked: $likeCount",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark),
        );
        Widget cardSwiper = CatCardSwiper(
          controller: controller,
          onSwipe: (dir) {
            if (dir == CardSwiperDirection.right) {
              setState(() {
                emojiConfetti(context, '😻');
                likeCount++;
              });
            }
          },
        );
        Widget likeButton = Flexible(
          child: CustomButton(
            icon: Icons.favorite,
            onPressed: () {
              controller.swipe(CardSwiperDirection.right);
            },
            emoji: '😻',
            spawnParticles: false,
          ),
        );
        Widget dislikeButton = Flexible(
          child: CustomButton(
            icon: Icons.heart_broken,
            onPressed: () {
              controller.swipe(CardSwiperDirection.bottom);
            },
            emoji: '😿',
          ),
        );
        if (constraints.maxWidth >= 600) {
          return Flex(
            direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  likeCounter,
                  likeButton,
                  dislikeButton,
                ],
              ),
              cardSwiper,
            ],
          );
        } else {
          return Flex(
            direction: Axis.vertical,
            children: [
              likeCounter,
              cardSwiper,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  likeButton,
                  dislikeButton,
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          );
        }
      }),
    );
  }
}
