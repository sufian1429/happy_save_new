import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final function;

  PlusButton({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Image.network(
            "https://cdn-icons-png.flaticon.com/128/2719/2719693.png",
            width: 100,
            height: 100,
            fit: BoxFit.fill,
            // color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
