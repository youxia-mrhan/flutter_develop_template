import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/widget/notifier_widget.dart';
import 'package:flutter_develop_template/module/home/view_model/home_vm.dart';

import '../../../common/widget/global_notification_widget.dart';
import '../model/home_list_m.dart';

class HomeView extends BaseStatefulPage<HomeViewModel> {
  HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends BaseStatefulPageState<HomeView, HomeViewModel> {
  @override
  HomeViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return HomeViewModel()..viewState = this;
  }

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  void dispose() {
    assert((){
      debugPrint('HomeView.onDispose()');
      return true;
    }());
    super.dispose();
  }

  bool runSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert((){
      debugPrint('HomeView.didChangeDependencies --- $operate');
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

      viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
    }
  }

  ValueNotifier<int> tapNum = ValueNotifier<int>(0);

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        /// 局部刷新
        title: ValueListenableBuilder<int>(
          valueListenable: tapNum,
          builder: (context, value, _) {
            return Text(
              'Home：$value',
              style: TextStyle(fontSize: 20),
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                tapNum.value += 1;
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
              },
              icon: Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                // 如果你想刷新的时候，显示loading，加上这个两行
                viewModel?.pageDataModel?.type = NotifierResultType.loading;
                viewModel?.pageDataModel?.refreshState();

                viewModel?.requestData(params: {'curPage': Random().nextInt(20)});
              },
              icon: Icon(Icons.refresh_sharp))
        ],
      ),
      body: NotifierPageWidget<PageDataModel>(
          model: viewModel?.pageDataModel,
          builder: (context, dataModel) {
            final data = dataModel.data as HomeListModel?;
            if(data != null) {
              /// 延迟一帧
              WidgetsBinding.instance.addPostFrameCallback((_){
                /// 赋值、并替换 HomeListModel 内的tapNum，建立联系
                tapNum.value = data.pageCount ?? 0;
                data.tapNum = tapNum;
              });
            }
            return Stack(
              children: [
                ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: data?.datas?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text('${data?.datas?[index].title}'),
                      );
                    }),
                Container(
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
              ],
            );
          }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
