//
//  SpamAbuseViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 30/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelManager.h"
#import "TKTintedKeyboardViewController.h"

@interface SpamAbuseViewController : TKTintedKeyboardViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    NSString *selectedOption;
    int selectedIndex;
    
    NSString *feedbackText;
    
    UITableView *tblView;
    UILabel *notification_text;
    UIButton *notificationsBtn;
}

@property (nonatomic, retain) IBOutlet UILabel *LblSettings;
@property (nonatomic, retain) IBOutlet UIImageView *topBarImageView;
- (IBAction)leftSideMenuButtonPressed:(id)sender;

@end
