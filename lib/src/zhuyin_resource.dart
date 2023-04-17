import 'dart:collection';

import 'package:lpinyin/src/dict_data.dart';

class ZhuyinResource{

  /// get Pinyin To Zhuyin Resource.
  static Map<String, String> getPinyinToZhuyinResource() {
    return pinyinToZhuyinDict;
  }

  /// get Pinyin To Zhuyin Resource.
  static Map<String, String> getZhuyinToPinyinResource() {
    List<String> keys = pinyinToZhuyinDict.keys.toList();
    List<String> values = pinyinToZhuyinDict.values.toList();
    Map<String, String> map = HashMap();
    List<MapEntry<String, String>> mapEntryList = [];
    for(int i = 0; i < values.length; i++){
      MapEntry<String, String> mapEntry = MapEntry(values[i], keys[i]);
      mapEntryList.add(mapEntry);
    }
    map.addEntries(mapEntryList);
    return map;
  }

}