


import '../api.dart';
import 'movies.dart';

class MovieState {

  final List<Movie> movies;
  final String searchText;
  final int page;
  final String apiPath;
  final bool isLoad;
  final bool isLoadMore;
  final String movieName;
  final List<Movie> cachedMovie;
  final String errorMessage;

  MovieState({required this.movies, required this.searchText, required this.isLoadMore, required this.page, required this.cachedMovie, required this.apiPath, required this.movieName, required this.isLoad, required this.errorMessage});


  //when we call the provider we pass this state as initial value
  MovieState.initState() : movies = [], searchText = '', isLoadMore = false, apiPath = Api.popular, page = 1, movieName = 'Popular Movie', isLoad = false, errorMessage = "", cachedMovie = [];  //initial state


  MovieState copyWith ({List<Movie>? movies, String? searchText, int? page, String? apiPath, String? movieName, bool? isLoad, bool? isLoadMore,String? errorMessage, List<Movie>? cachedMovie} ){
    return MovieState(
        isLoadMore: isLoadMore ?? this.isLoadMore,
        movies: movies ?? this.movies,
        searchText: searchText ?? this.searchText,
        page: page ?? this.page,
        apiPath: apiPath ?? this.apiPath,
        movieName: movieName ?? this.movieName,
        isLoad: isLoad ?? this.isLoad,
        errorMessage: errorMessage ?? this.errorMessage,
        cachedMovie: cachedMovie ?? this.cachedMovie

    );

  }





}