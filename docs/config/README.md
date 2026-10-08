# 配置说明

平台所有配置文件集中存放在发行版根目录下的 `etc/` 目录中。修改配置后需重启服务生效（部分支持热更新的插件除外）。

## 配置文件总览

| 文件 | 说明 |
|------|------|
| `alinkiot.conf` | 主配置文件：节点、日志、系统监控、MQTT 各协议监听器等 |
| `acl.conf` | 访问控制（ACL）规则：按用户 / IP 控制 Topic 的发布与订阅 |
| `alinkiot.config` | Erlang 原生配置（`sys.config` 格式）：Dashboard（管理后台）与 MySQL 连接等应用参数 |
| `tdengine.config` | TDengine 时序数据库连接配置 |
| `ssl_dist.conf` | Erlang 节点间分布式通信的 TLS 配置 |
| `vm.args.src` | Erlang 虚拟机启动参数 |
| `certs/` | TLS 证书目录（服务端 / 客户端证书、CA 证书、私钥） |

## 主配置 alinkiot.conf

### 节点

```ini
node.name = alinkiot
node.cookie = alinkiot_cookie
node.data_dir = data
node.crash_dump = log/crash.dump
```

### 认证与 ACL

```ini
acl_file = etc/acl.conf
allow_anonymous = true      # 是否允许匿名接入，生产环境建议改为 false
acl_nomatch = allow         # ACL 未命中时的默认动作
```

### 日志

```ini
log.to = file
log.level = warning         # 日志级别：debug / info / warning / error
log.dir = log               # 日志目录
log.file = alinkiot.log     # 当前日志文件名
log.rotation = on           # 开启日志滚动
log.rotation.size = 10MB    # 单文件大小上限，超过后滚动
log.rotation.count = 5      # 保留的历史文件数量（alinkiot.log.1 ~ .5）
```

> 日志目录结构与查看方式详见 [日志查询](../ops/log.md)。

### 系统监控

`sysmon.*` / `os_mon.*` / `vm_mon.*` 用于配置系统资源监控阈值（CPU、内存、进程、GC 等），例如：

```ini
os_mon.cpu_high_watermark = 80%
os_mon.sysmem_high_watermark = 70%
vm_mon.process_high_watermark = 80%
```

### 协议监听器

平台支持 TCP / SSL / WebSocket / WSS 四种接入方式，默认监听端口如下：

| 协议 | 配置项 | 默认监听 |
|------|--------|---------|
| MQTT over TCP | `listener.tcp.external` | `0.0.0.0:1883` |
| MQTT over SSL | `listener.ssl.external` | `8883` |
| MQTT over WebSocket | `listener.ws.external` | `8083` |
| MQTT over WSS | `listener.wss.external` | `8084` |

每个监听器还可配置连接数与速率等参数，例如 TCP：

```ini
listener.tcp.external = 0.0.0.0:1883
listener.tcp.external.acceptors = 8            # 接收进程数
listener.tcp.external.max_connections = 1024000 # 最大连接数
listener.tcp.external.max_conn_rate = 1000      # 每秒最大新建连接数
listener.tcp.external.zone = external
```

MQTT 监听器与接入方式的更多说明见 [MQTT 配置](mqtt.md)。

## 访问控制 acl.conf

ACL 规则按顺序匹配，命中即生效。规则形式为 `{allow|deny, who, access, [topics]}`：

```erlang
%% 允许 dashboard 用户订阅系统主题
{allow, {user, "dashboard"}, subscribe, ["$SYS/#"]}.
%% 允许本机对所有主题收发
{allow, {ipaddr, "127.0.0.1"}, pubsub, ["$SYS/#", "#"]}.
%% 拒绝其它客户端订阅系统主题和通配全量主题
{deny, all, subscribe, ["$SYS/#", {eq, "#"}]}.
%% 兜底：其余一律放行
{allow, all}.
```

- `who`：`all` / `{user, "名称"}` / `{client, "ClientID"}` / `{ipaddr, "CIDR"}`
- `access`：`subscribe` / `publish` / `pubsub`
- 生产环境建议收紧兜底规则（将最后的 `{allow, all}.` 改为按需放行）。

## 管理后台与 MySQL alinkiot.config

`alinkiot.config` 采用 Erlang 原生配置格式（即 `sys.config`，内容为 `[{App, [{Key, Value}, ...]}, ...]` 的 Erlang 项列表），用于配置各应用的运行参数：

```erlang
{alinkiot_dashboard, [
  {port, 18888},          %% 管理后台端口
  {docroot, "www/"},      %% 前端静态资源目录
  {expire, 18000},        %% 登录 Token 有效期（秒）
  {token_name, "token"}
]},
{alinkiot_mysql, [
  {mysql, [[
    {host, "127.0.0.1"}, {port, 3306},
    {user, "alinkiot"}, {password, "******"},
    {database, "alinkiot"},
    {pool_size, 10}
  ]]}
]}
```

> 管理后台默认端口 `18888`。数据库连接的 `host` / `user` / `password` / `database` 按实际环境修改，默认密码务必更换。

## TDengine tdengine.config

```erlang
{alinkiot_tdengine, [
  {host, "127.0.0.1"}, {port, 6041},
  {username, "root"}, {password, "******"},
  {database, "alinkiot"},
  {pool_size, 20},
  {flush_interval, 1000},   %% 批量写入刷新间隔（毫秒）
  {flush_msg_len, 20}       %% 批量写入条数阈值
]}
```

> TDengine 用于存储设备上报的时序数据，连接参数按实际部署修改。

## 分布式 TLS ssl_dist.conf 与 certs/

`ssl_dist.conf` 配置 Erlang 节点间分布式通信的 TLS 证书，证书文件位于 `etc/certs/`：

```erlang
[{server, [{certfile, "etc/certs/cert.pem"},
           {keyfile,  "etc/certs/key.pem"},
           {secure_renegotiate, true},
           {depth, 0}]},
 {client, [{secure_renegotiate, true}]}].
```

`certs/` 目录包含服务端证书 / 私钥（`cert.pem` / `key.pem`）、客户端证书 / 私钥（`client-cert.pem` / `client-key.pem`）和 CA 证书（`cacert.pem`）。

## vm.args.src

Erlang 虚拟机启动参数（如节点名、cookie、内存分配、端口范围等）。一般无需改动，确有调优需求时再按 Erlang/OTP 规范调整。
