# lpinyin (汉字转拼音Flutter版)

[![Pub](https://img.shields.io/pub/v/lpinyin.svg?style=flat-square)](https://pub.dartlang.org/packages/lpinyin)

lpinyin是一个汉字转拼音的Dart package. 主要参考Java开源类库[jpinyin](https://github.com/SilenceDut/jpinyin).  
①准确、完善的字库  
②拼音转换速度快  
③支持多种拼音输出格式：带音标、不带音标、数字表示音标以及拼音首字母输出格式  
④支持常见多音字的识别，其中包括词组、成语、地名等  
⑤简繁体中文转换  
⑥支持添加用户自定义字典

### v1.0.7 方法名改变
convertToPinyinString -> getPinyin  
convertToPinyinStringWithoutException -> getPinyinE

## Demo: [flutter_demos](https://github.com/Sky24n/flutter_demos).

## Android扫码下载APK
  ![](https://github.com/Sky24n/LDocuments/blob/master/AppImgs/flutter_demos/qrcode.png)

##  Demo截图
![image](https://github.com/Sky24n/lpinyin/blob/master/screenshot/2018-08-17_13_13_09.gif)

### Add dependency

```yaml
dependencies:
  lpinyin: x.x.x  #latest version
```

### Example

``` dart

// Import package
import 'package:lpinyin/lpinyin.dart';

String text = "天府广场";

//字符串拼音首字符
PinyinHelper.getShortPinyin(str); // tfgc

//字符串首字拼音
PinyinHelper.getFirstWordPinyin(str); // tian

//无法转换拼音会 throw PinyinException
PinyinHelper.getPinyin(text);
PinyinHelper.getPinyin(text, separator: " ", format: PinyinFormat.WITHOUT_TONE);//tian fu guang chang

//无法转换拼音 默认用' '替代
PinyinHelper.getPinyinE(text);
PinyinHelper.getPinyinE(text, separator: " ", defPinyin: '#', format: PinyinFormat.WITHOUT_TONE);//tian fu guang chang

//添加用户自定义字典
List<String> dict1 = ['耀=yào','老=lǎo'];
PinyinHelper.addPinyinDict(dict1);//拼音字典
List<String> dict2 = ['奇偶=jī,ǒu','成都=chéng,dū'];
PinyinHelper.addMultiPinyinDict(dict2);//多音字词组字典
List<String> dict3 = ['倆=俩','們=们'];
ChineseHelper.addChineseDict(dict3);//繁体字字典

```
