//
//  SettingsViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 17/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTintedKeyboardViewController.h"
#import "ModelManager.h"

@interface SettingsViewController : TKTintedKeyboardViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,QBActionStatusDelegate,UIAlertViewDelegate,MODropAlertViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    UITableView *tblView;
    UILabel *notification_text;
    UIButton *notificationsBtn;
    
    NSMutableArray *isSectionOpen;
    NSMutableArray *isRowOpen;
    bool isFeedbackOpen;
    
    LabeledActivityIndicatorView *activity;
    
    NSString *oldPassword;
    NSString *newPassword;
    NSString *confirmPassword;
    
    NSString *notWorkingText;
    NSString *feedbackText;
}

@property (nonatomic, retain) IBOutlet UILabel *LblSettings;
@property (nonatomic, retain) IBOutlet UIImageView *topBarImageView;
- (IBAction)leftSideMenuButtonPressed:(id)sender;

@end
