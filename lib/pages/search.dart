import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/drawer.dart';
import 'package:unoffical_aod_app/widgets/search.dart';

class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SearchResultWidget()
    );
  }
}