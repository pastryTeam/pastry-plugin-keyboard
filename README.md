# 支持平台
>
|平台 | 是否支持 |
|-----|------|
|JS    | 支持    |
|iOS    | 支持    |
|android    | 支持    |

# 依赖服务器数据
>
|平台 | 是否依赖 |
|-----|------|
|FO-Java    | 依赖    |
|FO-NodeJS    | 依赖    |

# 组件依赖关系
>
|组件 | 版本号 | 地址|
|-----|------|----|
|示例    | 版本号    | [GitHub地址](#)|

# 功能介绍
>
* 必选功能
    * JS 端调用原生端的密码键盘
* 可选功能
  * 无

## 请求参数
            jsShowKeyboards方法设置参数格式：
            
            param = [{'data':{
                'mask':'0',         // 支持明文显示
                'maxLength':'12',   // 密码最大长度:12
                'keyboardType':'2', // 密码键盘类型:数字键盘
                'randomSort':'1',   // 支持密码键盘乱序
                'encryptor':'1'     // 支持加密
            }}];
            
            jsHideKeyboards方法设置参数格式：
            
            param = ['null'];
            
## 返回参数
            input、delete、submit 方法返回参数格式：
            
            data = {
                'maskText':'0',     // 接收掩码 例如：****
                'plainText':'12',   // 接收明文 例如：1234
                'value':'2',        // 接收密文 例如：EADFD77978FDFS
                // 此字段为了兼容 pastry 平台
                'text':'1'          // 支持密码键盘乱序
            }
            
            返回参数使用方法：
            
            // 接收掩码 例如：****
            maskText = data.maskText;
            // 接收明文 例如：1234
            plainText = data.plainText;
            // 接收密文 例如：EADFD77978FDFS
            value = data.value;
            
# 安装方法
>
* ionic 平台

    # 安装指定 tag 版本,例如 版本号 = 0.1.0
    ionic plugin add https://github.com/pastryTeam/pastry-plugin-keyboard.git#0.1.0 
    
    # 安装最新代码
    ionic plugin add https://github.com/pastryTeam/pastry-plugin-keyboard.git

# 插件安装到项目里的目录结构
>
涉及两种目录

* 代码目录
        
    项目名称/platforms/ios/项目名称/Plugins/pastry-plugin-keyboard
    
* 资源目录 `特例`

    项目名称/platforms/ios/项目名称/Resources/PTResources.bundle

# 使用方法
>
JS 端UI设计

* AngularJS

>
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

>
* 如需修改页面显示效果
        
    自行修改 代码目录

> 
* 如需修改插件资源
        
    自定修改 资源目录
         
# 作者
>
pastryTeam 团队

