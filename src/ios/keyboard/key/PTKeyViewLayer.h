//
//  PTKeyViewLayer.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "PTKeyboardConstant.h"

/**
 @ingroup keyboardSingleKeyModuleClass
 对每个按键 做动画效果的 图层；
 */
@interface PTKeyViewLayer : CALayer{
@private
    CGImageRef keytopImage;
    
}
@property (nonatomic, retain) NSString *charText;
@property (nonatomic, assign) CGRect keyRect;
@property (nonatomic, retain) UIImage *topImage;

- (void)updateLayerByKeyMetric:(PTKeyMetric)keyMetric;

@end
