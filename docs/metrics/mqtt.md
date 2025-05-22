# MQTT 系统监控指标

## 概述
本文档总结了Prometheus监控系统暴露的关键指标，按系统组件和功能分类。

## 1. 服务健康指标

### 1.1 应用实例
- **指标**：`app_instances`
- **类型**：仪表盘（Gauge）
- **描述**：通过实例信息监控服务健康状态
- **标签**：
  - `app`：服务名称
  - `node`：主机名
  - `zone`：区域
  - `ip`：节点IP地址

### 1.2 活跃连接数
- **指标**：`active_connections_count`
- **类型**：仪表盘（Gauge）
- **描述**：跟踪活跃连接数量
- **标签**：
  - `zone`：区域标识

## 2. MQTT指标

### 2.1 消息处理
- **指标**：`mqtt_messages_received_total`
- **类型**：计数器（Counter）
- **描述**：按类型统计接收的MQTT消息数量
- **标签**：
  - `key`：消息类型（订阅/subscribe、接收发布/pub_recv、MQTT传递/mqtt_deliver）

### 2.2 性能延迟
- **指标**：`mqtt_acl_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：ACL处理延迟分布
- **标签**：
  - `status`：ACL状态

- **指标**：`mqtt_pub_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：消息发布延迟分布
- **标签**：
  - `status`：发布状态

- **指标**：`mqtt_auth_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：认证延迟分布
- **标签**：
  - `status`：认证状态

## 3. RPC指标

### 3.1 RPC性能
- **指标**：`rpc_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：RPC调用延迟分布
- **标签**：
  - `node`：目标节点
  - `method`：RPC方法名
  - `status`：调用状态

## 4. API指标

### 4.1 API性能
- **指标**：`api_handle_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：API请求处理延迟
- **标签**：
  - `key`：API端点名称
  - `status`：响应状态

