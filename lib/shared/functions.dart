import 'package:flutter/material.dart';
import 'constants.dart';

InputDecoration textInputDecoration(String hint, String label, Icon icon) {
  return InputDecoration(
    enabledBorder: inputBorder,
    disabledBorder: inputBorder,
    focusedBorder: inputBorder,
    prefixIcon: icon,
    hintText: hint,
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    focusColor: Colors.white,
    hoverColor: Colors.white,
    border: OutlineInputBorder(),
  );
}
