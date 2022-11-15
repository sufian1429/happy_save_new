import 'dart:developer';
// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/Screen/recognization_page.dart';
import 'package:ocr/Utils/image_cropper_page.dart';
import 'package:ocr/Utils/image_picker_class.dart';
import 'package:ocr/Widgets/modal_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'google_sheets_api.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'google_sheets_api.dart';
import 'loading_circle.dart';
import 'plus_button.dart';
import 'top_card.dart';
import 'transaction.dart';

final Uri _url = Uri.parse(
    'https://docs.google.com/spreadsheets/d/1BSrxKH_6NIMa2zJa1OSG8LgeBc2YoKmBt1Mla508Mrk/edit?usp=sharing');

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HappySave',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Happy Save'),
    );
  }
}

// var myMenuItems = <String>[
//   'มกราคม',
//   'กุมภาพันธ์',
//   'มีนาคม',
//   'เมษายน',
//   'พฤษภาคม',
//   'มิถุนายน',
//   'กรกฎาคม',
//   'สิงหาคม',
//   'กันยายน',
//   'ตุลาคม',
//   'พฤศจิกายน',
//   'ธันวาคม',
// ];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  String formattedDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

  final _textcontrollerAMOUNT = TextEditingController();
  final _textcontrollerITEM = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;
  List<String> list = <String>[
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม',
  ];
  String? value;

  // ignore: unused_element
  void _incrementCounter() {
    setState(() {
      //_counter++;
    });
  }

  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textcontrollerITEM.text,
      _textcontrollerAMOUNT.text,
      _isIncome,
      formattedDate,
    );
    setState(() {});
  }

  // void _deleteTransaction() {
  //   GoogleSheetsApi.insert(
  //     _textcontrollerITEM.text,
  //     _textcontrollerAMOUNT.text,
  //     _isIncome,
  //     formattedDate,
  //   );
  //   setState(() {});
  // }

  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('กรอกข้อมูลรายการใหม่'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('รายจ่าย'),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text('รายรับ'),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'จำนวนเงิน ?',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'กรุณาระบุเป็นตัวเลข';
                                  }
                                  return null;
                                },
                                controller: _textcontrollerAMOUNT,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'รายการ ?',
                              ),
                              controller: _textcontrollerITEM,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.red[600],
                    child:
                        Text('ยกเลิก', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.green[600],
                    child:
                        Text('บันทึก', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  // DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
  //       value: item,
  //       child: Text(
  //         item,
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    // start loading until the data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            ElevatedButton(
                child: Text('Google Sheets'),
                onPressed: () {
                  launchUrl(_url);
                }),
            SizedBox(
              height: 5,
            ),
            TopNeuCard(
              balance: (GoogleSheetsApi.calculateIncome() -
                      GoogleSheetsApi.calculateExpense())
                  .toString(),
              income: GoogleSheetsApi.calculateIncome().toString(),
              expense: GoogleSheetsApi.calculateExpense().toString(),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GoogleSheetsApi.loading == true
                            ? LoadingCircle()
                            : ListView.builder(
                                itemCount:
                                    GoogleSheetsApi.currentTransactions.length,
                                itemBuilder: (context, index) {
                                  return MyTransaction(
                                    transactionName: GoogleSheetsApi
                                        .currentTransactions[index][0],
                                    money: GoogleSheetsApi
                                        .currentTransactions[index][1],
                                    expenseOrIncome: GoogleSheetsApi
                                        .currentTransactions[index][2],
                                    formattedDate: GoogleSheetsApi
                                        .currentTransactions[index][3],
                                  );
                                }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            PlusButton(
              function: _newTransaction,
            ),
            Row(children: <Widget>[
              Container(
                width: 120,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // value: value,
                    // iconSize: 20,

                    // icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    isExpanded: true,
                    value: value,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Colors.greenAccent),
                    elevation: 10,
                    style: const TextStyle(color: Colors.black),
                    // underline: Container(
                    //   height: 2,
                    //   color: Colors.deepPurpleAccent,
                    // ),
                    items: list.map(buildMenuItem).toList(),
                    onChanged: (value) => {
                      if (value == 'มกราคม')
                        {
                          GoogleSheetsApi().init1(),
                          this.value = value,
                        }
                      else if (value == 'กุมภาพันธ์')
                        {
                          GoogleSheetsApi().init2(),
                          this.value = value,
                        }
                      else if (value == 'มีนาคม')
                        {
                          GoogleSheetsApi().init3(),
                          this.value = value,
                        }
                      else if (value == 'เมษายน')
                        {
                          GoogleSheetsApi().init4(),
                          this.value = value,
                        }
                      else if (value == 'พฤษภาคม')
                        {
                          GoogleSheetsApi().init5(),
                          this.value = value,
                        }
                      else if (value == 'มิถุนายน')
                        {
                          GoogleSheetsApi().init6(),
                          this.value = value,
                        }
                      else if (value == 'กรกฎาคม')
                        {
                          GoogleSheetsApi().init7(),
                          this.value = value,
                        }
                      else if (value == 'สิงหาคม')
                        {
                          GoogleSheetsApi().init8(),
                          this.value = value,
                        }
                      else if (value == 'กันยายน')
                        {
                          GoogleSheetsApi().init9(),
                          this.value = value,
                        }
                      else if (value == 'ตุลาคม')
                        {
                          GoogleSheetsApi().init10(),
                          this.value = value,
                        }
                      else if (value == 'พฤศจิกายน')
                        {
                          GoogleSheetsApi().init11(),
                          this.value = value,
                        }
                      else if (value == 'ธันวาคม')
                        {
                          GoogleSheetsApi().init12(),
                          this.value = value,
                        }
                    },
                  ),
                ),
                // DropdownMenuItem<String>buildMenuItem(String item) => DropdownMenuItem(
                //   value: item,
                //   child: Text(
                //     item,
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                //   ),);
                // PopupMenuButton<String>(
                //     onSelected: (String result) {
                //       print(result);

                //       if (result == 'มกราคม') {
                //         GoogleSheetsApi().init1();
                //       } else if (result == 'กุมภาพันธ์') {
                //         GoogleSheetsApi().init2();
                //       } else if (result == 'มีนาคม') {
                //         GoogleSheetsApi().init3();
                //       } else if (result == 'เมษายน') {
                //         GoogleSheetsApi().init4();
                //       } else if (result == 'พฤษภาคม') {
                //         GoogleSheetsApi().init5();
                //       } else if (result == 'มิถุนายน') {
                //         GoogleSheetsApi().init6();
                //       } else if (result == 'กรกฎาคม') {
                //         GoogleSheetsApi().init7();
                //       } else if (result == 'สิงหาคม') {
                //         GoogleSheetsApi().init8();
                //       } else if (result == 'กันยายน') {
                //         GoogleSheetsApi().init9();
                //       } else if (result == 'ตุลาคม') {
                //         GoogleSheetsApi().init10();
                //       } else if (result == 'พฤศจิกายน') {
                //         GoogleSheetsApi().init11();
                //       } else if (result == 'ธันวาคม') {
                //         GoogleSheetsApi().init12();
                //       }
                //     },
                //     color: Colors.green[100],
                //     itemBuilder: (BuildContext context) {
                //       return myMenuItems.map((String choice) {
                //         return PopupMenuItem<String>(
                //           child: Text(choice),
                //           value: choice,
                //         );
                //       }).toList();
                //     })
              )
            ])
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            log("ถ่ายภาพ");

            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            log("แกลเลอรี่");

            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          });
        },
        tooltip: 'Increment',
        label: const Text("เลือกภาพ"),
        icon: Image.network(
          "https://cdn-icons-png.flaticon.com/128/1837/1837512.png",
          width: 35,
          height: 30.0,
          fit: BoxFit.fill,

          // color: Colors.grey,
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          // selectionColor: Colors.black,
        ),
      );
}

_lauchUrl() async {
  const url =
      'https://docs.google.com/spreadsheets/d/1BSrxKH_6NIMa2zJa1OSG8LgeBc2YoKmBt1Mla508Mrk/edit#gid=0';

  // ignore: deprecated_member_use
  if (await canLaunch(url)) {
    // ignore: deprecated_member_use
    await launch(url);
  } else {
    print("Try again");
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
