import 'package:azlistview/azlistview.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:lpinyin/lpinyin.dart';

import './Api/Dio.dart';

class Const {
  static var isConstInit = false;

//  static final colorMap = <String, Color>{
////    'OLED模式(WIP)': Colors.black,
//    '胖次蓝': Colors.blue,
//    '简洁白(WIP)': Colors.grey[100],
//    '少女粉': Colors.pink[300],
//    '姨妈红': Colors.red,
//    '咸蛋黄': Colors.yellow[700],
//    '早苗绿': Colors.green[500],
//    '基佬紫': Colors.purple,
//  };

  static final productMap = {
//商超
//  '15': Product('15', '超市之星5', '1', '0'),
//  '16': Product('16', '商业之星6', '1', '0'),
//  '17': Product('17', '批发之星5', '1', '0'),
//  '1a': Product('1a', '易捷通6', '1', '0'),
//  '1f': Product('1f', '食品规范2', '1', '0'),
//  '1g': Product('1g', '商业之星7', '1', '0'),
//  '1h': Product('1h', '易捷通7', '1', '0'),
//  '1j': Product('1j', '便利店7', '1', '0'),
//  '1m': Product('1m', '易捷通8', '1', '0'),
    '18': Product('18', '商云8', '1', '0'),
//  '1o': Product('1o', '商贸王6', '1', '0'),
//  '1x': Product('1x', '领鲜8', '1', '0'),
//  '1r': Product('1r', '订货快', '1', '0'),
    '1u': Product('1u', '商云X', '1', '0'),
//  '1y': Product('1y', '入店营销', '1', '0'),
//商锐
//  '1i': Product('1i', '商锐8', '8', '1'),
//  '1k': Product('1k', '商锐9', '8', '1'),
//  '1l': Product('1l', '商鼎7', '8', '1'),
//  '1q': Product('1q', '商锐9.5', '8', '1'),
//  '1t': Product('1t', '商慧7', '8', '1'),
    '1w': Product('1w', '商锐9.7', '8', '1'),
    //生鲜便利
//  '1n': Product('1n', '便利店8', 'Y', '2'),
    '3j': Product('3j', '秤心管家3', 'Y', '2'),
//  '1s': Product('1s', '便利店9', 'Y', '2'),
    '3u': Product('3u', 'e店通10', 'Y', '2'),
    '3z': Product('3z', '秤心管家8', 'Y', '2'),
    //专卖
//  '32': Product('32', '连锁专卖6', '3', '3'),
//  '34': Product('34', '服装之星7', '3', '3'),
//  '35': Product('35', '服装之星5', '3', '3'),
//  '36': Product('36', '服装之星6', '3', '3'),
//  '37': Product('37', '烘焙系统7', '3', '3'),
//  '38': Product('38', '服装之星8', '3', '3'),
//  '39': Product('39', '烘焙7.5', '3', '3'),
//  '3a': Product('3a', '专卖店7', '3', '3'),
//  '3b': Product('3b', '医药之星5', '3', '3'),
//  '3c': Product('3c', '医药之星6', '3', '3'),
//  '3d': Product('3d', '医药之星7', '3', '3'),
//  '3e': Product('3e', '烘焙之星8', '3', '3'),
//  '3f': Product('3f', '专卖店8', '3', '3'),
//  '3g': Product('3g', '服装通3', '3', '3'),
//  '3h': Product('3h', '康利达专版', '3', '3'),
    '3i': Product('3i', '专卖店9', '3', '3'),
//  '3j': Product('3j', '思迅秤心管家3', '3', '3'),
//  '3K': Product('3K', '服装之星9', '3', '3'),
//  '3m': Product('3m', '医药之星7.5', '3', '3'),
    '3o': Product('3o', '烘焙之星9', '3', '3'),
    '3p': Product('3p', '孕婴童3', '3', '3'),
//    '3q': Product('3q', '孕婴童专业版2017', '3', '3'),
//  '3r': Product('3r', '思迅报修系统', '3', '3'),
    '3s': Product('3s', '专卖店10', '3', '3'),
    '3t': Product('3t', '烘焙之星10', '3', '3'),
//  '3u': Product('3u', 'e店通', '3', '3'),
    '3v': Product('3v', '服装之星10', '3', '3'),
    '3w': Product('3w', '扫码购', '3', '3'),
    '3x': Product('3x', '人脸识别', '3', '3'),
//  '3z': Product('3z', '秤心管家8', '3', '3'),
    //餐饮
//  '21': Product('21', '美世家-桑拿2.6', '2', '4'),
//  '22': Product('22', '美世家-快餐连锁', '2', '4'),
//  '23': Product('23', '美世家25', '2', '4'),
//  '24': Product('24', '美容美发', '2', '4'),
//  '25': Product('25', '美世家3', '2', '4'),
//  '27': Product('27', '美世家-易捷版', '2', '4'),
//  '28': Product('28', '美世家2', '2', '4'),
//  '2a': Product('2a', '美世家4', '2', '4'),
//  '2b': Product('2b', '美食通4', '2', '4'),
    '2c': Product('2c', '桑拿4', '2', '4'),
//  '2d': Product('2d', '美世家客房3', '2', '4'),
//  '2e': Product('2e', '快餐王5', '2', '4'),
//  '2f': Product('2f', '食通天5', '2', '4'),
//  '2h': Product('2h', '美食广场4', '2', '4'),
//  '2i': Product('2i', '美食通5', '2', '4'),
//  '2g': Product('2g', '美世家客房4', '2', '4'),
//  '26': Product('26', '食通天6', '2', '4'),
//  '2j': Product('2j', '快餐王6', '2', '4'),
//  '2k': Product('2k', '快饮6', '2', '4'),
    '2m': Product('2m', '客房5', '2', '4'),
//  '2n': Product('2n', '快饮6.5', '2', '4'),
    '2o': Product('2o', '美食广场5', '2', '4'),
    '2q': Product('2q', '食通天6.5', '2', '4'),
    '1c': Product('1c', '美食家移动POS', '2', '4'),
    '2t': Product('2t', '扫码点菜', '2', '4'),
    '2u': Product('2u', '食通天8', '2', '4'),
    '2w': Product('2w', '微餐厅3.0', '2', '4'),
    //星食客
//  '2p': Product('2p', '星食客3(独立型门店)', 'I', '5'),
    '2r': Product('2r', '星食客3(B/S总部)', 'I', '5'),
    '2s': Product('2s', '美食通+', 'I', '5'),
    '2v': Product('2v', '星食客3(实时型门店)', 'I', '5'),
//  '2w': Product('2w', '微餐厅3.0', 'I', '5'),
    //新零售
    '3n': Product('3n', '微商店2.0', 'C', '6'),
    '2l': Product('2l', '微餐厅2.0', 'C', '6'),
    '1P': Product('1P', '微POS', 'C', '6'),
    '9j': Product('9j', '思迅Pay', 'C', '6'),
    '1v': Product('1v', '自助收银', 'C', '6'),
//  '3w': Product('3w', '扫码购', 'C', '6'),
//  '2t': Product('2t', '扫码点菜', 'C', '6'),
//  '3x': Product('3x', '人脸识别', 'C', '6'),
//  '1z': Product('1z', '大屏营销', 'C', '6'),
    //eShop
//  '61': Product('61', 'iShop专卖3', '6', '7'),
//  '62': Product('62', 'eShop服装4', '6', '7'),
//  '63': Product('63', 'eShop商业4', '6', '7'),
//  '64': Product('64', '美丽管家5', '6', '7'),
    '65': Product('65', 'eShop商业5', '6', '7'),
    '66': Product('66', '小象称重5', '6', '7'),
    '67': Product('67', 'eShop服装5', '6', '7'),
    '68': Product('68', '美丽管家5.5', '6', '7'),
    '69': Product('69', '考拉母婴6', '6', '7'),
    '6a': Product('6a', '移动管家', '6', '7'),
    //思迅天店
    '4a': Product('4a', '零售标准版', 'J', '8'),
    '4b': Product('4b', '零售星耀版', 'J', '8'),
    '4c': Product('4c', '餐饮标准版', 'J', '8'),
//  '4d': Product('4d', '零售通定制版', 'J', '8'),
//  '4e': Product('4e', '运营平台(内部)', 'J', '8'),
    '4f': Product('4f', '零售标准版(安卓平板)', 'J', '8'),
    '4g': Product('4g', '零售星耀版(安卓平板)', 'J', '8'),
    '4h': Product('4h', '餐饮标准版(安卓平板)', 'J', '8'),
//  '4i': Product('4i', '零售通定制版(安卓)', 'J', '8'),
    '4j': Product('4j', '餐饮标准版(安卓手机)', 'J', '8'),
    '4k': Product('4k', '零售星耀版(安卓手机)', 'J', '8'),
    '4l': Product('4l', '零售标准版(安卓手机)', 'J', '8'),
    '4m': Product('4m', '零售标准版(手机iOS)', 'J', '8'),
    '4n': Product('4n', '零售PC前台', 'J', '8'),
    '4o': Product('4o', '零售安卓', 'J', '8'),
    '4p': Product('4p', '手机助手', 'J', '8'),
    '4q': Product('4q', '餐饮PC前台', 'J', '8'),
    '4r': Product('4r', '餐饮安卓', 'J', '8'),
    '4s': Product('4s', '零售星耀PC前台', 'J', '8'),
    '4t': Product('4t', '零售星耀安卓', 'J', '8'),
  };
  static var contactsList = <Contacts>[];
  static var avatarUrl =
      'http://www2.sixun.com.cn/Content/Images/icon/avatar1.png';
  static var realName = '';

  static String get agentID => SpUtil.getString('agentID');
  static set agentID(value) => SpUtil.putString('agentID', value);

  static String get userID => SpUtil.getString('userID');
  static set userID(value) => SpUtil.putString('userID', value);

  static String get password => SpUtil.getString('password');
  static set password(value) => SpUtil.putString('password', value);

  static int get themeIndex => SpUtil.getInt('themeIndex', defValue: -1);
  static set themeIndex(value) => SpUtil.putInt('themeIndex', value);

  static List<String> get endUserList => SpUtil.getStringList('endUserList');
  static set endUserList(value) => SpUtil.putStringList('endUserList', value);

//  static Map<String, Product> get productMap =>
//      SpUtil.getObject('productMap', defaultProductMap);
//  static set productMap(value) => SpUtil.putObject('productMap', value);

  static initConst() async {
    isConstInit = true;

    await _getContactsList();
    await _getUserInfo();
  }

  static Future<void> _getContactsList() async {
    Response response =
        await dio.get('http://www2.sixun.com.cn/webqa/QA/ContactsList.aspx');
    RegExp regExp = RegExp(
        r'_Label1".+?>(.+?)<(?:.|\s)+?_Label2".+?>(.+?)<(?:.|\s)+?_Label3".+?>(.+?)<(?:.|\s)+?_Label4">(.+?)</span>(?:.|\s)+?_Label5".+?>(.*?)<');

    for (var match in regExp.allMatches(response.data)) {
      contactsList.add(Contacts(
        match.group(1),
        match.group(2),
        match.group(3).trim(),
        match.group(4),
      ));
    }
  }

  static Future<void> _getUserInfo() async {
    RegExp regExp;
    Match match;

    Response response =
        await dio.get('http://www2.sixun.com.cn/Account/PersonInfo/');
    regExp = RegExp(r'preview-lg(?:.|\s)+?<img.+?src="(.+?)"');
    match = regExp.firstMatch(response.data);
    if (match == null || match.groupCount != 1)
      throw Error.safeToString('尝试获取AvatarUrl时出错');
    avatarUrl = 'http://www2.sixun.com.cn/' + match.group(1);

    regExp = RegExp(
        r'id="cust_no".+?value="(.+?)"(?:.|\s)+?id="oper_id".+?value="(.+?)"(?:.|\s)+?id="oper_name".+?value="(.+?)"');
    match = regExp.firstMatch(response.data);
    if (match == null || match.groupCount != 3)
      throw Error.safeToString('尝试获取UserInfo时出错');
    realName = match.group(3);
  }
}

class Contacts {
  String name;
  String mobile;
  String phone;
  String email;

  Contacts(this.name, this.mobile, this.phone, this.email);

  @override
  String toString() => name;
}

class Product extends ISuspensionBean {
  String id;
  String name;
  String typeID;
  String eventID;

  Product(this.id, this.name, this.typeID, this.eventID);

  @override
  String getSuspensionTag() {
    final pinyin = PinyinHelper.getFirstWordPinyin(name);
    return pinyin.substring(0, 1).toUpperCase();
  }
}
