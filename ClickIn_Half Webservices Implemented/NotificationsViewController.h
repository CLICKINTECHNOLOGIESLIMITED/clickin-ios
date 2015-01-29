//
//  NotificationsViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 10/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mixpanel/Mixpanel.h"

@interface NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    LabeledActivityIndicatorView *activity;
    UITableView *table;
    
    BOOL isChatHistoryOrNot;
    BOOL isFromEariler;
    
    int unreadCount;
    
    NSTimer *timer;
    
    NSMutableArray *notification_ID;
    NSMutableArray *notificationType;
    NSMutableArray *notificationMsgs;
    NSMutableArray *newsfeed_ID;
    BOOL isLoading,isDragging;
    BOOL isFetchingEarlier; // to fetch earlier notifications
    BOOL isHistoryAvailable ; // to check whether earlier notifications available or not
    
    NSTimer *loadingtimer;
}
@property (retain, nonatomic) IBOutlet UILabel *topBarLabel;
@property (nonatomic, retain) NSMutableArray *messages;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, copy) NSString *textLoad;
@property (nonatomic, retain) UIImageView *LoadingImageView;


- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

- (IBAction)leftSideMenuButtonPressed:(id)sender;
@end
