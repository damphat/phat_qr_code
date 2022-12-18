// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:phat_qr_code/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String data = "http://google.com";
  var controller = TextEditingController();
  var screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();
    controller.text = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildQRText(),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: buildQrImage(),
            ),
            SizedBox(
              height: 32,
            ),
            buildBottomBar(context)
          ],
        ),
      ),
    );
  }

  void saveDesktop(BuildContext context) async {
    try {
      var fileName = data.replaceAll(RegExp(r'[:/\#?=]'), '_');
      fileName = fileName.substring(0, min(fileName.length, 40));
      var p = await FilePicker.platform.saveFile(
        dialogTitle: "Save QR Image",
        fileName: "$fileName.png",
        allowedExtensions: ["png", "jpg"],
        type: FileType.custom,
      );
      if (p == null) return;

      screenshotController.captureAndSave(
        dirname(p),
        fileName: basename(p),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Saved to $p"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  Row buildBottomBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => saveDesktop(context),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("To Desktop"),
          ),
        ),
        SizedBox(
          width: 16,
        ),
        ElevatedButton(
          onPressed: (() => TODO(context, "Save to your Google Drive")),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text("To Google Drive"),
          ),
        ),
      ],
    );
  }

  Screenshot buildQrImage() {
    return Screenshot(
      controller: screenshotController,
      child: QrImage(
        data: data,
        foregroundColor: Colors.cyan,
      ),
    );
  }

  TextField buildQRText() {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter QR Text',
      ),
      onChanged: (value) => setState(() => data = value),
    );
  }
}
