//
//  KeyboardViewController.m
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import "KeyboardViewController.h"

@interface KeyboardViewController (){
    PTKeyboard *_pwdKeyboard;
    
    PTKeyboard *_pwdNumKeyboard;
    
    PTSessionManager *_sessionManager;
    
    // 字符键盘的密码数据
    NSData *_encryptPassword_Char;
    
    // 数字键盘的密码数据
    NSData *_encryptPassword_Num;
}
@end

@implementation KeyboardViewController

PT_REGISTER_COMPONENT(PTComponentType_Native, 密码键盘组件示例集合, 密码键盘, KeyboardViewController, KeyboardViewController, , )

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    _pwdKeyboard = [[PTKeyboardiPhone alloc] initWithResponder:YES isShowText:YES isRandomSort:YES length:10 key1:[_sessionManager getEncryptServerRandomKey] key2:[_sessionManager getClientRandomKey] key3:[_sessionManager getSessionKey]];
    _pwdKeyboard.keyDelegate = self;
    
    _passwordTF.inputView = _pwdKeyboard;
    
    _pwdNumKeyboard = [[PTKeyboardPasswordNumerPhone alloc] initWithResponder:YES isShowText:YES isRandomSort:YES length:10 key1:[_sessionManager getEncryptServerRandomKey] key2:[_sessionManager getClientRandomKey] key3:[_sessionManager getSessionKey]];
    _pwdNumKeyboard.keyDelegate = self;
    
    _passwork_NumTF.inputView = _pwdNumKeyboard;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 解决按钮选中在pop这个页面时的按钮显示效果
- (void)viewWillAppear:(BOOL)animated{
    _passwordTF.text = @"";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)returnBeforePage:(id)sender {
    // 执行该页面的回退；
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)closeKeyboard
{
    [_usenameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    [_passwork_NumTF resignFirstResponder];
    
}

#pragma mark - PTKeyboardDelegate 协议

#pragma mark 字符键盘 协议方法

- (void)didKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat{
    
    if ([keyboard class] == [PTKeyboardiPhone class]) {
        
        _passwordTF.text = [NSString stringWithFormat:@"%@%@", _passwordTF.text, @"*"];
        if (_encryptPassword_Char != nil) {
            _encryptPassword_Char = nil;
        }
        if (encryptData != nil && [encryptData length] != 0) {
            _encryptPassword_Char = [NSData dataWithData:encryptData];
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"字符键盘 添加密码后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"字符键盘 添加密码后  --  密码明文 = %@",plainText);
    }
    else{
        _passwork_NumTF.text = [NSString stringWithFormat:@"%@%@", _passwork_NumTF.text, @"*"];
        if (_encryptPassword_Num != nil) {
            _encryptPassword_Num = nil;
        }
        
        if (encryptData != nil && [encryptData length] != 0) {
            _encryptPassword_Num = [NSData dataWithData:encryptData];
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"数字键盘 添加密码后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"数字键盘 添加密码后  --  密码明文 = %@",plainText);
    }
}

- (void)didBackspaceKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat{
    
    if ([keyboard class] == [PTKeyboardiPhone class]) {
        
        NSInteger length = _passwordTF.text.length;
        if (length == 0) {
            _passwordTF.text = @"";
            return;
        }
        
        NSString *substring = [_passwordTF.text substringWithRange:NSMakeRange(0, length - 1)];
        _passwordTF.text = substring;
        
        if (_encryptPassword_Char != nil) {
            _encryptPassword_Char = nil;
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"密码键盘 删除密码后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"密码键盘 删除密码后  --  密码明文 = %@",plainText);
    }
    else{
        
        NSInteger length = _passwork_NumTF.text.length;
        if (length == 0) {
            _passwork_NumTF.text = @"";
            return;
        }
        
        NSString *substring = [_passwork_NumTF.text substringWithRange:NSMakeRange(0, length - 1)];
        _passwork_NumTF.text = substring;
        
        if (_encryptPassword_Num != nil) {
            _encryptPassword_Num = nil;
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"数字键盘 删除密码后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"数字键盘 删除密码后  --  密码明文 = %@",plainText);
    }
}

-(void)didDoneKeyPressed:(PTKeyboard *)keyboard encryptData:(NSMutableData *)encryptData plainText:(NSString *)plainText keyStat:(NSDictionary *)keyStat{
    if ([keyboard class] == [PTKeyboardiPhone class]) {
        if (encryptData != nil && [encryptData length] != 0) {
            _encryptPassword_Char = [NSData dataWithData:encryptData];
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"密码键盘 密码输入完成后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"密码键盘 密码输入完成后  --  密码明文 = %@",plainText);
    }
    else{
        if (encryptData != nil && [encryptData length] != 0) {
            _encryptPassword_Num = [NSData dataWithData:encryptData];
        }
        
        int pwdIntCount = (int)[[keyStat objectForKey:@"num"] integerValue];
        int pwdCharCount = (int)[[keyStat objectForKey:@"char"] integerValue];
        
        PTLogDebug(@"数字键盘 密码输入完成后  --  密码包含字符个数:%d 数字个数:%d", pwdIntCount, pwdCharCount);
        PTLogDebug(@"数字键盘 密码输入完成后  --  密码明文 = %@",plainText);
    }

    [self closeKeyboard];
}

@end
