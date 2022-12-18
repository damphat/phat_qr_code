import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
void TODO(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.yellow,
      content: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}
