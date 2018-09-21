import 'package:lpinyin/lpinyin.dart';

void main() {
  String str = "天府广场";

  //字符串拼音首字符
  PinyinHelper.getShortPinyin(str); // tfgc

  //字符串首字拼音
  PinyinHelper.getFirstWordPinyin(str); // tian

  PinyinHelper.convertToPinyinString(str); //tian fu guang chang
  PinyinHelper.convertToPinyinString(str, separator: " ", format: PinyinFormat.WITHOUT_TONE);

  PinyinHelper.convertToPinyinStringWithoutException(str); //tian fu guang chang
  PinyinHelper.convertToPinyinStringWithoutException(str, separator: " ", format: PinyinFormat.WITHOUT_TONE);

  //添加用户自定义字典
  List<String> dict1 = ['耀=yào', '老=lǎo'];
  PinyinHelper.addPinyinDict(dict1); //拼音字典
  List<String> dict2 = ['奇偶=jī,ǒu', '成都=chéng,dū'];
  PinyinHelper.addMultiPinyinDict(dict2); //多音字词组字典
  List<String> dict3 = ['倆=俩', '們=们'];
  ChineseHelper.addChineseDict(dict3); //繁体字字典
}



