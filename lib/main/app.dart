import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import '../../router/page_route_observer.dart';
import '../../router/routers.dart';
import 'package:flutter_develop_template/common/widget/global_notification_widget.dart';
import 'package:flutter_develop_template/module/message/view/message_v.dart';

import '../../res/style/color_styles.dart';
import '../../res/style/theme_styles.dart';
import '../module/home/view/home_v.dart';
import '../module/order/view/order_v.dart';
import '../module/personal/view/personal_v.dart';

/// App初始化的第一个页面可能是 其他页面，比如 广告、引导页、登陆页面
enum AppInitState {
  /// 是App主体页面
  isAppMainPage,

  /// 不是主体页面
  noAppMainPage
}

/// 全局key
/// 获取全局context方式：navigatorKey.currentContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 这个对象 可以获取当前设配信息
MediaQueryData? media;

/// 监听全局路由，比如获取 当前路由栈里 页面总数
PageRouteObserver? pageRouteObserver;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    /// 初始化 MediaQuery、PageRouteObserver
    media ??= MediaQuery.of(context);
    pageRouteObserver ??= PageRouteObserver();

    return GlobalOperateProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [pageRouteObserver!],
        // 全局key
        navigatorKey: navigatorKey,
        // 使用路由找不到页面时，就会执行 onGenerateRoute
        onGenerateRoute: Routers.router.generator,
        theme: ThemeStyles.defaultTheme,
        // PopScope：监听返回键
        home: PopScope(
            // WillPopScope 3.16中过时，使用PopScope替换
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }

              // 这里使用 Navigator.of(context).pop(); 是无效的
              // 使用SystemNavigator.pop() 或者 exit()

              // SystemNavigator.pop()：用于在导航堆栈中弹出最顶层的页面，并在导航堆栈为空时退出应用程序
              // 平台兼容性：如果你只用Flutter做Android应用，优先使用 SystemNavigator.pop() 来退出应用程序。

              // exit()：直接终止应用程序的运行。
              // 平台兼容性：适用于所有平台（Android、iOS等）

              // 写逻辑代码
              // ...

              exit(0); // 退出应用
            },
            child: AppTransfer(
              initState: AppInitState.isAppMainPage,
            )),
      ),
    );
  }
}

/// 这个是用来中转的，比如初始化第一个启动的页面 可能是 广告、引导页、登陆页面，之后再从这些页面进入 App主体页面
class AppTransfer extends StatelessWidget {
  const AppTransfer({super.key, required this.initState});

  final AppInitState initState;

  @override
  Widget build(BuildContext context) {
    Widget child; // MaterialApp
    switch (initState) {
      case AppInitState.isAppMainPage:
        {
          // 先判断是否登陆
          // ... ...
          child = AppMainPage();
        }
        break;
      default:
        // 进入 广告、引导页 等等，再从这些页面进入 App首页
        child = AppMainPage();
    }
    return child;
  }
}

/// 这是App主体页面，主要是 PageView + BottomNavigationBar
class AppMainPage extends BaseStatefulPage {
  AppMainPage({super.key});

  @override
  AppMainPageState createState() => AppMainPageState();
}

class AppMainPageState extends BaseStatefulPageState<AppMainPage,AppMainPageViewModel> {

  PageController? pageController;

  @override
  void initAttribute() {
    pageController ??= PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void initObserver() {

  }

  @override
  AppMainPageViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return AppMainPageViewModel()..viewState = this;
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  void pageChanged(int index) {
    bottomSelectedIndex = index;
  }

  void bottomTap(int index) {
    bottomSelectedIndex = index;
    pageController?.jumpToPage(index);
    setState(() {});
  }

  int bottomSelectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
      BottomNavigationBarItem(icon: Icon(Icons.add_chart), label: 'Order'),
      BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Personal'),
    ];
  }

  Widget buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(), // 禁止滑动
      controller: pageController,
      onPageChanged: pageChanged,
      children: <Widget>[
        HomeView(),
        MessageView(),
        OrderView(),
        PersonalView(),
      ],
    );
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 自适应宽度，但同时会失去，图标/文字 缩放效果
        currentIndex: bottomSelectedIndex,
        onTap: bottomTap,
        items: buildBottomNavBarItems(),
        unselectedItemColor: ColorStyles.color_1E88E5, // 未选中状态下的颜色
        unselectedFontSize: 14, // 未选中状态下的字体大小
        selectedItemColor: ColorStyles.color_EA5034, // 选中状态下的颜色
        selectedFontSize: 14, // 选中状态下的字体大小
      ),
    );
  }

}

class AppMainPageViewModel extends PageViewModel<AppMainPageState> {

  @override
  onCreate() {

  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}
