import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/common/router/navigator_util.dart';
import 'package:flutter_develop_template/main/app.dart';

import '../../common/router/routers.dart';

class PageAView extends BaseStatefulPage {
  PageAView(
      {super.key,
      this.name,
      this.title,
      this.url,
      this.age,
      this.price,
      this.flag});

  final String? name;
  final String? title;
  final String? url;
  final int? age;
  final double? price;
  final bool? flag;

  @override
  PageAViewState createState() => PageAViewState();
}

class PageAViewState extends BaseStatefulPageState<PageAView, PageAViewModel> {

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  PageAViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PageAViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageA'),
      ),
      body: SizedBox(
        width: media!.size.width,
        height: media!.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('name：${widget.name}'),
            Text('title：${widget.title}'),
            Text('url：${widget.url}'),
            Text('age：${widget.age}'),
            Text('price：${widget.price}'),
            Text('flag：${widget.flag}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.push(context, Routers.pageC, replace: true);
              },
              child: Text('前往PageC，并销毁当前页面'),
            ),
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.push(context, Routers.pageD);
              },
              child: Text('路由拦截 从PageA前往PageD'),
            ),
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.back(context, arguments: '我是PageA页的Pop返回值');
              },
              child: Text('返回上一页'),
            ),
          ],
        ),
      ),
    );
  }

}

class PageAViewModel extends PageViewModel {

  PageAViewState? state;

  @override
  onCreate() {
    state = viewState as PageAViewState;
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}
