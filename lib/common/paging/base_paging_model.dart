import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

/// 内部 有分页列表集合 的实体需要继承 BasePagingModel
class BasePagingModel<VM extends PageViewModel> {
  int? curPage;
  List<BasePagingItem>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  VM? vm;

  BasePagingModel({this.curPage, this.datas, this.offset, this.over,
    this.pageCount, this.size, this.total});

  void onDispose() {
    vm = null;
  }
}

/// 是分页列表 集合子项 实体需要继承 BasePagingItem
class BasePagingItem {}