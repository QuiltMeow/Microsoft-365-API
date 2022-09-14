<?php

require("common.php");

function changeAccount() {
    global $accounts;
    $change = is_numeric($_POST["account"]) ? $_POST["account"] : "0";
    if ((int) $change < 0 || (int) $change >= count($accounts)) {
        return false;
    }
    $_SESSION["account"] = $change;
    return true;
}

if (empty($_GET["a"])) {
    if (check_login()) {
        header("location: ./admin.php?a=show");
        exit();
    } else {
        require("login.tpl");
        exit();
    }
}

$ii = 0;
if ($_GET["a"] == "login") {
    if (empty($_POST["g-recaptcha-response"])) {
        require("login.tpl");
        exit();
    }

    include_once("re_captcha_lib.php");
    $re_captcha = new ReCaptcha($reCAPTCHA_secret_key);
    $re_captcha_res = $re_captcha->verifyResponse($_SERVER["REMOTE_ADDR"], $_POST["g-recaptcha-response"]);
    if (!isset($re_captcha_res) || !$re_captcha_res->success) {
        require("login.tpl");
        exit();
    }

    $username = !empty($_POST["username"]) ? $_POST["username"] : "";
    $password = !empty($_POST["password"]) ? $_POST["password"] : "";
    if ($username == $admin["username"] && hash("sha512", $password) == $admin["password"]) {
        if (!changeAccount()) {
            require("login.tpl");
            exit();
        }
        $_SESSION["token"] = hash("sha512", $admin["username"] . $admin["password"]);
        header("location: ./admin.php?a=show");
        exit();
    } else {
        require("login.tpl");
        exit();
    }
}

if ($_GET["a"] == "show") {
    if (!check_login()) {
        require("login.tpl");
        exit();
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $domains = getdomains($token);
    require("admin.tpl");
    exit();
}

if ($_GET["a"] == "getusers") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);

    $data = getusers($token);
    foreach ($data as $k => $v) {
        $license = $v["assignedLicenses"][0]["skuId"];
        if ($license == "") {
            $data[$k]["sku"] = "無授權";
        } elseif ($license == "314c4481-f395-4525-be8b-2ec4bb1e9d91") {
            $data[$k]["sku"] = "A1 學生";
        } elseif ($license == "94763226-9b3c-4e75-a931-5c89701abe66") {
            $data[$k]["sku"] = "A1 教職員";
        } elseif ($license == "e82ae690-a2d5-4d76-8d30-7c6e01e6022e") {
            $data[$k]["sku"] = "A1P 學生";
        } elseif ($license == "78e66a63-337a-4a9a-8959-41c6654dfb56") {
            $data[$k]["sku"] = "A1P 教職員";
        } else {
            $data[$k]["sku"] = "其他";
        }
    }
    response(0, "取得成員資訊成功", $data, count($data));
}

if ($_GET["a"] == "admin_add_account") {
    if (!check_login()) {
        response(1, "登入已失效");
    }

    $domain = $_POST["domain"];
    $password = $_POST["password"];
    $forceChangePassword = $_POST["forceChangePassword"];
    $location = $_POST["location"];
    $sku_id = $_POST["sku"];

    $request = [
        "username" => $_POST["add_user"],
        "displayname" => $_POST["displayname"]
    ];

    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    if (empty($token)) {
        response(1, "取得 Token 失敗，請檢查參數設定是否正確");
    }
    admin_create_user($request, $token, $domain, $sku_id, $password, $forceChangePassword, $location);
    response(0, "建立使用者成功");
}

if ($_GET["a"] == "admin_delete") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $user_email = !empty($_POST["email"]) ? $_POST["email"] : 0;
    if ($user_email) {
        $resultaccount = accountdelete($user_email, $token);
    } else {
        $resultaccount = false;
    }
    if (!empty($resultaccount)) {
        response(0, "使用者帳號刪除成功");
    } else {
        response(1, "刪除失敗");
    }
}

if ($_GET["a"] == "invitation_code_activeaccount") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $user_email = !empty($_POST["email"]) ? $_POST["email"] : 0;
    $result = accountactive($user_email, $token);
    if (!empty($result)) {
        response(0, $user_email . " 解鎖失敗");
    } else {
        response(1, $user_email . " 解鎖成功");
    }
}

if ($_GET["a"] == "invitation_code_inactiveaccount") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $user_email = !empty($_POST["email"]) ? $_POST["email"] : 0;
    $result = accountinactive($user_email, $token);
    if (!empty($result)) {
        response(0, $user_email . " 禁用失敗");
    } else {
        response(1, $user_email . " 成功禁用");
    }
}

if ($_GET["a"] == "invitation_code_setuserasadminbyid") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $user_id = !empty($_POST["id"]) ? $_POST["id"] : 0;
    $result = setuserasadminbyid($user_id, $token);
    if (!empty($result)) {
        response(0, "設定管理失敗 : " . $result);
    } else {
        response(1, "設定管理成功");
    }
}

if ($_GET["a"] == "invitation_code_deluserasadminbyid") {
    if (!check_login()) {
        response(1, "登入已失效");
    }
    $token = get_ms_token($accounts[$ii]["tenant_id"], $accounts[$ii]["client_id"], $accounts[$ii]["client_secret"]);
    $user_id = !empty($_POST["id"]) ? $_POST["id"] : 0;
    $result = deluserasadminbyid($user_id, $token);
    if (!empty($result)) {
        response(0, "取消管理權限失敗 : " . $result);
    } else {
        response(1, "取消管理權限成功");
    }
}

if ($_GET["a"] == "changeaccount") {
    changeAccount();
    if (!check_login()) {
        response(1, "登入已失效");
    }
    response(1, "切換全局成功");
}

if ($_GET["a"] == "logout") {
    session_destroy();
    response(1, "登出完成");
}