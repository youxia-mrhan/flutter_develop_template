import 'package:flutter/material.dart';
import 'package:flutter_develop_template/common/mvvm/base_view_model.dart';

/// 定义ViewModelWidget基类
abstract class BaseViewModelStatefulWidget<VM extends BaseViewModel> extends StatefulWidget {
  BaseViewModelStatefulWidget({super.key});

  @override
  BaseViewModelStatefulWidgetState<BaseViewModelStatefulWidget, VM> createState();
}

/// 定义ViewModelState
abstract class BaseViewModelStatefulWidgetState<T extends StatefulWidget, VM extends BaseViewModel> extends State<T> {

}
