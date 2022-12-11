import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../connectivity_check.dart';
import '../constants.dart';
import '../models/movie_state.dart';
import '../provider/movie_provider.dart';

class SearchErrorUi extends StatelessWidget {
  final WidgetRef ref;

  SearchErrorUi(this.ref);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceheight * 0.94,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Search using another keyword"),
          // OutlinedButton(
          //     onPressed: () {
          //       ref.read(movieProvider.notifier).getMovie();
          //     },
          //     child: const Text("Refresh"))
        ],
      ),
    );
  }
}
