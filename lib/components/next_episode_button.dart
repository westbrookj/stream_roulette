import 'package:flutter/material.dart';

class NextEpisodeButton extends StatelessWidget {
  NextEpisodeButton(this.onPressed);

  final onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: new EdgeInsets.only(bottom: 35.0),
        child: RaisedButton(
          onPressed: onPressed,
          child: const Text('Pick Next Episode', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}