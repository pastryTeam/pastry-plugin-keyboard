//
//  PTKeyViewLayer.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyViewLayer.h"

@implementation PTKeyViewLayer
@synthesize charText = _charText;
@synthesize keyRect = _keyRect;
@synthesize topImage = _topImage;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context
{
    keytopImage = [_topImage CGImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(_keyRect.size.width, _keyRect.size.height));
    CGContextTranslateCTM(context, 0.0, _keyRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, _keyRect.size.width, _keyRect.size.height), keytopImage);
    UIGraphicsEndImageContext();
    
    UIGraphicsPushContext (context);
    CGContextTranslateCTM(context, 0.0, _keyRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    NSString *text = _charText;
    [[UIColor blackColor] set];
    
    [text drawInRect:CGRectMake(0.0, 20, _keyRect.size.width, 30) withFont:[UIFont fontWithName:@"Helvetica" size:24]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    UIGraphicsPopContext();
}


- (void)updateLayerByKeyMetric:(PTKeyMetric)keyMetric{

    float originX = 0;
    float originWidth = 52;
    float scale = 52/26.0f;
    float width = keyMetric.keyRect.size.width * scale;
    float height = 103;
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    NSString *name = @"key_touch_m@2x";
    if (keyMetric.keySection.keyRow == 2 &&
        keyMetric.keyType == PTKeyType_Hybridkey_NumAndS ) { //底部宽按扭
        scale = 57/36.0f;
        originWidth = 57;
        width = keyMetric.keyRect.size.width * scale;
        originX = keyMetric.keyRect.origin.x - (width-keyMetric.keyRect.size.width)/2;
        name = @"key_touch_m2@2x";
    } else if (keyMetric.site == PTHybridKeySite_left) { //左边界
        scale = 53/26.0f;
        originWidth = 53;
        width = keyMetric.keyRect.size.width * scale;
        originX = keyMetric.keyRect.origin.x;
        name = @"key_touch_l@2x";
    } else if (keyMetric.site == PTHybridKeySite_right) { //右边界
        scale = 53/26.0f;
        originWidth = 53;
        width = keyMetric.keyRect.size.width * scale;
        originX = keyMetric.keyRect.origin.x - (width - keyMetric.keyRect.size.width);
        name = @"key_touch_r@2x";
    } else {
        originX = keyMetric.keyRect.origin.x - (width-keyMetric.keyRect.size.width)/2;
    }
    height = height * width/originWidth;
    float originY = keyMetric.keyRect.origin.y - (height-keyMetric.keyRect.size.height - 1);

    [self setTopImage:PTKeyboardResources_Char(name, @"png")];
    
    [self setKeyRect:CGRectMake(originX, originY, width, height)];
    [self setFrame:CGRectMake(originX, originY, width, height)];
    [self setNeedsDisplay];
    self.opacity = 1.0;

    [CATransaction commit];
    
}

@end
