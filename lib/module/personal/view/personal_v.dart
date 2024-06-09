import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/widget/global_notification_widget.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/main/app.dart';
import 'package:flutter_develop_template/module/personal/model/user_info_m.dart';

import '../../../common/util/global.dart';
import '../view_model/personal_vm.dart';

class PersonalView extends BaseStatefulPage {
  PersonalView({super.key});

  @override
  PersonalViewState createState() => PersonalViewState();
}

class PersonalViewState extends BaseStatefulPageState<PersonalView, PersonalViewModel> {
  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PersonalViewModel()..viewState = this;
  }

  bool runSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('OrderView.didChangeDependencies --- $operate');
      return true;
    }());

    if (operate == GlobalOperate.switchLogin) {
      runSwitchLogin = true;
      // 重新请求数据
      // viewModel.requestData();
    }
  }

  @override
  Widget appBuild(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayBlackStyle,
      child: Material(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: kToolbarHeight + media!.padding.top),
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('注册'),
                  onPressed: () {
                    // 如果你想刷新的时候，显示loading，加上这个两行
                    viewModel?.pageDataModel?.type = NotifierResultType.loading;
                    viewModel?.pageDataModel?.refreshState();

                    var str1 = Random().nextInt(9);
                    var str2 = Random().nextInt(9);
                    var str3 = Random().nextInt(9);
                    var str4 = Random().nextInt(9);
                    var str5 = Random().nextInt(9);
                    viewModel?.registerUser(params: {
                      'username': '${str1}${str2}${str3}${str4}${str5}',
                      'password': '123456',
                      'repassword': '123456'
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: kToolbarHeight + media!.padding.top + 100),
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('登陆'),
                  onPressed: () {
                    // 如果你想刷新的时候，显示loading，加上这个两行
                    viewModel?.pageDataModel?.type = NotifierResultType.loading;
                    viewModel?.pageDataModel?.refreshState();

                    viewModel?.loginUser(params: {
                      'username': 'aaaaaa',
                      'password': '123456',
                    });
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: kToolbarHeight + media!.padding.top + 200),
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('切换用户'),
                  onPressed: () {
                    // 更新本地存储的用户ID，（常用的本地存储库：shared_preferences）
                    // ... ...

                    // 通知所有继承 BaseStatefulPageState 的子页面
                    GlobalOperateProvider.runGlobalOperate(context: context, operate: GlobalOperate.switchLogin);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kToolbarHeight + media!.padding.top),
              color: Colors.green,
              child: runSwitchLogin
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('执行了切换用户操作'),
                  IconButton(
                      onPressed: () {
                        runSwitchLogin = false;
                        setState(() {});
                      },
                      icon: Icon(Icons.close))
                ],
              )
                  : SizedBox(),
            ),
            _myAppBar(),
          ],
        ),
      ),
    );
  }

  _myAppBar() {
    return Container(
      width: media!.size.width,
      height: kToolbarHeight + media!.padding.top,
      padding: EdgeInsets.only(top: media!.padding.top,left: 16),
      color: AppBarTheme.of(context).backgroundColor,
      alignment: Alignment.centerLeft,
      child: Builder(
        builder: (context) {
          /// 初始化状态设置为 不检查，不然会 返回 loading 组件
          viewModel?.pageDataModel?.type = NotifierResultType.notCheck;
          return NotifierPageWidget<PageDataModel>(
              model: viewModel?.pageDataModel,
              builder: (context, dataModel) {
              final data = dataModel.data as UserInfoModel?;
              String title = (data?.isLogin ?? false) ? '登陆成功：${data?.username} 欢迎您' : '注册成功：${data?.username} 欢迎您';
              return Text(
                (data?.username?.isEmpty ?? true) ?'Personal' : title,
                style: TextStyle(fontSize: 20),
              );
            }
          );
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}