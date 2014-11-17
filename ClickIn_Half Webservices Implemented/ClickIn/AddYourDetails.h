//
//  AddYourDetails.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 16/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ASIHTTPRequest.h"
#import <AssetsLibrary/AssetsLibrary.h>
//#import "XWPhotoEditorViewController.h"
//#import "AGSimpleImageEditorView.h"
#import "TKTintedKeyboardViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AddYourDetails : TKTintedKeyboardViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,FBLoginViewDelegate,FBViewControllerDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,MODropAlertViewDelegate>
{
    UIScrollView *scroll;
    UIButton *btn_PicFromGallery,*btn_PicFromCamera,*btn_Girl,*btn_Guy,*btn_Facebook,*btn_Back,*btn_Next;
        NSString *str_Gender;
    UIActionSheet *menuActionSheet;
    UIToolbar *ObjToolBar;
    UISegmentedControl *btn_SegmentedControl;
    UIDatePicker *DatePicker;
    UILabel  *datePickerlabel;
    UIImage *tempProfilePic;
    
    UIButton *Gallerybutton ,*EditCamerabutton ;
    
    NSString *str_FBBirthday,*str_FBEmail,*str_FB;
    NSArray *arrMonth;
    UIButton *DOBbutton;
    NSString *pickerSelectedDate;
    NSString *StrEncoded;

    LabeledActivityIndicatorView *activity;
    BOOL isFBDataFetched;
    //AGSimpleImageEditorView *simpleImageEditorView;
    UITextField *FirstNameTxtField;
    UITextField *LastNameTxtField;
    UITextField *CityNameTxtField;
    UITextField *CountryNameTxtField;
    UITextField *EmailTxtField;
    
}

@property (strong, nonatomic) FBProfilePictureView *profilePictureView;





@end
