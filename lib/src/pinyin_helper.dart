import 'dart:collection';

import 'package:lpinyin/src/chinese_helper.dart';
import 'package:lpinyin/src/pinyin_exception.dart';
import 'package:lpinyin/src/pinyin_format.dart';
import 'package:lpinyin/src/pinyin_resource.dart';

/// 汉字转拼音类.
class PinyinHelper {
  static Map<String, String> pinyinMap = PinyinResource.getPinyinResource();
  static Map<String, String> multiPinyinMap =
      PinyinResource.getMultiPinyinResource();

  /// 拼音分隔符
  static const String pinyinSeparator = ',';

  /// 所有带声调的拼音字母
  static const String allMarkedVowel = 'āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜ';
  static const String allUnmarkedVowel = 'aeiouv';
  static int minMultiLength = 2;
  static int maxMultiLength = 0;

  /// 获取字符串首字拼音
  /// @param str 需要转换的字符串
  /// @return 首字拼音 (成都 cheng)
  static String getFirstWordPinyin(String str) {
    if (str.isEmpty) return '';
    String _pinyin = getPinyin(str, separator: pinyinSeparator);
    return _pinyin.split(pinyinSeparator)[0];
  }

  /// 获取字符串对应拼音的首字母
  /// @param str 需要转换的字符串
  /// @return 对应拼音的首字母 (成都 cd)
  static String getShortPinyin(String str) {
    if (str.isEmpty) return '';
    StringBuffer sb = StringBuffer();
    StringBuffer temp = StringBuffer();
    for (int i = 0, len = str.length; i < len; i++) {
      String c = str[i];
      if (ChineseHelper.isChinese(c)) {
        int j = i + 1;
        temp.write(c);
        while (j < len && (ChineseHelper.isChinese(str[j]))) {
          temp.write(str[j]);
          j++;
        }
        String pinyin = getPinyin(temp.toString(), separator: pinyinSeparator);
        List<String> pinyinArray = pinyin.split(pinyinSeparator);
        pinyinArray.forEach((v) {
          sb.write(v[0]);
          i++;
        });
        i--;
        temp.clear();
      } else {
        sb.write(c);
      }
    }
    return sb.toString();
  }

  /// 将字符串转换成相应格式的拼音
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符 def: ' '
  /// @param format 拼音格式 def: PinyinFormat.WITHOUT_TONE
  /// @return 字符串的拼音(成都 cheng du)
  static String getPinyin(
    String str, {
    String separator = ' ',
    PinyinFormat format = PinyinFormat.WITHOUT_TONE,
  }) {
    if (str.isEmpty) return '';
    StringBuffer sb = StringBuffer();
    str = ChineseHelper.convertToSimplifiedChinese(str);

    int strLen = str.length;
    int i = 0;
    while (i < strLen) {
      String subStr = str.substring(i);
      MultiPinyin? node = convertToMultiPinyin(subStr, separator, format);
      if (node == null) {
        String _char = str[i];
        if (ChineseHelper.isChinese(_char)) {
          List<String> pinyinArray = convertToPinyinArray(_char, format);
          if (pinyinArray.isNotEmpty) {
            sb.write(pinyinArray[0]);
          } else {
            throw PinyinException("Can't convert to pinyin: $_char");
          }
        } else {
          sb.write(_char);
        }
        if (i < strLen) {
          sb.write(separator);
        }
        i++;
      } else {
        sb.write(node.pinyin);
        i += node.word!.length;
      }
    }
    String res = sb.toString();
    return ((res.endsWith(separator) && separator != '')
        ? res.substring(0, res.length - 1)
        : res);
  }

  /// 将字符串转换成相应格式的拼音 (不能转换的字拼音默认用' '替代 )
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符 def: ' '
  /// @param defPinyin 默认拼音 def: ' '
  /// @param format 拼音格式 def: PinyinFormat.WITHOUT_TONE
  /// @return 字符串的拼音(成都 cheng du)
  static String getPinyinE(
    String str, {
    String separator = ' ',
    String defPinyin = ' ',
    PinyinFormat format = PinyinFormat.WITHOUT_TONE,
  }) {
    if (str.isEmpty) return '';
    StringBuffer sb = StringBuffer();
    str = ChineseHelper.convertToSimplifiedChinese(str);
    int strLen = str.length;
    int i = 0;
    while (i < strLen) {
      String subStr = str.substring(i);
      MultiPinyin? node = convertToMultiPinyin(subStr, separator, format);
      if (node == null) {
        String _char = str[i];
        if (ChineseHelper.isChinese(_char)) {
          List<String> pinyinArray = convertToPinyinArray(_char, format);
          if (pinyinArray.isNotEmpty) {
            sb.write(pinyinArray[0]);
          } else {
            sb.write(defPinyin);
            print(
                "### Can't convert to pinyin: $_char , defPinyin: $defPinyin");
          }
        } else {
          sb.write(_char);
        }
        if (i < strLen) {
          sb.write(separator);
        }
        i++;
      } else {
        sb.write(node.pinyin);
        i += node.word!.length;
      }
    }
    String res = sb.toString();
    return ((res.endsWith(separator) && separator != '')
        ? res.substring(0, res.length - 1)
        : res);
  }

  /// 获取多音字拼音
  /// @param str 需要转换的字符串
  /// @param separator 拼音分隔符
  /// @param format 拼音格式
  /// @return 多音字拼音
  static MultiPinyin? convertToMultiPinyin(
      String str, String separator, PinyinFormat format) {
    if (str.length < minMultiLength) return null;
    if (maxMultiLength == 0) {
      List<String> keys = multiPinyinMap.keys.toList();
      for (int i = 0, length = keys.length; i < length; i++) {
        if (keys[i].length > maxMultiLength) {
          maxMultiLength = keys[i].length;
        }
      }
    }
    for (int end = minMultiLength, length = str.length;
        (end <= length && end <= maxMultiLength);
        end++) {
      String subStr = str.substring(0, end);
      String? multi = multiPinyinMap[subStr];
      if (multi != null && multi.isNotEmpty) {
        List<String> str = multi.split(pinyinSeparator);
        StringBuffer sb = StringBuffer();
        str.forEach((value) {
          List<String> pinyin = formatPinyin(value, format);
          sb.write(pinyin[0]);
          sb.write(separator);
        });
        return MultiPinyin(word: subStr, pinyin: sb.toString());
      }
    }
    return null;
  }

  /// 将单个汉字转换为相应格式的拼音
  /// @param c 需要转换成拼音的汉字
  /// @param format 拼音格式
  /// @return 汉字的拼音
  static List<String> convertToPinyinArray(String c, PinyinFormat format) {
    String? pinyin = pinyinMap[c];
    return pinyin == null ? [] : formatPinyin(pinyin, format);
  }

  /// 将带声调的拼音格式化为相应格式的拼音
  /// @param pinyinStr 带声调格式的拼音
  /// @param format 拼音格式
  /// @return 格式转换后的拼音
  static List<String> formatPinyin(String pinyinStr, PinyinFormat format) {
    if (format == PinyinFormat.WITH_TONE_MARK) {
      return pinyinStr.split(pinyinSeparator);
    } else if (format == PinyinFormat.WITH_TONE_NUMBER) {
      return convertWithToneNumber(pinyinStr);
    } else if (format == PinyinFormat.WITHOUT_TONE) {
      return convertWithoutTone(pinyinStr);
    }
    return [];
  }

  /// 将带声调格式的拼音转换为不带声调格式的拼音
  /// @param pinyinArrayStr 带声调格式的拼音
  /// @return 不带声调的拼音
  static List<String> convertWithoutTone(String pinyinArrayStr) {
    List<String> pinyinArray;
    for (int i = allMarkedVowel.length - 1; i >= 0; i--) {
      int originalChar = allMarkedVowel.codeUnitAt(i);
      double index = (i - i % 4) / 4;
      int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
      pinyinArrayStr = pinyinArrayStr.replaceAll(
          String.fromCharCode(originalChar), String.fromCharCode(replaceChar));
    }
    // 将拼音中的ü替换为v
    pinyinArray = pinyinArrayStr.replaceAll("ü", "v").split(pinyinSeparator);
    // 去掉声调后的拼音可能存在重复，做去重处理
    LinkedHashSet<String> pinyinSet = LinkedHashSet<String>();
    pinyinArray.forEach((value) {
      pinyinSet.add(value);
    });
    return pinyinSet.toList();
  }

  /// 将带声调格式的拼音转换为数字代表声调格式的拼音
  /// @param pinyinArrayStr 带声调格式的拼音
  /// @return 数字代表声调格式的拼音
  static List<String> convertWithToneNumber(String pinyinArrayStr) {
    List<String> pinyinArray = pinyinArrayStr.split(pinyinSeparator);
    for (int i = pinyinArray.length - 1; i >= 0; i--) {
      bool hasMarkedChar = false;
      String originalPinyin = pinyinArray[i].replaceAll('ü', 'v'); // 将拼音中的ü替换为v
      for (int j = originalPinyin.length - 1; j >= 0; j--) {
        int originalChar = originalPinyin.codeUnitAt(j);
        // 搜索带声调的拼音字母，如果存在则替换为对应不带声调的英文字母
        if (originalChar < 'a'.codeUnitAt(0) ||
            originalChar > 'z'.codeUnitAt(0)) {
          int indexInAllMarked =
              allMarkedVowel.indexOf(String.fromCharCode(originalChar));
          int toneNumber = indexInAllMarked % 4 + 1; // 声调数
          double index = (indexInAllMarked - indexInAllMarked % 4) / 4;
          int replaceChar = allUnmarkedVowel.codeUnitAt(index.toInt());
          pinyinArray[i] = originalPinyin.replaceAll(
                  String.fromCharCode(originalChar),
                  String.fromCharCode(replaceChar)) +
              toneNumber.toString();
          hasMarkedChar = true;
          break;
        }
      }
      if (!hasMarkedChar) {
        // 找不到带声调的拼音字母说明是轻声，用数字5表示
        pinyinArray[i] = originalPinyin + '5';
      }
    }

    return pinyinArray;
  }

  /// 将单个汉字转换成带声调格式的拼音
  /// @param c 需要转换成拼音的汉字
  /// @return 字符串的拼音
  static List<String> convertCharToPinyinArray(String c) {
    return convertToPinyinArray(c, PinyinFormat.WITH_TONE_MARK);
  }

  /// 判断一个汉字是否为多音字
  /// @param c汉字
  /// @return 判断结果，是汉字返回true，否则返回false
  static bool hasMultiPinyin(String c) {
    List<String> pinyinArray = convertCharToPinyinArray(c);
    if (pinyinArray.isNotEmpty) {
      return true;
    }
    return false;
  }

  /// 添加拼音字典
  static void addPinyinDict(List<String> list) {
    pinyinMap.addAll(PinyinResource.getResource(list));
  }

  /// 添加多音字字典
  static void addMultiPinyinDict(List<String> list) {
    multiPinyinMap.addAll(PinyinResource.getResource(list));
  }

  /// 将单个拼音分隔成声母和韵母
  static List<String> splitPinyin(String pinyin) {
    List<String> result = [];
    String initial = '';
    String finalPinyin = '';
    for (int i = 0; i < pinyin.length; i++) {
      String char = pinyin[i];
      if (char == 'a' ||
          char == "ǎ" ||
          char == "á" ||
          char == "à" ||
          char == "ā" ||
          char == "e" ||
          char == "ě" ||
          char == "é" ||
          char == "è" ||
          char == "ē" ||
          char == "i" ||
          char == "ǐ" ||
          char == "í" ||
          char == "ì" ||
          char == "ī" ||
          char == "o" ||
          char == "ǒ" ||
          char == "ó" ||
          char == "ò" ||
          char == "ō" ||
          char == "u" ||
          char == "ǔ" ||
          char == "ú" ||
          char == "ù" ||
          char == "ū" ||
          char == "ü" ||
          char == "ǘ" ||
          char == "ǚ" ||
          char == "ǜ" ||
          char == "ǖ") {
        initial = pinyin.substring(0, i);
        finalPinyin = pinyin.substring(i);
        break;
      }
    }
    result.add(initial);
    result.add(finalPinyin);
    return result;
  }
}

/// 多音字
class MultiPinyin {
  String? word;
  String? pinyin;

  MultiPinyin({this.word, this.pinyin});

  @override
  String toString() {
    StringBuffer sb = StringBuffer('{');
    sb.write("\"word\":\"$word\"");
    sb.write(",\"pinyin\":\"$pinyin\"");
    sb.write('}');
    return sb.toString();
  }
}
