//
//  PTKeyboardiPhone.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTKeyboardiPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "UIDevice+Hardware.h"

#import "Metrics.H"
#import "PTKeyboardHybridkey.h"
#import "PTKeyboardKey.h"
#import "PTKeyboardPublickey.h"
#import "PTKeyboardHybridShiftKey.h"
#import "PTKeyViewLayer.h"

#define KEYTOP_HEIGHT 103

@interface PTKeyboardiPhone ()

//@property (nonatomic, retain) NSArray *charactorArray;

@end


@implementation PTKeyboardiPhone{
    BOOL soundEnable; //是否大小写
    BOOL capsEnable;  //大小写
    NSString *desKey1;
    NSString *desKey2;
    NSString *desKey3;
    
    BOOL isShowInput;
    NSMutableString *plainText;
    NSMutableString *inputStat;
    
    PTKeyboardType kbType;  //键盘类型
    //BOOL isRandomSort;  //是否随机排列
    PTKeyboardRandomType randomType;
    
    NSInteger maxLength;
    
    
    int keyboard_W;
    int keyboard_H;
    
    /**  新增 */
    NSMutableArray *_hybridkeys;
    NSArray *_charkeysMetrics;
    NSArray *_numAndSkeysMetrics;
    NSMutableArray *_publicKeys;
    PTKeyboardHybridShiftKey *_shiftKey;
    PTKeyViewLayer *_keyTopLayer;
}

- (void)dealloc
{

}

- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText isRandomSort:(BOOL)randomSort length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    PTKeyboardRandomType randomTypeTemp = PTKeyboardRandomTypeDefault;
    if (randomSort) {
        randomTypeTemp = PTKeyboardRandomTypePunctuation;
    }
    
    return [self initWithResponder:enable isShowText:isShowText randomType:randomTypeTemp length:length key1:key1 key2:key2 key3:key3];
}


- (id)initWithResponder:(BOOL)enable isShowText:(BOOL)isShowText randomType:(PTKeyboardRandomType)randType length:(NSInteger)length key1:(NSString *)key1 key2:(NSString *)key2 key3:(NSString *)key3
{
    keyboard_W = Keyboard_W;
    getKeyboard_H(keyboard_H, keyboard_W);
    self = [super initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-keyboard_H, keyboard_W, keyboard_H)];
    if (self) {
        soundEnable = enable;
        capsEnable = NO;
        isShowInput = isShowText;
//        isRandomSort = randomSort;
        randomType = randType;
        kbType = PTKeyboardTypeDefault;
        
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
        
//        self.charactorArray = CHARACTERS_LOWER;
        
        [self initView]; //初始化布局
        
//        if (isRandomSort) {
//            self.charactorArray = [self randomArray:CHARACTERS_LOWER];
//            for (int i = 0; i < self.charactorArray.count; i++) {
//                UIButton *button = (UIButton *)[self viewWithTag:i + 1];
//                [button setTitle:[NSString stringWithFormat:@"%@", [self.charactorArray objectAtIndex:i]] forState:UIControlStateNormal];
//            }
//        }
        //点击Layer
        if (![[[UIDevice currentDevice] pt_getDeviceType] isEqualToString:@"ipad"]) {
            _keyTopLayer = [PTKeyViewLayer layer];
            [self.layer addSublayer:_keyTopLayer];
        }
        
    }
    
    return self;
}

/**
 * 键盘View布局
 */
- (void)initView {
    self.layer.contents = (id)PTKeyboardResources_Char(@"keyboard_background@2x",@"png").CGImage;
    
    PhoneKeyboardMetrics metrics = getPhoneLinearKeyboardMetrics(keyboard_W, keyboard_H);
    
    NSArray *publicMetrics = getPhoneLinearKeyboardPublicMetrics(keyboard_W, keyboard_H);
    
    [publicMetrics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PTKeyMetric keyMetric;
        objcToStruct(obj, keyMetric);
        PTKeyboardPublickey *key = nil;
        if (keyMetric.keyType == PTKeyType_ShiftKey_Chars) {
            key = [PTKeyboardHybridShiftKey keyWithType:keyMetric];
            _shiftKey = (PTKeyboardHybridShiftKey *)key;
        }else{
            key = [PTKeyboardPublickey keyWithType:keyMetric];
        }

        [key addTarget:self action:@selector(publickeyTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:key];
    }];
    
    _hybridkeys = [[NSMutableArray alloc]initWithCapacity:0];
    
    UIImage *keysImage = PTKeyboardResources_Char(@"key@2x", @"png");
    
    NSArray *charKeyTitles = CHARACTERS_LOWERCASE;
    
    //todo dongyy
    if (randomType == PTKeyboardRandomTypePunctuation || randomType == PTKeyboardRandomTypeNumberPunctuation) {
        
        charKeyTitles = [self randomArray:CHARACTERS_LOWERCASE];
    }
    //end
    
    _numAndSkeysMetrics = getPhoneLinearHybridKeyboardNumAndSKeysMetrics(keyboard_W, keyboard_H, metrics.hybridkeySize);
    _charkeysMetrics = getPhoneLinearHybridKeyboardCharKeysMetrics(keyboard_W, keyboard_H, metrics.hybridkeySize);
    [_charkeysMetrics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PTKeyMetric keyMetrics;
        objcToStruct(obj, keyMetrics);
        PTKeyboardHybridkey *key = [PTKeyboardHybridkey keyWithType:keyMetrics];
        [key reloadWithKeyMetric:keyMetrics];
        
        [key setBackgroundImage:keysImage forState:UIControlStateNormal];
        
        [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [key setNormalTitle:charKeyTitles[idx] outputString:charKeyTitles[idx]];
        [key.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
        key.layer.cornerRadius = metrics.cornerRadius;
        [key addTarget:self action:@selector(hybridkeyTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [key addTarget:self action:@selector(hybridkeyTouchDown:) forControlEvents:UIControlEventTouchDown];
        [key addTarget:self action:@selector(hybridkeyTouchUp:) forControlEvents:UIControlEventTouchDragOutside];
        [self addSubview:key];
        [_hybridkeys addObject:key];
    }];
    _keyTopLayer = [PTKeyViewLayer layer];
    [self.layer addSublayer:_keyTopLayer];
}


- (void)publickeyTouchUpInside:(PTKeyboardPublickey *)sender{
    if (soundEnable) {
        [self keySound];
    }
    
    switch (sender.keyType) {
        case PTKeyType_NextKey:{
            if (sender.selected) {
                [self changeHybridKeysState:PTHybridKeyState_CHARACTERS_LOWERCASE];
                _shiftKey.keyType = PTKeyType_ShiftKey_Chars;
                [_shiftKey setNormalBackgroundImage:PTKeyboardResources_Char(@"shift_normal@2x", @"png") SelectedBackgroundImage:PTKeyboardResources_Char(@"shift_selected@2x", @"png")];
                [_shiftKey setNormalTitle:@"" outputString:nil];
                [_shiftKey setSelectedTitle:@"" outputString:nil];
            }else{
                [self changeHybridKeysState:PTHybridKeyState_NUM_SPECIAI];
                _shiftKey.keyType = PTKeyType_ShiftKey_NumAndS;
                [_shiftKey setNormalBackgroundImage:PTKeyboardResources_Char(@"gary_m@2x", @"png") SelectedBackgroundImage:PTKeyboardResources_Char(@"gary_m@2x", @"png")];
                [_shiftKey setNormalTitle:@"#+=" outputString:nil];
                [_shiftKey setSelectedTitle:@"123" outputString:nil];
            }
            _shiftKey.selected = NO;
            sender.selected = !sender.selected;
        }
            break;
        case PTKeyType_ShiftKey_Chars:{
            if (sender.selected) {
                [self changeHybridKeysState:PTHybridKeyState_CHARACTERS_LOWERCASE];
            }else{
                [self changeHybridKeysState:PTHybridKeyState_CHARACTERS_UPPERCASE];
            }
            sender.selected = !sender.selected;
        }
            break;
        case PTKeyType_ShiftKey_NumAndS:{
            if (sender.selected) {
                [self changeHybridKeysState:PTHybridKeyState_NUM_SPECIAI];
            }else{
                [self changeHybridKeysState:PTHybridKeyState_SPECIAI];
            }
            sender.selected = !sender.selected;
        }
            break;
        case PTKeyType_DeleteKey:{
            [self backspaceKeyPressed:sender];
        }
            break;
        case PTKeyType_ReturnKey:{
            [self doneKeyPressed:sender];
        }
            break;
        default:{
            [self hybridkeyTouchUpInside:(PTKeyboardHybridkey *)sender];
        }
            break;
    }
}

- (void)changeHybridKeysState:(PTHybridKeyState)hybridKeyState{
    
    NSArray *hybridKeyTitles = nil;
    NSArray *hybridKeyRects = nil;
    switch (hybridKeyState) {
        case PTHybridKeyState_CHARACTERS_LOWERCASE:{
            hybridKeyTitles = CHARACTERS_LOWERCASE;
            //todo dongyy
            if (randomType == PTKeyboardRandomTypePunctuation || randomType == PTKeyboardRandomTypeNumberPunctuation) {
                
                hybridKeyTitles = [self randomArray:CHARACTERS_LOWERCASE];
            }
            //end
            
            hybridKeyRects = [NSArray arrayWithArray:_charkeysMetrics];
            ((UIButton *)_hybridkeys[25]).hidden = NO;
        }
            break;
        case PTHybridKeyState_CHARACTERS_UPPERCASE:{
            hybridKeyTitles = CHARACTERS_UPPERCASE;
            //todo dongyy
            if (randomType == PTKeyboardRandomTypePunctuation || randomType == PTKeyboardRandomTypeNumberPunctuation) {
                
                hybridKeyTitles = [self randomArray:CHARACTERS_UPPERCASE];
            }
            //end
            
            hybridKeyRects = [NSArray arrayWithArray:_charkeysMetrics];
            ((UIButton *)_hybridkeys[25]).hidden = NO;
        }
            break;
        case PTHybridKeyState_NUM_SPECIAI:{
            
            
            hybridKeyTitles = NUM_SPECIAI;
            //todo dongyy
            if (randomType == PTKeyboardRandomTypeNumberPunctuation || randomType == PTKeyboardRandomTypeNumber) {
                
                NSRange range = NSMakeRange(0, 10);
                NSArray *numArr = [NUM_SPECIAI subarrayWithRange:range];
                numArr = [self randomArray:numArr];
                NSMutableArray *muSpeciai = [NSMutableArray arrayWithArray:NUM_SPECIAI];
                [muSpeciai replaceObjectsInRange:range withObjectsFromArray:numArr];
                hybridKeyTitles = muSpeciai;

            }
            //end
            
            hybridKeyRects = [NSArray arrayWithArray:_numAndSkeysMetrics];
            ((UIButton *)_hybridkeys[25]).hidden = YES;
        }
            break;
        case PTHybridKeyState_SPECIAI:{
            hybridKeyTitles = SPECIAI;
            hybridKeyRects = [NSArray arrayWithArray:_numAndSkeysMetrics];
            ((UIButton *)_hybridkeys[25]).hidden = YES;
        }
            break;
        default:
            break;
    }
    [hybridKeyRects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PTKeyMetric keyMetrics;
        objcToStruct(hybridKeyRects[idx], keyMetrics);
        PTKeyboardHybridkey *key = _hybridkeys[idx];
        [key setNormalTitle:hybridKeyTitles[idx] outputString:hybridKeyTitles[idx]];
        [key reloadWithKeyMetric:keyMetrics];
    }];
}

- (void)hybridkeyTouchUpInside:(PTKeyboardHybridkey *)key{
    
    if (![[[UIDevice currentDevice] pt_getDeviceType] isEqualToString:@"ipad"]) {
        [self hybridkeyTouchUp:key];
    }
    [self keyPressed:key.keyOutput];
}

- (void)hybridkeyTouchDown:(PTKeyboardHybridkey *)key{
    if (![[[UIDevice currentDevice] pt_getDeviceType] isEqualToString:@"ipad"]) {
        [_keyTopLayer setCharText:key.titleLabel.text];
        [_keyTopLayer updateLayerByKeyMetric:key.keyMetric];
    }
}

- (void)hybridkeyTouchUp:(PTKeyboardHybridkey *)key{
    [_keyTopLayer setCharText:@""];
    _keyTopLayer.opacity = 0;
    [self setNeedsDisplay];
    [_keyTopLayer setNeedsDisplay];
}

/****************************************************************************************************/

/**
 * 清空加密数据
 */
- (void)emptyEncryptData
{
    [self.encryptStrData setLength:0];
    [inputStat setString:@""];
    [plainText setString:@""];
}

/**
 *将数组进行乱序排列
 *@param nums  排序的数组
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

- (IBAction)doneKeyPressed:(id)sender
{
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

//按钮按下
- (void)keyPressed:(NSString *)keyValue
{
    PTLogDebug(@"key pressed keyvalue = %@",keyValue);
    if (maxLength >= 0 && plainText.length >= maxLength) {//有最大长度限制，且输入的字符已经超出了最大长度限制
        return;
    }
    
    NSData *tempData = [PT3Des encrypt:[NSData dataWithBytes:[[NSString stringWithFormat:@"%@",keyValue] UTF8String] length:keyValue.length] key1:desKey1 key2:desKey2 key3:desKey3];
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
        
        PTLogDebug(@"key pressed ready do delegate");
        
        [self.keyDelegate didKeyPressed:self encryptData:self.encryptStrData plainText:plainText keyStat:stat];
    }
    
    PTLogDebug(@"key pressed plainText = %@",plainText);
    PTLogDebug(@"key pressed encryptStrData = %@",[PTConverter bytesToHex:self.encryptStrData]);
    PTLogDebug(@"key pressed encryptStrData length = %zd",[PTConverter bytesToHex:self.encryptStrData].length);
    
}

//删除键操作
- (IBAction)backspaceKeyPressed:(id)sender{
    NSUInteger length = self.encryptStrData.length;
    if (length > 0) {
        [self.encryptStrData setLength:length - 8];  //单字符被3DES加密后，会变成8字节的密文，因此删除一个字符相当于删除了8个字节的密文
        
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

@end
