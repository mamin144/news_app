import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/Api/api_manger.dart';
import 'package:news_app/modules/home/news_cubit/news_cubit.dart';
import 'package:news_app/modules/home/view/url_view.dart';

import '../model/card_model.dart';
import '../model/news_model.dart';
import '../sources_cubit/sources_cubit.dart';
import '../widgets/news_card.dart';

class HomeView extends StatefulWidget {
  final String category;

  const HomeView({super.key, required this.category});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  String? selectedSource;
  @override
  void initState() {
    super.initState();
    context.read<SourcesCubit>().getSources(widget.category);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<SourcesCubit, SourcesState>(
          builder: (context, state) {
            if (state is SourcesInitial || state is SourcesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SourcesLoaded) {
              final sources = state.sources.sources;


              if (sources.isEmpty) {
                return const Center(child: Text("No Sources Found"));
              }

              selectedSource ??= sources.first.id;
              context.read<NewsCubit>().getNews(selectedSource!);

              return DefaultTabController(
                length: sources.length,
                initialIndex: selectedIndex < sources.length ? selectedIndex : 0,
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                      selectedSource = sources[value].id;
                    });
                    context.read<NewsCubit>().getNews(selectedSource!);
                  },
                  tabs: sources.map((source) => Tab(text: source.name)).toList(),
                ),
              );
            } else if (state is SourcesError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
        BlocBuilder<NewsCubit, NewsState>(builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NewsError) {
            return const Center(child: Text("Error"));
          }

          if (state is NewsLoaded) {
            final articles = state.news.articles;


            if (articles.isEmpty) {
              return const Center(child: Text("No Data"));
            }
            return Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: articles.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return NewsCard(
                    article: articles[index],
                    onTap: () {
                      onCardTap(articles[index].url);
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },

          /// =================== NEWS ===================
          // Expanded(
          //   child: selectedSource == null
          //       ? const Center(child: CircularProgressIndicator())
          //       : FutureBuilder<NewsModel>(
          //     future:
          //     ApiManger().getNewsBySource(selectedSource!),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState ==
          //           ConnectionState.waiting) {
          //         return const Center(
          //             child: CircularProgressIndicator());
          //       }
          //
          //       if (snapshot.hasError) {
          //         return Center(
          //             child: Text(snapshot.error.toString()));
          //       }
          //
          //       final articles =
          //           snapshot.data?.articles ?? [];
          //
          //       if (articles.isEmpty) {
          //         return const Center(
          //             child: Text("No Articles"));
          //       }
          //
          //       return ListView.separated(
          //         padding: const EdgeInsets.all(16),
          //         itemCount: articles.length,
          //         separatorBuilder: (_, __) =>
          //         const SizedBox(height: 10),
          //         itemBuilder: (context, index) {
          //           return NewsCard(
          //             article: articles[index],
          //             onTap: () {
          //               onCardTap(articles[index].url);
          //             },
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        )
      ],
    );
  }

  void onCardTap(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsWebView(url: url),
      ),
    );
  }
}