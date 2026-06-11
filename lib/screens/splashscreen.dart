// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:cs_project_1/screens/selectuser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class splashscreen extends StatefulWidget{
const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> with SingleTickerProviderStateMixin {
@override
void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(Duration(seconds:4),() {
       Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => selectUser(),));
    });
  }
  @override
  void dispose()
  {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
Widget build(BuildContext context){
  return const Scaffold(
    backgroundColor:Colors.black,
    body: Center(
      child: Icon(Icons.menu_book_sharp,color:Colors.white,size: 120,),
      // child:Column(
      //   crossAxisAlignment:CrossAxisAlignment.center,
      //   mainAxisAlignment:MainAxisAlignment.center,
      //   children:[
        
      //     //  Image.asset('images/projectimagee.jpg'),
      //     //  const Text('College', 
      //     //  style: TextStyle(
      //     //   color: Colors.white,
      //     //   fontSize: 23,
      //     //  ))
      //      ])
    ),
  );
}
}