//
//  LeftViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "CenterViewController.h"
#import "SendInvite.h"
#import "ModelManager.h"

@interface following_owner : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,MODropAlertViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    UITableView *table;
    NSMutableArray *followingArray;
    UILabel *notification_text;
    
    UIButton *notificationsBtn;
    
    int selected_row;
    int btn_state;  // 1 for requested and 2 for following
    
    NSTimer *timer;
    
    UserInfo *otherUser;
    LabeledActivityIndicatorView *activity;
    UILabel *headertext;

}

@property(strong,nonatomic)NSString *is_Owner;
@property(strong,nonatomic)NSString *otheruser_phone_no;
@property(strong,nonatomic)NSString *name;

@end
