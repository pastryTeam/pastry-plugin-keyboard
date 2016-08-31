# 支持平台

|平台 | 是否支持 |
|-----|------|
|JS    | 支持    |
|iOS    | 支持    |
|android    | 支持    |

# 依赖服务器数据

|平台 | 是否依赖 |
|-----|------|
|FO-Java    | 依赖    |
|FO-NodeJS    | 依赖    |

# 组件依赖关系

|组件 | 版本号 | 地址|
|-----|------|----|
|示例    | 版本号    | [GitHub地址](#)|

# 功能介绍
JS 端调用原生端的密码键盘

# 安装方法

* ionic 平台

        ionic plugin add https://github.com/pastryTeam/pastry-plugin-keyboard.git

        需要在原生端定义 #define IONIC_PLATFORM 1
    
* pastry 平台
    
        pastry bake plugin add https://github.com/pastryTeam/pastry-plugin-keyboard.git
    
        不需要在原生端定义 IONIC_PLATFORM

# 使用方法

JS 端UI设计

* AngularJS

    待定

* pastry JS

    待定

JS 端调用方法

* 打开键盘

        window.cordova.exec(function(data){
                console.log('cordova 打开密码键盘 返回命令');
                // 接收 原生端字符输入事件
                document.addEventListener('keyboard.input', onPasswordInput);
                // 接收 原生端字符删除输入事件
                document.addEventListener('keyboard.delete', onPasswordDelete);
                // 接收 原生端提交输入事件
                document.addEventListener('keyboard.submit', onPasswordSubmit);
            },function(data) {
    
            },
            'PTKeyboards',
            'jsShowKeyboards',
            [{'data':{
                'mask':'0',         // 支持明文显示
                'maxLength':'12',   // 密码最大长度:12
                'keyboardType':'2', // 密码键盘类型:数字键盘
                'randomSort':'1',   // 支持密码键盘乱序
                'encryptor':'1'     // 支持加密
            }}]); 

* 关闭键盘

        window.cordova.exec(function(data) {
                document.removeEventListener('keyboard.input', onPasswordInput);
                document.removeEventListener('keyboard.delete', onPasswordDelete);
                document.removeEventListener('keyboard.submit', onPasswordSubmit);
            },function(data) {

            },
            'PTKeyboards',
            'jsHideKeyboards',
            ['null']);
            
* 接收键盘输入事件

        onPasswordInput = function(data) {
            // 接收掩码 例如：****
            maskText = data.maskText;
            // 接收明文 例如：1234
            plainText = data.plainText;
            // 接收密文 例如：EADFD77978FDFS
            value = data.value;
            console.log('onPasswordInput');
        };

* 接收键盘删除事件

        onPasswordDelete = function(data) {
            // 接收掩码 例如：****
            maskText = data.maskText;
            // 接收明文 例如：1234
            plainText = data.plainText;
            // 接收密文 例如：EADFD77978FDFS
            value = data.value;
            console.log('onPasswordDelete');
        };

* 接收键盘提交事件

        onPasswordSubmit = function(data) {
            // 接收掩码 例如：****
            maskText = data.maskText;
            // 接收明文 例如：1234
            plainText = data.plainText;
            // 接收密文 例如：EADFD77978FDFS
            value = data.value;
            console.log('onPasswordSubmit');
        };
        
# 作者

pastryTeam 团队

