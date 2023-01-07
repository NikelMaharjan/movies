


import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../api.dart';
import '../api_exceptions.dart';
import '../models/movies.dart';

class MovieService{


  static Future<List<Movie>> getMovieByCategory({required String apiPath, required int page}) async {
    final dio = Dio();

    try {
      if (apiPath == Api.popular) { //we are caching popular only.
        final cachedResponse = await dio.get(apiPath, queryParameters: {
          'api_key': '2cf12587f0e8dfb033cd9ea15dc8f9bf',
          'page': 1
        });
        final data = jsonEncode(cachedResponse.data['results']); //to put in box we need to encode
        final box = Hive.box('cached');
        box.put('popular', data);
      }

      final response = await dio.get(apiPath, queryParameters: {
        'api_key': '2cf12587f0e8dfb033cd9ea15dc8f9bf',
        'page': page
      });

      final data = response.data['results'];
      final movieData = (data as List).map((e) => Movie.fromJson(e)).toList();
      return movieData;
    }

    on DioError catch (err) {
      if (apiPath == Api.popular) {
        final box = Hive.box('cached');
        if (box.isNotEmpty) {
          final data = box.get('popular');
          final movieData = (jsonDecode(data)  as List).map((e) => Movie.fromJson(e)).toList();
          return movieData;
        }
      }

      throw DioException.fromDioError(err).errorMessage;


    }
  }

  static Future<List<Movie>> searchMovie({required String apiPath, required int page, required String searchText}) async{

    final dio = Dio();

    try{
      final response = await dio.get(apiPath,queryParameters: {
        'api_key' : '2cf12587f0e8dfb033cd9ea15dc8f9bf',
        'page': page,
        'query': searchText
      });

      final data = (response.data['results'] as List);


      if(data.isEmpty){          //need to catch in provider
        throw "search not found";

      }

      else{

        final movieData = (data).map((e) => Movie.fromJson(e)).toList();
        return movieData;

      }

    }

    on DioError catch (err) {
      throw DioException.fromDioError(err).errorMessage;   //errorMessage will hold error.. need to catch in provider
    }
  }

  static Future<List<Movie>> getMovieByRecommendations(int id) async{

    final dio = Dio();


    try{
      final response = await dio.get("https://api.themoviedb.org/3/movie/$id/recommendations",queryParameters: {
        'api_key' : '2cf12587f0e8dfb033cd9ea15dc8f9bf',
      });

      final data = response.data['results'];

      if((data as List).isEmpty){
        return [
          Movie(
              backdrop_path: '',
              id: 0,
              title: "No Recommendations ",
              release_date: "",
              overview: "",
              vote_average: "",
              popularity: "",
              poster_path: "")
        ];
      }

      final movieData = (data as List).map((e) => Movie.fromJson(e)).toList();
      return movieData;
    }

    on DioError catch (err) {
      throw DioException.fromDioError(err).errorMessage;
    }
  }





}