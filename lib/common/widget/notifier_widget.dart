import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_change_notifier.dart';
import 'package:flutter_develop_template/common/paging/paging_data_model.dart';
import '../../res/string/str_common.dart';
import 'package:flutter_develop_template/main/application.dart';

import '../mvvm/base_view_model.dart';
import '../paging/base_paging_model.dart';

enum NotifierResultType {
  // 不检查
  notCheck,

  // 加载中
  loading,

  // 请求成功
  success,

  // 这种属于请求成功，但业务不通过，比如没有权限
  unauthorized,

  // 请求异常
  dioError,

  // 未知异常
  fail,
}

class PageDataModel<T, L extends BasePagingModel> extends BaseChangeNotifier {
  // 完整的数据
  T? data;

  // 列表数据
  L? datas;

  // 当前页码
  int? curPage;

  // 总共多少页
  int? pageCount;

  // 当前页 数据数量
  int? size;

  // 总共 数据数量
  int? total;

  PagingDataModel? pagingDataModel;

  NotifierResultType type;

  String? errorMsg;

  // 是否有分页
  bool isPaging;

  PageDataModel({
    this.data,
    this.curPage = 0,
    this.pageCount = 0,
    this.size = 0,
    this.total = 0,
    this.pagingDataModel,
    this.type = NotifierResultType.loading,
    this.errorMsg,
    this.isPaging = false
  });

  /// 分页代码

  /// 这块是在继承 PageViewModel类 中使用的
  /// 刷新/加载更多 后，重新赋值最新的 分页数据
  void bindingPaging(
      PageViewModel currentPageViewModel,
      PageDataModel originalPageDataModel,
      PagingDataModel originalPagingDataModel,
      PageViewModel originalPageViewModel,
      ) {
    originalPageDataModel.pagingDataModel = originalPagingDataModel;
    originalPagingDataModel
      ..curPage = currentPageViewModel.pageDataModel?.curPage ?? 0
      ..pageCount = currentPageViewModel.pageDataModel?.pageCount ?? 0
      ..total = currentPageViewModel.pageDataModel?.total ?? 0
      ..size = currentPageViewModel.pageDataModel?.size ?? 0
      ..data = currentPageViewModel.pageDataModel
      ..listData.addAll((currentPageViewModel.pageDataModel?.data.datas as List<BasePagingItem>?) ?? [])
      ..pageDataModel = originalPageDataModel
      ..pageViewModel = originalPageViewModel;
  }


  /// 这块是在 请求接口方法里 中使用的
  /// 将请求的数据 分页数据，赋值给 PageDataModel
  void correlationPaging(PageViewModel pageViewModel, BasePagingModel data) {

    /// ViewModel 和 Model 相互持有
    data.vm = pageViewModel;
    pageViewModel.pageDataModel?.data = data;

    pageViewModel.pageDataModel?.curPage = data.curPage;
    pageViewModel.pageDataModel?.pageCount = data.pageCount;
    pageViewModel.pageDataModel?.size = data.size;
    pageViewModel.pageDataModel?.total = data.total;
  }
}

typedef NotifierPageWidgetBuilder<T extends BaseChangeNotifier> = Widget
    Function(BuildContext context, PageDataModel model);

/// 这个是配合 PageDataModel 类使用的
class NotifierPageWidget<T extends BaseChangeNotifier> extends StatefulWidget {
  NotifierPageWidget({
    super.key,
    required this.model,
    required this.builder,
  });

  /// 需要监听的数据观察类
  final PageDataModel? model;

  final NotifierPageWidgetBuilder builder;

  @override
  _NotifierPageWidgetState<T> createState() => _NotifierPageWidgetState<T>();
}

class _NotifierPageWidgetState<T extends BaseChangeNotifier>
    extends State<NotifierPageWidget<T>> {
  PageDataModel? model;

  /// 刷新UI
  refreshUI() => setState(() {
    model = widget.model;
  });

  /// 对数据进行绑定监听
  @override
  void initState() {
    super.initState();

    model = widget.model;

    // 先清空一次已注册的Listener，防止重复触发
    model?.removeListener(refreshUI);

    // 添加监听
    model?.addListener(refreshUI);
  }

  @override
  void didUpdateWidget(covariant NotifierPageWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      // 先清空一次已注册的Listener，防止重复触发
      oldWidget.model?.removeListener(refreshUI);

      model = widget.model;

      // 添加监听
      model?.addListener(refreshUI);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (model?.type == NotifierResultType.notCheck) {
      return widget.builder(context, model!);
    }

    if (model?.type == NotifierResultType.loading) {
      return Center(
        child: Text(StrCommon.loading),
      );
    }

    if (model?.type == NotifierResultType.success) {
      if (model?.data == null) {
        return Center(
          child: Text(StrCommon.dataIsEmpty),
        );
      }
      if(model?.isPaging ?? false) {
        var lists = model?.data?.datas as List<BasePagingItem>?;
        if(lists?.isEmpty ?? false){
          return Center(
            child: Text(StrCommon.listDataIsEmpty),
          );
        };
      }
      return widget.builder(context, model!);
    }

    if (model?.type == NotifierResultType.unauthorized) {
      return Center(
        child: Text('${StrCommon.businessDoesNotPass}：${model?.errorMsg}'),
      );
    }

    /// 异常抛出，会在终端会显示，可帮助开发阶段，快速定位异常所在，
    /// 但会阻断，后续代码执行，建议 非开发阶段 关闭
    if(EnvConfig.throwError) {
      throw Exception('${model?.errorMsg}');
    }

    if (model?.type == NotifierResultType.dioError) {
      return Center(
        child: Text('${StrCommon.dioErrorAnomaly}：${model?.errorMsg}'),
      );
    }

    if (model?.type == NotifierResultType.fail) {
      return Center(
        child: Text('${StrCommon.unknownAnomaly}：${model?.errorMsg}'),
      );
    }

    return Center(
      child: Text('${StrCommon.pleaseService}：${model?.errorMsg}'),
    );
  }

  @override
  void dispose() {
    widget.model?.removeListener(refreshUI);
    super.dispose();
  }
}

typedef NotifierValueWidgetBuilder<T extends BaseChangeNotifier> = Widget Function(BuildContext context, T? value);
/// 这个是配合 继承 BaseChangeNotifier 类使用的
class NotifierWidget<T extends BaseChangeNotifier> extends StatefulWidget {
  const NotifierWidget({
    super.key,
    required this.data,
    required this.builder,
  });

  /// 需要监听的数据观察类
  final T? data;

  final Widget Function(BuildContext, T?) builder;

  @override
  State<NotifierWidget<T>> createState() => _NotifierWidgetState<T>();
}

class _NotifierWidgetState<T extends BaseChangeNotifier>
    extends State<NotifierWidget<T>> {
  T? data;

  /// 刷新UI
  refreshState() => setState(() {
    data = widget.data;
  });

  /// 对数据进行绑定监听
  @override
  void initState() {
    super.initState();

    data = widget.data;

    // 先清空一次已注册的Listener，防止重复触发
    data?.removeListener(refreshState);

    // 添加监听
    data?.addListener(refreshState);
  }

  @override
  void didUpdateWidget(covariant NotifierWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      // 先清空一次已注册的Listener，防止重复触发
      oldWidget.data?.removeListener(refreshState);

      data = widget.data;

      // 添加监听
      data?.addListener(refreshState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Center(
        child: Text(StrCommon.loading),
      );
    }
    return widget.builder(context, data);
  }

  @override
  void dispose() {
    widget.data?.removeListener(refreshState);
    super.dispose();
  }
}