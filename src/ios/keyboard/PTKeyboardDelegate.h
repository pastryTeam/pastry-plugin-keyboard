//
//  PTKeyboardDelegate.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKeyboard;

/**
 * @ingroup keyboardModuleProtocol
 * 本协议为自定义按钮中按钮按下的各项操作
 */
@protocol PTKeyboardDelegate <NSObject>

@optional

/**
 * 按钮按下时的操作
 * @param  keyboard      键盘对象
 * @param  encryptData   用户输入数据经过3DES加密得到的结果
 * @param  plainText     用户输入的数据明文
 * @param  keyStat       用户输入内容的统计结果，即字符与数字的个数统计<br/>
 *                       num->用户输入的数字个数<br/>
 *                       char->用户输入的字母个数<br/>
 * @note   在不要求键盘返回明文的情况下，plainText返回的*号，用户输入多少字符，返回多少个*号
 */
- (void)didKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat;

/**
 * 退格删除键
 * @param  keyboard      键盘对象
 * @param  encryptData   用户输入数据经过3DES加密得到的结果
 * @param  plainText     用户输入的数据明文
 * @param  keyStat       用户输入内容的统计结果，即字符与数字的个数统计<br/>
 *                       num->用户输入的数字个数<br/>
 *                       char->用户输入的字母个数<br/>
 * @note   在不要求键盘返回明文的情况下，plainText返回的*号，用户输入多少字符，返回多少个*号
 */
- (void)didBackspaceKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat;

/**
 * DONE确认完成键
 * @param  keyboard      键盘对象
 * @param  encryptData   用户输入数据经过3DES加密得到的结果
 * @param  plainText     用户输入的数据明文
 * @param  keyStat       用户输入内容的统计结果，即字符与数字的个数统计<br/>
 *                       num->用户输入的数字个数<br/>
 *                       char->用户输入的字母个数<br/>
 * @note   在不要求键盘返回明文的情况下，plainText返回的*号，用户输入多少字符，返回多少个*号
 */
-(void)didDoneKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat;

@end
