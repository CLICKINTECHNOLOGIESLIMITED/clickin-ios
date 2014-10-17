//
//  SendInvite.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 17/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "TKTintedKeyboardViewController.h"


@interface SendInvite : TKTintedKeyboardViewController<UIScrollViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
    
    UIScrollView *scroll;
    UIImageView *img_ProfilePic;
    UILabel *lbl_Name,*lbl_Email,*lbl_DOB;
//  UIButton *btn_Edit,*btn_SendInvite,*btn_Back,*btn_Done,*btn_Skip;
    UIButton *GetClickin;
    UITextField * txt_PhoneNo,*txt_CountryCode;
    UIImage *ProfileImg;
    LabeledActivityIndicatorView *activity;
    NSString *StrCountryCode;
    NSMutableDictionary *dict;
    
}
@property(strong)NSDictionary *dict;
@property(strong)NSString *StrCountryCode;
@property(nonatomic,retain) UIImage *ProfileImg;
@property (nonatomic, retain) NSString *isFromMenu;
@end
