# Docker 部署

推荐使用官方提供的 [alinkiot-compose](https://github.com/alinkiot/alinkiot-compose) 仓库一键部署，无需手动准备二进制或自行编译源码。

更详细的说明（前提条件、配置、数据库操作等）请参考仓库的 README。

## 获取部署仓库

```bash
git clone https://github.com/alinkiot/alinkiot-compose.git
cd alinkiot-compose
```

## 启动

```bash
docker-compose up -d
```

## 停止

```bash
# 停止并删除所有容器
docker-compose down

# 停止并删除所有容器和卷（会清空数据，谨慎使用）
docker-compose down -v
```
