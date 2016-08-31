//
//  PTKeyboards.h
//  HelloCordova
//
//  Created by gengych on 16/1/26.
//
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDV.h>

/**
 * 接收 JS 端发送的网络请求，加密后转发给服务器；然后将服务器返回的结果发送给 JS 端；<br/>
 * JS 端键盘配置参数<br/>
 *  mask : 标记是否显示明文 <br>
 *  maxLength : 标记密码支持的长度 <br/>
 *  keyboardType : 键盘类型<br/>
 *  randomSort : 标记是否支持键盘乱序<br/>
 *  encryptor : 是否支持加密<br/>
 *
 * JS 端接收返回的消息<br/>
 *  {
 *		// 兼容pastryJS
 *		text = "*",
 *      maskText = "*";
 *      plainText = r;
 *      value = AB101073B5A9EBD2;
 *  }
 */
@interface PTKeyboards : CDVPlugin<PTKeyboardDelegate>

#ifdef IONIC_PLATFORM

#else
/** 
 * 兼容pastry平台
 */
- (void)tapViewToCloseTheKeyboard;
#endif

/**
 * JS端发送请求，打开密码键盘 <br/>
 * 打开键盘结束后，发送消息给JS端 <br/>
 * YES : 密码键盘打开成功 <br/>
 * NO : 密码键盘打开失败 <br/>
 */
- (void)jsShowKeyboards:(CDVInvokedUrlCommand*)command;

/**
 * JS端发送请求，隐藏密码键盘 <br/>
 * 隐藏键盘结束后，发送消息给JS端 <br/>
 * YES : 密码键盘关闭成功 <br/>
 */
- (void)jsHideKeyboards:(CDVInvokedUrlCommand *)command;

@end
