//
//  PTKeyboard.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKeyboardDelegate.h"
#import "PTKeyboardConstant.h"

/**
 @ingroup   keyboardModuleContant
 @def NUMS
 @brief 数字键盘 字符串
 */
#define NUMS [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",nil]
#define CHARACTERS [NSArray arrayWithObjects:@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",nil]
#define CHARACTERS_LOWER [NSArray arrayWithObjects:@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m",nil]

#define SPECIAI_CHARS_1 [NSArray arrayWithObjects:@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"\"",@".",@",",@"?",@"!",@"'",nil]

#define SPECIAI_CHARS_2 [NSArray arrayWithObjects:@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"\\",@"|",@"~",@"<",@">",@"€",@"£",@"￥",@"·",@".",@",",@"?",@"!",@"'",nil]


/**
 @ingroup   keyboardModuleEnum
 @typedef PTKeyboardType
 @brief 键盘种类 类型枚举
 */
typedef enum{
    PTKeyboardTypeDefault = 1000,                // 默认为字母键盘.
    PTKeyboardTypeNumbersAndPunctuation = 1001,  // 数字+字符.      (未使用)
    PTKeyboardTypeSpecialPunctuation = 1002,     // 特殊字符.       (未使用)
    PTKeyboardTypeNumber = 1003,                 // 纯数字（0-9）   (未使用)
} PTKeyboardType;



/**
 @ingroup   keyboardRandomModuleEnum
 @typedef PTKeyboardRandomType
 @brief 键盘乱序类型枚举
 */
typedef enum{
    PTKeyboardRandomTypeDefault = 1,          // 默认为不乱序键盘.
    PTKeyboardRandomTypePunctuation = 2,      // 字母乱序键盘
    PTKeyboardRandomTypeNumberPunctuation = 3,// 数字字母乱序键盘
    PTKeyboardRandomTypeNumber = 4,           // 数字乱序键盘
} PTKeyboardRandomType;


/**
 @ingroup keyboardModuleClass
 键盘基类
 */
@interface PTKeyboard : UIView

/**
 * 键盘返回的协议实例
 */
@property (nonatomic, assign) id<PTKeyboardDelegate> keyDelegate;

/**
 * 加密后的密文
 */
@property (nonatomic, retain) NSMutableData *encryptStrData;

/**
 * 标记数据是否加密
 */
@property (nonatomic, assign) BOOL needEncrypt;

/**
 * 初始化键盘的VIEW
 * @param  enable      按键时是否播放按键音
 * @param  isShowText  是否回传键盘输入的明文
 * @param  length      最大可输入的字符长度，但长度设置为小于0的值时，表示不做长度控制
 * @param  randomSort 是否随机排序字母
 * @param  key1        3DES加密的密钥1
 * @param  key2        3DES加密的密钥2
 * @param  key3        3DES加密的密钥3
 * @return 键盘UIView
 */
- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3 PT_DEPRECATED(1.2.0, "使用 initWithResponder:enable isShowText: randomType: length: key1: key2: key3 方法");

/**
 * 初始化键盘的VIEW
 * @param  enable      按键时是否播放按键音
 * @param  isShowText  是否回传键盘输入的明文
 * @param  length      最大可输入的字符长度，但长度设置为小于0的值时，表示不做长度控制
 * @param  randType    随机排序方式
 * @param  key1        3DES加密的密钥1
 * @param  key2        3DES加密的密钥2
 * @param  key3        3DES加密的密钥3
 * @return 键盘UIView
 */
- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText randomType:(PTKeyboardRandomType)randType length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;

/**
 * 清空加密数据
 */
- (void)emptyEncryptData;

/**
 * 加密方法
 * @param  keyValue      要加密的字符串
 * @param  desKey1       3DES加密的密钥1
 * @param  desKey2       3DES加密的密钥2
 * @param  desKey3       3DES加密的密钥3
 */
- (void)encryptInputString:(NSString *)keyValue desKey1:(NSString *)desKey1 desKey2:(NSString *)desKey2 desKey3:(NSString *)desKey3;

/**
 * 删除方法
 */
- (void)deleteEncryptData;

#pragma mark - 未使用的函数

/**
 *（此函数未使用）
 * 初始化键盘的VIEW
 * @param  enable      按键时是否播放按键音
 * @param  _value      设定默认值
 * @return 键盘UIView
 */
- (id)initWithResponder:(BOOL)enable value:(NSString *)_value;

/**
 *（此函数未使用）
 * 判断当前单例键盘是否是需要的子类键盘，如果不是则移除并将keyboard释放
 */
- (void)checkSuitableKeyboard;

/**
 *（此函数未使用）
 * 根据是否随机的属性刷新键盘
 */
- (void)refreshKeyboardWithRandomValue:(BOOL)random;

/**
 *（此属性未使用，只有在 PTKeyboardNumberPhone 类中被使用，但是 PTKeyboardNumberPhone 类 未被使用）
 * 需要加密的字符串
 */
@property (nonatomic, retain) NSMutableString *textData;

/**
 *读取按键声音
 */
-(void)keySound;

@end