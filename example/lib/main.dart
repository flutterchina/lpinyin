import 'package:lpinyin/lpinyin.dart';

void main() {
  String str = "天府广场";

  //字符串拼音首字符
  String shortpy = PinyinHelper.getShortPinyin(str); // tfgc

  //字符串首字拼音
  String firstWord = PinyinHelper.getFirstWordPinyin(str); // tian

  String pinyin1 = PinyinHelper.getPinyin(str); //tian fu guang chang
  String pinyin2 = PinyinHelper.getPinyin(str,
      separator: "-", format: PinyinFormat.WITHOUT_TONE);

  PinyinHelper.getPinyinE(str); //tian fu guang chang
  PinyinHelper.getPinyinE(str,
      separator: " ", format: PinyinFormat.WITHOUT_TONE);

  print("shortpy: " + shortpy);
  print("firstWord: " + firstWord);
  print("pinyin1: " + pinyin1);
  print("pinyin2: " + pinyin2);

  String zhuyin1 = ZhuyinHelper.getZhuyin(str);
  String zhuyin2 = ZhuyinHelper.getZhuyin(str,separator: "-");

  print("zhuyin1: " + zhuyin1);
  print("zhuyin2: " + zhuyin2);

  String name = "😃";
  String pinyin = PinyinHelper.getPinyin(name, separator: '');
  print(
      "pinyin: $pinyin , length: ${name.length}, sub: ${name.substring(0)} , FirstWord: ${PinyinHelper.getFirstWordPinyin(name)} , ShortPinyin: ${PinyinHelper.getShortPinyin(name)} ");

  //添加用户自定义字典
  List<String> dict1 = ['耀=yào', '老=lǎo'];
  PinyinHelper.addPinyinDict(dict1); //拼音字典
  List<String> dict2 = ['奇偶=jī,ǒu', '成都=chéng,dū'];
  PinyinHelper.addMultiPinyinDict(dict2); //多音字词组字典
  List<String> dict3 = ['倆=俩', '們=们'];
  ChineseHelper.addChineseDict(dict3); //繁体字字典
}
