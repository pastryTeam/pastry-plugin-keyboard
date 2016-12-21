//
//  PTKeyboardConstant.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#ifndef PT_PTKeyboardConstant_h
#define PT_PTKeyboardConstant_h

/**
 @ingroup keyboardSingleKeyModuleContant
 @def structToObjc(struct,structType)
 @brief 将 struct 类型 转换为 objc 的宏定义
 */
#define structToObjc(struct,structType) [NSValue valueWithBytes:&struct objCType:@encode(structType)]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def objcToStruct(objc,struct)
 @brief 将 objc 类型 转换为 struct 的宏定义
 */
#define objcToStruct(objc,struct) [objc getValue:&struct]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def Keyboard_W
 @brief 计算键盘的宽度
 */
#define Keyboard_W [UIScreen mainScreen].bounds.size.width

/**
 @ingroup keyboardSingleKeyModuleContant
 @def getKeyboard_H
 @brief 根据宽度计算键盘的高度； 宽度＝＝414，高度 ＝ 226； 宽度 < 414，高度 ＝ 216；否则：高度 ＝ 267
 */
#define getKeyboard_H(KeyboardH,KeyboardW) {\
if(KeyboardW == 414){\
    KeyboardH = 226;\
}else if(KeyboardW < 414){\
    KeyboardH = 216;\
}else{\
    KeyboardH = 267;\
}\
}

/**
 @ingroup keyboardSingleKeyModuleContant
 @def CHARACTERS_LOWERCASE
 @brief 键盘中 所有小写字母的 集合
 */
#define CHARACTERS_LOWERCASE @[@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p",@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l",@"z",@"x",@"c",@"v",@"b",@"n",@"m"]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def CHARACTERS_UPPERCASE
 @brief 键盘中 所有大写字母的 集合
 */
#define CHARACTERS_UPPERCASE @[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M"]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def NUM_SPECIAI
 @brief 键盘中 数字和特殊字母的 集合
 */
#define NUM_SPECIAI @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"-",@"/",@":",@";",@"(",@")",@"$",@"&",@"@",@"\"",@".",@",",@"?",@"!",@"'"]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def SPECIAI
 @brief 键盘中 特殊字母的 集合
 */
#define SPECIAI @[@"[",@"]",@"{",@"}",@"#",@"%",@"^",@"*",@"+",@"=",@"_",@"\\",@"|",@"~",@"<",@">",@"€",@"£",@"￥",@"·",@".",@",",@"?",@"!",@"'"]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def NUM
 @brief 键盘中 数字的 集合
 */
#define NUM @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"",@"0",@"完成"]

/**
 @ingroup keyboardSingleKeyModuleContant
 @brief 获取键盘中 按键的图片资源所在的Bundle路径
 */

#define PTResourceBundle [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"PTResources" withExtension:@"bundle"]]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def PTKeyboardResources_Char(name,type)
 @brief 获取 字符键盘中 按键的图片资源
 */

#define PTKeyboardResources_Char(name,type) [UIImage imageWithData:[NSData dataWithContentsOfFile:[PTResourceBundle pathForResource:name ofType:type inDirectory:@"char_keyboard"]]]

/**
 @ingroup keyboardSingleKeyModuleContant
 @def PTKeyboardResources_Number(name,type)
 @brief 获取 数字键盘中 按键的图片资源
 */

#define PTKeyboardResources_Number(name,type) [UIImage imageWithData:[NSData dataWithContentsOfFile:[PTResourceBundle pathForResource:name ofType:type inDirectory:@"number_keyboard"]]]

/**
 @ingroup keyboardSingleKeyModuleEnum
 * 按键的类型<br/>（包含 混合字符键、混合数字键、Shift ＋ 字符键、Shift ＋ 数字键、删除键、空格键、返回键、数字键）
 */
typedef enum {
    PTKeyType_Hybridkey_Chars = 0,  //!< 混合字符键
    PTKeyType_Hybridkey_NumAndS,    //!< 混合数字键
    PTKeyType_ShiftKey_Chars,       //!< Shift键：⬆️ 小写字母键盘 和 大写字母键盘 切换；
    PTKeyType_ShiftKey_NumAndS,     //!< Shift键： 123 #+= 两个按键； 实现 数字、字符混合键盘 和 特殊字符键盘 的切换；
    PTKeyType_DeleteKey,            //!< 删除键
    PTKeyType_NextKey,              //!< 键盘切换按键: ABC #+123 两个按键； 实现 字母键盘 和 数字键盘 的切换；
    PTKeyType_SpaceKey,             //!< 空格键
    PTKeyType_ReturnKey,            //!< 完成键
    PTKeyType_Num,                  //!< 数字键
}PTKeyType;

/**
 @ingroup keyboardSingleKeyModuleEnum
 键盘 按键种类 状态 的枚举
 */
typedef enum {
    PTHybridKeyState_CHARACTERS_LOWERCASE = 0,  //!< 小写字母键 状态
    PTHybridKeyState_CHARACTERS_UPPERCASE,      //!< 大写字母键 状态
    PTHybridKeyState_NUM_SPECIAI,               //!< 数字特殊字母键 状态
    PTHybridKeyState_SPECIAI,                   //!< 特殊键 状态
    PTHybridKeyState_NUM                        //!< 数字键 状态
}PTHybridKeyState;

/**
 @ingroup keyboardSingleKeyModuleEnum
 * 混合键位置类型 <br/>（包括 左、中、右）
 */
typedef enum {
    PTHybridKeySite_left = 0,           //!< 左
    PTHybridKeySite_center,             //!< 中
    PTHybridKeySite_right,              //!< 右
}PTHybridKeySite;

/**
 @ingroup keyboardSingleKeyModuleEnum
 键盘类型
 */
typedef enum {
    PTHybridKeyboardType_NumAndS,       //!< 数字 字母 键盘
    PTHybridKeyboardType_Char,          //!< 字母 键盘
}PTHybridKeyboardType;

/**
 @ingroup keyboardSingleKeyModuleStruct
 iPhone 键盘的排列矩阵 结构体
 */
typedef struct {
    CGRect leftShiftButtonFrame;        //!< 左Shift按键的Frame
    CGRect deleteButtonFrame;           //!< 删除按键的Frame
    
    CGRect nextKeyboardButtonFrame;     //!< 下一个 按键的Frame
    CGRect spaceButtonFrame;            //!< 空格键盘的Frame
    CGRect returnButtonFrame;           //!< 返回按键的Frame
    
    CGFloat cornerRadius;               //!< 边框角度
    CGSize hybridkeySize;               //!< 按键大小
    
} PhoneKeyboardMetrics;

/**
 @ingroup keyboardSingleKeyModuleStruct
 * 按键所在键盘的位置 结构体：<br/>例如几行几列，
 */
typedef struct {
    int keyRow;                         //!< 按键所在行
    int keyColumn;                      //!< 按键所在列
    PTHybridKeySite site;               //!< 按键位置信息
} PTSection;

/**
 @ingroup keyboardSingleKeyModuleStruct
 * 按键大小，位置，类型结构体
 */
typedef struct {
    CGRect keyRect;                     //!< 按键大小
    PTHybridKeySite site;               //!< 按键位置
    PTSection keySection;               //!< 按键位置
    PTKeyType keyType;                  //!< 按键类型
} PTKeyMetric;

/**
 @ingroup keyboardSingleKeyModuleStruct
 键盘 按键的排列方式 结构体
 */
typedef struct {
    float keyEdgeMargin;                //!< 边缘留白距离
    float keyBottomMargin;              //!< 顶部底部留白距离
    float keyRowMargin;                 //!< 行间距
    float keyColumnMargin;              //!< 列间距
    int rowNum;                         //!< 行数
    int columnNum;                      //!< 列数
}SudokuMargin;


#endif
