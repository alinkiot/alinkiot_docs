# 应用对接

## 1. 添加应用
- 1.通过帐号登录到管理后台。
- 2.选择 项目管理 -> 应用接入， 添加应用，获取 `appId` 和 `appSecret`


## 2. API 接口

### 2.1 获取鉴权Token
根据 `appid` 和 `appSecret` 获取 token。

#### 接口信息
**URL：** /iotapi/system/user/app/login
**方法：** POST
**类型：** application/json

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| appId | 是 | string | body | appId |
| appSecret | 是 | string | body | appSecret |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :--- | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| projectId | int | 是 | 参数说明 | 项目ID|
| token | string | 是 | 鉴权令牌 | 用于后续 API 调用的鉴权 |
| expire | int | 是 | 过期时间，单位秒 | 3600 |

#### 代码示例
```shell
curl -X POST "http://127.0.0.1/iotapi/system/user/app/login" \
     -H "accept: application/json" \
     -H "Content-Type: application/json" \
     -d "{\"appId\":\"xxxxxxx\", \"appSecret\":\"xxxxxxxxxxxxxx\"}"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "projectId":16,
    "token":"xxxxxxxx",
    "expire":3600
}
```


### 2.2 批量查询产品
产品定义了设备的一些上报属性、扩展字段以及设备使用的协议。通过获取设备的产品信息，能够知道设备上报的数据定义。。

#### 接口信息
**URL：** /iotapi/system/product/list
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| pageSize | 是 | int | query | 每页数量 |
| pageNum | 是 | int | query | 页码 |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| total | int | 是 | 总数量 | 16 |
| rows | array | 是 | 产品列表 | 产品信息列表 |

产品信息：
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| id | int | 是 | 产品ID | 1 |
| name | string | 是 | 产品名称 | 产品1 |
| pk | string | 是 | 产品主键 | xxxxxx |
| ps | string | 是 | 产品密钥 | xxxxxxxxxx |
| thing | string | 是 | 功能定义，JSON 字符串 | {} |
| status | string | 是 | 产品状态 | 0 |



#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/product/list?pageSize=10&pageNum=1" \
     -H "accept: application/json" \ 
     -H "token: xxxxxxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "total":16,
    "rows":[
        {
            "id":1,
            "name":"产品1",
            "pk":"xxxxxx",
            "ps":"xxxxxxxxxx",
            "thing":"{}",
            "status":"0"
        }
    ]
}
```

### 2.3 根据产品ID查询产品信息
根据产品 ID 查询产品信息。

#### 接口信息
**URL：** /iotapi/system/product/:ID
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| ID | 是 | int | path | 产品ID |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| data | object | 是 | 产品信息 | 产品详细信息, 见批量接口产品信息 |

#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/product/11" \
     -H "accept: application/json" \
     -H "token: xxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "data":{
        "id":11,
        "name":"产品1",
        "pk":"xxxxxx",
        "ps":"xxxxxxxxxx",
        "thing":"{}",
        "status":"0"
    }
}
```


### 2.4 批量查询设备
获取当前帐号的设备列表。

#### 接口信息
**URL：** /iotapi/system/device/list
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| pageSize | 是 | int | query | 每页数量 |
| pageNum | 是 | int | query | 页码 |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :--- | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| total | int | 是 | 总数量 | 16 |
| rows | array | 是 | 设备列表 | 设备信息列表 |

#### 设备信息：
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| id | int | 是 | 设备ID | 1 |
| addr | string | 是 | 设备地址 | 000001 |
| name | string | 是 | 设备名称 | 设备1 |
| dk | string | 是 | 设备密钥 | xxxxxxxxxx |
| ds | string | 是 | 设备密钥 | xxxxxxxxxx |
| project | string | 是 | 项目ID | 1 |
| product | string | 是 | 产品ID | 23 |
| status | string | 是 | 设备状态 | 0 |
| lat | float | 是 | 设备纬度 | 39.9042 |
| lng | float | 是 | 设备经度 | 116.4074 |



#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/device/list?pageSize=10&pageNum=1" \
     -H "accept: application/json" \ 
     -H "token: xxxxxxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "total":16,
    "rows":[
        {
            "id":1,
            "addr":"000001",
            "name":"设备1", 
            "dk":"xxxxxx",
            "ds":"xxxxxxxxxx",
            "project":"1",
            "product":"23",
            "status":"0",
            "lat":39.9042,
            "lng":116.4074
        }
    ]
}
```

### 2.5 根据设备ID查询设备信息
根据设备 ID 查询设备信息。

#### 接口信息
**URL：** /iotapi/system/device/:ID
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| ID | 是 | int | path | 设备ID |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| data | object | 是 | 设备信息 | 设备详细信息, 见批量接口设备信息 |

#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/device/11" \
     -H "accept: application/json" \
     -H "token: xxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "data":{
        "id":11,
        "addr":"000001",
        "name":"设备1", 
        "dk":"xxxxxx",
        "ds":"xxxxxxxxxx",
        "project":"1",
        "product":"23",
        "status":"0",
        "lat":39.9042,
        "lng":116.4074
    }
}
```



### 2.6 查询设备在线状态
根据设备地址查询设备在线状态。

#### 接口信息
**URL：** /iotapi/system/device/online
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| addr | 是 | string | query | 设备地址, 支持多个设备, 逗号分隔 |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| data | array | 是 | 在线设备列表 | 设备状态列表 |

#### 设备状态：
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :---: | :--- | :--- |
| addr | string | 是 | 设备地址 | 000001 |
| online | int | 是 | 设备状态 | 0: 不在线, 1: 在线 |


#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/device/online?addr=000001,000002" \
     -H "accept: application/json" \
     -H "token: xxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "data":[
        {
            "addr":"000001",
            "online":1
        },
        {
            "addr":"000002",
            "online":0
        }
    ]
}
```

### 2.7 查询设备实时数据
根据设备ID查询设备实时数据。

#### 接口信息
**URL：** /iotapi/system/device/history/last
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| addr | 是 | string | query | 设备地址, 支持多个设备, 逗号分隔 |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :--- | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| data | array | 是 | 设备实时数据, 根据功能定义返回 ||

#### 代码示例
```shell
curl -X GET "http://127.0.0.1/iotapi/system/device/history/last?addr=000001,000002" \
     -H "accept: application/json" \
     -H "token: xxxxxxxx"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "data":[
    ]
}
```

### 2.8 查询设备历史数据
根据设备地址查询设备历史数据。

#### 接口信息
**URL：** iotapi/system/history/list
**方法：** GET
**类型：** application/x-www-form-urlencoded

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| addr | 是 | string | query | 设备地址 |
| pageNum | 是 | int | query | 分页页码 |
| pageSize | 是 | int | query | 分页大小 |
| createTime[begin] | 是 | int | query | 开始时间，Unix 时间戳 |
| createTime[end] | 是 | int | query | 结束时间，Unix 时间戳 |
| orderBy[desc] | 否 | string | query | 排序字段 |
| orderBy[aes] | 否 | string | query | 排序字段 |
| step | 是 | int | query | 聚合时间，单位秒 |
| type | 是 | string | query | 返回数据类型, table: 以表格返回; chart: 以图表返回 |



#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :--- | :--- | :--- | :--- |
| code | string | 是 | 参数说明 | 状态码，200 表示成功 |
| msg | string | 否 | 消息说明 | 操作成功 |
| rows | array | 是 | 历史数据列表 | |

#### 代码示例
```shell
curl -X GET "https://127.0.0.1/iotapi/system/history/list?addr=xxxxxx&pageNum=1&pageSize=10&createTime%5Bbegin%5D=2024-12-02%2000%3A01%3A25&createTime%5Bend%5D=2024-12-02%2000%3A31%3A25&orderBy%5Bdesc%5D=createTime&step=30&type=table" \
    -H "accept: application/json" \
    -H "token: xxxxxxxx" \
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功",
    "rows":[
    ]
}
```


## 3. 应用实时对接
### 3.1 应用连接
通过 MQTT 订阅、发布模式，与 IOT 平台进行交互。
- 1.通过 `获取鉴权Token` 接口获取 Token、projectId。
- 2.通过以下 MQTT 配置，进行 MQTT 连接。（random 为随机数，用于多个客户端连接）

| 字段名 | 值 | 说明 |
| :--- | :--- | :--- |
| clientid | app_${appid}_${random}  | 客户端ID |
| username | ${appid}  | 用户名 |
| password | ${token}  | 密码 |

- 3.连接成功后，订阅以下 topic。

| Topic | 说明 |
| :--- | :--- |
| `app/in/${projectId}/${appid}`  | 收到同步消息时调用API接口进行同步 |
| `s/out/${projectid}/${sceneid}/${addr}`  | 获取平台告警、上下线、上行消息 |
| `s/out/${projectid}/#`  | 获取平台告警、上下线、上行消息 |


### 3.2 数据更新事件
当设备基础数据有变化时，应用会收到如下同步事件：

#### 3.2.1 基础数据（设备、产品）
```json
{  
    "msgType": "sync",  
    "data": {   
        "event": "syncBaseData"  
    }
}
```

#### 3.2.2 设备状态同步
```json
{  
    "msgType": "sync",  
    "data": {   
        "event": "syncDeviceStatus"  
    }
}
```

#### 3.2.3 应用回复状态
当应用收到同步事件后，开始调用API接口同步数据，并向下面的Topic根据同步状态回复给平台。

Topic: `s/in/${appid}`
```json
{  
    "msgType": "sync",  
    "data": {   
        "status": "doing"  
    }
}
```
| 状态 |  值 | 说明 |
| :---: | :--- | :--- |
| 正在同步 | `doing` | 开始同步前回复 |
| 同步成功 | `success` | 同步完成后回复 |
| 同步失败 | `failed` | 同步失败后回复 |

### 3.3 实时数据接收
订阅如下 Topic 会收到如下消息。
- `s/out/${project}/#`
- `s/out/${projectid}/${sceneid}/${addr}`

#### 3.3.1 设备上报数据
```json
{
  "msgType": "deviceData",
  "addr": "JG2024PD08",
  "data": {
    "time": 1765887962,
    "data": {
      "ts": 1765887962,
      "alarm_rule": "",
      "value": {
        "value": 5213.9,
        "ts": 1765887962
      },
      "DVOLT": {
        "value": 12489,
        "ts": 1765887962
      },
      "DBAT_GZ": {
        "value": 99,
        "ts": 1765887962
      },
      "CQS_GZ": {
        "value": 100,
        "ts": 1765887962
      }
    }
  }
}
```

### 3.3.2 设备下线消息
```json
{
  "msgType": "deviceEvent",
  "data": {
    "time": 1765888594,
    "status": "0",
    "reason": "keepalive_timeout",
    "addr": "JG2024PD08"
  }
}
```

### 3.3.3 设备上线事件
```json
{
  "msgType": "deviceEvent",
  "data": {
    "time": 1765888599,
    "status": "1",
    "addr": "JG2024PD08"
  }
}
```

### 3.3.4 设备告警事件
```json
{
    "msgType": "deviceAlarm",
    "data": {
        "time": 1765951302,
        "addr": "JG2024PD08",
        "data": {
            "type": "alarm", 
            "wrongInfos": [
                {
                    "thing": {
                        "unit": "mm",
                        "type": "float",
                        "title": "测量数据",
                        "rate": 1,
                        "name": "value",
                        "icon": "直尺",
                        "formula": {
                            "name": "hayl_jg"
                        },
                        "access": "read"
                    },
                    "stat": {
                        "value": 5213.9,
                        "ts": 1765951302
                    },
                    "name": "value",
                    "condition": {
                        "value": "5213.9",
                        "operate": "==",
                        "name": "value"
                    }
                }
            ],
            "stat": {
                "value": {
                    "value": 5213.9,
                    "ts": 1765951302
                },
                "ts": 1765951302
            },
            "rule": {
                "id": 27,
                "type": "1", // 0:事件，1:告警
                "level": "1", // 级别
                "project": 1,
                "product": 128,                
                "name": "测距告警", // 标题
                "groupId": 2,
                "notifyType": "[\"site\",\"sms\",\"app\",\"wechat\"]"，
                "content": "11111" // 内容               
            }
        }
    }
}
```

### 3.3.5 设备告警恢复
```json
{
  "msgType": "deviceAlarm",
  "data": {
    "addr": "JG2024PD08",
    "time": 1765952488,
    "data": {
      "type": "recover",
      "stat": {
        "value": {
          "value": 15213.9,
          "ts": 1765952488
        },
        "ts": 1765952488
      },
      "rule": {
        "type": "1",
        "rule": {
          "relation": "or",
          "conditions": [
            {
              "value": "5213.9",
              "operate": "==",
              "name": "value"
            }
          ],
          "children": []
        },
        "project": 1,
        "product": 128,
        "notifyType": "[\"site\",\"sms\",\"app\",\"wechat\"]",
        "name": "测距",
        "level": "1",
        "id": 27,
        "groupId": 2,
        "content": "11111"
      }
    }
  }
}
```


