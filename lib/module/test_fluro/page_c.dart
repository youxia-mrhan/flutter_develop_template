import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

import '../../common/router/navigator_util.dart';
import '../../common/router/routers.dart';
import '../../main/app.dart';

class PageCView extends BaseStatefulPage {
  PageCView({super.key});

  @override
  PageCViewState createState() => PageCViewState();
}

class PageCViewState extends BaseStatefulPageState<PageCView,PageCViewModel> {

  @override
  void initAttribute() {

  }

  @override
  void initObserver() {

  }

  @override
  PageCViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PageCViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageC'),
      ),
      body: SizedBox(
        width: media!.size.width,
        height: media!.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.push(context,Routers.pageD,replace:true);
              },
              child: Text('前往PageD'),
            ),
          ],
        ),
      ),
    );
  }

}

class PageCViewModel extends PageViewModel {

  PageCViewState? state;

  @override
  onCreate() {
    state = viewState as PageCViewState;
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}
