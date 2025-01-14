/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';

class NavigationElement extends StatelessWidget {
  final String routeName;
  final IconData icon;
  final String label;
  final FocusNode focusNode;
  final Function onPressed;
  final bool first;

  NavigationElement(
      {this.routeName,
      this.icon,
      this.label,
      this.focusNode,
      this.onPressed,
      this.first});

  String getRouteName(BuildContext context) {
    ModalRoute route = ModalRoute.of(context);
    String routeName = '';
    if (route != null) {
      routeName = route.settings.name;
    }
    return routeName;
  }

  @override
  Widget build(BuildContext context) {
    String routeName = getRouteName(context);
    if (this.first && routeName == '/') {
      routeName = this.routeName;
    }
    Color textColor;
    if (routeName == this.routeName) {
      if (focusNode.hasFocus) {
        textColor = Theme.of(context).primaryColor;
      } else {
        textColor = Theme.of(context).accentColor;
      }
    } else {
      if (focusNode.hasFocus) {
        textColor = Theme.of(context).primaryColor;
      } else {
        textColor = Colors.white;
      }
    }

    double fontSize = 14.5;
    if (routeName != this.routeName) {
      fontSize = 13;
    }

    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: this.onPressed,
        focusNode: focusNode,
        focusColor: Theme.of(context).accentColor,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 6),
          /*decoration: BoxDecoration(
              color: focusNode.hasFocus
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor),*/
          child: Column(
            children: [
              Icon(this.icon, color: textColor),
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: fontSize),
              )
            ],
          ),
        ),
      ),
    );
  }
}
