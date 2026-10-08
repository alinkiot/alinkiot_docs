#!/usr/bin/env bash
#
# compile.sh — CI 编译脚本（安装插件 → 生成 PDF → 构建，不启动预览）
#
# 流程：
#   1. gitbook install  安装 book.json 中声明的插件（含本地 pdf-download 插件）
#   2. gitbook pdf      生成 PDF 到 docs/assets/alinkiot.pdf
#   3. gitbook build    构建静态站点到 _book/（会把 docs/assets 一并拷入 _book/assets）
#
# 构建完成后，_book/assets/alinkiot.pdf 即为页面「下载 PDF」按钮指向的文件。
#
# 依赖：Docker（使用 billryan/gitbook 镜像，无需本机安装 gitbook/calibre）
#
set -euo pipefail

cd "$(dirname "$0")"

IMAGE="billryan/gitbook"
PDF_OUT="docs/assets/alinkiot.pdf"

run() {
  docker run --rm -v "$PWD":/gitbook -w /gitbook "$IMAGE" "$@"
}

echo "==> [1/3] gitbook install（安装插件）"
run gitbook install

echo "==> [2/3] gitbook pdf（生成 ${PDF_OUT}）"
run gitbook pdf ./ "./${PDF_OUT}"

echo "==> [3/3] gitbook build（构建静态站点到 _book/）"
run gitbook build

echo "==> 构建完成，产物位于 _book/（含 _book/assets/alinkiot.pdf）"
