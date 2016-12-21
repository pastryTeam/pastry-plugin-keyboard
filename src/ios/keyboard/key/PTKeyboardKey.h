//
//  PTKeyboardKey.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Metrics.h"
#import "PTKeyboardConstant.h"

/**
 @ingroup keyboardSingleKeyModuleClass
 按键基类
 */
@interface PTKeyboardKey : UIButton

@property (nonatomic, copy, readonly)NSString *normalTitle;
@property (nonatomic, copy, readonly)NSString *normalOutput;
@property (nonatomic, copy, readonly)NSString *selectedTitle;
@property (nonatomic, copy, readonly)NSString *selectedOutput;
@property (nonatomic, assign)PTHybridKeySite keySite;
@property (nonatomic, assign)PTKeyType keyType;

@property (nonatomic, assign)PTKeyMetric keyMetric;

+ (instancetype)keyWithType:(PTKeyMetric)keyMetric;


- (void)setNormalTitle:(NSString *)title outputString:(NSString *)output;

- (void)setSelectedTitle:(NSString *)title outputString:(NSString *)output;

- (void)setNormalBackgroundImage:(UIImage *)normalImage SelectedBackgroundImage:(UIImage *)selectedImage;

- (NSString *)keyOutput;

- (NSData *)keyEncryptOutput;

- (void)reloadWithKeyMetric:(PTKeyMetric)keyMetric;


@end
