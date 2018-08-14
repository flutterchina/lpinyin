import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = new TextEditingController();
  String _inputText = "天府广场";
  PinyinFormat _pinyinFormat = PinyinFormat.WITH_TONE_MARK;
  String _pinyinResult;
  static const int TYPE_PINYIN = 1;
  static const int TYPE_SIMPLIFIED = 2;
  static const int TYPE_TRADITIONAL = 3;

  int _convertType = TYPE_PINYIN;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 1), () {
      controller.text = _inputText;
      textChange(_inputText);
    });
  }

  void textChange(String text) {
    _inputText = text;
    if (text == null || text.length == 0) {
      setState(() {
        _pinyinResult = "";
      });
    } else {
      setState(() {
        convertToPinyin(text);
      });
    }
  }

  void convertToPinyin(String text) {
    switch (_convertType) {
      case TYPE_PINYIN:
        try {
          _pinyinResult =
              PinyinHelper.convertToPinyinString(text, format: _pinyinFormat);
        } catch (ex) {
          _pinyinResult = ex.toString();
        }
        break;
      case TYPE_SIMPLIFIED:
        _pinyinResult = ChineseHelper.convertToSimplifiedChinese(text);
        break;
      case TYPE_TRADITIONAL:
        _pinyinResult = ChineseHelper.convertToTraditionalChinese(text);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new ListView(children: <Widget>[
          new Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 5.0, right: 5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("带声调",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])),
                          new Checkbox(
                              value: (_pinyinFormat ==
                                      PinyinFormat.WITH_TONE_MARK &&
                                  _convertType == TYPE_PINYIN),
                              onChanged: (value) {
                                if (value) {
                                  setState(() {
                                    _convertType = TYPE_PINYIN;
                                    _pinyinFormat = PinyinFormat.WITH_TONE_MARK;
                                    convertToPinyin(_inputText);
                                  });
                                }
                              })
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 5.0, right: 5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("不带声调",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])),
                          new Checkbox(
                              value:
                                  (_pinyinFormat == PinyinFormat.WITHOUT_TONE &&
                                      _convertType == TYPE_PINYIN),
                              onChanged: (value) {
                                if (value) {
                                  setState(() {
                                    _convertType = TYPE_PINYIN;
                                    _pinyinFormat = PinyinFormat.WITHOUT_TONE;
                                    convertToPinyin(_inputText);
                                  });
                                }
                              })
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 5.0, right: 5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("带数字声调",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])),
                          new Checkbox(
                              value: (_pinyinFormat ==
                                      PinyinFormat.WITH_TONE_NUMBER &&
                                  _convertType == TYPE_PINYIN),
                              onChanged: (value) {
                                if (value) {
                                  setState(() {
                                    _convertType = TYPE_PINYIN;
                                    _pinyinFormat =
                                        PinyinFormat.WITH_TONE_NUMBER;
                                    convertToPinyin(_inputText);
                                  });
                                }
                              })
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 5.0, right: 5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("繁->简",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])),
                          new Checkbox(
                              value: _convertType == TYPE_SIMPLIFIED,
                              onChanged: (value) {
                                if (value) {
                                  setState(() {
                                    _convertType = TYPE_SIMPLIFIED;
                                    convertToPinyin(_inputText);
                                  });
                                }
                              })
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, left: 5.0, right: 5.0),
                      child: new Column(
                        children: <Widget>[
                          new Text("简->繁",
                              style: new TextStyle(
                                  fontSize: 12.0, color: Colors.grey[700])),
                          new Checkbox(
                              value: _convertType == TYPE_TRADITIONAL,
                              onChanged: (value) {
                                if (value) {
                                  setState(() {
                                    _convertType = TYPE_TRADITIONAL;
                                    convertToPinyin(_inputText);
                                  });
                                }
                              })
                        ],
                      ),
                    ),
                  ],
                ),
                new Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: new TextField(
                    controller: controller,
                    autofocus: false,
                    style:
                        new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                    decoration: new InputDecoration(
                        hintText: "请输入...",
                        hintStyle: new TextStyle(fontSize: 14.0)),
                    onChanged: (value) {
                      textChange(value);
                    },
                  ),
                ),
                new Container(
                  alignment: Alignment.topLeft,
                  height: 66.0,
                  padding: const EdgeInsets.all(10.0),
                  child: new Text(
                    '$_pinyinResult',
                    textAlign: TextAlign.start,
                    style:
                        new TextStyle(color: Colors.grey[600], fontSize: 14.0),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
