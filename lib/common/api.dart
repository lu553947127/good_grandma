///服务service
class Api {
  static String baseUrl() {
    /// 外网
    // return 'http://47.100.191.162';
    // return 'https://haoapo.haoapochn.cn/';
    /// 本地测试服务器
      return 'http://172.167.40.141:1888';
    ///宁哥服务器
    // return 'http://172.167.40.77:1888';
    ///周芾服务器
    // return 'http://172.167.40.110:1888';
  }

  /** 登录相关 **/

  ///密码登录
  static const loginPassword = "/api/hap-auth/oauth/token";

  ///通过手机号获取验证码
  static const getCode = "/api/hap-app/app/phone/verify";

  ///重置密码
  static const forgetPassword = "/api/hap-app/app/phone/restPassword";


  /** 首页相关 **/

  ///首页扫码解析数据
  static const analysisCode = "/api/hap-app/app/freezer/analysisCode";

  ///首页菜单列表
  static const homepageList = "/api/hap-app/app/menu/homepageList";

  ///应用菜单列表
  static const appMenuTree = "/api/hap-app/app/menu/appMenuTree";

  ///版本升级
  static const upgrade = "/api/hap-app/app/system/app";


  /** 消息相关 **/

  ///消息数量
  static const getCategoryCount = "/api/hap-app/app/notice/getCategoryCount";

  ///公告list
  static const getNoticeCategoryList = "/api/hap-app/app/notice/getNoticeCategoryList";

  ///消息已读
  static const settingRead = "/api/hap-app/app/notice/settingRead";


  /** 拜访计划相关 **/

  ///拜访计划列表
  static const visitPlanList = "/api/hap-app/app/visitplan/list";

  ///拜访计划新增
  static const visitPlanAdd = "/api/hap-app/app/visitplan/submit";


  /** 客户拜访相关 **/

  ///客户拜访列表
  static const customerVisitList = "/api/hap-app/app/visitplan/customerVisitList";

  ///客户拜访新增
  static const customerVisitAdd = "/api/hap-app/app/visitplan/customerVisitSave";

  ///客户拜访编辑
  static const customerVisitEdit = "/api/hap-app/app/visitplan/customerVisitEdit";


  /** 工作报告相关 **/

  ///报告列表
  static const reportList = "/api/hap-app/app/report/reportList";

  ///提交日报
  static const reportDayAdd = "/api/hap-app/app/report/reportDayAdd";

  ///提交week报
  static const reportWeekAdd = "/api/hap-app/app/report/reportWeekAdd";

  ///提交Month报
  static const reportMonthAdd = "/api/hap-app/app/report/reportMonthAdd";

  ///报告详情 参数 id  type：1日报2周报3月报
  static const reportDayDetail = "/api/hap-app/app/report/reportDayDetail";

  ///工作报告草稿列表
  static const reportDraftList = "/api/hap-app/app/report/reportDraft";


  /** 市场物料相关 **/

  ///市场物料列表
  static const materialList = "/api/hap-app/app/materialArea/list";

  ///市场物料不分页选择列表
  static const materialNoPageList = "/api/hap-app/app/materialArea/areaMaterial";

  ///市场物料出入库列表
  static const materialDetailsList = "/api/hap-app/app/materialArea/areaDetailsList";

  ///市场物料出入库新增
  static const materialAdd = "/api/hap-app/app/materialArea/areaDetailsAdd";

  ///市场物料详情
  static const materialDetail = "/api/hap-app/app/material/detail";


  /** 市场活动相关 **/

  ///市场活动列表
  static const activityList = "/api/hap-app/app/activity/list";

  ///市场活动详情
  static const activityDetail = "/api/hap-app/app/activity/detail";

  ///市场活动 行销规划列表
  static const activityPlanList = "/api/hap-app/app/activity/planList";

  ///市场活动添加
  static const activityAdd = "/api/hap-app/app/activity/submit";

  ///市场活动编辑
  static const activityEdit = "/api/hap-app/app/activity/update";


  /** 报修相关 **/

  ///报修列表
  static const getFreezerRepairList = "/api/hap-app/app/freezerRepair/getFreezerRepairList";


  /** 签到相关 **/

  ///签到
  static const signAdd = "/api/hap-app/app/sign/signAdd";

  ///签到统计
  static const signList = "/api/hap-app/app/sign/signList";


  /** 规章文件相关 **/

  ///规章文件
  static const regularDocList = "/api/hap-app/app/manage/list";

  ///规章文件已读
  static const regularDocRead = "/api/hap-app/app/manage/read";


  /** 订单相关 **/

  ///订单列表
  static const orderList = "/api/hap-app/app/order/orderList";

  ///订单detail
  static const orderDetail = "/api/hap-app/app/order/orderDetail";

  ///订单Confirm
  static const orderConfirm = "/api/hap-app/app/order/orderConfirm";

  ///订单审核驳回接口 参数id :订单id status：0；审核 5：驳回 6:二级客户取消订单  reject：驳回意见
  static const orderSh = "/api/hap-app/app/order/orderSh";

  ///订单专用商品list
  static const cusList = "/api/hap-app/app/order/cusList";

  ///下单
  static const orderAdd = "/api/hap-app/app/order/orderAdd";


  /** 冰柜订单 **/

  ///冰柜订单列表
  static const freezerOrderList = "/api/hap-app/app/freezerOrder/getFreezerOrderList";

  ///冰柜订单新增
  static const freezerOrderSave = "/api/hap-app/app/freezerOrder/save";

  ///冰柜品牌字典
  static const freezer_brand = "/api/hap-system/dict/dictionaryPid?code=freezer_brand";

  ///冰柜品牌字典
  static const freezer_model = "/api/hap-system/dict/dictionaryPid?code=freezer_brand&pid=";

  ///冰柜订单取消订单
  static const freezerOrderCancel = "/api/hap-app/app/freezerOrder/cancel";

  ///冰柜订单确认收货
  static const freezerOrderOver = "/api/hap-app/app/freezerOrder/over";


  /** 物料订单 **/

  ///物料订单列表
  static const materialOrderList = "/api/hap-app/app/materialRequisition/list";

  ///物料订单选择列表
  static const materialSelectList = "/api/hap-app/app/material/material_no_paging";

  ///物料订单添加
  static const materialOrderAdd = "/api/hap-app/app/materialRequisition/save";

  ///物料订单入库
  static const materialOrderWarehousing = "/api/hap-app/app/materialRequisition/warehousing";

  ///物料订单编辑
  static const materialOrderEdit = "/api/hap-app/app/materialRequisition/edit";


  /** 审批申请 **/

  ///我的请求列表(我申请的)
  static const sendList = "/api/hap-workflow/process/sendList";

  ///待办列表(我审批的 未审批)
  static const todoList = "/api/hap-workflow/process/todoList";

  ///待办列表(我的已办)
  static const myDoneList = "/api/hap-workflow/process/myDoneList";

  ///我的抄送列表(知会我的)
  static const copyList = "/api/hap-workflow/process/copyList";

  ///办结列表(暂时不用)
  static const doneList = "/api/hap-workflow/process/doneList";

  ///可发起流程列表
  static const processList = "/api/hap-workflow/process/processList";

  ///获取下级OA分类列表
  static const categoryList = "/api/hap-workflow/design/category/list";

  ///发起流程
  static const startProcess = "/api/hap-workflow/process/startProcess";

  ///获取流程表单
  static const getFormByProcessId = "/api/hap-workflow/process/getFormByProcessId";

  ///获取流程详情
  static const processDetail = "/api/hap-workflow/process/detail";

  ///获取流程驳回/同意
  static const completeTask = "/api/hap-workflow/process/completeTask";

  ///委托
  static const delegateTask = "/api/hap-workflow/process/delegateTask";

  ///转办
  static const transferTask = "/api/hap-workflow/process/transferTask";

  ///抄送多选人员列表
  static const sendSelectUser = "/api/hap-user/search/user";


  /** 商品销量统计 **/

  ///商品销量统计列表
  static const commoditySalesList = "/api/hap-app/app/goods/getCommoditySales";


  /** 业绩统计 **/

  ///业绩统计
  static const selectContractStatistics = "/api/hap-app/app/contract/selectContractStatistics";

  ///查询下级所有业绩总和
  static const selectSaleSubordinate = "/api/hap-app/app/contract/selectSaleSubordinate";

  ///业务人员统计每个月业绩
  static const selectSaleMonthStatistics = "/api/hap-app/app/contract/selectSaleMonthStatistics";

  ///客户统计每个月业绩
  static const selectMonthStatistics = "/api/hap-app/app/contract/selectMonthStatistics";


  /** 行动轨迹 **/

  ///轨迹查询
  static const trajectoryList = "/api/hap-app/app/trajectory/trajectoryList";


  /** 报告统计 **/

  ///报告统计
  static const reportTj = "/api/hap-app/app/report/reportTj";

  ///报告统计详情列表
  static const reportTjDetail = "/api/hap-app/app/report/reportTjDetail";


  /** 冰柜销量 **/

  ///冰柜销量列表
  static const freezerSalesList = "/api/hap-app/app/freezer/freezerSales";

  ///冰柜销量货物统计列表
  static const freezerCargoDetail = "/api/hap-app/app/freezer/cargoDetail";


  /** 客户库存 **/

  ///客户库存list
  static const customerStockList = "/api/hap-app/app/customerStock/list";

  ///库存商品list
  static const customerStockGoodsList = "/api/hap-app/app/goods/goodsListStock";

  ///商品list
  static const goodsList = "/api/hap-app/app/goods/goodsList";

  ///新增库存
  static const customerStockAdd = "/api/hap-app/app/customerStock/addStock";

  ///库存detail
  static const customerStockDetail = "/api/hap-app/app/customerStock/detail";


  /** 冰柜统计 **/

  ///冰柜统计列表
  static const freezerList = "/api/hap-app/app/freezer/list";


  /** 电子合同 **/

  ///注册电子合同账号
  static const registerContract = "/api/hap-app/app/contract/register";

  ///判断是否注册eqb
  static const isEqbContract = "/api/hap-app/app/contract/isEqb";

  ///电子合同列表
  static const contractList = "/api/hap-app/app/contract/contractList";

  ///电子合同签署h5链接
  static const contractSignUrl = "/api/hap-app/app/contract/getSignUrl";


  /** 文件柜 **/

  ///文件柜列表
  static const fileCabinetList = "/api/hap-app/app/file/selectFileFolder";

  ///创建文件夹
  static const fileAdd = "/api/hap-app/app/file/add";

  ///文件夹重命名
  static const fileChangeName = "/api/hap-app/app/file/change";

  ///文件夹删除
  static const fileDelete = "/api/hap-app/app/file/deleteof";

  ///文件夹复制
  static const fileCopy = "/api/hap-app/app/file/copyAdd";

  ///上传文件到文件夹
  static const fileAddFile = "/api/hap-app/app/file/fileAdd";


  /** 我的 **/

  ///获取用户信息
  static const getUserInfoById = "/api/hap-app/app/user/loginUser";

  ///修改用户信息
  static const updateUser = "/api/hap-app/app/user/updateUser";

  ///修改登录密码
  static const restPassword = "/api/hap-app/app/user/restPassword";

  ///关于我们
  static const getAbout = "/api/hap-app/app/about/getAbout";

  ///客户反馈
  static const feedback = "/api/hap-app/app/feedback/save";

  ///获取登录人可以开通的账户类型
  static const customerType = "/api/hap-app/app/user/customerType";

  ///开通账户
  static const openCustomer = "/api/hap-app/app/user/openCustomer";

  ///开通账号用户岗位信息
  static const allPostUserId = "/api/hap-app/app/user/allPostUserId";

  ///我的报单
  static const myOrderList = "/api/hap-app/app/order/myOrderList";


  /** 公共接口 **/

  ///上传附件
  static const putFile = "/api/hap-resource/oss/endpoint/put-file";

  ///所属角色列表
  static const roleCustomer = "/api/hap-app/app/user/roleCustomer";

  ///获取区域列表
  static const deptTreeList = "/api/hap-app/app/system/getDeptListDeptId";

  ///获取下级区域列表
  static const deptNextList = "/api/hap-app/app/system/getNextDept";

  ///登录人所有岗位信息
  static const allPost = "/api/hap-app/app/user/allPost";

  ///区域选择
  static const regionList = "/api/hap-app/app/report/regionList";

  ///获取部门名称
  static const getDeptName = "/api/hap-app/app/system/getDeptName";

  ///客户列表
  static const customerList = "/api/hap-app/app/user/areaUser";

  ///客户拜访新客户列表
  static const customerNewList = "/api/hap-app/app/visitplan/customerNewList";

  ///员工列表
  static const userList = "/api/hap-app/app/user/areaSaleUsers";

  ///筛选下级员工
  static const reportUserList = "/api/hap-app/app/report/userList";

  ///获取全部客户列表
  static const allUser = "/api/hap-app/app/user/allUser";

  ///获取城市经理列表
  static const allCsjlUser = "/api/hap-app/app/user/allCsjlUser";

  ///经销商性质字典
  static const natureType = "/api/hap-app/app/dict/dictionary?code=nature_type";

  ///经销商级别字典
  static const customer_type = "/api/hap-app/app/dict/dictionary?code=customer_type";

  ///反馈类别词典
  static const feedbackType = "/api/hap-system/dict/dictionary?code=feedback_type";
}