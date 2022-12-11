

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app_tabbar/views/home_page.dart';

import 'constants.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  await Hive.openBox('cached');



  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[300]
  ));
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProviderScope(child: Home())));
}

class Home extends StatelessWidget {

  Home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    deviceheight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    devicewidth = MediaQuery.of(context).size.width;

    return GetMaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[300],
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
      home: HomePage(),
    );
  }
}

