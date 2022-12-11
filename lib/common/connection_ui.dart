

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../provider/movie_provider.dart';

class ConnectionPage extends StatelessWidget {
  final WidgetRef ref;
  final ConnectivityResult? connects;

  ConnectionPage(this.ref, this.connects);

  @override
  Widget build(BuildContext context) {
    print(ref);
    return Center(
      child: SizedBox(
      height: deviceheight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(connects == ConnectivityResult.none || connects == null
                ? 'No Internet'
                : 'Internet available', style: TextStyle(
                fontSize: 20,
                color: connects == ConnectivityResult.none ||
                    connects == null ? Colors.black : Colors
                    .green),),
            OutlinedButton(onPressed: () {
              ref.read(movieProvider.notifier).getMovie();
              ElevatedButton.styleFrom(backgroundColor: Colors.red);
            }, child: Text('Reload', style: TextStyle(color: Colors.black),))
          ],
        ),
      ),
    );

  }
}
