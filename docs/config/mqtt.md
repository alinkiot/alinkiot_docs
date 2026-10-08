# MQTT 配置

MQTT 接入相关的监听器配置位于主配置文件 `etc/alinkiot.conf`。平台支持 TCP / SSL / WebSocket / WSS 四种接入方式，分别对应独立的 `listener.*` 配置块。

## 默认监听端口

| 协议 | 配置项 | 默认监听 | 用途 |
|------|--------|---------|------|
| MQTT over TCP | `listener.tcp.external` | `0.0.0.0:1883` | 标准 MQTT 明文接入 |
| MQTT over SSL | `listener.ssl.external` | `8883` | MQTT over TLS 加密接入 |
| MQTT over WebSocket | `listener.ws.external` | `8083` | 浏览器 / Web 客户端接入，路径 `/mqtt` |
| MQTT over WSS | `listener.wss.external` | `8084` | WebSocket over TLS 接入，路径 `/mqtt` |

## 通用监听器参数

每个监听器都支持以下常用参数：

| 参数 | 说明 |
|------|------|
| `acceptors` | 接收进程数，影响新连接的并发处理能力 |
| `max_connections` | 该监听器允许的最大连接数 |
| `max_conn_rate` | 每秒允许的最大新建连接数（限流） |
| `active_n` | 每次从 socket 读取的报文批量数 |
| `zone` | 绑定的 zone（控制该监听器的会话、流控、ACL 等策略） |
| `access.N` | 监听器级访问控制规则（如 `allow all`） |

## TCP 接入

```ini
listener.tcp.external = 0.0.0.0:1883
listener.tcp.external.acceptors = 8
listener.tcp.external.max_connections = 1024000
listener.tcp.external.max_conn_rate = 1000
listener.tcp.external.active_n = 100
listener.tcp.external.zone = external
```

## SSL（MQTT over TLS）接入

```ini
listener.ssl.external = 8883
listener.ssl.external.acceptors = 16
listener.ssl.external.max_connections = 102400
listener.ssl.external.max_conn_rate = 500
listener.ssl.external.active_n = 100
listener.ssl.external.zone = external
listener.ssl.external.handshake_timeout = 15s
listener.ssl.external.keyfile = etc/certs/key.pem
listener.ssl.external.certfile = etc/certs/cert.pem
listener.ssl.external.cacertfile = etc/certs/cacert.pem
```

> 证书文件位于 `etc/certs/` 目录；替换为自有证书后重启服务生效。

## WebSocket 接入

```ini
listener.ws.external = 8083
listener.ws.external.mqtt_path = /mqtt
listener.ws.external.acceptors = 4
listener.ws.external.max_connections = 102400
listener.ws.external.max_conn_rate = 1000
listener.ws.external.active_n = 100
listener.ws.external.zone = external
```

Web 客户端连接地址形如 `ws://<服务器地址>:8083/mqtt`。

## WSS（WebSocket over TLS）接入

```ini
listener.wss.external = 8084
listener.wss.external.mqtt_path = /mqtt
listener.wss.external.acceptors = 4
listener.wss.external.max_connections = 102400
listener.wss.external.max_conn_rate = 1000
listener.wss.external.active_n = 100
listener.wss.external.zone = external
```

Web 客户端连接地址形如 `wss://<服务器地址>:8084/mqtt`，复用 `etc/certs/` 下的证书。

> 认证（`allow_anonymous`）与 ACL（`acl.conf`）等全局配置参见 [配置说明](README.md)。设备侧如何使用这些端口接入，参见 [设备接入](../api/device.md)。
