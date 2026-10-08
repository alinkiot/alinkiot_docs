require(["gitbook", "jQuery"], function (gitbook, $) {
    gitbook.events.bind("start", function (e, config) {
        var conf = (config && config["pdf-download"]) || {};
        var file = (conf.file || "assets/alinkiot.pdf").replace(/^\//, "");
        var text = conf.label || "下载 PDF";

        gitbook.toolbar.createButton({
            icon: "fa fa-file-pdf-o",
            text: text,
            onClick: function () {
                var root = (gitbook.state && gitbook.state.basePath) || ".";
                if (root.slice(-1) !== "/") {
                    root += "/";
                }
                window.open(root + file, "_blank");
            }
        });
    });
});
