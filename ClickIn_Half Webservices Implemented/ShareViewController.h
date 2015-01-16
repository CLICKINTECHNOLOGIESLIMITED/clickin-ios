//
//  ShareViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 28/04/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LableInsets.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TKTintedKeyboardViewController.h"
#import "Mixpanel/Mixpanel.h"

@protocol SharedMessageDelegate

// define protocol functions that can be used in any class using this delegate
-(void)sendMessageData:(NSDictionary *)dictionary;

@end



@interface ShareViewController : TKTintedKeyboardViewController
{
    UIImageView *imgView;
    IBOutlet LableInsets *lblText;
    IBOutlet UIView *ClicksBGView;
    IBOutlet UITextView *txtView;
    IBOutlet UIScrollView *Scroll;
    IBOutlet UIButton *FBButton;
    IBOutlet UIButton *GooglePlusButton;
    IBOutlet UIButton *TwitterButton;
    LabeledActivityIndicatorView *activity;
    IBOutlet UILabel *HeaderLbl;
    UIImageView *ClicksImage;
    
    UILabel *cardHeading;
}
@property(nonatomic,retain) IBOutlet UIView *ShareButtonsView;
@property(nonatomic,retain) IBOutlet UIView *lightGrayBGView;
@property(nonatomic,retain)QBChatMessage *message;
@property(nonatomic,retain)NSData *ImageData;
@property(nonatomic,retain)NSData *VideoData;
@property(nonatomic,retain)NSData *AudioData;

// define delegate property
@property (nonatomic, assign) id  delegate;


-(IBAction)FBButtonAction:(id)sender;

-(IBAction)GooglePlusButtonAction:(id)sender;

-(IBAction)TwitterButtonAction:(id)sender;

-(IBAction)ShareButtonAction:(id)sender;

@end
