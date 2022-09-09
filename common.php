<?php

error_reporting(0);
session_set_cookie_params(["samesite" => "Lax"]);
session_start();
require("function.php");
$config = require("config.php");
extract($config);