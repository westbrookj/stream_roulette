import 'package:flutter/material.dart';

import 'package:stream_roulette/models/show.dart';
import 'package:stream_roulette/components/dropdown_button_below.dart';


class ShowDropdown extends StatelessWidget {
  ShowDropdown(this.shows, this.currentShow, this.handleChange);

  final Map<String, Show> shows;
  final Show currentShow;
  final handleChange;

  @override
  Widget build(BuildContext context) {
    List<Show> sortedShows = shows.values.toList();
    sortedShows.sort((a, b) => a.title.toString().compareTo(b.title.toString()));

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
            label: DropdownButtonBelowHideUnderline(
                child: DropdownButtonBelow(
                  value: currentShow.key,
                  items: sortedShows.map((show) {
                    return DropdownBelowMenuItem(
                      value: show.key,
                      child: Text(show.title, style: TextStyle(color: Colors.black)),
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