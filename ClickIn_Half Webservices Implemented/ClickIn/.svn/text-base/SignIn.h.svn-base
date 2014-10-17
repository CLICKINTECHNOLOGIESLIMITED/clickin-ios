//
//  SignIn.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUp.h"
#import "MFSideMenu.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import "AppDelegate.h"
#import "TKTintedKeyboardViewController.h"
#import "ModelManager.h"

@interface SignIn : TKTintedKeyboardViewController<UIScrollViewDelegate,UITextFieldDelegate,QBActionStatusDelegate,UIAlertViewDelegate,MODropAlertViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ChatManager *chatmanager;
    //
    
    UIScrollView *scroll;
    UITextField *txt_Password,*txt_Phone_mail;
    UIButton *btn_ClickIn,*btn_ForgotPass,*btn_SignUp;
    UILabel *lbl_Welcome;
    SignUp *signup;
    LabeledActivityIndicatorView *activity;
    UIButton *TopViewTransparentButton; // transparent button for hide the chat keyboard
}

@end
