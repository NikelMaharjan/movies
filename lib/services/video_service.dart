



import 'package:dio/dio.dart';

import '../api_exceptions.dart';
import '../models/videos.dart';

class VideoService {

  // static Future<List<Video>> getVideo (int id) async {
  //   final dio = Dio();
  //   try {
  //     final response = await dio.get(
  //         "https://api.themoviedb.org/3/movie/$id/videos", queryParameters: {
  //       'api_key': '2cf12587f0e8dfb033cd9ea15dc8f9bf',
  //     });
  //     final data = response.data["results"];
  //     final videoData = (data as List).map((e) => Video.fromJson(e)).toList();
  //     return videoData;
  //   }
  //
  //
  //   on DioError catch (err) {
  //     throw DioException.fromDioError(err).errorMessage;
  //   }
  // }

// static Future<String> getVideo(int id) async{
//   final dio = Dio();
//   final response = await dio.get('https://api.themoviedb.org/3/movie/$id/videos',
//       queryParameters: {
//         'api_key': '2a0f926961d00c667e191a21c14461f8'
//       }
//   );
//   return response.data['results'][0]['key'];
// }

  static Future<List<Video>> getVideo (int id) async {
    final dio = Dio();
    try {
      final response = await dio.get(
          "https://api.themoviedb.org/3/movie/$id/videos", queryParameters: {
        'api_key': '2cf12587f0e8dfb033cd9ea15dc8f9bf',
      });
      final data = response.data["results"];
      if((data as List).isEmpty){
        return[
          Video(
              key: "",
              name: "No videos",
              id: "")
        ];
      }

      final videoData = (data as List).map((e) => Video.fromJson(e)).toList();
      return videoData;
    }


    on DioError catch (err) {
      throw DioException.fromDioError(err).errorMessage;
    }
  }

}