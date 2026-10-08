#!/usr/bin/env bash
#
# compile.sh — 编译脚本（安装插件 → 生成 PDF → 构建）
#
# 运行环境：gitbook 镜像内（已自带 gitbook 命令，CI 直接调用本脚本）
#
# 流程：
#   0. 将本地插件 pdf-download 放入 node_modules（避免 gitbook 去 NPM 找本地插件）
#   1. gitbook install  安装 book.json 中声明的在线插件
#   2. gitbook pdf      生成 PDF 到 docs/assets/alinkiot.pdf
#   3. gitbook build    构建静态站点到 _book/（会把 docs/assets 一并拷入 _book/assets）
#
# 构建完成后，_book/assets/alinkiot.pdf 即为页面「下载 PDF」按钮指向的文件。
#
set -euo pipefail

cd "$(dirname "$0")"

PDF_OUT="docs/assets/alinkiot.pdf"
LOCAL_PLUGIN="gitbook-plugin-pdf-download"

echo "==> [0/3] 准备本地插件 ${LOCAL_PLUGIN} 到 node_modules"
mkdir -p node_modules
rm -rf "node_modules/${LOCAL_PLUGIN}"
cp -r "${LOCAL_PLUGIN}" "node_modules/${LOCAL_PLUGIN}"

echo "==> [1/3] gitbook install（安装在线插件）"
gitbook install

echo "==> [2/3] gitbook pdf（生成 ${PDF_OUT}）"
gitbook pdf ./ "./${PDF_OUT}"

echo "==> [3/3] gitbook build（构建静态站点到 _book/）"
gitbook build

echo "==> 构建完成，产物位于 _book/（含 _book/assets/alinkiot.pdf）"
