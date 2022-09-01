import 'package:flutter/material.dart';
import 'package:txp/bridge_generated.dart';

import 'dart:ffi';
import 'dart:io';

const base = 'rust';
final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
late final dylib = Platform.isIOS
    ? DynamicLibrary.process()
    : Platform.isMacOS
        ? DynamicLibrary.executable()
        : DynamicLibrary.open(path);

late final api = RustImpl(dylib);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  String displayText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  displayText = textController.text;
                  print('Raw Bitcoin Transaction');
                  api.platform(
                      tx: "02000000000101535227bfe2c25b3f72bb388c7190b354d7157f679ff07b423db3c18eb52ec3a90000000000ffffffff01d8ca020000000000160014966542367595fc0108b6133efce1fe629c2770f4024730440220313595b56ae15d5d290c9995d6c2b3242963a4fbfb633d9d2dacc4047e84d484022038a225b6fff2808db9a3ff82eb7e6f32d4e08add55772347a32156b505c5f8e601210259abe18711052eea2e1de8a5ecc57805deb2fee828dba543c6b294d8691b718600000000");
                },
                child: Text("Broadcast Transaction")),
          ],
        ),
      ),
    );
  }
}
