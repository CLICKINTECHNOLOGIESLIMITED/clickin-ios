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
#import "TKTintedKeyboardViewController.h"
#import "Mixpanel.h"


@interface LeftViewController : TKTintedKeyboardViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,leftchatReceiveProtocol>
{
    UITableView *table;
    //NSMutableArray *relationArray;
    
    // models references
    ModelManager *modelmanager;
    ProfileManager *profilemanager;
    UITableView *StrTable;
    
    NSTimer *timerCallService;
    UITextField * SearchtxtView;
    
    NSMutableArray *arrUsers;

    UIActivityIndicatorView *activityIndicator;
    int SelectedRow;
    UIButton *crossButton;
    UIButton *backButton;
    UIImageView *SearchBGimgView;
}
@property(strong,nonatomic) NSString *PartnerQBId;
@property(strong,nonatomic) NSMutableArray *relationArray;
@property(strong,nonatomic) NSString *ownersClick;
@end
