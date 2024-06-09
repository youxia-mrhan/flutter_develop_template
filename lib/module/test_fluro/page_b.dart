import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_page.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';
import 'package:flutter_develop_template/main/app.dart';
import '../../common/router/navigator_util.dart';
import '../../common/router/routers.dart';
import '../order/view/order_v.dart';

class PageBView extends BaseStatefulPage {
  PageBView({super.key, this.paramsModel});

  final TestParamsModel? paramsModel;

  @override
  PageBViewState createState() => PageBViewState();

}

class PageBViewState extends BaseStatefulPageState<PageBView,PageBViewModel> {

  @override
  void initAttribute() {

  }

  @override
  void initObserver() {

  }

  @override
  PageBViewModel viewBindingViewModel() {
    /// ViewModel 和 View 相互持有
    return PageBViewModel()..viewState = this;
  }

  @override
  Widget appBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageB'),
      ),
      body: SizedBox(
        width: media!.size.width,
        height: media!.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('name：${widget.paramsModel?.name}'),
            Text('title：${widget.paramsModel?.title}'),
            Text('url：${widget.paramsModel?.url}'),
            Text('age：${widget.paramsModel?.age}'),
            Text('price：${widget.paramsModel?.price}'),
            Text('flag：${widget.paramsModel?.flag}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.push(context,Routers.pageD);
              },
              child: Text('前往PageD'),
            ),
            ElevatedButton(
              onPressed: () {
                NavigatorUtil.back(context,arguments: widget.paramsModel);
              },
              child: Text('返回上一页'),
            ),
          ],
        ),
      ),
    );
  }

}

class PageBViewModel extends PageViewModel{

  PageBViewState? state;

  @override
  onCreate() {
    state = viewState as PageBViewState;
  }

  @override
  Future<PageViewModel?> requestData({Map<String, dynamic>? params}) {
    return Future.value(null);
  }

}
