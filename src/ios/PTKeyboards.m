//
//  PTKeyboards.m
//  HelloCordova
//
//  Created by gengych on 16/1/26.
//
//

#import "PTKeyboards.h"
#import "PTKeyboardiPhone.h"
#import "PTKeyboardPasswordNumerPhone.h"

/**
 * 标记是否显示明文 <br>
 * mask = 1 : 显示密文 <br/>
 * mask = 0 : 显示明文 <br/>
 */
#define ATTR_MASK @"mask"

/**
 * 标记密码支持的长度 <br/>
 * maxLength = 8 : 最长支持8位密码
 */
#define ATTR_MAX_LENGTH @"maxLength"

/**
 * 键盘类型
 * keyboardType = 2 : 数字键盘
 * keyboardType = 其它 : 字符键盘
 */
#define ATTR_KEYBOARD_TYPE @"keyboardType"

/**
 * 标记是否支持键盘乱序
 * randomSort = 1 : 支持键盘乱序
 * randomSort = 0 : 不支持键盘乱序
 */
#define ATTR_RANDOM_SORT @"randomSort"

/**
 * 是否支持加密
 * encryptor = 1 : 支持加密
 * encryptor = 0 : 不支持加密
 */
#define ATTR_ENCRYPTOR @"encryptor"

typedef enum {
    OPTYPE_POPUP = 0,
    OPTYPE_INPUT = 1,
    OPTYPE_DELETE = 2,
    OPTYPE_SUBMIT = 3,
} OPTYPE;


@implementation PTKeyboards{
    PTKeyboard *_keyboard;
}

- (void)jsShowKeyboards:(CDVInvokedUrlCommand*)command {
    id data = [[command.arguments objectAtIndex:0] objectForKey:@"data"];
    BOOL result = [self openKeyboard:data];
    // 返回 js 的回调，js 端 注册 keyboard.input keyboard.delete keyboard.submit 事件；
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@", [NSNumber numberWithBool:result]]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)jsHideKeyboards:(CDVInvokedUrlCommand *)command{
    [self closeKeyBoard];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"YES"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - 打开、关闭密码键盘
/**
 * 打开密码键盘<br/>
 * 根据js请求参数，开始调用对应类型密码键盘<br/>
 * 数字键盘<br/>
 * 字母键盘<br/>
 * @return YES : 键盘已经存在；<br/>
 *          NO : 键盘不存在，但是初始化好一个键盘<br/>
 */
-(BOOL)openKeyboard:(id)keyboardParam
{
    if ([self isHasKeyboard]) {
        return NO;
    } else {
        BOOL isShowText = NO;
        BOOL isRandomSort = NO;
        BOOL needEncryptor = true;
        int  length = 0;
        int  keyboardType = PTKeyboardTypeDefault;
        
        if (keyboardParam != nil) {
            if ([keyboardParam objectForKey:ATTR_MASK] != nil && [keyboardParam objectForKey:ATTR_MASK] != [NSNull null]) {
                isShowText = ![[keyboardParam objectForKey:ATTR_MASK] boolValue];
            }
            if ([keyboardParam objectForKey:ATTR_MAX_LENGTH] != nil && [keyboardParam objectForKey:ATTR_MAX_LENGTH] != [NSNull null]) {
                length = [[keyboardParam objectForKey:ATTR_MAX_LENGTH] intValue];
            }
            if ([keyboardParam objectForKey:ATTR_KEYBOARD_TYPE] != nil && [keyboardParam objectForKey:ATTR_KEYBOARD_TYPE] != [NSNull null]) {
                keyboardType = [[keyboardParam objectForKey:ATTR_KEYBOARD_TYPE] intValue];
            }
            if ([keyboardParam objectForKey:ATTR_RANDOM_SORT] != nil && [keyboardParam objectForKey:ATTR_RANDOM_SORT] != [NSNull null]) {
                isRandomSort = [[keyboardParam objectForKey:ATTR_RANDOM_SORT] boolValue];
            }
            if ([keyboardParam objectForKey:ATTR_ENCRYPTOR] != nil && [keyboardParam objectForKey:ATTR_ENCRYPTOR] != [NSNull null]) {
                needEncryptor = [[keyboardParam objectForKey:ATTR_ENCRYPTOR] boolValue];
            }
        }
        
        // 获取随机属性，之前是一个协议方法，由业务端提供
        BOOL keywordStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"keywordOrderSet"];
        NSNumber *localRandom = [NSNumber numberWithBool:keywordStatus];
        
        if (localRandom != nil) {
            isRandomSort = [localRandom boolValue];
        }
        
        //初始化keyboard
        PTSecretKeyManager *manager = [PTSecretKeyManager getInstance];
        
        switch (keyboardType) {
            case 2:
            {
                //数字键盘
                _keyboard = [[PTKeyboardPasswordNumerPhone alloc] initWithResponder:YES isShowText:isShowText randomType:keyboardType length:length key1:[manager getServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
            }
                break;
            default:
            {
                //字符键盘
                NSString *deviceType = [[PTDeviceManager getInstance] getIncaseDeviceType];
                if ([deviceType isEqualToString:@"ipad"]){
                    _keyboard = [[PTKeyboardiPhone alloc] initWithResponder:YES isShowText:isShowText randomType:keyboardType length:length key1:[manager getServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
                } else {
                    _keyboard = [[PTKeyboardiPhone alloc] initWithResponder:YES isShowText:isShowText randomType:keyboardType length:length key1:[manager getServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
                }
            }
                break;
        }
        _keyboard.needEncrypt = needEncryptor;
        _keyboard.keyDelegate = self;
        
        [self didShowKeyboard:_keyboard toTargetView:[self getTargetView]];
        return YES;
    }
}

/**
 * 关闭密码键盘，并清空数据
 */
- (void)closeKeyBoard {
    
    if ([self isHasKeyboard]) {
        [self didHideKeyboard:_keyboard];
    }
    
    if (_keyboard!=nil) {
        _keyboard.keyDelegate = nil;
        _keyboard = nil;
    }
}

#pragma mark - 密码键盘显示、隐藏动画效果

/**
 * 将密码键盘添加到父View，并执行展示动画效果
 * @param   keyboard        待操作的密码键盘
 * @param   targetView      密码键盘的父View
 */
- (void)didShowKeyboard:(PTKeyboard *)keyboard toTargetView:(UIView *)targetView {
    PTLogDebug(@"H5 调用原生密码键盘 didShowKeyboard ");
    
    CGRect currentRect = targetView.frame;
    keyboard.frame = CGRectMake(0.f, currentRect.size.height, keyboard.frame.size.width, keyboard.frame.size.height);
    [[targetView superview] addSubview:keyboard];
    
    [UIView animateWithDuration:.3f animations:^ {
        // 设置密码键盘的 frame
        keyboard.frame = CGRectMake(0.f, currentRect.size.height - keyboard.frame.size.height, keyboard.frame.size.width, keyboard.frame.size.height);
    } completion:^ (BOOL finish) {
        
    }];
}

/**
 * 将密码键盘从父View上移除，并执行关闭动画效果
 * @param   keyboard        待操作的密码键盘
 */
- (void)didHideKeyboard:(PTKeyboard *)keyboard {
    [UIView animateWithDuration:.3f animations:^ {
        CGFloat y = keyboard.frame.origin.y + keyboard.frame.size.height;
        keyboard.frame = CGRectMake(keyboard.frame.origin.x, y, keyboard.frame.size.width, keyboard.frame.size.height);
    } completion:^ (BOOL finish) {
        [keyboard removeFromSuperview];
    }];
}


#pragma mark - 获取密码键盘的父容器
/**
 * 获取 密码键盘将要显示到的父View
 * @return 父View
 */
- (UIView *)getTargetView {
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result.view;
}

#pragma mark - 判断密码键盘是否显示
/**
 * 获取密码键盘是否已经显示
 * @return  
 *      YES : 已经显示密码键盘<br/>
 *      NO : 没有显示的密码键盘<br/>
 */
-(BOOL)isHasKeyboard
{
    BOOL showKeyboard = NO;
    if (_keyboard != nil && _keyboard.superview != nil) {
        showKeyboard = YES;
    }
    PTLogDebug(@"keyboard has been %d",showKeyboard);
    return showKeyboard;
}


#pragma mark - 密码键盘代理 KeyboardDelegate

- (void)didKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat
{
    PTLogDebug(@"security keyboard plain text = %@",plainText);
    NSString *base64Passwd = nil;
    if (keyboard.needEncrypt) {
        base64Passwd = [self translateEncryptData:encryptData];
    } else {
        base64Passwd = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
    }
    NSNumber *strength = [self calculatePasswordStrength:keyStat encryptData:encryptData];
    
    [self sendKeyboardAction:OPTYPE_INPUT password:base64Passwd plainText:plainText passwordStrength:strength];
}

- (void)didBackspaceKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat
{
    PTLogDebug(@"security keyboard plain text = %@",plainText);
    NSString *base64Passwd = [self translateEncryptData:encryptData];
    NSNumber *strength = [self calculatePasswordStrength:keyStat encryptData:encryptData];
    
    [self sendKeyboardAction:OPTYPE_DELETE password:base64Passwd plainText:plainText passwordStrength:strength];
}

- (void)didDoneKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat
{
    PTLogDebug(@"security keyboard plain text = %@",plainText);
    
    NSString *base64Passwd = [self translateEncryptData:encryptData];
    NSNumber *strength = [self calculatePasswordStrength:keyStat encryptData:encryptData];
    [self sendKeyboardAction:OPTYPE_SUBMIT password:base64Passwd plainText:plainText passwordStrength:strength];
}

- (NSString *)translateEncryptData:(NSMutableData *)encryptData
{
    NSString *base64Password = nil;
    if ([encryptData length] == 0) {//密码已为空
        base64Password = [NSString stringWithFormat:@"%@", @""];
    } else {
        //        PTSessionManager *manager = [PTSessionManager getInstance];
        //        if ([manager getEncryptServerRandomKey] != nil && [manager getClientRandomKey] != nil && [manager getSessionKey] != nil) {//密钥协商成功
        base64Password = [PTConverter bytesToHex:encryptData];
        //        } else {
        //            base64Password = [NSString stringWithFormat:@"%@", [PTConverter bytesToBase64:encryptData]];
        //        }
    }
    return base64Password;
}

/**
 * 计算 密码强度 传递给H5
 */
- (NSNumber *)calculatePasswordStrength:(NSDictionary *)keyStat encryptData:(NSData *)encryptData
{
    NSData *data = [NSData dataWithData:encryptData];
    
    NSNumber *strength = nil;
    //        CBWebview * webView = (CBWebview *)[self superview];
    /////// 进行密码强度校验
    //        if (webView.delegate != nil && [webView.delegate respondsToSelector:@selector(passwordStrength:encryptData:)]) {
    //            int strengthValue = [webView.delegate passwordStrength:state encryptData:encryptData];
    //            strength = [NSNumber numberWithInt:strengthValue];
    //        }
    
    return strength;
}

- (void)sendKeyboardAction:(OPTYPE)type password:(NSString *)password plainText:(NSString *)plainText passwordStrength:(NSNumber *)strength
{
    [self sendAction:type text:password plainText:plainText passwordStrength:strength];
}

- (void)sendNumberKeyboardAction:(OPTYPE)type text:(NSString *)text plainText:(NSString *)plainText passwordStrength:(NSNumber *)strength
{
    [self sendAction:type text:text plainText:plainText passwordStrength:strength];
}

-(void)sendAction:(OPTYPE)type text:(NSString*)text plainText:(NSString *)plainText passwordStrength:(NSNumber *)strength
{
    PTLogDebug(@"sendAction type = %d,text= %@,plainText= %@,strength=%@", type, text, plainText, strength);
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    if (text != nil && text.length > 0) {
        [dataDictionary setObject:text forKey:@"value"];
        if (strength != nil) {
            [dataDictionary setObject:strength forKey:@"strength"];
        }
    } else {
        [dataDictionary setObject:@"" forKey:@"value"];
    }
    
    if (plainText != nil && plainText.length > 0) {
        [dataDictionary setObject:plainText forKey:@"plainText"];
        
        NSString *maskText = @"";
        for (int index = 0; index < plainText.length; index++) {
            maskText = [NSString stringWithFormat:@"%@*", maskText];
        }
        [dataDictionary setObject:maskText forKey:@"maskText"];
		
        // 兼容 pastry 平台
        [dataDictionary setObject:maskText forKey:@"text"];
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:dataDictionary forKey:@"data"];
    switch (type) {
        case OPTYPE_SUBMIT:{
            [dictionary setObject:[NSNumber numberWithBool:false] forKey:@"continue"];
            [self closeKeyBoard];
        }
            break;
        case OPTYPE_DELETE:
        case OPTYPE_INPUT:
        default:
            [dictionary setObject:[NSNumber numberWithBool:true] forKey:@"continue"];
            break;
    }
    
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        
        NSString *strParam = @"";
        for (NSString *key in dictionary) {
            
            if ([key isEqualToString:@"data"]) {
                
                if ([dictionary[key] isKindOfClass:[NSDictionary class]]) {
                    strParam = [dictionary[key] JSONString];
                }
            }
        }
        
        NSString *js = nil;
        switch (type) {
            case OPTYPE_SUBMIT:
                js = [NSString stringWithFormat:@"cordova.fireDocumentEvent('keyboard.submit',%@);",strParam];
                break;
                
            case OPTYPE_DELETE:
                js = [NSString stringWithFormat:@"cordova.fireDocumentEvent('keyboard.delete',%@);",strParam];
                break;
                
            case OPTYPE_INPUT:
            default:
                js = [NSString stringWithFormat:@"cordova.fireDocumentEvent('keyboard.input',%@);",strParam];
                break;
        }
        
        [self.commandDelegate evalJs:js];
    }
}

@end
