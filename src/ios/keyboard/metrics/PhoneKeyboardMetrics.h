//
//  PhoneKeyboardMetrics.h
//  PT
//
//  Created by 耿远超 on 15/9/20.
//  Copyright (c) 2015年 耿远超. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "PTKeyboardConstant.h"

PhoneKeyboardMetrics getPhoneLinearKeyboardMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight);
/**
 *  获取特定keys的信息列表
 *
 *  @param keyboardWidth  键盘宽
 *  @param keyboardHeight 键盘高
 *
 *  @return 信息列表
 */
NSArray *getPhoneLinearKeyboardPublicMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight);

/**
 *  获取纯字母keys的信息列表
 *
 *  @param keyboardWidth  键盘宽
 *  @param keyboardHeight 键盘高
 *  @param keySize        key大小
 *
 *  @return 信息列表
 */
NSArray *getPhoneLinearHybridKeyboardCharKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,CGSize keySize);

/**
 *  获取数字与特殊字符混合keys的信息列表
 *
 *  @param keyboardWidth  键盘宽
 *  @param keyboardHeight 键盘高
 *  @param keySize        key大小
 *
 *  @return 信息列表
 */
NSArray *getPhoneLinearHybridKeyboardNumAndSKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,CGSize keySize);


/**
 *  获取九宫格方式(如2x2、3x3、4x3等)排列的keys的Metric列表(各key的size相等)
 *
 *  @param keyboardWidth  键盘宽度
 *  @param keyboardHeight 键盘高度
 *  @param margin         margin
 *
 *  @return 信息列表
 */
NSArray *getPhoneLinearSudokuKeyboardKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,SudokuMargin margin);



/**
 *  获取单个key的位置
 *
 *  @param index key索引
 *  @param type  key类型
 *
 *  @return 相应位置信息
 */
PTSection getSection(int index,PTHybridKeyboardType type);


SudokuMargin makeSudokuMargin(float keyEdgeMargin,
                              float keyBottomMargin,
                              float keyRowMargin,
                              float keyColumnMargin,
                              int rowNum,
                              int columnNum);


