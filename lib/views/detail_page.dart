




import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:movie_app_tabbar/common/loading_ui.dart';
import 'package:movie_app_tabbar/provider/video_provider.dart';
import 'package:movie_app_tabbar/views/video_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';
import '../models/movies.dart';
import '../provider/movie_provider.dart';

class DetailPage extends StatelessWidget {

  final Movie movie;
  DetailPage(this.movie);


  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, ore){
        return WillPopScope(   //back button
          onWillPop: () async {
            if(ore == Orientation.landscape){//if screen is in landscape mode, it will first change to portrait mode
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                SystemUiOverlay.top
              ]);
              return false;
            }
            else {
              return true;  //can only do back in portrait mode
            }
          },

          child: Scaffold(
              body: Consumer(   // we wrap consumer from here to show video in full screen from detail page itself. if not, then we can wrap where needed only like recommendation section, video section
                builder: (context, ref, child){
                  final videoData = ref.watch(videoProvider(movie.id));
                  final recommendedMovie = ref.watch(recommendationProvider(movie.id));
                  if (ore == Orientation.landscape ) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                      SystemUiOverlay.bottom
                    ]);
                    return Container(
                      child: videoData.when(
                          data: (data){
                            return YoutubePlayer(
                              controller: YoutubePlayerController(
                                initialVideoId: data[0].key,
                                flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                ),
                              ),
                              // showVideoProgressIndicator: true,
                            );
                          },
                          error: (err, stack) => Center(child: Text('$err'),),
                          loading: () =>  Center(child: LoadingUI(),)),

                    );
                  }
                  else{
                    return SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                movieTitle(),


                                movieOverview(),


                                ExpansionTile(
                                  initiallyExpanded: true,
                                  collapsedTextColor: Colors.black,
                                  textColor: Colors.black,
                                  iconColor: Colors.black,
                                  title: const Text("Recommendation"), children: [
                                  recommendMovie(recommendedMovie, ref),

                                ],),


                                
                                ExpansionTile(
                                  collapsedTextColor: Colors.black,
                                  textColor: Colors.black,
                                  iconColor: Colors.black,

                                  title: const Text("Videos"), children: [

                                  videoData.when(
                                      data: (data){
                                        return  data[0].key.isEmpty ? Text(data[0].name) :  ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: data.length,
                                            itemBuilder: (context, index){
                                              return Card(
                                                color: Colors.grey[350],
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        Get.to(() => VideoPage(data[index]), transition: Transition.leftToRight);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(12.0),
                                                              child: Text(data[index].name),
                                                            ),
                                                          ),
                                                          const Icon(Icons.navigate_next),
                                                        ],
                                                      ),
                                                    ),
                                                    // YoutubePlayer(
                                                    //   controller: YoutubePlayerController(
                                                    //     initialVideoId: data[index].key,
                                                    //     flags: const YoutubePlayerFlags(
                                                    //       autoPlay: false,
                                                    //     ),
                                                    //   ),
                                                    //   // showVideoProgressIndicator: true,
                                                    // ),

                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      error: (err, stack) => SizedBox(
                                          height: deviceheight*0.2,
                                          child: Center(child: Column(
                                            children: [
                                              Text("$err"),
                                              OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                      foregroundColor: Colors.black
                                                  ),
                                                  onPressed: (){ref.refresh(videoProvider(movie.id));}, child: const Text("Retry"))
                                            ],
                                          ),)),
                                      loading: () => SizedBox(
                                        // height: deviceheight*0.08,
                                          child:  Center(child: LoadingUI())))

                                ],),



                              ], )
                        ),
                      ),
                    );}


                },

              )),
        );
      },

    );
  }

  Widget recommendMovie(AsyncValue<List<Movie>> recommendedMovie, WidgetRef ref) {
    return recommendedMovie.when(
        data: (data){
          return  data[0].id == 0 ? Text(data[0].title,) :  SizedBox(
            height: deviceheight*0.192,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Get.to(() => DetailPage(data[index]), transition: Transition.leftToRight, preventDuplicates: false);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Stack(
                              children:[ Hero(
                                tag: data[index].title,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),

                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => SizedBox(
                                        height: deviceheight*0.1787,
                                        child:  Center(child: LoadingUI())),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/noimage.jpg', height: deviceheight*0.1787, fit: BoxFit.fitHeight,),
                                    imageUrl: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/${data[index].poster_path}" , width: 100,),
                                ),),

                                Positioned(
                                    right: 6,
                                    child: Container(
                                      width: 20,
                                      color: Colors.grey[300],
                                      child: Column(
                                        children: [
                                          Icon(Icons.star, color: Colors.yellow[900], size: 12,),
                                          Text(data[index].vote_average.substring(0,3), style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12

                                          ),)
                                        ],
                                      ),
                                    ))
                              ] ),
                        ),
                      ),
                    ],
                  );
                }),
          );
        },
        error: (err, stack) => SizedBox(
            height: deviceheight*0.192,
            child: Center(child: Column(
              children: [
                Text(err as String),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black
                    ),
                    onPressed: (){ref.refresh(recommendationProvider(movie.id));}, child: const Text("Refresh"))
              ],
            ),)),
        loading: () => SizedBox(
            height: deviceheight*0.192,
            child:  Center(child: LoadingUI(),)));
  }


  Widget homeIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("You may also like", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),),
          //
          // InkWell(
          //     onTap: (){
          //       Get.offAll(HomePage(), transition: Transition.leftToRight);
          //     },
          //     child: const Icon(Icons.home)),
        ],
      ),
    );
  }

  Widget movieOverview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 22),
      child: Card(
        color: Colors.grey[350],
        child: SizedBox(
            height: deviceheight*0.32,
            child: Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.overview, style: const TextStyle(fontSize: 18),),
            ))),
      ),
    );
  }

  Widget movieTitle() {
    return SizedBox(
      height: deviceheight*0.30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 180,
            child: Hero(
                tag: movie.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => LoadingUI(),

                    errorWidget: (context, url, error) => Image.asset('assets/images/noimage.jpg', fit: BoxFit.fitWidth,),
                      imageUrl: 'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${movie.backdrop_path}', fit: BoxFit.fitWidth,),
                )),
          ),
          Expanded(
            child: Card(
              color: Colors.grey[350],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: deviceheight*0.18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(movie.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.calendar, size: 18, color: Colors.brown,),
                          const SizedBox(width: 14,),
                          Text(movie.release_date, style: const TextStyle(fontSize: 14,),),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.yellow[900],),
                          Text(movie.vote_average, style: const TextStyle(fontSize: 14,),),
                          const SizedBox(width: 28,),
                          Icon(Icons.stacked_line_chart, size: 20, color: Colors.yellow[900],),
                          Text(movie.popularity, style: const TextStyle(fontSize: 14,),),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
