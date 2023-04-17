import 'package:lpinyin/lpinyin.dart';

class ZhuyinHelper {
  static Map<String, String> pinyinToZhuyinMap =
      ZhuyinResource.getPinyinToZhuyinResource();
  static Map<String, String> zhuyinToPinyinMap =
      ZhuyinResource.getZhuyinToPinyinResource();

  static Map<String, String> toneToNumberMap = {
    "": "1",
    "ˊ": "2",
    "ˇ": "3",
    "ˋ": "4",
    "˙": "5",
  };

  static Map<String, String> numberToToneMap = {
    "1": "",
    "2": "ˊ",
    "3": "ˇ",
    "4": "ˋ",
    "5": "˙",
  };

  /// 将字符串转换成相应格式的注音
  static String getZhuyin(
    String str, {
    String separator = ' ',
  }) {
    String pinyin = PinyinHelper.getPinyin(
      str,
      format: PinyinFormat.WITH_TONE_NUMBER,
    );
    List<String> pinyinList = pinyin.split(' ');
    String zhuyin = '';
    pinyinList.forEach((singlePinyin) {
      zhuyin += _singlePinyinToZhuYin(singlePinyin) + ' ';
    });
    zhuyin = zhuyin.substring(0, zhuyin.length);
    zhuyin = zhuyin.replaceAll(' ', separator);
    return zhuyin;
  }

  /// 單個拼音轉注音
  static String _singlePinyinToZhuYin(String pinyin) {
    String tone = '1';
    pinyin = pinyin.replaceAll("v", "ü");

    for (int i = 0; i < pinyin.length; i++) {
      if (_isDigit(pinyin[i])) {
        tone = pinyin[i];
        pinyin = pinyin.replaceAll(tone, "");
        break;
      }
    }
    return _convert(pinyin, tone, true, false);
  }

  /// 單個注音轉拼音
  static String _singleZhuyinToPinyin(String zhuyin, bool uToV) {
    String tone = '';
    for (int i = 0; i < zhuyin.length; i++) {
      if (toneToNumberMap.containsKey(zhuyin[i])) {
        tone = zhuyin[i];
        zhuyin = zhuyin.replaceAll(tone, "");
        break;
      }
    }
    return _convert(zhuyin, tone, false, uToV);
  }

  static bool _isDigit(String s) {
    return int.tryParse(s) != null;
  }

  static String _convert(
    String word,
    String tone,
    bool pinyinToZhuyin,
    bool uToV,
  ) {
    String result = "";

    if (pinyinToZhuyin) {
      if (pinyinToZhuyinMap.containsKey(word)) {
        result = pinyinToZhuyinMap[word]!;
      } else {
        throw PinyinException("No mapping for given pinyin input: $word");
      }
    } else {
      if (zhuyinToPinyinMap.containsKey(word)) {
        if (uToV) {
          result = zhuyinToPinyinMap[word]!.replaceAll("ü", "v");
        } else {
          result = zhuyinToPinyinMap[word]!;
        }
      } else {
        throw PinyinException("No mapping for given zhuyin input: $word");
      }
    }

    if (pinyinToZhuyin) {
      result = tone != '5'
          ? result + numberToToneMap[tone]!
          : numberToToneMap[tone]! + result;
    } else {
      result = result + toneToNumberMap[tone]!;
    }

    return result;
  }
}
