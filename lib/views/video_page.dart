


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app_tabbar/models/videos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class VideoPage extends StatelessWidget {

  final Video video;
  VideoPage(this.video);

  @override
  Widget build(BuildContext context) {
    print(video.key);
    return OrientationBuilder(
      builder: (context, ore){
        if(ore == Orientation.landscape){
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
            SystemUiOverlay.bottom
          ]);

        }
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
            body: Center(
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: video.key,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                  ),
                ),
                // showVideoProgressIndicator: true,
              ),
            ),

          ),
        );

      },
    );
  }
}
