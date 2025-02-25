import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ProdImageView extends StatelessWidget {
  final List<String> imagesList;
  final ValueNotifier<int> _imageIndex = ValueNotifier<int>(0);

  ProdImageView({super.key, required this.imagesList});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Hero(
            tag: imagesList[0],
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
              child: SizedBox(
                height: size.height * 0.6,
                width: size.width - 50,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    _imageIndex.value = index;
                  },
                  children: [
                    for (int i = 0; i < imagesList.length; i++)
                      CachedNetworkImage(
                        cacheKey: imagesList[i],
                        imageUrl: imagesList[i],
                        maxHeightDiskCache: (size.height * 2).toInt(),
                        maxWidthDiskCache: (size.width * 2).toInt(),
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 35,
          bottom: 30,
          child: ValueListenableBuilder<int>(
            valueListenable: _imageIndex,
            builder: (context, value, child) {
              return Row(
                children: [
                  for (int i = 0; i < imagesList.length; i++)
                    AnimatedContainer(
                      width: (value == i) ? 30 : 15,
                      height: 4,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: (value == i)
                            ? kOffBlack
                            : kSnowFlakeWhite,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
