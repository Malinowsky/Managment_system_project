import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final Widget? child;
  const SplashPage({super.key, this.child});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.child!),result: (route)=>false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome", style: TextStyle(),),
      ),
    );
  }
}
