# alinkiot Book
进入到当前目录下，执行以下命令

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