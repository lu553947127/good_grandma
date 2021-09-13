
///服务service
class Api {

  static String baseUrl() {
    /// 外网
    // return 'http://47.100.191.162';
    /// 本地测试服务器
    return 'http://172.167.40.141:1888';
  }

  ///密码登录
  static const loginPassword = "/api/hap-auth/oauth/token";

  ///我的请求列表(我申请的)
  static const sendList = "/api/hap-workflow/process/sendList";

  ///待办列表(我审批的)
  static const todoList = "/api/hap-workflow/process/todoList";

  ///我的抄送列表(知会我的)
  static const copyList = "/api/hap-workflow/process/copyList";

  ///办结列表(暂时不用)
  static const doneList = "/api/hap-workflow/process/doneList";

  ///可发起流程列表
  static const processList = "/api/hap-workflow/process/processList";

  ///发起流程
  static const startProcess = "/api/hap-workflow/process/startProcess";

  ///获取流程表单
  static const getFormByProcessId = "/api/hap-workflow/process/getFormByProcessId";

  ///获取流程详情
  static const processDetail = "/api/hap-workflow/process/detail";

  ///获取流程驳回/同意
  static const completeTask = "/api/hap-workflow/process/completeTask";

  ///上传附件
  static const putFile = "/api/hap-resource/oss/endpoint/put-file";


  ///拜访计划列表
  static const visitPlanList = "/api/hap-app/app/visitplan/list";

  ///冰柜销量列表
  static const freezerSalesList = "/api/hap-app3/app/freezer/freezerSales";

  ///冰柜销量货物统计列表
  static const freezerCargoDetail = "/api/hap-app3/app/freezer/cargoDetail";

  ///冰柜统计列表
  static const freezerList = "/api/hap-app3/app/freezer/list";
}