import 'package:flutter/material.dart';
import 'package:news_app/Api/api_manger.dart';
import 'package:news_app/modules/home/view/url_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/card_model.dart';
import '../model/news_model.dart';
import '../model/sources_model.dart';
import '../widgets/news_card.dart';

class HomeView extends StatefulWidget {
  final String category;

  const HomeView({super.key, required this.category});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CardModel? selectedCardCategory;
  int selectedIndex = 0;
  String? selectedSource;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<SourcesResponse>(
          future: ApiManger().getSources(widget.category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text("No Data", style: TextStyle(color: Colors.black)),
              );
            }

            var sources = snapshot.data!.sources;

            if (sources.isEmpty) {
              return const Center(child: Text("No Data"));
            }

            if (selectedSource == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  selectedSource = sources.first.id;
                });
              });
            }
            return DefaultTabController(
              length: sources.length,
              // animationDuration: Duration(seconds: 2),
              initialIndex: selectedIndex,

              child: TabBar(
                tabAlignment: TabAlignment.start,

                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                    selectedSource = sources[value].id;
                  });
                },

                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),

                // padding: EdgeInsets.zero,
                isScrollable: true,
                tabs: List.generate(sources.length, (index) {
                  return Tab(text: sources[index].name);
                }),
              ),
            );
          },
        ),
        Expanded(
          child: selectedSource == null
              ?  Center(child: CircularProgressIndicator())
              :
          FutureBuilder<NewsModel>(
                  future: ApiManger().getNewsBySource(selectedSource!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    final articles = snapshot.data?.articles ?? [];

                    if (articles.isEmpty) {
                      return const Center(child: Text("No Articles"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: articles.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return NewsCard(article: articles[index],
                        onTap: (){
                          onCardTap( articles[index].url);
                        },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  void onCategoryTap(CardModel cardModel) {
    setState(() {
      selectedCardCategory = cardModel;
    });
  }
  void onCardTap(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsWebView(url: url),
      ),
    );
  }
  // void onCardTap(String url) async {
  //   final Uri uri = Uri.parse(url);
  //
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(
  //       uri,
  //       mode: LaunchMode.externalApplication, // يفتح في المتصفح
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
