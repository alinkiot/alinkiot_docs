# Erlang VM 指标报告
本文档总结了Prometheus监控系统暴露的关键指标，按系统组件和功能分类。

## 7.1 内存管理
- **指标**：
  - `erlang_vm_memory_atom_bytes_total`
  - `erlang_vm_memory_bytes_total`
  - `erlang_vm_memory_processes_bytes_total`
  - `erlang_vm_memory_system_bytes_total`

## 7.2 进程管理
- **指标**：
  - `erlang_vm_process_count`
  - `erlang_vm_process_limit`
  - `erlang_vm_port_count`
  - `erlang_vm_port_limit`

## 7.3 调度器指标
- **指标**：
  - `erlang_vm_schedulers`
  - `erlang_vm_schedulers_online`
  - `erlang_vm_dirty_cpu_schedulers`
  - `erlang_vm_dirty_io_schedulers`

## 7.4 垃圾回收
- **指标**：
  - `erlang_vm_statistics_garbage_collection_number_of_gcs`
  - `erlang_vm_statistics_garbage_collection_bytes_reclaimed`
  - `erlang_vm_statistics_garbage_collection_words_reclaimed`

## 7.5 系统统计信息
- **指标**：
  - `erlang_vm_statistics_reductions_total`
  - `erlang_vm_statistics_runtime_milliseconds`
  - `erlang_vm_statistics_wallclock_time_milliseconds`
  - `erlang_vm_statistics_bytes_output_total`
  - `erlang_vm_statistics_bytes_received_total`