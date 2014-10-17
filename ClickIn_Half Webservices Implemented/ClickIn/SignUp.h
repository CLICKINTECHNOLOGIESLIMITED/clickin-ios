//
//  SignUp.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTintedKeyboardViewController.h"

@interface SignUp : TKTintedKeyboardViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *scroll;
    UITextField *txt_DisplayName,*txt_PhoneNo,*txt_VerificationCode,*txt_CountryCode;
    
    UIButton *btn_CheckMeOut,*btn_Go;
    UILabel *lbl_Info;
   // BOOL check_btn_VerifyPhoneClk;
    int int_VerifiCode;
    
    LabeledActivityIndicatorView *activity;
    NSString *StrCountryCode;
    UIButton *TopViewTransparentButton; // transparent button for hide the chat keyboard
}

@property(strong)NSString *StrCountryCode;
@end
