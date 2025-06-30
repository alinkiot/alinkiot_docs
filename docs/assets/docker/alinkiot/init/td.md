# tdengine 初始化
```sql
CREATE DATABASE IF NOT EXISTS alinkiot;
ALTER USER root PASS 'a112345666';
```

## 备份
taosdump -h localhost -P 6030 -D alinkiot -o /file/path

## 导入
taosdump -i /file/path -h localhost -P 6030


# mysql 

## 备份
```sql
mysqldump -u root -p alinkiot > backup.sql
```