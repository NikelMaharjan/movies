import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app_tabbar/common/search_error_ui.dart';
import 'package:movie_app_tabbar/constants.dart';
import 'package:movie_app_tabbar/models/movie_state.dart';
import 'package:movie_app_tabbar/provider/movie_provider.dart';
import 'package:get/get.dart';


import '../api.dart';
import '../widgets/movie_widget.dart';



class HomePage extends StatelessWidget {

  TextEditingController textController = TextEditingController();
  String? text;


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Consumer(
        builder: (context, ref, child) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey[300],
                elevation: 1,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(deviceheight * 0.01 ),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.black,
                      onTap: (index) {

                        switch (index) {
                          case 0:
                            ref.read(movieProvider.notifier).updateMovieByCategory(Api.popular);
                            break;
                          case 1:
                            ref.read(movieProvider.notifier).updateMovieByCategory(Api.topRated);
                            break;
                            case 2:
                            ref.read(movieProvider.notifier).updateMovieByCategory(Api.upcoming);
                        }
                      },
                      tabs: const [
                        Tab(
                          text: 'Popular',
                        ),
                        Tab(
                          text: 'Top Rated',
                        ),
                        Tab(
                          text: 'Upcoming',
                        ),
                      ]),
                ),
              ),
              resizeToAvoidBottomInset: false,
              body: StreamBuilder<ConnectivityResult>(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  return Consumer(
                      builder: (context, ref, child) {
                        return InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: deviceheight * 0.08,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: TextFormField(
                                      controller: textController,
                                      onFieldSubmitted: (val) {
                                        if(val.isEmpty){

                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Search Something"), duration: Duration(seconds: 2),));

                                        }

                                        else{
                                          ref.read(movieProvider.notifier).searchMovie(val);
                                          textController.clear();
                                        }

                                      },
                                      decoration: const InputDecoration(
                                          focusColor: Colors.black,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black)
                                          ),

                                          hintText: "Search",
                                          suffixIcon: Icon(Icons.search),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                      physics: const NeverScrollableScrollPhysics(),
                                      children: [
                                        //MovieWidget(Api.popular),
                                        MovieWidget(snapshot.data),
                                        MovieWidget(snapshot.data),
                                        MovieWidget(snapshot.data),

                                      ]),
                                )

                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
              )

          );
        }
      ),
    );
  }
}