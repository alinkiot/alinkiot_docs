# 日志说明

平台运行日志默认输出到 `log/` 目录下，用于排查设备接入、消息收发、服务异常等问题。

## 日志目录

使用 [alinkiot-compose](https://github.com/alinkiot/alinkiot-compose) 部署时，日志挂载在容器的 `log/` 目录中：

```
log/
├── alinkiot.log        # 当前正在写入的日志文件
├── alinkiot.log.1      # 滚动归档的历史日志（上一份）
├── alinkiot.log.2
└── ...
```

- `alinkiot.log`：当前日志文件，实时写入最新日志。
- `alinkiot.log.1`、`alinkiot.log.2` …：日志滚动（rotate）后归档的历史文件，序号越大时间越早。单个日志文件达到大小上限后，当前文件被重命名为 `alinkiot.log.1`，原有的 `.1` 顺延为 `.2`，依此类推。

## 查看日志

```bash
# 实时跟踪最新日志
tail -f log/alinkiot.log

# 查看历史归档日志
less log/alinkiot.log.1

# 按关键字检索（如设备地址 addr、异常关键字）
grep "<关键字>" log/alinkiot.log log/alinkiot.log.1
```

容器化部署时，也可直接查看容器标准输出：

```bash
docker-compose logs -f
```

## 常见排查场景

- **设备连接 / 鉴权失败**：在 `log/alinkiot.log` 中按设备地址（`addr`）或 ClientID 检索，定位认证、ACL 相关报错。
- **消息收发异常**：按 Topic 或设备地址检索发布 / 订阅相关日志。
- **服务启动异常**：查看日志开头的启动阶段记录，确认配置加载与依赖连接是否正常。
