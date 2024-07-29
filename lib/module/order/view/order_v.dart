import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import '../../../../res/string/str_order.dart';
import '../../../../router/routers.dart';
import '../../../../router/navigator_util.dart';
import '../../../../res/string/str_common.dart';
import '../../../../res/style/color_styles.dart';
import '../../../../res/style/text_styles.dart';
import '../../../common/widget/global_notification_widget.dart';
import '../view_model/order_vm.dart';

class OrderView extends BaseStatefulPage {
  OrderView({super.key});

  @override
  OrderViewState createState() => OrderViewState();
}

class OrderViewState extends BaseStatefulPageState<OrderView, OrderViewModel> {
  late TestParamsModel paramsModel;

  @override
  void initAttribute() {
    paramsModel = TestParamsModel(
      name: 'jk',
      title: '张三',
      url: 'https://www.baidu.com',
      age: 99,
      price: 9.9,
      flag: true,
    );
  }

  @override
  void initObserver() {}

  @override
  OrderViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return OrderViewModel()..viewState = this;
  }

  bool executeSwitchLogin = false;

  @override
  void didChangeDependencies() {
    var operate = GlobalOperateProvider.getGlobalOperate(context: context);

    assert(() {
      debugPrint('PersonalView.didChangeDependencies --- $operate');
      return true;
    }());

    if (operate == GlobalOperate.switchLogin) {
      executeSwitchLogin = true;
      // 重新请求数据
      // viewModel.requestData();
    }
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        title: Text(
          StrOrder.order,
          style: TextStyles.style_222222_20,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    /// 传递 非对象参数 方式
                    /// 在path后面，使用 '?' 拼接，再使用 '&' 分割

                    String name = 'jk';

                    /// Invalid argument(s): Illegal percent encoding in URI
                    /// 出现这个异常，说明相关参数，需要转码一下
                    /// 当前举例：中文、链接
                    String title = Uri.encodeComponent('张三');
                    String url = Uri.encodeComponent('https://www.baidu.com');

                    int age = 99;
                    double price = 9.9;
                    bool flag = true;

                    /// 注意：使用 path拼接方式 传递 参数，会改变原来的 路由页面 Path
                    /// path会变成：/pageA?name=jk&title=%E5%BC%A0%E4%B8%89&url=https%3A%2F%2Fwww.baidu.com&age=99&price=9.9&flag=true
                    /// 所以再次匹配pageA，找不到，需要还原一下，getOriginalPath(path)
                    NavigatorUtil.push(context,
                            '${Routers.pageA}?name=$name&title=$title&url=$url&age=$age&price=$price&flag=$flag')
                        .then((result) {
                      assert(() {
                        debugPrint('PageA Pop的返回值：$result');
                        return true;
                      }());
                    });
                  },
                  child: Text(StrOrder.noObjectToPageA),
                ),
                ElevatedButton(
                  onPressed: () {
                    NavigatorUtil.push(
                      context,
                      Routers.pageB,
                      arguments: TestParamsModel(
                        name: 'jk',
                        title: '张三',
                        url: 'https://www.baidu.com',
                        age: 99,
                        price: 9.9,
                        flag: true,
                      ),
                    ).then((result) {
                      assert(() {
                        debugPrint('PageB Pop的返回值：$result');
                        return true;
                      }());
                    });
                  },
                  child: Text(StrOrder.objectToPageB),
                ),
                ElevatedButton(
                  child: Text("上报 同步异常"),
                  onPressed: pushSyncError,
                ),
                ElevatedButton(
                  child: Text("上报 异步异常"),
                  onPressed: pushAsyncError,
                )
              ],
            ),
          ),
          Container(
            color: ColorStyles.color_388E3C,
            child: executeSwitchLogin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(StrCommon.executeSwitchUser),
                      IconButton(
                          onPressed: () {
                            executeSwitchLogin = false;
                            setState(() {});
                          },
                          icon: Icon(Icons.close))
                    ],
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  /// 上报 同步异常
  pushSyncError() {
    DateTime today = new DateTime.now();
    String dateSlug = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}:${today.second.toString().padLeft(2, '0')}";
    throw Exception("$dateSlug:发生 同步异常");
  }

  /// 上报 异步异常
  pushAsyncError() async {
    DateTime today = new DateTime.now();
    String dateSlug = "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} ${today.hour.toString().padLeft(2, '0')}:${today.minute.toString().padLeft(2, '0')}:${today.second.toString().padLeft(2, '0')}";
    await Future.delayed(Duration(seconds: 1));
    throw Exception("$dateSlug:发生 异步异常");
  }

  @override
  bool get wantKeepAlive => true;

}

class TestParamsModel {
  String? name;
  String? title;
  String? url;
  int? age;
  double? price;
  bool? flag;

  TestParamsModel({
    this.name,
    this.title,
    this.url,
    this.age,
    this.price,
    this.flag,
  });

  @override
  String toString() {
    return 'TestParamsModel{name: $name, title: $title, url: $url, age: $age, price: $price, flag: $flag}';
  }
}
