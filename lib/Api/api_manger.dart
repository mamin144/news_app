import 'dart:convert';

import 'package:http/http.dart' as http;

import '../modules/home/model/news_model.dart';
import '../modules/home/model/sources_model.dart';
import 'api_constant.dart';

class ApiManger {
  Future<SourcesResponse> getSources(String category) async {
    Uri url = Uri.https(
      ApiConstant.baseUrl,
      '/v2/top-headlines/sources',
      {
        'apiKey': ApiConstant.apiKey,
        'category': category,
      },
    );

    final response = await http.get(url);
    final json = jsonDecode(response.body);

    if (json['status'] != 'ok') {
      throw Exception(json['message']);
    }

    return SourcesResponse.fromJson(json);
  }

  Future<NewsModel> getNewsBySource(String sourceId) async {
    Uri url = Uri.https(
      ApiConstant.baseUrl,
      '/v2/everything',
      {
        'apiKey': ApiConstant.apiKey,
        'sources': sourceId,
      },
    );

    final response = await http.get(url);
    final json = jsonDecode(response.body);

    if (json['status'] != 'ok') {
      throw Exception(json['message']);
    }

    return NewsModel.fromJson(json);
  }
}
