//
//  PTKeyboardiPad.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboardiPad.h"

@implementation PTKeyboardiPad{
    BOOL sound_enable;
    BOOL shift_enable;
    NSString *desKey1;
    NSString *desKey2;
    NSString *desKey3;
    NSInteger maxLength;
    
    BOOL isShowInput;
    NSMutableString *plainText;
    NSMutableString *inputStat;
}

- (void)dealloc
{

}


- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    self = [super init];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:165/255.f green:167/255.f blue:173/255.f alpha:1.f]];
        
        sound_enable = enable;
        shift_enable = NO;
        isShowInput = isShowText;
        plainText = [NSMutableString string];
        [plainText setString:@""];
        inputStat = [NSMutableString string];
        [inputStat setString:@""];
        
        desKey1 = [NSString stringWithFormat:@"%@", key1];
        desKey2 = [NSString stringWithFormat:@"%@", key2];
        desKey3 = [NSString stringWithFormat:@"%@", key3];
        
        self.encryptStrData = [NSMutableData data];
        [self.encryptStrData setLength:0];
        
        if (length > 0) { //张千通
            maxLength = length;
        } else {
            maxLength = -1;
        }
        //乱序
        NSArray *numbers = [self randomArray:NUMS];
        //数字键盘
        for (int i = 0; i < numbers.count; i++) {
            UIButton *button = (UIButton *)[self viewWithTag:i + 1];
            [button setTitle:[NSString stringWithFormat:@"%@", [numbers objectAtIndex:i]] forState:UIControlStateNormal];
        }
    }
    
    return self;
}

- (void)emptyEncryptData
{
    [self.encryptStrData setLength:0];
    [inputStat setString:@""];
}


/**
 *将数字键数组进行乱序排列
 */
- (NSArray *)randomArray: (NSArray *)nums{
    
    NSMutableArray *destArray = [[NSMutableArray alloc]init];
    
    //首先将原数组的值赋给临时数组
    NSMutableArray *tmp=[NSMutableArray arrayWithArray:nums];
    int num = (int)[tmp count];
    
    //进行一个循环随机地从tmp中取出一个元素,然后赋给destArray
    for(int i=0; i<num ;i++)
    {
        srand((unsigned)time(0));
        int j=rand()%(num-i);
        [destArray addObject:[tmp objectAtIndex:j]];
        [tmp removeObjectAtIndex:j];
    }
    return destArray;
}


- (IBAction)keyPressedAction:(UIButton *)button {
    if (sound_enable) {
        [self keySound];
    }
    
    [self keyPressed:button.titleLabel.text];
}

- (IBAction)doneKeyPressed:(id)sender {
    if (self.keyDelegate != nil && [self.keyDelegate respondsToSelector:@selector(didDoneKeyPressed:encryptData:plainText:keyStat:)]) {
        NSMutableDictionary *stat = [NSMutableDictionary dictionary];
        int numCount = 0;
        int charCount = 0;
        for (int i = 0; i < inputStat.length; i++) {
            unichar single = [inputStat characterAtIndex:i];
            if (single == '0') {
                numCount++;
            } else {
                charCount++;
            }
        }
        [stat setObject:[NSString stringWithFormat:@"%d", numCount] forKey:@"num"];
        [stat setObject:[NSString stringWithFormat:@"%d", charCount] forKey:@"char"];
        
        [self.keyDelegate didDoneKeyPressed:self encryptData:self.encryptStrData plainText:plainText keyStat:stat];
    }
}

//数字与字母按下
- (void)keyPressed:(NSString *)keyValue
{
    PTLogDebug(@"key pressed keyvalue = %@",keyValue);
    if (maxLength >= 0 && plainText.length >= maxLength) {//有最大长度限制，且输入的字符已经超出了最大长度限制
        return;
    }
    
    NSData *tempData = [PT3Des encrypt:[NSData dataWithBytes:[[NSString stringWithFormat:@"%@", keyValue] UTF8String] length:keyValue.length] key1:desKey1 key2:desKey2 key3:desKey3];
    [self.encryptStrData appendData:tempData];
    
    unichar single = [keyValue characterAtIndex:0];
    if (single >= '0' && single <= '9') {
        [inputStat appendString:@"0"]; //0表示输入的是数字
    } else {
        [inputStat appendString:@"1"]; //1表示输入的是字母
    }
    
    if (isShowInput) {
        [plainText appendString:keyValue];
    } else {
        [plainText appendString:@"*"];
    }
    
    if (self.keyDelegate != nil && [self.keyDelegate respondsToSelector:@selector(didKeyPressed:encryptData:plainText:keyStat:)]) {
        NSMutableDictionary *stat = [NSMutableDictionary dictionary];
        int numCount = 0;
        int charCount = 0;
        for (int i = 0; i < inputStat.length; i++) {
            unichar single = [inputStat characterAtIndex:i];
            if (single == '0') {
                numCount++;
            } else {
                charCount++;
            }
        }
        [stat setObject:[NSString stringWithFormat:@"%d", numCount] forKey:@"num"];
        [stat setObject:[NSString stringWithFormat:@"%d", charCount] forKey:@"char"];
        
        [self.keyDelegate didKeyPressed:self encryptData:self.encryptStrData plainText:plainText keyStat:stat];
    }
}

//删除键操作
- (IBAction)backspaceKeyPressed:(id)sender
{
    if (sound_enable) {
        [self keySound];
    }
    
    NSUInteger length = self.encryptStrData.length;
    if (length > 0) {
        [self.encryptStrData setLength:length - 8]; //单字符被3DES加密后，会变成8字节的密文，因此删除一个字符相当于删除了8个字节的密文
        
        NSString *substring = [inputStat substringWithRange:NSMakeRange(0, inputStat.length - 1)];
        [inputStat setString:substring];
        
        substring = [plainText substringWithRange:NSMakeRange(0, plainText.length - 1)];
        [plainText setString:substring];
    }
    
    if (self.keyDelegate != nil && [self.keyDelegate respondsToSelector:@selector(didBackspaceKeyPressed:encryptData:plainText:keyStat:)]) {
        NSMutableDictionary *stat = [NSMutableDictionary dictionary];
        int numCount = 0;
        int charCount = 0;
        for (int i = 0; i < inputStat.length; i++) {
            unichar single = [inputStat characterAtIndex:i];
            if (single == '0') {
                numCount++;
            } else {
                charCount++;
            }
        }
        [stat setObject:[NSString stringWithFormat:@"%d", numCount] forKey:@"num"];
        [stat setObject:[NSString stringWithFormat:@"%d", charCount] forKey:@"char"];
        
        [self.keyDelegate didBackspaceKeyPressed:self encryptData:self.encryptStrData plainText:plainText keyStat:stat];
    }
    
}


//大小写切换
- (IBAction)didShiftKeyPressed:(UIButton *)button{
    if (sound_enable) {
        [self keySound];
    }
    
    NSArray *subViews = [self subviews];
    
    if(shift_enable){
        
        [button setImage:PTKeyboardResources_Char(@"key-shift@2x",@"png") forState:UIControlStateNormal];

        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                NSString *charKey =[NSString stringWithFormat:@"%@", btn.titleLabel.text];
                if ([charKey isEqualToString:@"shift"] || [charKey isEqualToString:@"SHITF"]) {

                    [btn setImage:PTKeyboardResources_Char(@"key-shift-l", @"png") forState:UIControlStateNormal];
                }
                if (![charKey isEqualToString:@"Done"]) {
                    [btn setTitle:[charKey lowercaseString] forState:(UIControlStateNormal)];
                }
                
            }
            
        }
        
        shift_enable = NO;
    }else{
        for (UIView *view in subViews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                NSString *charKey =[NSString stringWithFormat:@"%@", btn.titleLabel.text];
                if ([charKey isEqualToString:@"shift"] || [charKey isEqualToString:@"SHITF"]) {
                    [btn setImage:PTKeyboardResources_Char(@"key-shift-blue-l", @"png") forState:UIControlStateNormal];
                }
                if (![charKey isEqualToString:@"Done"]) {
                    [btn setTitle:[charKey uppercaseString] forState:(UIControlStateNormal)];
                }
            }
            
        }
        
        [button setImage:PTKeyboardResources_Char(@"key-shift-blue-l", @"png") forState:UIControlStateNormal];
        shift_enable = YES;
    }
}


@end