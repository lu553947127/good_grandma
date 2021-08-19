
class WorkText {
  static List<Map> listWork = [
    {
      'title': '工作',
      'list':[
        {
          "image":"assets/images/ic_work_1.png",
          "name":"拜访计划",
        },
        {
          "image":"assets/images/ic_work_2.png",
          "name":"客户拜访",
        },
        {
          "image":"assets/images/ic_work_3.png",
          "name":"工作报告",
        },
        {
          "image":"assets/images/ic_work_4.png",
          "name":"市场物料",
        },
        {
          "image":"assets/images/ic_work_5.png",
          "name":"市场活动",
        },
        {
          "image":"assets/images/ic_work_6.png",
          "name":"报修",
        },
        {
          "image":"assets/images/ic_work_7.png",
          "name":"签到",
        },
        {
          "image":"assets/images/ic_work_8.png",
          "name":"规章文件",
        }
      ]
    },
    {
      'title': '订货订单',
      'list':[
        {
          "image":"assets/images/ic_work_9.png",
          "name":"一级订单",
        },
        {
          "image":"assets/images/ic_work_10.png",
          "name":"二级订单",
        }
      ]
    },
    {
      'title': '审批流程',
      'list':[
        {
          "image":"assets/images/ic_work_11.png",
          "name":"审批申请",
        }
      ]
    },
    {
      'title': '费用管理',
      'list':[
        {
          "image":"assets/images/ic_work_12.png",
          "name":"营销费用申请",
        },
        {
          "image":"assets/images/ic_work_13.png",
          "name":"营销费用核销",
        },
        {
          "image":"assets/images/ic_work_14.png",
          "name":"客户对账",
        }
      ]
    },
    {
      'title': '统计分析',
      'list':[
        {
          "image":"assets/images/ic_work_15.png",
          "name":"商品销量统计",
        },
        {
          "image":"assets/images/ic_work_16.png",
          "name":"业绩统计",
        },
        {
          "image":"assets/images/ic_work_17.png",
          "name":"拜访统计",
        },
        {
          "image":"assets/images/ic_work_18.png",
          "name":"行动轨迹",
        },
        {
          "image":"assets/images/ic_work_19.png",
          "name":"报告统计",
        },
        {
          "image":"assets/images/ic_work_20.png",
          "name":"冰柜销量",
        },
        {
          "image":"assets/images/ic_work_21.png",
          "name":"客户库存",
        },
        {
          "image":"assets/images/ic_work_22.png",
          "name":"冰柜统计",
        }
      ]
    },
    {
      'title': '合同管理',
      'list':[
        {
          "image":"assets/images/ic_work_23.png",
          "name":"电子合同",
        }
      ]
    },
    {
      'title': '企业文件柜',
      'list':[
        {
          "image":"assets/images/ic_work_24.png",
          "name":"企业文件柜",
        }
      ]
    }
  ];


  static var examine = {
    'labelPosition': 'left',
    'labelSuffix': '：',
    'labelWidth': 120,
    'gutter': 0,
    'menuBtn': true,
    'submitBtn': true,
    'submitText': '提交',
    'emptyBtn': true,
    'emptyText': '清空',
    'menuPosition': 'center',
    'column': [
      {
        'type': 'date',
        'label': '日期',
        'span': 12,
        'display': true,
        'format': 'yyyy-MM-dd',
        'valueFormat': 'yyyy-MM-dd',
        'prop': '1627871021462_70086',
        'value': 'Date.now()'
      },
      {
        'type': 'input',
        'label': '申请人',
        'span': 12,
        'display': true,
        'prop': '1627871072643_66617',
        'value': 'applyUser'
      },
      {
        'type': 'select',
        'label': '费用类型',
        'cascaderItem': [],
        'span': 24,
        'display': true,
        'props': {
          'label': 'label',
          'value': 'value'
        },
        'prop': '1627871108560_41410',
        'dicUrl': '/api/xxxxx',
        'required': true,
        'rules': [
          {
            'required': true,
            'message': '请选择费用类型'
          }
        ]
      },
      {
        'type': 'input',
        'label': '主旨',
        'span': 24,
        'display': true,
        'prop': '1627871137349_94316'
      },
      {
        'type': 'textarea',
        'label': '说明',
        'span': 24,
        'display': true,
        'prop': '1627871147439_92417'
      },
      {
        'type': 'upload',
        'label': '附件',
        'span': 24,
        'display': true,
        'showFileList': true,
        'multiple': true,
        'limit': 10,
        'propsHttp': {
          'res': 'data',
          'name': 'fileName',
          'url': 'link'
        },
        'canvasOption': {},
        'prop': '1627871318233_8530',
        'action': '/api/xxxxx',
        'required': true,
        'rules': [
          {
            'required': true,
            'message': '附件必须填写'
          }
        ]
      },
      {
        'type': 'dynamic',
        'label': '子表单',
        'span': 24,
        'display': true,
        'children': {
          'align': 'center',
          'headerAlign': 'center',
          'index': false,
          'addBtn': true,
          'delBtn': true,
          'column': [
            {
              'type': 'input',
              'label': '表单名称',
              'span': 24,
              'display': true,
              'prop': '1627871356926_66525'
            },
            {
              'type': 'input',
              'label': '上传人',
              'span': 24,
              'display': true,
              'prop': '1627871372269_52233'
            }
          ]
        },
        'prop': '1627871353960_85737'
      }
    ]
  };
}