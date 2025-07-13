# Docker 部署


## 前提条件

- Docker 已安装
- Docker Compose 已安装

## 数据库导入导出操作
### tdengine 初始化
```sql
CREATE DATABASE IF NOT EXISTS alinkiot;
ALTER USER root PASS 'a112345666';
```

### 备份
taosdump -h localhost -P 6030 -D alinkiot -o /file/path

### 导入
taosdump -i /file/path -h localhost -P 6030


## mysql 

### 备份
```sql
mysqldump -u root -p alinkiot > backup.sql
```



## 启动
```bash
docker-compose down && docker-compose up -d

# 停止并删除所有容器和卷
docker-compose down -v
```