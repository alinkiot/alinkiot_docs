# 应用对接

## 接入概述

平台面向第三方应用提供 **HTTP REST API + MQTT 实时推送** 两种对接方式：REST API 用于数据查询与同步，MQTT 用于实时接收设备上报、上下线、告警等消息。

```
行业应用
  │
  ├── REST API（数据同步、设备查询）─────────► alinkiot 平台
  │                                                ▲
  └── MQTT 订阅（实时数据推送）◄──────────── 设备上报数据
```

> 设备侧（MQTT / TCP 设备）如何接入，参见 [设备接入](device.md)。

## 1. 添加应用
- 1.通过帐号登录到管理后台。
- 2.选择 项目管理 -> 应用接入， 添加应用，获取 `appId` 和 `appSecret`


## 2. API 接口

### 2.1 获取鉴权Token
根据 `appid` 和 `appSecret` 获取 token。

#### 接口信息
- URL： /iotapi/system/user/app/login
- 方法： POST
- 类型： application/json

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
- URL： /iotapi/system/product/list
- 方法： GET
- 类型： application/x-www-form-urlencoded

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

#### 产品信息：
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
- URL： /iotapi/system/product/:ID
- 方法： GET
- 类型： application/x-www-form-urlencoded

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
- URL： /iotapi/system/device/list
- 方法： GET
- 类型： application/x-www-form-urlencoded

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
- URL： /iotapi/system/device/:ID
- 方法： GET
- 类型： application/x-www-form-urlencoded

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
- URL： /iotapi/system/device/online
- 方法： GET
- 类型： application/x-www-form-urlencoded

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
- URL： /iotapi/system/device/history/last
- 方法： GET
- 类型： application/x-www-form-urlencoded

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
- URL： /iotapi/system/history/list
- 方法： GET
- 类型： application/x-www-form-urlencoded

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


### 2.9 下发设备控制指令
向指定设备下发物模型「写」指令（如开关、参数设置等）。

> 说明：平台收到请求后组装物模型写消息，并通过内部 MQTT（`p/in/<addr>`）下发给设备。设备在线才会真正到达；设备离线时接口仍返回成功，但指令不会下发。

#### 接口信息
- URL： /iotapi/system/control/device
- 方法： POST
- 类型： application/json

#### 请求参数
| 参数名 | 是否必须 | 类型 | 位置 | 说明 |
| :--- | :---: | :---: | :---: | :--- |
| token | 是 | string | header | 鉴权令牌 |
| addr | 是 | string | query | 设备地址 |
| msgType | 是 | string | body | 固定为 `control_device` |
| name | 是 | string | body | 物模型变量名，需为该设备产品物模型中可写（`access` 为 `rw`/`write`）的属性 |
| value | 是 | - | body | 下发值，类型需与物模型属性一致（string / int / float） |

#### 响应参数
| 字段名 | 类型 | 是否必填 | 说明 | 示例值 |
| :--- | :---: | :--- | :--- | :--- |
| code | string | 是 | 状态码，200 表示成功 | 200 |
| msg | string | 否 | 消息说明 | 操作成功 |

#### 代码示例
```shell
curl -X POST "http://127.0.0.1/iotapi/system/control/device?addr=000001" \
     -H "accept: application/json" \
     -H "Content-Type: application/json" \
     -H "token: xxxxxxxx" \
     -d "{\"msgType\":\"control_device\",\"name\":\"switch\",\"value\":1}"
```

#### 响应示例
```json
{
    "code":200,
    "msg":"操作成功"
}
```

> 提示：下发的 `name` 必须是设备产品物模型中真实存在且可写的变量，不确定时先调用「根据产品ID查询产品信息」查看 `thing` 字段。部分设备（如继电器）需要下发 16 进制值，由设备端协议约定，平台按物模型类型透传。


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



## 4. 应用侧 MQTT 消息收发（Topic 说明）

适用于第三方应用系统通过 MQTT 与平台交互（区别于设备侧接入）。

**订阅（接收平台推送）：**

| Topic | 说明 |
| :--- | :--- |
| `p/in` | 接收平台下发给应用的消息（如命令下发、同步通知等） |

**发布 / 订阅（设备上行消息转发）：**

| Topic | 说明 |
| :--- | :--- |
| `p/out/{addr}` | 平台处理设备上行消息后转发给应用（按设备地址维度） |
| `s/out/{projectId}/{sceneId}/{addr}` | 平台处理设备上行消息后按场景维度转发（含项目 ID、场景 ID） |

**使用场景说明：**

- 若应用只关注某台设备的数据，订阅 `p/out/{addr}` 即可
- 若应用按场景维度管理设备（如一个工地一个场景），订阅 `s/out/{projectId}/{sceneId}/{addr}` 可按场景过滤消息
- `p/in` 用于接收平台主动推送给应用的控制或同步指令

## 5. 接入最佳实践

1. **一个应用一套凭证**：每个对接系统在平台单独创建 AppID，权限互不影响
2. **启动时初始化**：应用启动时获取 token 和 projectId，同步全量设备 / 产品数据到本地库
3. **定时 + 事件双保险**：本地定时轮询 + 监听 MQTT 同步事件，确保数据不遗漏
4. **Token 自动续期**：token 即将过期前主动重新获取，避免业务中断
5. **MQTT 断线重连**：实现 MQTT 客户端断线自动重连逻辑，保障实时数据不丢失

## 6. API 接口速查表

| 接口 | 方法 | 路径 |
| :--- | :---: | :--- |
| 获取 Token | POST | `/iotapi/system/user/app/login` |
| 查询产品列表 | GET | `/iotapi/system/product/list` |
| 查询产品详情 | GET | `/iotapi/system/product/:ID` |
| 查询设备列表 | GET | `/iotapi/system/device/list` |
| 查询设备详情 | GET | `/iotapi/system/device/:ID` |
| 查询设备在线状态 | GET | `/iotapi/system/device/online` |
| 查询设备实时数据 | GET | `/iotapi/system/device/history/last` |
| 查询设备历史数据 | GET | `/iotapi/system/history/list` |
| 下发设备控制指令 | POST | `/iotapi/system/control/device` |

> 完整接口可在平台 **系统工具 → 系统接口（Swagger UI）** 中在线查阅和调试。
