import 'package:catinder/data/provider/cat_repository_provider.dart';
import 'package:catinder/domain/entities/cat_image_entity.dart';
import 'package:catinder/presentation/provider/liked_cats_provider.dart';
import 'package:catinder/presentation/view/cat_card_swiper.dart';
import 'package:catinder/presentation/view/liked_cats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catinder/util/particle_utils.dart';
import '../../domain/provider/domain_providers.dart';
import 'custom_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _setupNetworkListener();
  }

  void _setupNetworkListener() {
    final networkService = ref.read(networkServiceProvider);
    networkService.isConnectedStream.listen((isConnected) {
      if (!isConnected && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final likedCatsNotifier = ref.watch(likedCatsProvider);
    final likeCount = likedCatsNotifier.likedCats.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Catinder'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red[400]),
            tooltip: 'Liked Cats',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LikedCatsScreen()),
              );
            },
          ),
        ],
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
          onSwipe: (prevIndex, dir) async {
            if (dir == CardSwiperDirection.right) {
              emojiConfetti(context, '😻');
              if (prevIndex != null) {
                final catRepository = ref.read(catRepositoryProvider);
                final catImageFutureOr = catRepository.get(prevIndex);
                CatImageEntity likedCatImage;
                if (catImageFutureOr is Future<CatImageEntity>) {
                  try {
                    likedCatImage = await catImageFutureOr;
                    ref.read(likedCatsProvider.notifier).addCat(likedCatImage);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not like cat: $e')));
                    }
                  }
                } else {
                  likedCatImage = catImageFutureOr;
                  ref.read(likedCatsProvider.notifier).addCat(likedCatImage);
                }
              }
            } else if (dir == CardSwiperDirection.left ||
                dir == CardSwiperDirection.bottom ||
                dir == CardSwiperDirection.top) {}
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
                  dislikeButton,
                  likeButton,
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
                  dislikeButton,
                  likeButton,
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
