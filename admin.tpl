<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Microsoft Office 365 全局管理</title>
        <link rel="stylesheet" href="layui/css/layui.css" />
        <link href="files/mslogo.png" rel="icon" type="image/png" />
    </head>
    <body class="layui-layout-body" style="overflow-y: visible; background: #FFF">
        <div class="layui-form">
            <blockquote class="layui-elem-quote quoteBox">
                <div class="layui-inline" style="margin-left: 2rem">
                    <a class="layui-btn" id="add_account"><i class="layui-icon layui-icon-username"></i> 建立帳號</a>
                </div>

                <div class="layui-inline" style="margin-left: 2rem">
                    <select name="account" id="account" lay-verify="required">
                        <option value="<?php echo $ii; ?>"><?php echo $accounts[$ii]["name"]; ?></option>
                        <?php
                        $i = 0;
                        foreach ($accounts as $value) {
                            if ($i != $ii) {
                                ?>
                                <option value="<?php echo $i; ?>"><?php echo $value["name"]; ?></option>
                                <?php
                            }
                            $i++;
                        }
                        ?>
                    </select>
                </div>
                <div class="layui-inline" style="margin-left: 2rem">
                    <a class="layui-btn" id="change_account"><i class="layui-icon layui-icon-template-1"></i> 切換全局</a>
                </div>
                <div class="layui-inline" style="margin-left: 2rem">
                    <a class="layui-btn" id="logout"><i class="layui-icon layui-icon-logout"></i> 登出</a>
                </div>
            </blockquote>
        </div>

        <table class="layui-hide" id="table" lay-filter="table">
        </table>

        <div id="add_account_content" class="layui-form layui-form-pane" style="display: none; margin: 1rem 3rem">
            <form class="layui-form" id="add_account_form">
                <div class="layui-form-item">
                    <label class="layui-form-label">顯示名稱</label>
                    <div class="layui-input-inline">
                        <input type="text" placeholder="帳號顯示的名稱" class="layui-input" id="displayname" required lay-verify="required" />
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">使用者帳號</label>
                    <div class="layui-input-inline">
                        <input type="text" placeholder="請輸入前墜" class="layui-input" id="add_user" pattern="[A-z0-9]{1,50}" required lay-verify="required" />
                    </div>
                    <div class="layui-input-inline">
                        <select name="domain" lay-verify="required" id="domain">
                            <?php
                            foreach ($domains as $value) {
                                ?>
                                <option value="<?php echo $value["id"]; ?>"><?php echo $value["id"]; ?></option>
                                <?php
                            }
                            ?>
                        </select>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">密碼</label>
                    <div class="layui-input-inline">
                        <input type="password" placeholder="請輸入密碼" class="layui-input" id="password" pattern="[A-z0-9]{8,50}" required lay-verify="required" />
                    </div>
                    <div class="layui-input-inline">
                        <input type="checkbox" name="forceChangePassword" id="forceChangePassword" lay-skin="switch" lay-text="首次登入強制重設密碼|首次登入無需重設密碼" />
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">國家 (地區)</label>
                    <div class="layui-input-inline">
                        <select name="location" lay-verify="required" id="location">
                            <?php
                            foreach ($locations as $key => $value) {
                                ?>
                                <option value="<?php echo $value; ?>"><?php echo $key; ?></option>
                                <?php
                            }
                            ?>
                        </select>
                    </div>
                    <div class="layui-form-mid layui-word-aux">建議和全局申請時區域一致</div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">授權</label>
                    <div class="layui-input-inline">
                        <select name="sku" lay-verify="required" id="sku">
                            <?php
                            foreach ($accounts[$ii]["sku_ids"] as $key => $value) {
                                ?>
                                <option value="<?php echo $value; ?>"><?php echo $key; ?></option>
                                <?php
                            }
                            ?>
                        </select>
                    </div>
                    <div class="layui-form-mid layui-word-aux">請在 config.php 檔案設定</div>
                </div>
                <div class="layui-form-item">
                    <div class="layui-input-block">
                        <button class="layui-btn" lay-filter="formDemo" id="submitaccount" type="submit">送出</button>
                    </div>
                </div>
            </form>
        </div>
    </body>

    <script type="text/html" id="buttons">
        <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="accountactive">允許</a>
        <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="accountinactive">禁止</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setuserasadminbyid">設為管理</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="deluserasadminbyid">取消管理</a>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">刪除</a>
    </script>
    <script src="./layui/layui.js" charset="utf-8"></script>
    <script src="./layui/jquery.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dompurify/dist/purify.min.js"></script>
    <script type="text/javascript" charset="utf-8">
        layui.use(["table", "form", "layer"], function () {
            var table = layui.table;
            var layer = layui.layer;
            table.render({
                elem: "#table",
                url: "./admin.php?a=getusers",
                cellMinWidth: 60,
                height: "full-120",
                loading: true,
                cols: [[{
                            field: "displayName",
                            title: "顯示名稱",
                            align: "center"
                        }, {
                            field: "userPrincipalName",
                            title: "帳號",
                            align: "center",
                            templet: function (d) {
                                if (d.userPrincipalName) {
                                    return d.userPrincipalName;
                                } else {
                                    return "-";
                                }
                            }
                        }, {
                            field: "accountEnabled",
                            title: "帳號狀態",
                            align: "center",
                            templet: function (d) {
                                if (d.accountEnabled == true) {
                                    return "<span style=\"color: #99CC00\">正常</span>";
                                } else {
                                    return "<span style=\"color: red\">禁用</span>";
                                }
                            }
                        }, {
                            field: "usageLocation",
                            title: "資料中心位置",
                            align: "center"
                        }, {
                            field: "id",
                            title: "ID",
                            width: 335,
                            align: "center",
                            templet: function (d) {
                                if (d.id) {
                                    return d.id;
                                } else {
                                    return "-";
                                }
                            }
                        }, {
                            field: "createdDateTime",
                            title: "建立時間",
                            align: "center"
                        }, {
                            field: "sku",
                            title: "授權",
                            align: "center",
                            templet: function (d) {
                                if (d.sku == "無授權") {
                                    return "<span style=\"color: #FF461F\">無授權</span>";
                                } else {
                                    return d.sku;
                                }
                            }
                        }, {
                            fixed: "right",
                            title: "操作",
                            width: 335,
                            align: "center",
                            toolbar: "#buttons"
                        }
                    ]]
            });

            table.on("tool(table)", function (obj) {
                if (obj.event === "del") {
                    layer.confirm("確定是否刪除 ?", function (index) {
                        $.post("./admin.php?a=admin_delete", {
                            email: obj.data.userPrincipalName,
                            id: obj.data.id
                        }, function (res) {
                            if (res.code == 0) {
                                obj.del();
                            }
                            layer.msg(DOMPurify.sanitize(res.msg));
                        }, "json");
                    });
                }

                if (obj.event === "accountactive") {
                    layer.confirm("確定允許登入 ?", function (index) {
                        $.post("./admin.php?a=invitation_code_activeaccount", {
                            email: obj.data.userPrincipalName
                        }, function (res) {
                            if (res.code == 1) {
                                layer.closeAll();
                                layui.use("table", function () {
                                    var table = layui.table;
                                    table.reload("table", {
                                        url: "./admin.php?a=getusers"
                                    });
                                });
                            }
                            layer.msg(DOMPurify.sanitize(res.msg));
                        }, "json");
                    });
                }

                if (obj.event === "setuserasadminbyid") {
                    layer.confirm("確定設為管理 ?", function (index) {
                        $.post("./admin.php?a=invitation_code_setuserasadminbyid", {
                            id: obj.data.id
                        }, function (res) {
                            if (res.code == 1) {
                                layer.closeAll();
                                layui.use("table", function () {
                                    var table = layui.table;
                                    table.reload("table", {
                                        url: "./admin.php?a=getusers"
                                    });
                                });
                            }
                            layer.msg(DOMPurify.sanitize(res.msg));
                        }, "json");
                    });
                }

                if (obj.event === "deluserasadminbyid") {
                    layer.confirm("確定取消管理 ?", function (index) {
                        $.post("./admin.php?a=invitation_code_deluserasadminbyid", {
                            id: obj.data.id
                        }, function (res) {
                            if (res.code == 1) {
                                layer.closeAll();
                                layui.use("table", function () {
                                    var table = layui.table;
                                    table.reload("table", {
                                        url: "./admin.php?a=getusers"
                                    });
                                });
                            }
                            layer.msg(DOMPurify.sanitize(res.msg));
                        }, "json");
                    });
                }

                if (obj.event === "accountinactive") {
                    layer.confirm("確定禁止登入 ?", function (index) {
                        $.post("./admin.php?a=invitation_code_inactiveaccount", {
                            email: obj.data.userPrincipalName
                        }, function (res) {
                            if (res.code == 1) {
                                layer.closeAll();
                                layui.use("table", function () {
                                    var table = layui.table;
                                    table.reload("table", {
                                        url: "./admin.php?a=getusers"
                                    });
                                });
                            }
                            layer.msg(DOMPurify.sanitize(res.msg));
                        }, "json");
                    });
                }
            });

            $("#change_account").click(function () {
                layer.confirm("確定切換全局 ?", function (index) {
                    var accountid = $("#account").val();
                    $.post("./admin.php?a=changeaccount", {
                        account: accountid
                    }, function (res) {
                        if (res.code == 1) {
                            layer.closeAll();
                        }
                        layer.msg(DOMPurify.sanitize(res.msg));
                        window.location.reload();
                    }, "json");
                });
            });

            $("#logout").click(function () {
                layer.confirm("確定登出 ?", function (index) {
                    $.post("./admin.php?a=logout", function (res) {
                        if (res.code == 1) {
                            layer.closeAll();
                        }
                        layer.msg(DOMPurify.sanitize(res.msg));
                        window.location.reload();
                    }, "json");
                });
            });

            $("#add_account").click(function () {
                layer.open({
                    type: 1,
                    title: "建立帳號",
                    end: function () {
                        $("#add_account_content").hide();
                    },
                    skin: "layui-layer-rim",
                    content: $("#add_account_content")
                });
            });

            $("#add_account_form").submit(function (event) {
                event.preventDefault();
                var data = {
                    displayname: $("#displayname").val(),
                    add_user: $("#add_user").val(),
                    domain: $("#domain").val(),
                    password: $("#password").val(),
                    forceChangePassword: $("#forceChangePassword").is(":checked"),
                    location: $("#location").val(),
                    sku: $("#sku").val()
                };

                $.post("./admin.php?a=admin_add_account", data, function (res) {
                    if (res.code == 0) {
                        layer.closeAll();
                        layui.use("table", function () {
                            var table = layui.table;
                            table.reload("table", {
                                url: "./admin.php?a=getusers"
                            });
                        });
                    }
                    layer.msg(DOMPurify.sanitize(res.msg));
                }, "json");
            });
        });
    </script>
</html>