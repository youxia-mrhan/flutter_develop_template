import 'base_view_model.dart';

class BaseModel<VM extends PageViewModel> {

  VM? vm;

  void onDispose() {
    vm = null;
  }
}