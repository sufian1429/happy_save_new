import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ocr/google_sheets_api.dart';
import 'package:ocr/main.dart';
import 'package:ocr/transaction.dart';

class RecognizePage extends StatefulWidget {
  final String? path;

  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  void _enter() {
    GoogleSheetsApi.insert(
        nameController.text, amountController.text, false, formattedDate);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Recognized")),
        body: _isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topLeft,
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: Text("รายการ")),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          maxLines: 1,
                          controller: nameController,
                          // decoration:
                          //     const InputDecoration(hintText: "Text goes here..."),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.topLeft,
                          child: Text("จำนวนเงิน")),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextFormField(
                          maxLines: 1,

                          controller: amountController,
                          // decoration:
                          //     const InputDecoration(hintText: "Text goes here..."),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: MaterialButton(
                            color: Colors.green[600],
                            child: Text('บันทึก',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              _enter();
                              Navigator.of(context).pop();
                            },
                          ))
                    ]))));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    amountController.text = recognizedText.text;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
