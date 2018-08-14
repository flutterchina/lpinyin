import 'dart:collection';

import 'package:lpinyin/src/dict_data.dart';

class PinyinResource {
  static Map<String, String> getPinyinResource() {
    return getResource(PINYIN_DICT);
  }

  static Map<String, String> getChineseResource() {
    return getResource(CHINESE_DICT);
  }

  static Map<String, String> getMultiPinyinResource() {
    return getResource(MULTI_PINYIN_DICT);
  }

  static Map<String, String> getResource(List<String> list) {
    Map<String, String> map = new HashMap.fromIterable(list,
        key: (item) => item.trim().split("=")[0],
        value: (item) => item.trim().split("=")[1]);
    return map;

//    Map<String, String> _map = new HashMap();
//    List<MapEntry<String, String>> mapEntryList = new List();
//    list.forEach((value) {
//      List<String> tokens = value.trim().split("=");
//      MapEntry<String, String> mapEntry = new MapEntry(tokens[0], tokens[1]);
//      mapEntryList.add(mapEntry);
//    });
//    _map.addEntries(mapEntryList);
//    return _map;
  }
}
