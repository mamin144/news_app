import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Api/api_manger.dart';
import '../model/news_model.dart';
import '../model/sources_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  String? selectedSource; // Fix: add selectedSource field

  HomeCubit()
      : super(HomeLoaded(
    sources: [],
    news: [],
    selectedSource: '',
  ));

  // Get news by source
  Future<NewsModel> getNews(String sourceId) async {
    emit(HomeLoading()); // Use HomeLoading instead of undefined NewsLoading
    try {
      var news = await ApiManger().getNewsBySource(sourceId);
      emit(HomeLoaded(
        sources: state is HomeLoaded ? (state as HomeLoaded).sources : [],
        news: news.articles,
        selectedSource: sourceId,
      ));
      return news;
    } catch (e) {
      emit(HomeError(e.toString()));
      rethrow;
    }
  }

  // Get sources by category
  Future<SourcesResponse> getSources(String category) async {
    try {
      emit(HomeLoading()); // Use HomeLoading instead of SourcesLoading
      var sources = await ApiManger().getSources(category);
      emit(HomeLoaded(
        sources: sources.sources,
        news: state is HomeLoaded ? (state as HomeLoaded).news : [],
        selectedSource: sources.sources.isNotEmpty ? sources.sources.first.id : '',
      ));
      return sources;
    } catch (e) {
      emit(HomeError(e.toString()));
      rethrow;
    }
  }

  // Initialize with category
  void init(String category) async {
    try {
      emit(HomeLoading());

      final sourcesResponse = await ApiManger().getSources(category);
      final sources = sourcesResponse.sources;

      if (sources.isEmpty) {
        emit(HomeError("No Sources Found"));
        return;
      }

      selectedSource = sources.first.id;

      final news = await ApiManger().getNewsBySource(selectedSource!);

      emit(HomeLoaded(
        sources: sources,
        news: news.articles,
        selectedSource: selectedSource!,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}