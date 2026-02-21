import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:news_app/core/gen/assets.gen.dart';

import '../../home/model/card_model.dart';

class CategoryCard extends StatelessWidget {

  final CardModel cardModel;

  final  Function(CardModel cardModel) onTap;

  const CategoryCard({
    super.key,
    required this.onTap,
    required this.cardModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isOdd;

    return Bounceable(
      onTap: () {
        onTap(cardModel);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image(image: AssetImage(cardModel.image), fit: BoxFit.cover),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardModel.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      height: 50,
                      // padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: const Text(
                              "View All",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
