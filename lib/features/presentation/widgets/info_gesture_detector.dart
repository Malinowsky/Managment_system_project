import 'package:flutter/material.dart';

class InfoGestureDetector extends StatefulWidget {
  const InfoGestureDetector({super.key, this.controller, this.hintText});

  final TextEditingController? controller;
  final String? hintText;

  @override
  State<InfoGestureDetector> createState() => _InfoGestureDetectorState();
}

class _InfoGestureDetectorState extends State<InfoGestureDetector> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: MediaQuery.of(context).size.width / 9,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black45),
          suffixIcon: GestureDetector(
              onTap: () {
                // setState(() {
                //   _obscureText = !_obscureText;
                // });
              },
              child: Text("")),
        ),
      ),
    );
  }
}
