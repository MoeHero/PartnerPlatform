import 'package:flutter/material.dart';

class Product {
  // extends ISuspensionBean {
  String id;
  String originalName;
  String showName;
  String typeID;
  String eventID;
  ProductType defaultType;

  Product({
    @required this.id,
    @required this.originalName,
    this.showName,
    @required this.typeID,
    @required this.eventID,
    @required this.defaultType,
  });

//  @override
//  String getSuspensionTag() {
//    final pinyin = PinyinHelper.getFirstWordPinyin(name);
//    return pinyin.substring(0, 1).toUpperCase();
//  }
}

enum ProductType {
  Business,
  NewRetail,
  Monopoly,
  Catering,
  eShop,
  TD365,
  O2O,
}

//final defaultProductMap = {
////商超
//  '15': Product(
//    id: '15',
//    originalName: '超市之星5',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '16': Product(
//    id: '16',
//    originalName: '商业之星6',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '17': Product(
//    id: '17',
//    originalName: '批发之星5',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1a': Product(
//    id: '1a',
//    originalName: '易捷通6',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1f': Product(
//    id: '1f',
//    originalName: '食品规范2',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.O2O,
//  ),
//  '1g': Product(
//    id: '1g',
//    originalName: '商业之星7',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1h': Product(
//    id: '1h',
//    originalName: '易捷通7',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1j': Product(
//    id: '1j',
//    originalName: '便利店7',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.NewRetail,
//  ),
//  '1m': Product(
//    id: '1m',
//    originalName: '易捷通8',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '18': Product(
//    id: '18',
//    originalName: '商云8',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1o': Product(
//    id: '1o',
//    originalName: '商贸王6',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1x': Product(
//    id: '1x',
//    originalName: '领鲜8',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.NewRetail,
//  ),
//  '1r': Product(
//    id: '1r',
//    originalName: '订货快',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.O2O,
//  ),
//  '1u': Product(
//    id: '1u',
//    originalName: '商云X',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.Business,
//  ),
//  '1y': Product(
//    id: '1y',
//    originalName: '入店营销',
//    typeID: '1',
//    eventID: '0',
//    defaultType: ProductType.O2O,
//  ),
////商锐
//  '1i': Product(
//    id: '1i',
//    originalName: '商锐8',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  '1k': Product(
//    id: '1k',
//    originalName: '商锐9',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  '1l': Product(
//    id: '1l',
//    originalName: '商鼎7',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  '1q': Product(
//    id: '1q',
//    originalName: '商锐9.5',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  '1t': Product(
//    id: '1t',
//    originalName: '商慧7',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  '1w': Product(
//    id: '1w',
//    originalName: '商锐9.7',
//    typeID: '8',
//    eventID: '1',
//    defaultType: ProductType.Business,
//  ),
//  //生鲜便利
//  '1n': Product(
//    id: '1n',
//    originalName: '便利店8',
//    typeID: 'Y',
//    eventID: '2',
//    defaultType: ProductType.NewRetail,
//  ),
//  '3j': Product(
//    id: '3j',
//    originalName: '秤心管家3',
//    typeID: 'Y',
//    eventID: '2',
//    defaultType: ProductType.NewRetail,
//  ),
//  '1s': Product(
//    id: '1s',
//    originalName: '便利店9',
//    typeID: 'Y',
//    eventID: '2',
//    defaultType: ProductType.NewRetail,
//  ),
//  '3u': Product(
//    id: '3u',
//    originalName: 'e店通',
//    showName: 'e店通10',
//    typeID: 'Y',
//    eventID: '2',
//    defaultType: ProductType.NewRetail,
//  ),
//  '3z': Product(
//    id: '3z',
//    originalName: '秤心管家8',
//    typeID: 'Y',
//    eventID: '2',
//    defaultType: ProductType.NewRetail,
//  ),
//  //专卖
//  '32': Product(
//    id: '32',
//    originalName: '连锁专卖6',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '34': Product(
//    id: '34',
//    originalName: '服装之星7',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '35': Product(
//    id: '35',
//    originalName: '服装之星5',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '36': Product(
//    id: '36',
//    originalName: '服装之星6',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '37': Product(
//    id: '37',
//    originalName: '烘焙系统7',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '38': Product(
//    id: '38',
//    originalName: '服装之星8',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '39': Product(
//    id: '39',
//    originalName: '烘焙7.5',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3a': Product(
//    id: '3a',
//    originalName: '专卖店7',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3b': Product(
//    id: '3b',
//    originalName: '医药之星5',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3c': Product(
//    id: '3c',
//    originalName: '医药之星6',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3d': Product(
//    id: '3d',
//    originalName: '医药之星7',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3e': Product(
//    id: '3e',
//    originalName: '烘焙之星8',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3f': Product(
//    id: '3f',
//    originalName: '专卖店8',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3g': Product(
//    id: '3g',
//    originalName: '服装通3',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3h': Product(
//    id: '3h',
//    originalName: '康利达专版',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3i': Product(
//    id: '3i',
//    originalName: '专卖店9',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3K': Product(
//    id: '3K',
//    originalName: '服装之星9',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3m': Product(
//    id: '3m',
//    originalName: '医药之星7.5',
//    typeID: '3',
//    eventID: '3',
//    defaultType: ProductType.Monopoly,
//  ),
//  '3o': Product(
//    id: '3o',
//    originalName: '烘焙之星9',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3p': Product(
//    id: '3p',
//    originalName: '孕婴童3',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3q': Product(
//    id: '3q',
//    originalName: '孕婴童专业版2017',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//    isHide: true,
//  ),
//  '3r': Product(
//    id: '3r',
//    originalName: '思迅报修系统',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//    isHide: true,
//  ),
//  '3s': Product(
//    id: '3s',
//    originalName: '专卖店10',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3t': Product(
//    id: '3t',
//    originalName: '烘焙之星10',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3v': Product(
//    id: '3v',
//    originalName: '服装之星10',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3w': Product(
//    id: '3w',
//    originalName: '扫码购',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  '3x': Product(
//    id: '3x',
//    originalName: '人脸识别',
//    typeID: '3',
//    eventID: '3',
//    type: 0,
//  ),
//  //餐饮
//  '21': Product(
//    id: '21',
//    originalName: '美世家-桑拿2.6',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '22': Product(
//    id: '22',
//    originalName: '美世家-快餐连锁',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '23': Product(
//    id: '23',
//    originalName: '美世家25',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '24': Product(
//    id: '24',
//    originalName: '美容美发',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '25': Product(
//    id: '25',
//    originalName: '美世家3',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '27': Product(
//    id: '27',
//    originalName: '美世家-易捷版',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '28': Product(
//    id: '28',
//    originalName: '美世家2',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2a': Product(
//    id: '2a',
//    originalName: '美世家4',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2b': Product(
//    id: '2b',
//    originalName: '美食通4',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2c': Product(
//    id: '2c',
//    originalName: '桑拿4',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2d': Product(
//    id: '2d',
//    originalName: '美世家客房3',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2e': Product(
//    id: '2e',
//    originalName: '快餐王5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2f': Product(
//    id: '2f',
//    originalName: '食通天5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2h': Product(
//    id: '2h',
//    originalName: '美食广场4',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2i': Product(
//    id: '2i',
//    originalName: '美食通5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2g': Product(
//    id: '2g',
//    originalName: '美世家客房4',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '26': Product(
//    id: '26',
//    originalName: '食通天6',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2j': Product(
//    id: '2j',
//    originalName: '快餐王6',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2k': Product(
//    id: '2k',
//    originalName: '快饮6',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2m': Product(
//    id: '2m',
//    originalName: '客房5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2n': Product(
//    id: '2n',
//    originalName: '快饮6.5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//    isHide: true,
//  ),
//  '2o': Product(
//    id: '2o',
//    originalName: '美食广场5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2q': Product(
//    id: '2q',
//    originalName: '食通天6.5',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '1c': Product(
//    id: '1c',
//    originalName: '美食家移动POS',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2t': Product(
//    id: '2t',
//    originalName: '扫码点菜',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2u': Product(
//    id: '2u',
//    originalName: '食通天8',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  '2w': Product(
//    id: '2w',
//    originalName: '微餐厅3.0',
//    typeID: '2',
//    eventID: '4',
//    type: 0,
//  ),
//  //星食客
//  '2p': Product(
//    id: '2p',
//    originalName: '星食客3(独立型门店)',
//    typeID: 'I',
//    eventID: '5',
//    type: 0,
//    isHide: true,
//  ),
//  '2r': Product(
//    id: '2r',
//    originalName: '星食客3(B/S总部)',
//    showName: '星食客3(总部)',
//    typeID: 'I',
//    eventID: '5',
//    type: 0,
//  ),
//  '2s': Product(
//    id: '2s',
//    originalName: '美食通+',
//    typeID: 'I',
//    eventID: '5',
//    type: 0,
//  ),
//  '2v': Product(
//    id: '2v',
//    originalName: '星食客3(实时型门店)',
//    showName: '星食客3(门店)',
//    typeID: 'I',
//    eventID: '5',
//    type: 0,
//  ),
//  //新零售
//  '3n': Product(
//    id: '3n',
//    originalName: '微商店2.0',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//  ),
//  '2l': Product(
//    id: '2l',
//    originalName: '微餐厅2.0',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//  ),
//  '1P': Product(
//    id: '1P',
//    originalName: '微POS',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//  ),
//  '9j': Product(
//    id: '9j',
//    originalName: '思迅Pay',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//  ),
//  '1v': Product(
//    id: '1v',
//    originalName: '自助收银',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//  ),
//  '1z': Product(
//    id: '1z',
//    originalName: '大屏营销',
//    typeID: 'C',
//    eventID: '6',
//    type: 0,
//    isHide: true,
//  ),
//  //eShop
//  '61': Product(
//    id: '61',
//    originalName: 'iShop专卖3',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//    isHide: true,
//  ),
//  '62': Product(
//    id: '62',
//    originalName: 'eShop服装4',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//    isHide: true,
//  ),
//  '63': Product(
//    id: '63',
//    originalName: 'eShop商业4',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//    isHide: true,
//  ),
//  '64': Product(
//    id: '64',
//    originalName: '美丽管家5',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//    isHide: true,
//  ),
//  '65': Product(
//    id: '65',
//    originalName: 'eShop商业5',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//  ),
//  '66': Product(
//    id: '66',
//    originalName: '小象称重5',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//  ),
//  '67': Product(
//    id: '67',
//    originalName: 'eShop服装5',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//    isHide: true,
//  ),
//  '68': Product(
//    id: '68',
//    originalName: '美丽管家5.5',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//  ),
//  '69': Product(
//    id: '69',
//    originalName: '考拉母婴6',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//  ),
//  '6a': Product(
//    id: '6a',
//    originalName: '移动管家',
//    typeID: '6',
//    eventID: '7',
//    type: 0,
//  ),
//  //思迅天店
//  '4a': Product(
//    id: '4a',
//    originalName: '零售标准版',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4b': Product(
//    id: '4b',
//    originalName: '零售星耀版',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4c': Product(
//    id: '4c',
//    originalName: '餐饮标准版',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4d': Product(
//    id: '4d',
//    originalName: '零售通定制版',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//    isHide: true,
//  ),
//  '4e': Product(
//    id: '4e',
//    originalName: '运营平台(内部)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//    isHide: true,
//  ),
//  '4f': Product(
//    id: '4f',
//    originalName: '零售标准版(安卓平板)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4g': Product(
//    id: '4g',
//    originalName: '零售星耀版(安卓平板)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4h': Product(
//    id: '4h',
//    originalName: '餐饮标准版(安卓平板)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4i': Product(
//    id: '4i',
//    originalName: '零售通定制版(安卓)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//    isHide: true,
//  ),
//  '4j': Product(
//    id: '4j',
//    originalName: '餐饮标准版(安卓手机)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4k': Product(
//    id: '4k',
//    originalName: '零售星耀版(安卓手机)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4l': Product(
//    id: '4l',
//    originalName: '零售标准版(安卓手机)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4m': Product(
//    id: '4m',
//    originalName: '零售标准版(手机iOS)',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4n': Product(
//    id: '4n',
//    originalName: '零售PC前台',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4o': Product(
//    id: '4o',
//    originalName: '零售安卓',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4p': Product(
//    id: '4p',
//    originalName: '手机助手',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//    isHide: true,
//  ),
//  '4q': Product(
//    id: '4q',
//    originalName: '餐饮PC前台',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4r': Product(
//    id: '4r',
//    originalName: '餐饮安卓',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4s': Product(
//    id: '4s',
//    originalName: '零售星耀PC前台',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//  '4t': Product(
//    id: '4t',
//    originalName: '零售星耀安卓',
//    typeID: 'J',
//    eventID: '8',
//    type: 0,
//  ),
//};
