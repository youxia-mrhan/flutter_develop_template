import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/widget/refresh_load_widget.dart';
import 'package:flutter_develop_template/module/message/model/message_list_m.dart';
import 'package:flutter_develop_template/module/message/view_model/message_vm.dart';

import '../../../common/widget/global_notification_widget.dart';
import '../../../common/widget/notifier_widget.dart';

class MessageView extends BaseStatefulPage {
  MessageView({super.key});

  @override
  MessageViewState createState() => MessageViewState();
}

class MessageViewState extends BaseStatefulPageState<MessageView, MessageViewModel> {

  @override
  MessageViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return MessageViewModel()..viewState = this;
  }

  @override
  void initAttribute() {

  }

  @override
  void initObserver() {}

  @override
  void dispose() {
    assert((){
      debugPrint('MessageView.onDispose()');
      return true;
    }());
    super.dispose();
  }

  bool runSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('MessageView.didChangeDependencies --- $operate');
      return true;
    }());

    // 切换用户
    // 正常业务流程是：从本地存储，拿到当前最新的用户ID，请求接口，我这里偷了个懒 😄
    // 直接使用随机数，模拟 不同用户ID
    if (operate == GlobalOperate.switchLogin) {
      runSwitchLogin = true;

      // 重新请求数据
      // 如果你想刷新的时候，显示loading，加上这个两行
      viewModel?.pageDataModel?.type = NotifierResultType.loading;
      viewModel?.pageDataModel?.refreshState();

      viewModel?.pagingDataModel?.listData.clear();
      viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
    }
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppBarTheme.of(context).backgroundColor,
          title: Text(
            'Message',
            style: TextStyle(
              fontSize: 20,
            ),
          )),
      body: NotifierPageWidget<PageDataModel>(
        model: viewModel?.pageDataModel,
        builder: (context, dataModel) {
          final dataList = dataModel.pagingDataModel?.listData;
          return Stack(
            children: [
              RefreshLoadWidget(
                pagingDataModel: dataModel.pagingDataModel!,
                scrollView: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: dataList?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = dataList?[index] as Datas;
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: Colors.black
                                )
                            )
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text('${data.title}'),
                      );
                    }),
              ),
              Container(
                color: Colors.green,
                child: runSwitchLogin ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('执行了切换用户操作'),
                    IconButton(onPressed: (){
                      runSwitchLogin = false;
                      setState(() {});
                    }, icon: Icon(Icons.close))
                  ],
                ) : SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
