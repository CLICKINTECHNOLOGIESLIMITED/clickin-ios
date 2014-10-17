//
//  StarredViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 25/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "Newsfeed.h"

@interface StarredViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,MODropAlertViewDelegate>
{
    UITableView *table;
    NSMutableArray *usersArray;
    //UILabel *notification_text;
    //UIButton *notificationsBtn;
    
    LabeledActivityIndicatorView *activity;
    
    int selected_row;
    int btn_state;  // 1 for requested and 2 for following
}
@property (nonatomic, retain) IBOutlet UILabel *LblStars;
- (IBAction)backButtonPressed:(id)sender;

@property (nonatomic, retain) Newsfeed *selectedNewsfeed;

@property(strong,nonatomic)NSString *newsfeedID;
@end
