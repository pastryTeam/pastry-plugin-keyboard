//
//  KeyboardViewController.h
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import <UIKit/UIKit.h>
#import "PTKeyboardDelegate.h"

#ifdef IONIC_PLATFORM
@interface KeyboardViewController : UIViewController<PTKeyboardDelegate>
#else
@interface KeyboardViewController : PTViewControllerBase<PTKeyboardDelegate, PTComponentInterface>
#endif

- (IBAction)returnBeforePage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *usenameTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UITextField *passwork_NumTF;

@end
