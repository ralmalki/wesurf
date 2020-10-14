import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 5.0),
      color: Colors.transparent,
      child: Container(
        height: 50.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: const Offset(0.0, 2.0),
              blurRadius: 5.0,
              spreadRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
              borderSide: BorderSide(style: BorderStyle.none, width: 0),
            ),
            hintText: 'Search here',
            //contentPadding: EdgeInsets.only(left: 50.0),
            prefixIcon: Icon(
              TablerIcons.search,
              color: Colors.black,
            ),
            filled: true,
            fillColor: Color(0xFFF2F2F7),
          ),
        ),
      ),
    );
  }
}
