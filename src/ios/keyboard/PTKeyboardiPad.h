//
//  PTKeyboardiPad.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboard.h"

/**
 @ingroup keyboardModuleClass
 @brief iPad 键盘类<br />
 本类为类做为自定义键盘的View<br />
 所有的有返回值的方法，指针类型返回值均返回nil<br />
 NSInteger类型的参见具体的方法返回值说明
 @todo  优化1.1注释：
 目前 iPad键盘 不支持乱序
 适配 iOS9 ，iPad的键盘初始化方式不变。以后关注此类的修改。因此：PTKeyboardiPad 与 PTKeyboardiPhone 使用类不用的初始化键盘的方式。
 */
@interface PTKeyboardiPad : PTKeyboard

@end
