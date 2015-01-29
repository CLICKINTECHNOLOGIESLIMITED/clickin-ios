//
//  VerifyPhoneNumberViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 20/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTintedKeyboardViewController.h"
#import "Mixpanel.h"

@interface VerifyPhoneNumberViewController : TKTintedKeyboardViewController<UITextFieldDelegate,MODropAlertViewDelegate>
{
    UITextField* text_Field;
    LabeledActivityIndicatorView *activity;
    NSString  *VCodeString;
    UIButton *HitMebutton ;
}

@end
