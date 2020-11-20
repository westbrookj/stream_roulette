import 'package:flutter/material.dart';

import 'package:stream_roulette/models/show.dart';


class ShowDropdown extends StatelessWidget {
  ShowDropdown(this.shows, this.currentShow, this.handleChange);

  final Map<String, Show> shows;
  final Show currentShow;
  final handleChange;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: new EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
          child: FloatingActionButton.extended(
            icon: Icon(
              Icons.tv,
              color: Colors.black,
              size: 30.0,
            ),
            backgroundColor: Color(0xffe0e0e0),
            label: DropdownButtonHideUnderline(
                child: DropdownButton(
                  underline: null,
                  value: currentShow.key,
                  items: shows.values.map((show) {
                    return DropdownMenuItem(
                      value: show.key,
                      child: Text(show.display, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (showKey) => handleChange(showKey),
                )
            ),
          ),
        )
    );
  }
}