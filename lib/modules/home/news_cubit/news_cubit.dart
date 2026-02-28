import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:news_app/Api/api_manger.dart';
import 'package:news_app/modules/home/model/news_model.dart';

import '../view/url_view.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());


  Future<NewsModel> getNews(String sourceId ) async {
    emit(NewsLoading());
    try {
     var news = await ApiManger().getNewsBySource(sourceId);
      emit(NewsLoaded(
        news
      ));
      return news;
    } catch (e) {
      emit(NewsError());
      rethrow;

    }
  }

  static void onCardTap(String url, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsWebView(url: url),
      ),
    );
  }

}
