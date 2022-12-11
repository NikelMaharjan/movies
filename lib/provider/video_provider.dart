



import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../models/videos.dart';
import '../services/video_service.dart';


// we use family when we need to provide something. here movie id when watching the provider

//final videoProvider  = FutureProvider.family((ref, int id) => VideoService.getVideo(id));

//we use future if we dont need to change state like display detail

//we use this instead of future provider to change state... like clicking the button
final videoProvider  = StateNotifierProvider.family<VideoProvider, AsyncValue<List<Video>>, int>((ref, int id) => VideoProvider(AsyncData([]), id));


class VideoProvider extends StateNotifier<AsyncValue<List<Video>>>{
  VideoProvider(super.state, this.id){
    getVideo();
  }
  final int id;


  Future<void> getVideo() async {


    try{
      print("okkk");
      state= AsyncLoading();
      final response = await VideoService.getVideo(id);
      state = AsyncData(response);
    }

    catch (err){
      state = AsyncError(err);

    }

  }

}


