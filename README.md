# alinkiot Book
进入到当前目录下，执行以下命令

## 一键编译（含 PDF，CI 可用）
```bash
./compile.sh
```
该脚本依次执行：安装插件 → 生成 PDF（`docs/assets/alinkiot.pdf`）→ 构建静态站点到 `_book/`。
构建产物中的 `_book/assets/alinkiot.pdf` 即页面左上角「下载 PDF」按钮指向的文件。
> 依赖 Docker（使用 `billryan/gitbook` 镜像，无需本机安装 gitbook/calibre）。

本地预览可在编译后执行 `gitbook serve`（见下方「启动服务」）。

## 初始化
```bash
docker run --name alinkiot_docs --rm -v "$PWD":/gitbook -p 4000:4000 billryan/gitbook gitbook init
```

## 安装插件
```bash
docker run --name alinkiot_docs --rm -v "$PWD":/gitbook -p 4000:4000 billryan/gitbook gitbook install
```

## 编译成静态网站
```bash
docker run --name alinkiot_docs --rm -v "$PWD":/gitbook -p 4000:4000 billryan/gitbook gitbook build
```

## 启动服务
```bash
docker run --name alinkiot_docs --rm -v "$PWD":/gitbook -p 4000:4000 billryan/gitbook gitbook serve
```


## 导出 pdf
```bash
docker run --name alinkiot_docs --rm -v "$PWD":/gitbook -p 4000:4000 billryan/gitbook gitbook pdf ./ ./_book/assets/alinkiot.pdf
```