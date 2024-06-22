/// 这里统一写全局，非动态、固定的 字符串文本
/// 如果哪一天 项目突然要求 使用 国际化
/// 直接将这里的内容，拷贝到 国际化插件生成的 映射文件中，再 对照中文 翻译成 指定语言
class Strings {

  ///--------------------------- 通用 -------------------------------
  static const String pleaseService = '请联系客服';
  static const String platformNotAdapted = '当前平台未适配';
  static const String executeSwitchUser = '执行了切换用户操作';

  static const String loading = '加载中...';
  static const String dataIsEmpty = '数据为空';
  static const String listDataIsEmpty = '列表数据为空';
  static const String businessDoesNotPass = '业务不通过';
  static const String dioErrorAnomaly = 'dioError异常';
  static const String unknownAnomaly = '未知异常';

  static const String pullDownToRefresh = '下拉刷新';
  static const String refreshing = '刷新中...';
  static const String loadedSuccess = '加载成功';
  static const String releaseToRefreshImmediately = '松开立即刷新';
  static const String refreshFailed = '刷新失败';
  static const String pullUpLoad = '上拉加载';
  static const String letGoLoading = '松手开始加载数据';
  static const String failedLoad = '加载失败';
  static const String noMoreData = '没有更多数据了';

  static const String connectionTimeout = '连接超时';
  static const String sendTimeout = '发送超时';
  static const String receiveTimeout = '接收超时';
  static const String accessCertificateError = '访问证书错误';
  static const String validationFailed = '验证失败';
  static const String connectionIsAbnormal = '连接异常';
  static const String unknownError = '未知错误';

  static const String parameterIsIncorrect = '参数有误';
  static const String illegalRequests = '非法请求';
  static const String serverRejectsRequest = '服务器拒绝请求';
  static const String accessAddressDoesNotExist = '访问地址不存在';
  static const String requestIsMadeWrongWay = '请求方式错误';
  static const String wasAnErrorInsideServer = '服务器内部出错了';
  static const String invalidRequest = '无效的请求';
  static const String serverIsBusy = '服务器繁忙';
  static const String unsupportedHttpProtocol = '不支持的HTTP协议';

  ///--------------------------- 首页 -------------------------------
  static const String home = 'Home';


  ///--------------------------- 消息 -------------------------------
  static const String message = 'Message';


  ///--------------------------- 订单 -------------------------------
  static const String order = 'Order';
  static const String noObjectToPageA = '携带 非对象类型 前往PageA';
  static const String objectToPageB = '携带 对象类型 前往PageB';


  ///--------------------------- 个人 -------------------------------
  static const String personal = 'Personal';
  static const String register = '注册';
  static const String switchUser = '切换用户';
  static const String loginSuccess = '登陆成功';
  static const String registerSuccess = '注册成功';
  static const String welcome = '欢迎您';
  static const String login = '登陆';


  ///--------------------------- 测试路由 -------------------------------
  static const String pageA = 'PageA';
  static const String pageB = 'PageB';
  static const String pageC = 'PageC';
  static const String pageD = 'PageD';

  static const String toPageCDestroyCurrent = '前往PageC，并销毁当前页面';
  static const String routeInterceptFromPageAtoPageD = '路由拦截 从PageA前往PageD';
  static const String backPreviousPage = '返回上一页';
  static const String toPageD = '前往PageD';
  static const String toHomeDestroyAll = '前往首页，并销毁所有页面';


}