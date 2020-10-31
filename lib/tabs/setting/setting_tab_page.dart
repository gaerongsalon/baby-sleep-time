import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';

class SettingTabPage extends StatefulWidget {
  const SettingTabPage({Key key}) : super(key: key);

  @override
  _SettingTabPageState createState() => _SettingTabPageState();
}

class _SettingTabPageState extends State<SettingTabPage>
    with AutomaticKeepAliveClientMixin<SettingTabPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container();
  }
}
