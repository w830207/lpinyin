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
    PinyinFormat format = PinyinFormat.WITH_TONE_MARK,
  }) {
    String pinyin = PinyinHelper.getPinyin(
      str,
      format: PinyinFormat.WITH_TONE_NUMBER,
    );
    List<String> pinyinList = pinyin.split(' ');
    String zhuyin = '';
    pinyinList.forEach((singlePinyin) {
      zhuyin += _singlePinyinToZhuYin(singlePinyin, format) + ' ';
    });
    zhuyin = zhuyin.substring(0, zhuyin.length - 1);
    zhuyin = zhuyin.replaceAll(' ', separator);
    zhuyin = zhuyin.replaceAll(separator + separator, separator + ' ');
    return zhuyin;
  }

  /// 單個拼音轉注音
  static String _singlePinyinToZhuYin(String pinyin, PinyinFormat format) {
    if (_isDigit(pinyin)) return pinyin;
    String tone = '1';
    pinyin = pinyin.replaceAll("v", "ü");

    for (int i = 0; i < pinyin.length; i++) {
      if (_isDigit(pinyin[i])) {
        tone = pinyin[i];
        pinyin = pinyin.replaceAll(tone, "");
        break;
      }
    }
    return _convert(pinyin, tone, true, false, format);
  }

  /// 單個注音轉拼音
  // static String _singleZhuyinToPinyin(String zhuyin, bool uToV) {
  //   String tone = '';
  //   for (int i = 0; i < zhuyin.length; i++) {
  //     if (toneToNumberMap.containsKey(zhuyin[i])) {
  //       tone = zhuyin[i];
  //       zhuyin = zhuyin.replaceAll(tone, "");
  //       break;
  //     }
  //   }
  //   return _convert(zhuyin, tone, false, uToV);
  // }

  static bool _isDigit(String s) {
    return int.tryParse(s) != null;
  }

  static String _convert(
    String word,
    String tone,
    bool pinyinToZhuyin,
    bool uToV,
    PinyinFormat format,
  ) {
    String result = "";

    if (pinyinToZhuyin) {
      if (pinyinToZhuyinMap.containsKey(word)) {
        result = pinyinToZhuyinMap[word]!;
      } else {
        return word;
      }
    } else {
      if (zhuyinToPinyinMap.containsKey(word)) {
        if (uToV) {
          result = zhuyinToPinyinMap[word]!.replaceAll("ü", "v");
        } else {
          result = zhuyinToPinyinMap[word]!;
        }
      } else {
        return word;
      }
    }

    if (pinyinToZhuyin) {
      switch (format) {
        case PinyinFormat.WITH_TONE_MARK:
          result = tone != '5'
              ? result + numberToToneMap[tone]!
              : numberToToneMap[tone]! + result;
          break;
        case PinyinFormat.WITH_TONE_NUMBER:
          result = result + tone;
          break;
        case PinyinFormat.WITHOUT_TONE:
          break;
      }
    } else {
      result = result + toneToNumberMap[tone]!;
    }

    return result;
  }
}
