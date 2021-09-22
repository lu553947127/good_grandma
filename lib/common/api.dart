
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

  ///拜访计划新增
  static const visitPlanAdd= "/api/hap-app/app/visitplan/submit";

  ///市场物料列表
  static const materialList = "/api/hap-app/app/material/list";

  ///市场物料添加
  static const materialAdd= "/api/hap-app/app/material/submit";

  ///市场物料详情
  static const materialDetail = "/api/hap-app/app/material/detail";

  ///获取区域列表
  static const deptTreeList = "/api/hap-app/app/system/getDeptListDeptId";

  ///获取下级区域列表
  static const deptNextList = "/api/hap-app/app/system/getNextDept";

  ///客户拜访列表
  static const customerVisitList= "/api/hap-app/app/visitplan/customerVisitList";

  ///客户拜访新增
  static const customerVisitAdd= "/api/hap-app/app/visitplan/customerVisitSave";

  ///客户列表
  static const customerList= "/api/hap-app/app/user/areaUser";

  ///冰柜销量列表
  static const freezerSalesList = "/api/hap-app3/app/freezer/freezerSales";

  ///冰柜销量货物统计列表
  static const freezerCargoDetail = "/api/hap-app3/app/freezer/cargoDetail";

  ///冰柜统计列表
  static const freezerList = "/api/hap-app3/app/freezer/list";
  ///报修列表
  static const getFreezerRepairList = "/api/hap-app3/app/freezerRepair/getFreezerRepairList";
  ///签到
  static const signAdd = "/api/hap-apptony/app/sign/signAdd";
  static const signList = "/api/hap-apptony/app/sign/signList";
  ///规章文件
  static const regularDocList = "/api/hap-app3/app/manage/list";
  ///消息
  static const getCategoryCount = "/api/hap-app3/app/notice/getCategoryCount";
  ///公告list
  static const getNoticeCategoryList = "/api/hap-app3/app/notice/getNoticeCategoryList";
  ///消息已读
  static const settingRead = "/api/hap-app3/app/notice/settingRead";
  ///客户库存list
  static const customerStockList = "/api/hap-app3/app/customerStock/list";
  ///商品list
  static const customerStockGoodsList = "/api/hap-app3/app/customerStock/goodsList";
  ///新增库存
  static const customerStockAdd = "/api/hap-app3/app/customerStock/addStock";
  ///库存detail
  static const customerStockDetail = "/api/hap-app3/app/customerStock/detail";
  ///获取用户信息
  static const getUserInfoById = "/api/hap-app/app/user/loginUser";
  ///报告列表
  static const reportList = "/api/hap-apptony/app/report/reportList";
}