import 'package:flutter/material.dart';
import 'package:news_app/Api/api_manger.dart';

import '../model/news_model.dart';
import '../model/sources_model.dart';
import '../widgets/news_card.dart';

class HomeView extends StatefulWidget {
  final String category;

  const HomeView({super.key, required this.category});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {

  TabController? _tabController;
  String? selectedSource;

  late Future<SourcesResponse> _sourcesFuture;

  @override
  void initState() {
    super.initState();
    _sourcesFuture = ApiManger().getSources(widget.category);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// ================= SOURCES =================
        FutureBuilder<SourcesResponse>(
          future: _sourcesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(snapshot.error.toString()),
              );
            }

            final sources = snapshot.data?.sources ?? [];

            if (sources.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No Sources Found"),
              );
            }

            /// Initialize TabController once
            if (_tabController == null) {
              _tabController = TabController(
                initialIndex: 0,
                length: sources.length,
                vsync: this,
              );

              selectedSource = sources.first.id;

              _tabController!.addListener(() {
                if (!_tabController!.indexIsChanging) return;

                setState(() {
                  selectedSource =
                      sources[_tabController!.index].id;
                });
              });
            }

            return TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
              ),
              tabs: sources
                  .map((source) => Tab(text: source.name))
                  .toList(),
            );
          },
        ),

        /// ================= NEWS =================
        Expanded(
          child: selectedSource == null
              ? const Center(child: Text("Select a source"))
              : FutureBuilder<NewsModel>(
            future:
            ApiManger().getNewsBySource(selectedSource!),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              final articles =
                  snapshot.data?.articles ?? [];

              if (articles.isEmpty) {
                return const Center(
                    child: Text("No Articles"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: articles.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return NewsCard(
                    article: articles[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}