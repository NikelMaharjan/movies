import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_app_tabbar/common/connection_ui.dart';
import 'package:movie_app_tabbar/common/loading_ui.dart';
import 'package:movie_app_tabbar/common/search_error_ui.dart';

import '../provider/movie_provider.dart';
import '../views/detail_page.dart';


class MovieWidget extends StatelessWidget {

  final ConnectivityResult? connects;
  MovieWidget(this.connects);
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) {
          final movieState = ref.watch(movieProvider);

          if (movieState.isLoad) {
            return Center(child: LoadingUI());
          }

          if (movieState.errorMessage.isNotEmpty) {
            if (movieState.errorMessage == 'search not found') {
              return SearchErrorUi(ref);
            }

            else {
              if (movieState.errorMessage == 'No Internet.') {

                if (connects != ConnectivityResult.none && connects != null) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {     //to solve when data wont load automatically
                    ref.read(movieProvider.notifier).getMovie();
                  });
                }
                return ConnectionPage(ref, connects);
              } else {
                return Center(
                    child: Text(movieState.errorMessage));
              }
            }
          }

          return NotificationListener(
              onNotification: (onNotification) {
                if (onNotification is ScrollEndNotification) {
                  final before = onNotification.metrics.extentBefore;
                  final max = onNotification.metrics.maxScrollExtent;
                  if (before == max) {
                    if (connects == ConnectivityResult.wifi || connects == ConnectivityResult.mobile) {
                      ref.read(movieProvider.notifier).loadMore();
                    }
                  }
                }
                return false;
              },
              child:GridView.builder(
                physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: movieState.movies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 2 / 3
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => DetailPage(movieState.movies[index]), transition: Transition.leftToRight);

                      },
                      child: Stack(
                        children: [
                          Hero(
                            tag: movieState.movies[index].id,
                            child: CachedNetworkImage(
                                placeholder: (context, url) =>  Center(child: LoadingUI()),
                                errorWidget: (context, url, error) => Image.asset('assets/images/noimage.jpg', fit: BoxFit.fitHeight,),
                                imageUrl: 'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${movieState.movies[index].poster_path}'),
                          ),
                          Positioned(
                              right: 6,
                              child: Container(
                                color: Colors.grey[300],
                                child: Column(
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow[900],),
                                    Text(movieState.movies[index].vote_average, style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                              ))
                        ],

                      ),
                    );
                  }
              )
          );
        }
    );
  }
}