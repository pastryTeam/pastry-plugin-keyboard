//
//  PTKeyboard.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboard.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PTKeyboard

@synthesize keyDelegate = _keyDelegate;
@synthesize encryptStrData = _encryptStrData;
@synthesize textData = _textData;

//- (void)dealloc
//{
//    _keyDelegate = nil;
//    _encryptStrData = nil;
//    _textData = nil;
//    [super dealloc];
//}

//+ (id)getKeyboardInstanceWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
//{
//    return nil;
//}
//
//+ (id)getKeyboardInstanceWithResponder:(BOOL)enable value:(NSString *)_value
//{
//    return nil;
//}
- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;
{
    return nil;
}

- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText randomType:(PTKeyboardRandomType)randType length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3;
{
    return nil;
}


- (id)initWithResponder:(BOOL)enable value:(NSString *)_value{
    return nil;
}

- (void)emptyEncryptData
{
    
}

//判断当前单例键盘是否是需要的子类键盘，如果不是则移除并将keyboard释放
- (void)checkSuitableKeyboard
{
    
}

- (void)refreshKeyboardWithRandomValue:(BOOL)random
{
    
}

- (void)encryptInputString:(NSString *)keyValue desKey1:(NSString *)desKey1 desKey2:(NSString *)desKey2 desKey3:(NSString *)desKey3
{
    if (self.needEncrypt) {
        NSData *tempData = [PT3Des encrypt:[NSData dataWithBytes:[[NSString stringWithFormat:@"%@",keyValue] UTF8String] length:keyValue.length] key1:desKey1 key2:desKey2 key3:desKey3];
        [self.encryptStrData appendData:tempData];
    } else {
        NSData *tmpData = [NSData dataWithBytes:[[NSString stringWithFormat:@"%@",keyValue] UTF8String] length:keyValue.length];
        [self.encryptStrData appendData:tmpData];
    }
}

- (void)deleteEncryptData {
    NSUInteger length = self.encryptStrData.length;
    if (self.needEncrypt) {
        if (length >= 8) {
            [self.encryptStrData setLength:length - 8];
        }
    } else {
        if (length >= 1) {
            [self.encryptStrData setLength:length - 1];
        }
    }
}


-(void)keySound{
    CFBundleRef mainbundle = CFBundleGetMainBundle();
    SystemSoundID soundFileObject;
    //获得声音文件URL
    CFURLRef soundfileurl=CFBundleCopyResourceURL(mainbundle,CFSTR("tap"),CFSTR("aif"),CFSTR("PTResources.bundle"));
    if (soundfileurl == nil) {
        return;
    }
    //创建system sound 对象
    AudioServicesCreateSystemSoundID(soundfileurl, &soundFileObject);
    //播放
    AudioServicesPlaySystemSound(soundFileObject);
    CFRelease(soundfileurl);
}

@end

