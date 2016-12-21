//
//  PTKeyboardPublickey.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboardPublickey.h"

@implementation PTKeyboardPublickey

+ (instancetype)keyWithType:(PTKeyMetric)keyMetric{
    
    PTKeyboardPublickey *key = [super keyWithType:keyMetric];
    PTKeyType keyType = keyMetric.keyType;
    key.frame = keyMetric.keyRect;
    key.keySite = keyMetric.site;
    key.keyType = keyType;
    key.layer.cornerRadius = 4;
    [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [key.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    //    [key setAdjustsImageWhenHighlighted:NO];
    switch (keyType) {
        case PTKeyType_ShiftKey_Chars:{
            [key setNormalBackgroundImage:PTKeyboardResources_Char(@"shift_normal@2x", @"png") SelectedBackgroundImage:PTKeyboardResources_Char(@"shift_selected@2x", @"png")];
            [key setNormalTitle:@"" outputString:nil];
            [key setSelectedTitle:@"" outputString:nil];
        }
            break;
        case PTKeyType_DeleteKey:{
            [key setBackgroundImage:PTKeyboardResources_Char(@"backDel@2x",@"png") forState:UIControlStateNormal];
        }
            break;
        case PTKeyType_NextKey:{
            [key setNormalTitle:@"#+123" outputString:nil];
            [key setSelectedTitle:@"ABC" outputString:nil];
            [key setBackgroundImage:PTKeyboardResources_Char(@"gary_m@2x",@"png") forState:UIControlStateNormal];
        }
            break;
        case PTKeyType_SpaceKey:{
            [key setNormalTitle:@"空格" outputString:@" "];
            [key setBackgroundImage:PTKeyboardResources_Char(@"space@2x",@"png") forState:UIControlStateNormal];
        }
            break;
        case PTKeyType_ReturnKey:{
            [key setNormalTitle:@"完成" outputString:nil];
            [key setBackgroundImage:PTKeyboardResources_Char(@"gary_m@2x",@"png") forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    return key;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
