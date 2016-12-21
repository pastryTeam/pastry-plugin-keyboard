//
//  PTKeyboardKey.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboardKey.h"

@implementation PTKeyboardKey


//- (void)dealloc{
//    
//    [_normalTitle release];
//    [_normalOutput release];
//    [_selectedTitle release];
//    [_selectedOutput release];
//    PTLogInfo(@"--------PTKeyboardKey dealloc-------");
//    [super dealloc];
//}

+ (instancetype)keyWithType:(PTKeyMetric)keyMetric{
    PTKeyboardKey *key = [PTKeyboardKey buttonWithType:UIButtonTypeCustom];
    return key;
}

- (void)setNormalTitle:(NSString *)title outputString:(NSString *)output{
    if (title) {
        _normalTitle = [NSString stringWithString:title];
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (output) {
        _normalOutput = [NSString stringWithString:output];
    }
}

- (void)setSelectedTitle:(NSString *)title outputString:(NSString *)output{
    if (title) {
        _selectedTitle = [NSString stringWithString:title];
        [self setTitle:title forState:UIControlStateSelected];
    }
    if (output) {
        _selectedOutput = [NSString stringWithString:output];
    }
}

- (void)setNormalBackgroundImage:(UIImage *)normalImage SelectedBackgroundImage:(UIImage *)selectedImage{
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self updateKeyBySelected:selected];
}

- (void)updateKeyBySelected:(BOOL)selected{
    
}

- (void)setKeyType:(PTKeyType)keyType{
    _keyType = keyType;
}

- (NSString *)keyOutput{
    if (self.selected) {
        return (!_selectedOutput)?_normalOutput:_selectedOutput;
    }
    return _normalOutput;
}

//TODO
- (NSData *)keyEncryptOutput{
    if (!self.keyOutput) return nil;
    return nil;
}


- (void)reloadWithKeyMetric:(PTKeyMetric)keyMetric{
    self.frame = keyMetric.keyRect;
    self.keySite = keyMetric.site;
    self.keyType = keyMetric.keyType;
    self.keyMetric = keyMetric;
}

@end
