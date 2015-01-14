//
//  RegisterYourEmail.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 15/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTintedKeyboardViewController.h"
#import "Mixpanel.h"

@interface RegisterYourEmail : TKTintedKeyboardViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *scroll;
    UITextField *txt_email,*txt_Password,*txt_RePass;
    UIButton *btn_Back,*btn_Done,*btn_Skip;
    UIButton *btn_TryAnother,*btn_ForgotPassword;   
    UILabel *lbl_Info,*lbl_DisplayName;

    LabeledActivityIndicatorView *activity;
}
@end
