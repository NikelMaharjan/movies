


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constants.dart';

class LoadingUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SizedBox( // isLoad will always be true before data from api comes. check movieservice
      child: SpinKitThreeBounce(
        size: 28,
        color: Colors.grey,
      ),
    );
  }
}
