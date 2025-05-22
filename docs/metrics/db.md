# 数据库指标

## 1 Mnesia操作
- **指标**：`mnesia_handle_duration_microseconds`
- **类型**：直方图（Histogram）
- **描述**：Mnesia操作执行时间
- **标签**：
  - `key`：操作类型
  - `tab`：表名

## 2 事务指标
- **指标**：
  - `erlang_mnesia_held_locks`
  - `erlang_mnesia_lock_queue`
  - `erlang_mnesia_transaction_participants`
  - `erlang_mnesia_transaction_coordinators`
  - `erlang_mnesia_failed_transactions`
  - `erlang_mnesia_committed_transactions`
  - `erlang_mnesia_logged_transactions`
  - `erlang_mnesia_restarted_transactions`

## 3 内存使用情况
- **指标**：`erlang_mnesia_memory_usage_bytes`
- **描述**：Mnesia使用的总内存

- **指标**：`erlang_mnesia_tablewise_memory_usage_bytes`
- **描述**：每张表的内存使用情况
- **标签**：
  - `table`：表名

- **指标**：`erlang_mnesia_tablewise_size`
- **描述**：每张表的行数
- **标签**：
  - `table`：表名