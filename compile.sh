#!/usr/bin/env bash
#
# compile.sh — 编译脚本（安装插件 → 生成 PDF → 构建）
#
# 运行环境：gitbook 镜像内（已自带 gitbook 命令，CI 直接调用本脚本）
#
# 说明：pdf-download 是本地插件（不在 NPM）。gitbook install 会按 book.json
# 的 plugins 列表逐个去 NPM 安装，遇到本地插件会报 "Not found"。因此这里：
#   - 安装阶段：用一个临时的、不含 pdf-download 的 book.json 安装在线插件
#   - 构建阶段：恢复完整 book.json，并把本地插件放进 node_modules，
#     gitbook build/pdf 时即可从 node_modules 加载本地插件
#
set -euo pipefail

cd "$(dirname "$0")"

PDF_OUT="docs/assets/alinkiot.pdf"
LOCAL_PLUGIN="gitbook-plugin-pdf-download"

cleanup() {
  # 确保无论成功失败都恢复原始 book.json
  if [ -f book.json.bak ]; then
    mv -f book.json.bak book.json
  fi
}
trap cleanup EXIT

echo "==> [0/3] 准备本地插件 ${LOCAL_PLUGIN} 到 node_modules"
mkdir -p node_modules
rm -rf "node_modules/${LOCAL_PLUGIN}"
cp -r "${LOCAL_PLUGIN}" "node_modules/${LOCAL_PLUGIN}"

echo "==> [1/3] gitbook install（仅安装在线插件；临时移除本地插件 pdf-download）"
cp book.json book.json.bak
# 从 plugins 数组去掉本地插件 pdf-download（用 python 处理，格式无关）
python3 - "$LOCAL_PLUGIN" <<'PY'
import json, sys
name = sys.argv[1].replace("gitbook-plugin-", "")
with open("book.json.bak") as f:
    data = json.load(f)
data["plugins"] = [p for p in data.get("plugins", []) if p != name]
data.get("pluginsConfig", {}).pop(name, None)
with open("book.json", "w") as f:
    json.dump(data, f, ensure_ascii=False, indent=4)
PY
gitbook install
# 恢复完整 book.json（含 pdf-download，供 build 加载本地插件）
mv -f book.json.bak book.json

echo "==> [2/3] gitbook pdf（生成 ${PDF_OUT}）"
gitbook pdf ./ "./${PDF_OUT}"

echo "==> [3/3] gitbook build（构建静态站点到 _book/）"
gitbook build

echo "==> 构建完成，产物位于 _book/（含 _book/assets/alinkiot.pdf）"
