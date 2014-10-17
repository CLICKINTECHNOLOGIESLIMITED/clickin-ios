//
//  EditProfileViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 02/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelManager.h"
#import "TKTintedKeyboardViewController.h"

@interface EditProfileViewController : TKTintedKeyboardViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    UIScrollView *scroll;
    UIImageView *editPhotoView;
    UIImageView * profileImageView;
    
    UIButton *btn_PicFromGallery,*btn_PicFromCamera;
    
    UITextField *NameTxtField,*LastNameTxtField;
    UITextField *CityNameTxtField;
    UITextField *CountryNameTxtField;
    UITextField *EmailTxtField;
    
    UIImage *tempProfilePic;
    NSString *StrEncoded;
    
    UIButton *saveButton;
    
    UILabel *notification_text;
    UIButton *notificationsBtn;
    
    LabeledActivityIndicatorView *activity;
}

@property (nonatomic, retain) IBOutlet UILabel *LblEditProfile;
@property (nonatomic, retain) IBOutlet UIImageView *topBarImageView;

@property (strong, nonatomic) UIImagePickerController *imgPicker;

- (IBAction)leftSideMenuButtonPressed:(id)sender;
@end
