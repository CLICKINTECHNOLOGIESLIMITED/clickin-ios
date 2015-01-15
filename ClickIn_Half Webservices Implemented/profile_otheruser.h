//
//  profile_owner.h
//  ClickIn
//
//  Created by Leo Macbook on 21/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "follower_owner.h"
#import "following_owner.h"
#import "SBJSON.h"
#import "ModelManager.h"
#import "RelationInfo.h"
#import "Mixpanel.h"

@interface profile_otheruser : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,MODropAlertViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //
    
    UILabel *Name;
    UILabel *userinfo1,*userinfo2,*userinfo3; // info of the profile owner
    UILabel *followers_count_text,*following_count_text; // followers and follwing count
    UIImageView *owner_profilepic; // profile oic
    UITableView *table; // tableview
    NSMutableArray *relationArray;  // relationship data
//    UIButton *followbutton; //follow following button
    
    UILabel *lblCityAndCountry;
    LabeledActivityIndicatorView *activity;
    
    NSDictionary *userinfo; //user info
    
    UILabel *notification_text; // notifications text
    
    UIButton *notificationsBtn;
    
    int clickInStatus; // for storing if user is in clickIn relation with the owner or not
}
//@property(strong,nonatomic)NSString *otheruser_name;
//@property(strong,nonatomic)NSString *otheruser_phone_no;
//@property(strong,nonatomic)NSString *relationship_id;
@property(strong,nonatomic)RelationInfo *relationObject;

@property BOOL isFromSearchByName;
@end
