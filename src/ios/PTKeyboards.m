//
//  PTKeyboards.m
//  HelloCordova
//
//  Created by gengych on 16/1/26.
//
//

#import "PTKeyboards.h"
#import "PTBrowserContainer.h"
#import "PTWindowPage.h"


#define ATTR_MASK @"mask"
#define ATTR_MAX_LENGTH @"maxLength"
#define ATTR_KEYBOARD_TYPE @"keyboardType"
#define ATTR_RANDOM_SORT @"randomSort"
#define ATTR_RANDOM_SORT2 @"random"

#define ATTR_ENCRYPTOR @"encryptor"

typedef enum {
    OPTYPE_POPUP = 0,
    OPTYPE_INPUT = 1,
    OPTYPE_DELETE = 2,
    OPTYPE_SUBMIT = 3,
}OPTYPE;


@implementation PTKeyboards{
    PTKeyboard *_keyboard;
    
    UITapGestureRecognizer *_singleTap;
    
}

- (void)jsHideKeyboards:(CDVInvokedUrlCommand *)command{
    NSMutableDictionary *responseMsg = [NSMutableDictionary dictionary];
    
    [responseMsg setObject:[NSNumber numberWithInteger:0] forKey:@"result"];
    [responseMsg setObject:[NSNumber numberWithBool:false] forKey:@"continue"];
//    [self closeKeyBoard];
    [self sendAction:OPTYPE_SUBMIT text:nil plainText:nil passwordStrength:nil];
}

- (void)jsShowKeyboards:(CDVInvokedUrlCommand*)command
{
    id data = [[command.arguments objectAtIndex:0] objectForKey:@"data"];

    NSMutableDictionary *responseMsg = [NSMutableDictionary dictionary];
    
    [responseMsg setObject:[NSNumber numberWithInteger:0] forKey:@"result"];
    [responseMsg setObject:[NSNumber numberWithBool:true] forKey:@"continue"];
    
    BOOL correctOpt = [self callSecurityKeyboardWithRequest:data];
    if (correctOpt) {
        PTLogDebug(@"密码键盘已经存在");
        
        
    } else {
        PTLogDebug(@"密码键盘不存在");
        
        // 返回 js 的回调，js 端 注册 keyboard.input keyboard.delete keyboard.submit 事件；
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"test"];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    
}

/**
 * 根据js请求参数，开始调用对应类型密码键盘
 * 数字键盘
 * 字母键盘
 * @return YES : 键盘已经存在；
 *          NO : 键盘不存在，但是初始化好一个键盘
 */
-(BOOL)callSecurityKeyboardWithRequest:(id)requestData
{
    if ([self keyboardHasBeenShown]) {
        return YES;
    }
    else if (_keyboard==nil){
        BOOL isShowText = NO;
        BOOL isRandomSort = NO;
        BOOL random2 = NO;
        BOOL needEncryptor = true;
        int  length = 0;
        int  keyboardType = PTKeyboardTypeDefault;
        
        if (requestData != nil) {
            if ([requestData objectForKey:ATTR_MASK] != nil && [requestData objectForKey:ATTR_MASK] != [NSNull null]) {
                isShowText = ![[requestData objectForKey:ATTR_MASK] boolValue];
            }
            if ([requestData objectForKey:ATTR_MAX_LENGTH] != nil && [requestData objectForKey:ATTR_MAX_LENGTH] != [NSNull null]) {
                length = [[requestData objectForKey:ATTR_MAX_LENGTH] intValue];
            }
            if ([requestData objectForKey:ATTR_KEYBOARD_TYPE] != nil && [requestData objectForKey:ATTR_KEYBOARD_TYPE] != [NSNull null]) {
                keyboardType = [[requestData objectForKey:ATTR_KEYBOARD_TYPE] intValue];
            }
            if ([requestData objectForKey:ATTR_RANDOM_SORT] != nil && [requestData objectForKey:ATTR_RANDOM_SORT] != [NSNull null]) {
                isRandomSort = [[requestData objectForKey:ATTR_RANDOM_SORT] boolValue];
            }
            
            if ([requestData objectForKey:ATTR_RANDOM_SORT2] != nil && [requestData objectForKey:ATTR_RANDOM_SORT2] != [NSNull null]) {
                random2 = [[requestData objectForKey:ATTR_RANDOM_SORT2] boolValue];
            }
            if ([requestData objectForKey:ATTR_ENCRYPTOR] != nil && [requestData objectForKey:ATTR_ENCRYPTOR] != [NSNull null]) {
                needEncryptor = [[requestData objectForKey:ATTR_ENCRYPTOR] boolValue];
            }
            
            isRandomSort = (random2 ||isRandomSort);
        }
        
        // 获取随机属性，之前是一个协议方法，由业务端提供
        //NSNumber *localRandom = [jsWebView didGetLocalRandomValueOfKeyboard];
        BOOL keywordStatus = [[NSUserDefaults standardUserDefaults] boolForKey:@"keywordOrderSet"];
        NSNumber *localRandom = [NSNumber numberWithBool:keywordStatus];
        
        if (localRandom != nil) {
            isRandomSort = [localRandom boolValue];
        }
        
        //初始化keyboard
        PTSessionManager *manager = [PTSessionManager getInstance];
        
        switch (keyboardType) {
            case 2:
            {
                //数字键盘
                _keyboard = [[PTKeyboardPasswordNumerPhone alloc] initWithResponder:YES isShowText:isShowText isRandomSort: isRandomSort length:length key1:[manager getEncryptServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
            }
                break;
            default:
            {
                //字符键盘
                NSString *deviceType = [[PTDeviceManager getInstance] getIncaseDeviceType];
                if ([deviceType isEqualToString:@"ipad"]){
                    _keyboard = [[PTKeyboardiPhone alloc] initWithResponder:YES isShowText:isShowText isRandomSort:isRandomSort length:length key1:[manager getEncryptServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
                } else {
                    _keyboard = [[PTKeyboardiPhone alloc] initWithResponder:YES isShowText:isShowText isRandomSort:isRandomSort length:length key1:[manager getEncryptServerRandomKey] key2:[manager getClientRandomKey] key3:[manager getSessionKey]];
                }
            }
                break;
        }
        _keyboard.needEncrypt = needEncryptor;
        _keyboard.keyDelegate = self;
        
        [self didShowPasswordKeyboard:_keyboard browserContainer:[self getBrowserContainer]];
        
        return NO;
    }
    else{
        return NO;
    }
}

/**
 * 通过webview对象，获取当前的插件的BrowserContainer；
 */
- (id)getBrowserContainer{
    PTBrowserContainer *browserContainer = nil;
    for (UIView *next = self.webView; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder class] == [PTBrowserContainer class]) {
            browserContainer = (PTBrowserContainer *)nextResponder;
            break;
        }
    }
    
    return browserContainer;
}

- (id)getBrowserContainerParentViewController:(UIViewController *)browserContainer{
    UIViewController *parentViewController = nil;
    for (UIView *next = browserContainer.view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([[nextResponder class] isSubclassOfClass:[UIViewController class]] && [nextResponder respondsToSelector:@selector(passwordStrength:encryptData:)]) {
            parentViewController = (UIViewController *)nextResponder;
            break;
        }
    }
    
    return parentViewController;
}

/**
 * 显示密码键盘到UI，并实现动画效果
 */
- (void)didShowPasswordKeyboard:(PTKeyboard *)keyboard browserContainer:(PTBrowserContainer *)browserContainer
{
    PTLogDebug(@"didShowPasswordKeyboard");
    
    CGRect currentRect = [browserContainer getOriginFrame];
    [keyboard setFrame:CGRectMake(0.f, currentRect.size.height, keyboard.frame.size.width, keyboard.frame.size.height)];
    [[browserContainer.view superview] addSubview:keyboard];
    
//    [self addTapGestureRecognizer:browserContainer];
    
    [UIView animateWithDuration:.3f animations:^ {
        // 设置密码键盘的 frame
        CGRect newFrame = CGRectMake(0.f, currentRect.size.height - keyboard.frame.size.height, keyboard.frame.size.width, keyboard.frame.size.height);
        keyboard.frame = newFrame;
        PTLogDebug(@"end frame = %@",NSStringFromCGRect(currentRect));
        PTLogDebug(@"keyboard frame = %@",NSStringFromCGRect(keyboard.frame));
    } completion:^ (BOOL finish) {
        // 设置 browserContainer 显示密码键盘后的 frame
        browserContainer.view.backgroundColor = [UIColor yellowColor];
        CGRect browserContainerNewFrame = CGRectMake(0.f, currentRect.origin.y, currentRect.size.width, currentRect.size.height - keyboard.frame.size.height);
        [browserContainer setWindowPageFrame:browserContainerNewFrame];
        PTLogDebug(@"did change jswebview frame to %@",NSStringFromCGRect(browserContainer.view.frame));
    }];
}

- (void)didHidePasswordKeyboard:(PTKeyboard *)keyboard taskID:(NSString *)taskID
{
    [UIView animateWithDuration:.3f animations:^ {
        CGFloat y = keyboard.frame.origin.y + keyboard.frame.size.height;
        keyboard.frame = CGRectMake(keyboard.frame.origin.x, y, keyboard.frame.size.width, keyboard.frame.size.height);
        //            self.frame = originFrame;
        PTBrowserContainer *browserContainer = [self getBrowserContainer];
        // 恢复 BrowserContainer 不显示 keyboard 的frame大小；
        [browserContainer getCurrentWindowPage].view.frame = [browserContainer getOriginFrame];
//        [browserContainer setWindowPageFrame:[browserContainer getOriginFrame]];
        
    } completion:^ (BOOL finish) {
        PTBrowserContainer *browserContainer = [self getBrowserContainer];
        [browserContainer setWindowPageFrame:[browserContainer getOriginFrame]];
        [keyboard removeFromSuperview];
    }];
}

//判断键盘是否已经显示
-(BOOL)keyboardHasBeenShown
{
    BOOL showKeyboard = NO;
    if (_keyboard != nil && _keyboard.superview != nil) {
        return YES;
        showKeyboard = YES;
    }
    PTLogDebug(@"keyboard has been %d",showKeyboard);
    return showKeyboard;
}

#pragma mark -- KeyboardDelegate
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
    
    PTBrowserContainer *browserContainer = [self getBrowserContainer];
    
    UIViewController *parentVC = [self getBrowserContainerParentViewController:browserContainer];
    if (parentVC != nil) {
        int strengthValue = [parentVC performSelector:@selector(passwordStrength:encryptData:) withObject:keyStat withObject:data];
        strength = [NSNumber numberWithInt:strengthValue];
    }
    
    return strength;
}

- (void)closeKeyBoard
{
    if ([self keyboardHasBeenShown]) {
        [self didHidePasswordKeyboard:_keyboard taskID:nil];
    }
    
    if (_keyboard!=nil) {
        _keyboard.keyDelegate = nil;
        _keyboard = nil;
    }
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
    PTLogDebug(@"sendAction type = %d,text= %@,plainText= %@,strength=%@",type,text,plainText,strength);
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    [dataDictionary setObject:[NSNumber numberWithInteger:type] forKey:@"optype"];
    
    if (plainText != nil && plainText.length > 0) {
        [dataDictionary setObject:plainText forKey:@"value"];
        if (strength != nil) {
            [dataDictionary setObject:strength forKey:@"strength"];
        }
    } else {
        [dataDictionary setObject:@"" forKey:@"value"];
    }
    if (plainText != nil && plainText.length > 0) {
        [dataDictionary setObject:plainText forKey:@"text"];
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
    PTBrowserContainer *browserContainer = [self getBrowserContainer];
    
    if (browserContainer != nil) {
        PTWindowPage *windowPage = [browserContainer getCurrentWindowPage];
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            
            NSString *strParam = @"";
            for (NSString *key in dictionary) {
                
                if ([key  isEqualToString: @"data"]) {
                    
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
            [windowPage.commandDelegate evalJs:js];
        }
    }
}
    
    
-(void)tapViewToCloseTheKeyboard
{
    [self sendAction:OPTYPE_SUBMIT text:nil plainText:nil passwordStrength:nil];
}
@end
