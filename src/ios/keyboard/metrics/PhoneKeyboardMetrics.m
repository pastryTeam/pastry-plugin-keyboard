//
//  PhoneKeyboardMetrics.m
//  PT
//
//  Created by 林尤伟 on 15/9/20.
//  Copyright (c) 2015年 林尤伟. All rights reserved.
//

#import "PhoneKeyboardMetrics.h"
#import "UIDevice+Hardware.h"
#import "Linear.h"
#define kPhoneKeyboardPortraitWidth     320.0
#define kPhoneKeyboardLandscapeWidth    568.0

#define kPhoneKeyboardPortraitHeight    Keyboard_H*1.0
#define kPhoneKeyboardLandscapeHeight   162.0

#define edgeMargin      3.0
#define bottomMargin    3.0

#define hybrid_CharKeysCount  26
#define hybrid_numAndSKeysCount  25

#define topMargin    12.0

#define hybridKeyHeight(keyboardHeight) (keyboardHeight - 216)/4.0f + 39

PhoneKeyboardMetrics getPhoneLinearKeyboardMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight) {
    CGFloat rowMargin = LINEAR_EQ(keyboardHeight,
                                  keyboardHeight, 15.0,
                                  kPhoneKeyboardLandscapeHeight, 7.0);
    
    CGFloat columnMargin = LINEAR_EQ(keyboardWidth,
                                     kPhoneKeyboardPortraitWidth, 6.0,
                                     kPhoneKeyboardLandscapeWidth, 7.0);
    
    CGFloat keyHeight = hybridKeyHeight(keyboardHeight);
    
    /** 切换按钮按钮宽度 */
    CGFloat nextKeyboardButtonWidth = LINEAR_EQ(keyboardWidth,
                                                kPhoneKeyboardPortraitWidth, 74.0,
                                                kPhoneKeyboardLandscapeWidth, 107.0);
    /** 完成按钮宽度 */
    CGFloat returnButtonWidth = LINEAR_EQ(keyboardWidth,
                                          kPhoneKeyboardPortraitWidth, 74.0,
                                          kPhoneKeyboardLandscapeWidth, 107.0);
    
    /** 删除按钮宽度 */
    CGFloat deleteButtonWidth = LINEAR_EQ(keyboardWidth,
                                          kPhoneKeyboardPortraitWidth, 36.0,
                                          kPhoneKeyboardLandscapeWidth, 69.0);
    
    PhoneKeyboardMetrics metrics = {
        
        .nextKeyboardButtonFrame = {
            edgeMargin,
            keyboardHeight - bottomMargin - keyHeight,
            nextKeyboardButtonWidth,
            keyHeight
        },
        
        .returnButtonFrame = {
            keyboardWidth - edgeMargin - returnButtonWidth,
            keyboardHeight - bottomMargin - keyHeight,
            returnButtonWidth,
            keyHeight
        },
        
        .spaceButtonFrame = {
            edgeMargin + nextKeyboardButtonWidth + columnMargin,
            keyboardHeight - bottomMargin - keyHeight,
            keyboardWidth - (edgeMargin + nextKeyboardButtonWidth + columnMargin + columnMargin + returnButtonWidth + edgeMargin),
            keyHeight
        },
        
        .deleteButtonFrame = {
            keyboardWidth - edgeMargin - deleteButtonWidth,
            keyboardHeight - (bottomMargin + keyHeight + rowMargin + keyHeight),
            deleteButtonWidth,
            keyHeight
        },
        
        .leftShiftButtonFrame = {
            edgeMargin,
            keyboardHeight - (bottomMargin + keyHeight + rowMargin + keyHeight),
            LINEAR_EQ(keyboardWidth,
                      kPhoneKeyboardPortraitWidth, 36.0,
                      kPhoneKeyboardLandscapeWidth, 69.0),
            keyHeight
        },
        
        .hybridkeySize = {
            (keyboardWidth - columnMargin * 9 - edgeMargin * 2)/10.0f,
            keyHeight
        },
        
        .cornerRadius = ([[[UIDevice currentDevice] pt_machine] hasPrefix:@"iPhone7,1"] ? 5.0 : 4.0),
    };
    return metrics;
}

NSArray *getPhoneLinearKeyboardPublicMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight){
    CGFloat rowMargin = LINEAR_EQ(keyboardHeight,
                                  keyboardHeight, 15.0,
                                  kPhoneKeyboardLandscapeHeight, 7.0);
    
    CGFloat columnMargin = LINEAR_EQ(keyboardWidth,
                                     kPhoneKeyboardPortraitWidth, 6.0,
                                     kPhoneKeyboardLandscapeWidth, 7.0);
    
    CGFloat keyHeight = hybridKeyHeight(keyboardHeight);
    
    /** 切换按钮按钮宽度 */
    CGFloat nextKeyboardButtonWidth = LINEAR_EQ(keyboardWidth,
                                                kPhoneKeyboardPortraitWidth, 74.0,
                                                kPhoneKeyboardLandscapeWidth, 107.0);
    /** 完成按钮宽度 */
    CGFloat returnButtonWidth = LINEAR_EQ(keyboardWidth,
                                          kPhoneKeyboardPortraitWidth, 74.0,
                                          kPhoneKeyboardLandscapeWidth, 107.0);
    
    /** 删除按钮宽度 */
    CGFloat deleteButtonWidth = LINEAR_EQ(keyboardWidth,
                                          kPhoneKeyboardPortraitWidth, 36.0,
                                          kPhoneKeyboardLandscapeWidth, 69.0);
    PTKeyMetric shiftKeyMetric = {
        .keyRect = {
            edgeMargin,
            keyboardHeight - (bottomMargin + keyHeight + rowMargin + keyHeight),
            LINEAR_EQ(keyboardWidth,
                      kPhoneKeyboardPortraitWidth, 36.0,
                      kPhoneKeyboardLandscapeWidth, 69.0),
            keyHeight
        },
        PTHybridKeySite_left,
        .keySection = {
            2,
            0,
            PTHybridKeySite_left
        },
        PTKeyType_ShiftKey_Chars
    };
    PTKeyMetric deleteKeyMetric = {
        .keyRect = {
            keyboardWidth - edgeMargin - deleteButtonWidth,
            keyboardHeight - (bottomMargin + keyHeight + rowMargin + keyHeight),
            deleteButtonWidth,
            keyHeight
        },
        PTHybridKeySite_right,
        .keySection = {
            2,
            -999,
            PTHybridKeySite_right
        },
        PTKeyType_DeleteKey
    };
    PTKeyMetric nextKeyMetric = {
        .keyRect = {
            edgeMargin,
            keyboardHeight - bottomMargin - keyHeight,
            nextKeyboardButtonWidth,
            keyHeight
        },
        PTHybridKeySite_left,
        .keySection = {
            3,
            0,
            PTHybridKeySite_left
        },
        PTKeyType_NextKey
    };
    PTKeyMetric spaceKeyMetric = {
        .keyRect = {
            edgeMargin + nextKeyboardButtonWidth + columnMargin,
            keyboardHeight - bottomMargin - keyHeight,
            keyboardWidth - (edgeMargin + nextKeyboardButtonWidth + columnMargin + columnMargin + returnButtonWidth + edgeMargin),
            keyHeight
        },
        PTHybridKeySite_center,
        .keySection = {
            3,
            1,
            PTHybridKeySite_center
        },
        PTKeyType_SpaceKey
    };
    PTKeyMetric returnKeyMetric = {
        .keyRect = {
            keyboardWidth - edgeMargin - returnButtonWidth,
            keyboardHeight - bottomMargin - keyHeight,
            returnButtonWidth,
            keyHeight
        },
        PTHybridKeySite_right,
        .keySection = {
            3,
            2,
            PTHybridKeySite_right
        },
        PTKeyType_ReturnKey
    };
    NSArray *KeyMetric = @[structToObjc(shiftKeyMetric,PTKeyMetric),
                           structToObjc(deleteKeyMetric,PTKeyMetric),
                           structToObjc(nextKeyMetric,PTKeyMetric),
                           structToObjc(spaceKeyMetric,PTKeyMetric),
                           structToObjc(returnKeyMetric,PTKeyMetric)];
    return KeyMetric;
}


NSArray *getPhoneLinearHybridKeyboardCharKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,CGSize keySize){
    CGFloat keyWidth = ((int)(keySize.width*100))/100;
    CGFloat keyHeight = keySize.height;
    CGFloat rowMargin = LINEAR_EQ(keyboardHeight,
                                  keyboardHeight, 15.0,
                                  kPhoneKeyboardLandscapeHeight, 7.0);
    
    CGFloat columnMargin = LINEAR_EQ(keyboardWidth,
                                     kPhoneKeyboardPortraitWidth, 6.0,
                                     kPhoneKeyboardLandscapeWidth, 7.0);
    
    NSMutableArray *charKeyReacts = [NSMutableArray array];
    
    for (int i = 0; i < hybrid_CharKeysCount; i ++) {
        PTSection charKeySection = getSection(i, PTHybridKeyboardType_Char);
        CGRect charKeyRect;
        float keyEdgeMargin = edgeMargin;
        float keytopMargin = topMargin + (rowMargin + keyHeight)*charKeySection.keyRow;
        if (charKeySection.keyRow == 1 ) {
            keyEdgeMargin = (keyboardWidth - keyWidth*9 - columnMargin*8)/2.0f;
        }else if (charKeySection.keyRow == 2){
            keyEdgeMargin = (keyboardWidth - keyWidth*7 - columnMargin*6)/2.0f;
        }
        charKeyRect.origin.x = keyEdgeMargin + (columnMargin + keyWidth)*charKeySection.keyColumn;
        charKeyRect.origin.y = keytopMargin;
        charKeyRect.size = CGSizeMake(keyWidth, keyHeight);
        PTKeyMetric keysMetrics = {
            charKeyRect,
            charKeySection.site,
            charKeySection,
            PTKeyType_Hybridkey_Chars
        };
        [charKeyReacts addObject:structToObjc(keysMetrics,PTKeyMetric)];
    }
    return [NSArray arrayWithArray:charKeyReacts];
}


NSArray *getPhoneLinearHybridKeyboardNumAndSKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,CGSize keySize){
    CGFloat keyWidth = ((int)(keySize.width*100))/100;
    CGFloat keyHeight = keySize.height;
    CGFloat rowMargin = LINEAR_EQ(keyboardHeight,
                                  keyboardHeight, 15.0,
                                  kPhoneKeyboardLandscapeHeight, 7.0);
    
    CGFloat columnMargin = LINEAR_EQ(keyboardWidth,
                                     kPhoneKeyboardPortraitWidth, 6.0,
                                     kPhoneKeyboardLandscapeWidth, 7.0);
    NSMutableArray *numAndSKeyReacts = [NSMutableArray array];
    
    for (int i = 0; i < hybrid_numAndSKeysCount; i ++) {
        PTSection numAndSKeySection = getSection(i, PTHybridKeyboardType_NumAndS);
        CGRect numAndSKeyRect;
        float keyEdgeMargin = edgeMargin;
        
        float numAndSkeyWidth = keyWidth;
        float keytopMargin = topMargin + (rowMargin + keyHeight)*numAndSKeySection.keyRow;
        if (numAndSKeySection.keyRow == 1){
            keyEdgeMargin = edgeMargin;
        }else if(numAndSKeySection.keyRow == 2){
            keyEdgeMargin = (keyboardWidth - keyWidth*7 - columnMargin*6)/2.0f;
            numAndSkeyWidth = (keyboardWidth - keyEdgeMargin*2 - columnMargin*4)/5.0f;
        }
        numAndSKeyRect.origin.x = keyEdgeMargin + (columnMargin + numAndSkeyWidth)*numAndSKeySection.keyColumn;
        numAndSKeyRect.origin.y = keytopMargin;
        numAndSKeyRect.size = CGSizeMake(numAndSkeyWidth, keyHeight);
        
        PTKeyMetric keysMetrics = {
            numAndSKeyRect,
            numAndSKeySection.site,
            numAndSKeySection,
            PTKeyType_Hybridkey_NumAndS
        };
        [numAndSKeyReacts addObject:structToObjc(keysMetrics,PTKeyMetric)];
    }
    return [NSArray arrayWithArray:numAndSKeyReacts];
}

NSArray *getPhoneLinearSudokuKeyboardKeysMetrics(CGFloat keyboardWidth, CGFloat keyboardHeight,SudokuMargin margin){
    if (margin.rowNum == 0 || margin.columnNum == 0) {
        return nil;
    }
    
    NSMutableArray *numKeyMetrics = [NSMutableArray array];
    float keyWidth = (keyboardWidth - margin.keyColumnMargin*(margin.columnNum - 1) - margin.keyEdgeMargin*2)/margin.columnNum;
    float keyHeight = (keyboardHeight - margin.keyRowMargin*(margin.rowNum - 1) - margin.keyBottomMargin*2)/margin.rowNum;
    
    for (int rowIndex = 0; rowIndex < margin.rowNum; rowIndex ++) {
        CGRect keyRect = CGRectZero;
        keyRect.size = CGSizeMake(keyWidth, keyHeight);
        keyRect.origin.y = margin.keyBottomMargin + (keyHeight + margin.keyRowMargin)*rowIndex;
        for (int columnIndex = 0; columnIndex < margin.columnNum; columnIndex ++) {
            keyRect.origin.x = margin.keyEdgeMargin + (keyWidth + margin.keyColumnMargin)*columnIndex;
            PTKeyMetric keyMetric = {
                keyRect,
                PTHybridKeySite_left,
                .keySection = {
                    rowIndex,
                    columnIndex,
                    PTHybridKeySite_left,
                },
                PTKeyType_Num,
            };
            [numKeyMetrics addObject:structToObjc(keyMetric, PTKeyMetric)];
        }
    }
    
    return [NSArray arrayWithArray:numKeyMetrics];
}




PTSection getSection(int index,PTHybridKeyboardType type){
    int row;
    int column;
    PTHybridKeySite keySite = PTHybridKeySite_center;
    switch (type) {
        case PTHybridKeyboardType_Char:{
            if (index < 10) {
                row = 0;
                column = index;
            }else if (index < 19){
                row = 1;
                column = index - 10;
            }else{
                row = 2;
                column = index - 19;
            }
            if (index == 9 || index == 18 || index == 25) keySite = PTHybridKeySite_right;
        }
            break;
        case PTHybridKeyboardType_NumAndS:{
            if (index < 10) {
                row = 0;
                column = index;
            }else if (index < 20){
                row = 1;
                column = index - 10;
            }else{
                row = 2;
                column = index - 20;
            }
            if (index == 9 || index == 19 || index == 24) keySite = PTHybridKeySite_right;
        }
            break;
        default:
            break;
    }
    if (column == 0) keySite = PTHybridKeySite_left;
    if (row == 2) keySite = PTHybridKeySite_center;
    PTSection keySection = {
        row,
        column,
        keySite
    };
    return keySection;
}

SudokuMargin makeSudokuMargin(float keyEdgeMargin,
                              float keyBottomMargin,
                              float keyRowMargin,
                              float keyColumnMargin,
                              int rowNum,
                              int columnNum){
    SudokuMargin margin = {
        keyEdgeMargin,
        keyBottomMargin,
        keyRowMargin,
        keyColumnMargin,
        rowNum,
        columnNum
    };
    return margin;
}


