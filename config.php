<?php

return [
    // 全局帳號相關設定
    "accounts" => [
        [
            "name" => "你的訂閱名稱",
            "client_id" => "你的應用程式 (用戶端) 識別碼",
            "tenant_id" => "你的目錄 (租用戶) 識別碼",
            "client_secret" => "你的用戶端密碼",
            "sku_ids" => [ // 全局所包含的授權設定
                "A1P 學生" => "e82ae690-a2d5-4d76-8d30-7c6e01e6022e",
                "A1P 教職員" => "78e66a63-337a-4a9a-8959-41c6654dfb56"
            ]
        ], [
            "name" => "第二個訂閱",
            "client_id" => "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "tenant_id" => "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "client_secret" => "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            "sku_ids" => [
                "A1 學生" => "314c4481-f395-4525-be8b-2ec4bb1e9d91",
                "A1 教職員" => "94763226-9b3c-4e75-a931-5c89701abe66"
            ]
        ]
    ],
    // 建立使用者時可選資料中心位置
    "locations" => [
        "台灣" => "TW",
        "香港" => "HK",
        "日本" => "JP",
        "新加坡" => "SG",
        "美國" => "US",
        "英國" => "GB",
        "中國" => "CN"
    ],
    // 後台相關設定
    "admin" => [
        "username" => "xxxxxxxx", // 登入帳號
        "password" => "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" // 自行輸入密碼 https://miniwebtool.com/zh-tw/sha512-hash-generator 填入輸出
    ]
];