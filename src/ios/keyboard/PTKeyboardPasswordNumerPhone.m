//
//  PTKeyboardPasswordNumerPhone.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboardPasswordNumerPhone.h"

#import "Metrics.h"
#import "PTKeyboardKey.h"

#define space .2

#define PT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define PT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation PTKeyboardPasswordNumerPhone{
    BOOL soundEnable; //是否大小写
    BOOL capsEnable;  //大小写
    NSString *desKey1;
    NSString *desKey2;
    NSString *desKey3;
    
    BOOL isShowInput;
    NSMutableString *plainText;
    NSMutableString *inputStat;
    
//    BOOL isRandomSort;  //是否随机排列
    PTKeyboardRandomType randomType;
    
    NSInteger maxLength;
    
    int keyboard_W;
    int keyboard_H;
    float scale;
    float key_H;
    float key_W;
    float space_W;
    
}

- (void)dealloc
{

}


- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    PTKeyboardRandomType randomTypeTemp = PTKeyboardRandomTypeDefault;
    if (randomSort) {
        randomTypeTemp = PTKeyboardRandomTypeNumber;
    }
    
    return [self initWithResponder:enable isShowText:isShowText randomType:randomTypeTemp length:length key1:key1 key2:key2 key3:key3];
}


- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText randomType:(PTKeyboardRandomType)randType length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    keyboard_W = Keyboard_W;
    getKeyboard_H(keyboard_H, keyboard_W);
    key_H = keyboard_H/4.0f;
    key_W = PT_SCREEN_WIDTH/3.0f;
    self = [super initWithFrame:CGRectMake(0, 0, keyboard_W, keyboard_H)];
    if (self) {
        
        self.needEncrypt = true;
        soundEnable = enable;
        capsEnable = NO;
        isShowInput = isShowText;
        randomType = randType;
        
        plainText = [NSMutableString string];
        [plainText setString:@""];
        inputStat = [NSMutableString string];
        [inputStat setString:@""];
        
        if (length > 0) {
            maxLength = length;
        } else {
            maxLength = -1;
        }
        
        desKey1 = [NSString stringWithFormat:@"%@", key1];
        desKey2 = [NSString stringWithFormat:@"%@", key2];
        desKey3 = [NSString stringWithFormat:@"%@", key3];
        
        self.encryptStrData = [NSMutableData data];
        [self.encryptStrData setLength:0];
        
        [self initView];
        
//        if (isRandomSort) {
//            //乱序
//            NSArray *numbers = [self randomArray:NUMS];
//            //数字键盘
//            for (int i = 0; i < numbers.count; i++) {
//                UIButton *button = (UIButton *)[self viewWithTag:i + 1];
//                [button setTitle:[NSString stringWithFormat:@"%@", [numbers objectAtIndex:i]] forState:UIControlStateNormal];
//            }
//        }
    }
    
    return self;
}

- (void)initView {
    
    self.layer.contents = (id)PTKeyboardResources_Number(@"keyboard_number_background@2x",@"png").CGImage;
    
    NSArray *numKeysMetrics = getPhoneLinearSudokuKeyboardKeysMetrics(keyboard_W, keyboard_H, makeSudokuMargin(space, space, space, space, 4, 3));
    
    NSArray *keyTitles = NUM;
    if (randomType == PTKeyboardRandomTypeNumberPunctuation || randomType == PTKeyboardRandomTypeNumber) {
        
        NSArray *number = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
        NSString *empty = @"";
        NSString *com = @"完成";
        number = [self randomArray:number];
        NSMutableArray *muSpeciai = [NSMutableArray arrayWithArray:number];
        [muSpeciai insertObject:empty atIndex:9];
        [muSpeciai addObject:com];
        keyTitles = muSpeciai;
    }
    [numKeysMetrics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PTKeyMetric keyMetric;
        objcToStruct(obj, keyMetric);
        PTKeyboardKey *key = [PTKeyboardKey keyWithType:keyMetric];
        [key setNormalTitle:keyTitles[idx] outputString:keyTitles[idx]];
        if (keyMetric.keySection.keyRow == 3 && keyMetric.keySection.keyColumn == 0) {
            /** 删除按钮 */
            keyMetric.keyType = PTKeyType_DeleteKey;
            [key setBackgroundImage:PTKeyboardResources_Number(@"number_delete@2x", @"png") forState:UIControlStateNormal];
            [key setNormalTitle:keyTitles[idx] outputString:nil];
        }else if (keyMetric.keySection.keyRow == 3 && keyMetric.keySection.keyColumn == 2){
            /** 完成按钮 */
            keyMetric.keyType = PTKeyType_ReturnKey;
            [key setBackgroundImage:PTKeyboardResources_Number(@"number_key_highlighted@2x", @"png") forState:UIControlStateNormal];
            [key setNormalTitle:keyTitles[idx] outputString:nil];
        }else{
            [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [key.titleLabel setFont:[UIFont systemFontOfSize:25.f]];
            [key setBackgroundImage:PTKeyboardResources_Number(@"number_key@2x", @"png") forState:UIControlStateNormal];
            [key setBackgroundImage:PTKeyboardResources_Number(@"number_key_highlighted@2x", @"png") forState:UIControlStateHighlighted];
        }
        [key addTarget:self action:@selector(keyTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [key reloadWithKeyMetric:keyMetric];
        [self addSubview:key];
    }];
}


- (void)keyTouchUpInside:(PTKeyboardKey *)key{
    if (soundEnable) {
        [self keySound];
    }
    
    switch (key.keyType) {
        case PTKeyType_ReturnKey:{
            [self doneKeyPressed:key];
        }
            break;
        case PTKeyType_DeleteKey:{
            [self backspaceKeyPressed:key];
        }
            break;
        case PTKeyType_Num:{
            [self keyPressed:key.keyOutput];
        }
            break;
        default:
            break;
    }
}



/**
 * 清空加密数据
 */
- (void)emptyEncryptData
{
    PTLogDebug(@"clear emptydata");
    [self.encryptStrData setLength:0];
    [inputStat setString:@""];
    [plainText setString:@""];
}

/**
 *将数组进行乱序排列
 *@param nums  0-9的数字
 */
- (NSArray *)randomArray:(NSArray *)nums{
    
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



//按钮按下
- (void)keyPressed:(NSString *)keyValue
{
    
    PTLogDebug(@"maxLength %ld,plainText.Length %lu",(long)maxLength,(unsigned long)plainText.length);
    if (maxLength >= 0 && plainText.length >= maxLength) {//有最大长度限制，且输入的字符已经超出了最大长度限制
        return;
    }
    
    [self encryptInputString:keyValue desKey1:desKey1 desKey2:desKey2 desKey3:desKey3];
    
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
    PTLogDebug(@"key pressed plainText = %@",plainText);
    PTLogDebug(@"key pressed encryptStrData = %@",[PTConverter bytesToHex:self.encryptStrData]);
    PTLogDebug(@"key pressed encryptStrData length = %zd",[PTConverter bytesToHex:self.encryptStrData].length);
    
}

- (IBAction)backspaceKeyPressed:(id)sender{
    
    NSUInteger length = self.encryptStrData.length;
    if (length > 0) {
        //        [self.encryptStrData setLength:length - 8];  //单字符被3DES加密后，会变成8字节的密文，因此删除一个字符相当于删除了8个字节的密文
        [self deleteEncryptData];
        
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
    PTLogDebug(@"key pressed plainText = %@",plainText);
    PTLogDebug(@"key pressed encryptStrData = %@",[PTConverter bytesToHex:self.encryptStrData]);
    PTLogDebug(@"key pressed encryptStrData length = %zd",[PTConverter bytesToHex:self.encryptStrData].length);
    
}

- (IBAction)doneKeyPressed:(id)sender{
    
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
    PTLogDebug(@"key pressed plainText = %@",plainText);
    PTLogDebug(@"key pressed encryptStrData = %@",[PTConverter bytesToHex:self.encryptStrData]);
    PTLogDebug(@"key pressed encryptStrData length = %zd",[PTConverter bytesToHex:self.encryptStrData].length);
    
}

@end