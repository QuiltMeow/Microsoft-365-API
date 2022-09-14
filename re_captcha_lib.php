<?php

class ReCaptchaResponse {

    public $success;
    public $errorCodes;

}

class ReCaptcha {

    private static $_signupUrl = "https://www.google.com/recaptcha/admin";
    private static $_siteVerifyUrl = "https://www.google.com/recaptcha/api/siteverify?";
    private $_secret;
    private static $_version = "php_1.0";

    function ReCaptcha($secret) {
        if ($secret == null || $secret == "") {
            die("必須從 <a href=\"" . self::$_signupUrl . "\">" . self::$_signupUrl . "</a> 取得 API 金鑰後才可使用驗證碼");
        }
        $this->_secret = $secret;
    }

    private function _encodeQS($data) {
        $req = "";
        foreach ($data as $key => $value) {
            $req .= $key . "=" . urlencode(stripslashes($value)) . "&";
        }
        $req = substr($req, 0, strlen($req) - 1);
        return $req;
    }

    private function _submitHTTPGet($path, $data) {
        $req = $this->_encodeQS($data);
        $response = file_get_contents($path . $req);
        return $response;
    }

    public function verifyResponse($remoteIp, $response) {
        if ($response == null || strlen($response) == 0) {
            $recaptchaResponse = new ReCaptchaResponse();
            $recaptchaResponse->success = false;
            $recaptchaResponse->errorCodes = "找不到輸入資料";
            return $recaptchaResponse;
        }
        $getResponse = $this->_submitHttpGet(
                self::$_siteVerifyUrl, array(
                    "secret" => $this->_secret,
                    "remoteip" => $remoteIp,
                    "v" => self::$_version,
                    "response" => $response
                )
        );
        $answers = json_decode($getResponse, true);
        $recaptchaResponse = new ReCaptchaResponse();
        if (trim($answers["success"])) {
            $recaptchaResponse->success = true;
        } else {
            $recaptchaResponse->success = false;
            $recaptchaResponse->errorCodes = $answers [error - codes];
        }
        return $recaptchaResponse;
    }

}