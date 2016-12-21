//
//  UIDevice+Hardware.h
//  testPastry
//
//  Created by 耿远超 on 16/12/21.
//
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

/**
 *  获取当前设备类型
 *
 *  @return 当前设备类型
 */
- (NSString *)pt_getDeviceType;

/**
 *  获取当前设备型号
 *
 *  @return 当前设备型号
 */
- (NSString *)pt_machine;

@end
