import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

import '../../../../res/string/str_common.dart';
import '../../../../router/navigator_util.dart';

class PageA2View extends BaseStatefulPage {
  PageA2View(
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
  PageA2ViewState createState() => PageA2ViewState();
}

class PageA2ViewState extends BaseStatefulPageState<PageA2View, PageA2ViewModel> {

  @override
  void initAttribute() {}

  @override
  void initObserver() {}

  @override
  PageA2ViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PageA2ViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(StrCommon.pageA2),
      ),
      body: SizedBox(
        width: media.size.width,
        height: media.size.height,
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
                NavigatorUtil.back(context, arguments: '我是PageA2页的Pop返回值');
              },
              child: Text(StrCommon.backPreviousPage),
            ),
          ],
        ),
      ),
    );
  }

}

class PageA2ViewModel extends PageViewModel<PageA2ViewState> {

  @override
  onCreate() {

  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }
}
