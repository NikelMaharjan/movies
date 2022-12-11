


import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie_state.dart';
import '../provider/movie_provider.dart';


class ErrorUi extends StatelessWidget {

  MovieState movieState;
  final ref;

  ErrorUi(this.movieState, this.ref);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: deviceheight * 0.94,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(movieState.errorMessage, style: TextStyle(fontSize: 22),),
          OutlinedButton(onPressed: (){ref.refresh(movieProvider);}, child: Text("Retry"))
        ],
      ),
    );
  }
}
