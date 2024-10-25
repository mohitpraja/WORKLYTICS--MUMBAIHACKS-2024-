
import 'package:flutter/material.dart';

class DialogBuilder {
  /// Builds various dialogs with different methods.
  /// * e.g. [showLoadingDialog], [showResultDialog]
  const DialogBuilder(this.context);

  /// Takes [context] as parameter.
  final BuildContext context;



  /// Example result dialog
  Future<void> showResultDialog(String text) => showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(text),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // primary: appColorTimeINMaster,
                  textStyle: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),

              onPressed: () => Navigator.pop(context, true), // passing true
              child: Text('Back'),
            ),
          ],
        );
      }).then((exit) {
    if (exit == null) return;

    if (exit) {
      // user pressed Yes button
    } else {
      // user pressed No button
    }
  });  /// Example result dialog



}