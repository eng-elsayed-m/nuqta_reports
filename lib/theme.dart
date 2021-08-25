import 'package:flutter/material.dart';

class Them {
  static TextStyle tableHeader = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 12,
  );
  static TextStyle tableCell =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
  static TextStyle pageTitle = TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
            offset: Offset(0.0, 5),
            blurRadius: 4,
            color: Colors.cyanAccent.shade700)
      ]);
  static TextStyle drawerItemText = TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w900,
  );
}
