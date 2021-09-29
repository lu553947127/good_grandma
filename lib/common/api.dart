
///服务service
class Api {

  static String baseUrl() {
    /// 外网
    // return 'http://47.100.191.162';
    /// 本地测试服务器
    return 'http://172.167.40.141:1888';
    // return 'http://tmdapp.yicp.top:36530';
  }

  ///密码登录
  static const loginPassword =
      "/api/hap-auth/oauth/token";

  ///我的请求列表(我申请的)
  static const sendList =
      "/api/hap-workflow/process/sendList";

  ///待办列表(我审批的)
  static const todoList =
      "/api/hap-workflow/process/todoList";

  ///我的抄送列表(知会我的)
  static const copyList =
      "/api/hap-workflow/process/copyList";

  ///办结列表(暂时不用)
  static const doneList =
      "/api/hap-workflow/process/doneList";

  ///可发起流程列表
  static const processList =
      "/api/hap-workflow/process/processList";

  ///发起流程
  static const startProcess =
      "/api/hap-workflow/process/startProcess";

  ///获取流程表单
  static const getFormByProcessId =
      "/api/hap-workflow/process/getFormByProcessId";

  ///获取流程详情
  static const processDetail =
      "/api/hap-workflow/process/detail";

  ///获取流程驳回/同意
  static const completeTask =
      "/api/hap-workflow/process/completeTask";

  ///上传附件
  static const putFile =
      "/api/hap-resource/oss/endpoint/put-file";

  ///拜访计划列表
  static const visitPlanList =
      "/api/hap-app1/app/visitplan/list";

  ///拜访计划新增
  static const visitPlanAdd=
      "/api/hap-app1/app/visitplan/submit";

  ///市场物料列表
  static const materialList =
      "/api/hap-app1/app/material/list";

  ///市场物料不分页列表
  static const materialListNoPage =
      "/api/hap-app1/app/material/noPagingList";

  ///市场物料添加
  static const materialAdd=
      "/api/hap-app1/app/material/submit";

  ///市场物料详情
  static const materialDetail =
      "/api/hap-app1/app/material/detail";

  ///获取区域列表
  static const deptTreeList =
      "/api/hap-app1/app/system/getDeptListDeptId";

  ///获取下级区域列表
  static const deptNextList =
      "/api/hap-app1/app/system/getNextDept";

  ///获取部门名称
  static const getDeptName =
      "/api/hap-app1/app/system/getDeptName";

  ///客户拜访列表
  static const customerVisitList=
      "/api/hap-app1/app/visitplan/customerVisitList";

  ///客户拜访新增
  static const customerVisitAdd=
      "/api/hap-app1/app/visitplan/customerVisitSave";

  ///客户列表
  static const customerList=
      "/api/hap-app1/app/user/areaUser";

  ///员工列表
  static const userList=
      "/api/hap-app1/app/user/areaSaleUsers";

  ///冰柜销量列表
  static const freezerSalesList =
      "/api/hap-app3/app/freezer/freezerSales";

  ///冰柜销量货物统计列表
  static const freezerCargoDetail =
      "/api/hap-app3/app/freezer/cargoDetail";

  ///冰柜统计列表
  static const freezerList =
      "/api/hap-app3/app/freezer/list";

  ///文件柜列表
  static const fileCabinetList =
      "/api/hap-app1/app/file/selectFileFolder";

  ///创建文件夹
  static const fileAdd =
      "/api/hap-app1/app/file/add";

  ///文件夹重命名
  static const fileChangeName =
      "/api/hap-app1/app/file/change";

  ///文件夹删除
  static const fileDelete =
      "/api/hap-app1/app/file/deleteof";

  ///文件夹复制
  static const fileCopy =
      "/api/hap-app1/app/file/copyAdd";

  ///上传文件到文件夹
  static const fileAddFile =
      "/api/hap-app1/app/file/fileAdd";

  ///市场活动列表
  static const activityList =
      "/api/hap-app1/app/activity/list";

  ///市场活动 行销规划列表
  static const activityPlanList=
      "/api/hap-app1/app/activity/planList";

  ///市场活动添加
  static const activityAdd =
      "/api/hap-app1/app/activity/submit";

  ///商品销量统计列表
  static const commoditySalesList =
      "/api/hap-app1/app/goods/getCommoditySales";

  ///报修列表
  static const getFreezerRepairList =
      "/api/hap-app3/app/freezerRepair/getFreezerRepairList";

  ///签到
  static const signAdd =
      "/api/hap-apptony/app/sign/signAdd";

  ///签到统计
  static const signList =
      "/api/hap-apptony/app/sign/signList";

  ///规章文件
  static const regularDocList =
      "/api/hap-app3/app/manage/list";

  ///消息
  static const getCategoryCount =
      "/api/hap-app3/app/notice/getCategoryCount";

  ///公告list
  static const getNoticeCategoryList =
      "/api/hap-app3/app/notice/getNoticeCategoryList";

  ///消息已读
  static const settingRead =
      "/api/hap-app3/app/notice/settingRead";

  ///客户库存list
  static const customerStockList =
      "/api/hap-app3/app/customerStock/list";

  ///库存商品list
  static const customerStockGoodsList =
      "/api/hap-app3/app/goods/goodsListStock";

  ///商品list
  static const goodsList =
      "/api/hap-app3/app/goods/goodsList";

  ///新增库存
  static const customerStockAdd =
      "/api/hap-app3/app/customerStock/addStock";

  ///库存detail
  static const customerStockDetail =
      "/api/hap-app3/app/customerStock/detail";

  ///获取用户信息
  static const getUserInfoById =
      "/api/hap-app/app/user/loginUser";

  ///修改用户信息
  static const updateUser =
      "/api/hap-app3/app/user/updateUser";

  ///修改登录密码
  static const restPassword =
      "/api/hap-app3/app/user/restPassword";

  ///关于我们
  static const getAbout =
      "/api/hap-app3/app/about/getAbout";

  ///报告列表
  static const reportList =
      "/api/hap-apptony/app/report/reportList";

  ///提交日报
  static const reportDayAdd =
      "/api/hap-apptony/app/report/reportDayAdd";

  ///提交week报
  static const reportWeekAdd =
      "/api/hap-apptony/app/report/reportWeekAdd";

  ///提交Month报
  static const reportMonthAdd =
      "/api/hap-apptony/app/report/reportMonthAdd";

  ///报告详情 参数 id  type：1日报2周报3月报
  static const reportDayDetail =
      "/api/hap-apptony/app/report/reportDayDetail";

  ///区域选择
  static const regionList =
      "/api/hap-apptony/app/report/regionList";

  ///筛选下级员工
  static const reportUserList =
      "/api/hap-apptony/app/report/userList";

  ///客户反馈
  static const feedback =
      "/api/hap-app3/app/feedback/save";

  ///轨迹查询
  static const trajectoryList =
      "/api/hap-apptony/app/trajectory/trajectoryList";

  ///下单
  static const orderAdd =
      "/api/hap-apptony/app/order/orderAdd";

  ///订单列表
  static const orderList =
      "/api/hap-apptony/app/order/orderList";

  ///订单detail
  static const orderDetail =
      "/api/hap-apptony/app/order/orderDetail";

  ///订单Confirm
  static const orderConfirm =
      "/api/hap-apptony/app/order/orderConfirm";

  ///feedbackType
  static const feedbackType =
      "/api/hap-system3/dict/dictionary?code=feedback_type";

  ///业绩统计
  static const selectContractStatistics =
      "/api/hap-app1/app/contract/selectContractStatistics";

  ///查询下级所有业绩总和
  static const selectSaleSubordinate =
      "/api/hap-app1/app/contract/selectSaleSubordinate";

  ///业务人员统计每个月业绩
  static const selectSaleMonthStatistics =
      "/api/hap-app1/app/contract/selectSaleMonthStatistics";

  ///客户统计每个月业绩
  static const selectMonthStatistics =
      "/api/hap-app1/app/contract/selectMonthStatistics";
}