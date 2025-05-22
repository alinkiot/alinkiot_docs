# 监控指标说明文档

## 1. 服务概览
### 1.1 服务部署情况
**指标**：`app_instances`（gauge类型）
- 含义：监控服务健康状态，包含实例部署信息
- 标签：`app`（服务名）、`node`（主机名）、`zone`（区域）、`ip`（节点IP）
- 当前数据：`app_instances{app="alinkiot",node="alinkiot@172.25.102.82",zone="default",ip="172.25.102.82"} 1`
- 结论：当前`default`区域部署了1个`alinkiot`服务实例，主机名为`alinkiot@172.25.102.82`，IP为`172.25.102.82`。

### 1.2 当前连接数
**指标**：`active_connections_count`（gauge类型）
- 含义：当前活跃连接数
- 标签：`zone`（区域）
- 当前数据：`active_connections_count{zone="default"} 1`
- 结论：`default`区域当前活跃连接数为1。

## 2. MQTT性能指标
### 2.1 消息接收统计
**指标**：`mqtt_messages_received_total`（counter类型）
- 含义：按消息类型统计的MQTT消息接收总量
- 标签：`key`（消息类型）
- 当前数据：`subscribe=1`，`pub_recv=9`，`mqtt_deliver=9`
- 结论：`pub_recv`和`mqtt_deliver`类型消息接收量较高（各9条），`subscribe`类型较少（1条）。
- PromQL示例：
  ```promql
  # 按消息类型统计总接收量
  mqtt_messages_received_total
  # 近5分钟各类型消息接收速率
  rate(mqtt_messages_received_total[5m])
  ```

### 2.2 延迟分布指标
#### 2.2.1 ACL处理延迟（`mqtt_acl_duration_microseconds`）
- 类型：histogram
- 含义：ACL（访问控制列表）处理延迟分布
- 标签：`status`（ACL状态）
- 当前数据：`status="allow"`时，所有分桶计数均为1，`sum=0.586`微秒
- 结论：ACL处理延迟极低（平均约0.586微秒），且所有请求均通过（`allow`状态）。
- PromQL示例（95分位数）：
  ```promql
  histogram_quantile(0.95, sum(rate(mqtt_acl_duration_microseconds_bucket[5m])) by (le))
  ```

#### 2.2.2 消息发布延迟（`mqtt_pub_duration_microseconds`）
- 类型：histogram
- 含义：消息发布延迟分布
- 标签：`status`（发布状态）
- 当前数据：`status="success"`时，所有分桶计数均为9，`sum=0.329`微秒
- 结论：消息发布延迟稳定（平均约0.329微秒），且全部成功。
- PromQL示例（平均延迟）：
  ```promql
  sum(rate(mqtt_pub_duration_microseconds_sum[5m])) by (status) / sum(rate(mqtt_pub_duration_microseconds_count[5m])) by (status)
  ```

## 3. RPC性能分析
**指标**：`rpc_duration_microseconds`（histogram类型）
- 含义：RPC请求延迟分布
- 标签：`node`（节点）、`method`（方法）、`status`（调用状态）

### 3.1 按方法与状态分类统计
当前数据（`node="local"`）：
- `method="subscribe"`，`status="success"`：计数1
- `method="publish"`，`status="unknow"`：计数9
- `method="open_session"`，`status="success"`：计数2

### 3.2 异常调用识别
- 异常状态：`status="unknow"`出现在`publish`和`match_routes`方法（各9次），需检查接口返回状态码是否规范。

### 3.3 方法成功率计算
示例（`open_session`方法）：
```promql
  (sum(rpc_duration_microseconds_count{method="open_session",status="success"}) / sum(rpc_duration_microseconds_count{method="open_session"})) * 100
```

### 3.4 延迟百分位查询
```promql
  histogram_quantile(0.90, sum(rate(rpc_duration_microseconds_bucket[5m])) by (le, method))
```

## 4. Mnesia数据库监控
### 4.1 表内存使用
**指标**：`erlang_mnesia_tablewise_memory_usage_bytes`（gauge类型）
- 当前数据：`mqtt_client=2600B`，`mqtt_route=10776B`（最大），`schema=7472B`
- 容量建议：定期监控`mqtt_route`表内存增长，避免超过节点内存限制。

### 4.2 事务统计
**指标**：`erlang_mnesia_committed_transactions`（counter类型，当前值3），`erlang_mnesia_failed_transactions`（counter类型，当前值4）
- 结论：失败事务（4次）多于成功事务（3次），需排查事务回滚原因。

### 4.3 锁竞争
**指标**：`erlang_mnesia_held_locks=0`，`erlang_mnesia_lock_queue=0`
- 结论：当前无锁竞争，事务执行流畅。

## 5. 综合PromQL示例
1. 服务健康状态概览：
```promql
  app_instances + active_connections_count
```
2. 消息处理吞吐量趋势：
```promql
  rate(mqtt_messages_received_total[1m])
```
3. 异常请求追踪：
```promql
  rpc_duration_microseconds_count{status="unknow"}
```
4. 资源使用TOP N（Mnesia表内存）：
```promql
  topk(3, erlang_mnesia_tablewise_memory_usage_bytes)
```
5. 历史性能对比（近7天同时间段RPC延迟）：
```promql
  histogram_quantile(0.95, sum(rate(rpc_duration_microseconds_bucket[1h])) by (le)) offset 7d
```