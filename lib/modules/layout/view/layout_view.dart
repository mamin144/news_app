import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/Api/api_manger.dart';
import 'package:news_app/core/gen/assets.gen.dart';
import '../../home/model/card_model.dart';
import '../../home/news_cubit/news_cubit.dart';
import '../../home/sources_cubit/sources_cubit.dart';
import '../../home/view/home_View.dart';
import '../widgets/category_card.dart';
import '../widgets/home_drawer.dart';

class category extends StatefulWidget {
  const category({super.key});

  @override
  State<category> createState() => _categoryState();
}

class _categoryState extends State<category> {
  CardModel? selectedCardCategory;

  @override
  Widget build(BuildContext context) {
    List<CardModel> categories = [
      CardModel(
        text: "General",
        image: Assets.images.generalDark.path,
        id: 'general',
      ),
      CardModel(
        text: "Business",
        image: Assets.images.busniessDark.path,
        id: 'business',
      ),
      CardModel(
        text: "Entertainment",
        image: Assets.images.entertainmentDark.path,
        id: 'entertainment',
      ),
      CardModel(
        text: "Health",
        image: Assets.images.helthDark.path,
        id: 'health',
      ),
      CardModel(
        text: "Sports",
        image: Assets.images.sportDark.path,
        id: 'sports',
      ),
      CardModel(
        text: "Technology",
        image: Assets.images.technologyDark.path,
        id: 'technology',
      ),
      CardModel(
        text: "Science",
        image: Assets.images.scienceDark.path,
        id: 'science',
      ),
    ];

    bool isEven;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsCubit(),
        ),
        BlocProvider(
          create: (context) =>
          SourcesCubit()..getSources(selectedCardCategory!.id),
        ),
      ], child: Scaffold(
        backgroundColor: Colors.white,
        drawer: HomeDrawer(goToHome: _goToHome),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,

          title: Text(
            selectedCardCategory?.id ?? 'Home',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Assets.icons.search.svg(
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
        body: selectedCardCategory == null
            ? Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning\nHere is Some News For You",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Directionality(
                          textDirection: index.isEven
                              ? TextDirection.rtl
                              : TextDirection.ltr,

                          child: CategoryCard(
                            cardModel: CardModel(
                              text: categories[index].text,
                              image: categories[index].image,
                              id: categories[index].id,
                            ),
                            onTap: _onCategoryTap,
                          ),
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),

                        itemCount: categories.length,
                      ),
                    ),
                  ],
                ),
              )
            :  HomeView(category: selectedCardCategory!.id),


      ),
    );
  }

  void _onCategoryTap(CardModel cardModel) {
    setState(() {
      selectedCardCategory = cardModel;
    });
  }

  void _goToHome() {
    setState(() {
      selectedCardCategory = null;
      Navigator.pop(context);
    });
  }
}
