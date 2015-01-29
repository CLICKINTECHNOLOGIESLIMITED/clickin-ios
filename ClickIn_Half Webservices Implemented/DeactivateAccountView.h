//
//  DeactivateAccountView.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 02/07/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelManager.h"
#import "TKTintedKeyboardViewController.h"
#import "Mixpanel/Mixpanel.h"

@interface DeactivateAccountView : TKTintedKeyboardViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate,QBActionStatusDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    NSString *selectedOption;
    int selectedIndex;
    bool isEmailOpted;
    
    NSString *feedbackText;
    
    NSString *passwordString;
    
    UITableView *tblView;
    UILabel *notification_text;
    UIButton *notificationsBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *LblSettings;
@property (nonatomic, retain) IBOutlet UIImageView *topBarImageView;
- (IBAction)leftSideMenuButtonPressed:(id)sender;


@end
