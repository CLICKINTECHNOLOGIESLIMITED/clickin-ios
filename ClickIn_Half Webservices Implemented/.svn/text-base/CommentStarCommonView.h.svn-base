//
//  CommentStarCommonView.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 07/07/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "HPGrowingTextView.h"
#import "Newsfeed.h"

@interface CommentStarCommonView : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,HPGrowingTextViewDelegate>
{
    UITableView *table;
    NSMutableArray *usersArray; // contains the required user info for the comment
    UILabel *notification_text;
    UIButton *notificationsBtn;
    LabeledActivityIndicatorView *activity;
    float padding;
    UIView *containerView;
    HPGrowingTextView *textView;
    UIView *InnerView;
    
    float comments_offsetY;
}

@property (nonatomic, retain) IBOutlet UILabel *LblComments;

- (IBAction)backButtonPressed:(id)sender;

@property (nonatomic, retain) Newsfeed *selectedNewsfeed;
@property(strong,nonatomic)NSString *newsfeedID;

@property(strong,nonatomic)NSString *isViewPushed;

@property (nonatomic,retain) NSString *isNotificationSelected;

@end
