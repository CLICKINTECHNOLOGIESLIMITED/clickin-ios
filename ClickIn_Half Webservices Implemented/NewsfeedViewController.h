//
//  NewsfeedViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 27/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ModelManager.h"
#import "Mixpanel/Mixpanel.h"

@interface NewsfeedViewController : UIViewController
{
    // models references
    ModelManager *modelmanager;
    NewsfeedManager *newsfeedmanager;
    ProfileManager *profilemanager;
    //

    
    LabeledActivityIndicatorView *activity;
    IBOutlet UITableView *tblView;
    
    BOOL isChatHistoryOrNot;
    BOOL isFromEariler;
    
    NSTimer *timer;
    
    UILabel *notification_text;
    UIButton *notificationsBtn;
    
    BOOL isLoading,isDragging;
    
    float comments_offsetY;
    
    NSThread *timerThread;
    
    NSTimer *loadingtimer;
}

@property (nonatomic, retain) IBOutlet UILabel *LblNewsfeed;
@property (nonatomic, retain) IBOutlet UIImageView *topBarImageView;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, retain) UIImageView *LoadingImageView;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, copy) NSString *textLoad;

@property (nonatomic, retain) NSString *firstTimeLoad;

@property (nonatomic, retain) NSString *isFromSharingView;

@property (nonatomic, retain) NSString *scrollToNewsfeedID;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

- (IBAction)leftSideMenuButtonPressed:(id)sender;
@end
