
///api服务service
class Api {

  ///本地测试服务器
  static String baseUrl() {
    return 'http://172.167.40.141:1888';
  }

  ///密码登录
  static const loginPassword = "/api/hap-auth/oauth/token";

  ///待办列表
  static const todoList = "/api/hap-workflow/process/todoList";

  ///我的请求列表
  static const sendList = "/api/hap-workflow/process/sendList";

  ///办结列表
  static const doneList = "/api/hap-workflow/process/doneList";

  ///可发起流程列表
  static const processList = "/api/hap-workflow/process/processList";

  ///获取流程表单
  static const getFormByProcessId = "/api/hap-workflow/process/getFormByProcessId";

  ///上传附件
  static const putFile = "/hap-resource/oss/endpoint/put-file";
}