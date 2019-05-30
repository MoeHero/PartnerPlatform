import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';

import '../Const.dart';

class SoftwareHidePage extends StatefulWidget {
  @override
  _SoftwareHidePageState createState() => _SoftwareHidePageState();
}

class _SoftwareHidePageState extends State<SoftwareHidePage> {
  @override
  Widget build(BuildContext context) {
    final _productList = Const.productMap.values.toList();
    SuspensionUtil.sortListBySuspensionTag(_productList);

    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: AzListView(
        data: _productList,
//        header: AzListViewHeader(
//          height: 40,
//          builder: (_) {
//            return Text('搜索');
//          },
//          tag: '搜索',
//        ),
        itemBuilder: (_, model) => _buildListItem(model),
      ),
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(Product model) {
    var susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: !model.isShowSuspension,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: 50,
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.visibility,
//                model.isHide ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
//                  model.isHide = !model.isHide;
                });
                print("hide: ${model.name}");
              },
            ),
            title: Text(model.name),
            trailing: Padding(
              padding: EdgeInsets.only(right: 10),
              child: DropdownButton(
                items: [
                  DropdownMenuItem(
                    child: Text('测试一二1'),
                  ),
                  DropdownMenuItem(
                    child: Text('测试一二2'),
                  ),
                  DropdownMenuItem(
                    child: Text('测试一二3'),
                  ),
                ],
                onChanged: (value) {},
              ),
            ),
          ),
        )
      ],
    );
  }
}
