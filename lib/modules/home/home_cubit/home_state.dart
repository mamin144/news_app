import 'package:news_app/modules/home/model/sources_model.dart';

import '../model/news_model.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<SourceModel> sources;
  final List<News> news;
  final String selectedSource;

  HomeLoaded({
    required this.sources,
    required this.news,
    required this.selectedSource,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}