import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../api.dart';
import '../models/movie_state.dart';
import '../models/movies.dart';
import '../services/movie_service.dart';




// final movieProvider = StateNotifierProvider.family<MovieProvider, MovieState, String>((ref, api) => MovieProvider(MovieState.initState(), api));

final movieProvider = StateNotifierProvider<MovieProvider, MovieState>((ref) => MovieProvider(MovieState.initState()));



final recommendationProvider = FutureProvider.family((ref, int id) => MovieService.getMovieByRecommendations(id));


class MovieProvider extends StateNotifier<MovieState>{

  MovieProvider(super.state){
    getMovie();
  }

 // final String apiPath;





  Future<void> getMovie() async{
    try {
      if (state.searchText.isEmpty) {
        state = state.copyWith(isLoad: state.isLoadMore ? false : true);
        final response = await MovieService.getMovieByCategory(apiPath: state.apiPath, page: state.page);
        state = state.copyWith(
          isLoad: false,
          movies: [...state.movies, ...response],
          errorMessage: '',
        );
      }
      else {

        print(state.apiPath);

        state = state.copyWith(isLoad: state.isLoadMore ? false : true);
        final response = await MovieService.searchMovie(apiPath: state.apiPath, page: state.page, searchText: state.searchText);
        state = state.copyWith(
          isLoad: false,
          movies: [...state.movies, ...response],
          errorMessage: '',
        );
      }

    }
     catch (err) {

      state = state.copyWith(
        errorMessage: err as String,
        isLoad: false,
      );

    }

  }


  void searchMovie(String searchText){
    state = state.copyWith(
        movies: [],
        searchText: searchText,
        page: 1,
        apiPath: Api.search
    );
    getMovie();

  }


  void updateMovieByCategory(String apiPath){
    state = state.copyWith(
        movies: [],
        page: 1,
        apiPath: apiPath,
        searchText: ''
    );
    getMovie();

  }





  void loadMore(){
    state = state.copyWith(
      page:  state.page + 1,
      isLoadMore:  true
    );
    getMovie();

  }



}

