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
#import "SBJSON.h"
#import "profile_otheruser.h"
#import "follower_owner.h"
#import "following_owner.h"
#import "ModelManager.h"
#import "EditProfileViewController.h"
#import "Mixpanel.h"

@interface profile_owner : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,MODropAlertViewDelegate,imageUpdated>
{
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    //

    UILabel *Name;
    UILabel *userinfo1;
    UILabel *lblCityAndCountry;
    UILabel *followers_count_text,*following_count_text;
    UIImageView *owner_profilepic;
    UITableView *table;
    NSMutableArray *relationArray;
    NSMutableArray *nonAcceptedUsersArray;
    
    UILabel *notification_text;
    
    UIButton *notificationsBtn;
    
    LabeledActivityIndicatorView *activity;
    int selected_row; //for storing row index
    
    bool profileLoadedFirstTime;
}

@property BOOL isFromNotification;

-(void)imageUpdated:(NSData*)imageData;
@end
