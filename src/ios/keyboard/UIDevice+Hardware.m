//
//  UIDevice+Hardware.m
//  testPastry
//
//  Created by 耿远超 on 16/12/21.
//
//

#import "UIDevice+Hardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDevice (Hardware)

static NSString *_ptmachine;
static dispatch_once_t ptmachineonceToken;

- (NSString *)pt_getDeviceType{
    //    /** 20151014 经业务要求统一识别为iPhone */
    //    return @"iphone";
    if ([[self pt_machine] rangeOfString:@"iPad"].location != NSNotFound) {
        return @"ipad";
    }else if ([[self pt_machine] rangeOfString:@"iPhone"].location != NSNotFound) {
        return @"iphone";
    }
    return @"iphone";
}

- (NSString *)pt_machine {
    
    dispatch_once(&ptmachineonceToken, ^{
        
#if TARGET_IPHONE_SIMULATOR
        
        // hack for core simulator, device plist is ~/Library/Developer/CoreSimulator/Devices/DEVICE-UUID/device.plist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths firstObject];
        NSString *devicePlist = [NSString pathWithComponents:[[libraryDirectory pathComponents] arrayByAddingObjectsFromArray:@[@"..", @"..", @"device.plist"]]];
        NSDictionary *deviceDescription = [NSDictionary dictionaryWithContentsOfFile:devicePlist];
        NSString *deviceType = deviceDescription[@"deviceType"];
        
        if ([deviceType hasSuffix:@"iPhone-4s"]) {
            _ptmachine = @"iPhone4,";
        } else if ([deviceType hasSuffix:@"iPhone-5"]) {
            _ptmachine = @"iPhone5,";
        } else if ([deviceType hasSuffix:@"iPhone-5s"]) {
            _ptmachine = @"iPhone6,";
        } else if ([deviceType hasSuffix:@"iPhone-6"]) {
            _ptmachine = @"iPhone7,2";
        } else if ([deviceType hasSuffix:@"iPhone-6-Plus"]) {
            _ptmachine = @"iPhone7,1";
        } else if ([deviceType hasSuffix:@"iPad-2"]) {
            _ptmachine = @"iPad2,";
        } else if ([deviceType hasSuffix:@"iPad-Retina"]) {
            _ptmachine = @"iPad3,";
        } else if ([deviceType hasSuffix:@"iPad-Air"]) {
            _ptmachine = @"iPad4,";
        } else {
            _ptmachine = @"Unknown simulator model";
            //            NSAssert(NO, @"Unknown simulator model");
        }
#else
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _ptmachine = [NSString stringWithUTF8String:machine];
        free(machine);
#endif
    });
    
    return _ptmachine;
}

@end
