import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/test/moor.dart';

class LoadingAlert extends StatefulWidget {
  final int n;

  LoadingAlert(this.n, {key}) : super(key: key);

  State<StatefulWidget> createState() => _LoadingAlertState();
}

class _LoadingAlertState extends State<LoadingAlert> {
  int _completed = 0;

  void _updateCompleted() {
    setState(() => _completed++);
  }

  @override
  void initState() {
    super.initState();
    Database()
        .updateData(updateFunc: _updateCompleted)
        .then((value) => Navigator.pop(context, value));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        backgroundColor: Theme.of(context).canvasColor,
        children: [
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  value: _completed / widget.n,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(height: 20),
                Text(
                  "$_completed/${widget.n} Favoriten aktualisiert.\nBitte warten....",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
