

//
//  CenterViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "CenterViewController.h"
#import "ChatMessageTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "PhotoViewController.h"
#import "TradePostCards.h"
#import "PlayCardView.h"
#include <CommonCrypto/CommonHMAC.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MapWebView.h"
#import "NotificationsViewController.h"
#import "profile_otheruser.h"
#import "CSAnimationView.h"
#import <CoreText/CoreText.h>
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "LeftViewController.h"

#define CC_SHA1_DIGEST_LENGTH 20

#define MediaAlertTag 4001

@interface CenterViewController ()

@end

@implementation CenterViewController
@synthesize messages,sendMessageField,sendMessageButton,tableView,ChatBgImgView,ChatBgWhiteView,SliderBar,leftTopHeaderClicks,rightTopHeaderClicks,mediaAttachButton,strChatIdOfFirstRecord,strRelationShipId,MyTotalClicks,FriendTotalClicks,PartnerNameLbl,ContentButton,LeftSmallClickImageView,int_leftmenuIndex;
@synthesize partner_name,partner_pic,partner_QB_id,BtnPartnerImg,BtnUserImg,PartnerPhoneNumber;
@synthesize relationObject,lblTyping;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    //call reset unread messages
//    QBChatMessage *lastChatMessage = (QBChatMessage *)[messages lastObject];
//    [self resetUnreadMessageCount:lastChatMessage.ID relationship_ID:self.strRelationShipId];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(SharedMessageNotificationReceived:)
//     name:NotificationDidReceiveSharedMessage
//     object:nil];
    
//    QBCOCustomObject *object = [QBCOCustomObject customObject];
//     [QBCustomObjects createObject:object delegate:Nil];
}

- (void)dealloc
{
     tableView.delegate = nil;
     textView.delegate = nil;
     textView.delegateNotification=nil;
    
    
        //remove  chat delegate
     chatmanager.CenterMessageReceiveDelegate=Nil;
    chatmanager.CenterCustomObjDelegate=Nil;
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RightMenuToggled object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ChatHistoryFetched object:nil];
   //  [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDidReceiveNewMessage object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ProfileInfoUpdated object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_InAppSoundsFlag object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ChatLoginStatusChanged object:nil];
    // cancel all upload operations
  
    for (NSObject<Cancelable> *obj in uploadingObjects )
    {
        [obj cancel];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     uploadingObjects = [[NSMutableArray alloc] init];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"R-Page"
                                                                                                                       action:@"Open R-page"
                                                                                                                        label:@"Open R-Page"
                                                                                                                        value:nil] build]];
    
    is_loadeariler = false;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.strRelationShipId forKey:@"relationShipId"];

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(chatHistoryFetched:)
     name:Notification_ChatHistoryFetched
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(chatLoginStatusChanged:)
     name:Notification_ChatLoginStatusChanged
     object:nil];
    
//    // Set chat notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
//        name:NotificationDidReceiveNewMessage object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(SetVolumeNotificationReceived3:)
     name:Notification_InAppSoundsFlag
     object:nil];
    
//    if (IS_IPHONE_5)
//    {
//        BgImageView.image = [UIImage imageNamed:@"bgR_Page.png"];
//    }
//    else
//    {
//        BgImageView.image = [UIImage imageNamed:@"640x960-2.png"];
//    }
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(SharedMessageNotificationReceived:)
//     name:NotificationDidReceiveSharedMessage
//     object:nil];
    
    // Models
    modelmanager=[ModelManager modelManager];
    chatmanager=modelmanager.chatManager;
    profilemanager=modelmanager.profileManager;
    
    [self performSelector:@selector(setChatDelegate) withObject:Nil afterDelay:0.5];
    
    
    
//  [sendMessageField setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"footer_centerbox.png"]]];
    
    PartnerNameLbl.frame = CGRectMake(106,8,108,29);
    
    lblTyping.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12.0];
    lblTyping.text = @"";
    rightTopHeaderClicks.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
    leftTopHeaderClicks.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
    card_countered_indexes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:-1],@"cardArrayIndex",[NSNumber numberWithInt:-1],@"selectedIndex", nil];
    
    ContentButton.hidden = NO;
    sendMessageButton.hidden = YES;
    CheckIfAttachBtnContainMedia = false;
    
    addMyClicks = [FriendTotalClicks intValue];
    addMyFriendClicks = [MyTotalClicks intValue];
    
    rightTopHeaderClicks.text = MyTotalClicks;
    leftTopHeaderClicks.text = FriendTotalClicks;
    
    switch ([rightTopHeaderClicks.text length])
    {
        case 1:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(69-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(69-15, 60,14, 15);
            }
            
            rightTopHeaderClicks.frame = CGRectMake(48, 51,16, 32);
            break;
            
        case 2:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(79-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(79-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,25, 32);
            break;
            
        case 3:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(89-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(89-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,38, 32);
            break;
            
        case 4:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(99-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(99-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,44, 32);
            break;
            
        default:
            break;
    }

    
    PartnerNameLbl.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
    NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
    if([substrings count] != 0)
    {
        NSString *first = [substrings objectAtIndex:0];
        PartnerNameLbl.text = [first uppercaseString];
    }
    
//  PartnerNameLbl.text=[partner_name uppercaseString];
    
    rightTopHeaderClicks.textColor = [UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0];
    leftTopHeaderClicks.textColor = [UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0];
    
    //[NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    
   // self.transitionController =[[TransitionDelegate alloc] init];
    
    headerOptionsScrolled = false;
    
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_heading"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_content"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_clicks"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_owner"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_originator"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"is_CustomCard"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_DB_ID"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSData alloc] init]  forKey:@"locationimagedata"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"locationCoordinates"];

    //NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]                                               pathForResource:@"clickSound" ofType:@"wav"]];
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Clicker_Slider"
                                               ofType:@"mp3"]];
    click = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [click prepareToPlay];
    
    attachmentSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"Menu_Attachments"                                                                                           ofType:@"mp3"]] error:nil];
    [attachmentSound prepareToPlay];
    
    ClicksChangedSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"Clicker_ScoresChange"                                                                                           ofType:@"mp3"]] error:nil];
    [ClicksChangedSound prepareToPlay];
    
    outgoingMsgSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"Message_Sent"                                                                                           ofType:@"mp3"]] error:nil];
    outgoingMsgSound.volume = 1;
    [outgoingMsgSound prepareToPlay];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
    {
        click.volume = 0;
        attachmentSound.volume = 0;
        ClicksChangedSound.volume = 0;
        outgoingMsgSound.volume = 0;
        outgoingMsgSound.volume = 0;
    }
    else
    {
        click.volume = 2;
        attachmentSound.volume = 2;
        ClicksChangedSound.volume = 2;
        outgoingMsgSound.volume = 2;
        
    }

    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    card_accept_status = [[NSMutableArray alloc] init];
    card_status_webHistory = [[NSMutableArray alloc] init];
    
 //   if([NSNull null] != [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"] != nil)
//    [self.UserImgView setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]];
    
    [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];

    if(![partner_pic isEqual: [NSNull null]])
    [self.PartnerImgView sd_setImageWithURL:[NSURL URLWithString:partner_pic] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
   
    UIView *OverLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 86, 320, 399)];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            OverLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 86, 320, 495-7)];
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            OverLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 86, 320, 495-7)];
        }
        else
        {
            OverLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 86, 320, 399)];
        }
    }
    
//  [OverLayView setBackgroundColor:[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0]];
    //[OverLayView setBackgroundColor:[UIColor blackColor]];
   // OverLayView.blurRadius=10.0f;
    OverLayView.alpha = 0;
    OverLayView.tag = 111111;
   
    
    UILabel *lblClicks;
    UIImageView *imgView;
    
    lblClicks = [[UILabel alloc] initWithFrame:CGRectMake(-35, 120-40,300,150)];
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 155-40, 75,81)];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            lblClicks = [[UILabel alloc] initWithFrame:CGRectMake(-35, 168-45,300,150)];
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 205-45, 75, 81)];
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            lblClicks = [[UILabel alloc] initWithFrame:CGRectMake(-35, 168-40,300,150)];
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 205-40, 75, 81)];
        }
        else
        {
            lblClicks = [[UILabel alloc] initWithFrame:CGRectMake(-35, 120-40,300,150)];
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 155-40, 75, 81)];
        }
    }

    lblClicks.tag = 12;
    lblClicks.font = [UIFont fontWithName:@"Helvetica Bold" size:103];
    lblClicks.backgroundColor = [UIColor clearColor];
    lblClicks.textAlignment = NSTextAlignmentCenter;
    lblClicks.textColor=[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0];//220,149,144
    lblClicks.numberOfLines=0;
    lblClicks.lineBreakMode=NSLineBreakByCharWrapping;
    lblClicks.text = @"00";
    [OverLayView addSubview:lblClicks];
    
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0, lblClicks.frame.origin.y+15, 320, 106);
    lblClicks.hidden = YES;
    
    //imgView.image = [UIImage imageNamed:@"heart.png"];
    imgView.tag = 13;
    [OverLayView addSubview:imgView];
    
    UIButton *overlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayBtn.tag=14;
    [overlayBtn addTarget:self action:@selector(overlayBtnAction:)forControlEvents:UIControlEventTouchUpInside];
    overlayBtn.backgroundColor=[UIColor clearColor];
    overlayBtn.frame = OverLayView.frame;
    [OverLayView addSubview:overlayBtn];
    
    [self.view addSubview:OverLayView];
    OverLayView.hidden = NO;
    OverLayView = nil;
    
    // Do any additional setup after loading the view from its nib.
    messages = [[NSMutableArray alloc] init];
    //[[QBChat instance] setDelegate:self];
    
    //[self performSelector:@selector(CallrelationshipsWebservice) withObject:self afterDelay:0.1];
    
    mediaAttachButton.tag = 1; //tag 1 for default
    
    //imagesURL=[[NSMutableArray alloc] init];
    imagesData = [[NSMutableArray alloc] init];
    images_indexes = [[NSMutableArray alloc] init];
    imagesUploading_indexes = [[NSMutableArray alloc] init];
    
    //videosData = [[NSMutableArray alloc] init];
    //video_indexes = [[NSMutableArray alloc] init];
    videoUploading_indexes = [[NSMutableArray alloc] init];
    
    audioUploading_indexes = [[NSMutableArray alloc] init];
    audioData = [[NSMutableArray alloc] init];
        
    
    //audio speak now view
    startRecordingView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100 , self.view.frame.size.height/2 - 90 , 200, 180)];
    
  [startRecordingView setBackgroundColor:[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0]];
//    [startRecordingView setBackgroundColor:[UIColor whiteColor]];
    startRecordingView.layer.cornerRadius = 8.0f;
    startRecordingView.layer.borderWidth = 1.0f;
    startRecordingView.layer.borderColor = [[UIColor blackColor] CGColor];
    startRecordingView.alpha = 0;
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(0 , 90, 200, 40)];
    lblText.font = [UIFont fontWithName:@"Helvetica Bold" size:18];
    lblText.backgroundColor = [UIColor clearColor];
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.textColor=[UIColor whiteColor];
    lblText.numberOfLines=0;
    lblText.lineBreakMode=NSLineBreakByCharWrapping;
    lblText.text = @"HOLD TO RECORD";
    [startRecordingView addSubview:lblText];
    
    //UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5 , 100, 100)];
    UIButton *iconView = [UIButton buttonWithType:UIButtonTypeCustom];   // for audio recording selection
    iconView.frame = CGRectMake(50, 0 , 100, 100);
    [iconView addTarget:self action:@selector(AudioButtonDownAction)forControlEvents:UIControlEventTouchDown];
    [iconView addTarget:self action:@selector(AudioButtonUpAction)forControlEvents:UIControlEventTouchUpInside];
    [iconView addTarget:self action:@selector(AudioButtonUpAction)forControlEvents:UIControlEventTouchCancel];
    [iconView setImage:[UIImage imageNamed:@"speak_icon.png"] forState:UIControlStateNormal];
    [startRecordingView addSubview:iconView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];   // for audio recording selection
    cancelButton.frame = CGRectMake(40, 130 , 120, 40);
    [cancelButton addTarget:self action:@selector(hideRecordingView)forControlEvents:UIControlEventTouchDown];
    [cancelButton setBackgroundColor:[UIColor blackColor]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 5.0;
    [startRecordingView addSubview:cancelButton];
    
    
    [self.view addSubview:startRecordingView];
    startRecordingView.hidden = NO;
   
    //----header chat history Scroll View Implementation------
    HeaderChatHistoryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(235, 45, 45, 280)];
    HeaderChatHistoryScrollView.contentSize = CGSizeMake(45, 600);
    HeaderChatHistoryScrollView.showsHorizontalScrollIndicator = NO;
    HeaderChatHistoryScrollView.showsVerticalScrollIndicator = NO;
    HeaderChatHistoryScrollView.scrollsToTop = NO;
    HeaderChatHistoryScrollView.delegate = self;
    HeaderChatHistoryScrollView.alpha=0;
    HeaderChatHistoryScrollView.tag = 774477;
    
    
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            HeaderChatHistoryScrollView.frame=CGRectMake(238, 45, 45, 280);
        }
        else
        {
            HeaderChatHistoryScrollView.frame=CGRectMake(238, 45, 45, 280);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            HeaderChatHistoryScrollView.frame=CGRectMake(238, 45, 45, 280);
        }
        else
        {
            HeaderChatHistoryScrollView.frame=CGRectMake(238, 45, 45, 280);
        }
    }
    
    [self.view addSubview:HeaderChatHistoryScrollView];
    [self.view bringSubviewToFront:HeaderChatHistoryScrollView];
    
    //---------Header Chat history view buttons---------
    UIButton *headerChatHistoryIcon1 = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryIcon1.tag=1;
    [headerChatHistoryIcon1 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryIcon1 setBackgroundImage:[UIImage imageNamed:@"icon11.png"] forState:UIControlStateNormal];
    headerChatHistoryIcon1.frame = CGRectMake(0, 10, 45 ,45);
//  [HeaderChatHistoryScrollView addSubview:headerChatHistoryIcon1];
    
    UIButton *headerChatHistoryIcon2 = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryIcon2.tag=66;
    [headerChatHistoryIcon2 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryIcon2 setBackgroundImage:[UIImage imageNamed:@"icon22.png"] forState:UIControlStateNormal];
    headerChatHistoryIcon2.frame = CGRectMake(0, 10, 45 ,45);
    [HeaderChatHistoryScrollView addSubview:headerChatHistoryIcon2];
    
    UIButton *headerChatHistoryIcon3 = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryIcon3.tag=77;
    [headerChatHistoryIcon3 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryIcon3 setBackgroundImage:[UIImage imageNamed:@"icon33.png"] forState:UIControlStateNormal];
    headerChatHistoryIcon3.frame = CGRectMake(0, 65, 45 ,45);
    [HeaderChatHistoryScrollView addSubview:headerChatHistoryIcon3];
    
    UIButton *headerChatHistoryIcon4 = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryIcon4.tag=88;
    [headerChatHistoryIcon4 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryIcon4 setBackgroundImage:[UIImage imageNamed:@"icon44.png"] forState:UIControlStateNormal];
    headerChatHistoryIcon4.frame = CGRectMake(0, 120, 45 ,45);
    [HeaderChatHistoryScrollView addSubview:headerChatHistoryIcon4];
    
    UIButton *headerChatHistoryIcon5 = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryIcon5.tag=99;
    [headerChatHistoryIcon5 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryIcon5 setBackgroundImage:[UIImage imageNamed:@"Icon55.png"] forState:UIControlStateNormal];
    headerChatHistoryIcon5.frame = CGRectMake(0, 175, 45 ,45);
    [HeaderChatHistoryScrollView addSubview:headerChatHistoryIcon5];
    
    UIButton *headerChatHistoryBlank = [UIButton buttonWithType:UIButtonTypeCustom];
    headerChatHistoryBlank.tag=10;
    [headerChatHistoryBlank addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [headerChatHistoryBlank setBackgroundImage:nil forState:UIControlStateNormal];
    headerChatHistoryBlank.frame = CGRectMake(0, 230, 45 ,45);
    [HeaderChatHistoryScrollView addSubview:headerChatHistoryBlank];
    
    //-----sharing scroll view-----
    shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 485, 290, 50)];
    shareScrollView.contentSize = CGSizeMake(290, 50);
    shareScrollView.showsHorizontalScrollIndicator = NO;
    shareScrollView.showsVerticalScrollIndicator = NO;
    shareScrollView.scrollsToTop = NO;
    shareScrollView.delegate = self;
    shareScrollView.alpha=0;
    [self.view addSubview:shareScrollView];
    
    UIButton *iconShareBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];   // for googleplus
    iconShareBtn1.tag=111111;
    [iconShareBtn1 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconShareBtn1 setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
    iconShareBtn1.frame = CGRectMake(0, 0, 45 ,45);
    [shareScrollView addSubview:iconShareBtn1];
    
    UIButton *iconShareBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];   // for twitter
    iconShareBtn2.tag=222222;
    [iconShareBtn2 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconShareBtn2 setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
    iconShareBtn2.frame = CGRectMake(50, 0, 45 ,45);
    [shareScrollView addSubview:iconShareBtn2];
    
    UIButton *iconShareBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];   // for facebook
    iconShareBtn3.tag=333333;
    [iconShareBtn3 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconShareBtn3 setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
    iconShareBtn3.frame = CGRectMake(100, 0, 45 ,45);
    [shareScrollView addSubview:iconShareBtn3];
    
    UIButton *iconShareBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];   // for inapp clickin
    iconShareBtn4.tag=444444;
    [iconShareBtn4 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconShareBtn4 setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
    iconShareBtn4.frame = CGRectMake(150, 0, 45 ,45);
    [shareScrollView addSubview:iconShareBtn4];
    
    UIButton *iconShareBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];   // for sharing
    iconShareBtn5.tag=555555;
    [iconShareBtn5 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconShareBtn5 setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
    iconShareBtn5.frame = CGRectMake(200, 0, 88 ,45);
    [shareScrollView addSubview:iconShareBtn5];
    
    
    
    //----media Scroll View Implementation------
    mediaScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 485, 160, 50)];
    mediaScrollview.contentSize = CGSizeMake(160, 50);
    mediaScrollview.showsHorizontalScrollIndicator = NO;
    mediaScrollview.showsVerticalScrollIndicator = NO;
    mediaScrollview.scrollsToTop = NO;
    mediaAttachButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    mediaScrollview.delegate = self;
    mediaScrollview.alpha=0;
    
    //----Scroll View Implementation------
    CardsScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(215, 425, self.view.frame.size.width, 50)];
    CardsScrollview.contentSize = CGSizeMake(320, 50);
    CardsScrollview.showsHorizontalScrollIndicator = NO;
    CardsScrollview.showsVerticalScrollIndicator = NO;
    CardsScrollview.scrollsToTop = NO;
    CardsScrollview.delegate = self;
    CardsScrollview.alpha=0;
    
    
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            CardsScrollview.frame=CGRectMake(170, 425, self.view.frame.size.width, 50);
            mediaScrollview.frame=CGRectMake(12, 485, 220, 50);
        }
        else
        {
            CardsScrollview.frame=CGRectMake(170, 335, self.view.frame.size.width, 50);
            mediaScrollview.frame=CGRectMake(12, 395, 220, 50);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            CardsScrollview.frame=CGRectMake(170, 425, self.view.frame.size.width, 50);
            mediaScrollview.frame=CGRectMake(12, 485, 220, 50);
        }
        else
        {
            CardsScrollview.frame=CGRectMake(170, 335, self.view.frame.size.width, 50);
            mediaScrollview.frame=CGRectMake(12, 395, 220, 50);
        }
    }
    
    [self.view addSubview:CardsScrollview];
    //[self.view addSubview:mediaScrollview];
    //[self.view bringSubviewToFront:mediaScrollview];
    
    //---------media view buttons---------
    UIButton *icon1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    icon1Btn.tag=1;
    [icon1Btn addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [icon1Btn setBackgroundImage:[UIImage imageNamed:@"icons1.png"] forState:UIControlStateNormal];
    icon1Btn.frame = CGRectMake(0, 0, 45 ,45);
    [CardsScrollview addSubview:icon1Btn];
    
    UIButton *icon2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    icon2Btn.tag=2;
    [icon2Btn addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [icon2Btn setBackgroundImage:[UIImage imageNamed:@"icons2.png"] forState:UIControlStateNormal];
    icon2Btn.frame = CGRectMake(45, 0, 45 ,45);
    [CardsScrollview addSubview:icon2Btn];
    
    UIButton *icon3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    icon3Btn.tag=3;
    [icon3Btn addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [icon3Btn setBackgroundImage:[UIImage imageNamed:@"icons3.png"] forState:UIControlStateNormal];
    icon3Btn.frame = CGRectMake(90, 0, 45 ,45);
    [CardsScrollview addSubview:icon3Btn];
    
    UIButton *iconMediaBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];   // for images selection
    iconMediaBtn1.tag=4;
    [iconMediaBtn1 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconMediaBtn1 setBackgroundImage:[UIImage imageNamed:@"gallery.png"] forState:UIControlStateNormal];
    iconMediaBtn1.frame = CGRectMake(0, 0, 45 ,45);
    [mediaScrollview addSubview:iconMediaBtn1];
    
    UIButton *iconMediaBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];   // for videos selection
    iconMediaBtn2.tag=5;
    [iconMediaBtn2 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconMediaBtn2 setBackgroundImage:[UIImage imageNamed:@"gallery65.png"] forState:UIControlStateNormal];
    iconMediaBtn2.frame = CGRectMake(50, 0, 45 ,45);
    [mediaScrollview addSubview:iconMediaBtn2];
    
    UIButton *iconMediaBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];   // for location selection
    iconMediaBtn3.tag=6;
    [iconMediaBtn3 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconMediaBtn3 setBackgroundImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    iconMediaBtn3.frame = CGRectMake(100, 0, 45 ,45);
    [mediaScrollview addSubview:iconMediaBtn3];
    
    UIButton *iconMediaBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];   // for audio recording selection
    iconMediaBtn4.tag=7;
    //[iconMediaBtn4 addTarget:self action:@selector(AudioButtonDownAction)forControlEvents:UIControlEventTouchDown];
    //[iconMediaBtn4 addTarget:self action:@selector(AudioButtonUpAction)forControlEvents:UIControlEventTouchUpInside];
    [iconMediaBtn4 addTarget:self action:@selector(MediaButtonsAction:)forControlEvents:UIControlEventTouchDown];
    [iconMediaBtn4 setBackgroundImage:[UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    iconMediaBtn4.frame = CGRectMake(150, 0, 45 ,45);
    [mediaScrollview addSubview:iconMediaBtn4];
    
    // create container for animations
    attachmentAnimationView = [[CSAnimationView alloc] initWithFrame:CGRectMake(-220, mediaScrollview.frame.origin.y, mediaScrollview.frame.size.width, mediaScrollview.frame.size.height)];
    
    mediaScrollview.frame = CGRectMake(0, 0, attachmentAnimationView.frame.size.width, attachmentAnimationView.frame.size.height);
    attachmentAnimationView.userInteractionEnabled=YES;
    [self.view addSubview:attachmentAnimationView];
    [self.view bringSubviewToFront:attachmentAnimationView];

    [attachmentAnimationView addSubview:mediaScrollview];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudio.mp4",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
   [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
//    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
//                                    [NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
//                                    [NSNumber numberWithInt:16], AVEncoderBitRateKey,
//                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
//                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt:8], AVLinearPCMBitDepthKey,
//                                    nil];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
    [self.SliderBar setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    
    self.ChatBgWhiteView.frame = CGRectMake(0,400,320,31);
    self.ChatBgImgView.frame = CGRectMake(0,432,320,50);
    self.sendMessageField.frame = CGRectMake(45,439,233,34);
    [self.sendMessageField setKeyboardAppearance:UIKeyboardAppearanceDark];
    self.sendMessageButton.frame = CGRectMake(282,439,33,35);
    self.ContentButton.frame = CGRectMake(282,439,33,35);
    self.mediaAttachButton.frame = CGRectMake(5,439,33,34);
    self.tableView.userInteractionEnabled=YES;
    self.tableView.allowsSelection=NO;
    
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            self.ChatBgWhiteView.frame = CGRectMake(0,488,320,31);
            self.ChatBgImgView.frame = CGRectMake(0,520,320,50);
            self.sendMessageField.frame = CGRectMake(45,527,233,34);
            self.sendMessageButton.frame = CGRectMake(282,527,33,35);
            self.ContentButton.frame = CGRectMake(282,527,33,35);
            self.mediaAttachButton.frame = CGRectMake(5,527,33,34);
            self.tableView.frame = CGRectMake(0,84,320,405);
        }
    }
    else
    {
         if(IS_IPHONE_5)
        {
            self.ChatBgWhiteView.frame = CGRectMake(0,488,320,31);
            self.ChatBgImgView.frame = CGRectMake(0,520,320,50);
            self.sendMessageField.frame = CGRectMake(45,527,233,34);
            self.ContentButton.frame = CGRectMake(45,527,233,34);
            self.sendMessageButton.frame = CGRectMake(282,527,33,35);
            self.mediaAttachButton.frame = CGRectMake(5,527,33,34);
            self.tableView.frame = CGRectMake(0,84,320,405);
        }
        else
        {
            self.ChatBgWhiteView.frame = CGRectMake(0,400,320,31);
            self.ChatBgImgView.frame = CGRectMake(0,432,320,50);
            self.sendMessageField.frame = CGRectMake(45,439,233,34);
            self.ContentButton.frame = CGRectMake(45,439,233,34);
            self.sendMessageButton.frame = CGRectMake(282,439,33,35);
            self.mediaAttachButton.frame = CGRectMake(5,439,33,34);
            self.tableView.frame = CGRectMake(0,84,320,315);
        }
    }
    
    
    // notifications text
    notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    notification_text.center=CGPointMake(298, 19);
    notification_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    notification_text.tag = 5;
    notification_text.backgroundColor = [UIColor clearColor];
    // header_text = [UIFont fontWithName:@"Halvetica" size:10];
    notification_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
    notification_text.lineBreakMode = YES;
    notification_text.numberOfLines = 0;
    notification_text.lineBreakMode = NSLineBreakByTruncatingTail;
    notification_text.text=@"";
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    notification_text.text = [NSString stringWithFormat:@"%i",appDelegate.unreadNotificationsCount];
    appDelegate = nil;
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
    
    [self.view addSubview:notification_text];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillHide:) 
                                                 name:UIKeyboardWillHideNotification 
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    
	textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(45, 9, 233, 43)];
    [textView setBackgroundColor:[UIColor colorWithRed:(104.0/255.0) green:(113.0/255.0) blue:(141.0/255.0) alpha:1.0]];
    textView.textColor = [UIColor whiteColor];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 4;
    // you can also set the maximum height in points with maxHeight
	textView.returnKeyType = UIReturnKeyDefault; //just as an example
    [textView setKeyboardAppearance:UIKeyboardAppearanceDark];
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.delegateNotification=self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    //textView.placeholder = @"Type to see the textView grow!";
//    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    textView.layer.cornerRadius = 2.0;
    textView.clipsToBounds = YES;
    
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(5, 0, 248, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"test.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    //[containerView addSubview:entryImageView];
    
	ContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
	ContentButton.frame = CGRectMake(282, 9, 33, 35);
    ContentButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [ContentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	//[ContentButton addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
    [ContentButton setBackgroundImage:[UIImage imageNamed:@"arrow-1.png"] forState:UIControlStateNormal];
	[containerView addSubview:ContentButton];
    
    sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sendMessageButton.frame = CGRectMake(281, 10, 38, 32);
    sendMessageButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[sendMessageButton addTarget:self action:@selector(chatButton:) forControlEvents:UIControlEventTouchUpInside];
    [sendMessageButton setBackgroundImage:[UIImage imageNamed:@"sendbtn.png"] forState:UIControlStateNormal];
	[containerView addSubview:sendMessageButton];
    
    mediaAttachButton = [UIButton buttonWithType:UIButtonTypeCustom];
	mediaAttachButton.frame = CGRectMake(5, 9, 33, 34);
    mediaAttachButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [mediaAttachButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[mediaAttachButton addTarget:self action:@selector(mediaButton:) forControlEvents:UIControlEventTouchUpInside];//MediaButtonsAction:
    [mediaAttachButton setImage:[UIImage imageNamed:@"footer_attachment.png"] forState:UIControlStateNormal];
	[containerView addSubview:mediaAttachButton];
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    ContentButton.hidden = NO;
    sendMessageButton.hidden = YES;
    
    [self.view bringSubviewToFront:ChatBgWhiteView];
    [self getprofileinfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.tableView addGestureRecognizer:tap];
   
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![[prefs stringForKey:@"ShowChatOverlay"] isEqualToString:@"no"])
    {
        if (IS_IPHONE_5)
        {
            overLayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            overLayImgView.image = [UIImage imageNamed:@"overlay_640by1136 (1).png"];
            
           okGotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okGotItButton.frame = CGRectMake(90, 250, 140, 60);
            okGotItButton.backgroundColor = [UIColor clearColor];
            [okGotItButton addTarget:self action:@selector(okGotItButtonAction:) forControlEvents:UIControlEventTouchUpInside];//MediaButtonsAction:
            [self.view addSubview:okGotItButton];
        }
        else
        {
            overLayImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            overLayImgView.image = [UIImage imageNamed:@"overlay_640by960 (2).png"];
            
            okGotItButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okGotItButton.frame = CGRectMake(90, 210, 140, 60);
            okGotItButton.backgroundColor = [UIColor clearColor];
            [okGotItButton addTarget:self action:@selector(okGotItButtonAction:) forControlEvents:UIControlEventTouchUpInside];//MediaButtonsAction:
            [self.view addSubview:okGotItButton];
        }
        
        [self.view addSubview:overLayImgView];
    }
    else
    {
        [prefs setObject:@"no" forKey:@"ShowChatOverlay"];
    }
    
    UIImageView *imgViewOverLay;
    UIButton *LetsGetClickinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (IS_IPHONE_5)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        imgViewOverLay = [[UIImageView alloc] initWithFrame:CGRectMake(35, 180, 250, 211)];
        LetsGetClickinButton.frame = CGRectMake(50, 320, 220, 60);
    }
    else
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imgViewOverLay = [[UIImageView alloc] initWithFrame:CGRectMake(35, 120, 250, 211)];
        LetsGetClickinButton.frame = CGRectMake(50, 260, 220, 60);
    }
    
    [view setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];

    imgViewOverLay.image = [UIImage imageNamed:@"popup.png"];
    [view addSubview:imgViewOverLay];
    view.hidden = YES;
    
   
    
    
    LetsGetClickinButton.backgroundColor = [UIColor clearColor];
    [LetsGetClickinButton addTarget:self action:@selector(LetsGetClickinButtonAction:) forControlEvents:UIControlEventTouchUpInside];//MediaButtonsAction:
    [view addSubview:LetsGetClickinButton];
    
    [prefs stringForKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]];

    if(![[prefs stringForKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]] isEqualToString:@"no"])
    {
        //show
        view.hidden = NO;
    }
    else
    {
        //hide
        [prefs setObject:@"no" forKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]];
        view.hidden = YES;
    }

    [self.view addSubview:view];
    
    if(![[prefs stringForKey:@"ShowChatOverlay"] isEqualToString:@"no"])
    {
        view.hidden = YES;
    }
    
  ///////////////////////////////////////////////////for local storage////////////////////////////////////////////////////////////////////////
    
   NSLog(@"strRelationShipId>> %@",self.strRelationShipId);
   NSLog(@"%d",self.messages.count);
    
   NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]]; //[prefs objectForKey:self.strRelationShipId];
    
    if([dict objectForKey:@"ArrayMessages"])
    {
        NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
        NSMutableArray *retrievedarray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        [self.messages addObjectsFromArray:retrievedarray];
    }
    
    if([dict objectForKey:@"ArrayCardStatus"])
    {
         [card_accept_status addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
    }

    if([dict objectForKey:@"ArrayImagedata"])
         [imagesData addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
//    imagesData = (NSMutableArray *)[dict objectForKey:@"ArrayImagedata"];
    
    if([dict objectForKey:@"ArrayAudioData"])
         [audioData addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
//    audioData = (NSMutableArray *)[dict objectForKey:@"ArrayAudioData"];

    if(self.messages.count >= 20)
    {
        isChatHistoryOrNot = TRUE;
        [self.tableView reloadData];
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        [self.tableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    }
    else
    {
        isChatHistoryOrNot = FALSE;
        [self.tableView reloadData];
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
//    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
//    [activity show];
//    [self performSelector:@selector(CallGetChatHistoryWebservice) withObject:nil afterDelay:0.1];
    
    //[NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    
    
     [self.view bringSubviewToFront:self.tintView];
    
    
}


-(void)setChatDelegate
{
    chatmanager.CenterCustomObjDelegate = self;
    //set chat delegate
    chatmanager.CenterMessageReceiveDelegate=self;
}
-(void)sendNotification:(NSString*)Message
{
    if([Message isEqualToString:@"is_typing"])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"yes" forKey:@"is_typing"];
        QBChatMessage *message = [QBChatMessage message];
        message.ID = @"0987";
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue]; // opponent's id
        [message setText:@"        "];
        [message setCustomParameters:[@{@"isComposing" : @"YES"} mutableCopy]];
        
        [self SendMessage:message dict:nil];
//        [chatmanager sendMessage:message];
    }
    else if([Message isEqualToString:@"callHideSendbuttonMethod"])
    {
        if(mediaAttachButton.tag == 1)
        {
            ContentButton.hidden = NO;
            sendMessageButton.hidden = YES;
        }
    }
    else if([Message isEqualToString:@"callShowSendbuttonMethod"])
    {
        ContentButton.hidden = YES;
        sendMessageButton.hidden = NO;
    }
    else if([Message isEqualToString:@"endistyping"])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"no" forKey:@"is_typing"];
        
        QBChatMessage *message = [QBChatMessage message];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
        [message setText:@"        "];
        [message setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
        
        [self SendMessage:message dict:nil];

    }
}

-(void)SetVolumeNotificationReceived3:(NSNotification *)notification
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
    {
        click.volume = 0;
        attachmentSound.volume = 0;
        ClicksChangedSound.volume = 0;
        outgoingMsgSound.volume = 0;
        outgoingMsgSound.volume = 0;
    }
    else
    {
        click.volume = 1;
        attachmentSound.volume = 1;
        ClicksChangedSound.volume = 1;
        outgoingMsgSound.volume = 1;
        outgoingMsgSound.volume = 1;
    }
}


//- (void)endistypingMethod:(NSNotification *)notification
//{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:@"no" forKey:@"is_typing"];
//
//    QBChatMessage *message = [QBChatMessage message];
//    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
//    message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
//    [message setText:@"        "];
//    [message setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
//    [chatmanager sendMessage:message];
//}
//
//- (void)istypingMethod:(NSNotification *)notification
//{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    [prefs setObject:@"yes" forKey:@"is_typing"];
//    QBChatMessage *message = [QBChatMessage message];
//    message.ID = @"0987";
//    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
//    message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue]; // opponent's id
//   [message setText:@"        "];
//    [message setCustomParameters:[@{@"isComposing" : @"YES"} mutableCopy]];
//    [chatmanager sendMessage:message];
//}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    notification_text.text = @"0";
    
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
   
}


- (void)chatLoginStatusChanged:(NSNotification *)notification //use notification method and logic
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.isChatLoggedIn)
        sendMessageButton.enabled = true;
    else
        sendMessageButton.enabled = false;
    
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        //retrieve partner user last seen
        [QBUsers userWithID:[partner_QB_id integerValue] delegate:chatmanager];
    }
    appDelegate = nil;

}

- (void)ProfileInfoNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    //set notification count set
    notification_text.text=profilemanager.ownerDetails.notificationCount;
    
    [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
}

-(void)sendMessageData:(NSDictionary *)dictionary
{
    QBChatMessage *testMessage = [QBChatMessage message];
    NSString *Str_Partner_id = partner_QB_id;
    testMessage.recipientID = [Str_Partner_id intValue];
    [testMessage setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
    [self SendMessage:testMessage dict:nil];
    
    
    QBChatMessage *message = dictionary[@"sharedMessage"];
    NSData *image_data = dictionary[@"imageData"];
    
    [self.messages addObject:message];
    
    // NSLog(@"%@",self.messages);
    [imagesData addObject:image_data];
    [audioData addObject:[[NSData alloc] init]];
    
    NSLog(@"local chat added: %@",self.messages);
    
    //[[QBChat instance] sendMessage:message];
    
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
    
    if(message.text.length==0)
        message.text = @" ";
    
    [self SendMessage:message dict:Tempdict];
    
    if([message.text isEqualToString:@" "])
        message.text = @"";

    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:message.ID forKey:@"chatId"];
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    
    if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        Str = [Str stringByReplacingCharactersInRange:range withString:@""];
        
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    
    [object.fields setObject:@"1" forKey:@"type"];
    
    if([message.customParameters[@"fileID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"fileID"] forKey:@"content"];
        [object.fields setObject:@"2" forKey:@"type"];
    }
    else if([message.customParameters[@"isFileUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"content"];
        [object.fields setObject:@"2" forKey:@"type"];
    }
    
    else if([message.customParameters[@"videoID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"videoID"] forKey:@"content"];
        [object.fields setObject:message.customParameters[@"videoThumbnail"] forKey:@"video_thumb"];
        [object.fields setObject:@"4" forKey:@"type"];
    }
    else if([message.customParameters[@"isVideoUploading"] integerValue]==1 )
    {
        [object.fields setObject:message.customParameters[@"videoStreamURL"] forKey:@"content"];
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"video_thumb"];
        [object.fields setObject:@"4" forKey:@"type"];
    }
    else if([message.customParameters[@"audioID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"audioID"] forKey:@"content"];
        [object.fields setObject:@"3" forKey:@"type"];
    }
    else if([message.customParameters[@"isAudioUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"audioStreamURL"] forKey:@"content"];
        [object.fields setObject:@"3" forKey:@"type"];
    }
    else if([message.customParameters[@"locationID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"locationID"] forKey:@"content"];
        [object.fields setObject:@"6" forKey:@"type"];
    }
    else if([message.customParameters[@"isLocationUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"content"];
        [object.fields setObject:@"6" forKey:@"type"];
    }
    else if([message.customParameters[@"card_heading"] length]>0)
    {
        [object.fields setObject:@"5" forKey:@"type"];
        NSArray *cards_array=[NSArray arrayWithObjects: message.customParameters[@"card_id"],
                              message.customParameters[@"card_heading"],
                              message.customParameters[@"card_content"],
                              message.customParameters[@"card_url"],
                              message.customParameters[@"card_clicks"],
                              @"accepted",
                              message.customParameters[@"card_originator"],
                              message.customParameters[@"is_CustomCard"],
                              message.customParameters[@"card_DB_ID"],
                              nil];
        [object.fields setObject:cards_array forKey:@"cards"];
        cards_array = nil;
    }
    
    
    
    NSArray *shared_array=[NSArray arrayWithObjects: message.customParameters[@"originalMessageID"],
                           message.customParameters[@"shareStatus"],
                           message.customParameters[@"messageSenderID"],
                           message.customParameters[@"isAccepted"],
                           message.customParameters[@"isMessageSender"],
                           message.customParameters[@"comment"],
                           message.customParameters[@"sharingMedia"],
                           message.customParameters[@"facebookToken"],
                           nil];
    [object.fields setObject:shared_array forKey:@"sharedMessage"];
    
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    [QBCustomObjects createObject:object delegate:chatmanager];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.play_chatAnimation = true;
    appDelegate = nil;
    
    [self.tableView reloadData];
    
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

- (void)SharedMessageNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    /*
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationDidReceiveSharedMessage object:nil];
    QBChatMessage *message = notification.userInfo[@"sharedMessage"];
    NSData *image_data = notification.userInfo[@"imageData"];
    
    [self.messages addObject:message];
    
    // NSLog(@"%@",self.messages);
    [imagesData addObject:image_data];
    [audioData addObject:[[NSData alloc] init]];
    
  
    
    NSLog(@"local chat added: %@",self.messages);
    
    //[[QBChat instance] sendMessage:message];
    [chatmanager sendMessage:message];
    
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:message.ID forKey:@"chatId"];
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    
    if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        Str = [Str stringByReplacingCharactersInRange:range withString:@""];
        
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    
    [object.fields setObject:@"1" forKey:@"type"];
    
    if([message.customParameters[@"fileID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"fileID"] forKey:@"content"];
        [object.fields setObject:@"2" forKey:@"type"];
    }
    else if([message.customParameters[@"isFileUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"content"];
        [object.fields setObject:@"2" forKey:@"type"];
    }
    
    else if([message.customParameters[@"videoID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"videoID"] forKey:@"content"];
        [object.fields setObject:message.customParameters[@"videoThumbnail"] forKey:@"video_thumb"];
        [object.fields setObject:@"4" forKey:@"type"];
    }
    else if([message.customParameters[@"isVideoUploading"] integerValue]==1 )
    {
        [object.fields setObject:message.customParameters[@"videoStreamURL"] forKey:@"content"];
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"video_thumb"];
        [object.fields setObject:@"4" forKey:@"type"];
    }
    else if([message.customParameters[@"audioID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"audioID"] forKey:@"content"];
        [object.fields setObject:@"3" forKey:@"type"];
    }
    else if([message.customParameters[@"isAudioUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"audioStreamURL"] forKey:@"content"];
        [object.fields setObject:@"3" forKey:@"type"];
    }
    else if([message.customParameters[@"locationID"] length]>1)
    {
        [object.fields setObject:message.customParameters[@"locationID"] forKey:@"content"];
        [object.fields setObject:@"6" forKey:@"type"];
    }
    else if([message.customParameters[@"isLocationUploading"] length]>0)
    {
        [object.fields setObject:message.customParameters[@"imageURL"] forKey:@"content"];
        [object.fields setObject:@"6" forKey:@"type"];
    }
    else if([message.customParameters[@"card_heading"] length]>0)
    {
        [object.fields setObject:@"5" forKey:@"type"];
        NSArray *cards_array=[NSArray arrayWithObjects: message.customParameters[@"card_id"],
                              message.customParameters[@"card_heading"],
                              message.customParameters[@"card_content"],
                              message.customParameters[@"card_url"],
                              message.customParameters[@"card_clicks"],
                              @"accepted",
                              message.customParameters[@"card_originator"],
                              message.customParameters[@"is_CustomCard"],
                              message.customParameters[@"card_DB_ID"],
                              nil];
        [object.fields setObject:cards_array forKey:@"cards"];
        cards_array = nil;
    }
    
    
    
    NSArray *shared_array=[NSArray arrayWithObjects: message.customParameters[@"originalMessageID"],
                          message.customParameters[@"shareStatus"],
                          message.customParameters[@"messageSenderID"],
                          message.customParameters[@"isAccepted"],
                          message.customParameters[@"isMessageSender"],
                          message.customParameters[@"comment"],
                          message.customParameters[@"sharingMedia"],
                          message.customParameters[@"facebookToken"],
                          nil];
    [object.fields setObject:shared_array forKey:@"sharedMessage"];
    
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    [QBCustomObjects createObject:object delegate:self];

    
    
    [self.tableView reloadData];
    
    if(isChatHistoryOrNot == TRUE)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    */
}


-(void)LetsGetClickinButtonAction:(id)sender
{
    view.hidden = YES;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"no" forKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]];
}

-(void)okGotItButtonAction:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"no" forKey:@"ShowChatOverlay"];
    overLayImgView.hidden = YES;
    okGotItButton.hidden =  YES;
    
    if(![[prefs stringForKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]] isEqualToString:@"no"])
    {
        //show
        view.hidden = NO;
    }
    else
    {
        //hide
        [prefs setObject:@"no" forKey:[NSString stringWithFormat:@"%dpopup",int_leftmenuIndex]];
        view.hidden = YES;
    }
}

- (void)chatHistoryFetched:(NSNotification *)notification
{
    // reload table data
    [activity hide];
    
    NSArray *ArrTemp = [NSArray arrayWithArray:self.messages];
    
    [messages removeAllObjects];
    [messages addObjectsFromArray:chatmanager.messages];
    if(chatmanager.TempArrayChatHistory.count < 20)
    {
        isChatHistoryOrNot = FALSE;
    }
    else
    {
        isChatHistoryOrNot = TRUE;
    }
    
    //adjust the media uploading indexes
    for(int i=0 ;i<videoUploading_indexes.count ; i++)
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *oldDict = (NSMutableDictionary *)[videoUploading_indexes objectAtIndex:i];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSString stringWithFormat:@"%i", chatmanager.TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
        [videoUploading_indexes replaceObjectAtIndex:i withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
    }
    
    for(int i=0 ;i<imagesUploading_indexes.count ; i++)
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *oldDict = (NSMutableDictionary *)[imagesUploading_indexes objectAtIndex:i];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSString stringWithFormat:@"%i", chatmanager.TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
        [imagesUploading_indexes replaceObjectAtIndex:i withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
    }
    
    for(int i=0 ;i<audioUploading_indexes.count ; i++)
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *oldDict = (NSMutableDictionary *)[audioUploading_indexes objectAtIndex:i];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSString stringWithFormat:@"%i", chatmanager.TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
        [audioUploading_indexes replaceObjectAtIndex:i withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
    }
    
    
    // fill imagedata correctly
    NSArray *ImageDataTemp = [NSArray arrayWithArray:imagesData];
    [imagesData removeAllObjects];
    [imagesData addObjectsFromArray:chatmanager.TempImageDataHistory];
    [imagesData addObjectsFromArray:ImageDataTemp];
    ImageDataTemp = nil;
    
    //fill audio data correctly
    NSArray *AudioDataTemp = [NSArray arrayWithArray:audioData];
    [audioData removeAllObjects];
    [audioData addObjectsFromArray:chatmanager.TempImageDataHistory];
    [audioData addObjectsFromArray:AudioDataTemp];
    AudioDataTemp = nil;
    
    
    for(int i=0 ;i<card_accept_status.count ; i++)
    {
        
        NSDictionary *oldDict = (NSDictionary *)[card_accept_status objectAtIndex:i];
        NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i", chatmanager.TempArrayChatHistory.count + [[oldDict valueForKey:@"index"] integerValue]],@"index",[oldDict valueForKey:@"status"],@"status", nil];;
        
        
        [card_accept_status replaceObjectAtIndex:i withObject:newDict];
        oldDict = nil;
        newDict = nil;
    }
    
    
    //fill card status array correctly
    NSArray *CardStatusTemp = [NSArray arrayWithArray:card_accept_status];
    [card_accept_status removeAllObjects];
    [card_accept_status addObjectsFromArray:chatmanager.TempCardStatusHistory];
    [card_accept_status addObjectsFromArray:CardStatusTemp];
    CardStatusTemp = nil;
    
    
    [self.tableView reloadData];
    if(chatmanager.TempArrayChatHistory.count < 20)
    {
        if(isChatHistoryOrNot == TRUE)
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count]  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
            else
            {
                if([messages count]>=1)
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count]-1   inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        
        
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count]-1   inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        if(isFromEariler == FALSE)
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
    
    //call reset unread messages
//    QBChatMessage *lastChatMessage = (QBChatMessage *)[messages lastObject];
//    [self resetUnreadMessageCount:lastChatMessage.ID relationship_ID:self.strRelationShipId];
}



-(void) HideSendbuttonMethod:(NSNotification *)note
{
    ContentButton.hidden = NO;
    sendMessageButton.hidden = YES;
}


-(void) ShowSendbuttonMethod:(NSNotification *)note
{
    ContentButton.hidden = YES;
    sendMessageButton.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [timer_notify invalidate];
    timer_notify = nil;
    
    ///////////////////////////////// For local storage ////////////////////////////////////////////////////////////////////////////////////////
 /*   NSMutableArray *TempArrayMessages;
    NSMutableArray *TempArrayImagedata;
    NSMutableArray *TempArrayAudioData;
    
    //fetching last 20 objects form messages array(main array)
    
    if(self.messages.count >= 20)
    {
        NSRange RangeMessages;
        RangeMessages.location = [self.messages count] - 20;
        RangeMessages.length = 20;
        TempArrayMessages = [[self.messages subarrayWithRange:RangeMessages] mutableCopy];
    }
    else
    {
        TempArrayMessages = [[NSArray arrayWithArray:self.messages] mutableCopy];
    }
    
    //fetching last 20 objects form imagedata array
    
    if(imagesData.count >= 20)
    {
        NSRange RangeImageData;
        RangeImageData.location = [imagesData count] - 20;
        RangeImageData.length = 20;
        TempArrayImagedata = [[imagesData subarrayWithRange:RangeImageData] mutableCopy];
    }
    else
    {
        TempArrayImagedata = [[NSArray arrayWithArray:imagesData] mutableCopy];
    }

    //fetching last 20 objects form audiodata array

    if(audioData.count >= 20)
    {
        NSRange RangeAudioData;
        RangeAudioData.location = [audioData count] - 20;
        RangeAudioData.length = 20;
        TempArrayAudioData = [[audioData subarrayWithRange:RangeAudioData] mutableCopy];
    }
    else
    {
        TempArrayAudioData = [[NSArray arrayWithArray:audioData] mutableCopy];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:TempArrayMessages],@"ArrayMessages",TempArrayImagedata,@"ArrayImagedata",TempArrayAudioData,@"ArrayAudioData", nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setObject:dict forKey:self.strRelationShipId];
    
    [prefs synchronize];
    */
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
     
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_InAppSoundsFlag object:nil];
}
#pragma mark keyboard notifications
//Keyboard up and down
-(void) keyboardWillShow:(NSNotification *)note
{
    isKeyBoardVisible=YES;
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
    
    CGRect ChatBgWhiteViewRect = ChatBgWhiteView.frame;
    ChatBgWhiteViewRect.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-31;
    
    CGRect rectAttachementScrollView = attachmentAnimationView.frame;
    rectAttachementScrollView.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-31;
    
    CGRect keyboardEndFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGRect rectTableView = self.tableView.frame;
    int diff =keyboardEndFrame.size.height-keyboardBeginFrame.size.height;
    CGFloat height=textView.frame.size.height;
    // In case of keyboard shown or hidden the diff comes out to be 0.
    // IN case of difference is negative the suggestions are hidden.
    // In case of positive the suggestions are shown.
    if (diff==-29)
    {
        isKeyboardSuggestionEnabled=FALSE;
        if (IS_IPHONE_5)
        {
            rectTableView.size.height = 214-height;
        }
        else
        {
            rectTableView.size.height=188-20-height;
        }
        
        NSLog(@"In this case keyboard hides the suggestion view");
    }
    else if(diff==29)
    {
        isKeyboardSuggestionEnabled=TRUE;
        if (IS_IPHONE_5)
        {
            rectTableView.size.height=185-height;
        }
        else
        {
            rectTableView.size.height=188-20-88;
        }
        NSLog(@"In this case keyboard shows the suggestion view");
    }
    else
    {
         CGFloat txtViewheight=textView.frame.size.height;
        if (IS_IPHONE_5)
        {
            int height = MIN(keyboardBeginFrame.size.height,keyboardBeginFrame.size.width);
            // IN CASE THE SUGGESTIONS ARE OPEN HEIGHT OF KEYBOARD IS 253 ELSE 224
            if (height>224)
            {
                isKeyboardSuggestionEnabled=TRUE;
                rectTableView.size.height = 186-txtViewheight;
            }
            else
            {
                isKeyboardSuggestionEnabled=FALSE;
                rectTableView.size.height = 214-txtViewheight;
            }
            
        }
        else
        {
            rectTableView.size.height = 188-60-txtViewheight;
        }
    }
    
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
    
    ChatBgWhiteView.frame = ChatBgWhiteViewRect;
    
    [attachmentAnimationView setFrame:rectAttachementScrollView];
   
   [self.tableView setFrame:rectTableView];
    
    
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    UIImageView *ImgViewClicks=(UIImageView *)[Overlay viewWithTag:13];
    
    CGRect rectChatOverlayImgView = ImgViewClicks.frame;
    
    CGRect rectChatOverlayText = textClicks.frame;
    if (IS_IPHONE_5)
    {
        rectChatOverlayText.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-250-40;
        rectChatOverlayImgView.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-250-20;
    }
    else
    {
        rectChatOverlayText.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-200-40;
        rectChatOverlayImgView.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)-200-20;
    }
    [ImgViewClicks setFrame:rectChatOverlayImgView];
    [textClicks setFrame:rectChatOverlayText];
    
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    isKeyBoardVisible=NO;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    
    CGRect ChatBgWhiteViewRect = ChatBgWhiteView.frame;
    ChatBgWhiteViewRect.origin.y = self.view.bounds.size.height - containerFrame.size.height - 31;
    
    CGRect rectAttachementScrollView = attachmentAnimationView.frame;
    rectAttachementScrollView.origin.y = self.view.bounds.size.height - containerFrame.size.height - 31;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
    ChatBgWhiteView.frame = ChatBgWhiteViewRect;
    [attachmentAnimationView setFrame:rectAttachementScrollView];
    
    CGFloat height=textView.frame.size.height;
    CGRect rectTableView = self.tableView.frame;
    if (IS_IPHONE_5)
    {
        rectTableView.size.height = 439-height;
    }
    else
    {
        rectTableView.size.height = 349-height;
    }
    [self.tableView setFrame:rectTableView];
    
    
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    UIImageView *ImgViewClicks=(UIImageView *)[Overlay viewWithTag:13];
    
    CGRect rectChatOverlayImgView = ImgViewClicks.frame;
    CGRect rectChatOverlayText = textClicks.frame;
    if (IS_IPHONE_5)
    {
        rectChatOverlayImgView.origin.y = self.view.bounds.size.height - containerFrame.size.height-350-25;
        rectChatOverlayText.origin.y = self.view.bounds.size.height - containerFrame.size.height-350-45;
    }
    else
    {
        rectChatOverlayImgView.origin.y = self.view.bounds.size.height - containerFrame.size.height-280-50;
        rectChatOverlayText.origin.y = self.view.bounds.size.height - containerFrame.size.height-280-70;
    }
    
    [ImgViewClicks setFrame:rectChatOverlayImgView];
    [textClicks setFrame:rectChatOverlayText];
    
    if(isChatHistoryOrNot == TRUE)
    {
        // In Case of isChatHistoryOrNot == TRUE , set the -1 in case of
        if([messages count]>=1)
        {
            NSIndexPath *idxPath=[NSIndexPath indexPathForRow:[messages count] inSection:0];
            [self.tableView scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
	// commit animations
	[UIView commitAnimations];
}
#pragma mark -
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
    
    CGRect ChatBgWhiteViewRect = ChatBgWhiteView.frame;
    ChatBgWhiteViewRect.origin.y = containerView.frame.origin.y-30;
    ChatBgWhiteView.frame = ChatBgWhiteViewRect;
    
    CGRect TableViewRect = tableView.frame;
    if(diff < 0)
    {
        if([messages count]>=1)
        TableViewRect.size.height = tableView.frame.size.height - 18;
        CGFloat height=tableView.contentSize.height;
        [self.tableView setContentOffset:CGPointMake(0,  height)];
    }
    else
    {
        TableViewRect.size.height = tableView.frame.size.height + 18;
    }
    tableView.frame = TableViewRect;
}

-(void) resetUnreadMessageCount:(NSString*)chatID relationship_ID:(NSString *)relationShipID
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"chats/resetunreadmessagecount"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationShipID,@"relationship_id", chatID, @"last_chat_id", nil];
        
        NSLog(@"%@",Dictionary);
        
        
        request.tag = 77;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
//        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        NSLog(@"responseString %@",[request responseString]);
    }
}



-(void)getprofileinfo
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        [profilemanager.ownerDetails getProfileInfo:YES];
        //retrieve partner user last seen
        [QBUsers userWithID:[partner_QB_id integerValue] delegate:chatmanager];
    }
    
    /*NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //NSError *error;
    
    //NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    //
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //[request appendPostData:jsonData];
    [request setDidFinishSelector:@selector(requestFinished_info:)];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];*/
}

/*
- (void)requestFinished_info:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User details found."] || success)
        {
            //notification count set
            notification_text.text=[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]];
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
    }
}*/

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"no" forKey:@"is_typing"];
    QBChatMessage *message = [QBChatMessage message];
    NSString *StrPartner_id = partner_QB_id;
    message.recipientID = [StrPartner_id intValue];
    [message setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
//  [chatmanager sendMessage:message];
    
    [self SendMessage:message dict:nil];
    [textView resignFirstResponder];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.sendMessageField resignFirstResponder];
//}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
- (void)viewWillAppear:(BOOL)animated
{
    if(timer_notify == nil)
    {
        timer_notify = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self
                                                  selector:@selector(getprofileinfo)
                                                  userInfo:nil
                                                   repeats:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.isChatLoggedIn)
        sendMessageButton.enabled = true;
    else
        sendMessageButton.enabled = false;
    
    
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    QBUUser *currentUser = [QBUUser user];
//    currentUser.ID = [prefs integerForKey:@"SenderId"]; // your current user's ID
//    currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
//    [QBChat instance].delegate = self;
//    [[QBChat instance] loginWithUser:currentUser];
    
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        //retrieve partner user last seen
        [QBUsers userWithID:[partner_QB_id integerValue] delegate:chatmanager];
    }
    
    appDelegate = nil;
    [super viewWillAppear:animated];
    [tableView reloadData];
}

//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    self.HistoryButton.enabled = true;
//}


/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.HistoryButton.enabled = true;

}*/
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    self.HistoryButton.enabled = true;
//}
#pragma mark -
#pragma mark attachment delegates
-(void)cancelAttachment
{
    [self dismissViewControllerAnimated:YES completion:^
    {
         [viewAttachment removeFromSuperview];
    }];
    
}
-(void)addAttachment
{
    if (viewAttachment.isAttachmentImage)
    {
        tempImageRatio = 1;
        
        
        //NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        //NSString *imageName = [imagePath lastPathComponent];
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
        // Upload selected file
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.5f;
        int maxFileSize = 2*1024;
        
        NSData *imageData = UIImageJPEGRepresentation(imgAttachment, compression);
        
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(imgAttachment, compression);
        }
        
        
        NSLog(@"Size of Image(bytes):%d",[imageData length]);
        
        if(([imageData length]/1000000.0f)>25)
        {
            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Image size is too big. Maximum limit allowed is 25 MB." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            //            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Sorry!"
                                                                            description:@"Image size is too big. Maximum limit allowed is 25 MB."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
        else
        {
            tempMediaData  = imageData ;
            [mediaAttachButton setImage:[UIImage imageWithData:tempMediaData] forState:UIControlStateNormal];
            mediaAttachButton.tag = 2; //tag 2 for image
        }
        
    }
    else
    {
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:viewAttachment.videoURL];
        UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [player stop];
        player=Nil;
        
        thumbnail = [self scaleImage:thumbnail toSize:CGSizeMake(175, 175)];
        
        NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.4);
        
        tempMediaData  = imageData ;
        tempVideoUrl = viewAttachment.videoURL;
        [mediaAttachButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
        mediaAttachButton.tag = 4; //tag 4 for video
    }
    
    [viewAttachment removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark custom actions

-(IBAction)btnUserImgAction:(id)sender
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    
//    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//    while (controllers.count>1) {
//        [controllers removeLastObject];
//    }
//    
//    navigationController.viewControllers = controllers;
//    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(IBAction)btnPartnarImgAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];

    profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
    profile_other.relationObject = relationObject;
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
    while (controllers.count>1) {
        [controllers removeLastObject];
    }
    navigationController.viewControllers = controllers;
    [navigationController pushViewController:profile_other animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag==774477)
    {
    
        if(scrollView.contentOffset.y<0)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
        }
    
        if(scrollView.contentOffset.y>0 && headerOptionsScrolled==false)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 400) animated:YES];
            headerOptionsScrolled = true;
            HeaderChatHistoryScrollView.userInteractionEnabled = false;
            [self.HistoryButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
            
            self.HistoryButton.enabled=false;
            
           timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                      target:self
                                                    selector:@selector(timerFired)
                                                    userInfo:nil
                                                     repeats:NO];
            
            
            [UIView animateWithDuration:0.4 animations:^() {
                
                    HeaderChatHistoryScrollView.alpha = 0;
                }];
        }
        
        NSLog(@"scoll offset .......%f",scrollView.contentOffset.y);
    }
    
    
    if(shareScrollView.alpha==1)
    {
        [UIView animateWithDuration:0.4 animations:^() {
            shareScrollView.alpha = 0;
        }];
        [(UIButton*)[shareScrollView viewWithTag:111111] setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:222222] setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:333333] setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:444444] setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        //[(UIButton*)[shareScrollView.superview viewWithTag:555555] setEnabled:false];
    }
}

-(void)timerFired
{
    self.HistoryButton.enabled = true;
    HeaderChatHistoryScrollView.userInteractionEnabled=true;
    [timer invalidate];
    timer = nil;
}

/*
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView.tag==774477)
    {
        self.HistoryButton.enabled=true;
        scrollView.userInteractionEnabled = true;
    }
}
*/

-(IBAction)TopNotificationButton:(id)sender
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}


-(IBAction)topCardButton:(id)sender
{
    //card selection
    
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_heading"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_content"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_clicks"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_owner"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_originator"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"is_CustomCard"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_DB_ID"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:rightTopHeaderClicks.text forKey:@"UserClicks"];
    
    TradePostCards *obj=[[TradePostCards alloc] init];
    obj.view.backgroundColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //obj.view.superview.bounds = CGRectMake(0, 0, 550, 320);
    //[obj setTransitioningDelegate:transitionController];
    self.navigationController.modalPresentationStyle=UIModalPresentationCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;
    
    [UIView animateWithDuration:0.5 animations:^() {
        CardsScrollview.alpha = 0;
        mediaScrollview.alpha = 0;
        [self.view sendSubviewToBack:attachmentAnimationView];
    }];

}

/*
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            
            FBSession.activeSession = session;
            
            if(shareScrollView.alpha==1)
            {
                [(UIButton*)[shareScrollView viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
            }
            
            //[self getuserID];  // get user email
            [activity hide];
            
        }
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
            [activity hide];
        }
            break;
            
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
            // [self.navController popToRootViewControllerAnimated:NO];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
            [FBSession.activeSession closeAndClearTokenInformation];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"FB privacy settings Error"
                                      message:@"Please go to Settings -> Facebook and allow ClickIn to use your account"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            [activity hide];
            return;
            // [self showLoginView];
        }
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        [activity hide];
    }
}
*/

-(void) ShareButtonsAction:(UIButton*)sender
/*{
    UIButton* ShareButton = (UIButton*)sender;
    UITableViewCell *cell = (UITableViewCell *)[[[ShareButton superview] superview] superview];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    
 //   QBChatMessage *message;
//    if(messages.count < 20)
//    {
//        message= [messages objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        message= [messages objectAtIndex:indexPath.row-1];
//    }
    
    SharingViewController* SharingController = [[SharingViewController alloc] init];
//  SharingController.messageID = message.ID;
    [self.navigationController pushViewController:SharingController animated:YES];
    SharingController =nil;
}*/
{
    
    if(sender.tag==111111)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharegoogleplus.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharegoogleplusS.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
            [sender setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }

    }
    if(sender.tag==222222)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharetwitter.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharetwitterS.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
            [sender setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
    }
    if(sender.tag==333333)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharefacebook.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharefacebookS.png"] forState:UIControlStateNormal];
            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
            [activity show];
            
            //facebook login
            NSArray *permissions =
            [NSArray arrayWithObjects:@"publish_stream",@"publish_actions",nil];
//
//            [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES  completionHandler:
//             ^(FBSession *session,
//               FBSessionState state, NSError *error) {
//                 [self sessionStateChanged:session state:state error:error];
//             }];
            
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
        }
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
    }
    if(sender.tag==444444)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"clickin.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"clickinS.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"shareOnClickin"];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"shareOnClickin"];
        }
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
        
    }
    if(sender.tag==555555)
    {
        
        NSLog(@"%@",((UIButton*)[sender.superview viewWithTag:555555]).currentBackgroundImage);
        
        //if(((UIButton*)[sender.superview viewWithTag:555555]).currentBackgroundImage == [UIImage imageNamed:@"share_btnS.png"])
        if ([[((UIButton*)[sender.superview viewWithTag:555555]) backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"share_btnS.png"]])
        {
        
        [UIView animateWithDuration:0.5 animations:^() {
            shareScrollView.alpha = 0;
        }];
        
        QBChatMessage *message;
        message= [messages objectAtIndex:shareScrollView.tag];
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"/chats/share"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            NSError *error;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            
            NSLog(@"%@",[prefs stringForKey:@"phoneNumber"]);
            
            NSString *sharing_media = [NSString stringWithFormat:@""];
            if([[prefs stringForKey:@"shareOnClickin"] isEqualToString:@"yes"])
            {
                if(sharing_media.length==0)
                    sharing_media = [sharing_media stringByAppendingString:@"clickin"];
                else
                    sharing_media = [sharing_media stringByAppendingString:@",clickin"];
            }
            if([[prefs stringForKey:@"fb_accesstoken"] length]>0)
            {
                if(sharing_media.length==0)
                    sharing_media = [sharing_media stringByAppendingString:@"facebook"];
                else
                    sharing_media = [sharing_media stringByAppendingString:@",facebook"];
            }
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", message.ID ,@"chat_id" , [prefs stringForKey:@"relationShipId"] ,@"relationship_id",
                          sharing_media, @"media", [prefs stringForKey:@"fb_accesstoken"], @"fb_access_token", @"", @"twitter_access_token", @"" , @"googleplus_access_token" ,nil];
            
            
            NSLog(@"%@",Dictionary);
            sharing_media = nil;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
            
            [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            
            [request appendPostData:jsonData];
            
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request setTimeOutSeconds:200];
            [request startAsynchronous];
            NSLog(@"responseStatusCode %i",[request responseStatusCode]);
            NSLog(@"responseString %@",[request responseString]);
            
            if([request responseStatusCode] == 200)
            {
                NSError *error = nil;
                NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Newsfeed has been saved."])
                {
                }
            }
            
            else if([request responseStatusCode] == 401)
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Some error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Some error occured."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                            description:alertNetRechMessage
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
        }
        [activity hide];
            //[(UIButton*)[sender.superview viewWithTag:555555] setEnabled:false];
            [(UIButton*)[sender.superview viewWithTag:111111] setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:222222] setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:333333] setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:444444] setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
      }
        
      else
      {
//          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please select media to share with" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//          [alert show];
//          alert = nil;
          
          MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                          description:@"Please select media to share with"
                                                                        okButtonTitle:@"OK"];
          alertView.delegate = nil;
          [alertView show];
          alertView = nil;

      }
        
    }
}

-(void) MediaButtonsAction:(UIButton*)sender
{
    if(sender.tag==1)
    {
        //card selection
        
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_heading"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_content"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_url"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_clicks"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_id"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_owner"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_originator"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"is_CustomCard"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_DB_ID"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:rightTopHeaderClicks.text forKey:@"UserClicks"];
        
        TradePostCards *obj=[[TradePostCards alloc] init];
        obj.view.backgroundColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        //obj.view.superview.bounds = CGRectMake(0, 0, 550, 320);
        //[obj setTransitioningDelegate:transitionController];
        self.navigationController.modalPresentationStyle=UIModalPresentationCurrentContext;
        [self presentViewController:obj animated:YES completion:nil];
        obj=nil;
        
        [UIView animateWithDuration:0.5 animations:^() {
            CardsScrollview.alpha = 0;
            mediaScrollview.alpha = 0;
            [self.view sendSubviewToBack:attachmentAnimationView];
        }];
    }
    
    if(sender.tag==4)
    {
        //image picking
        [self AlertForSeLectionTheImageCapturing];
        [UIView animateWithDuration:0.5 animations:^() {
            mediaScrollview.alpha = 0;
            CardsScrollview.alpha  = 0;
            [self.view sendSubviewToBack:attachmentAnimationView];
        }];
    }
    
    if(sender.tag==5)
    {
        
        //video picking
        [self AlertForSeLectionTheVideoCapturing];
        [UIView animateWithDuration:0.5 animations:^() {
            mediaScrollview.alpha = 0;
            CardsScrollview.alpha  = 0;
            [self.view sendSubviewToBack:attachmentAnimationView];
        }];
        
//        if(_imgPicker==nil)
//            _imgPicker = [[UIImagePickerController alloc] init];
//        
//        
//        _imgPicker.delegate = self;
//
//        
//        _imgPicker.sourceType =
//        UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        
//        _imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
//        
//        [self presentViewController:_imgPicker animated:YES completion:nil];
//        
//        
//        [UIView animateWithDuration:0.5 animations:^() {
//            mediaScrollview.alpha = 0;
//            CardsScrollview.alpha  = 0;
//        }];
    }
    
    
    if(sender.tag==6)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[NSData alloc] init]  forKey:@"locationimagedata"];
        [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"locationCoordinates"];
        //[self.navigationController pushViewController:[[MapWebView alloc] init] animated:YES];
        [self presentViewController:[[MapWebView alloc] init] animated:YES completion:nil];
        [UIView animateWithDuration:0.5 animations:^()
        {
            mediaScrollview.alpha = 0;
            CardsScrollview.alpha  = 0;
            [self.view sendSubviewToBack:attachmentAnimationView];
        }];
    }
    
    
    if(sender.tag==7)
    {
        //audio picking
        //[self AlertForSeLectionTheAudioCapturing];

        [textView resignFirstResponder];
        
        [UIView animateWithDuration:0.5 animations:^() {
            mediaScrollview.alpha = 0;
            CardsScrollview.alpha  = 0;
            startRecordingView.alpha = 0.8;
            [self.view sendSubviewToBack:attachmentAnimationView];
        }];
    }
    
    
    tempMediaData = nil;
    tempImageRatio = 1;
    tempVideoUrl = nil;
    mediaAttachButton.tag = 1;
    [mediaAttachButton setImage:[UIImage imageNamed:@"footer_attachment.png"] forState:UIControlStateNormal];
    
}

-(void)hideRecordingView
{
    [UIView animateWithDuration:0.4 animations:^() {
        startRecordingView.alpha = 0;
    }];
}

//start recording audio
-(void) AudioButtonDownAction
{
    /*startRecordingView.alpha = 0.8;
    
    [UIView animateWithDuration:1.8 animations:^() {
        startRecordingView.alpha = 0;
    }];*/
    
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
    {
        isMusicPlaying = true;
        [[MPMusicPlayerController iPodMusicPlayer] pause];
    }
    else
        isMusicPlaying = false;
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionCategoryError = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionCategoryError];

    //AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    // Start recording
    [recorder record];
    
    /*
    UIAlertView *alert;
    alert = [[UIAlertView alloc]  initWithTitle:@"" message:@"Speak while holding the button" delegate:nil cancelButtonTitle:@" " otherButtonTitles:nil, nil];
    
    [alert show];

    [self performSelector:@selector(startRecording:) withObject:alert afterDelay:0.5];
    */
    
    
}

/*
-(void)startRecording:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:-1 animated:YES];
    
}
*/


//stop recording audio
-(void) AudioButtonUpAction
{
    [recorder stop];
    
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSError *sessionCategoryError = nil;
    if(isMusicPlaying)
    {
        [[MPMusicPlayerController iPodMusicPlayer] play];
        //[session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
    }
    else
    {
//        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionCategoryError];
//       UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);

    }
    
    //[session setActive:YES error:nil];
    
    // Initialize audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    // Active your audio session
    [audioSession setActive: NO error: nil];
    
    // Set audio session category
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    // Modifying Playback Mixing Behavior, allow playing music in other apps
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    
    propertySetError = AudioSessionSetProperty (
                                                kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                sizeof (allowMixing),
                                                &allowMixing);
    
    // Active your audio session
    [audioSession setActive: YES error: nil];

    
    [UIView animateWithDuration:0.4 animations:^() {
        startRecordingView.alpha = 0;
    }];
    
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag
{
    ContentButton.hidden = YES;
    sendMessageButton.hidden = NO;

    NSData *audio_data = [NSData dataWithContentsOfURL:recorder.url];

    /*NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    
    [QBContent TUploadFile:audio_data fileName:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString] contentType:@"audio/mpeg" isPublic:YES delegate:self];
    
    [audioData addObject:audio_data];
    //displaying file sent message in the chat
    QBChatMessage *message = [QBChatMessage message];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
    message.recipientID = [StrPartner_id intValue];
    message.text=@"Sending File...";
    [message setCustomParameters:[@{@"isAudioUploading": [NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString]} mutableCopy]];
    [[QBChat instance] sendMessage:message];*/
    
    tempMediaData  = audio_data ;
    [mediaAttachButton setImage:[UIImage imageNamed:@"mic_icon.png"] forState:UIControlStateNormal];
    mediaAttachButton.tag = 3; //tag 3 for audio


    audio_data = nil;
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"audio error %@",error.description);
}

#pragma mark audio 
//for hiding the Overlay View
-(void) overlayBtnAction:(UIButton*)sender
{
    sender.superview.alpha=0;
    
    UILabel *textClicks=(UILabel *)[sender.superview viewWithTag:12];
    
    float centerValue = ((SliderBar.maximumValue - SliderBar.minimumValue) / 2)+SliderBar.minimumValue;
    [SliderBar setValue:centerValue animated:YES];
    
    textClicks.text =@"00";
    [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
    [self.SliderBar setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
}


-(IBAction)HistoryHeaderButton:(id)sender
{
    
    UIButton *headerChatbutton = (UIButton *)sender;
    if([[UIImage imageNamed:@"head-nav.png"] isEqual:headerChatbutton.currentImage])
    {
        [headerChatbutton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [headerChatbutton setImage:[UIImage imageNamed:@"head-nav.png"] forState:UIControlStateNormal];
    }
    
    if(HeaderChatHistoryScrollView.alpha==0)
    {
        [HeaderChatHistoryScrollView setContentOffset:CGPointMake(HeaderChatHistoryScrollView.contentOffset.x, 0)];
        headerOptionsScrolled = false;
        HeaderChatHistoryScrollView.userInteractionEnabled = true;
        [UIView animateWithDuration:0.4 animations:^() {
            HeaderChatHistoryScrollView.alpha = 1;
        }];
    }
    else if(headerOptionsScrolled==false)
    {
        [UIView animateWithDuration:0.4 animations:^() {
            HeaderChatHistoryScrollView.alpha = 0;
        }];
    }
    
    
}


-(IBAction)SlideBarAction:(id)sender
{
    if(click.isPlaying==false)
        [click play];
    UISlider *slider = (UISlider *)sender;
    int SliderVal = slider.value;
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    UIImageView *imgView=(UIImageView *)[Overlay viewWithTag:13];
    
   
    
    if(SliderVal <= 0)
    {
        
        
        //[Overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blackBGClicks.png"]]];
        UISlider *slider=(UISlider *)sender;
        NSLog(@"Value is %i",slider.value);
        //CGFloat value=slider.value;
        //CGFloat posValue=abs(value);
        [Overlay setBackgroundColor:[UIColor blackColor]];
//        [Overlay setBlurRadius:posValue];
    

        if(SliderVal >= -9)
        {
            NSString *TempStr = [[NSString stringWithFormat:@"%d",SliderVal] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if([TempStr isEqualToString:@"0"])
                textClicks.text = [NSString stringWithFormat:@"0%@      ",TempStr];
            else
                textClicks.text = [NSString stringWithFormat:@"-0%@      ",TempStr];
            [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgrailapink.png"]];
            [self.SliderBar setThumbImage: [UIImage imageNamed:@"knobpink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
        }
        else
        {
            textClicks.text = [NSString stringWithFormat:@"%d      ",SliderVal];
            [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgrailapink.png"]];
            [self.SliderBar setThumbImage: [UIImage imageNamed:@"knobpink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
        }
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        if(SliderVal<previous_SliderValue)
        {
            if(SliderVal==-1)
            {
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_0.png"];
            }
            else if(SliderVal==-2)
            {
                for (int i = 0; i < 7; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_6.png"];
            }
            else if(SliderVal==-3)
            {
                for (int i = 7; i < 14; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_13.png"];
            }
            else if(SliderVal==-4)
            {
                for (int i = 14; i < 21; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_20.png"];
            }
            else if(SliderVal==-5)
            {
                for (int i = 21; i < 27; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_26.png"];
            }
            else if(SliderVal==-6)
            {
                for (int i = 27; i < 33; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_32.png"];
            }
            else if(SliderVal==-7)
            {
                for (int i = 33; i < 39; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_38.png"];
            }
            else if(SliderVal==-8)
            {
                for (int i = 39; i < 45; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_44.png"];
            }
            else if(SliderVal==-9)
            {
                for (int i = 45; i < 51; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_50.png"];
            }
            else if(SliderVal==-10)
            {
                for (int i = 51; i < 56; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_55.png"];
            }
            
            
            
            // Normal Animation
            imgView.animationImages = images;
            imgView.animationDuration = 0.6;
            imgView.animationRepeatCount = 1;
            [imgView startAnimating];
        }
        else if(SliderVal>previous_SliderValue)
        {
            if(SliderVal==-1)
            {
                for (int i = 6; i >= 0; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_0.png"];
            }
            else if(SliderVal==-2)
            {
                for (int i = 13; i >= 7; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_7.png"];
            }
            else if(SliderVal==-3)
            {
                for (int i = 20; i >= 14; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_14.png"];
            }
            else if(SliderVal==-4)
            {
                for (int i = 26; i >= 21; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_21.png"];
            }
            else if(SliderVal==-5)
            {
                for (int i = 32; i >= 27; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_27.png"];
            }
            else if(SliderVal==-6)
            {
                for (int i = 38; i >= 33; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_33.png"];
            }
            else if(SliderVal==-7)
            {
                for (int i = 44; i >= 39; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_39.png"];
            }
            else if(SliderVal==-8)
            {
                for (int i = 50; i >= 45; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_45.png"];
            }
            else if(SliderVal==-9)
            {
                for (int i = 55; i >= 51; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationNegative_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationNegative_51.png"];
            }
            
            
            
            // Normal Animation
            imgView.animationImages = images;
            imgView.animationDuration = 0.6;
            imgView.animationRepeatCount = 1;
            [imgView startAnimating];
        }

    }
    else
    {
        UISlider *slider=(UISlider *)sender;
        NSLog(@"Value is %i",slider.value);
        //CGFloat value=slider.value;
         Overlay.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:1.0f];
      //  [Overlay setBlurRadius:value];
       // [Overlay setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"whiteBGClicks.png"]]];
       // Overlay.opaque=NO;
         if(SliderVal <= 9)
         {
             textClicks.text = [NSString stringWithFormat:@"+0%d      ",SliderVal];
             [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgrailapink.png"]];
             [self.SliderBar setThumbImage: [UIImage imageNamed:@"knobpink.png"] forState:UIControlStateNormal];
             [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
             [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
         }
        else
        {
            textClicks.text = [NSString stringWithFormat:@"+%d      ",SliderVal];
            [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgrailapink.png"]];
            [self.SliderBar setThumbImage: [UIImage imageNamed:@"knobpink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
            [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
        }
        
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        
        if(SliderVal>previous_SliderValue)
        {
            if(SliderVal==1)
            {
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_0.png"];
            }
            else if(SliderVal==2)
            {
                for (int i = 0; i < 7; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_6.png"];
            }
            else if(SliderVal==3)
            {
                for (int i = 7; i < 14; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_13.png"];
            }
            else if(SliderVal==4)
            {
                for (int i = 14; i < 21; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_20.png"];
            }
            else if(SliderVal==5)
            {
                for (int i = 21; i < 27; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_26.png"];
            }
            else if(SliderVal==6)
            {
                for (int i = 27; i < 33; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_32.png"];
            }
            else if(SliderVal==7)
            {
                for (int i = 33; i < 39; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_38.png"];
            }
            else if(SliderVal==8)
            {
                for (int i = 39; i < 45; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_44.png"];
            }
            else if(SliderVal==9)
            {
                for (int i = 45; i < 51; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_50.png"];
            }
            else if(SliderVal==10)
            {
                for (int i = 51; i < 56; i++) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_55.png"];
            }
            
            
            
            // Normal Animation
            imgView.animationImages = images;
            imgView.animationDuration = 0.6;
            imgView.animationRepeatCount = 1;
            [imgView startAnimating];
        }
        else if(SliderVal<previous_SliderValue)
        {
            if(SliderVal==1)
            {
                for (int i = 6; i >= 0; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_0.png"];
            }
            else if(SliderVal==2)
            {
                for (int i = 13; i >= 7; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_7.png"];
            }
            else if(SliderVal==3)
            {
                for (int i = 20; i >= 14; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_14.png"];
            }
            else if(SliderVal==4)
            {
                for (int i = 26; i >= 21; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_21.png"];
            }
            else if(SliderVal==5)
            {
                for (int i = 32; i >= 27; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_27.png"];
            }
            else if(SliderVal==6)
            {
                for (int i = 38; i >= 33; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_33.png"];
            }
            else if(SliderVal==7)
            {
                for (int i = 44; i >= 39; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_39.png"];
            }
            else if(SliderVal==8)
            {
                for (int i = 50; i >= 45; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_45.png"];
            }
            else if(SliderVal==9)
            {
                for (int i = 55; i >= 51; i--) {
                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"SliderAnimationPositive_%i.png",i]]];
                }
                imgView.image = [UIImage imageNamed:@"SliderAnimationPositive_51.png"];
            }
            
            
            
            // Normal Animation
            imgView.animationImages = images;
            imgView.animationDuration = 0.6;
            imgView.animationRepeatCount = 1;
            [imgView startAnimating];
        }
    }
    
    ContentButton.hidden = YES;
    sendMessageButton.hidden = NO;
    if(SliderVal == 0)
    {
        ContentButton.hidden = NO;
        sendMessageButton.hidden = YES;
        //Overlay.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^() {
            Overlay.alpha = 0;
        }];
        [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
        [self.SliderBar setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
        [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
        [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    }
    else
    {
        ContentButton.hidden = YES;
        sendMessageButton.hidden = NO;
        //Overlay.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^()
        {
            // Changes Gurkaran 13/11/14
            Overlay.alpha = 1.0;
        }];
        [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgrailapink.png"]];
        [self.SliderBar setThumbImage: [UIImage imageNamed:@"knobpink.png"] forState:UIControlStateNormal];
        [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
        [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgraillinepink.png"] forState:UIControlStateNormal];
    }
    NSLog(@"sliderValue: %d",SliderVal);
    NSLog(@"textClicksText: %@",textClicks.text);
    
    previous_SliderValue = SliderVal;
}


-(IBAction)chatButton:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults]setObject:@"no" forKey:@"is_typing"];
    QBChatMessage *message1 = [QBChatMessage message];
    message1.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    message1.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
    [message1 setText:@"        "];
    [message1 setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
    [chatmanager sendMessage:message1 dict:nil];

    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking != 0)//0: internet working
    {
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        return;
    }
    
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    //Overlay.hidden = NO;
    Overlay.alpha=0;
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    if(mediaAttachButton.tag==1)
    {
        if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
        {
            //return if empty spaces entered
            NSString *rawString = [textView text];
            NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
            if ([trimmed length] == 0)
            {
                // Text was empty or only whitespace.
                [textView resignFirstResponder];
                return;
            }
            
    //        if(textView.text.length == 0)
    //        {
    //            [textView resignFirstResponder];
    //            return;
    //        }
        }
    }
    
    CheckIfAttachBtnContainMedia = false;
    ContentButton.hidden = NO;
    sendMessageButton.hidden = YES;
    checkforClicks =  false;
    
//    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
//    //Overlay.hidden = NO;
//    Overlay.alpha=0;
//    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    QBChatMessage *message = [[QBChatMessage alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *StrPartner_id = partner_QB_id;
    message.recipientID = [StrPartner_id intValue];
    NSLog(@"%d",[StrPartner_id intValue]);
    NSLog(@"%@",StrPartner_id);
    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    
    
    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init];

    if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
    {
        message.text = textView.text;
        //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
        [custom_Data setObject:@"no" forKey:@"clicks"];
    }
    else
    {
        [custom_Data setObject:[NSString stringWithFormat:@"%@",textClicks.text] forKey:@"clicks"];
        //[message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",textClicks.text]} mutableCopy]];
        message.text = [NSString stringWithFormat:@"%@ %@",textClicks.text ,textView.text];
        
        addMyClicks += [textClicks.text intValue];
        leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
        
        NSString *Clicks_g_analytics = [message.text substringFromIndex:1];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"R-Page"
                                                                                                                           action:@"Clicks sent"
                                                                                                                            label:@"Clicks sent"
                                                                                                                            value:[NSNumber numberWithInt:[Clicks_g_analytics intValue]]] build]];
    }
    
    float centerValue = ((SliderBar.maximumValue - SliderBar.minimumValue) / 2)+SliderBar.minimumValue;
    [SliderBar setValue:centerValue animated:YES];
    
    textClicks.text =@"00";
    [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
    [self.SliderBar setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    
    if(mediaAttachButton.tag==2)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);

        NSObject<Cancelable> *obj=[QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:chatmanager];
        [uploadingObjects addObject:obj];
        
                [imagesData addObject:tempMediaData];
                [audioData addObject:[[NSData alloc] init]];
                //displaying file sent message in the chat
                //QBChatMessage *message = [QBChatMessage message];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
                NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
                message.recipientID = [StrPartner_id intValue];
                message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
                //message.text=@"";
                //message.text=@"Sending File...";
                [custom_Data setObject:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isFileUploading"];
                [custom_Data setObject:[NSString stringWithFormat:@"%f",tempImageRatio] forKey:@"imageRatio"];
                [message setCustomParameters:custom_Data];
        
                [self.messages addObject:message];
        
        if([message.customParameters[@"isFileUploading"] length]>0)
        {
            //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
            
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isFileUploading"],@"blobName", nil];
            [imagesUploading_indexes addObject:personDict];
            
        }
    }
    
    else if(mediaAttachButton.tag==3)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
       NSObject<Cancelable> *obj= [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"audio/mpeg" isPublic:YES delegate:chatmanager];
        [uploadingObjects addObject:obj];
        
        [audioData addObject:tempMediaData];
        //displaying file sent message in the chat
        //QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"";
        [custom_Data setObject:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isAudioUploading"];
        
        [message setCustomParameters:custom_Data];
        [imagesData addObject:[[NSData alloc] init]];
        
        
        [self.messages addObject:message];
        
        if([message.customParameters[@"isAudioUploading"] length]>0)
        {
            //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
            
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isAudioUploading"],@"blobName", nil];
            [audioUploading_indexes addObject:personDict];
        }

    }
    
    else if(mediaAttachButton.tag==4)
    {
        [imagesData addObject:tempMediaData];
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
       NSObject<Cancelable> *obj= [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:chatmanager];
        [uploadingObjects addObject:obj];
        
        
        
        //displaying file sent message in the chat
        //QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"Sending File...";
        
        [custom_Data setObject:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"fileName"];
        [custom_Data setObject:[NSString stringWithFormat:@"%@",tempVideoUrl] forKey:@"videoURL"];
        [custom_Data setObject:[NSNumber numberWithInt: 1] forKey:@"isVideoUploading"];
        
        [message setCustomParameters:custom_Data];
        
        
        [self.messages addObject:message];
        [audioData addObject:[[NSData alloc] init]];
        
        if([message.customParameters[@"isVideoUploading"] integerValue]==1)
        {
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"fileName"],@"blobName", message.customParameters[@"videoURL"], @"videoURL", @"-", @"imageURL", nil];
            [videoUploading_indexes addObject:personDict];
        }
    }
    
    else
    {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Chat Message"
                                                                                                                           action:@"Chat message sent"
                                                                                                                            label:@"Chat message sent"
                                                                                                                            value:nil] build]];
        
        [message setCustomParameters:custom_Data];
        
    // custom object work
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[prefs integerForKey:@"SenderId"],partner_QB_id,dateString];
    
    NSLog(@"%@",uniqueString);
 
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:uniqueString forKey:@"chatId"];
    
    message.ID = uniqueString;
    
    [object.fields setObject:@"1" forKey:@"type"];

    if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        Str = [Str stringByReplacingCharactersInRange:range withString:@""];
        
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    [object.fields setObject:@"" forKey:@"content"];
        
    [object.fields setObject:self.strRelationShipId forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    [QBCustomObjects createObject:object delegate:chatmanager];
        
    
        
    [self.messages addObject:message];
    
    NSLog(@"chat button %d",[self.messages count]);
    
 // NSLog(@"%@",self.messages);
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];
    //[imagesURL addObject:@"-"];
    //[videosData addObject:@"-"];
    
    NSLog(@"%d",self.messages.count);
    NSLog(@"%d",imagesData.count);
    
    NSLog(@"local chat added: %@",self.messages);
    
    //[[QBChat instance] sendMessage:message];
        
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
        
    [self SendMessage:message dict:Tempdict];
    //[[QBChat instance] setDelegate:self];
        
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.play_chatAnimation = true;
    appDelegate = nil;
    
    [self.tableView reloadData];
    
    
    
    custom_Data=nil;
    tempMediaData = nil;
    tempVideoUrl = nil;
    tempImageRatio = 1;
    mediaAttachButton.tag = 1;
    [mediaAttachButton setImage:[UIImage imageNamed:@"footer_attachment.png"] forState:UIControlStateNormal];
    [textView setText:nil];
//    [self.sendMessageField resignFirstResponder];
    
    
     CGRect rectTableView = self.tableView.frame;
    
    if (IS_IPHONE_5)
    {
        if (isKeyBoardVisible)
        {
            if (isKeyboardSuggestionEnabled)
            {
                 rectTableView.size.height = 152;
            }
            else
            {
                 rectTableView.size.height = 180;
            }
        }
    }
    else
    {
        if (isKeyBoardVisible)
        {
            if (isKeyboardSuggestionEnabled)
            {
                rectTableView.size.height = 62;
            }
            else
            {
                rectTableView.size.height = 90;
            }
        }
    }
   self.tableView.frame=rectTableView;
    
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
   [self performSelector:@selector(playoutgoingMsgSound) withObject:nil afterDelay:0.2];
}

-(void)playoutgoingMsgSound
{
    [outgoingMsgSound play];
}


-(NSDate *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    NSDate *newDate = [dateFormatter dateFromString:dateString];
    dateFormatter=nil;
    dateString = nil;
    return newDate;
}


-(void)CallrelationshipsWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/getrelationships"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        if([request responseStatusCode] == 200)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"])
            {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSArray *TempArray = [[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"relationships"]];
                [[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"];
                [prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"]] forKey:@"partner_QB_id"];
                [prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_pic"]] forKey:@"partner_pic"];
                [prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_name"]] forKey:@"partner_name"];
                
                if([jsonResponse objectForKey:@"user_pic"]!= [NSNull null])
                [prefs setObject:[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"user_pic"]] forKey:@"user_pic"];
                //[prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_pic"]] forKey:@"partner_pic"];
                
                PartnerNameLbl.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];

                if([NSNull null] == [[TempArray objectAtIndex:0] objectForKey:@"partner_name"] || [[TempArray objectAtIndex:0] objectForKey:@"partner_name"] == nil)
                {
                    PartnerNameLbl.text =@"";
                }
                else
                {
                    NSArray *substrings = [[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_name"]] componentsSeparatedByString:@" "];
                    if([substrings count] != 0)
                    {
                        NSString *first = [substrings objectAtIndex:0];
                        PartnerNameLbl.text = [first uppercaseString];
                    }
                }
                
                NSLog(@"user:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]);
                NSLog(@"part Pic %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"partner_pic"]);
                NSLog(@"id: %@",[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"]]);
                NSLog(@"userClicks: %@",[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"user_clicks"]]);
                NSLog(@"clicks: %@",[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"clicks"]]);

                if([[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"user_clicks"]] isEqual:[NSNull null]] || [[[TempArray objectAtIndex:0] objectForKey:@"user_clicks"] isKindOfClass:[NSNull class]] || [[TempArray objectAtIndex:0] objectForKey:@"user_clicks"] == nil)
                {
                    self.MyTotalClicks = @"0";
                }
                else
                {
                    self.MyTotalClicks = [NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"user_clicks"]];
                }
                
                if([[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"clicks"]] isEqual:[NSNull null]] || [[[TempArray objectAtIndex:0] objectForKey:@"clicks"] isKindOfClass:[NSNull class]] || [[TempArray objectAtIndex:0] objectForKey:@"clicks"] == nil)
                {
                    self.FriendTotalClicks = @"0";
                }
                else
                {
                    self.FriendTotalClicks = [NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"clicks"]];
                }
                
                addMyClicks = [FriendTotalClicks intValue];
                addMyFriendClicks = [MyTotalClicks intValue];

                NSLog(@"CallrelationshipsWebservice");
                if([NSNull null] == (NSNull *)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"] == nil)
                {
                
                }
                else
                {
                    [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]];
                }
                
                if([NSNull null] == (NSNull *)[[NSUserDefaults standardUserDefaults] objectForKey:@"partner_pic"] || [[NSUserDefaults standardUserDefaults] objectForKey:@"partner_pic"] == nil)
                {
                    
                }
                else
                {
                    [self.PartnerImgView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"partner_pic"]]];
                }
                
                [prefs setObject:[[[TempArray objectAtIndex:0] objectForKey:@"id"] objectForKey:@"$id"] forKey:@"relationShipId"];
                self.strRelationShipId = [[[TempArray objectAtIndex:0] objectForKey:@"id"] objectForKey:@"$id"];
                //[self CallGetChatHistoryWebservice:[[[TempArray objectAtIndex:0] objectForKey:@"id"] objectForKey:@"$id"]];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"])
            {
               [activity hide];

//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"No relationships found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"No relationships found."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        else if([request responseStatusCode] == 401)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Some error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Some error occured."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;

            
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
   // [activity hide];
}

-(void)loadearlierButtonAction
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    isFromEariler = TRUE;
    
    [self performSelector:@selector(fetchEarlierRecordsFromHistory) withObject:nil afterDelay:0.1];
}

-(void)fetchEarlierRecordsFromHistory
{
    
    [chatmanager.messages removeAllObjects];
    [chatmanager.messages addObjectsFromArray:messages];
    
    self.strChatIdOfFirstRecord = ((QBChatMessage*)[messages objectAtIndex:0]).ID;
    [chatmanager getChatHistory:self.strRelationShipId lastChatID:self.strChatIdOfFirstRecord];
}

-(void)CallGetChatHistoryWebservice//:(NSString *)relationShipId
{
    [chatmanager getChatHistory:self.strRelationShipId lastChatID:@""];
    /*
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/chats/fetchchatrecords"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        NSLog(@"%@",relationShipId);
        NSLog(@"%@",[prefs stringForKey:@"phoneNumber"]);
        if([self.messages count] == 0)
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationShipId,@"relationship_id",nil];
        }
        else
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationShipId,@"relationship_id",self.strChatIdOfFirstRecord,@"last_chat_id",nil];
        }

        NSLog(@"%@",Dictionary);
        
        [prefs setObject:relationShipId forKey:@"relationShipId"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        if([request responseStatusCode] == 200)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Chat history fetched"])
            {
                if(appDelegate.isFlowFromNotification == true)
                {
                      [self.messages removeAllObjects];
                }
                
                NSMutableArray *TempArrayChatHistory = [[NSMutableArray alloc] init];
                NSMutableArray *TempImageDataHistory = [[NSMutableArray alloc] init];
                NSMutableArray *TempCardStatusHistory = [[NSMutableArray alloc] init];
                //NSMutableArray *TempVideoDataHistory = [[NSMutableArray alloc] init];
                for (int i = 0; i < [[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] count]; i++)
                {
                    QBChatMessage *message = [[QBChatMessage alloc] init];
                    
                    NSString *MessageText = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"message"];
                    
                    if(MessageText == (NSString*)[NSNull null])
                    {
                        MessageText = @"";
                    }
                    
                    NSString *MessageClicks = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"clicks"];
                    
                    NSString *SentOn = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"sentOn"];

                    NSString *SenderId = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"QB_id"];
                    
                    NSString *chatId = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"chatId"];
                    
                    NSLog(@"iiiffff %@",MessageText);
                  
                    rightTopHeaderClicks.text = MyTotalClicks;
                    leftTopHeaderClicks.text = FriendTotalClicks;
                    
                    switch ([rightTopHeaderClicks.text length])
                    {
                        case 1:
                            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
                            {
                                LeftSmallClickImageView.frame = CGRectMake(69-10, 60,14, 15);
                            }
                            else
                            {
                                LeftSmallClickImageView.frame = CGRectMake(69-15, 60,14, 15);
                            }
                            
                            rightTopHeaderClicks.frame = CGRectMake(48, 51,16, 32);
                            break;
                            
                        case 2:
                            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
                            {
                                LeftSmallClickImageView.frame = CGRectMake(79-10, 60,14, 15);
                            }
                            else
                            {
                                LeftSmallClickImageView.frame = CGRectMake(79-15, 60,14, 15);
                            }
                            rightTopHeaderClicks.frame = CGRectMake(48, 51,25, 32);
                            break;
                            
                        case 3:
                            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
                            {
                                LeftSmallClickImageView.frame = CGRectMake(89-10, 60,14, 15);
                            }
                            else
                            {
                                LeftSmallClickImageView.frame = CGRectMake(89-15, 60,14, 15);
                            }
                            rightTopHeaderClicks.frame = CGRectMake(48, 51,38, 32);
                            break;
                            
                        case 4:
                            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
                            {
                                LeftSmallClickImageView.frame = CGRectMake(99-10, 60,14, 15);
                            }
                            else
                            {
                                LeftSmallClickImageView.frame = CGRectMake(99-15, 60,14, 15);
                            }
                            rightTopHeaderClicks.frame = CGRectMake(48, 51,44, 32);
                            break;
                            
                        default:
                            break;
                    }
                
                    message.ID = chatId;
                    
                    if(![MessageClicks isEqual:[NSNull null]])
                    {
                        if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
                        {
                            message.text = MessageText;
                        
                            message.senderID = [SenderId longLongValue];
                            NSLog(@"senderID: %lld",[SenderId longLongValue]);
                            [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                        }
                        else
                        {
                            message.senderID = [SenderId longLongValue];
                            NSLog(@"senderID: %lld",[SenderId longLongValue]);

                            [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
                            message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
                           
                        }
                    }
                    else
                    {
                        message.senderID = [SenderId longLongValue];
                        NSLog(@"senderID: %lld",[SenderId longLongValue]);

                        message.text = MessageText;
                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                    }
                    
                    
                    
                    //check for image data
                    NSString *contentURL = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"content"];
                    
                    NSNumber *type = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"type"];
                    
                    NSString *imageRatio = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"imageRatio"];
                    
                    if([type intValue]==2 && contentURL.length>0)
                    {
                        //[imagesData addObject:[[NSData alloc] init]];
                        //[imagesURL addObject:contentURL];
                        
                       
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
                        //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }
                    
                    //location data
                    if([type intValue]==6 && contentURL.length>0)
                    {
                        NSString *locationCoordinates = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"location_coordinates"];
                        if([locationCoordinates isEqual:[NSNull null]])
                            locationCoordinates = @"";
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
                        //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
                        
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }

                    
                    [TempImageDataHistory addObject:[[NSData alloc] init]];
                    //end of image data check
                    
                    
                    
                    
                    NSTimeInterval seconds = [SentOn doubleValue];
                    
                    NSDate* ts_utc = [NSDate  dateWithTimeIntervalSince1970:seconds];
                    
                    
                    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
                    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
                    [df_local setDateFormat:@"hh:mm a"];
                    
                    
                    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
                    
                    message.datetime = [df_local dateFromString:ts_local_string];
                    
                    df_local = nil;

                    
                    
                    //fetching video data
                    if([type intValue]==4 && contentURL.length>0)
                    {
                        NSString * video_thumbnail = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"video_thumb"];
                        
                        if(video_thumbnail == (NSString*)[NSNull null])
                            video_thumbnail = @"";
                        
                        
                        
                        
                        
                        NSMutableDictionary *video_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"videoID", video_thumbnail ,@"videoThumbnail",
                                                           nil];

                        
                        [message setCustomParameters:video_Data];
                        
                        video_Data = nil;
                        video_thumbnail = nil;
                    }
                    
                    
                    if([type intValue]==3 && contentURL.length>0)
                    {
                        
                        //[imagesData addObject:[[NSData alloc] init]];
                        //[imagesURL addObject:contentURL];
                        
                       NSMutableDictionary *audio_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"audioID",
                                                           nil];
                        
                        [message setCustomParameters:audio_Data];
                        audio_Data = nil;
                        //[message setCustomParameters:[@{@"audioID": contentURL} mutableCopy]];
                        
                    }

                    

                   
                    
                    //adding videoData
                    //[TempVideoDataHistory addObject:@"-"];
                    
                    //fetching cards data
                    if([type intValue]==5)
                    {
                        message.text=@"";
                        
                        NSArray *cards_array = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"cards"];
                        
                        NSString *card_actionText;
                        
                        NSLog(@"%@",[cards_array objectAtIndex:5]);
                        
                        
                        if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
                        {
                            card_actionText = @"ACCEPTED!";
                            [card_status_webHistory addObject:[cards_array objectAtIndex:0]];
                        }
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
                        {
                            card_actionText = @"REJECTED!";
                            [card_status_webHistory addObject:[cards_array objectAtIndex:0]];
                        }
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
                            card_actionText = @"COUNTERED CARD";
                        else
                            card_actionText = @"PLAYED A CARD";
                        
                        NSString *card_owner;
                        if([[cards_array objectAtIndex:6] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]])
                        {
                            card_owner =[NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]];
                        }
                        else{
                            card_owner = @"";
                        }
                        
                        NSString *card_clicks;
                        if([[cards_array objectAtIndex:4] length]==1)
                            card_clicks = [NSString stringWithFormat:@"0%@",[cards_array objectAtIndex:4]];
                        else
                            card_clicks = [cards_array objectAtIndex:4];
                        
                        if(cards_array.count>5)
                        {
                            
                            NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:card_clicks,@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", [cards_array objectAtIndex:7] , @"is_CustomCard",
                                [cards_array objectAtIndex:6],@"card_originator",
                                [cards_array objectAtIndex:8],@"card_DB_ID",card_owner,@"card_owner",nil];
                            
                            [message setCustomParameters:cards_data];
                        }
                        
                        NSDictionary *cardDict;
                        if(cards_array.count>9)
                        {
                            if([[cards_array objectAtIndex:9] isEqualToString:@"playing"])
                                cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"0",@"status", nil];
                            else
                                cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"1",@"status", nil];
                        }
                        else
                        {
                            cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"1",@"status", nil];
                        }
                        
                        [TempCardStatusHistory addObject:cardDict];
                        
                        cardDict = nil;
                        cards_array=nil;
                        card_actionText=nil;
                        card_owner = nil;
                        card_clicks = nil;
                    }
                    
                    
                   [TempArrayChatHistory addObject:message];
                    
                    
                   if([TempArrayChatHistory count] == 1)
                   {
                      self.strChatIdOfFirstRecord = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"chatId"];
                   }
                    message = nil;
                }
                
                if(TempArrayChatHistory.count < 20)
                {
                    isChatHistoryOrNot = FALSE;
                }
                else
                {
                    isChatHistoryOrNot = TRUE;
                }
                NSArray *ArrTemp = [NSArray arrayWithArray:self.messages];
                NSLog(@"%d",[self.messages count]);
                [self.messages removeAllObjects];
                [self.messages addObjectsFromArray:TempArrayChatHistory];
                [self.messages addObjectsFromArray:ArrTemp];
                
                
//                NSLog(@"%@",self.messages);
                //adjust the media uploading indexes
                for(int i=0 ;i<videoUploading_indexes.count ; i++)
                {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary *oldDict = (NSMutableDictionary *)[videoUploading_indexes objectAtIndex:i];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setObject:[NSString stringWithFormat:@"%i", TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
                    [videoUploading_indexes replaceObjectAtIndex:i withObject:newDict];
                    newDict = nil;
                    oldDict = nil;

                }
                
                for(int i=0 ;i<imagesUploading_indexes.count ; i++)
                {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary *oldDict = (NSMutableDictionary *)[imagesUploading_indexes objectAtIndex:i];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setObject:[NSString stringWithFormat:@"%i", TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
                    [imagesUploading_indexes replaceObjectAtIndex:i withObject:newDict];
                    newDict = nil;
                    oldDict = nil;
                    
                }
                
                for(int i=0 ;i<audioUploading_indexes.count ; i++)
                {
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary *oldDict = (NSMutableDictionary *)[audioUploading_indexes objectAtIndex:i];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setObject:[NSString stringWithFormat:@"%i", TempArrayChatHistory.count + [[oldDict objectForKey:@"index"] integerValue]] forKey:@"index"];
                    [audioUploading_indexes replaceObjectAtIndex:i withObject:newDict];
                    newDict = nil;
                    oldDict = nil;
                    
                }


                
                
                // fill imagedata correctly
                NSArray *ImageDataTemp = [NSArray arrayWithArray:imagesData];
                [imagesData removeAllObjects];
                [imagesData addObjectsFromArray:TempImageDataHistory];
                [imagesData addObjectsFromArray:ImageDataTemp];
                ImageDataTemp = nil;
                
                //fill audio data correctly
                NSArray *AudioDataTemp = [NSArray arrayWithArray:audioData];
                [audioData removeAllObjects];
                [audioData addObjectsFromArray:TempImageDataHistory];
                [audioData addObjectsFromArray:AudioDataTemp];
                AudioDataTemp = nil;
                
                
                
                for(int i=0 ;i<card_accept_status.count ; i++)
                {
                    
                    NSDictionary *oldDict = (NSDictionary *)[card_accept_status objectAtIndex:i];
                     NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i", TempArrayChatHistory.count + [[oldDict valueForKey:@"index"] integerValue]],@"index",[oldDict valueForKey:@"status"],@"status", nil];;
                    
                    
                    [card_accept_status replaceObjectAtIndex:i withObject:newDict];
                    oldDict = nil;
                    newDict = nil;
                }
                
                
                //fill card status array correctly
                NSArray *CardStatusTemp = [NSArray arrayWithArray:card_accept_status];
                [card_accept_status removeAllObjects];
                [card_accept_status addObjectsFromArray:TempCardStatusHistory];
                [card_accept_status addObjectsFromArray:CardStatusTemp];
                CardStatusTemp = nil;
                
                [card_status_webHistory removeAllObjects];
                // fill videodata correctly
                //NSArray *VideoDataTemp = [NSArray arrayWithArray:videosData];
                //[videosData removeAllObjects];
                //[videosData addObjectsFromArray:TempVideoDataHistory];
                //[videosData addObjectsFromArray:VideoDataTemp];
                //VideoDataTemp = nil;
                
                
                NSLog(@"%d",self.messages.count);
                NSLog(@"%d",imagesData.count);
                
                [self.tableView reloadData];
                if(TempArrayChatHistory.count < 20)
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count]-1   inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                else
                {
                    NSLog(@"%d",[messages count]);
                    NSLog(@"%d",[TempArrayChatHistory count]);
                    NSLog(@"%d",[ArrTemp count]);

                    if(isFromEariler == FALSE)
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    else
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
                TempArrayChatHistory = nil;
                TempImageDataHistory = nil;
          }
        }
        else if([request responseStatusCode] == 401)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Some error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    [activity hide];
    appDelegate.isFlowFromNotification = false;
    */
}

// share btn press
-(void)shareBtnPress:(UIButton*)sender
{
    ChatMessageTableViewCell *cell;
    if (IS_IOS_7)
    {
       cell  = (ChatMessageTableViewCell*)[[[[sender superview] superview] superview] superview];
    }
    else
    {
        cell  = (ChatMessageTableViewCell*)[[[sender superview] superview] superview];
    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    NSLog(@"%d",messages.count);
    QBChatMessage *message;

    if(isChatHistoryOrNot == FALSE)
    {
        message= [messages objectAtIndex:indexPath.row];
    }
    else
    {
        message= [messages objectAtIndex:indexPath.row-1];
    }
    
    ShareViewController* SharingController = [[ShareViewController alloc] init];
    SharingController.delegate = self;
    SharingController.message = message;
    if(isChatHistoryOrNot == FALSE)
    {
        SharingController.ImageData = [imagesData objectAtIndex:indexPath.row];
    }
    else
    {
        SharingController.ImageData = [imagesData objectAtIndex:indexPath.row-1];
    }
   [self.navigationController pushViewController:SharingController animated:YES];
   //SharingController =nil;
/*    if(shareScrollView.alpha==1)
    {
        [UIView animateWithDuration:0.4 animations:^() {
            shareScrollView.alpha = 0;
        }];
        
        [(UIButton*)[shareScrollView viewWithTag:111111] setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:222222] setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:333333] setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:444444] setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
        [(UIButton*)[shareScrollView viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        //[(UIButton*)[shareScrollView.superview viewWithTag:555555] setEnabled:false];
    }
    else
    {
        ChatMessageTableViewCell *cell = (ChatMessageTableViewCell*)[[[sender superview] superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        CGRect rect = [self.tableView convertRect:cell.frame toView:self.view];
    
        shareScrollView.frame = CGRectMake(15, rect.origin.y
                                           +rect.size.height-50, 290, 50);
        
        if(isChatHistoryOrNot)
            shareScrollView.tag = indexPath.row-1;
        else
            shareScrollView.tag = indexPath.row;
        
        
            [UIView animateWithDuration:0.5 animations:^() {
                shareScrollView.alpha = 1;
            }];
    }
 */
}


-(void)callShareWebservice:(QBChatMessage*)message
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/chats/share"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        NSLog(@"%@",[prefs stringForKey:@"phoneNumber"]);
        
        NSString *sharing_media = message.customParameters[@"sharingMedia"];
        
        NSString *strText;
        if([message.customParameters[@"comment"] isEqualToString:@"Write your caption here..."])
        {
            strText = @"";
        }
        else
        {
            strText = message.customParameters[@"comment"];
        }
        
        if([prefs stringForKey:@"fb_accesstoken"] == nil)
            [prefs setObject:@"" forKey:@"fb_accesstoken"];
        
        NSString *facebookAcessToken = message.customParameters[@"facebookToken"];
        if(facebookAcessToken.length<=1)
            facebookAcessToken = @"";
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", message.customParameters[@"originalMessageID"] ,@"chat_id" , [prefs stringForKey:@"relationShipId"] ,@"relationship_id",
                      sharing_media, @"media", facebookAcessToken, @"fb_access_token", @"", @"twitter_access_token", @"" , @"googleplus_access_token" ,strText,@"comment", message.customParameters[@"isAccepted"], @"accepted", nil];
        
        NSLog(@"%@",Dictionary);
        sharing_media = nil;
        facebookAcessToken = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:nil];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        if([request responseStatusCode] == 200)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Newsfeed has been saved."])
            {
                /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Shared successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 alert = nil;*/
                
                
            }
        }
        
        else if([request responseStatusCode] == 401)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Some error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Some error occured."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    else
    {
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    [activity hide];
    
}

- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==4774)// send clickIn request
    {
        if(buttonType==0)
        {
            [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            
            if(![partner_pic isEqual: [NSNull null]])
                [self.PartnerImgView sd_setImageWithURL:[NSURL URLWithString:partner_pic] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"resignKeyboardLeftMenu"
             object:nil];
            [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
                
            }];

        }
    }
}

#pragma mark - UIBarButtonItem Callbacks
- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    if (imagesUploading_indexes.count>0||videoUploading_indexes.count>0||audioUploading_indexes.count>0)
    {
//        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Media is uploading."
//                                                                        description:@"Do you want to cancel and continue?"
//                                                                      okButtonTitle:@"Yes"
//                                                                  cancelButtonTitle:@"No"];
//        alertView.delegate = self;
//        alertView.tag = 4774;
//        [alertView show];
//        alertView = nil;
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"All media upload will be cancelled. Do you want to proceed?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag=MediaAlertTag;
        [alert show];
        alert=Nil;
        
    }
    else
    {
        
        [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        
        if(![partner_pic isEqual: [NSNull null]])
            [self.PartnerImgView sd_setImageWithURL:[NSURL URLWithString:partner_pic] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"resignKeyboardLeftMenu"
         object:nil];
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
    
}

- (IBAction)rightSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{

    }];
}

//media button pressed
-(IBAction)mediaButton:(id)sender
{
    
    //[self AlertForSeLectionTheImageCapturing];
    if(mediaScrollview.alpha==0)
    {
        [self performSelector:@selector(playAttachmentSound) withObject:nil afterDelay:0.1];
        [UIView animateWithDuration:0.2 animations:^() {
            mediaScrollview.alpha = 1;
            [self.view bringSubviewToFront:attachmentAnimationView];
        }];
        
        attachmentAnimationView.frame = CGRectMake(15, attachmentAnimationView.frame.origin.y, attachmentAnimationView.frame.size.width, attachmentAnimationView.frame.size.height);
        
        //[self.view bringSubviewToFront:attachmentAnimationView];
        attachmentAnimationView.duration = 0.3;
        attachmentAnimationView.delay    = 0.0;
        attachmentAnimationView.type     = CSAnimationTypeSlideRight;
        [attachmentAnimationView startCanvasAnimation];
    }
    else
    {
        [UIView animateWithDuration:0.75 animations:^() {
            mediaScrollview.alpha = 0;
            
        }];
        
        attachmentAnimationView.frame = CGRectMake(-275, attachmentAnimationView.frame.origin.y, attachmentAnimationView.frame.size.width, attachmentAnimationView.frame.size.height);
        
        //[self.view bringSubviewToFront:attachmentAnimationView];
        attachmentAnimationView.duration = 0.3;
        attachmentAnimationView.delay    = 0.0;
        attachmentAnimationView.type     = CSAnimationTypeSlideLeft;
        [attachmentAnimationView startCanvasAnimation];
        
        [self performSelector:@selector(sendAttachmentViewToBack) withObject:nil afterDelay:0.3];

    }
}

-(void)sendAttachmentViewToBack
{
    [self.view sendSubviewToBack:attachmentAnimationView];
}

-(void)playAttachmentSound
{
    [attachmentSound play];
}

-(IBAction)cardsButton:(id)sender
{
    //[self AlertForSeLectionTheImageCapturing];
    if(CardsScrollview.alpha==0)
    {
        [UIView animateWithDuration:0.5 animations:^() {
            CardsScrollview.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^() {
            CardsScrollview.alpha = 0;
        }];
        
    }
}


-(void)AlertForSeLectionTheImageCapturing
{
    [self hideRecordingView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"TAKE A PICTURE",@"FROM YOUR GALLERY",nil];
    [alert show];
    alert.tag=4; // for image selection
    alert = nil;
}

-(void)AlertForSeLectionTheVideoCapturing
{
     [self hideRecordingView];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"CAPTURE A VIDEO",@"FROM YOUR GALLERY",nil];
    [alert show];
    alert.tag=5;  //for video selection
    alert = nil;
}

-(void)AlertForSeLectionTheAudioCapturing
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"CAPTURE A AUDIO",@"FROM YOUR GALLERY",nil];
    [alert show];
    alert.tag=6;  //for video selection
    alert = nil;
}

#pragma mark UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==4)  // for image selection
    {
    if (buttonIndex == 1)
    {
        //[self CaptureFromCamara];
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == 2)
    {
        //[self CaptureFromGallery];
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    }
    
    if(alertView.tag==5)  // for video selection
    {
        if (buttonIndex == 1)
        {
            //[self CaptureFromCamara];
            [self showVideoPicker:UIImagePickerControllerSourceTypeCamera];
            
            // pause the music
            if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
            {
                isMusicPlaying = true;
                [[MPMusicPlayerController iPodMusicPlayer] pause];
            }
            else
                isMusicPlaying = false;
            
            
        }
        else if (buttonIndex == 2)
        {
            //[self CaptureFromGallery];
            [self showVideoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
    
    if(alertView.tag==MediaAlertTag)
    {
        if(buttonIndex==1)
        {
            [self.UserImgView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            
            if(![partner_pic isEqual: [NSNull null]])
                [self.PartnerImgView sd_setImageWithURL:[NSURL URLWithString:partner_pic] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"resignKeyboardLeftMenu"
             object:nil];
            [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
                
            }];
        }

    }
    
    /*if(alertView.tag==6)  // for audio selection
    {
        if(buttonIndex ==1)
        {
            if(audio_picker==nil)
                audio_picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
            
            audio_picker.delegate                    = self;
            audio_picker.allowsPickingMultipleItems  = NO;
            audio_picker.prompt                      = NSLocalizedString(@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
            
     
            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
            
            [self presentViewController:audio_picker animated:YES completion:nil];
        }
        else if(buttonIndex == 2)
        {
            if(audio_picker==nil)
                audio_picker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
            
            audio_picker.delegate                    = self;
            audio_picker.allowsPickingMultipleItems  = NO;
            audio_picker.prompt                      = NSLocalizedString(@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
            
            
            
            [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
            
            [self presentViewController:audio_picker animated:YES completion:nil];
        }
    }*/
}

/*
//audio file picked
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    //play your file here
    MPMediaItem *mediaItem = [mediaItemCollection.items objectAtIndex:0];
    NSLog(@"%@=========>",[mediaItem valueForProperty:MPMediaItemPropertyAssetURL]);
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] error:nil];
    NSData *mydata = [audioPlayer data];
    
    
}

// audio picking cancelled
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

-(void)showImagePicker:(UIImagePickerControllerSourceType) sourceType
{
    @try
    {
        if(_imgPicker==nil)
            _imgPicker = [[UIImagePickerController alloc] init];
        
        _imgPicker.sourceType = sourceType;
        _imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        _imgPicker.delegate = self;
        if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            _imgPicker.showsCameraControls = YES;
            _imgPicker.allowsEditing=NO;
        }
        else
        {
            [_imgPicker setAllowsEditing:NO];
        }
        
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType])
        {
            [self presentViewController:_imgPicker animated:YES completion:nil];
        }
    }
    
    @catch (NSException *exception)
    {
        
    }
}
-(void)showVideoPicker:(UIImagePickerControllerSourceType) sourceType
{
    @try {
        if(_imgPicker==nil)
            _imgPicker = [[UIImagePickerController alloc] init];
        
        _imgPicker.sourceType = sourceType;
        _imgPicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        
        [_imgPicker setAllowsEditing:NO];
        
        _imgPicker.delegate = self;
        _imgPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        
        isVideoPickedFromLibrary = true;
        if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            _imgPicker.showsCameraControls = YES;
            isVideoPickedFromLibrary = false;
        }
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [self presentViewController:_imgPicker animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
    }
}

//resizing images picked to 320*480 resolution
-(UIImage *)reSizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"w: %f -- h : %f",image.size.width,image.size.height);
    NSLog(@"w: %f -- h : %f",img.size.width,img.size.height);
    return img;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ContentButton.hidden = YES;
    sendMessageButton.hidden = NO;
    CheckIfAttachBtnContainMedia = true;
   // isChatHistoryOrNot = FALSE;
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];

    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo)
    {
        // video + audio file
        __block NSURL *videoUrl;
        //NSString *moviePath = (NSString*)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        videoUrl= [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSString *videoPath1;
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
        {
            NSString *moviePath = (NSString*)[[info objectForKey:UIImagePickerControllerMediaURL] path];
            
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath))
            {
                NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                videoPath1 =[NSString stringWithFormat:@"%@/videoClick.mov",docDir];
                NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
                NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
                [videoData writeToFile:videoPath1 atomically:NO];
                //  UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, nil, nil);
            }
        }
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath1] options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
        {
            
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            videoPath1 = [NSString stringWithFormat:@"%@/videoClick.mp4", [paths objectAtIndex:0]];
            
            //check if file exists if yes then delete the file
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:videoPath1];
            if (fileExists) {
                [[NSFileManager defaultManager] removeItemAtPath:videoPath1 error:NULL];
            }
            
            exportSession.outputURL = [NSURL fileURLWithPath:videoPath1];
            NSLog(@"videopath of your mp4 file = %@",videoPath1);  // PATH OF YOUR .mp4 FILE
            exportSession.outputFileType = AVFileTypeMPEG4;
            
            //  CMTime start = CMTimeMakeWithSeconds(1.0, 600);
            //  CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
            //  CMTimeRange range = CMTimeRangeMake(start, duration);
            //   exportSession.timeRange = range;
            //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
            
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                
                switch ([exportSession status]) {
                        
                    case AVAssetExportSessionStatusFailed:
                        NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                        break;
                        
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Export canceled");
                        break;
                        
                    case AVAssetExportSessionStatusCompleted:
                    {
                        
                        
                        NSLog(@"URL is  %@", videoUrl.absoluteString);
                        NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
                        if(([videoData length]/1048576.0f)>25)
                        {
                            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Video size is too big. Maximum limit allowed is 25 MB." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            //            [alert show];
                            //            alert = nil;
                            
                            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Sorry!"
                                                                                            description:@"Video size is too big. Maximum limit allowed is 25 MB."
                                                                                          okButtonTitle:@"OK"];
                            alertView.delegate = nil;
                            [alertView show];
                            alertView = nil;
                            
                            
                        }
                        else
                        {
                            //            viewAttachment=[[PreviewAttachment_View alloc] initWithFrame:self.view.frame];
                            //            viewAttachment.isAttachmentImage=NO;
                            //            viewAttachment.videoURL=videoUrl;
                            //            viewAttachment.attachmentDelegate=self;
                            //            [_imgPicker.view addSubview:viewAttachment];
                            
                            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
                            UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
                            [player stop];
                            player=Nil;
                            
                            thumbnail = [self scaleImage:thumbnail toSize:CGSizeMake(175, 175)];
                            
                            
                            NSData *imageData = UIImageJPEGRepresentation(thumbnail, 0.4);
                            
                            videoUrl=[NSURL URLWithString:videoPath1];
                            
                            tempMediaData  = imageData ;
                            tempVideoUrl = videoUrl;
                            
                            
                            [mediaAttachButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
                            mediaAttachButton.tag = 4; //tag 4 for video
                            
                            
                            /*[imagesData addObject:imageData];
                             
                             NSDate *currDate = [NSDate date];
                             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                             [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                             NSString *dateString = [dateFormatter stringFromDate:currDate];
                             NSLog(@"dateString: %@",dateString);
                             
                             [QBContent TUploadFile:imageData fileName:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:self];
                             
                             [QBContent TUploadFile:imageData fileName:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString] contentType:@"image/jpeg" isPublic:YES delegate:self];
                             
                             
                             //displaying file sent message in the chat
                             QBChatMessage *message = [QBChatMessage message];
                             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                             
                             NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
                             message.recipientID = [StrPartner_id intValue];
                             message.text=@"Sending File...";
                             
                             NSMutableDictionary *video_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString], @"fileName",[NSString stringWithFormat:@"%@",videoUrl],@"videoURL",[NSNumber numberWithInt: 1],@"isVideoUploading",nil];
                             
                             [message setCustomParameters:video_Data];
                             [[QBChat instance] sendMessage:message];*/
                            
                            //videoData=nil;
                            //videoUrl=nil;
                            
                        }
                        
                        videoData = nil;
                        [self dismissViewControllerAnimated:YES completion:^{
                            if(isMusicPlaying)
                            {
                                [[MPMusicPlayerController iPodMusicPlayer] play];
                                //[session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
                            }
                            
                            // Initialize audio session
                            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                            
                            // Active your audio session
                            [audioSession setActive: NO error: nil];
                            
                            // Set audio session category
                            [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
                            
                            // Modifying Playback Mixing Behavior, allow playing music in other apps
                            OSStatus propertySetError = 0;
                            UInt32 allowMixing = true;
                            
                            propertySetError = AudioSessionSetProperty (
                                                                        kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                                        sizeof (allowMixing),
                                                                        &allowMixing);
                            
                            // Active your audio session
                            [audioSession setActive: YES error: nil];
                        }];
                        
                        
                        
                    }
                        break;
                        
                    default:
                        
                        break;
                        
                }
                
                //UISaveVideoAtPathToSavedPhotosAlbum(videoPath1, self, nil, nil);
                
                
                
            }];
            
        }
    }
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        
        // image file
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if(image==nil)
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //NSLog(@"w: %f -- h : %f",image.size.width,image.size.height);
        /*if(image.size.width<1000 || image.size.height<1000)
            image = [self scaleImage:image toSize:CGSizeMake(image.size.width/2, image.size.height/2)];
        else if(image.size.width<1500 || image.size.height<1500)
            image = [self scaleImage:image toSize:CGSizeMake(image.size.width/3, image.size.height/3)];
        else
            image = [self scaleImage:image toSize:CGSizeMake(image.size.width/4, image.size.height/4)];*/
        
        imgAttachment = [self reSizeImage:image];
        
        viewAttachment=[[PreviewAttachment_View alloc] initWithFrame:self.view.frame];
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera )
        {
            viewAttachment.isFromCamera=YES;
        }
        else
        {
            viewAttachment.isFromCamera=NO;
        }
        viewAttachment.attachmentDelegate=self;
        viewAttachment.isAttachmentImage=YES;
        
        viewAttachment.imgAttachment=imgAttachment;
        [UIView transitionWithView:containerView
                          duration:0.5
                           options:UIViewAnimationTransitionFlipFromLeft //any animation
                        animations:^ { [_imgPicker.view addSubview:viewAttachment]; }
                        completion:nil];
        
        
//        tempImageRatio = image.size.width/image.size.height;
        /*
        tempImageRatio = 1;
        
        //NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        //NSString *imageName = [imagePath lastPathComponent];
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
        // Upload selected file
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.5f;
        int maxFileSize = 2*1024;
        
        NSData *imageData = UIImageJPEGRepresentation(image, compression);
        
        while ([imageData length] > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(image, compression);
        }
        
        
        NSLog(@"Size of Image(bytes):%d",[imageData length]);
        
        if(([imageData length]/1000000.0f)>25)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry!" message:@"Image size is too big. Maximum limit allowed is 25 MB." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Sorry!"
                                                                            description:@"Image size is too big. Maximum limit allowed is 25 MB."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
        else
        {
            tempMediaData  = imageData ;
            [mediaAttachButton setImage:[UIImage imageWithData:tempMediaData] forState:UIControlStateNormal];
            mediaAttachButton.tag = 2; //tag 2 for image
        }
        
        
        */
        //NSData *imageData = UIImageJPEGRepresentation(image, 0.75f);
        
//        if(imageData==nil)
//        {
//            imageData = UIImagePNGRepresentation(image);
//            
//            /* QBCBlob *myBlob = [[QBCBlob alloc] init];
//             myBlob.name = @"MyImage";
//             myBlob.contentType = @"image/png";
//             myBlob.isPublic = YES;
//             QBCBlobObjectAccess *access = [[QBCBlobObjectAccess alloc] init];
//             access.type = QBCBlobObjectAccessTypeWrite;
//             NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//             NSDateComponents *DaysOffset = [[NSDateComponents alloc] init];
//             DaysOffset.day = 1000;
//             NSDate *expiryDate = [calendar dateByAddingComponents:DaysOffset toDate:[NSDate date] options:0];
//             NSLog(@"expiry Date ... %@",expiryDate);
//             access.expires = expiryDate;
//             //access.url = [NSURL URLWithString:@"http://qbprod.s3.amazonaws.com/"];
//             myBlob.blobObjectAccess = access;
//             
//             NSDate *currDate = [NSDate date];
//             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//             [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
//             NSString *dateString = [dateFormatter stringFromDate:currDate];
//             NSLog(@"dateString: %@",dateString);
//             
//             myBlob.UID = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString];
//             
//             
//             [QBContent createBlob:myBlob delegate:self];
//             
//             
//             [QBContent uploadFile:imageData blobWithWriteAccess:myBlob delegate:self];*/
//            
//            
//            
//            
//            [QBContent TUploadFile:imageData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString] contentType:@"image/png" isPublic:YES delegate:self];
//            
//        }
//        else
//        {
//            /*QBCBlob *myBlob = [QBCBlob blob];
//             myBlob.name = @"MyImage";
//             myBlob.contentType = @"image/jpeg";
//             myBlob.isPublic = YES;
//             QBCBlobObjectAccess *access = [[QBCBlobObjectAccess alloc] init];
//             access.type = QBCBlobObjectAccessTypeWrite;
//             NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//             NSDateComponents *DaysOffset = [[NSDateComponents alloc] init];
//             DaysOffset.day = 1000;
//             NSDate *expiryDate = [calendar dateByAddingComponents:DaysOffset toDate:[NSDate date] options:0];
//             NSLog(@"expiry Date ... %@",expiryDate);
//             access.expires = expiryDate;
//             //access.url = [NSURL URLWithString:@"http://qbprod.s3.amazonaws.com/"];
//             myBlob.blobObjectAccess = access;
//             
//             [QBContent createBlob:myBlob delegate:self];
//             
//             
//             [QBContent uploadFile:imageData blobWithWriteAccess:myBlob delegate:self];*/
//            
//            [QBContent TUploadFile:imageData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString] contentType:@"image/jpeg" isPublic:YES delegate:self];
//
//        }
//        
//        //NSURL *imgUrl=[info objectForKey:@"UIImagePickerControllerReferenceURL"];
//        //[imagesURL addObject:imgUrl];
//        
//        
//        [imagesData addObject:imageData];
//        //displaying file sent message in the chat
//        QBChatMessage *message = [QBChatMessage message];
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        
//        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
//        message.recipientID = [StrPartner_id intValue];
//        message.text=@"";
//        //message.text=@"Sending File...";
//        [message setCustomParameters:[@{@"isFileUploading": [NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[[NSUserDefaults standardUserDefaults] stringForKey:@"partner_QB_id"],dateString]} mutableCopy]];
//        //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
//        [[QBChat instance] sendMessage:message];
//        
  
        
        image=nil;
      //  imageData=nil;
        //imgUrl=nil;
        //imageName=nil;
        //imagePath=nil;

    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    if(isMusicPlaying)
    {
        [[MPMusicPlayerController iPodMusicPlayer] play];
        //[session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
    }
    
   //
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if(isMusicPlaying)
        {
            [[MPMusicPlayerController iPodMusicPlayer] play];
            //[session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
        }
        
        // Initialize audio session
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        // Active your audio session
        [audioSession setActive: NO error: nil];
        
        // Set audio session category
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:nil];
        
        // Modifying Playback Mixing Behavior, allow playing music in other apps
        OSStatus propertySetError = 0;
        UInt32 allowMixing = true;
        
        propertySetError = AudioSessionSetProperty (
                                                    kAudioSessionProperty_OverrideCategoryMixWithOthers,
                                                    sizeof (allowMixing),
                                                    &allowMixing);
        
        // Active your audio session
        [audioSession setActive: YES error: nil];

    }];
}

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



//compress video
- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
{
    //setup video writer
    AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:inputURL options:nil];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    CGSize videoSize = videoTrack.naturalSize;
    
    NSDictionary *videoWriterCompressionSettings =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1250000], AVVideoAverageBitRateKey, nil];
    
    NSDictionary *videoWriterSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey, videoWriterCompressionSettings, AVVideoCompressionPropertiesKey, [NSNumber numberWithFloat:videoSize.width], AVVideoWidthKey, [NSNumber numberWithFloat:videoSize.height], AVVideoHeightKey, nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoWriterSettings];
    
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    videoWriterInput.transform = videoTrack.preferredTransform;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:nil];
    
    [videoWriter addInput:videoWriterInput];
    
    //setup video reader
    NSDictionary *videoReaderSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoReaderSettings];
    
    AVAssetReader *videoReader = [[AVAssetReader alloc] initWithAsset:videoAsset error:nil];
    
    [videoReader addOutput:videoReaderOutput];
    
    //setup audio writer
    AVAssetWriterInput* audioWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeAudio
                                            outputSettings:nil];
    
    audioWriterInput.expectsMediaDataInRealTime = NO;
    
    [videoWriter addInput:audioWriterInput];
    
    //setup audio reader
    AVAssetTrack* audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    AVAssetReaderOutput *audioReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
    
    AVAssetReader *audioReader = [AVAssetReader assetReaderWithAsset:videoAsset error:nil];
    
    [audioReader addOutput:audioReaderOutput];
    
    [videoWriter startWriting];
    
    //start writing from video reader
    [videoReader startReading];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue1", NULL);
    
    [videoWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:
     ^{
         
         while ([videoWriterInput isReadyForMoreMediaData]) {
             
             CMSampleBufferRef sampleBuffer;
             
             if ([videoReader status] == AVAssetReaderStatusReading &&
                 (sampleBuffer = [videoReaderOutput copyNextSampleBuffer])) {
                 
                 [videoWriterInput appendSampleBuffer:sampleBuffer];
                 CFRelease(sampleBuffer);
             }
             
             else {
                 
                 [videoWriterInput markAsFinished];
                 
                 if ([videoReader status] == AVAssetReaderStatusCompleted) {
                     
                     //start writing from audio reader
                     [audioReader startReading];
                     
                     [videoWriter startSessionAtSourceTime:kCMTimeZero];
                     
                     dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue2", NULL);
                     
                     [audioWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:^{
                         
                         while (audioWriterInput.readyForMoreMediaData) {
                             
                             CMSampleBufferRef sampleBuffer;
                             
                             if ([audioReader status] == AVAssetReaderStatusReading &&
                                 (sampleBuffer = [audioReaderOutput copyNextSampleBuffer])) {
                                 
                                 [audioWriterInput appendSampleBuffer:sampleBuffer];
                                 CFRelease(sampleBuffer);
                             }
                             
                             else {
                                 
                                 [audioWriterInput markAsFinished];
                                 
                                 if ([audioReader status] == AVAssetReaderStatusCompleted) {
                                     
                                     [videoWriter finishWritingWithCompletionHandler:^(){
                                         NSData *videoData = [NSData dataWithContentsOfURL:outputURL];
                                         
                                         NSLog(@"video data after compression.......%i",videoData.length);
                                         //[self sendMovieFileAtURL:outputURL];
                                     }];
                                     
                                 }
                             }
                         }
                         
                     }
                      ];
                 }
             }
         }
     }
     ];
}


//video compression
-(void)resizeVideo:(NSString*)pathy{
   
    NSString *newName = [pathy stringByAppendingString:@"output.mov"];
    NSURL *fullPath = [NSURL fileURLWithPath:newName];
    NSURL *path = [NSURL fileURLWithPath:pathy];
    
    
    
    NSError *error = nil;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:fullPath fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    AVAsset *avAsset = [[AVURLAsset alloc] initWithURL:path options:nil] ;
    
    
    
    NSDictionary *videoCleanApertureSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInt:480], AVVideoCleanApertureWidthKey,
                                                [NSNumber numberWithInt:640], AVVideoCleanApertureHeightKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureHorizontalOffsetKey,
                                                [NSNumber numberWithInt:10], AVVideoCleanApertureVerticalOffsetKey,
                                                nil];
    
    
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:1960000], AVVideoAverageBitRateKey,
                                   [NSNumber numberWithInt:24],AVVideoMaxKeyFrameIntervalKey,
                                   videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   nil];
    
    
    
    NSDictionary *videoCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              AVVideoCodecH264, AVVideoCodecKey,
                                              codecSettings,AVVideoCompressionPropertiesKey,
                                              [NSNumber numberWithInt:480], AVVideoWidthKey,
                                              [NSNumber numberWithInt:640], AVVideoHeightKey,
                                              nil];
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoCompressionSettings];
    
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    NSError *aerror = nil;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:avAsset error:&aerror];
    AVAssetTrack *videoTrack = [[avAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    
    videoWriterInput.transform = videoTrack.preferredTransform;
    NSDictionary *videoOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    AVAssetReaderTrackOutput *asset_reader_output = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoOptions];
    [reader addOutput:asset_reader_output];
    //audio setup
    
    AVAssetWriterInput* audioWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeAudio
                                            outputSettings:nil];
    
    
    AVAssetReader *audioReader = [AVAssetReader assetReaderWithAsset:avAsset error:&error];
    AVAssetTrack* audioTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVAssetReaderOutput *readerOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
    
    [audioReader addOutput:readerOutput];
    NSParameterAssert(audioWriterInput);
    NSParameterAssert([videoWriter canAddInput:audioWriterInput]);
    audioWriterInput.expectsMediaDataInRealTime = NO;
    [videoWriter addInput:audioWriterInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    [reader startReading];
    dispatch_queue_t _processingQueue = dispatch_queue_create("assetAudioWriterQueue", NULL);
    [videoWriterInput requestMediaDataWhenReadyOnQueue:_processingQueue usingBlock:
     ^{
         while ([videoWriterInput isReadyForMoreMediaData]) {
             
             CMSampleBufferRef sampleBuffer;
             if ([reader status] == AVAssetReaderStatusReading &&
                 (sampleBuffer = [asset_reader_output copyNextSampleBuffer])) {
                 
                 BOOL result = [videoWriterInput appendSampleBuffer:sampleBuffer];
                 CFRelease(sampleBuffer);
                 
                     if (!result) {
                     // PROBLEM SEEMS TO BE HERE... result is getting false value....
                     [reader cancelReading];
                     NSLog(@"NO RESULT");
                     NSLog(@"videoWriter.error: %@", videoWriter.error);
                     break;
                 }
             } else {
                 [videoWriterInput markAsFinished];
                 
                 switch ([reader status]) {
                     case AVAssetReaderStatusReading:
                         // the reader has more for other tracks, even if this one is done
                         break;
                         
                     case AVAssetReaderStatusCompleted:
                         // your method for when the conversion is done
                         // should call finishWriting on the writer
                         //hook up audio track
                         [audioReader startReading];
                         [videoWriter startSessionAtSourceTime:kCMTimeZero];
                         // dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
                         // [audioWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^
                         //{
                         NSLog(@"Request");
                         NSLog(@"Asset Writer ready :%d",audioWriterInput.readyForMoreMediaData);
                         while (audioWriterInput.readyForMoreMediaData) {
                             CMSampleBufferRef nextBuffer;
                             if ([audioReader status] == AVAssetReaderStatusReading &&
                                 (nextBuffer = [readerOutput copyNextSampleBuffer])) {
                                 NSLog(@"Ready");
                                 if (nextBuffer) {
                                     NSLog(@"NextBuffer");
                                     [audioWriterInput appendSampleBuffer:nextBuffer];
                                 }
                             }else{
                                 [audioWriterInput markAsFinished];
                                 switch ([audioReader status]) {
                                     case AVAssetReaderStatusCompleted:
                                         [videoWriter finishWritingWithCompletionHandler:nil];
                                         NSLog(@"setting  final... the URL  %@",[[NSURL alloc]initFileURLWithPath:newName]);
                                         NSData *videoData = [NSData dataWithContentsOfURL:[[NSURL alloc]initFileURLWithPath:newName]];
                                         
                                         NSLog(@"video data after compression.......%i",videoData.length);
                                        NSObject<Cancelable> *obj= [QBContent TUploadFile:videoData fileName:@"MyVideo" contentType:@"video/mp4" isPublic:YES delegate:chatmanager];
                                         [uploadingObjects addObject:obj];
                                         break;
                                 }
                             }
                             
                             
                         }
                         
                         break;
                         
                     case AVAssetReaderStatusFailed:
                         [videoWriter cancelWriting];
                         break;
                 }
                 
                 break;
             }
         }
     }
     ];
    NSLog(@"Write Ended");
}

-(void)playClicksChangesSound
{
    [ClicksChangedSound play];
}

#pragma mark Chat Notifications
- (void)SendMessage:(QBChatMessage *)message dict:(NSDictionary *)dictData
{
//    
//     ////////////////////////////////////////////////////// local storage ////////////////////////////////////////////////////////////////////////////////////////////
//    if(dictData)
//    {
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]];
//        
//        NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
//        NSMutableArray *retrievedarray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
//        
//        NSMutableArray *arrCardStatus=[[NSMutableArray alloc] init];
//        if([dict objectForKey:@"ArrayCardStatus"])
//        {
//            arrCardStatus=Nil;
//            arrCardStatus =[(NSArray*)[dict objectForKey:@"ArrayCardStatus"] mutableCopy];
//            
//            
//            // decrease indexes by 1 when messages are above 20
//            if(self.messages.count>20)
//            {
//                for (int i = 0; i < [arrCardStatus count]; i++)
//                {
//                    NSDictionary *oldDict = (NSDictionary *)[arrCardStatus objectAtIndex:i];
//                    NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[[oldDict valueForKey:@"index"] integerValue]-1],@"index",[oldDict valueForKey:@"status"],@"status", nil];
//                    
//                    [arrCardStatus replaceObjectAtIndex:i withObject:newDict];
//                    oldDict = nil;
//                    newDict = nil;
//                }
//            }
//        }
//        
//        NSMutableArray *ArrImagedata;
//        ArrImagedata=[[NSMutableArray alloc] init];
//        if([dict objectForKey:@"ArrayImagedata"])
//            [ArrImagedata addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
//        
//        NSMutableArray *ArrAudioData;
//        ArrAudioData=[[NSMutableArray alloc] init];
//        if([dict objectForKey:@"ArrayAudioData"])
//            [ArrAudioData addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
//        
//        
//        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:retrievedarray],@"ArrayMessages",ArrImagedata,@"ArrayImagedata",ArrAudioData,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
//        
//        [prefs setObject:tempDict forKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"]];
//        
//        [prefs synchronize];
//    }
//    
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //call chat manager send msg
    [chatmanager sendMessage:message dict:dictData];
    
}

- (void)CenterchatDidReceiveMessageNotification:(NSDictionary *)dictMessage
{
    
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"CenterchatDidReceiveMess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    alert = nil;
    
    QBChatMessage *message = [dictMessage objectForKey:kMessage];
    
    //QBChatMessage *message = notification.userInfo[kMessage];
    
    if(appDelegate.isFlowFromNotification == true)
    {
        appDelegate.isFlowFromNotification = false;
    }
    
    if([[NSString stringWithFormat:@"%ld",(long)message.senderID] isEqualToString:partner_QB_id])
    {
    NSDictionary *customParameters = message.customParameters;
    NSNumber *isComposingNotification = customParameters[@"isComposing"];
    if(isComposingNotification != nil)
    {
        BOOL isComposingState = [isComposingNotification boolValue];
        if(isComposingState)
        {
            lblTyping.text = @"typing...";
            PartnerNameLbl.frame = CGRectMake(106,1,108,29);
            // opponent is composing - update UI
        }
        else
        {
            lblTyping.text = @"online";
            //retrieve partner user last seen
            [QBUsers userWithID:[partner_QB_id integerValue] delegate:chatmanager];
            //PartnerNameLbl.frame = CGRectMake(106,8,108,29);
            // opponent has stopped compose - update UI
        }
        return;
    }
    }
    
     if([[NSString stringWithFormat:@"%ld",(long)message.senderID] isEqualToString:partner_QB_id])
     {
            for(int i=0;i<3;i++)
            {
                if(messages.count > i)
                {
                    QBChatMessage *oldMessage = [messages objectAtIndex:messages.count-1-i];
                    if([message.ID isEqualToString:oldMessage.ID])
                        return;
                }
            }
     }
    
    if([message.customParameters[@"isDelivered"] length]>0)
    {
        for(int k=messages.count-1;k>=0;k--)
        {
            if([message.customParameters[@"messageID"] isEqualToString:((QBChatMessage*)[messages objectAtIndex:k]).ID])
            {
                NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
                [custom_Data addEntriesFromDictionary:((QBChatMessage*)[messages objectAtIndex:k]).customParameters];
                [custom_Data setObject:@"yes" forKey:@"isDelivered"];
                [((QBChatMessage*)[messages objectAtIndex:k]) setCustomParameters:custom_Data];
                custom_Data = nil;
                
                [tableView reloadData];
                
                //////////////////////////////////////////////////////////// local storage/////////////////////////////////////////////////////////////////////////////////
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]];

                NSMutableArray *ArrayMessages;
               
                NSRange RangeMessages;
                if(messages.count > 20)
                {
                    RangeMessages.location = [messages count] - 20;
                    RangeMessages.length = 20;
                }
                else
                {
                    RangeMessages.location = 0;
                    RangeMessages.length = [messages count];
                }
                
                ArrayMessages = [[messages subarrayWithRange:RangeMessages] mutableCopy];
                
                NSMutableArray *arrCardStatus = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayCardStatus"])
                {
                    arrCardStatus=nil;
                    arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
                }
                
                NSMutableArray *arrTempImages = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayImagedata"])
                {
                    arrTempImages = nil;
                    arrTempImages = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
                }
                
                NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayAudioData"])
                {
                    arrTempAudio = nil;
                    arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
                }
                
                
                NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
                
                [prefs setObject:tempDict forKey:self.strRelationShipId];
                
                [prefs synchronize];
                
                ArrayMessages = nil;
                arrTempImages = nil;
                arrTempAudio = nil;
                arrCardStatus = nil;
                
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                break;
            }
            
        }
        
        return;
    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"<!> %@",partner_QB_id);
    NSLog(@"<!> %@",[NSString stringWithFormat:@"%ld",(long)message.senderID]);
    NSLog(@"<!> %@",[NSString stringWithFormat:@"%d",message.recipientID]);
    
    if([[NSString stringWithFormat:@"%ld",(long)message.senderID] isEqualToString:partner_QB_id])
    {
        checkforClicks =  false;
        NSLog(@"New message: %@", message);
        NSLog(@"%@",message.text);
        // set 'Clicks' on the tops of the chat view
        NSLog(@"login: %@",[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]);
        NSLog(@"other: %@",[NSString stringWithFormat:@"%d",message.recipientID]);
        NSLog(@"other: %@",[NSString stringWithFormat:@"%d",message.senderID]);
        
        NSString *StrClicks = message.customParameters[@"clicks"];
        
        if([message.customParameters[@"shareStatus"] length]>0 && [message.customParameters[@"shareStatus"] isEqualToString:@"shared"])
        {
            
        }
        else
        {
//            if([StrClicks intValue]!=0)
//            {
//                [self performSelector:@selector(playClicksChangesSound) withObject:nil afterDelay:0.2];
//            }
            
            addMyFriendClicks += [StrClicks intValue];
            rightTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyFriendClicks];
        }
        
        
        //if([message.customParameters[@"isFileUploading"] length]==0 && [message.customParameters[@"isVideoUploading"] length]==0 && [message.customParameters[@"isLocationUploading"] length]==0)
        {
            [imagesData addObject:[[NSData alloc] init]];
        }
        
        //if([message.customParameters[@"isAudioUploading"] length]==0)
        {
            [audioData addObject:[[NSData alloc] init]];
        }
        
        [self.messages addObject:message];
        
        ////////////////////////////////////////////////////// local storage ////////////////////////////////////////////////////////////////////////////////////////////
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]];
        
        
        NSMutableArray *ArrayMessages = [[NSMutableArray alloc] init];
        if([dict objectForKey:@"ArrayMessages"])
        {
            NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
            ArrayMessages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            [ArrayMessages addObject:message];
            if(ArrayMessages.count >= 20)
            {
                NSRange RangeMessages;
                RangeMessages.location = [ArrayMessages count] - 20;
                RangeMessages.length = 20;
                ArrayMessages = [[ArrayMessages subarrayWithRange:RangeMessages] mutableCopy];
            }
            
        }
        else
        {
            [ArrayMessages addObject:message];
        }
        
        
        NSMutableArray *arrCardStatus = [[NSMutableArray alloc] init];
        if([dict objectForKey:@"ArrayCardStatus"])
        {
            arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
            
            // decrease indexes by 1 when messages are above 20
            if(self.messages.count>20)
            {
                for (int i = 0; i < [arrCardStatus count]; i++)
                {
                    NSDictionary *oldDict = (NSDictionary *)[arrCardStatus objectAtIndex:i];
                    NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[[oldDict valueForKey:@"index"] integerValue]-1],@"index",[oldDict valueForKey:@"status"],@"status", nil];
                    
                    [arrCardStatus replaceObjectAtIndex:i withObject:newDict];
                    oldDict = nil;
                    newDict = nil;
                }
            }
            // check if message contains card
            if([message.customParameters[@"card_heading"] length]>0)
            {
                
                NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ArrayMessages.count-1],@"index",@"0",@"status", nil];
                [arrCardStatus addObject:cardDict];
            }
            
            if(arrCardStatus.count >= 20)
            {
                NSRange RangeMessages;
                RangeMessages.location = [arrCardStatus count] - 20;
                RangeMessages.length = 20;
                arrCardStatus = [[arrCardStatus subarrayWithRange:RangeMessages] mutableCopy];
            }
            
        }
        else
        {
            if([message.customParameters[@"card_heading"] length]>0)
            {
                NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ArrayMessages.count-1],@"index",@"0",@"status", nil];
                [arrCardStatus addObject:cardDict];
            }
        }
        
       
        
        
        NSMutableArray *arrTempImages = [[NSMutableArray alloc] init];
        if([dict objectForKey:@"ArrayImagedata"])
        {
            arrTempImages = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
            [arrTempImages addObject:[[NSData alloc] init]];
            if(arrTempImages.count >= 20)
            {
                NSRange RangeMessages;
                RangeMessages.location = [arrTempImages count] - 20;
                RangeMessages.length = 20;
                arrTempImages = [[arrTempImages subarrayWithRange:RangeMessages] mutableCopy];
            }
        
        }
        else
        {
            [arrTempImages addObject:[[NSData alloc] init]];
        }
        
        NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
        if([dict objectForKey:@"ArrayAudioData"])
        {
            arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
            [arrTempAudio addObject:[[NSData alloc] init]];

            if(arrTempAudio.count >= 20)
            {
                NSRange RangeMessages;
                RangeMessages.location = [arrTempAudio count] - 20;
                RangeMessages.length = 20;
                arrTempAudio = [[arrTempAudio subarrayWithRange:RangeMessages] mutableCopy];
            }
        }
        else
        {
            [arrTempAudio addObject:[[NSData alloc] init]];
        }
        
        
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
        
        [prefs setObject:tempDict forKey:self.strRelationShipId];
        
        [prefs synchronize];
        
        ArrayMessages = nil;
        arrTempImages = nil;
        arrTempAudio = nil;
        arrCardStatus = nil;
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        NSLog(@"%d",self.messages.count);
        NSLog(@"%d",imagesData.count);
        
        //for downloading file in chat
        //NSUInteger fileID = [message.customParameters[@"fileID"] integerValue];
        NSString *fileUrl = message.customParameters[@"fileID"];
        
        // download file by ID
        /*if(fileID>0)
         {
         [QBContent TDownloadFileWithBlobID:fileID delegate:self];
         NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
         NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",[NSNumber numberWithInteger:fileID],@"blobID", nil];
         
         [images_indexes addObject:personDict];
         index=nil;
         
         //[images_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
         }*/
        
        if(fileUrl.length>1)
        {
            //[imagesURL addObject:fileUrl];
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",fileUrl,@"blobID", nil];
            
            [images_indexes addObject:personDict];
            index=nil;
            
            //[images_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
        }
        
        [self.tableView reloadData];
        if(isChatHistoryOrNot == TRUE)
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else            {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        
        if([message.customParameters[@"card_heading"] length]>0)
        {
            NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",self.messages.count-1],@"index",@"0",@"status", nil];
            
            [card_accept_status addObject:cardDict];
        }
        

        
        if([message.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"] && [message.customParameters[@"shareStatus"] length]==0)
        {
            
            if([message.customParameters[@"card_owner"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]])
            {
                addMyClicks += [message.customParameters[@"card_clicks"] intValue];
                leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
                
                addMyFriendClicks -= [message.customParameters[@"card_clicks"] intValue];
                rightTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyFriendClicks];
                //[self performSelector:@selector(playClicksChangesSound) withObject:nil afterDelay:0.2];
            }
            else
            {
                addMyClicks -= [message.customParameters[@"card_clicks"] intValue];
                leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
                
                addMyFriendClicks += [message.customParameters[@"card_clicks"] intValue];
                rightTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyFriendClicks];
                //[self performSelector:@selector(playClicksChangesSound) withObject:nil afterDelay:0.2];
            }
        }
    }
    else
    {
        if([message.customParameters[@"fileID"] length] > 1)
        {
            
        }
        else if ([message.customParameters[@"videoID"] length]>1)
        {
            
        }
        else if ([message.customParameters[@"audioID"] length] > 1)
        {
            
        }
        else if ([message.customParameters[@"locationID"] length] > 1)
        {
            
        }
        else
        {
            
        }
    }
    switch ([rightTopHeaderClicks.text length])
    {
        case 1:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(69-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(69-15, 60,14, 15);
            }
            
            rightTopHeaderClicks.frame = CGRectMake(48, 51,16, 32);
            break;
            
        case 2:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(79-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(79-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,25, 32);
            break;
            
        case 3:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(89-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(89-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,38, 32);
            break;
            
        case 4:
            if([rightTopHeaderClicks.text rangeOfString:@"-"].location == NSNotFound)
            {
                LeftSmallClickImageView.frame = CGRectMake(99-10, 60,14, 15);
            }
            else
            {
                LeftSmallClickImageView.frame = CGRectMake(99-15, 60,14, 15);
            }
            rightTopHeaderClicks.frame = CGRectMake(48, 51,44, 32);
            break;
            
        default:
            break;
    }
    
    
}

/*
#pragma mark -
#pragma mark QBChatDelegate

-(void)chatDidFailWithError:(int)code
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    QBUUser *currentUser = [QBUUser user];
    currentUser.ID = [prefs integerForKey:@"SenderId"]; // your current user's ID
    currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
    [QBChat instance].delegate = self;
    [[QBChat instance] loginWithUser:currentUser];
    
    [self.tableView reloadData];
    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}*/


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
//- (void)completedWithResult:(Result *)result
- (void)completedWithResultNotification:(Result *)result
{
    if(result.success && [result isKindOfClass:QBCOCustomObjectResult.class])
    {
        QBCOCustomObjectResult *createObjectResult = (QBCOCustomObjectResult *)result;
        NSLog(@"Created object: %@", createObjectResult.object);
    }
    else
    {
        NSLog(@"customObjects errors====== %@", result.errors);
        @try
        {
//            for(int i = 0 ; i< result.errors.count ; i++)
//            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error>>> %@",[result.errors objectAtIndex:i]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
//            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        //create user session again
        if(result.errors.count>0)
        {
            NSDate *sessionExpiratioDate = [QBBaseModule sharedModule].tokenExpirationDate;
            NSDate *currentDate = [NSDate date];
            NSTimeInterval interval = [currentDate timeIntervalSinceDate:sessionExpiratioDate];
            
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate performSelector:@selector(CheckInternetConnection)];
            if(appDelegate.internetWorking == 0)
            {
                if(interval > 0)
                {
                    [QBAuth createSessionWithDelegate:(AppDelegate *)[[UIApplication sharedApplication]delegate]];
                }
                else
                {
                    [QBUsers logInWithUserLogin:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"] password:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] delegate:(AppDelegate *)[[UIApplication sharedApplication]delegate]];
                }
            }
            else
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                                description:alertNetRechMessage
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
       
    }
    
    
    //retreive partner user details
    if(result.success && [result isKindOfClass:QBUUserResult.class]){
        QBUUserResult *res = (QBUUserResult *)result;
        @try {
            // ---------------------------------------------------
            //check user last seen status
            NSInteger currentTimeInterval = [[NSDate date] timeIntervalSince1970];
            NSInteger userLastRequestAtTimeInterval   = [[res.user lastRequestAt] timeIntervalSince1970];
            
            // if user didn't do anything last 1 minutes (1*60 seconds)
            if((currentTimeInterval - userLastRequestAtTimeInterval) > 20){
                // user is offline now
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormat setDateFormat:@"dd/MM/YYYY"];
                
                NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
                [timeFormat setTimeZone:[NSTimeZone systemTimeZone]];
                [timeFormat setDateFormat:@"hh:mm a"];
                
                
                NSString *lastSeen = [timeFormat stringFromDate:[res.user lastRequestAt]];
                lblTyping.text = [NSString stringWithFormat:@"last seen today at %@",lastSeen];
                
                
                NSString *lastSeenDate = [dateFormat stringFromDate:[res.user lastRequestAt]];
                
                NSDateFormatter *currentDateFormat = [[NSDateFormatter alloc] init];
                [currentDateFormat setDateFormat:@"dd/MM/YYYY"];
                [currentDateFormat setTimeZone:[NSTimeZone systemTimeZone]];
                NSString *currentDate = [currentDateFormat stringFromDate:[NSDate date]];
                
                if(![lastSeenDate isEqualToString:currentDate])
                    lblTyping.text = [NSString stringWithFormat:@"last seen on %@ at %@",lastSeenDate, lastSeen];
                
                PartnerNameLbl.frame = CGRectMake(106,1,108,29);
                
                dateFormat = nil;
                timeFormat = nil;
                currentDateFormat = nil;
            }
            else
            {
                lblTyping.text = @"online";
                PartnerNameLbl.frame = CGRectMake(106,1,108,29);
            }
            //-----------------------------------------------------
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
 /*   // QuickBlox session creation  result
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]])
    {
        // Success result
        if(result.success)
        {
            NSLog(@"session created");
            NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
            NSLog(@"Uname:%@",[Prefs stringForKey:@"QBUserName"]);
            NSLog(@"Pass: %@",[Prefs stringForKey:@"QBPassword"]);
            [QBUsers logInWithUserLogin:[Prefs stringForKey:@"QBUserName"] password:[Prefs stringForKey:@"QBPassword"] delegate:self];
        }
        
    }
    else if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBUUserLogInResult *userResult = (QBUUserLogInResult *)result;
        NSLog(@"Logged In user=%d", (int)(unsigned long)userResult.user.ID);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSLog(@"%d",(int)(unsigned long)userResult.user.ID);
        [prefs setInteger:(int)(unsigned long)userResult.user.ID forKey:@"SenderId"];
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = userResult.user.ID; // your current user's ID
        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
        [QBChat instance].delegate = self;
        [[QBChat instance] loginWithUser:currentUser];
    }
  */
    
   /* if([result isKindOfClass:QBCBlobResult.class])
    {
        QBCBlobResult *res= (QBCBlobResult*)result;
        
        int selected_index=-1;
        for(int i=0;i<imagesData_indexes.count;i++)
        {
            if([[[imagesData_indexes objectAtIndex:i] objectForKey:@"blobID"] isEqualToString:res.blob.UID])
            {
                selected_index=i;
                break;
            }
        }
        if(selected_index==-1)
            selected_index=0;
        
        
        [QBContent uploadFile:[[imagesData_indexes objectAtIndex:selected_index] objectForKey:@"data"] blobWithWriteAccess:res.blob delegate:self];
        
        for(int i=selected_index;i<imagesData_indexes.count-1;i++)
        {
            [imagesData_indexes replaceObjectAtIndex:i withObject:[imagesData_indexes objectAtIndex:i+1]];
        }
        [imagesData_indexes removeLastObject];
        
        
    }*/
    
    // Upload file code
    if([result isKindOfClass:QBCFileUploadTaskResult.class]){
        
        if(result.success)
        {
        // get uploaded file ID
        QBCFileUploadTaskResult *res = (QBCFileUploadTaskResult *)result;
        //NSUInteger uploadedFileID = res.uploadedBlob.ID;
        NSString *uploadedFileUrl = res.uploadedBlob.publicUrl;
        
        NSLog(@"public url of the file is.....  %@",uploadedFileUrl);
        
        // update file sending text message
        /*QBChatMessage *tempMsg=[messages objectAtIndex:[messages count]-1];
        tempMsg.text=@"File Sent Successfully!!!";
        [messages replaceObjectAtIndex:[messages count]-1 withObject:tempMsg];
        tempMsg=nil;*/

        
        
        //[self.tableView reloadData];
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        // CHANGESS
        //audio file
        if([res.uploadedBlob.contentType isEqualToString:@"audio/mpeg"])
        {
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Sending Audio"
                                                                                                                               action:@"Audio sent"
                                                                                                                                label:@"Audio sent"
                                                                                                                                value:nil] build]];
            QBChatMessage *tempMsg;
            int selected_index=-1;
            @try {
                
                for(int i=0;i<audioUploading_indexes.count;i++)
                {
                    if([[[audioUploading_indexes objectAtIndex:i] objectForKey:@"blobName"] isEqualToString:res.uploadedBlob.name])
                    {
                        selected_index=i;
                        break;
                    }
                }
                if(selected_index==-1)
                    selected_index=0;
                
                
                tempMsg=[messages objectAtIndex:[[[audioUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]];
                
                NSMutableDictionary *setCustom_Data = [[NSMutableDictionary alloc] init] ;
                [setCustom_Data addEntriesFromDictionary:tempMsg.customParameters];
                [setCustom_Data setObject:res.uploadedBlob.publicUrl forKey:@"audioStreamURL"];
                [tempMsg setCustomParameters:setCustom_Data];
                /*tempMsg.text=@"File Sent";
                [messages replaceObjectAtIndex:[[[audioUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
                tempMsg=nil;
                
                [self.tableView reloadData];
                if(messages.count>0)
                {
                    if(isChatHistoryOrNot == TRUE)
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    else
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
                
                for(int i=selected_index;i<audioUploading_indexes.count-1;i++)
                {
                    [audioUploading_indexes replaceObjectAtIndex:i withObject:[audioUploading_indexes objectAtIndex:i+1]];
                }
                [audioUploading_indexes removeLastObject];*/
            }
            @catch (NSException *exception) {
                
            }
            
            // send link of uploaded file in the message
            QBChatMessage *message = [QBChatMessage message];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *StrPartner_id = partner_QB_id;
            message.recipientID = [StrPartner_id intValue];
            message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
            //message.text=@"File Received";
            message.text=tempMsg.text;
            if(message.text.length==0)
                message.text = @" ";
            //message.recipientID = 546; // opponent's id
            NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: tempMsg.customParameters[@"clicks"] ,@"clicks", res.uploadedBlob.publicUrl, @"audioID",nil];
            //[message setCustomParameters:[@{@"audioID": res.uploadedBlob.publicUrl} mutableCopy]];
            //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
            [message setCustomParameters:custom_Data];
            custom_Data = nil;
            
            //set custom object for message
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            NSLog(@"dateString: %@",dateString);
            
            NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
            
            NSLog(@"%@",uniqueString);
            
            QBCOCustomObject *object = [QBCOCustomObject customObject];
            object.className = QBchatTable; // your Class name
            
            //NSString *StrClicks = message.customParameters[@"clicks"];
            
            [object.fields setObject:uniqueString forKey:@"chatId"];
            
            message.ID = uniqueString;
            tempMsg.ID=uniqueString;
            [messages replaceObjectAtIndex:[[[audioUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
            
            [object.fields setObject:@"3" forKey:@"type"];
            
            //[object.fields setObject:@"" forKey:@"clicks"];
            //[object.fields setObject:@"Audio File" forKey:@"message"];
            if([tempMsg.customParameters[@"clicks"] isEqualToString:@"no"])
            {
                [object.fields setObject:tempMsg.text forKey:@"message"];
                [object.fields setObject:@"" forKey:@"clicks"];
            }
            else
            {
                NSString *Str = [tempMsg.text substringWithRange:NSMakeRange(3, [tempMsg.text length]-3)];
                NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                Str = [Str stringByReplacingCharactersInRange:range withString:@""];

                [object.fields setObject:Str forKey:@"message"];
                [object.fields setObject:tempMsg.customParameters[@"clicks"] forKey:@"clicks"];
            }

            
            [object.fields setObject:res.uploadedBlob.publicUrl forKey:@"content"];
            [object.fields setObject:self.strRelationShipId forKey:@"relationshipId"];
            [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
            [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
            //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
            [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
            
            //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
            
            [QBCustomObjects createObject:object delegate:chatmanager];
            
            //[[QBChat instance] sendMessage:message];
            
            NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSData alloc] init],@"imagesData",[audioData objectAtIndex:[[[audioUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]], @"audioData" ,nil];
            
            [self SendMessage:message dict:Tempdict];
            
            tempMsg = nil;
            for(int i=selected_index;i<audioUploading_indexes.count-1;i++)
            {
                [audioUploading_indexes replaceObjectAtIndex:i withObject:[audioUploading_indexes objectAtIndex:i+1]];
            }
            [audioUploading_indexes removeLastObject];
            
            [self.tableView reloadData];
            [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        
        
        //video file
        if([res.uploadedBlob.contentType isEqualToString:@"video/mp4"])
        {
            ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Sending Video"
                                                                                                                               action:@"Video sent"
                                                                                                                                label:@"Video sent"
                                                                                                                                value:nil] build]];
            int selected_index=-1;
            @try {
                
                for(int i=0;i<videoUploading_indexes.count;i++)
                {
                    if([[[videoUploading_indexes objectAtIndex:i] objectForKey:@"blobName"] isEqualToString:res.uploadedBlob.name])
                    {
                        selected_index=i;
                        break;
                    }
                }
                
            }
            @catch (NSException *exception) {
                
            }
            if(selected_index==-1)
                selected_index=0;
            
            
            QBChatMessage *tempMsg=[messages objectAtIndex:[[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]];
            
            NSMutableDictionary *setCustom_Data = [[NSMutableDictionary alloc] init] ;
            [setCustom_Data addEntriesFromDictionary:tempMsg.customParameters];
            [setCustom_Data setObject:[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"imageURL"] forKey:@"imageURL"];
            [setCustom_Data setObject:res.uploadedBlob.publicUrl forKey:@"videoStreamURL"];
            [tempMsg setCustomParameters:setCustom_Data];
            
            setCustom_Data = nil;
            /*tempMsg.text=@"File Sent";
            [messages replaceObjectAtIndex:[[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
            tempMsg=nil;
            
            
            [self.tableView reloadData];
            if(messages.count>0)
            {
                if(isChatHistoryOrNot == TRUE)
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                else
                {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
            */
    
        
        //[self.tableView reloadData];
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        // send link of uploaded file in the message
        QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *StrPartner_id = partner_QB_id;
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"File Received";
        message.text=tempMsg.text;
            if(message.text.length==0)
                message.text = @" ";
        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: tempMsg.customParameters[@"clicks"] ,@"clicks", res.uploadedBlob.publicUrl, @"videoID", [[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"imageURL"] ,@"videoThumbnail", nil];
        //message.recipientID = 546; // opponent's id
        //NSMutableDictionary *video_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:                                               res.uploadedBlob.publicUrl,@"videoID", [[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"imageURL"] ,@"videoThumbnail", nil];
            
            
        [message setCustomParameters:custom_Data];
        custom_Data = nil;
            
        //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
        
        //set custom object for message
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
        
        NSLog(@"%@",uniqueString);
        
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = QBchatTable; // your Class name
        
        //NSString *StrClicks = message.customParameters[@"clicks"];
        
        [object.fields setObject:uniqueString forKey:@"chatId"];
            
            message.ID = uniqueString;
            tempMsg.ID=uniqueString;
            [messages replaceObjectAtIndex:[[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
            
        [object.fields setObject:@"4" forKey:@"type"];
        
            if([tempMsg.customParameters[@"clicks"] isEqualToString:@"no"])
            {
                [object.fields setObject:tempMsg.text forKey:@"message"];
                [object.fields setObject:@"" forKey:@"clicks"];
            }
            else
            {
                NSString *Str = [tempMsg.text substringWithRange:NSMakeRange(3, [tempMsg.text length]-3)];
                NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                Str = [Str stringByReplacingCharactersInRange:range withString:@""];
                
                [object.fields setObject:Str forKey:@"message"];
                [object.fields setObject:tempMsg.customParameters[@"clicks"] forKey:@"clicks"];
            }

        [object.fields setObject:res.uploadedBlob.publicUrl forKey:@"content"];
        [object.fields setObject:[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"imageURL"] forKey:@"video_thumb"];
        [object.fields setObject:self.strRelationShipId forKey:@"relationshipId"];
        [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
        [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
        //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
        [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
            
        //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
        
        [QBCustomObjects createObject:object delegate:chatmanager];
        
      //[[QBChat instance] sendMessage:message];
//       [chatmanager sendMessage:message];
            
            NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData objectAtIndex:[[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]],@"imagesData",[[NSData alloc] init], @"audioData" ,nil];
            [self SendMessage:message dict:Tempdict];
            
            tempMsg = nil;
            for(int i=selected_index;i<videoUploading_indexes.count-1;i++)
            {
                [videoUploading_indexes replaceObjectAtIndex:i withObject:[videoUploading_indexes objectAtIndex:i+1]];
            }
            [videoUploading_indexes removeLastObject];

            [self.tableView reloadData];
            [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
        }
        
        
        if([res.uploadedBlob.contentType isEqualToString:@"image/png"] || [res.uploadedBlob.contentType isEqualToString:@"image/jpeg"])
        {
            
            //check for video thumbnail
            if([[res.uploadedBlob.name substringToIndex:5] isEqualToString:@"Video"])
            {
                @try {
                    
                    
                    int selected_index=-1;
                    for(int i=0;i<videoUploading_indexes.count;i++)
                    {
                        if([[[videoUploading_indexes objectAtIndex:i] objectForKey:@"blobName"] isEqualToString:res.uploadedBlob.name])
                        {
                            selected_index=i;
                            break;
                        }
                    }
                    if(selected_index==-1)
                        selected_index=0;
                    
                    //[(NSMutableDictionary*)[videoUploading_indexes objectAtIndex:selected_index] setObject:res.uploadedBlob.publicUrl forKey:@"imageURL"];
                    
                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                    NSMutableDictionary *oldDict = (NSMutableDictionary *)[videoUploading_indexes objectAtIndex:selected_index];
                    [newDict addEntriesFromDictionary:oldDict];
                    [newDict setObject:res.uploadedBlob.publicUrl forKey:@"imageURL"];
                    [videoUploading_indexes replaceObjectAtIndex:selected_index withObject:newDict];
                    newDict = nil;
                    oldDict = nil;
                    
                    
                    NSURL *videoUrl =[NSURL URLWithString:(NSString *) [[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"videoURL"]];
                
                    NSData *videoData=[NSData dataWithContentsOfFile:videoUrl.absoluteString];
                    
                    //NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
                    
                    //NSLog(@"video data without compression.......%i",videoData.length);
                    
                    /*
                    if(isVideoPickedFromLibrary)
                    {
                        //testing compression
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"my_CompressedVideo.mov"];
                    
                        [videoData writeToFile:path atomically:YES];
                    
                        [self resizeVideo:path];
                    }
                    else*/
                    
                     NSObject<Cancelable> *obj=   [QBContent TUploadFile:videoData fileName:[NSString stringWithFormat:@"%@",[[videoUploading_indexes objectAtIndex:selected_index] objectForKey:@"blobName"]]contentType:@"video/mp4" isPublic:YES delegate:chatmanager];
                    [uploadingObjects addObject:obj];
                    
                }
                @catch (NSException *exception) {
                    
                }
            }
            
            else
            {
                
                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Sending Image"
                                                                                                                                   action:@"Image sent"
                                                                                                                                    label:@"Image sent"
                                                                                                                                    value:nil] build]];

                
                QBChatMessage *tempMsg;
                int selected_index=-1;
            
            @try {
                
                
                for(int i=0;i<imagesUploading_indexes.count;i++)
                {
                    if([[[imagesUploading_indexes objectAtIndex:i] objectForKey:@"blobName"] isEqualToString:res.uploadedBlob.name])
                    {
                        selected_index=i;
                        break;
                    }
                }
                if(selected_index==-1)
                    selected_index=0;
                
                
                tempMsg=[messages objectAtIndex:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]];
                
                NSMutableDictionary *setCustom_Data = [[NSMutableDictionary alloc] init] ;
                [setCustom_Data addEntriesFromDictionary:tempMsg.customParameters];
                [setCustom_Data setObject:[NSString stringWithFormat:@"%@",res.uploadedBlob.publicUrl] forKey:@"imageURL"];
                [tempMsg setCustomParameters:setCustom_Data];
                setCustom_Data = nil;
                
                /*id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] inSection:0]];
                
                [((ChatMessageTableViewCell*)cell).downloadingView stopAnimating];*/
                
                /*if(isChatHistoryOrNot)
                    [((ChatMessageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] + 1 inSection:0]]).downloadingView stopAnimating];
                else
                    [((ChatMessageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] inSection:0]]).downloadingView stopAnimating];*/
                
                /*tempMsg.text=@"";
                //tempMsg.text=@"File Sent";
                [messages replaceObjectAtIndex:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
                tempMsg=nil;
                
                //[((ChatMessageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] inSection:0]]).downloadingView stopAnimating];
                
                
                [self.tableView reloadData];
                if(messages.count>0)
                {
                    if(isChatHistoryOrNot == TRUE)
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    else
                    {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
                
                for(int i=selected_index;i<imagesUploading_indexes.count-1;i++)
                {
                    [imagesUploading_indexes replaceObjectAtIndex:i withObject:[imagesUploading_indexes objectAtIndex:i+1]];
                }
                [imagesUploading_indexes removeLastObject];*/
            }
            @catch (NSException *exception) {
                
            }
            
            // send link of uploaded file in the message
            QBChatMessage *message = [QBChatMessage message];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSString *StrPartner_id = partner_QB_id;
            message.recipientID = [StrPartner_id intValue];
            message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
            //message.text=@"File Received";
            message.text=tempMsg.text;
                if(message.text.length==0)
                    message.text = @" ";
            //message.recipientID = 546; // opponent's id
            NSMutableDictionary *custom_Data ;
            if([tempMsg.customParameters[@"isFileUploading"] length]>0)
                custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: tempMsg.customParameters[@"clicks"] ,@"clicks", res.uploadedBlob.publicUrl, @"fileID", tempMsg.customParameters[@"imageRatio"] ,@"imageRatio",nil];
            else
                if([tempMsg.customParameters[@"isLocationUploading"] length]>0)
                    custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: tempMsg.customParameters[@"clicks"] ,@"clicks", res.uploadedBlob.publicUrl, @"locationID", tempMsg.customParameters[@"imageRatio"] ,@"imageRatio", tempMsg.customParameters[@"location_coordinates"],@"location_coordinates", nil];
                
                
            //[message setCustomParameters:[@{@"fileID": res.uploadedBlob.publicUrl} mutableCopy]];
            [message setCustomParameters:custom_Data];
                custom_Data=nil;
            
            //set custom object for message
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            NSLog(@"dateString: %@",dateString);
            
            NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
            
            NSLog(@"%@",uniqueString);
            
            QBCOCustomObject *object = [QBCOCustomObject customObject];
            object.className = QBchatTable; // your Class name
            
            //NSString *StrClicks = message.customParameters[@"clicks"];
            
            [object.fields setObject:uniqueString forKey:@"chatId"];
                
                message.ID = uniqueString;
                tempMsg.ID=uniqueString;
                
                NSLog(@"messages count....%i",messages.count);
                
                [messages replaceObjectAtIndex:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue] withObject:tempMsg];
                
            if([tempMsg.customParameters[@"isFileUploading"] length]>0)
                [object.fields setObject:@"2" forKey:@"type"];
            else if([tempMsg.customParameters[@"isLocationUploading"] length]>0)
            {
                [object.fields setObject:@"6" forKey:@"type"];
                [object.fields setObject:tempMsg.customParameters[@"location_coordinates"] forKey:@"location_coordinates"];
            }
            
            
                
            if([tempMsg.customParameters[@"clicks"] isEqualToString:@"no"])
            {
                [object.fields setObject:tempMsg.text forKey:@"message"];
                [object.fields setObject:@"" forKey:@"clicks"];
            }
            else
            {
                NSString *Str = [tempMsg.text substringWithRange:NSMakeRange(3, [tempMsg.text length]-3)];
                NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                Str = [Str stringByReplacingCharactersInRange:range withString:@""];
                
                [object.fields setObject:Str forKey:@"message"];
                [object.fields setObject:tempMsg.customParameters[@"clicks"] forKey:@"clicks"];
            }
            [object.fields setObject:tempMsg.customParameters[@"imageRatio"] forKey:@"imageRatio"];
            [object.fields setObject:res.uploadedBlob.publicUrl forKey:@"content"];
            [object.fields setObject:self.strRelationShipId forKey:@"relationshipId"];
            [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
            [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
            //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
            [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
                
                //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
            
            [QBCustomObjects createObject:object delegate:chatmanager];
            
            
            //[[QBChat instance] sendMessage:message];
                NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData objectAtIndex:[[[imagesUploading_indexes objectAtIndex:selected_index] objectForKey:@"index"] integerValue]],@"imagesData",[[NSData alloc] init], @"audioData" ,nil];
                
                [self SendMessage:message dict:Tempdict];
//                [chatmanager sendMessage:message];
            
                tempMsg = nil;
                for(int i=selected_index;i<imagesUploading_indexes.count-1;i++)
                {
                    [imagesUploading_indexes replaceObjectAtIndex:i withObject:[imagesUploading_indexes objectAtIndex:i+1]];
                }
                [imagesUploading_indexes removeLastObject];
            
                
             [self.tableView reloadData];
                [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                
          }
        }
        
       }
        else
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Media Upload Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
        }
    }
//    
//    // Download file code
//    if(result.success && [result isKindOfClass:QBCFileDownloadTaskResult.class]){
//        
//        if(result.success)
//        {
//        // extract image
//        QBCFileDownloadTaskResult *res = (QBCFileDownloadTaskResult *)result;
//        //UIImage *image = [UIImage imageWithData:res.file];
//        //((ChatMessageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0]]).imageSentView.image=[UIImage imageWithData:res.file];
//        
//        if(res.file!=nil)
//        {
//            @try {
//                int selected_index=-1;
//                for(int i=0;i<images_indexes.count;i++)
//                {
//                    if([[[images_indexes objectAtIndex:i] objectForKey:@"blobID"] intValue]==res.blob.ID)
//                    {
//                        selected_index=[[[images_indexes objectAtIndex:i] objectForKey:@"index"] integerValue];
//                        break;
//                    }
//                }
//                if(selected_index==-1)
//                    selected_index=0;
//                
//                
//                
//                [imagesData replaceObjectAtIndex:selected_index withObject:res.file];
//                QBChatMessage *tempMsg=[messages objectAtIndex:selected_index];
//                tempMsg.text=@"File Downloaded";
//                [messages replaceObjectAtIndex:selected_index withObject:tempMsg];
//                tempMsg=nil;
//
//                /*
//                [imagesData replaceObjectAtIndex:[[images_indexes objectAtIndex:0] integerValue] withObject:res.file];
//                
//                QBChatMessage *tempMsg=[messages objectAtIndex:[[images_indexes objectAtIndex:0] integerValue]];
//                tempMsg.text=@"File Downloaded";
//                [messages replaceObjectAtIndex:[[images_indexes objectAtIndex:0] integerValue] withObject:tempMsg];
//                tempMsg=nil;*/
//                
//                
//                //[((ChatMessageTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[images_indexes objectAtIndex:0] integerValue] inSection:0]]).downloadingView stopAnimating];
//                
//                [self.tableView reloadData];
//                if(isChatHistoryOrNot == TRUE)
//                {
//                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                }
//                else
//                {
//                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                }
//                /*for(int i=0;i<images_indexes.count-1;i++)
//                {
//                    [images_indexes replaceObjectAtIndex:i withObject:[images_indexes objectAtIndex:i+1]];
//                }
//                [images_indexes removeLastObject];*/
//                
//                for(int i=selected_index;i<images_indexes.count-1;i++)
//                {
//                    [images_indexes replaceObjectAtIndex:i withObject:[images_indexes objectAtIndex:i+1]];
//                }
//                [images_indexes removeLastObject];
//                
//                /*for(int i=selected_index;i<images_indexes.count-1;i++)
//                {
//                    [images_indexes replaceObjectAtIndex:i withObject:[images_indexes objectAtIndex:i+1]];
//                }
//                [images_indexes removeLastObject];*/
//            }
//            @catch (NSException *exception) {
//                
//            }
//            
//        }
//        
//        
//        /*QBChatMessage *tempMsg=[messages objectAtIndex:[[images_indexes objectAtIndex:0] integerValue]];
//        tempMsg.text=@"";
//        [messages replaceObjectAtIndex:[[images_indexes objectAtIndex:0] integerValue] withObject:tempMsg];
//        tempMsg=nil;
//        
//        [self.tableView reloadData];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        
//        //remove file downloading message from messages array
//        
//        */
//        
//        }
//        else
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Image Download Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
//        }
//    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    QBChatMessage *testMessage = [QBChatMessage message];
    NSString *Str_Partner_id = partner_QB_id;
    testMessage.recipientID = [Str_Partner_id intValue];
    [testMessage setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
    [self SendMessage:testMessage dict:nil];
    
    NSString *card_selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"];
    if(card_selected.length>0)
    {
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Trade Card"
                                                                                                                           action:@"Trade Card played"
                                                                                                                            label:@"Trade Card played"
                                                                                                                            value:nil] build]];
        //isChatHistoryOrNot = FALSE;
        QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *StrPartner_id = partner_QB_id;
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        NSLog(@"%d",[StrPartner_id intValue]);
        NSLog(@"%@",StrPartner_id);
        
        message.text = @" ";
       
        NSString *uniqueString;
        NSMutableDictionary *cards_data;
       if([[[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"] length]==0)
       {
        
           NSDate *currDate = [NSDate date];
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
           [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
           NSString *dateString = [dateFormatter stringFromDate:currDate];
           NSLog(@"dateString: %@",dateString);
        
           uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
           
           cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"card_clicks"],@"card_clicks",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"],@"card_heading",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_content"],@"card_content",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_url"],@"card_url", @"playing",@"card_Played_Countered", @"nil",@"card_Accepted_Rejected", uniqueString,@"card_id", [NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] , @"card_owner", [[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"], @"card_originator", [[NSUserDefaults standardUserDefaults] stringForKey:@"is_CustomCard"], @"is_CustomCard", [[NSUserDefaults standardUserDefaults] stringForKey:@"card_DB_ID"], @"card_DB_ID", nil];
           
           
           
       }
       else
       {
           //uniqueString = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"];
           NSDate *currDate = [NSDate date];
           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
           [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
           NSString *dateString = [dateFormatter stringFromDate:currDate];
           NSLog(@"dateString: %@",dateString);
           
           uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
           
           cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"card_clicks"],@"card_clicks",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"],@"card_heading",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_content"],@"card_content",[[NSUserDefaults standardUserDefaults] objectForKey:@"card_url"],@"card_url", @"played",@"card_Played_Countered", @"countered",@"card_Accepted_Rejected", [[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"],@"card_id", [[NSUserDefaults standardUserDefaults] objectForKey:@"card_owner"],@"card_owner", [[NSUserDefaults standardUserDefaults] stringForKey:@"card_originator"], @"card_originator", [[NSUserDefaults standardUserDefaults] stringForKey:@"is_CustomCard"], @"is_CustomCard", [[NSUserDefaults standardUserDefaults] stringForKey:@"card_DB_ID"], @"card_DB_ID", @"", @"isDelivered",  nil];
           
           
           NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[[card_countered_indexes objectForKey:@"selectedIndex"] integerValue]],@"index",@"1",@"status", nil];
           
           
           [card_accept_status replaceObjectAtIndex:[[card_countered_indexes objectForKey:@"cardArrayIndex"] integerValue] withObject:cardDict];
           
           QBChatMessage *tempChat_Msg = (QBChatMessage *)[messages objectAtIndex:[[card_countered_indexes objectForKey:@"selectedIndex"] integerValue]];
           
           [self UpdateCardStatusLocalStorage:tempChat_Msg];
           
       }
        
        NSLog(@"%@",uniqueString);
        
        
        
        [message setCustomParameters:cards_data];

        
        /*[message setCustomParameters:[@{@"card_clicks" : [[NSUserDefaults standardUserDefaults] objectForKey:@"card_clicks"]} mutableCopy]];
        
        [message setCustomParameters:[@{@"card_heading" : [[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"]} mutableCopy]];
        
        [message setCustomParameters:[@{@"card_content" : [[NSUserDefaults standardUserDefaults] objectForKey:@"card_content"]} mutableCopy]];
        
        [message setCustomParameters:[@{@"card_url" : [[NSUserDefaults standardUserDefaults] objectForKey:@"card_url"]} mutableCopy]];*/
        
        
        //set custom object for message
        
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = QBchatTable; // your Class name
        
        //NSString *StrClicks = message.customParameters[@"clicks"];
        
        [object.fields setObject:uniqueString forKey:@"chatId"];
        message.ID = uniqueString;
        [object.fields setObject:@"5" forKey:@"type"];
        
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:@"" forKey:@"message"];
        [object.fields setObject:@"" forKey:@"content"];
        
        NSArray *cards_array;
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"] length]==0)
            cards_array=[NSArray arrayWithObjects: uniqueString,[[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"card_content"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"card_url"],
                              [[NSUserDefaults standardUserDefaults] objectForKey:@"card_clicks"],
                              @"nil",[prefs stringForKey:@"QBUserName"], [[NSUserDefaults standardUserDefaults] stringForKey:@"is_CustomCard"],[[NSUserDefaults standardUserDefaults] stringForKey:@"card_DB_ID"],
                              nil];
        else
            cards_array=[NSArray arrayWithObjects: [[NSUserDefaults standardUserDefaults] objectForKey:@"card_id"],[[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"],
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"card_content"],
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"card_url"],
                         [[NSUserDefaults standardUserDefaults] objectForKey:@"card_clicks"],
                         @"countered",[[NSUserDefaults standardUserDefaults] stringForKey:@"card_originator"], [[NSUserDefaults standardUserDefaults] stringForKey:@"is_CustomCard"], [[NSUserDefaults standardUserDefaults] stringForKey:@"card_DB_ID"],
                         nil];
        
        [object.fields setObject:cards_array forKey:@"cards"];
        [object.fields setObject:[prefs stringForKey:@"relationShipId"] forKey:@"relationshipId"];
        [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
        [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
        //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
        [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
        
        [QBCustomObjects createObject:object delegate:chatmanager];
        
        cards_array = nil;
        
        
        [imagesData addObject:[[NSData alloc] init]];
        [audioData addObject:[[NSData alloc] init]];
        //[imagesURL addObject:@"-"];
        //[videosData addObject:@"-"];
        
        
        //[[QBChat instance] sendMessage:message];
//        [chatmanager sendMessage:message];
        NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
        
        [self SendMessage:message dict:Tempdict];
        
        message.text = @"";
        [self.messages addObject:message];
        
        NSLog(@"local chat added: %@",self.messages);
        
        //[[QBChat instance] setDelegate:self];
        [self.tableView reloadData];
        if(isChatHistoryOrNot == TRUE)
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_heading"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_content"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_clicks"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_owner"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_originator"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"is_CustomCard"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_DB_ID"];
    
    card_selected = nil;
    
    
    //share location
    NSData *locationImageData =  [[NSUserDefaults standardUserDefaults] objectForKey:@"locationimagedata"];
    if(locationImageData.length>0)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        NSObject<Cancelable> *obj=[QBContent TUploadFile:locationImageData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:chatmanager];
        [uploadingObjects addObject:obj];
        
        [imagesData addObject:locationImageData];
        [audioData addObject:[[NSData alloc] init]];
        //displaying file sent message in the chat
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        QBChatMessage *message = [QBChatMessage message];
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        
        message.text=@"Location Shared";
        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init];
        [custom_Data setObject:@"no" forKey:@"clicks"];
        [custom_Data setObject:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isLocationUploading"];
        [custom_Data setObject:[NSString stringWithFormat:@"%f",1.0] forKey:@"imageRatio"];
        [custom_Data setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"locationCoordinates"] forKey:@"location_coordinates"];
        [message setCustomParameters:custom_Data];
        
        
        [self.messages addObject:message];
        custom_Data = nil;
        
        if([message.customParameters[@"isLocationUploading"] length]>0)
        {
            //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
            
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isLocationUploading"],@"blobName", nil];
            [imagesUploading_indexes addObject:personDict];
            
        }
        
        [self.tableView reloadData];
        
        if(isChatHistoryOrNot == TRUE)
        {
            if([messages count]>=1)
            {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
        else
        {
            if([messages count]>=1)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSData alloc] init]  forKey:@"locationimagedata"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"locationCoordinates"];
}

#pragma mark -
#pragma mark TextFieldDelegate


- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.tag == 7777)
    {
//        CGFloat fixedWidth = textView.frame.size.width;
//        CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
//        CGRect newFrame = textView.frame;
//        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//        NSLog(@"%f",newSize.width);
//        NSLog(@"%f",fixedWidth);
//        NSLog(@"%f",newSize.height);
//        textView.frame = newFrame;
//        NSLog(@"yyy:%f",newFrame.origin.y);
//        NSLog(@"%f",newFrame.origin.x);
//        NSLog(@">>>>>%f",newFrame.size.height);
//        NSLog(@">>>>>width %f",newSize.width);
        
        
        CGFloat myMaxSize = 568.0f; // Set to max height you would ever want your textView to expand to
        
        CGRect frameRect = textView.frame;
        CGRect rect = [textView.text
                       boundingRectWithSize:CGSizeMake(frameRect.size.width, CGFLOAT_MAX)
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName: textView.font}
                       context:nil];
        
        CGSize size = rect.size;
        if (size.height > myMaxSize) {
            size.height = myMaxSize;
        }
        
        frameRect.size = size;
        [textView setFrame:frameRect];
        
//        if(newFrame.size.height ==  33.0f)
//        {
//            if(CheckIfTextViewIncreasedByHeight == false)
//            {
//                textView.frame =  CGRectMake(newFrame.origin.x, textView.frame.origin.y-(newFrame.size.height-33), newFrame.size.width, newFrame.size.height);
//            }
//            CheckIfTextViewIncreasedByHeight = true;
//        }
//        else if(newFrame.size.height >  33.0f && newFrame.size.height <=  49.5f)
//        {
//            if(CheckIfTextViewIncreasedByHeight == false)
//            {
//                textView.frame =  CGRectMake(newFrame.origin.x, textView.frame.origin.y-(newFrame.size.height-33), newFrame.size.width, newFrame.size.height);
//            }
//            CheckIfTextViewIncreasedByHeight = true;
//        }
//        else if(newFrame.size.height >  49.5f && newFrame.size.height <=  66.0f)
//        {
//            if(CheckIfTextViewIncreasedByHeight == false)
//            {
//                textView.frame =  CGRectMake(newFrame.origin.x, textView.frame.origin.y-(newFrame.size.height-33), newFrame.size.width, newFrame.size.height);
//            }
//            CheckIfTextViewIncreasedByHeight = true;
//        }
//        else if(newFrame.size.height >  66.0f && newFrame.size.height <=  82.5f)
//        {
//            if(CheckIfTextViewIncreasedByHeight == false)
//            {
//                textView.frame =  CGRectMake(newFrame.origin.x, textView.frame.origin.y-(newFrame.size.height-33), newFrame.size.width, newFrame.size.height);
//            }
//            CheckIfTextViewIncreasedByHeight = true;
//        }
//        else
//        {
//            
//        }
    }
//    CGFloat fixedWidth = textView.frame.size.width;
//    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];//
//    CGRect newFrame = CGRectMake(45, self.view.frame.size.height-41, fixedWidth, MAXFLOAT);
//    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
//    textView.frame = newFrame;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag == 7777)
    {
        [self keyboardShow];

        [UIView animateWithDuration:0.3 animations:^() {
            //mediaScrollview.alpha = 0;
            CardsScrollview.alpha = 0;
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 7777)
    {
        [self keyboardHide];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"shouldChangeTextInRange"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
    
    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Done"
                                                                    description:@"shouldChangeTextInRange"
                                                                  okButtonTitle:@"OK"];
    alertView.delegate = nil;
    [alertView show];
    alertView = nil;

    if(textView.tag == 7777)
    {
        if([text isEqualToString:@"\n"])
        {
            UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
            Overlay.alpha=0;
            UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
            
            if(mediaAttachButton.tag==1)
            {
                if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
                {
                    if(self.sendMessageField.text.length == 0)
                    {
                        [textView resignFirstResponder];
                        return NO;
                    }
                }
            }
            
            ContentButton.hidden = NO;
            sendMessageButton.hidden = YES;
            CheckIfAttachBtnContainMedia = false;
            
            checkforClicks =  false;
            
            QBChatMessage *message = [[QBChatMessage alloc] init];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSString *StrPartner_id = partner_QB_id;
            message.recipientID = [StrPartner_id intValue];
            NSLog(@"%d",[StrPartner_id intValue]);
            NSLog(@"%@",StrPartner_id);
            
            NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init];
            
            if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
            {
                message.text = self.sendMessageField.text;
                //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                [custom_Data setObject:@"no" forKey:@"clicks"];
            }
            else
            {
                [custom_Data setObject:[NSString stringWithFormat:@"%@",textClicks.text] forKey:@"clicks"];
                //[message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",textClicks.text]} mutableCopy]];
                message.text = [NSString stringWithFormat:@"%@ %@",textClicks.text ,self.sendMessageField.text];
                
                addMyClicks += [textClicks.text intValue];
                leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
            }
            
            
            float centerValue = ((SliderBar.maximumValue - SliderBar.minimumValue) / 2)+SliderBar.minimumValue;
            [SliderBar setValue:centerValue animated:YES];
            
            textClicks.text =@"00";
            [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
            [self.SliderBar setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
            [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
            [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
            
            if(mediaAttachButton.tag==2)
            {
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                NSLog(@"dateString: %@",dateString);
                
                NSObject<Cancelable> *obj=[QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:chatmanager];
                [uploadingObjects addObject:obj];
                
                [imagesData addObject:tempMediaData];
                [audioData addObject:[[NSData alloc] init]];
                //displaying file sent message in the chat
                //QBChatMessage *message = [QBChatMessage message];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
                message.recipientID = [StrPartner_id intValue];
                message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
                //message.text=@"";
                //message.text=@"Sending File...";
                [custom_Data setObject:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isFileUploading"];
                [custom_Data setObject:[NSString stringWithFormat:@"%f",tempImageRatio] forKey:@"imageRatio"];
                [message setCustomParameters:custom_Data];
                
                
                [self.messages addObject:message];
                
                
                if([message.customParameters[@"isFileUploading"] length]>0)
                {
                    //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
                    
                    NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
                    NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isFileUploading"],@"blobName", nil];
                    [imagesUploading_indexes addObject:personDict];
                    
                }
                
                
                
            }
            
            else if(mediaAttachButton.tag==3)
            {
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                NSLog(@"dateString: %@",dateString);
                
                
                NSObject<Cancelable> *obj=[QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"audio/mpeg" isPublic:YES delegate:chatmanager];
                [uploadingObjects addObject:obj];
                [audioData addObject:tempMediaData];
                //displaying file sent message in the chat
                //QBChatMessage *message = [QBChatMessage message];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
                message.recipientID = [StrPartner_id intValue];
                message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
                //message.text=@"";
                [custom_Data setObject:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isAudioUploading"];
                
                [message setCustomParameters:custom_Data];
                [imagesData addObject:[[NSData alloc] init]];
                
                
                [self.messages addObject:message];
                
                if([message.customParameters[@"isAudioUploading"] length]>0)
                {
                    //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
                    
                    NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
                    NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isAudioUploading"],@"blobName", nil];
                    [audioUploading_indexes addObject:personDict];
                }
                
            }
            
            else if(mediaAttachButton.tag==4)
            {
                [imagesData addObject:tempMediaData];
                
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                NSLog(@"dateString: %@",dateString);
                
                
               NSObject<Cancelable> *obj= [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:chatmanager];
                
                [uploadingObjects addObject:obj];
                //displaying file sent message in the chat
                //QBChatMessage *message = [QBChatMessage message];
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
                message.recipientID = [StrPartner_id intValue];
                message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
                //message.text=@"Sending File...";
                
                [custom_Data setObject:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"fileName"];
                [custom_Data setObject:[NSString stringWithFormat:@"%@",tempVideoUrl] forKey:@"videoURL"];
                [custom_Data setObject:[NSNumber numberWithInt: 1] forKey:@"isVideoUploading"];
                
                [message setCustomParameters:custom_Data];
                
                
                [self.messages addObject:message];
                [audioData addObject:[[NSData alloc] init]];
                
                if([message.customParameters[@"isVideoUploading"] integerValue]==1)
                {
                    NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
                    NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"fileName"],@"blobName", message.customParameters[@"videoURL"], @"videoURL", @"-", @"imageURL", nil];
                    [videoUploading_indexes addObject:personDict];
                }
                
            }
            
            
            else
            {
                [message setCustomParameters:custom_Data];
                
                // custom object work
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                NSLog(@"dateString: %@",dateString);
                
                NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[prefs integerForKey:@"SenderId"],partner_QB_id,dateString];
                
                NSLog(@"%@",uniqueString);
                
                QBCOCustomObject *object = [QBCOCustomObject customObject];
                object.className = QBchatTable; // your Class name
                
                NSString *StrClicks = message.customParameters[@"clicks"];
                
                [object.fields setObject:uniqueString forKey:@"chatId"];
                message.ID = uniqueString;
                
                [object.fields setObject:@"1" forKey:@"type"];
                
                if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
                {
                    [object.fields setObject:@"" forKey:@"clicks"];
                    [object.fields setObject:message.text forKey:@"message"];
                }
                else
                {
                    NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
                    [object.fields setObject:Str forKey:@"message"];
                    [object.fields setObject:StrClicks forKey:@"clicks"];
                }
                [object.fields setObject:@"" forKey:@"content"];
                [object.fields setObject:[prefs stringForKey:@"relationShipId"] forKey:@"relationshipId"];
                [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
                [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
                //[object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sentOn"];
                
                [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
                
                //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
                
                [QBCustomObjects createObject:object delegate:chatmanager];
                
                [self.messages addObject:message];
                //   NSLog(@"%@",self.messages);
                [imagesData addObject:[[NSData alloc] init]];
                [audioData addObject:[[NSData alloc] init]];
                //[imagesURL addObject:@"-"];
                //[videosData addObject:@"-"];
                
                NSLog(@"%d",self.messages.count);
                NSLog(@"%d",imagesData.count);
                
                
                NSLog(@"local chat added: %@",self.messages);
                //[[QBChat instance] sendMessage:message];
//                [chatmanager sendMessage:message];
                NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
                
                [self SendMessage:message dict:Tempdict];
                //[[QBChat instance] setDelegate:self];
            }
            
            [self.tableView reloadData];
            if(isChatHistoryOrNot == TRUE)
            {
                if([messages count]>=1)
                {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
            else
            {
                if([messages count]>=1)
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [self.sendMessageField setText:nil];
            
            custom_Data = nil;
            tempMediaData = nil;
            tempVideoUrl = nil;
            tempImageRatio = 1;
            mediaAttachButton.tag = 1;
            [mediaAttachButton setImage:[UIImage imageNamed:@"footer_attachment.png"] forState:UIControlStateNormal];
            //  [textField resignFirstResponder];
            return YES;
        }
        else
        {
            NSMutableString *StrTextfield = [NSMutableString stringWithFormat:@"%@",textView.text];
            [StrTextfield deleteCharactersInRange:range];
            [StrTextfield insertString:text atIndex:range.location];
            NSLog(@"StrTextfield: %@",StrTextfield);
            
            if([StrTextfield length] == 0)
            {
                ContentButton.hidden = NO;
                sendMessageButton.hidden = YES;
            }
            else
            {
                ContentButton.hidden = YES;
                sendMessageButton.hidden = NO;
            }
        }
        return  YES;
    }
    return 0;
}

/*
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    //Overlay.hidden = NO;
    Overlay.alpha=0;
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    if(mediaAttachButton.tag==1)
    {
        if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
        {
            if(self.sendMessageField.text.length == 0)
            {
                [textField resignFirstResponder];
                return YES;
            }
        }
    }
    
    ContentButton.hidden = NO;
    sendMessageButton.hidden = YES;
    CheckIfAttachBtnContainMedia = false;
    
    checkforClicks =  false;
    
    QBChatMessage *message = [[QBChatMessage alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *StrPartner_id = partner_QB_id;
    message.recipientID = [StrPartner_id intValue];
    NSLog(@"%d",[StrPartner_id intValue]);
    NSLog(@"%@",StrPartner_id);
    
    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init];
    
    if([[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[textClicks.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"] || textClicks == nil)
    {
        message.text = self.sendMessageField.text;
        //[message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
        [custom_Data setObject:@"no" forKey:@"clicks"];
    }
    else
    {
        [custom_Data setObject:[NSString stringWithFormat:@"%@",textClicks.text] forKey:@"clicks"];
        //[message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",textClicks.text]} mutableCopy]];
        message.text = [NSString stringWithFormat:@"%@ %@",textClicks.text ,self.sendMessageField.text];
        
        addMyClicks += [textClicks.text intValue];
        leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
    }

    
    float centerValue = ((SliderBar.maximumValue - SliderBar.minimumValue) / 2)+SliderBar.minimumValue;
    [SliderBar setValue:centerValue animated:YES];
    
    textClicks.text =@"00";
    [ImgViewBGOfSlider setImage:[UIImage imageNamed:@"slider_bgraila.png"]];
    [self.SliderBar setThumbImage: [UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.SliderBar setMaximumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    [self.SliderBar setMinimumTrackImage:[UIImage imageNamed:@"slider_bgrailline.png"] forState:UIControlStateNormal];
    
    if(mediaAttachButton.tag==2)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:self];
        
        [imagesData addObject:tempMediaData];
        [audioData addObject:[[NSData alloc] init]];
        //displaying file sent message in the chat
        //QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"";
        //message.text=@"Sending File...";
        [custom_Data setObject:[NSString stringWithFormat:@"Image%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isFileUploading"];
        [custom_Data setObject:[NSString stringWithFormat:@"%f",tempImageRatio] forKey:@"imageRatio"];
        [message setCustomParameters:custom_Data];
        
 
        [self.messages addObject:message];
        
        
        if([message.customParameters[@"isFileUploading"] length]>0)
        {
            //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
            
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isFileUploading"],@"blobName", nil];
            [imagesUploading_indexes addObject:personDict];
            
        }
        
        
        
    }
    
    else if(mediaAttachButton.tag==3)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
        [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"audio/mpeg" isPublic:YES delegate:self];
        
        [audioData addObject:tempMediaData];
        //displaying file sent message in the chat
        //QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"";
        [custom_Data setObject:[NSString stringWithFormat:@"Audio%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"isAudioUploading"];
        
        [message setCustomParameters:custom_Data];
        [imagesData addObject:[[NSData alloc] init]];
        
 
        [self.messages addObject:message];
        
        if([message.customParameters[@"isAudioUploading"] length]>0)
        {
            //[imagesUploading_indexes addObject:[NSString stringWithFormat:@"%i",self.messages.count-1]];
            
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"isAudioUploading"],@"blobName", nil];
            [audioUploading_indexes addObject:personDict];
        }
        
    }
    
    else if(mediaAttachButton.tag==4)
    {
        [imagesData addObject:tempMediaData];
        
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        
        [QBContent TUploadFile:tempMediaData fileName:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] contentType:@"image/jpeg" isPublic:YES delegate:self];
        
        
        //displaying file sent message in the chat
        //QBChatMessage *message = [QBChatMessage message];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *StrPartner_id = [NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]];
        message.recipientID = [StrPartner_id intValue];
        message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
        //message.text=@"Sending File...";
        
        [custom_Data setObject:[NSString stringWithFormat:@"Video%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString] forKey:@"fileName"];
        [custom_Data setObject:[NSString stringWithFormat:@"%@",tempVideoUrl] forKey:@"videoURL"];
        [custom_Data setObject:[NSNumber numberWithInt: 1] forKey:@"isVideoUploading"];
        
        [message setCustomParameters:custom_Data];
 
        
        [self.messages addObject:message];
        [audioData addObject:[[NSData alloc] init]];
        
        if([message.customParameters[@"isVideoUploading"] integerValue]==1)
        {
            NSString * index=[NSString stringWithFormat:@"%i",self.messages.count-1];
            NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:index,@"index",message.customParameters[@"fileName"],@"blobName", message.customParameters[@"videoURL"], @"videoURL", @"-", @"imageURL", nil];
            [videoUploading_indexes addObject:personDict];
        }
        
    }


    else
    {
        [message setCustomParameters:custom_Data];
        
    // custom object work
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[prefs integerForKey:@"SenderId"],partner_QB_id,dateString];
    
    NSLog(@"%@",uniqueString);
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:uniqueString forKey:@"chatId"];
    message.ID = uniqueString;
        
    [object.fields setObject:@"1" forKey:@"type"];
    
    if([StrClicks isEqualToString:@"no"])
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    [object.fields setObject:@"" forKey:@"content"];
    [object.fields setObject:[prefs stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    //[object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] forKey:@"sentOn"];
        
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
        
    //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
    
    [QBCustomObjects createObject:object delegate:self];
    
    [self.messages addObject:message];
    //   NSLog(@"%@",self.messages);
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];
    //[imagesURL addObject:@"-"];
    //[videosData addObject:@"-"];
    
    NSLog(@"%d",self.messages.count);
    NSLog(@"%d",imagesData.count);
    
    
    NSLog(@"local chat added: %@",self.messages);
    [[QBChat instance] sendMessage:message];
    [[QBChat instance] setDelegate:self];
    }
        
    [self.tableView reloadData];
    if(isChatHistoryOrNot == TRUE)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        if([messages count]>=1)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [self.sendMessageField setText:nil];
    
    custom_Data = nil;
    tempMediaData = nil;
    tempVideoUrl = nil;
    tempImageRatio = 1;
    mediaAttachButton.tag = 1;
    [mediaAttachButton setImage:[UIImage imageNamed:@"footer_attachment.png"] forState:UIControlStateNormal];
  //  [textField resignFirstResponder];
    return YES;
}
 
*/


-(void)keyboardShow
{
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    
    UIImageView *ImgViewClicks=(UIImageView *)[Overlay viewWithTag:13];
    
    CGRect rectChatOverlayImgView = ImgViewClicks.frame;
    
    CGRect rectChatOverlayText = textClicks.frame;
    
    CGRect rectChatOverlay = Overlay.frame;
    rectChatOverlay.origin.y -= 215;
    
    CGRect rectChatBgWhite = self.ChatBgWhiteView.frame;
    rectChatBgWhite.origin.y -= 215;
    
    CGRect rectChatBg = self.ChatBgImgView.frame;
    rectChatBg.origin.y -= 215;

    CGRect rectFild = self.sendMessageField.frame;
    rectFild.origin.y -= 215;
    
    CGRect rectButton = self.sendMessageButton.frame;
    rectButton.origin.y -= 215;
    
    CGRect rectContentButton = self.ContentButton.frame;
    rectContentButton.origin.y -= 215;
    
    CGRect rectAttachementButton = self.mediaAttachButton.frame;
    rectAttachementButton.origin.y -= 215;
    
    CGRect rectAttachementScrollView = attachmentAnimationView.frame;
    rectAttachementScrollView.origin.y -= 215;
    
    CGRect rectAudioRecordView = startRecordingView.frame;
    rectAudioRecordView.origin.y -= 215;

    
    CGRect rectTableView = self.tableView.frame;
    
    if (IS_IPHONE_5)
    {
        rectChatOverlayText.origin.y += 100;
        rectChatOverlayImgView.origin.y += 100;
        rectTableView.size.height = 188-20;
    }
    else
    {
        rectChatOverlayText.origin.y += 110;
        rectChatOverlayImgView.origin.y += 110;
        rectTableView.size.height = 188-20-88;
    }
 
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [ImgViewClicks setFrame:rectChatOverlayImgView];
                         [textClicks setFrame:rectChatOverlayText];
                         [Overlay setFrame:rectChatOverlay];
                         [self.sendMessageField setFrame:rectFild];
                         [self.sendMessageButton setFrame:rectButton];
                         [self.ContentButton setFrame:rectContentButton];
                         [self.ChatBgImgView setFrame:rectChatBg];
                         [self.ChatBgWhiteView setFrame:rectChatBgWhite];
                         [self.mediaAttachButton setFrame:rectAttachementButton];
                         [self.tableView setFrame:rectTableView];
                         [attachmentAnimationView setFrame:rectAttachementScrollView];
                         [startRecordingView setFrame:rectAudioRecordView];
                     }
     ];
}

-(void)keyboardHide
{
    UIView *Overlay=(UIView *)[self.view viewWithTag:111111];
    UILabel *textClicks=(UILabel *)[Overlay viewWithTag:12];
    UIImageView *ImgViewClicks=(UIImageView *)[Overlay viewWithTag:13];
    
    CGRect rectChatOverlayImgView = ImgViewClicks.frame;
    CGRect rectChatOverlayText = textClicks.frame;
    CGRect rectChatOverlay = Overlay.frame;
    rectChatOverlay.origin.y += 215;
    
    CGRect rectChatBgwhite = self.ChatBgWhiteView.frame;
    rectChatBgwhite.origin.y += 215;
    CGRect rectChatBg = self.ChatBgImgView.frame;
    rectChatBg.origin.y += 215;
    CGRect rectFild = self.sendMessageField.frame;
    rectFild.origin.y += 215;
    CGRect rectButton = self.sendMessageButton.frame;
    rectButton.origin.y += 215;
    
    CGRect rectContentButton = self.ContentButton.frame;
    rectContentButton.origin.y += 215;
    
    CGRect rectMediaAttachmentButton = self.mediaAttachButton.frame;
    rectMediaAttachmentButton.origin.y += 215;
    
    CGRect rectAttachementScrollView = attachmentAnimationView.frame;
    rectAttachementScrollView.origin.y += 215;
    
    CGRect rectAudioRecordView = startRecordingView.frame;
    rectAudioRecordView.origin.y += 215;
    
    CGRect rectTableView = self.tableView.frame;
  
    if (IS_IPHONE_5)
    {
        rectChatOverlayImgView.origin.y -= 100;
        rectChatOverlayText.origin.y -= 100;
        rectTableView.size.height = 382;
    }
    else
    {
        rectChatOverlayImgView.origin.y -= 110;
        rectChatOverlayText.origin.y -= 110;
        rectTableView.size.height = 315;
    }
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [ImgViewClicks setFrame:rectChatOverlayImgView];
                         [textClicks setFrame:rectChatOverlayText];
                         [Overlay setFrame:rectChatOverlay];
                         [self.ChatBgWhiteView setFrame:rectChatBgwhite];
                         [self.sendMessageField setFrame:rectFild];
                         [self.sendMessageButton setFrame:rectButton];
                         [self.ContentButton setFrame:rectContentButton];
                         [self.ChatBgImgView setFrame:rectChatBg];
                         [self.mediaAttachButton setFrame:rectMediaAttachmentButton];
                         [self.tableView setFrame:rectTableView];
                         [attachmentAnimationView setFrame:rectAttachementScrollView];
                         [startRecordingView setFrame:rectAudioRecordView];
                     }
     ];
}

/*- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
*/

-(void)handleImageTap:(id)sender
{
    
}


-(void)showFullScreenPicture:(id)sender
{
    NSLog(@"%lu",(unsigned long)messages.count);
    UIButton* img_btn = (UIButton*)sender;
    UITableViewCell *cell ;
    //= (UITableViewCell *)[[[[img_btn superview] superview] superview] superview];
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[img_btn superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[[img_btn superview] superview] superview];
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)indexPath.row);
    
    QBChatMessage *message;
    if(messages.count < 20)
    {
        message= [messages objectAtIndex:indexPath.row];
    }
    else
    {
        message= [messages objectAtIndex:indexPath.row-1];
    }
    
    PhotoViewController* photoController = [[PhotoViewController alloc] initWithImage:img_btn.imageView.image];
    photoController.messageID = message.ID;
    [self.navigationController pushViewController:photoController animated:YES];
    photoController =nil;
}

-(void) playAudio:(id)sender
{
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
    {
        isMusicPlaying = true;
        [[MPMusicPlayerController iPodMusicPlayer] pause];
    }
    else
        isMusicPlaying = false;
    
    
    UIButton* play_btn = (UIButton*)sender;
    
    QBChatMessage *messageBody;
    messageBody= [messages objectAtIndex:play_btn.tag];
    
    MPMoviePlayerViewController *mpvc;
    if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"shareStatus"] length]>0)
    {
        if([(NSData*)[audioData objectAtIndex:play_btn.tag] length]==0)
        {               mpvc = [[MPMoviePlayerViewController alloc] init];
            mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
            [mpvc.moviePlayer setContentURL:[NSURL URLWithString:messageBody.customParameters[@"audioID"]]];
            
            dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
            dispatch_async(downloadQueue, ^{
                NSData *_audioData;
                if([messageBody.customParameters[@"audioID"] length]>1)
                    _audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageBody.customParameters[@"audioID"]]];
                else
                    _audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageBody.customParameters[@"audioStreamURL"]]];
                
            dispatch_async(dispatch_get_main_queue(), ^{
            [audioData replaceObjectAtIndex:play_btn.tag withObject:_audioData];
            });
    
        });
        }
        else
        {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"my_Audio.m4a"];
            
            [[audioData objectAtIndex:play_btn.tag] writeToFile:path atomically:YES];
            NSURL *audioUrl = [NSURL fileURLWithPath:path];
            
            
            mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:audioUrl];
            mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
            
            /*
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *path = [documentsDirectory stringByAppendingPathComponent:@"my_Audio.mp4"];
            NSError *error = nil;
            [[audioData objectAtIndex:play_btn.tag] writeToFile:path atomically:YES];
            
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* foofile = [documentsPath stringByAppendingPathComponent:@"my_Audio.mp4"];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
            
            if (fileExists)
            {
                NSLog(@"The file is");
            }
           
            NSURL *audioUrl = [NSURL fileURLWithPath:path];
            NSData *Data=[[NSData alloc] initWithContentsOfURL:audioUrl];
            player = [[AVAudioPlayer alloc] initWithData:Data
                                                             error:&error];
            if (error)
            {
                NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
            }
            else
            {
                player.numberOfLoops = 0; //Infinite
                player.delegate=self;
                [player play];
            }
             */
        }
    }
    else
    {
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"my_Audio.mp4"];
        NSError *error = nil;
        [[audioData objectAtIndex:play_btn.tag] writeToFile:path atomically:YES];
        NSURL *audioUrl = [NSURL fileURLWithPath:path];
        
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl
                                                                       error:&error];
        if (error)
        {
            NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
        }
        else
        {
        player.numberOfLoops = 0; //Infinite
        player.delegate=self;
        [player play];
        }
         */
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"my_Audio.m4a"];
        
        [[audioData objectAtIndex:play_btn.tag] writeToFile:path atomically:YES];
        NSURL *audioUrl = [NSURL fileURLWithPath:path];
        
        mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:audioUrl];
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        
    }
    
    [mpvc.moviePlayer prepareToPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:mpvc  name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    [self presentMoviePlayerViewControllerAnimated:mpvc] ;
    mpvc = nil;

    /*
    
    if(player!=nil)
        player = nil;
    
    if([messageBody.customParameters[@"audioID"] length]>1)
    {
        //NSData *_audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageBody.customParameters[@"audioID"]]];
        //player = [[AVAudioPlayer alloc] initWithData:_audioData error:nil];
        //_audioData=nil;
     
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSData *_audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageBody.customParameters[@"audioID"]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                player = [[AVAudioPlayer alloc] initWithData:_audioData error:nil];
                
                [player setDelegate:self];
                [player setVolume:1];
                [player setNumberOfLoops:0];
                [player prepareToPlay];
                [player play];
                audioData = nil;
            });
        });
    }
    else
    {
        player = [[AVAudioPlayer alloc] initWithData:[audioData objectAtIndex:play_btn.tag] error:nil];
        [player setDelegate:self];
        [player setVolume:1];
        [player setNumberOfLoops:0];
        [player prepareToPlay];
        [player play];

    }*/
}
/*
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}*/

-(void)showFullScreenVideo:(id)sender
{
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
    {
        isMusicPlaying = true;
        [[MPMusicPlayerController iPodMusicPlayer] pause];
    }
    else
        isMusicPlaying = false;
    
    
    
    UIButton* play_btn = (UIButton*)sender;
    
    
    QBChatMessage *messageBody;
    messageBody= [messages objectAtIndex:play_btn.tag];
    
    
    MPMoviePlayerViewController *mpvc;
    if([messageBody.customParameters[@"videoID"] length]>1)
    {
        mpvc = [[MPMoviePlayerViewController alloc] init];
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [mpvc.moviePlayer setContentURL:[NSURL URLWithString:messageBody.customParameters[@"videoID"]]];
    }
    else
    {
        if([messageBody.customParameters[@"shareStatus"] length]==0)
        {
            mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:messageBody.customParameters[@"videoURL"]]];
            mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        }
        else
        {
            mpvc = [[MPMoviePlayerViewController alloc] init];
            mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
            [mpvc.moviePlayer setContentURL:[NSURL URLWithString:messageBody.customParameters[@"videoStreamURL"]]];
        }
    }
    
    [mpvc.moviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] removeObserver:mpvc  name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    [self presentMoviePlayerViewControllerAnimated:mpvc] ;
    mpvc = nil;
}

-(void)videoFinished:(NSNotification*)aNotification
{
    
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    NSLog(@"error :%@",[aNotification.userInfo valueForKey:@"error"]);
    
    if (value == MPMovieFinishReasonUserExited) {
        
        if(isMusicPlaying)
        {
            [[MPMusicPlayerController iPodMusicPlayer] play];
            //[session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
        }
        
        [self dismissMoviePlayerViewControllerAnimated];
    }
    
    if (value == MPMovieFinishReasonPlaybackError) {
        NSLog(@"error");
    }
    
    if (value == MPMovieFinishReasonPlaybackEnded) {
        NSLog(@"Ended");
    }
}


-(void)showMapView:(UIButton*)sender
{
    ChatMessageTableViewCell *cell = (ChatMessageTableViewCell*)[[[[sender superview] superview] superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    MapWebView *Obj= [[MapWebView alloc] init];
    
    QBChatMessage *messageBody;
    
    if(isChatHistoryOrNot)
        messageBody= [messages objectAtIndex:indexPath.row-1];
    else
        messageBody= [messages objectAtIndex:indexPath.row];
    
    if([messageBody.customParameters[@"location_coordinates"] length]>0)
        Obj.location_coordinates = messageBody.customParameters[@"location_coordinates"];
    
    //[self.navigationController pushViewController:Obj animated:YES];
    [self presentViewController:Obj animated:YES completion:nil];
    
    Obj = nil;

}

#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

static CGFloat padding = 20.0;
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cell for row %d",[self.messages count]);
	static NSString *CellIdentifier = @"MessageCellIdentifier";

    // Create cell
	ChatMessageTableViewCell *cell = (ChatMessageTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
		cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:CellIdentifier];
	}
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = YES;
    cell.contentView.userInteractionEnabled=YES;
    
    if(isChatHistoryOrNot == TRUE)
    {
        if(indexPath.row == 0)
        {
            cell.load_earlierBtn.frame = CGRectMake(0,2,320,65/2);
            [cell.load_earlierBtn setBackgroundImage:[UIImage imageNamed:@"ChatLoadEariler.png"] forState:UIControlStateNormal];
            [cell.load_earlierBtn addTarget:self action:@selector(loadearlierButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            cell.message.frame = CGRectZero;
            cell.shareHeading.frame = CGRectZero;
            cell.shareBarImgView.frame = CGRectZero;
            cell.shareAccepted.frame = CGRectZero;
            cell.shareRejected.frame = CGRectZero;
            cell.date.frame = CGRectZero;
            cell.backgroundImageView.frame = CGRectZero;
            cell.bubbleImageView.frame = CGRectZero;
            cell.bubbleImageView.hidden = YES;
            cell.clicksImageView.frame = CGRectZero;
            cell.imageSentView.frame = CGRectZero;
            cell.PhotoView.frame = CGRectZero;
            cell.VideoSentView.frame = CGRectZero;
            cell.ThumbnailPhotoView.frame = CGRectZero;
            cell.play_btn.frame=CGRectZero;
            cell.sound_iconView.frame=CGRectZero;
            cell.sound_bgView.frame=CGRectZero;
            cell.downloadingView.frame = CGRectZero;
            [cell.share_btn setImage:nil forState:UIControlStateNormal];
            [cell.share_btn setFrame:CGRectZero];
            cell.LocationView.frame = CGRectZero;
            cell.LocationSentView.frame = CGRectZero;
            cell.cardAccepted.frame=CGRectZero;
            cell.cardAcceptedView.frame=CGRectZero;
            cell.cardBarView.frame=CGRectZero;
            cell.cardBottomClicks.frame=CGRectZero;
            cell.cardContent.frame=CGRectZero;
            cell.cardCountered.frame=CGRectZero;
            cell.cardHeading.frame=CGRectZero;
            cell.cardImageView.frame=CGRectZero;
            cell.cardPlayed_Countered.frame=CGRectZero;
            cell.cardRejected.frame=CGRectZero;
            cell.cardSender.frame=CGRectZero;
            cell.cardTopClicks.frame=CGRectZero;
            cell.deliveredIcon.frame=CGRectZero;
        }
        else
        {
            cell.bubbleImageView.hidden = NO;
            cell.load_earlierBtn.frame = CGRectZero;
            // Message
            
           // NSLog(@"cellForRowIndex %d",[indexPath row]-1);
            
            QBChatMessage *messageBody = [messages objectAtIndex:[indexPath row]-1];
            NSString *message;
            
            NSString *StrClicks = messageBody.customParameters[@"clicks"];
            
            NSLog(@"%@",StrClicks);
            
            if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
            {
                // set message's text
                message = [messageBody text];
                if(message== (NSString*)[NSNull null])
                {
                    message = @"";
                    cell.message.text = @"";
                }
                else
                    cell.message.text = message;
                cell.message.textColor = [UIColor blackColor];
                cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                cell.date.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:11.0];
            }
            else
            {
                message = [messageBody text];
                
                if(message== (NSString*)[NSNull null])
                    message = @"";
                
                // font setting when sending the clicks
                
                UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
                UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
//              UIColor *foregroundColor = [UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
                UIColor *foregroundColor = [UIColor whiteColor];
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       boldFont, NSFontAttributeName,nil];
                NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
                const NSRange range = NSMakeRange(0,[StrClicks length]);
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:message
                                                       attributes:attrs];
                [attributedText setAttributes:subAttrs range:range];
                [cell.message setAttributedText:attributedText];
            }
            
            //check for image sent
            
            if([messageBody.customParameters[@"fileID"] length]>1)// image
            {
                cell.PhotoView.image=nil;
                cell.PhotoView.frame = CGRectZero;
                cell.PhotoView.alpha = 1;
                cell.downloadingView.frame = CGRectZero;
                [cell.imageSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight ;
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                else
                    imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
                {
                    cell.imageSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.imageSentView.layer.borderWidth = 2.0f;
                        cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.imageSentView.layer.borderWidth = 2.0f;
                        cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    cell.imageSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                }
                
                cell.imageSentView.enabled=false;
                
                cell.PhotoView.frame=cell.imageSentView.frame;
            
                [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"fileID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    if (!error)
                    {
                        [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                        cell.imageSentView.enabled=true;
                        cell.PhotoView.alpha = 0;
                    }
                    
                    if(error)
                    {
                        NSLog(@"Error %@",error.description);
                    }}
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
                 ];
         
          // Commented 3 Dec
//                [cell.PhotoView sd_setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"fileID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
//                {
//                    [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
//                    cell.imageSentView.enabled=true;
//                    cell.PhotoView.alpha = 0;
//                    if(error)
//                    {
//                        NSLog(@"Fass gya");
//                    }} usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                //[cell.imageSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                //[cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                [cell.imageSentView addTarget:self action:@selector(showFullScreenPicture:)
                             forControlEvents:UIControlEventTouchUpInside];
                
                /*
                 //calculate the correct position
                 
                 cell.downloadingView.frame = CGRectMake(cell.imageSentView.frame.origin.x + cell.imageSentView.frame.size.width/2 - 25, cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height/2 -25,50,50);
                 [cell.downloadingView startAnimating];
                 
                 if([[imagesData objectAtIndex:indexPath.row] length]>0)
                 [cell.downloadingView stopAnimating];*/
                
            }
            else if([messageBody.customParameters[@"isFileUploading"] length]>0)
            {
                cell.PhotoView.image=nil;
                cell.PhotoView.frame = CGRectZero;
                cell.PhotoView.alpha = 1;
                [cell.imageSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight;
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                else
                    imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.imageSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    if([messageBody.customParameters[@"shareStatus"] length]==0)
                    {
                        [cell.imageSentView setImage:[UIImage imageWithData:((NSData*)[imagesData objectAtIndex:indexPath.row-1])] forState:UIControlStateNormal];
                    }
                    else
                    {
                        cell.imageSentView.enabled=false;
                        [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                        {
                             [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                            cell.imageSentView.enabled=true;
                            cell.PhotoView.alpha = 0;
                            if(error)
                            {
                                NSLog(@"Fass gya");
                            }
                        }
                            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    }
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.imageSentView.layer.borderWidth = 2.0f;
                        cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.imageSentView.layer.borderWidth = 2.0f;
                        cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }

                    cell.imageSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                    
                    [cell.imageSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]] forState:UIControlStateNormal];
                }
                
              //cell.PhotoView.frame=cell.imageSentView.frame;
                
              //[cell.PhotoView setImageWithURL:[imagesURL objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"loading.png"]];
                
                NSLog(@"%ld",(long)indexPath.row);
                NSLog(@"%lu",(unsigned long)[imagesData count]);
                NSLog(@"%lu",(unsigned long)[self.messages count]);
                
                
                [cell.imageSentView addTarget:self action:@selector(showFullScreenPicture:)                               forControlEvents:UIControlEventTouchUpInside];
                
                
                /*cell.PhotoView.frame=cell.imageSentView.frame;
                cell.PhotoView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]];
                
                UITapGestureRecognizer *tapRecognizer;
                tapRecognizer=[[UITapGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(handleImageTap:)];
                tapRecognizer.numberOfTapsRequired=1;
                tapRecognizer.numberOfTouchesRequired=1;
                tapRecognizer.delegate = self;
                [cell.PhotoView addGestureRecognizer:tapRecognizer];
                tapRecognizer = nil;*/
                
                /*bool earlier_uploaded = false;
                for(int i=0;i<imagesUploading_indexes.count;i++)
                {
                    if([[[imagesUploading_indexes objectAtIndex:i] objectForKey:@"index"] integerValue] == indexPath.row)
                    {
                        earlier_uploaded = true;
                        break;
                    }
                }
                if(earlier_uploaded==false)
                {
                    cell.downloadingView.frame = CGRectMake(cell.imageSentView.frame.origin.x + cell.imageSentView.frame.size.width/2 - 25, cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height/2 -25,50,50);
                    [cell.downloadingView startAnimating];
                }*/
            }
            else
            {
                [cell.imageSentView setImage:nil forState:UIControlStateNormal];
                cell.imageSentView.frame=CGRectZero;
                
                cell.PhotoView.image=nil;
                cell.PhotoView.frame=CGRectZero;
                cell.PhotoView.alpha = 1;
                cell.downloadingView.frame = CGRectZero;
            }
            
            // check for video sent
            if([messageBody.customParameters[@"videoID"] length]>1)
            {
                /*cell.ThumbnailPhotoView.image=nil;
                cell.ThumbnailPhotoView.frame = CGRectZero;
                [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
                cell.ThumbnailPhotoView.frame = CGRectZero;*/
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.VideoSentView.frame=CGRectMake(320 - padding -175, padding-12, 175, 175);
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.VideoSentView.layer.borderWidth = 2.0f;
                        cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.VideoSentView.layer.borderWidth = 2.0f;
                        cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    cell.VideoSentView.frame=CGRectMake(padding, padding-12, 175, 175);
                }
                
                cell.VideoSentView.enabled=false;
                
                cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
                
                if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                    [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"videoThumbnail"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                         [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                    cell.VideoSentView.enabled=true;
                }
                     
                usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                cell.VideoSentView.tag = indexPath.row-1;
                [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                             forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if([messageBody.customParameters[@"isVideoUploading"] integerValue]==1 )
            {
                /*cell.ThumbnailPhotoView.image=nil;
                cell.ThumbnailPhotoView.frame = CGRectZero;
                [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
                cell.ThumbnailPhotoView.frame = CGRectZero;*/
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;

                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.VideoSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    if([messageBody.customParameters[@"shareStatus"] length]==0)
                    {
                        cell.ThumbnailPhotoView.frame = cell.VideoSentView.frame;
                        cell.ThumbnailPhotoView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]] ;
                    }
                    else
                    {
                        NSLog(@"Came into this ");
                        cell.VideoSentView.enabled=false;
                        
                        cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
                        
                        if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                            [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                        {
                                [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                            cell.VideoSentView.enabled=true;
                        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
                        ];
                    }
                }
                else
                {
                 
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.VideoSentView.layer.borderWidth = 2.0f;
                        cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.VideoSentView.layer.borderWidth = 2.0f;
                        cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    cell.VideoSentView.frame=CGRectMake(padding, padding-12, 175, 175);
                    
                    cell.ThumbnailPhotoView.frame = cell.VideoSentView.frame;
                    cell.ThumbnailPhotoView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]] ;
                }
                
                
                
                [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                
                cell.VideoSentView.enabled=true;
                cell.VideoSentView.tag = indexPath.row-1;
                [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                             forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
                cell.VideoSentView.frame=CGRectZero;
                cell.ThumbnailPhotoView.image=nil;
                cell.ThumbnailPhotoView.frame=CGRectZero;
            }
            
            
            //audio data
            if([messageBody.customParameters[@"audioID"] length]>1)
            {
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.sound_bgView.frame=CGRectMake(320 - padding -175, padding-12, 175, 50);
                    cell.sound_iconView.frame=CGRectMake(320 - padding -120, padding-9, 100, 44);
                    cell.play_btn.frame = CGRectMake(320 - padding - 170, padding-12, 40, 50);
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.sound_bgView.layer.borderWidth = 2.0f;
                        cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.sound_bgView.layer.borderWidth = 2.0f;
                        cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    
                    cell.sound_bgView.frame=CGRectMake(padding , padding-12, 175, 50);
                    cell.sound_iconView.frame=CGRectMake(padding + 60, padding-9, 100, 44);
                    cell.play_btn.frame = CGRectMake(padding + 10, padding-12, 40, 50);
                }
                
                //[cell.slider setThumbImage: [UIImage imageNamed:@"sliderhandle.png"] forState:UIControlStateNormal];
                cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
                
                cell.play_btn.tag = indexPath.row-1;
                [cell.play_btn setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                [cell.play_btn addTarget:self action:@selector(playAudio:)
                             forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if([messageBody.customParameters[@"isAudioUploading"] length]>0)
            {
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.sound_bgView.frame=CGRectMake(320 - padding -175, padding-12, 180, 50);
                    cell.sound_iconView.frame=CGRectMake(320 - padding -120, padding-9, 100, 44);
                    cell.play_btn.frame = CGRectMake(320 - padding - 170, padding-12, 40, 50);
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.sound_bgView.layer.borderWidth = 2.0f;
                        cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.sound_bgView.layer.borderWidth = 2.0f;
                        cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    
                    cell.sound_bgView.frame=CGRectMake(padding , padding-12, 175, 50);
                    cell.sound_iconView.frame=CGRectMake(padding + 60, padding-9, 100, 44);
                    cell.play_btn.frame = CGRectMake(padding + 10, padding-12, 40, 50);
                }

                
                //[cell.slider setThumbImage: [UIImage imageNamed:@"sliderhandle.png"] forState:UIControlStateNormal];
                cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
                
                cell.play_btn.tag = indexPath.row-1;
                [cell.play_btn setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                [cell.play_btn addTarget:self action:@selector(playAudio:)
                        forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                [cell.play_btn setImage:nil forState:UIControlStateNormal];
                cell.play_btn.frame=CGRectZero;
                
                cell.sound_iconView.frame=CGRectZero;
                cell.sound_bgView.frame=CGRectZero;
                //[cell.slider setThumbImage: [[UIImage alloc] init] forState:UIControlStateNormal];
            }
            
            
            if([messageBody.customParameters[@"locationID"] length]>1)
            {
                cell.LocationView.image=nil;
                cell.LocationView.frame = CGRectZero;
                cell.LocationView.alpha = 1;
                cell.downloadingView.frame = CGRectZero;
                [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight;
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                else
                {
                    imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
                }
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.LocationSentView.frame=CGRectMake(320-padding-175, padding-12,175, 175);
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.LocationSentView.layer.borderWidth = 2.0f;
                        cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.LocationSentView.layer.borderWidth = 2.0f;
                        cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    cell.LocationSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                }
                
                cell.LocationSentView.enabled=false;
                
                cell.LocationView.frame=cell.LocationSentView.frame;
                
                [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"locationID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    if (!error)
                    {
                        [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal];
                        cell.LocationSentView.enabled=true;
                        cell.LocationView.alpha = 0;
                    }
                }
            usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                [cell.LocationSentView addTarget:self action:@selector(showMapView:)
                             forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            else if([messageBody.customParameters[@"isLocationUploading"] length]>0)
            {
                cell.LocationView.image=nil;
                cell.LocationView.frame = CGRectZero;
                cell.LocationView.alpha = 1;
                [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight;
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                else
                    imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];

                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.LocationSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    if([messageBody.customParameters[@"shareStatus"] length]==0)
                    {
                        [cell.LocationSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]] forState:UIControlStateNormal];
                    }
                    else
                    {
                        cell.LocationSentView.enabled=false;
                        
                        cell.LocationView.frame=cell.LocationSentView.frame;
                        
                        [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                        {
                            [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal];
                            cell.LocationSentView.enabled=true;
                            cell.LocationView.alpha = 0;
                        }
                               usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                    }
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.LocationSentView.layer.borderWidth = 2.0f;
                        cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    }
                    else
                    {
                        cell.LocationSentView.layer.borderWidth = 2.0f;
                        cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    cell.LocationSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                    
                    [cell.LocationSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row-1]] forState:UIControlStateNormal];
                }
                
                NSLog(@"%d",indexPath.row);
                NSLog(@"%d",[imagesData count]);
                NSLog(@"%d",[self.messages count]);
                
                [cell.LocationSentView addTarget:self action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
                cell.LocationSentView.frame=CGRectZero;
                
                cell.LocationView.image=nil;
                cell.LocationView.frame=CGRectZero;
                cell.LocationView.alpha = 1;
                
                cell.downloadingView.frame = CGRectZero;
            }


            
            // message's datetime
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
            NSString *OldTime = [formatter stringFromDate:messageBody.datetime];
            NSString *time;
            //..NSLog(@"%@",[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]]);
            if([[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]] isEqualToString:@"pm"])
            {
                time = [OldTime substringToIndex:[OldTime length]-2];
                time = [time stringByAppendingString:@"PM"];
            }
            else
            {
                time = [OldTime substringToIndex:[OldTime length]-2];
                time = [time stringByAppendingString:@"AM"];
            }
            
            CGSize textSize = { 200.0, 7690.0 };
            
            if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
            {
                textSize = CGSizeMake(150.0, 6921.0);
            }
            else if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0 || [messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
                textSize = CGSizeMake(150.0, 8651.25);

            
            
        //    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
        
         //       if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
            
            //[messageBody.customParameters[@"clicks"]];
            
            
//            [NSString stringWithFormat:@"%@%@",[messageBody.customParameters[@"clicks"]],message]
            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//            CGSize size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
//                              constrainedToSize:textSize
//                                  lineBreakMode:NSLineBreakByWordWrapping];
//            
//            
            
            CGSize size;
   /*         if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
            {
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"    "];
                
                
                NSMutableAttributedString  *tempStr = [[NSMutableAttributedString alloc] initWithAttributedString:cell.message.attributedText];
                
                [tempStr appendAttributedString:str];
                
                CGFloat width = 200.0;
                CGRect sizeRect = [tempStr boundingRectWithSize:CGSizeMake(width, 7690.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                
                size =  CGSizeMake(sizeRect.size.width, sizeRect.size.height);

            }
            else
            {
                size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                           constrainedToSize:textSize
                               lineBreakMode:NSLineBreakByWordWrapping];


            }
        */


//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"width87 : %f",textSize.width] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//            [alert show];
//            alert = nil;
            
            
            size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if(![StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
            {
                size.width+=10.0;
            }
            
//            NSLog(@"width: %f",size.width);
//            NSLog(@"height: %f",size.height);
            
            size.width += (padding/2);
            [cell setBackgroundColor:[UIColor clearColor]];
            
            // Left/Right message box
            UIImage *bgImage = nil;
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
//            NSLog(@"1:: %@",[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]);
//            NSLog(@"2:: %@",[NSString stringWithFormat:@"%@",[prefs stringForKey:@"partner_QB_id"]]);
            
            if([messageBody.customParameters[@"card_heading"] length]==0)
            {
                if(![[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    //bgImage = [[UIImage imageNamed:@"chatboxsml2.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:16];
                    
                    if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.imageSentView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.LocationSentView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                    {
                        cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.ThumbnailPhotoView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.sound_bgView.frame.size.height, 175, size.height+padding);
                    }
                    else
                        [cell.message setFrame:CGRectMake(320 - size.width - padding,
                                                      padding-13,
                                                      size.width+padding-20,
                                                      size.height+padding)];
                    
                    
                        [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  size.width+padding,
                                                                  size.height+padding)];
                    
                    //for textview side bubble
                    [cell.bubbleImageView setFrame:CGRectMake((self.view.frame.size.width - padding*1.22f)+2,
                                                              cell.message.frame.origin.y+cell.message.frame.size.height-35,
                                                              14,30)];
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
                    
                    //for clicks image in the textview
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        else
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                        cell.bubbleImageView.image=[UIImage imageNamed:@"right_red_bubble-1.png"];
                        cell.message.textColor = [UIColor whiteColor];
                        
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    }
                    else
                    {
                        [cell.message setBackgroundColor:[UIColor whiteColor]];
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                        cell.message.layer.borderWidth = 2.0f;
                        [cell.clicksImageView setFrame:CGRectZero];
                        cell.clicksImageView.image=nil;
                    }
                    
                    cell.date.textAlignment = NSTextAlignmentRight;
                    cell.backgroundImageView.image = bgImage;
                    cell.date.text = [[NSString stringWithFormat:@"%@",time] uppercaseString];
                    [cell.date setFrame:CGRectMake((cell.message.frame.origin.x - padding/2) - 65 , size.height+padding-5  , 70, 10)];
                }
                else
                {
                    //bgImage = [[UIImage imageNamed:@"chatboxsml.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:16];
                    
                    if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(padding, padding-15 + cell.imageSentView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(padding, padding-15 + cell.LocationSentView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                    {
                        cell.message.frame=CGRectMake(padding, padding-15 + cell.ThumbnailPhotoView.frame.size.height, 175, size.height+padding);
                    }
                    else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        cell.message.frame=CGRectMake(padding, padding-15 + cell.sound_bgView.frame.size.height, 175, size.height+padding);
                    }
                    else
                        [cell.message setFrame:CGRectMake(padding, padding-13, size.width+padding-20 , size.height+padding)];
                    
                    
                        [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  size.width+padding,
                                                                  size.height+padding)];
                    
                    [cell.bubbleImageView setFrame:CGRectMake((padding*0.5f)-2,
                                                              cell.message.frame.origin.y+cell.message.frame.size.height-35,
                                                              14,30)];
                    cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                    
                    //for clicks image in the textview
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        else
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        cell.bubbleImageView.image=[UIImage imageNamed:@"left_red_bubble-1.png"];
                        cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                        cell.message.textColor = [UIColor whiteColor];
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]]; // red bubble
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    }
                    else
                    {
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                        cell.message.layer.borderWidth = 2.0f;
                        [cell.clicksImageView setFrame:CGRectZero];
                        cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                        cell.clicksImageView.image=nil;
                    }
                    
                    
                    cell.date.textAlignment = NSTextAlignmentLeft;
                    cell.backgroundImageView.image = bgImage;
                    cell.date.text = [[NSString stringWithFormat:@"%@", time] uppercaseString];
                    [cell.date setFrame:CGRectMake((size.width+padding) + 5 , size.height+padding -5 , 70, 10)];
                }
            }
            else
            {
                [cell.message setFrame:CGRectZero];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                cell.message.layer.borderWidth = 0.0f;
            }
            
            if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0 || [messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0 || [messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
            {
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.bubbleImageView.image=[UIImage imageNamed:@"right_red_bubble-1.png"];
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    }
                    else
                    {
                        cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
                        [cell.message setBackgroundColor:[UIColor whiteColor]];
                        cell.message.layer.borderWidth = 2.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    }
                    
                    if(cell.message.text.length==0)
                    {
                        if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                        {
                            [cell.date setFrame:CGRectMake(74+50 - 80, 172 , 70, 10)];
                        }
                        else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                        {
                            [cell.date setFrame:CGRectMake(75+50 - 80, 45 , 70, 10)];
                        }
                        else if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                        {
                            [cell.date setFrame:CGRectMake(74+50 - 77, cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height -15 , 70, 10)];
                        }
                        else
                        {
                            [cell.date setFrame:CGRectMake(74+50 - 77, cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height -15 , 70, 10)];
                        }
                    }
                    else
                    {
                         if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                         {
                              [cell.date setFrame:CGRectMake(74+50 - 80, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                         }
                        else
                        {
                            [cell.date setFrame:CGRectMake(74+50 - 77, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                        }
                    }
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-30, 30, 30)];
                    cell.share_btn.tag = indexPath.row-1;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        cell.bubbleImageView.image=[UIImage imageNamed:@"left_red_bubble-1.png"];
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    }
                    else
                    {
                        cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                        cell.message.layer.borderWidth = 2.0f;
                        cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    
                    if(cell.message.text.length==0)
                    {
                        if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                            [cell.date setFrame:CGRectMake(175-50 + 80, 172 , 70, 10)];
                        else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                        {
                            [cell.date setFrame:CGRectMake(175-50 + 80, 45 , 70, 10)];
                        }
                        else if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                            [cell.date setFrame:CGRectMake(175-50 + 77 , cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height -15 , 70, 10)];
                        else
                            [cell.date setFrame:CGRectMake(175-50 + 77 , cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height -15 , 70, 10)];
                    }
                    else
                    {
                        if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                        {
                            [cell.date setFrame:CGRectMake(175-50 + 80, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                        }
                        
                        else
                            [cell.date setFrame:CGRectMake(175-50 + 77, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                    }
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-30, 30, 30)];
                    cell.share_btn.tag = indexPath.row-1;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                if([messageBody.customParameters[@"isFileUploading"] length]>0  || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"isAudioUploading"] length]>0 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
                {
                    NSString *string = @".";
                    NSRange range = [messageBody.ID rangeOfString:string];

                    if(messageBody.ID.length<7 || range.location != NSNotFound)
                    {
                        cell.share_btn.hidden = true;
                        cell.downloadingView.frame = CGRectMake(cell.share_btn.frame.origin.x + cell.share_btn.frame.size.width/2 - 25, cell.share_btn.frame.origin.y + cell.share_btn.frame.size.height/2 -25,50,50);
                        [cell.downloadingView startAnimating];
                    }
                    else
                    {
                        cell.share_btn.hidden = false;
                        [cell.downloadingView stopAnimating];
                    }
                    
                    string = nil;
                }

                if((cell.message.text.length==0 && [messageBody.customParameters[@"clicks"] isEqualToString:@"no"]) || ( cell.message.text.length==0 && [messageBody.customParameters[@"clicks"]length]==0))
                {
                    [cell.message setFrame:CGRectZero];
                    
                    [cell.clicksImageView setFrame:CGRectZero];
                    cell.clicksImageView.image=nil;
                    //                [cell.message setBackgroundColor:[UIColor whiteColor]];
                    cell.message.layer.borderWidth = 2.0f;
                }
            }
            else if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
            {
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row-1;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row-1;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                cell.share_btn.hidden = false;
                [cell.downloadingView stopAnimating];
            }
            else
            {
                cell.message.layer.borderWidth = 2.0f;
                [cell.share_btn setImage:nil forState:UIControlStateNormal];
                [cell.share_btn setFrame:CGRectZero];
                cell.share_btn.hidden = false;
                [cell.downloadingView stopAnimating];
            }
            
            //-------for displaying cards------------
            if([messageBody.customParameters[@"card_heading"] length]>0)
            {
                if(![[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    [cell.message setFrame:CGRectMake(320 - 240 - padding,
                                                      padding-13,
                                                      240+padding-20,
                                                      126+padding)];
                    [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  240+padding,
                                                                  126+padding)];
                    
                    //for textview side bubble
                    [cell.bubbleImageView setFrame:CGRectMake((self.view.frame.size.width - padding*1.22f)+2,
                                                              12.5f,
                                                              14,30)]; // if right side card is availble
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
                    
                    [cell.clicksImageView setFrame:CGRectZero];
                    cell.clicksImageView.image=nil;
                    [cell.message setBackgroundColor:[UIColor whiteColor]];
                    cell.message.layer.borderWidth = 0.0f;
                    
                    cell.PhotoView.frame=CGRectZero;
                    cell.PhotoView.image=nil;
                    
                    //if([messageBody.customParameters[@"card_Played_Countered"] isEqualToString:@"PLAYED A CARD"])
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 ,cell.message.frame.origin.y + 5, 248, 326);
                    else
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  8 ,cell.message.frame.origin.y + 10, 95, 125);
                    //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
                    
                    cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
                    cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                    
                    cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
                    cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];
                    
                    cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
                    [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
                    
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
                    [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
                    
                    if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
                    {
                        cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                        cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  8 + 6 ,cell.message.frame.origin.y + 10 + 18 , 95-12, 125 -40);
                        cell.cardHeading.numberOfLines=4;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
                        cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                        cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];
                    }
                    else
                    {
                        cell.cardHeading.numberOfLines=2;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                        //cell.cardHeading.text = @"";
                        //cell.cardContent.text = @"";
                    }

                    
                    cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
                    //cell.cardSender.text = @"You";
                    
                    NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                    if([substrings count] != 0)
                    {
                        NSString *first = [substrings objectAtIndex:0];
                        cell.cardSender.text = [first uppercaseString];
                    }
                    
//                    cell.cardSender.text = [partner_name capitalizedString];
                    
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 18 - 5, 120, 40);
                    //if([messageBody.customParameters[@"card_Played_Countered"] isEqualToString:@"PLAYED A CARD"])
                    
                    NSString *card_actionText;
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                    {
                        card_actionText = @"ACCEPTED!";
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                    {
                        card_actionText = @"REJECTED!";
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                        card_actionText = @"COUNTERED CARD";
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        card_actionText = @"PLAYED A CARD";
                    
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        cell.cardPlayed_Countered.text = @"will offer you clicks for";
                    else
                        cell.cardPlayed_Countered.text = card_actionText;
                        //cell.cardPlayed_Countered.text = messageBody.customParameters[@"card_Played_Countered"];
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                    {
                        cell.cardSender.text = [NSString stringWithFormat:@"%@ made a",[cell.cardSender.text capitalizedString]];
                        cell.cardPlayed_Countered.text = @"COUNTER OFFER";
                    }
                    
                    
//                    cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 48 - 5, 195/2, 2);
                    // Changed 18 Nov gurkaran
                    cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 48 - 5, 195/2, 2);
                    cell.cardBarView.image = [UIImage imageNamed:@"bar.png"];
                    
                    cell.date.textAlignment = NSTextAlignmentRight;
                    cell.backgroundImageView.image = bgImage;
                    cell.date.text = [[NSString stringWithFormat:@"%@",time] uppercaseString];
                    [cell.date setFrame:CGRectMake(-14 , 145 , 70, 10)];
                    
                    
                    //if([messageBody.customParameters[@"card_Played_Countered"] isEqualToString:@"PLAYED A CARD"])
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    {
                        [cell.message setFrame:CGRectMake(320 - 250 - padding,
                                                          padding-13,
                                                          250+padding-20,
                                                          388+padding)];
                        [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                                      cell.message.frame.origin.y+10 - padding/2,
                                                                      250+padding,
                                                                      388+padding)];
                        
                        if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"false"])
                        {
                            cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 + 11 ,cell.message.frame.origin.y + 5 + 7, 248 - 22, 326 - 14);
                            //cell.cardImageView.image = [UIImage imageNamed:@"savewater.png"];
                            [cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            cell.cardHeading.frame = CGRectZero;
                            cell.cardHeading.numberOfLines=2;
                            cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                            [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                            [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];

                            cell.cardContent.frame = CGRectZero;
                            
                            cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 8, 36, 36);
                            cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 75, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 44, 36, 36);
                            
                        }
                        else
                        {
                            cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x -  1.5 + 7 ,cell.message.frame.origin.y + 5 + 3, 248 -14, 326 - 9);
                            cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                            //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  25 ,cell.message.frame.origin.y + 5  + 48, 248-48, 326-100);
                            cell.cardHeading.numberOfLines=4;
                            cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                            [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:24]];
                            [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                            cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 14, cell.cardImageView.frame.origin.y + 9, 36, 36);
                            cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 82, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 55, 36, 36);
                        }
                        
                        cell.cardContent.frame = CGRectZero;
                        [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                        
                        
                        [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                        
                        
                        CGSize textSize = {120,18};
                        CGSize size = [cell.cardSender.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]
                                constrainedToSize:textSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
                        
                        
                        
                        cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + 15, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2 , size.width + 15, 40);
                        cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardSender.frame.size.width + 5 , cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2, 120, 40);
                        
//                        cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + 15, cell.cardImageView.frame.origin.y , size.width + 15, 40);
//                         cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardSender.frame.size.width + 5 , cell.cardImageView.frame.origin.y, 120, 40);
                        cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + 12 - 10, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 28 , 224, 2);
                        
                        [cell.date setFrame:CGRectMake(-20.5f,404, 70, 10)];

                        
                    }
                    
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                    {
                        cell.cardAccepted.frame=CGRectZero;
                        cell.cardRejected.frame=CGRectZero;
                        cell.cardCountered.frame=CGRectZero;
                        
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19+ 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                        cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                        
                        [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                        cell.share_btn.tag = indexPath.row;
                        [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                    {
                        cell.cardAccepted.frame=CGRectZero;
                        cell.cardRejected.frame=CGRectZero;
                        cell.cardCountered.frame=CGRectZero;
                        
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                        cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                        
                        [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                        cell.share_btn.tag = indexPath.row;
                        [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else
                    {
                        cell.cardAcceptedView.frame = CGRectZero;
                        cell.cardAcceptedView.image = nil;
                        
                        [cell.share_btn setImage:nil forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectZero];
                        
                        cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardAccepted.tag=indexPath.row-1;
                        [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                        //[cell.cardAccepted setEnabled:true];
                        [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardRejected.tag=indexPath.row-1;
                        [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                        //[cell.cardRejected setEnabled:true];
                        [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20 - 4, cell.cardImageView.frame.origin.y + 98 - 5 - 4, 188/2, 41);
                        cell.cardCountered.tag=indexPath.row-1;
                        [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                        //[cell.cardCountered setEnabled:true];
                        [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
                        
                        //if([messageBody.customParameters[@"card_Played_Countered"] isEqualToString:@"PLAYED A CARD"])
                        if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        {
                            cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 + 3 , 32, 32);
                            cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20 + 50, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 + 3 , 32, 32);
                            cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + 138 - 4, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 - 4 + 3 , 188/2, 41);
                        }

                        
                        
                        for(int i=0;i<card_accept_status.count;i++)
                        {
                            if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==indexPath.row-1)
                            {
                                if([[[card_accept_status objectAtIndex:i] objectForKey:@"status"] intValue]==1)
                                {
                                    [cell.cardAccepted setEnabled:false];
                                    [cell.cardRejected setEnabled:false];
                                    [cell.cardCountered setEnabled:false];
                                }
                                else
                                {
                                    if([messageBody.customParameters[@"card_originator"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]] && [messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                                    {
                                        [cell.cardAccepted setEnabled:false];
                                        [cell.cardRejected setEnabled:false];
                                        [cell.cardCountered setEnabled:false];
                                    }
                                    else
                                    {
                                        [cell.cardAccepted setEnabled:true];
                                        [cell.cardRejected setEnabled:true];
                                        [cell.cardCountered setEnabled:true];
                                    }

                                }
                            }
                        }
                    }
                    
                    
                }
                else
                {

                    [cell.message setFrame:CGRectMake(padding, padding-13, 240+padding-20 , 126+padding)];
                    [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  240+padding,
                                                                  126+padding)];
                    
                    [cell.bubbleImageView setFrame:CGRectMake((padding*0.5f)-2,
                                                              9.8f,
                                                              14,30)];//// if left side card is availble
                    cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                    
                    [cell.clicksImageView setFrame:CGRectZero];
                    cell.clicksImageView.image=nil;
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                    cell.message.layer.borderWidth = 2.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    
                    cell.PhotoView.frame=CGRectZero;
                    cell.PhotoView.image=nil;
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 ,cell.message.frame.origin.y + 5, 248, 326);
                    else
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  8 ,cell.message.frame.origin.y + 10, 95, 125);
                    
                    cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
                    //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
                    cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                    
                    cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
                    cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];
                    
                    cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
                    [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
                    
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
                    [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
                    
                    if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
                    {
                        cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                        cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  8 + 6 ,cell.message.frame.origin.y + 10 +18 , 95-12, 125 -40);
                        cell.cardHeading.numberOfLines=4;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
                        cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                        cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];

                    }
                    else
                    {
                        cell.cardHeading.numberOfLines=2;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                        //cell.cardHeading.text = @"";
                        //cell.cardContent.text = @"";
                    }
                    
                    
                    cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
                    //cell.cardSender.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"partner_name"] capitalizedString];
                    cell.cardSender.text = @"You";
                    
                    
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 18 - 5, 120, 40);
                    
                    
                    NSString *card_actionText;
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                    {
                        card_actionText = @"ACCEPTED!";
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                    {
                        card_actionText = @"REJECTED!";
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                        card_actionText = @"COUNTERED CARD";
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        card_actionText = @"PLAYED A CARD";
                    
                    
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        cell.cardPlayed_Countered.text = @"will offer you clicks for";
                    else
                        cell.cardPlayed_Countered.text = card_actionText;
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                    {
                        cell.cardSender.text = @"You made a";
                        cell.cardPlayed_Countered.text = @"COUNTER OFFER";
                    }
                    
                    
                    cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 48 - 8, 195/2, 8);
                    cell.cardBarView.image = [UIImage imageNamed:@"chatBar.png"];
                    
                    cell.date.textAlignment = NSTextAlignmentLeft;
                    cell.backgroundImageView.image = bgImage;
                    cell.date.text = [[NSString stringWithFormat:@"%@", time] uppercaseString];
                    [cell.date setFrame:CGRectMake(320-55,145, 70, 10)];
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    {
                        [cell.message setFrame:CGRectMake(padding, padding-13, 250+padding-20 , 388+padding - 72)];
                        [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                                      cell.message.frame.origin.y+10 - padding/2,
                                                                      250+padding,
                                                                      388+padding - 72)];

                        
                        if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"false"])
                        {
                            cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 + 11,cell.message.frame.origin.y + 5 + 7, 248 -22, 326 - 14);
                            //cell.cardImageView.image = [UIImage imageNamed:@"savewater.png"];
                            [cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            cell.cardHeading.frame = CGRectZero;
                            cell.cardHeading.numberOfLines=2;
                            cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                            [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                            [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                            cell.cardContent.frame = CGRectZero;
                            cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 8, 36, 36);
                            cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 75, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 44, 36, 36);
                        }
                        else
                        {
                            cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x -  1.5 +7 ,cell.message.frame.origin.y + 5 + 3, 248-14, 326 - 9);
                            cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                            //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                            cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  25 ,cell.message.frame.origin.y + 5  + 48, 248-48, 326-100);
                            cell.cardHeading.numberOfLines=4;
                            cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                            [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:24]];
                            [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                            cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 14, cell.cardImageView.frame.origin.y + 9, 36, 36);
                            cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 82, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 55, 36, 36);
                        }

                        cell.cardContent.frame = CGRectZero;
                        
                        [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                        
                        
                        [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                        
                        cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + 15, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2 , 40, 40);
                        cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardSender.frame.size.width + 5, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2, 150, 40);
                        cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + 12, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 28 , 224, 2);
                        
                        [cell.date setFrame:CGRectMake(320-49,404 - 72, 70, 10)];
                        
                    }

                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                    {
                        cell.cardAccepted.frame=CGRectZero;
                        cell.cardRejected.frame=CGRectZero;
                        cell.cardCountered.frame=CGRectZero;
                        
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                        cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                        
                        [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                        cell.share_btn.tag = indexPath.row;
                        [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                    else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                    {
                        cell.cardAccepted.frame=CGRectZero;
                        cell.cardRejected.frame=CGRectZero;
                        cell.cardCountered.frame=CGRectZero;
                        
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                        cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                        
                        [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                        cell.share_btn.tag = indexPath.row;
                        [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                        
                    }
                    /*else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                    {
                        cell.cardAcceptedView.frame = CGRectZero;
                        cell.cardAcceptedView.image = nil;
                        
                        cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardAccepted.tag=indexPath.row-1;
                        [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                        [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardRejected.tag=indexPath.row-1;
                        [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                        [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 98 - 5, 172/2, 33);
                        cell.cardCountered.tag=indexPath.row-1;
                        [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                        [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell.cardAccepted setEnabled:false];
                        [cell.cardRejected setEnabled:false];
                        [cell.cardCountered setEnabled:false];

                    }*/
                    else
                    {
                        cell.cardAcceptedView.frame = CGRectZero;
                        cell.cardAcceptedView.image = nil;
                        
                        [cell.share_btn setImage:nil forState:UIControlStateNormal];
                        [cell.share_btn setFrame:CGRectZero];
                        
                        cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardAccepted.tag=indexPath.row-1;
                        [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                        [cell.cardAccepted setEnabled:false];
                        [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                        cell.cardRejected.tag=indexPath.row-1;
                        [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                        [cell.cardRejected setEnabled:false];
                        [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                    forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20 - 4, cell.cardImageView.frame.origin.y + 98 - 5 - 4, 188/2, 41);
                        cell.cardCountered.tag=indexPath.row-1;
                        [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                        [cell.cardCountered setEnabled:false];
                        [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                     forControlEvents:UIControlEventTouchUpInside];
                        
                        cell.cardAccepted.frame = CGRectZero;
                        cell.cardRejected.frame = CGRectZero;
                        cell.cardCountered.frame =CGRectZero;
                        cell.cardBarView.frame = CGRectZero;
                        
                        if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                        {
                            /*cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 , 32, 32);
                            cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20 + 50, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 , 32, 32);
                            cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + 138 - 4, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 - 4 , 188/2, 41);*/
                            
                            cell.cardAccepted.frame = CGRectZero;
                            cell.cardRejected.frame = CGRectZero;
                            cell.cardCountered.frame =CGRectZero;
                            cell.cardSender.frame =CGRectZero;
                            cell.cardPlayed_Countered.frame =CGRectZero;
                        }
                        
                        
                        for(int i=0;i<card_accept_status.count;i++)
                        {
                            if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==indexPath.row-1)
                            {
                                if([[[card_accept_status objectAtIndex:i] objectForKey:@"status"] intValue]==1)
                                {
                                    [cell.cardAccepted setEnabled:false];
                                    [cell.cardRejected setEnabled:false];
                                    [cell.cardCountered setEnabled:false];
                                }
                                else
                                {
                                if([messageBody.customParameters[@"card_originator"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]] && [messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                                    {
                                        [cell.cardAccepted setEnabled:false];
                                        [cell.cardRejected setEnabled:false];
                                        [cell.cardCountered setEnabled:false];
                                    }
                                    else
                                    {
                                        [cell.cardAccepted setEnabled:true];
                                        [cell.cardRejected setEnabled:true];
                                        [cell.cardCountered setEnabled:true];
                                    }
                                }
                            }
                        }
                        
                       
                    }
                    
                    
                }
                
            }
            else
            {
                cell.cardAccepted.frame=CGRectZero;
                cell.cardAcceptedView.frame=CGRectZero;
                cell.cardBarView.frame=CGRectZero;
                cell.cardBottomClicks.frame=CGRectZero;
                cell.cardContent.frame=CGRectZero;
                cell.cardCountered.frame=CGRectZero;
                cell.cardHeading.frame=CGRectZero;
                cell.cardImageView.frame=CGRectZero;
                cell.cardPlayed_Countered.frame=CGRectZero;
                cell.cardRejected.frame=CGRectZero;
                cell.cardSender.frame=CGRectZero;
                cell.cardTopClicks.frame=CGRectZero;
                
            }
            
            /*
            if(messageBody.ID.length>=5)
                cell.share_btn.enabled = true;
            else
                cell.share_btn.enabled = false;*/
            
            if(cell.message.text.length==0 && [messageBody.customParameters[@"card_heading"] length]==0)
            {
                [cell.message setFrame:CGRectZero];
            }
            
            
            if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shared"])
            {
                cell.share_btn.frame = CGRectZero;
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                
                cell.shareHeading.frame = CGRectMake(320 - 32 - 215, 7, 215, 35);
                NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                NSString *first;
                if([substrings count] != 0)
                {
                    first = [substrings objectAtIndex:0];
                    cell.shareHeading.text = [first capitalizedString];
                }

                cell.shareHeading.text = [cell.shareHeading.text stringByAppendingString:@" wants to share"];
                    
                    UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
                    UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                    //              UIColor *foregroundColor = [UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
                    
                    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                           boldFont, NSFontAttributeName,nil];
                    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                              regularFont, NSFontAttributeName, nil];
                    const NSRange range = NSMakeRange(0,[first length]);
                    NSMutableAttributedString *attributedText =
                    [[NSMutableAttributedString alloc] initWithString:cell.shareHeading.text
                                                           attributes:attrs];
                    [attributedText setAttributes:subAttrs range:range];
                    [cell.shareHeading setAttributedText:attributedText];
                    
                    
                cell.shareBarImgView.frame = CGRectMake(320-28-220, 39, 220, 2);
                cell.shareBarImgView.image = [UIImage imageNamed:@"bar.png"];
                
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_bubble_border.png"];
                [cell.message setBackgroundColor:[UIColor clearColor]]; // owner gray chat popup
                    
                    cell.message.frame = CGRectMake(/*cell.message.frame.origin.x - 17.5f - 35*/ 320-20-228, 45, 220, cell.message.frame.size.height);
                    
                    if(cell.message.text.length == 0)
                        cell.message.frame = CGRectMake(320-20-228, 0, 0, 0);
                    
                    
                    
                    float imageHeight=0;
                    
                    //check for image
                    if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                    {
                        cell.imageSentView.frame = CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                        cell.imageSentView.layer.borderWidth = 0;
                        cell.PhotoView.frame = cell.imageSentView.frame;
                        imageHeight = 100;
                    }
                    if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 )
                    {
                        [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button_45.png"] forState:UIControlStateNormal];
                        cell.ThumbnailPhotoView.frame = CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                        cell.ThumbnailPhotoView.layer.borderWidth = 0;
                        cell.VideoSentView.frame = cell.ThumbnailPhotoView.frame;
                        cell.VideoSentView.layer.borderWidth = 0;
                        imageHeight = 100;
                    }
                    
                    if([messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        cell.sound_iconView.frame=CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                        cell.sound_bgView.frame = CGRectZero;
                        [cell.play_btn setImage:nil forState:UIControlStateNormal];
                        cell.play_btn.frame = cell.sound_iconView.frame;
                        imageHeight = 100;
                    }
                    
                    if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                    {
                        cell.LocationSentView.frame=CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                        cell.LocationView.frame = cell.LocationSentView.frame;
                        imageHeight = 100;
                    }
                    
                    //-------for displaying cards------------
                    if([messageBody.customParameters[@"card_heading"] length]>0)
                    {
                        
                        imageHeight = 130;
                        
                        cell.cardImageView.frame = CGRectMake(cell.cardImageView.frame.origin.x+5, cell.cardImageView.frame.origin.y+30, cell.cardImageView.frame.size.width, cell.cardImageView.frame.size.height);
                        cell.cardHeading.frame = CGRectMake(cell.cardHeading.frame.origin.x+5, cell.cardHeading.frame.origin.y+30, cell.cardHeading.frame.size.width, cell.cardHeading.frame.size.height);
                        cell.cardContent.frame = CGRectMake(cell.cardContent.frame.origin.x+5, cell.cardContent.frame.origin.y+30, cell.cardContent.frame.size.width, cell.cardContent.frame.size.height);
                        cell.cardTopClicks.frame = CGRectMake(cell.cardTopClicks.frame.origin.x+5, cell.cardTopClicks.frame.origin.y+30, cell.cardTopClicks.frame.size.width, cell.cardTopClicks.frame.size.height);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardBottomClicks.frame.origin.x+5, cell.cardBottomClicks.frame.origin.y+30, cell.cardBottomClicks.frame.size.width, cell.cardBottomClicks.frame.size.height);
                        cell.cardSender.frame = CGRectMake(cell.cardSender.frame.origin.x+5, cell.cardSender.frame.origin.y+30, cell.cardSender.frame.size.width, cell.cardSender.frame.size.height);
                        cell.cardPlayed_Countered.frame = CGRectMake(cell.cardPlayed_Countered.frame.origin.x+5, cell.cardPlayed_Countered.frame.origin.y+30, cell.cardPlayed_Countered.frame.size.width, cell.cardPlayed_Countered.frame.size.height);
                        cell.cardBarView.frame = CGRectMake(cell.cardBarView.frame.origin.x+5, cell.cardBarView.frame.origin.y+30, cell.cardBarView.frame.size.width, cell.cardBarView.frame.size.height);
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardAcceptedView.frame.origin.x+5, cell.cardAcceptedView.frame.origin.y+28, cell.cardAcceptedView.frame.size.width, cell.cardAcceptedView.frame.size.height);
                        
                        if([messageBody.customParameters[@"isMessageSender"] isEqualToString:@"true"])
                        {
                            NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                            if([substrings count] != 0)
                            {
                                NSString *first = [substrings objectAtIndex:0];
                                cell.cardSender.text = [first uppercaseString];
                                first = nil;
                            }
                            substrings = nil;
                        }
                        else
                        {
                            cell.cardSender.text = @"You";
                        }
                        
                        cell.shareBottomBarImgView.frame = CGRectMake(320-28-220, 46 + imageHeight, 220, 2);
                        cell.shareBottomBarImgView.image = [UIImage imageNamed:@"bar.png"];
                    }
                    else
                    {
                        cell.shareBottomBarImgView.frame = CGRectZero;
                    }

                
                cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, cell.message.frame.size.height);
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor clearColor] CGColor];
                cell.message.layer.cornerRadius = 0;
                
                CGSize textSize = { 220.0, 8461.53};
                if(cell.message.text.length > 0)
                {
                    CGSize newSize = [cell.message.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                           constrainedToSize:textSize
                                               lineBreakMode:NSLineBreakByWordWrapping];
                    
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, newSize.height+18);
                    
                    
                }
                
                cell.bubbleImageView.frame = CGRectMake(cell.bubbleImageView.frame.origin.x, cell.message.frame.origin.y + cell.message.frame.size.height - cell.bubbleImageView.frame.size.height + 22, cell.bubbleImageView.frame.size.width, cell.bubbleImageView.frame.size.height);
                
                cell.backgroundImageView.frame = CGRectMake(cell.message.frame.origin.x-7.5f, 7, 235, cell.message.frame.size.height+45+imageHeight+42);
                cell.backgroundImageView.backgroundColor = [UIColor whiteColor];
                cell.backgroundImageView.layer.borderWidth = 2;
                cell.backgroundImageView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                    cell.message.textColor = [UIColor whiteColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    
                    if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    else
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                    cell.message.textColor = [UIColor whiteColor];
                }
                else
                {
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                    cell.message.textColor = [UIColor blackColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                    
                    cell.shareAccepted.frame=CGRectMake(cell.backgroundImageView.frame.origin.x + 10, cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 42, 32, 32);
                    cell.shareAccepted.tag=indexPath.row-1;
                    [cell.shareAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    [cell.shareAccepted setEnabled:true];
                    [cell.shareAccepted addTarget:self action:@selector(shareAcceptedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.shareRejected.frame=CGRectMake(cell.backgroundImageView.frame.origin.x + 62, cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 42, 32, 32);
                    cell.shareRejected.tag=indexPath.row-1;
                    [cell.shareRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                    [cell.shareRejected setEnabled:true];
                    [cell.shareRejected addTarget:self action:@selector(shareRejectedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    if([messageBody.customParameters[@"isAccepted"] isEqualToString:@"yes"] || [messageBody.customParameters[@"isAccepted"] isEqualToString:@"no"])
                    {
                        [cell.shareAccepted setEnabled:false];
                        [cell.shareRejected setEnabled:false];
                    }
                    else
                    {
                        [cell.shareAccepted setEnabled:true];
                        [cell.shareRejected setEnabled:true];
                    }

                
                [cell.date setFrame:CGRectMake(-7 , cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 12, 70, 10)];
                }
                else
                {
                    cell.shareHeading.frame = CGRectMake(28, 7, 215, 35);
                    cell.shareHeading.text = @"You want to share";
                    cell.shareBarImgView.frame = CGRectMake(26, 37, 220, 6);
                    cell.shareBarImgView.image = [UIImage imageNamed:@"chatBar.png"];
                    cell.shareBottomBarImgView.frame = CGRectZero;
                    
                    cell.shareAccepted.frame = CGRectZero;
                    cell.shareRejected.frame = CGRectZero;
                    
                    cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                    [cell.message setBackgroundColor:[UIColor clearColor]]; // owner gray chat popup
                    
                    if(cell.message.text.length == 0)
                        cell.message.frame = CGRectMake(20, 0, 0, 0);
                    
                    
                    float imageHeight=0;
                    
                    //check for image
                    if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                    {
                        cell.imageSentView.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                        cell.imageSentView.layer.borderWidth = 0;
                        cell.PhotoView.frame = cell.imageSentView.frame;
                        imageHeight = 100;
                    }
                    if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 )
                    {
                        [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button_45.png"] forState:UIControlStateNormal];
                        cell.ThumbnailPhotoView.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                        cell.ThumbnailPhotoView.layer.borderWidth = 0;
                        cell.VideoSentView.frame = cell.ThumbnailPhotoView.frame;
                        cell.VideoSentView.layer.borderWidth = 0;
                        imageHeight = 100;
                    }
                    
                    if([messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        cell.sound_iconView.frame=CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                        cell.sound_bgView.frame = CGRectZero;
                        [cell.play_btn setImage:nil forState:UIControlStateNormal];
                        cell.play_btn.frame = cell.sound_iconView.frame;
                        imageHeight = 100;
                    }
                    
                    if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                    {
                        cell.LocationSentView.frame=CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                        cell.LocationView.frame = cell.LocationSentView.frame;
                        imageHeight = 100;
                    }
                    
                    //-------for displaying cards------------
                    if([messageBody.customParameters[@"card_heading"] length]>0)
                    {
                    
                        imageHeight = 130;
                        
                        cell.cardImageView.frame = CGRectMake(cell.cardImageView.frame.origin.x, cell.cardImageView.frame.origin.y+30, cell.cardImageView.frame.size.width, cell.cardImageView.frame.size.height);
                        cell.cardHeading.frame = CGRectMake(cell.cardHeading.frame.origin.x, cell.cardHeading.frame.origin.y+30, cell.cardHeading.frame.size.width, cell.cardHeading.frame.size.height);
                        cell.cardContent.frame = CGRectMake(cell.cardContent.frame.origin.x, cell.cardContent.frame.origin.y+30, cell.cardContent.frame.size.width, cell.cardContent.frame.size.height);
                        cell.cardTopClicks.frame = CGRectMake(cell.cardTopClicks.frame.origin.x, cell.cardTopClicks.frame.origin.y+30, cell.cardTopClicks.frame.size.width, cell.cardTopClicks.frame.size.height);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardBottomClicks.frame.origin.x, cell.cardBottomClicks.frame.origin.y+30, cell.cardBottomClicks.frame.size.width, cell.cardBottomClicks.frame.size.height);
                        cell.cardSender.frame = CGRectMake(cell.cardSender.frame.origin.x, cell.cardSender.frame.origin.y+30, cell.cardSender.frame.size.width, cell.cardSender.frame.size.height);
                        cell.cardPlayed_Countered.frame = CGRectMake(cell.cardPlayed_Countered.frame.origin.x, cell.cardPlayed_Countered.frame.origin.y+30, cell.cardPlayed_Countered.frame.size.width, cell.cardPlayed_Countered.frame.size.height);
                        cell.cardBarView.frame = CGRectMake(cell.cardBarView.frame.origin.x, cell.cardBarView.frame.origin.y+30, cell.cardBarView.frame.size.width, cell.cardBarView.frame.size.height);
                        cell.cardAcceptedView.frame = CGRectMake(cell.cardAcceptedView.frame.origin.x, cell.cardAcceptedView.frame.origin.y+28, cell.cardAcceptedView.frame.size.width, cell.cardAcceptedView.frame.size.height);
                        
                        if([messageBody.customParameters[@"isMessageSender"] isEqualToString:@"false"])
                        {
                            NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                            if([substrings count] != 0)
                            {
                                NSString *first = [substrings objectAtIndex:0];
                                cell.cardSender.text = [first uppercaseString];
                                first = nil;
                            }
                            substrings = nil;
                        }
                        else
                        {
                            cell.cardSender.text = @"You";
                        }
                    }
                    
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 45+imageHeight, 220, cell.message.frame.size.height);
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor clearColor] CGColor];
                    cell.message.layer.cornerRadius = 0;
                    
                    CGSize textSize = { 220.0, 8461.53};
                    if(cell.message.text.length > 0)
                    {
                        CGSize newSize = [cell.message.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                                       constrainedToSize:textSize
                                                           lineBreakMode:NSLineBreakByWordWrapping];
                        
                        cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, newSize.height+18);
                        
                        
                    }
                    
                    cell.bubbleImageView.frame = CGRectMake(cell.bubbleImageView.frame.origin.x, cell.message.frame.origin.y + cell.message.frame.size.height - cell.bubbleImageView.frame.size.height + 22, cell.bubbleImageView.frame.size.width, cell.bubbleImageView.frame.size.height);
                    
                    cell.backgroundImageView.frame = CGRectMake(cell.message.frame.origin.x-7.5f, 7, 235, cell.message.frame.size.height+45+imageHeight);
                    cell.backgroundImageView.backgroundColor = [UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0];
                    cell.backgroundImageView.layer.borderWidth = 2;
                    cell.backgroundImageView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    
                    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                    {
                        
                        [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                        cell.message.textColor = [UIColor whiteColor];
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                        
                        if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        else
                            [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                      cell.message.frame.origin.y+12,
                                                                      14,15)];
                        cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                        cell.message.textColor = [UIColor whiteColor];
                    }
                    else
                    {
                        
                        //[cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                        [cell.message setBackgroundColor:[UIColor whiteColor]];
                        cell.message.textColor = [UIColor blackColor];
                        cell.message.layer.borderWidth = 0.0f;
                        cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    }
                    
                    [cell.date setFrame:CGRectMake(258 , cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 12, 70, 10)];

                }

                
            }
            else
            {
                cell.shareHeading.frame = CGRectZero;
                cell.shareBarImgView.frame = CGRectZero;
                cell.shareBottomBarImgView.frame = CGRectZero;
                cell.backgroundImageView.frame = CGRectZero;
                cell.message.layer.cornerRadius = 4.0f;
                cell.shareAccepted.frame = CGRectZero;
                cell.shareRejected.frame = CGRectZero;
            }

            if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shareAccepted"])
            {
                [cell.message setBackgroundColor:[UIColor colorWithRed:81/255.0 green:204/255.0 blue:211/255.0 alpha:1]];
                cell.message.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:134/255.0 alpha:1];
                cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
                cell.message.layer.borderWidth = 0.0f;
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_blue_bubble.png"];
                }
                else
                    cell.bubbleImageView.image=[UIImage imageNamed:@"left_blue_bubble.png"];
                
            }
            
            if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shareRejected"])
            {
                [cell.message setBackgroundColor:[UIColor colorWithRed:50/255.0 green:69/255.0 blue:102/255.0 alpha:1]];
                cell.message.textColor = [UIColor colorWithRed:88/255.0 green:216/255.0 blue:233/255.0 alpha:1];
                
                cell.message.layer.borderWidth = 0.0f;
                cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
                
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_darkblue_bubble.png"];
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x-10, cell.message.frame.origin.y, cell.message.frame.size.width+12, cell.message.frame.size.height);
                    cell.date.frame = CGRectMake(cell.date.frame.origin.x-10, cell.date.frame.origin.y, cell.date.frame.size.width, cell.date.frame.size.height);
                }
                else
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"left_darkblue_bubble.png"];
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x, cell.message.frame.origin.y, cell.message.frame.size.width+10, cell.message.frame.size.height);
                    cell.date.frame = CGRectMake(cell.date.frame.origin.x+10, cell.date.frame.origin.y, cell.date.frame.size.width, cell.date.frame.size.height);
                }
            }
            
            
//            if([messageBody.customParameters[@"isComposing"] length] > 0)
//            {
//                cell.istypingImgView.frame = CGRectMake(265, 12, 30, 30);
//                //cell.istypingImgView.image = [UIImage imageNamed:@"IsTyping_1.png"];
//                
//                NSMutableArray *images = [[NSMutableArray alloc] init];
//                for (int i = 1; i <= 3; i++)
//                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"IsTyping_%i.png",i]]];
//                
//                // Normal Animation
//                cell.istypingImgView.animationImages = images;
//                cell.istypingImgView.animationDuration = 1;
//                cell.istypingImgView.animationRepeatCount = 0;
//                [cell.istypingImgView startAnimating];
//                
//                cell.shareHeading.frame = CGRectZero;
//                cell.shareBarImgView.frame = CGRectZero;
//                cell.shareAccepted.frame = CGRectZero;
//                cell.shareRejected.frame = CGRectZero;
//                cell.date.hidden = YES;
//                cell.backgroundImageView.frame = CGRectZero;
//                cell.clicksImageView.frame = CGRectZero;
//                cell.imageSentView.frame = CGRectZero;
//                cell.PhotoView.frame = CGRectZero;
//                cell.VideoSentView.frame = CGRectZero;
//                cell.ThumbnailPhotoView.frame = CGRectZero;
//                cell.play_btn.frame=CGRectZero;
//                cell.sound_iconView.frame=CGRectZero;
//                cell.sound_bgView.frame=CGRectZero;
//                cell.downloadingView.frame = CGRectZero;
//                [cell.share_btn setImage:nil forState:UIControlStateNormal];
//                [cell.share_btn setFrame:CGRectZero];
//                cell.LocationView.frame = CGRectZero;
//                cell.LocationSentView.frame = CGRectZero;
//                cell.cardAccepted.frame=CGRectZero;
//                cell.cardAcceptedView.frame=CGRectZero;
//                cell.cardBarView.frame=CGRectZero;
//                cell.cardBottomClicks.frame=CGRectZero;
//                cell.cardContent.frame=CGRectZero;
//                cell.cardCountered.frame=CGRectZero;
//                cell.cardHeading.frame=CGRectZero;
//                cell.cardImageView.frame=CGRectZero;
//                cell.cardPlayed_Countered.frame=CGRectZero;
//                cell.cardRejected.frame=CGRectZero;
//                cell.cardSender.frame=CGRectZero;
//                cell.cardTopClicks.frame=CGRectZero;
//            }
//            else
//            {
//                cell.istypingImgView.frame =  CGRectZero;
//                cell.date.hidden = NO;
//            }
            
            if([messageBody.customParameters[@"isDelivered"] isEqualToString:@"yes"])
            {
                if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]])
                {
                    cell.deliveredIcon.frame = CGRectMake(cell.date.frame.origin.x+39, cell.date.frame.origin.y-1, 34/2, 25/2);
                    cell.deliveredIcon.image= [UIImage imageNamed:@"tick.png"];
                }
                else
                    cell.deliveredIcon.frame = CGRectZero;
            }
            else
            {
                //cell.deliveredIcon.frame = CGRectZero;
                if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]])
                {
                    cell.deliveredIcon.frame = CGRectMake(cell.date.frame.origin.x+39, cell.date.frame.origin.y-1, 28/2, 25/2);
                    cell.deliveredIcon.image= [UIImage imageNamed:@"singleTick.png"];
                }
                else
                    cell.deliveredIcon.frame = CGRectZero;
            }

        }
    }
    else
    {
        cell.load_earlierBtn.frame = CGRectZero;
        
        // Message
        QBChatMessage *messageBody = [messages objectAtIndex:[indexPath row]];
        NSString *message;
        
        NSString *StrClicks = messageBody.customParameters[@"clicks"];

        NSLog(@"%@",StrClicks);
        
        if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
        {
            // set message's text
            message = [messageBody text];
            
            if(message== (NSString*)[NSNull null])
            {
                message = @"";
                cell.message.text = @"";
            }
            else
                cell.message.text = message;
            cell.message.textColor = [UIColor blackColor];
            cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            cell.date.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:11.0];
        }
        else
        {
            message = [messageBody text];
            if(message== (NSString*)[NSNull null])
                message = @"";
        
    //      font setting when sending the clicks
            
            //innn
            
            cell.message.textColor = [UIColor whiteColor];
            UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
    //      UIColor *foregroundColor = [UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
            UIColor *foregroundColor = [UIColor whiteColor];

            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   boldFont, NSFontAttributeName,nil];
            NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
            // RANGE ISSUE COMES HERE
            if (StrClicks.length>0)
            {
                const NSRange range = NSMakeRange(0,[StrClicks length]);
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:message
                                                       attributes:attrs];
                [attributedText setAttributes:subAttrs range:range];
                [cell.message setAttributedText:attributedText];
            }
            else
            {
                [cell.message setText:message];
            }
            
        }
        
        //check for image sent
        
        if([messageBody.customParameters[@"fileID"] length]>1)
        {
            cell.PhotoView.image=nil;
            cell.PhotoView.frame = CGRectZero;
            cell.PhotoView.alpha = 1;
            [cell.imageSentView setImage:nil forState:UIControlStateNormal];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            float imageHeight;
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            else
                imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.imageSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
//                cell.imageSentView.layer.borderWidth = 2.0f;
//                cell.imageSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
//                cell.PhotoView.layer.borderWidth = 2.0f;
//                cell.PhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    cell.PhotoView.layer.borderWidth = 2.0f;
                    cell.PhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    cell.PhotoView.layer.borderWidth = 2.0f;
                    cell.PhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    cell.PhotoView.layer.borderWidth = 2.0f;
                    cell.PhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    cell.PhotoView.layer.borderWidth = 2.0f;
                    cell.PhotoView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                cell.imageSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
            }
            
            cell.imageSentView.enabled=false;
            
            cell.PhotoView.frame=cell.imageSentView.frame;
            
            [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"fileID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                 cell.imageSentView.enabled=true;
                 cell.PhotoView.alpha = 0;
             } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
            
            //[cell.imageSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            //[cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
            [cell.imageSentView addTarget:self action:@selector(showFullScreenPicture:)
                         forControlEvents:UIControlEventTouchUpInside];
            
            /*
             //calculate the correct position
             
             cell.downloadingView.frame = CGRectMake(cell.imageSentView.frame.origin.x + cell.imageSentView.frame.size.width/2 - 25, cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height/2 -25,50,50);
             [cell.downloadingView startAnimating];
             
             if([[imagesData objectAtIndex:indexPath.row] length]>0)
             [cell.downloadingView stopAnimating];*/
            
        }
        else if([messageBody.customParameters[@"isFileUploading"] length]>0)
        {
            cell.PhotoView.image=nil;
            cell.PhotoView.frame = CGRectZero;
            cell.PhotoView.alpha = 0;
            [cell.imageSentView setImage:nil forState:UIControlStateNormal];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            float imageHeight;
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            else
                imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.imageSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                cell.imageSentView.layer.borderWidth = 2.0f;
                cell.imageSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                if([messageBody.customParameters[@"shareStatus"] length]==0)
                {
                    [cell.imageSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                }
                else
                {
                    cell.imageSentView.enabled=false;
                    [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                    {
                        [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                        cell.imageSentView.enabled=true;
                        cell.PhotoView.alpha = 0;
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                }
            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.imageSentView.layer.borderWidth = 2.0f;
                    cell.imageSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                
                cell.imageSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                
                [cell.imageSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            }
            //  cell.PhotoView.frame=cell.imageSentView.frame;
            
            //  [cell.PhotoView setImageWithURL:[imagesURL objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"loading.png"]];
            
            
            
            //[cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
            
            [cell.imageSentView addTarget:self action:@selector(showFullScreenPicture:)
                         forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cell.imageSentView setImage:nil forState:UIControlStateNormal];
            cell.imageSentView.frame=CGRectZero;
            
            cell.PhotoView.image=nil;
            cell.PhotoView.frame=CGRectZero;
            cell.PhotoView.alpha = 1;
            
        }
        
        
        
        // check for video sent
        if([messageBody.customParameters[@"videoID"] length]>1)
        {
            /*cell.ThumbnailPhotoView.image=nil;
            cell.ThumbnailPhotoView.frame = CGRectZero;
            [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
            cell.ThumbnailPhotoView.frame = CGRectZero;*/
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {//iiinnnn right side 1
                cell.VideoSentView.frame=CGRectMake(320 - padding -175, padding-12, 175, 175);
//                cell.VideoSentView.layer.borderWidth = 2.0f;
//                cell.VideoSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
//                cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
//                cell.ThumbnailPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }

            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                cell.VideoSentView.frame=CGRectMake(padding, padding-12, 175, 175);
            }
            
            cell.VideoSentView.enabled=false;
            
            cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
            
            if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"videoThumbnail"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
            {
                    [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                cell.VideoSentView.enabled=true;
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
            cell.VideoSentView.tag = indexPath.row;
            [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                         forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else if([messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
        {
            /*cell.ThumbnailPhotoView.image=nil;
            cell.ThumbnailPhotoView.frame = CGRectZero;
            [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
            cell.ThumbnailPhotoView.frame = CGRectZero;*/
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;

            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                cell.VideoSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                cell.VideoSentView.layer.borderWidth = 2.0f;
                cell.VideoSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                cell.ThumbnailPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
                if([messageBody.customParameters[@"shareStatus"] length]==0)
                {
                    cell.ThumbnailPhotoView.frame = cell.VideoSentView.frame;
                    
                    cell.ThumbnailPhotoView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] ;
                }
                else
                {
                    cell.VideoSentView.enabled=false;
                    
                    cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
                    
                    if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                        [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                    {
                            [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                        cell.VideoSentView.enabled=true;
                        }
                                     usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                }

            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {//iiiinnnn
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.VideoSentView.layer.borderWidth = 2.0f;
                    cell.VideoSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                    cell.ThumbnailPhotoView.layer.borderWidth = 2.0f;
                    cell.ThumbnailPhotoView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                cell.VideoSentView.frame=CGRectMake(padding, padding-12, 175, 175);
                
                cell.ThumbnailPhotoView.frame = cell.VideoSentView.frame;
                
                cell.ThumbnailPhotoView.image = [UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] ;
            }
            
            
            
            [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
            
            cell.VideoSentView.enabled=true;
            cell.VideoSentView.tag = indexPath.row;
            [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                         forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
            cell.VideoSentView.frame=CGRectZero;
            
            cell.ThumbnailPhotoView.image=nil;
            cell.ThumbnailPhotoView.frame=CGRectZero;
        }
        
        
        //audio data
        if([messageBody.customParameters[@"audioID"] length]>1)
        {
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                cell.sound_bgView.frame=CGRectMake(320 - padding -175, padding-12, 175, 50);
                cell.sound_iconView.frame=CGRectMake(320 - padding -120, padding-9, 100, 44);
                cell.play_btn.frame = CGRectMake(320 - padding - 170, padding-12, 40, 50);
//                cell.sound_bgView.layer.borderWidth = 2.0f;
//                cell.sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                cell.sound_bgView.frame=CGRectMake(padding , padding-12, 175, 50);
                cell.sound_iconView.frame=CGRectMake(padding + 60, padding-9, 100, 44);
                cell.play_btn.frame = CGRectMake(padding + 10, padding-12, 40, 50);
            }

            cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
            //[cell.slider setThumbImage: [UIImage imageNamed:@"sliderhandle.png"] forState:UIControlStateNormal];
            
            cell.play_btn.tag = indexPath.row;
            [cell.play_btn setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
            [cell.play_btn addTarget:self action:@selector(playAudio:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }
        else if([messageBody.customParameters[@"isAudioUploading"] length]>0)
        {
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                cell.sound_bgView.frame=CGRectMake(320 - padding -175, padding-12, 175, 50);
                cell.sound_iconView.frame=CGRectMake(320 - padding -120, padding-9, 100, 44);
                cell.play_btn.frame = CGRectMake(320 - padding - 170, padding-12, 40, 50);
                cell.sound_bgView.layer.borderWidth = 2.0f;
                cell.sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.sound_bgView.layer.borderWidth = 2.0f;
                    cell.sound_bgView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                cell.sound_bgView.frame=CGRectMake(padding , padding-12, 175, 50);
                cell.sound_iconView.frame=CGRectMake(padding + 60, padding-9, 100, 44);
                cell.play_btn.frame = CGRectMake(padding + 10, padding-12, 40, 50);
            }
            cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
            //[cell.slider setThumbImage: [UIImage imageNamed:@"sliderhandle.png"] forState:UIControlStateNormal];
            
            cell.play_btn.tag = indexPath.row;
            [cell.play_btn setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
            [cell.play_btn addTarget:self action:@selector(playAudio:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
            [cell.play_btn setImage:nil forState:UIControlStateNormal];
            cell.play_btn.frame=CGRectZero;
            
            cell.sound_iconView.frame=CGRectZero;
            cell.sound_bgView.frame=CGRectZero;
            //[cell.slider setThumbImage: [[UIImage alloc] init] forState:UIControlStateNormal];
        }
        
        if([messageBody.customParameters[@"locationID"] length]>1)
        {
            cell.LocationView.image=nil;
            cell.LocationView.frame = CGRectZero;
            cell.LocationView.alpha = 1;
            cell.downloadingView.frame = CGRectZero;
            [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            float imageHeight;
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            else
                imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                cell.LocationSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                cell.LocationSentView.layer.borderWidth = 2.0f;
                cell.LocationSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                cell.LocationSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
            }
            
            cell.LocationSentView.enabled=false;
            
            cell.LocationView.frame=cell.LocationSentView.frame;
            
            [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"locationID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal];
                cell.LocationSentView.enabled=true; cell.LocationView.alpha = 0;
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            [cell.LocationSentView addTarget:self action:@selector(showMapView:)
                            forControlEvents:UIControlEventTouchUpInside];
        }
        else if([messageBody.customParameters[@"isLocationUploading"] length]>0)
        {
            cell.LocationView.image=nil;
            cell.LocationView.frame = CGRectZero;
            cell.LocationView.alpha = 1;
            [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            float imageHeight;
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            else
                imageHeight = 225/[messageBody.customParameters[@"imageRatio"] floatValue];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                cell.LocationSentView.frame=CGRectMake(320-padding-175, padding-12, 175, 175);
                cell.LocationSentView.layer.borderWidth = 2.0f;
                cell.LocationSentView.layer.borderColor = [[UIColor whiteColor] CGColor];
                if([messageBody.customParameters[@"shareStatus"] length]==0)
                {
                    [cell.LocationSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                }
                else
                {
                    cell.LocationSentView.enabled=false;
                    
                    cell.LocationView.frame=cell.LocationSentView.frame;
                    
                    [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"imageURL"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                    {
                           [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal]; cell.LocationSentView.enabled=true; cell.LocationView.alpha = 0;
                    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                }

            }
            else
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.LocationSentView.layer.borderWidth = 2.0f;
                    cell.LocationSentView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                cell.LocationSentView.frame=CGRectMake(padding, padding - 12, 175, 175);
                [cell.LocationSentView setImage:[UIImage imageWithData:[imagesData objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            }
            NSLog(@"%ld",(long)indexPath.row);
            NSLog(@"%lu",(unsigned long)[imagesData count]);
            NSLog(@"%lu",(unsigned long)[self.messages count]);
            
            [cell.LocationSentView addTarget:self action:@selector(showMapView:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
            cell.LocationSentView.frame=CGRectZero;
            cell.LocationView.image=nil;
            cell.LocationView.frame=CGRectZero;
            cell.LocationView.alpha = 1;
            cell.downloadingView.frame = CGRectZero;
        }


        
        // message's datetime
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"hh:mm a"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        NSString *OldTime = [formatter stringFromDate:messageBody.datetime];
        NSString *time;
        //..NSLog(@"%@",[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]]);
        if([[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]] isEqualToString:@"pm"])
        {
            time = [OldTime substringToIndex:[OldTime length]-2];
            time = [time stringByAppendingString:@"PM"];
        }
        else
        {
            time = [OldTime substringToIndex:[OldTime length]-2];
            time = [time stringByAppendingString:@"AM"];
        }
        
        
        CGSize textSize = { 200.0, 7690.0 };
        
        if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
        {
            textSize = CGSizeMake(150.0, 6921.0);
        }
        else if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0 || [messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
            textSize = CGSizeMake(150.0, 8651.25);
        
        
        //inn
//        CGSize size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
//                          constrainedToSize:textSize
//                              lineBreakMode:NSLineBreakByWordWrapping];


        
        CGSize size;
     /* if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
        {
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)cell.message.attributedText);
            CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [cell.message.attributedText length]), NULL, textSize, NULL);
            CFRelease(framesetter);
            
            size =  CGSizeMake(ceilf(fitSize.width), ceilf(fitSize.height));
           
        }
        else
        {
            size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
            
        }
        */
        
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"width87 : %f",textSize.width] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        
        size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                   constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];

        
    /*    if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
        {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"    "];
            
            
            NSMutableAttributedString  *tempStr = [[NSMutableAttributedString alloc] initWithAttributedString:cell.message.attributedText];
            
            [tempStr appendAttributedString:str];
            
            CGFloat width = 200.0;
            CGRect sizeRect = [tempStr boundingRectWithSize:CGSizeMake(width, 7690.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
            
            size =  CGSizeMake(sizeRect.size.width, sizeRect.size.height);
            
        }
        else
        {
            size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
        }
     */
        
        
        if(![StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
        {
            //inn
            size.width+=10.0;
        }
        
        NSLog(@"width: %f",size.width);
        NSLog(@"height: %f",size.height);
        
        size.width += (padding/2);
        [cell setBackgroundColor:[UIColor clearColor]];
        
        // Left/Right message box
        UIImage *bgImage = nil;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSLog(@"1:: %@",[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]);
        NSLog(@"2:: %@",[NSString stringWithFormat:@"%@",partner_QB_id]);
        
        if([messageBody.customParameters[@"card_heading"] length]==0)
        {
            
        
        if(![[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
        {
            //bgImage = [[UIImage imageNamed:@"chatboxsml2.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:16];
            if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.imageSentView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.LocationSentView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
            {
                cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.ThumbnailPhotoView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(320-padding-175, padding-15 + cell.sound_bgView.frame.size.height, 175, size.height+padding);
            }
            else
                [cell.message setFrame:CGRectMake(320 - size.width - padding,
                                              padding-13,
                                              size.width+padding-20,
                                              size.height+padding)];
            [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                          cell.message.frame.origin.y+10 - padding/2,
                                                          size.width+padding,
                                                          size.height+padding)];
            
            //for textview side bubble
            [cell.bubbleImageView setFrame:CGRectMake((self.view.frame.size.width - padding*1.22f)+2,
                                                          cell.message.frame.origin.y+cell.message.frame.size.height-35,
                                                          14,30)];// if right side card is not available
            cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
            
            //for clicks image in the textview
            if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"]&&[messageBody.customParameters[@"clicks"]length]>0)
            {
                if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                              cell.message.frame.origin.y+12,
                                                              14,15)];
                else
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                          cell.message.frame.origin.y+12,
                                                          14,15)];
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_red_bubble-1.png"];
                cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                cell.message.textColor = [UIColor whiteColor];
                
                //iiinnn right side 2
                [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                [cell.message setBackgroundColor:[UIColor whiteColor]];
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                cell.message.layer.borderWidth = 0.0f;
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
            }
            
            cell.date.textAlignment = NSTextAlignmentRight;
            cell.backgroundImageView.image = bgImage;
            cell.date.text = [[NSString stringWithFormat:@"%@",time] uppercaseString];
            [cell.date setFrame:CGRectMake((cell.message.frame.origin.x - padding/2) - 65 , size.height+padding-5  , 70, 10)];
        }
        else
        {
            //bgImage = [[UIImage imageNamed:@"chatboxsml.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:16];
            if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(padding, padding-15 + cell.imageSentView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(padding, padding-15 + cell.LocationSentView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
            {
                cell.message.frame=CGRectMake(padding, padding-15 + cell.ThumbnailPhotoView.frame.size.height, 175, size.height+padding);
            }
            else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
            {
                cell.message.frame=CGRectMake(padding, padding-15 + cell.sound_bgView.frame.size.height, 175, size.height+padding);
            }
            else
            {
                //inn
                [cell.message setFrame:CGRectMake(padding, padding-13, size.width+padding-20 , size.height+padding)];
            }
            [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                          cell.message.frame.origin.y+10 - padding/2,
                                                          size.width+padding,
                                                          size.height+padding)];
            
            [cell.bubbleImageView setFrame:CGRectMake((padding*0.5f)-2,
                                                      cell.message.frame.origin.y+cell.message.frame.size.height-35,
                                                      14,30)];
            cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
            
            //for clicks image in the textview
            if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"]&&[messageBody.customParameters[@"clicks"]length]>0)
            {
                if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                {
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                              cell.message.frame.origin.y+12,
                                                              14,15)];
                }
                else
                {
                    //inn
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                              cell.message.frame.origin.y+12,
                                                              14,15)];
                }
                
                cell.bubbleImageView.image=[UIImage imageNamed:@"left_red_bubble-1.png"];
                cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                cell.message.textColor = [UIColor whiteColor];
                //iiinnnn
                [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                cell.message.layer.borderWidth = 2.0f;
                cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
            }

            
            cell.date.textAlignment = NSTextAlignmentLeft;
            cell.backgroundImageView.image = bgImage;
            cell.date.text = [[NSString stringWithFormat:@"%@", time] uppercaseString];
            [cell.date setFrame:CGRectMake((size.width+padding) + 5 , size.height+padding -5 , 70, 10)];
        }
       }
        else
        {
            [cell.message setFrame:CGRectZero];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            cell.message.layer.borderWidth = 0.0f;
        }
        

        if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0 || [messageBody.customParameters[@"locationID"] length]>1 || [messageBody.customParameters[@"isLocationUploading"] length]>0 || [messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
        {
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_red_bubble-1.png"];
                    //chatboxleft.png
                    //iinnnnn right side 3
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                    cell.message.layer.borderWidth = 2.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0] CGColor];
                }
                else
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
                    [cell.message setBackgroundColor:[UIColor whiteColor]];
                    cell.message.layer.borderWidth = 2.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                }

                if(cell.message.text.length==0)
                {
                    if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                    {
                        [cell.date setFrame:CGRectMake(74+50 - 80, 172 , 70, 10)];
                    }
                    else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        [cell.date setFrame:CGRectMake(74+50 - 80, 45 , 70, 10)];
                    }
                    else if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                        [cell.date setFrame:CGRectMake(74+50 - 77, cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height -15 , 70, 10)];
                    else
                        [cell.date setFrame:CGRectMake(74+50 - 77, cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height -15 , 70, 10)];
                }
                else
                {
                    if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        [cell.date setFrame:CGRectMake(74+50 - 80, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                    }
                    else
                        [cell.date setFrame:CGRectMake(74+50 - 77, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                }
                [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-30, 30, 30)];
                cell.share_btn.tag = indexPath.row;
                [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"left_red_bubble-1.png"];
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                    //iiinnnn
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                    cell.message.layer.borderWidth = 2.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }

                
                if(cell.message.text.length==0)
                {
                    if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1)
                        [cell.date setFrame:CGRectMake(175-50 + 80, 172 , 70, 10)];
                    
                    else if([messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        [cell.date setFrame:CGRectMake(175-50 + 80, 45 , 70, 10)];
                    }
                    else if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                        [cell.date setFrame:CGRectMake(175-50 + 77 , cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height -15 , 70, 10)];
                    else
                        [cell.date setFrame:CGRectMake(175-50 + 77 , cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height -15 , 70, 10)];
                }
                else
                {
                    if([messageBody.customParameters[@"videoID"] length]>1 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"audioID"] length]>1 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                    {
                        [cell.date setFrame:CGRectMake(175-50 + 80, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                    }
                    else
                        [cell.date setFrame:CGRectMake(175-50 + 77, cell.message.frame.origin.y + cell.message.frame.size.height - 15 , 70, 10)];
                }
                [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-30, 30, 30)];
                cell.share_btn.tag = indexPath.row;
                [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            if([messageBody.customParameters[@"isFileUploading"] length]>0  || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 || [messageBody.customParameters[@"isAudioUploading"] length]>0 || [messageBody.customParameters[@"isLocationUploading"] length]>0)
            {
                NSString *string = @".";
                NSRange range = [messageBody.ID rangeOfString:string];
                
                if(messageBody.ID.length<7 || range.location != NSNotFound)
                {
                    cell.share_btn.hidden = true;
                    cell.downloadingView.frame = CGRectMake(cell.share_btn.frame.origin.x + cell.share_btn.frame.size.width/2 - 25, cell.share_btn.frame.origin.y + cell.share_btn.frame.size.height/2 -25,50,50);
                    [cell.downloadingView startAnimating];
                }
                else
                {
                    cell.share_btn.hidden = false;
                    [cell.downloadingView stopAnimating];
                }
                
                string = nil;
            }
            
            if(cell.message.text.length==0 && [messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]==0)
            {
                [cell.message setFrame:CGRectZero];
                
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
           //   [cell.message setBackgroundColor:[UIColor whiteColor]];
             // iiinnn right side
                cell.message.layer.borderWidth = 2.0f;
            }

        }
        else if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
        {//inn
            cell.message.layer.borderWidth = 0.0f;
            cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                cell.share_btn.tag = indexPath.row;
                [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                //inn
                [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                cell.share_btn.tag = indexPath.row;
                [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            cell.share_btn.hidden = false;
            [cell.downloadingView stopAnimating];
        }
        else
        {
            cell.message.layer.borderWidth = 2.0f;
            [cell.share_btn setImage:nil forState:UIControlStateNormal];
            [cell.share_btn setFrame:CGRectZero];
            cell.share_btn.hidden = false;
            [cell.downloadingView stopAnimating];
        }
        
        //-------for displaying cards------------
        if([messageBody.customParameters[@"card_heading"] length]>0)
        {
            if(![[NSString stringWithFormat:@"%ld",(long)[prefs integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]] )
            {
                
                [cell.message setFrame:CGRectMake(320 - 240 - padding,
                                                  padding-13,
                                                  240+padding-20,
                                                  126+padding)];
                [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                              cell.message.frame.origin.y+10 - padding/2,
                                                              240+padding,
                                                              126+padding)];
                
                //for textview side bubble
                [cell.bubbleImageView setFrame:CGRectMake((self.view.frame.size.width - padding*1.22f)+2,
                                                          12.5f,
                                                          14,30)];
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_white_bubble.png"];
                
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                [cell.message setBackgroundColor:[UIColor whiteColor]];
                cell.message.layer.borderWidth = 0.0f;
                
                cell.PhotoView.frame=CGRectZero;
                cell.PhotoView.image=nil;
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 ,cell.message.frame.origin.y + 5, 248, 326);
                else
                    cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  8 ,cell.message.frame.origin.y + 10, 95, 125);
                cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
                //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
                cell.cardHeading.text = messageBody.customParameters[@"card_heading"];
                
                cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
                cell.cardContent.text = messageBody.customParameters[@"card_content"];
                
                cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
                [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
                
                cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
                [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
                
                if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
                {
                    cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                    cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  8 + 6 ,cell.message.frame.origin.y + 10 + 18 , 95-12, 125 -40);
                    cell.cardHeading.numberOfLines=4;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
                    cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                    cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];
                }
                else
                {
                    cell.cardHeading.numberOfLines=2;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                    //cell.cardHeading.text = @"";
                    //cell.cardContent.text = @"";
                }

                
                cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
                //cell.cardSender.text = @"You";
                
                NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                if([substrings count] != 0)
                {
                    NSString *first = [substrings objectAtIndex:0];
                    cell.cardSender.text = [first uppercaseString];
                }
//                cell.cardSender.text = [partner_name capitalizedString];
                
                cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 18 - 5, 120, 40);
                
                NSString *card_actionText;
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                {
                    card_actionText = @"ACCEPTED!";
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                {
                    card_actionText = @"REJECTED!";
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                    card_actionText = @"COUNTERED CARD";
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    card_actionText = @"PLAYED A CARD";
                
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    cell.cardPlayed_Countered.text = @"will offer you clicks for";
                else
                    cell.cardPlayed_Countered.text = card_actionText;
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                {
                    cell.cardSender.text = [NSString stringWithFormat:@"%@ made a",[cell.cardSender.text capitalizedString]];
                    cell.cardPlayed_Countered.text = @"COUNTER OFFER";
                }
                
                
                cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 48 - 5, 195/2, 2);
                cell.cardBarView.image = [UIImage imageNamed:@"bar.png"];
                
                cell.date.textAlignment = NSTextAlignmentRight;
                cell.backgroundImageView.image = bgImage;
                cell.date.text = [[NSString stringWithFormat:@"%@",time] uppercaseString];
                [cell.date setFrame:CGRectMake(-14 , 145 , 70, 10)];
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                {
                    [cell.message setFrame:CGRectMake(320 - 250 - padding,
                                                      padding-13,
                                                      250+padding-20,
                                                      388+padding)];
                    [cell.backgroundImageView setFrame:CGRectMake(cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  250+padding,
                                                                  388+padding)];
                    if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"false"])
                    {
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 + 11 ,cell.message.frame.origin.y + 5 + 7, 248 - 22, 326 - 14);
                        //cell.cardImageView.image = [UIImage imageNamed:@"savewater.png"];
                        [cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        cell.cardHeading.frame = CGRectZero;
                        cell.cardHeading.numberOfLines=2;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                        cell.cardContent.frame = CGRectZero;
                        cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 8, 36, 36);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 75, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 44, 36, 36);
                        
                    }
                    else
                    {
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x -  1.5 +7 ,cell.message.frame.origin.y + 5 + 3, 248-14, 326 - 9);
                        cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                        //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  25 ,cell.message.frame.origin.y + 5  + 48, 248-48, 326-100);
                        cell.cardHeading.numberOfLines=4;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:24]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                        cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 14, cell.cardImageView.frame.origin.y + 9, 36, 36);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 82, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 55, 36, 36);
                    }

                    cell.cardContent.frame = CGRectZero;
                    
                    [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                    
                    
                    [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                    
                    CGSize textSize = {120,18};
                    CGSize size = [cell.cardSender.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]
                                                   constrainedToSize:textSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
                    
                    cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + 15, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2 , size.width +15, 40);
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardSender.frame.size.width + 5, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2, 150, 40);
                    cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + 12 - 10, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 28 , 224, 2);
                    
                    [cell.date setFrame:CGRectMake(-20.5f,404, 70, 10)];
                    
                    
                }

                
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                    
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5 + 2, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                    
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x + 45, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.cardAcceptedView.frame = CGRectZero;
                    cell.cardAcceptedView.image = nil;
                    
                    [cell.share_btn setImage:nil forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectZero];
                    
                    cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardAccepted.tag=indexPath.row;
                    [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    //[cell.cardAccepted setEnabled:true];
                    [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardRejected.tag=indexPath.row;
                    [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                    //[cell.cardRejected setEnabled:true];
                    [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20 - 4, cell.cardImageView.frame.origin.y + 98 - 5 - 4, 188/2, 41);
                    cell.cardCountered.tag=indexPath.row;
                    [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                    //[cell.cardCountered setEnabled:true];
                    [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                 forControlEvents:UIControlEventTouchUpInside];
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    {
                        cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 + 3, 32, 32);
                        cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20 + 50, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 + 3, 32, 32);
                        cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + 138 - 4, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 - 1, 188/2, 41);
                    }

                    
                    
                    for(int i=0;i<card_accept_status.count;i++)
                    {
                        if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==indexPath.row)
                        {
                            if([[[card_accept_status objectAtIndex:i] objectForKey:@"status"] intValue]==1)
                            {
                                [cell.cardAccepted setEnabled:false];
                                [cell.cardRejected setEnabled:false];
                                [cell.cardCountered setEnabled:false];
                            }
                            else
                            {
                                if([messageBody.customParameters[@"card_originator"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]] && [messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                                {
                                    [cell.cardAccepted setEnabled:false];
                                    [cell.cardRejected setEnabled:false];
                                    [cell.cardCountered setEnabled:false];
                                }
                                else
                                {
                                    [cell.cardAccepted setEnabled:true];
                                    [cell.cardRejected setEnabled:true];
                                    [cell.cardCountered setEnabled:true];
                                }

                            }
                        }
                    }
                }
                

                
            }
            else
            {
                
                [cell.message setFrame:CGRectMake(padding, padding-13, 240+padding-20 , 126+padding)];
                [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                              cell.message.frame.origin.y+10 - padding/2,
                                                              240+padding,
                                                              126+padding)];
                
                [cell.bubbleImageView setFrame:CGRectMake((padding*0.5f)-2,
                                                          9.8f,
                                                          14,30)];
                cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                cell.message.layer.borderWidth = 2.0f;
                cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                
                cell.PhotoView.frame=CGRectZero;
                cell.PhotoView.image=nil;
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 ,cell.message.frame.origin.y + 5, 248, 326);
                else
                    cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  8 ,cell.message.frame.origin.y + 10, 95, 125);
                cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
                //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
                cell.cardHeading.text = messageBody.customParameters[@"card_heading"];
                
                cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
                cell.cardContent.text = messageBody.customParameters[@"card_content"];
                
                cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
                [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
                
                cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
                [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
                
                if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
                {
                    cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                    cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  8 + 6 ,cell.message.frame.origin.y + 10 +18 , 95-12, 125 -40);
                    cell.cardHeading.numberOfLines=4;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
                    cell.cardHeading.text = [messageBody.customParameters[@"card_heading"] uppercaseString];
                    cell.cardContent.text = [messageBody.customParameters[@"card_content"] uppercaseString];
                    
                }
                else
                {
                    cell.cardHeading.numberOfLines=2;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                    //cell.cardHeading.text = @"";
                    //cell.cardContent.text = @"";
                }

                
                cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
                //cell.cardSender.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"partner_name"] capitalizedString];
                cell.cardSender.text = @"You";
                
                cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 18 - 5, 120, 40);
                
                NSString *card_actionText;
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                {
                    card_actionText = @"ACCEPTED!";
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                {
                    card_actionText = @"REJECTED!";
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                    card_actionText = @"COUNTERED CARD";
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    card_actionText = @"PLAYED A CARD";
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                {
                    //cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 18 - 5, 140, 40);
                    cell.cardPlayed_Countered.text = @"will offer you clicks for";
                }
                else
                cell.cardPlayed_Countered.text = card_actionText;
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                {
                    cell.cardSender.text = @"You made a";
                    cell.cardPlayed_Countered.text = @"COUNTER OFFER";
                }

                cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 48 - 8, 195/2, 8);
                cell.cardBarView.image = [UIImage imageNamed:@"chatBar.png"];
                
                cell.date.textAlignment = NSTextAlignmentLeft;
                cell.backgroundImageView.image = bgImage;
                cell.date.text = [[NSString stringWithFormat:@"%@", time] uppercaseString];
                [cell.date setFrame:CGRectMake(320-55,145, 70, 10)];
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                {
                    [cell.message setFrame:CGRectMake(padding, padding-13, 250+padding-20 , 388+padding - 72)];
                    [cell.backgroundImageView setFrame:CGRectMake( cell.message.frame.origin.x - padding/2,
                                                                  cell.message.frame.origin.y+10 - padding/2,
                                                                  250+padding,
                                                                  388+padding - 72)];
                    
                    if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"false"])
                    {
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x +  1 + 11,cell.message.frame.origin.y + 5 + 7, 248 - 22, 326 - 14);
                        //cell.cardImageView.image = [UIImage imageNamed:@"savewater.png"];
                        [cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        cell.cardHeading.frame = CGRectZero;
                        cell.cardHeading.numberOfLines=2;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                        cell.cardContent.frame = CGRectZero;
                        cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 8, 36, 36);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 75, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 44, 36, 36);
                    }
                    else
                    {
                        cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x -  1.5 +7 ,cell.message.frame.origin.y + 5 + 3, 248-14, 326 - 9);
                        cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                        //[cell.cardImageView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"card_url"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                        cell.cardHeading.frame = CGRectMake(cell.message.frame.origin.x +  25 ,cell.message.frame.origin.y + 5  + 48, 248-48, 326-100);
                        cell.cardHeading.numberOfLines=4;
                        cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                        [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:24]];
                        [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                        cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 14, cell.cardImageView.frame.origin.y + 9, 36, 36);
                        cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 82, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 55, 36, 36);
                    }

                    cell.cardContent.frame = CGRectZero;
                    
                    [cell.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                    
                    [cell.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:34]];
                    
                    cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + 15, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2 , 40, 40);
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardSender.frame.size.width + 5, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 2, 120, 40);
                    cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + 12, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 28 , 224, 2);
                    
                    [cell.date setFrame:CGRectMake(320-49,396 - 72, 70, 10)];
                    
                }

                
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                    
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 19 + 5, cell.cardImageView.frame.origin.y + 53 - 5, 80, 80);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                    
                    [cell.share_btn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectMake(cell.date.frame.origin.x - 5, cell.date.frame.origin.y-25, 30, 30)];
                    cell.share_btn.tag = indexPath.row;
                    [cell.share_btn addTarget:self action:@selector(shareBtnPress:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                /*else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"countered"])
                {
                    cell.cardAcceptedView.frame = CGRectZero;
                    cell.cardAcceptedView.image = nil;
                    
                    cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardAccepted.tag=indexPath.row;
                    [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardRejected.tag=indexPath.row;
                    [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                    [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 98 - 5, 172/2, 33);
                    cell.cardCountered.tag=indexPath.row;
                    [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                    [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                 forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.cardAccepted setEnabled:false];
                    [cell.cardRejected setEnabled:false];
                    [cell.cardCountered setEnabled:false];
                    
                }*/

                else
                {
                    cell.cardAcceptedView.frame = CGRectZero;
                    cell.cardAcceptedView.image = nil;
                    
                    [cell.share_btn setImage:nil forState:UIControlStateNormal];
                    [cell.share_btn setFrame:CGRectZero];
                    
                    cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardAccepted.tag=indexPath.row;
                    [cell.cardAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                    [cell.cardAccepted setEnabled:false];
                    [cell.cardAccepted addTarget:self action:@selector(cardAcceptedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 74, cell.cardImageView.frame.origin.y + 60 - 5, 32, 32);
                    cell.cardRejected.tag=indexPath.row;
                    [cell.cardRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                    [cell.cardRejected setEnabled:false];
                    [cell.cardRejected addTarget:self action:@selector(cardRejectedPressed:)
                                forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 20 - 4, cell.cardImageView.frame.origin.y + 98 - 5 - 4, 188/2, 41);
                    cell.cardCountered.tag=indexPath.row;
                    [cell.cardCountered setImage:[UIImage imageNamed:@"counter.png"] forState:UIControlStateNormal];
                    [cell.cardCountered setEnabled:false];
                    [cell.cardCountered addTarget:self action:@selector(cardCounteredPressed:)
                                 forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.cardAccepted.frame = CGRectZero;
                    cell.cardRejected.frame = CGRectZero;
                    cell.cardCountered.frame =CGRectZero;
                    cell.cardBarView.frame = CGRectZero;
                    
                    if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                    {
                        /*cell.cardAccepted.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 , 32, 32);
                        cell.cardRejected.frame=CGRectMake(cell.cardImageView.frame.origin.x + 20 + 50, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 , 32, 32);
                        cell.cardCountered.frame=CGRectMake(cell.cardImageView.frame.origin.x + 138 - 4, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height + 36 - 4, 188/2, 41);*/
                        
                        cell.cardAccepted.frame = CGRectZero;
                        cell.cardRejected.frame = CGRectZero;
                        cell.cardCountered.frame =CGRectZero;
                        cell.cardSender.frame =CGRectZero;
                        cell.cardPlayed_Countered.frame =CGRectZero;
                    }

                    
                    
                    for(int i=0;i<card_accept_status.count;i++)
                    {
                        if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==indexPath.row)
                        {
                            if([[[card_accept_status objectAtIndex:i] objectForKey:@"status"] intValue]==1)
                            {
                                [cell.cardAccepted setEnabled:false];
                                [cell.cardRejected setEnabled:false];
                                [cell.cardCountered setEnabled:false];
                            }
                            else
                            {
                                if([messageBody.customParameters[@"card_originator"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]] && [messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                                {
                                    [cell.cardAccepted setEnabled:false];
                                    [cell.cardRejected setEnabled:false];
                                    [cell.cardCountered setEnabled:false];
                                }
                                else
                                {
                                    [cell.cardAccepted setEnabled:true];
                                    [cell.cardRejected setEnabled:true];
                                    [cell.cardCountered setEnabled:true];
                                }

                            }
                        }
                    }
                }
                
                
            }

        }
        else
        {
            cell.cardAccepted.frame=CGRectZero;
            cell.cardAcceptedView.frame=CGRectZero;
            cell.cardBarView.frame=CGRectZero;
            cell.cardBottomClicks.frame=CGRectZero;
            cell.cardContent.frame=CGRectZero;
            cell.cardCountered.frame=CGRectZero;
            cell.cardHeading.frame=CGRectZero;
            cell.cardImageView.frame=CGRectZero;
            cell.cardPlayed_Countered.frame=CGRectZero;
            cell.cardRejected.frame=CGRectZero;
            cell.cardSender.frame=CGRectZero;
            cell.cardTopClicks.frame=CGRectZero;
            
        }
        
        /*
        if(messageBody.ID.length>=5)
            cell.share_btn.enabled = true;
        else
            cell.share_btn.enabled = false;*/
        
        if(cell.message.text.length==0 && [messageBody.customParameters[@"card_heading"] length]==0)
        {
            [cell.message setFrame:CGRectZero];
        }
        
        if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shared"])
        {
            cell.share_btn.frame = CGRectZero;
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                
                cell.shareHeading.frame = CGRectMake(320 - 32 - 215, 7, 215, 35);
                NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                NSString *first;
                if([substrings count] != 0)
                {
                    first = [substrings objectAtIndex:0];
                    cell.shareHeading.text = [first capitalizedString];
                }
                
                cell.shareHeading.text = [cell.shareHeading.text stringByAppendingString:@" wants to share"];
                
                UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
                UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                //              UIColor *foregroundColor = [UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
                
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       boldFont, NSFontAttributeName,nil];
                NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          regularFont, NSFontAttributeName, nil];
                const NSRange range = NSMakeRange(0,[first length]);
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:cell.shareHeading.text
                                                       attributes:attrs];
                [attributedText setAttributes:subAttrs range:range];
                [cell.shareHeading setAttributedText:attributedText];
                
                
                cell.shareBarImgView.frame = CGRectMake(320-28-220, 39, 220, 2);
                cell.shareBarImgView.image = [UIImage imageNamed:@"bar.png"];
                
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_bubble_border.png"];
                [cell.message setBackgroundColor:[UIColor clearColor]]; // owner gray chat popup
                
                cell.message.frame = CGRectMake(/*cell.message.frame.origin.x - 17.5f - 35*/ 320-20-228, 45, 220, cell.message.frame.size.height);
                
                if(cell.message.text.length == 0)
                    cell.message.frame = CGRectMake(320-20-228, 0, 0, 0);
                
                
                
                float imageHeight=0;
                
                //check for image
                if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                {
                    cell.imageSentView.frame = CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                    cell.imageSentView.layer.borderWidth = 0;
                    cell.PhotoView.frame = cell.imageSentView.frame;
                    imageHeight = 100;
                }
                if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 )
                {
                    cell.ThumbnailPhotoView.frame = CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                    cell.ThumbnailPhotoView.layer.borderWidth = 0;
                    cell.VideoSentView.frame = cell.ThumbnailPhotoView.frame;
                    cell.VideoSentView.layer.borderWidth = 0;
                    imageHeight = 100;
                }
                
                if([messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                {
                    cell.sound_iconView.frame=CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                    cell.sound_bgView.frame = CGRectZero;
                    [cell.play_btn setImage:nil forState:UIControlStateNormal];
                    cell.play_btn.frame = cell.sound_iconView.frame;
                    imageHeight = 100;
                }
                
                if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                {
                    cell.LocationSentView.frame=CGRectMake(cell.message.frame.origin.x  , 42.5f, 100, 100);
                    cell.LocationView.frame = cell.LocationSentView.frame;
                    imageHeight = 100;
                }
                
                //-------for displaying cards------------
                if([messageBody.customParameters[@"card_heading"] length]>0)
                {
                    
                    imageHeight = 130;
                    
                    cell.cardImageView.frame = CGRectMake(cell.cardImageView.frame.origin.x+5, cell.cardImageView.frame.origin.y+30, cell.cardImageView.frame.size.width, cell.cardImageView.frame.size.height);
                    cell.cardHeading.frame = CGRectMake(cell.cardHeading.frame.origin.x+5, cell.cardHeading.frame.origin.y+30, cell.cardHeading.frame.size.width, cell.cardHeading.frame.size.height);
                    cell.cardContent.frame = CGRectMake(cell.cardContent.frame.origin.x+5, cell.cardContent.frame.origin.y+30, cell.cardContent.frame.size.width, cell.cardContent.frame.size.height);
                    cell.cardTopClicks.frame = CGRectMake(cell.cardTopClicks.frame.origin.x+5, cell.cardTopClicks.frame.origin.y+30, cell.cardTopClicks.frame.size.width, cell.cardTopClicks.frame.size.height);
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardBottomClicks.frame.origin.x+5, cell.cardBottomClicks.frame.origin.y+30, cell.cardBottomClicks.frame.size.width, cell.cardBottomClicks.frame.size.height);
                    cell.cardSender.frame = CGRectMake(cell.cardSender.frame.origin.x+5, cell.cardSender.frame.origin.y+30, cell.cardSender.frame.size.width, cell.cardSender.frame.size.height);
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardPlayed_Countered.frame.origin.x+5, cell.cardPlayed_Countered.frame.origin.y+30, cell.cardPlayed_Countered.frame.size.width, cell.cardPlayed_Countered.frame.size.height);
                    cell.cardBarView.frame = CGRectMake(cell.cardBarView.frame.origin.x+5, cell.cardBarView.frame.origin.y+30, cell.cardBarView.frame.size.width, cell.cardBarView.frame.size.height);
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardAcceptedView.frame.origin.x+5, cell.cardAcceptedView.frame.origin.y+28, cell.cardAcceptedView.frame.size.width, cell.cardAcceptedView.frame.size.height);
                    
                    if([messageBody.customParameters[@"isMessageSender"] isEqualToString:@"true"])
                    {
                        NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                        if([substrings count] != 0)
                        {
                            NSString *first = [substrings objectAtIndex:0];
                            cell.cardSender.text = [first uppercaseString];
                            first = nil;
                        }
                        substrings = nil;
                    }
                    else
                    {
                        cell.cardSender.text = @"You";
                    }
                    
                    cell.shareBottomBarImgView.frame = CGRectMake(320-28-220, 46 + imageHeight, 220, 2);
                    cell.shareBottomBarImgView.image = [UIImage imageNamed:@"bar.png"];
                }
                else
                {
                    cell.shareBottomBarImgView.frame = CGRectZero;
                }
                
                
                cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, cell.message.frame.size.height);
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor clearColor] CGColor];
                cell.message.layer.cornerRadius = 0;
                
                CGSize textSize = { 220.0, 8461.53};
                if(cell.message.text.length > 0)
                {
                    CGSize newSize = [cell.message.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                                   constrainedToSize:textSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
                    
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, newSize.height+18);
                    
                    
                }
                
                cell.bubbleImageView.frame = CGRectMake(cell.bubbleImageView.frame.origin.x, cell.message.frame.origin.y + cell.message.frame.size.height - cell.bubbleImageView.frame.size.height + 22, cell.bubbleImageView.frame.size.width, cell.bubbleImageView.frame.size.height);
                
                cell.backgroundImageView.frame = CGRectMake(cell.message.frame.origin.x-7.5f, 7, 235, cell.message.frame.size.height+45+imageHeight+42);
                cell.backgroundImageView.backgroundColor = [UIColor whiteColor];
                cell.backgroundImageView.layer.borderWidth = 2;
                cell.backgroundImageView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                    cell.message.textColor = [UIColor whiteColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    
                    if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    else
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                    cell.message.textColor = [UIColor whiteColor];
                }
                else
                {
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                    cell.message.textColor = [UIColor blackColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                
                cell.shareAccepted.frame=CGRectMake(cell.backgroundImageView.frame.origin.x + 10, cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 42, 32, 32);
                cell.shareAccepted.tag=indexPath.row-1;
                [cell.shareAccepted setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                [cell.shareAccepted setEnabled:true];
                [cell.shareAccepted addTarget:self action:@selector(shareAcceptedPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                
                cell.shareRejected.frame=CGRectMake(cell.backgroundImageView.frame.origin.x + 62, cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 42, 32, 32);
                cell.shareRejected.tag=indexPath.row-1;
                [cell.shareRejected setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
                [cell.shareRejected setEnabled:true];
                [cell.shareRejected addTarget:self action:@selector(shareRejectedPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                
                if([messageBody.customParameters[@"isAccepted"] isEqualToString:@"yes"] || [messageBody.customParameters[@"isAccepted"] isEqualToString:@"no"])
                {
                    [cell.shareAccepted setEnabled:false];
                    [cell.shareRejected setEnabled:false];
                }
                else
                {
                    [cell.shareAccepted setEnabled:true];
                    [cell.shareRejected setEnabled:true];
                }

                
                
                [cell.date setFrame:CGRectMake(-7 , cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 12, 70, 10)];
            }
            else
            {
                cell.shareHeading.frame = CGRectMake(28, 7, 215, 35);
                cell.shareHeading.text = @"You want to share";
                cell.shareBarImgView.frame = CGRectMake(26, 37, 220, 6);
                cell.shareBarImgView.image = [UIImage imageNamed:@"chatBar.png"];
                cell.shareBottomBarImgView.frame = CGRectZero;
                
                cell.shareAccepted.frame = CGRectZero;
                cell.shareRejected.frame = CGRectZero;
                
                cell.bubbleImageView.image=[UIImage imageNamed:@"new_left_grey.png"];
                [cell.message setBackgroundColor:[UIColor clearColor]]; // owner gray chat popup
                
                if(cell.message.text.length == 0)
                    cell.message.frame = CGRectMake(20, 0, 0, 0);
                
                
                float imageHeight=0;
                
                //check for image
                if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"isFileUploading"] length]>0)
                {
                    cell.imageSentView.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                    cell.imageSentView.layer.borderWidth = 0;
                    cell.PhotoView.frame = cell.imageSentView.frame;
                    imageHeight = 100;
                }
                if([messageBody.customParameters[@"videoID"]  length]>0 || [messageBody.customParameters[@"isVideoUploading"] integerValue]==1 )
                {
                    cell.ThumbnailPhotoView.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                    cell.ThumbnailPhotoView.layer.borderWidth = 0;
                    cell.VideoSentView.frame = cell.ThumbnailPhotoView.frame;
                    cell.VideoSentView.layer.borderWidth = 0;
                    imageHeight = 100;
                }
                
                if([messageBody.customParameters[@"audioID"]  length]>0 || [messageBody.customParameters[@"isAudioUploading"] length]>0)
                {
                    cell.sound_iconView.frame=CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                    cell.sound_bgView.frame = CGRectZero;
                    [cell.play_btn setImage:nil forState:UIControlStateNormal];
                    cell.play_btn.frame = cell.sound_iconView.frame;
                    imageHeight = 100;
                }
                
                if([messageBody.customParameters[@"locationID"] length]>1 ||[messageBody.customParameters[@"isLocationUploading"] length]>0)
                {
                    cell.LocationSentView.frame=CGRectMake(cell.message.frame.origin.x + 7.5f, 42.5f, 100, 100);
                    cell.LocationView.frame = cell.LocationSentView.frame;
                    imageHeight = 100;
                }
                
                //-------for displaying cards------------
                if([messageBody.customParameters[@"card_heading"] length]>0)
                {
                    
                    imageHeight = 130;
                    
                    cell.cardImageView.frame = CGRectMake(cell.cardImageView.frame.origin.x, cell.cardImageView.frame.origin.y+30, cell.cardImageView.frame.size.width, cell.cardImageView.frame.size.height);
                    cell.cardHeading.frame = CGRectMake(cell.cardHeading.frame.origin.x, cell.cardHeading.frame.origin.y+30, cell.cardHeading.frame.size.width, cell.cardHeading.frame.size.height);
                    cell.cardContent.frame = CGRectMake(cell.cardContent.frame.origin.x, cell.cardContent.frame.origin.y+30, cell.cardContent.frame.size.width, cell.cardContent.frame.size.height);
                    cell.cardTopClicks.frame = CGRectMake(cell.cardTopClicks.frame.origin.x, cell.cardTopClicks.frame.origin.y+30, cell.cardTopClicks.frame.size.width, cell.cardTopClicks.frame.size.height);
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardBottomClicks.frame.origin.x, cell.cardBottomClicks.frame.origin.y+30, cell.cardBottomClicks.frame.size.width, cell.cardBottomClicks.frame.size.height);
                    cell.cardSender.frame = CGRectMake(cell.cardSender.frame.origin.x, cell.cardSender.frame.origin.y+30, cell.cardSender.frame.size.width, cell.cardSender.frame.size.height);
                    cell.cardPlayed_Countered.frame = CGRectMake(cell.cardPlayed_Countered.frame.origin.x, cell.cardPlayed_Countered.frame.origin.y+30, cell.cardPlayed_Countered.frame.size.width, cell.cardPlayed_Countered.frame.size.height);
                    cell.cardBarView.frame = CGRectMake(cell.cardBarView.frame.origin.x, cell.cardBarView.frame.origin.y+30, cell.cardBarView.frame.size.width, cell.cardBarView.frame.size.height);
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardAcceptedView.frame.origin.x, cell.cardAcceptedView.frame.origin.y+28, cell.cardAcceptedView.frame.size.width, cell.cardAcceptedView.frame.size.height);
                    
                    if([messageBody.customParameters[@"isMessageSender"] isEqualToString:@"false"])
                    {
                        NSArray *substrings = [partner_name componentsSeparatedByString:@" "];
                        if([substrings count] != 0)
                        {
                            NSString *first = [substrings objectAtIndex:0];
                            cell.cardSender.text = [first uppercaseString];
                            first = nil;
                        }
                        substrings = nil;
                    }
                    else
                    {
                        cell.cardSender.text = @"You";
                    }
                }
                
                cell.message.frame = CGRectMake(cell.message.frame.origin.x + 7.5f, 45+imageHeight, 220, cell.message.frame.size.height);
                cell.message.layer.borderWidth = 0.0f;
                cell.message.layer.borderColor = [[UIColor clearColor] CGColor];
                cell.message.layer.cornerRadius = 0;
                
                CGSize textSize = { 220.0, 8461.53};
                if(cell.message.text.length > 0)
                {
                    CGSize newSize = [cell.message.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                                   constrainedToSize:textSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
                    
                    cell.message.frame = CGRectMake(cell.message.frame.origin.x, 45+imageHeight, 220, newSize.height+18);
                    
                    
                }
                
                cell.bubbleImageView.frame = CGRectMake(cell.bubbleImageView.frame.origin.x, cell.message.frame.origin.y + cell.message.frame.size.height - cell.bubbleImageView.frame.size.height + 22, cell.bubbleImageView.frame.size.width, cell.bubbleImageView.frame.size.height);
                
                cell.backgroundImageView.frame = CGRectMake(cell.message.frame.origin.x-7.5f, 7, 235, cell.message.frame.size.height+45+imageHeight);
                cell.backgroundImageView.backgroundColor = [UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0];
                cell.backgroundImageView.layer.borderWidth = 2;
                cell.backgroundImageView.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0]];
                    cell.message.textColor = [UIColor whiteColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                    
                    if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+30,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    else
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    cell.clicksImageView.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
                    cell.message.textColor = [UIColor whiteColor];
                }
                else
                {
                    
                    //[cell.message setBackgroundColor:[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0]]; // owner gray chat popup
                    [cell.message setBackgroundColor:[UIColor whiteColor]];
                    cell.message.textColor = [UIColor blackColor];
                    cell.message.layer.borderWidth = 0.0f;
                    cell.message.layer.borderColor = [[UIColor colorWithRed:(203.0/255.0) green:(203.0/255.0) blue:(203.0/255.0) alpha:1.0] CGColor];
                }
                
                [cell.date setFrame:CGRectMake(258 , cell.backgroundImageView.frame.origin.y + cell.backgroundImageView.frame.size.height - 12, 70, 10)];
                
            }
            
            
        }
        else
        {
            cell.shareHeading.frame = CGRectZero;
            cell.shareBarImgView.frame = CGRectZero;
            cell.shareBottomBarImgView.frame = CGRectZero;
            cell.backgroundImageView.frame = CGRectZero;
            cell.message.layer.cornerRadius = 4.0f;
            cell.shareAccepted.frame = CGRectZero;
            cell.shareRejected.frame = CGRectZero;
        }
        
        if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shareAccepted"])
        {
            [cell.message setBackgroundColor:[UIColor colorWithRed:81/255.0 green:204/255.0 blue:211/255.0 alpha:1]];
            cell.message.textColor = [UIColor colorWithRed:96/255.0 green:96/255.0 blue:134/255.0 alpha:1];
            cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            cell.message.layer.borderWidth = 0.0f;
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_blue_bubble.png"];
            }
            else
                cell.bubbleImageView.image=[UIImage imageNamed:@"left_blue_bubble.png"];
            
        }
        
        if([messageBody.customParameters[@"shareStatus"] length]>0 && [messageBody.customParameters[@"shareStatus"] isEqualToString:@"shareRejected"])
        {
            [cell.message setBackgroundColor:[UIColor colorWithRed:50/255.0 green:69/255.0 blue:102/255.0 alpha:1]];
            cell.message.textColor = [UIColor colorWithRed:88/255.0 green:216/255.0 blue:233/255.0 alpha:1];
            cell.message.layer.borderWidth = 0.0f;
            cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.bubbleImageView.image=[UIImage imageNamed:@"right_darkblue_bubble.png"];
                cell.message.frame = CGRectMake(cell.message.frame.origin.x-10, cell.message.frame.origin.y, cell.message.frame.size.width+10, cell.message.frame.size.height);
                cell.date.frame = CGRectMake(cell.date.frame.origin.x-10, cell.date.frame.origin.y, cell.date.frame.size.width, cell.date.frame.size.height);
            }
            else
            {
                cell.bubbleImageView.image=[UIImage imageNamed:@"left_darkblue_bubble.png"];
                cell.message.frame = CGRectMake(cell.message.frame.origin.x, cell.message.frame.origin.y, cell.message.frame.size.width+10, cell.message.frame.size.height);
                cell.date.frame = CGRectMake(cell.date.frame.origin.x+10, cell.date.frame.origin.y, cell.date.frame.size.width, cell.date.frame.size.height);
            }
        }
        
        if([messageBody.customParameters[@"isDelivered"] isEqualToString:@"yes"])
        {
            if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]])
            {
                cell.deliveredIcon.frame = CGRectMake(cell.date.frame.origin.x+39, cell.date.frame.origin.y-1, 34/2, 25/2);
                cell.deliveredIcon.image= [UIImage imageNamed:@"tick.png"];
            }
            else
                cell.deliveredIcon.frame = CGRectZero;
        }
        else
        {
            //inn
            cell.deliveredIcon.frame = CGRectZero;
        }


        
//        if([messageBody.customParameters[@"isComposing"] length] > 0)
//        {
//            cell.istypingImgView.frame = CGRectMake(265, 12, 30, 30);
//            //cell.istypingImgView.image = [UIImage imageNamed:@"IsTyping_1.png"];
//            
//            NSMutableArray *images = [[NSMutableArray alloc] init];
//            for (int i = 1; i <= 3; i++) {
//                [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"IsTyping_%i.png",i]]];
//            }
//            
//            // Normal Animation
//            cell.istypingImgView.animationImages = images;
//            cell.istypingImgView.animationDuration = 1;
//            cell.istypingImgView.animationRepeatCount = 0;
//            [cell.istypingImgView startAnimating];
//
//            
//            cell.shareHeading.frame = CGRectZero;
//            cell.shareBarImgView.frame = CGRectZero;
//            cell.shareAccepted.frame = CGRectZero;
//            cell.shareRejected.frame = CGRectZero;
//            cell.date.hidden = YES;
//            cell.backgroundImageView.frame = CGRectZero;
//            cell.clicksImageView.frame = CGRectZero;
//            cell.imageSentView.frame = CGRectZero;
//            cell.PhotoView.frame = CGRectZero;
//            cell.VideoSentView.frame = CGRectZero;
//            cell.ThumbnailPhotoView.frame = CGRectZero;
//            cell.play_btn.frame=CGRectZero;
//            cell.sound_iconView.frame=CGRectZero;
//            cell.sound_bgView.frame=CGRectZero;
//            cell.downloadingView.frame = CGRectZero;
//            [cell.share_btn setImage:nil forState:UIControlStateNormal];
//            [cell.share_btn setFrame:CGRectZero];
//            cell.LocationView.frame = CGRectZero;
//            cell.LocationSentView.frame = CGRectZero;
//            cell.cardAccepted.frame=CGRectZero;
//            cell.cardAcceptedView.frame=CGRectZero;
//            cell.cardBarView.frame=CGRectZero;
//            cell.cardBottomClicks.frame=CGRectZero;
//            cell.cardContent.frame=CGRectZero;
//            cell.cardCountered.frame=CGRectZero;
//            cell.cardHeading.frame=CGRectZero;
//            cell.cardImageView.frame=CGRectZero;
//            cell.cardPlayed_Countered.frame=CGRectZero;
//            cell.cardRejected.frame=CGRectZero;
//            cell.cardSender.frame=CGRectZero;
//            cell.cardTopClicks.frame=CGRectZero;
//        }
//        else
//        {
//            cell.istypingImgView.frame =  CGRectZero;
//            cell.date.hidden = NO;
//        }
        
        if([messageBody.customParameters[@"isDelivered"] isEqualToString:@"yes"])
        {
            if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]])
            {
                cell.deliveredIcon.frame = CGRectMake(cell.date.frame.origin.x+39, cell.date.frame.origin.y-1, 34/2, 25/2);
                cell.deliveredIcon.image= [UIImage imageNamed:@"tick.png"];
            }
            else
                cell.deliveredIcon.frame = CGRectZero;
        }
        else
        {
            //cell.deliveredIcon.frame = CGRectZero;
            
            if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%lu",(unsigned long)messageBody.senderID]])
            {
                cell.deliveredIcon.frame = CGRectMake(cell.date.frame.origin.x+39, cell.date.frame.origin.y-1, 28/2, 25/2);
                
                cell.deliveredIcon.image= [UIImage imageNamed:@"singleTick.png"];
                
            }
            else
                cell.deliveredIcon.frame = CGRectZero;
        }

    }
    
    [cell.bubbleImageView setFrame:CGRectMake(cell.bubbleImageView.frame.origin.x,
                                              cell.date.frame.origin.y-22,
                                              14,30)];
    
    
    
    
    if(isChatHistoryOrNot == TRUE && indexPath.row == 0)
    {
        cell.animationView.frame=CGRectMake(cell.animationView.frame.origin.x, cell.animationView.frame.origin.y, cell.animationView.frame.size.width, 50);
    }
    else
    {
        //inn
        QBChatMessage *chatMessage;
        if(isChatHistoryOrNot == TRUE)
            chatMessage = (QBChatMessage *)[messages objectAtIndex:indexPath.row-1];
        else
            chatMessage = (QBChatMessage *)[messages objectAtIndex:indexPath.row];
        
        NSString *text = chatMessage.text;
        
        if([chatMessage.customParameters[@"shareStatus"] length]>0 && [chatMessage.customParameters[@"shareStatus"] isEqualToString:@"shared"])
        {
            CGSize text_Size = { 220.0, 8461.53};
            //if(text.length > 0)
            {
                CGSize newSize = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                  constrainedToSize:text_Size
                                      lineBreakMode:NSLineBreakByWordWrapping];
                CGSize heightOfRow;
                heightOfRow.height = 0;
                if(chatMessage.text.length > 0)
                    heightOfRow.height+=newSize.height+18;
                heightOfRow.height+=55;
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                    heightOfRow.height += 43;
                
                if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0 || [chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
                {
                    //float imageHeight = 100/[chatMessage.customParameters[@"imageRatio"] floatValue];
                    
                    if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                        heightOfRow.height += 100;
                    else
                        heightOfRow.height += 100;
                }
                
                if([chatMessage.customParameters[@"card_heading"] length]>0)
                    heightOfRow.height += 130;
                
                
                cell.animationView.frame=CGRectMake(cell.animationView.frame.origin.x, cell.animationView.frame.origin.y, cell.animationView.frame.size.width, heightOfRow.height);
                
            }
        }
        else
        {
            CGSize  textSize = { 200.0, 7690.0 };
            
            if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
            {
                textSize = CGSizeMake(180.0, 6921.0);
            }
            else if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
                textSize = CGSizeMake(180.0, 8651.25);
            
            
            CGSize size;
            if((chatMessage.text == (NSString*)[NSNull null] && [chatMessage.customParameters[@"card_heading"] length]==0) || ([chatMessage.text isEqualToString:@""] && [chatMessage.customParameters[@"card_heading"] length]==0))
                size = CGSizeZero;
            else
            {
                size = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                        constrainedToSize:textSize
                            lineBreakMode:NSLineBreakByWordWrapping];
                
                size.height += padding;
            }
            
            
            if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
            {
                if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                    size.height += 125;
                else
                    size.height += 175;
            }
            
            if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1)
            {
                if(![chatMessage.customParameters[@"clicks"] isEqualToString:@"no"] && [chatMessage.customParameters[@"clicks"]length]>0)
                {
                    size.height += 175;
                }
                else
                {
                    size.height += 175;
                }
            }
            
            if([chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
            {
                size.height += 49;
            }
            
            if([chatMessage.customParameters[@"card_heading"] length]>0)
            {
                if([chatMessage.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                {
                    if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                        size.height += 305;
                    else
                        size.height += 380;
                }
                else
                    size.height += 115;
            }
        
            cell.animationView.frame=CGRectMake(cell.animationView.frame.origin.x, cell.animationView.frame.origin.y, cell.animationView.frame.size.width, size.height+padding-11);
        }
        
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if(isChatHistoryOrNot == TRUE)
    {
        if(indexPath.row==messages.count && appDelegate.play_chatAnimation)
        {
            appDelegate.play_chatAnimation =false;
            QBChatMessage *messageBody = [messages objectAtIndex:[indexPath row]-1];
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.animationView.duration = 0.3;
                cell.animationView.delay    = 0.0;
                cell.animationView.type     = CSAnimationTypeSlideLeft;
            }
            else {
                cell.animationView.duration = 0.3;
                cell.animationView.delay    = 0.0;
                cell.animationView.type     = CSAnimationTypeSlideRight;
            }
        }
        else
        {
            cell.animationView.duration = 0.0;
            cell.animationView.delay    = 0.0;
            cell.animationView.type     = Nil;
        }
    }
    else
    {
        if(indexPath.row==messages.count-1 && appDelegate.play_chatAnimation)
        {
            appDelegate.play_chatAnimation=false;
            
            QBChatMessage *messageBody = [messages objectAtIndex:[indexPath row]];
            
            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",messageBody.senderID]] )
            {
                cell.animationView.duration = 0.3;
                cell.animationView.delay    = 0.0;
                cell.animationView.type     = CSAnimationTypeSlideLeft;
            }
            else {
                cell.animationView.duration = 0.3;
                cell.animationView.delay    = 0.0;
                cell.animationView.type     = CSAnimationTypeSlideRight;
            }
            
        }
        else
        {
            cell.animationView.duration = 0.0;
            cell.animationView.delay    = 0.0;
            cell.animationView.type     = Nil;
        }
    }
    
    appDelegate = nil;
    
    //cell.animationView.frame=CGRectMake(cell.animationView.frame.origin.x, cell.animationView.frame.origin.y, cell.animationView.frame.size.width, cell.animationView.frame.size.height+cell.message.frame.size.height);
    //cell.animationView.backgroundColor = [UIColor redColor];
    
    
    [cell.animationView startCanvasAnimation];
    
	return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isChatHistoryOrNot == TRUE)
    {
        NSLog(@"Check 1 %d",[self.messages count]+1);
        return [self.messages count]+1;
        
    }
    else
    {
        NSLog(@"Check 2 %d",[self.messages count]);
        return [self.messages count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath %lu",(unsigned long)[self.messages count]);
    NSLog(@"%ld",(long)indexPath.row);
    if(isChatHistoryOrNot == TRUE)
    {
        if(indexPath.row == 0)
        {
            return 50;
        }
        else
        {
            QBChatMessage *chatMessage = (QBChatMessage *)[messages objectAtIndex:indexPath.row-1];
            NSString *text = chatMessage.text;
            
            if([chatMessage.customParameters[@"shareStatus"] length]>0 && [chatMessage.customParameters[@"shareStatus"] isEqualToString:@"shared"])
            {
                CGSize text_Size = { 220.0, 8461.53};
                //if(text.length > 0)
                {
                    CGSize newSize = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                                   constrainedToSize:text_Size
                                                       lineBreakMode:NSLineBreakByWordWrapping];
                    CGSize heightOfRow;
                    heightOfRow.height = 0;
                    if(chatMessage.text.length > 0)
                        heightOfRow.height+=newSize.height+18;
                    heightOfRow.height+=55;
                    if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                        heightOfRow.height += 43;
                    
                    if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0 || [chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
                    {
                        //float imageHeight = 100/[chatMessage.customParameters[@"imageRatio"] floatValue];
                        
                        if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                            heightOfRow.height += 100;
                        else
                            heightOfRow.height += 100;
                    }

                    if([chatMessage.customParameters[@"card_heading"] length]>0)
                        heightOfRow.height += 130;

                    
                    return heightOfRow.height;
                    
                }
            }
            
            CGSize  textSize = { 200.0, 7690.0 };
            
            
            
            if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
            {
                textSize = CGSizeMake(150.0, 6921.0);
            }
            else if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
                textSize = CGSizeMake(150.0, 8651.25);
            
                
            CGSize size;
            if((chatMessage.text == (NSString*)[NSNull null] && [chatMessage.customParameters[@"card_heading"] length]==0) || ([chatMessage.text isEqualToString:@""] && [chatMessage.customParameters[@"card_heading"] length]==0))
                size = CGSizeZero;
            else
            {
//                size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16]
//                           constrainedToSize:textSize
//                               lineBreakMode:NSLineBreakByWordWrapping];
                
                size = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                           constrainedToSize:textSize
                               lineBreakMode:NSLineBreakByWordWrapping];
                
                size.height += padding;
            }
            
            
            if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
            {
                //float imageHeight = 225/[chatMessage.customParameters[@"imageRatio"] floatValue];
                /*if(imageHeight<=125)
                    size.height += 125;
                else*/
                if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                    size.height += 125;
                else
                    size.height += 175;
            }
            
            if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1)
            {
                if(![chatMessage.customParameters[@"clicks"] isEqualToString:@"no"] && [chatMessage.customParameters[@"clicks"]length]>0)
                {
                    size.height += 175;
                }
                else
                {
                    size.height += 175;
                }
            }
            
            if([chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
            {
                size.height += 49;
            }
            
            if([chatMessage.customParameters[@"card_heading"] length]>0)
            {
                if([chatMessage.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
                {
                    if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                        size.height += 305;
                    else
                        size.height += 380;
                }
                else
                    size.height += 115;
            }
            
            return size.height+padding-11;
        }
    }
    else
    {
        QBChatMessage *chatMessage = (QBChatMessage *)[messages objectAtIndex:indexPath.row];
        NSString *text = chatMessage.text;
        
        if([chatMessage.customParameters[@"shareStatus"] length]>0 && [chatMessage.customParameters[@"shareStatus"] isEqualToString:@"shared"])
        {
            CGSize text_Size = { 220.0, 8461.53};
            //if(text.length > 0)
            {
                CGSize newSize = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
                                  constrainedToSize:text_Size
                                      lineBreakMode:NSLineBreakByWordWrapping];
                CGSize heightOfRow;
                heightOfRow.height = 0;
                if(chatMessage.text.length > 0)
                    heightOfRow.height+=newSize.height+18;
                heightOfRow.height+=55;
                if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                    heightOfRow.height += 43;
                
                if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0 || [chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
                {
                    //float imageHeight = 100/[chatMessage.customParameters[@"imageRatio"] floatValue];
                    
                    if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                        heightOfRow.height += 100;
                    else
                        heightOfRow.height += 100;
                }
                
                if([chatMessage.customParameters[@"card_heading"] length]>0)
                    heightOfRow.height += 130;
                
                
                return heightOfRow.height;
                
            }
        }
        
        CGSize  textSize = { 200.0, 7690.0 };
        
        if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1 || [chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
        {
            textSize = CGSizeMake(150.0, 6921.0);
        }
        else if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
            textSize = CGSizeMake(150.0, 8651.25);

        
        CGSize size;
        if((chatMessage.text == (NSString*)[NSNull null] && [chatMessage.customParameters[@"card_heading"] length]==0) || ([chatMessage.text isEqualToString:@""] && [chatMessage.customParameters[@"card_heading"] length]==0))
            size = CGSizeZero;
        else
        {
//            size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16]
//                       constrainedToSize:textSize
//                           lineBreakMode:NSLineBreakByWordWrapping];
            
//            CGSize size;
//            if(![chatMessage.customParameters[@"clicks"] isEqualToString:@"no"] && [chatMessage.customParameters[@"clicks"]length]>0)
//            {
//                CGRect rect = [text boundingRectWithSize:textSize
//                                                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                                                        context:nil];
//                
//                //
//                //                  CGRect labelRect = [cell.message.text boundingRectWithSize:textSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:cell.message.font} context:nil];
//                //                 size = labelRect.size;
//                //                size = CGSizeMake(300, 2);
//                
//                size =  CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
//                
//            }
//            else
//            {
//                size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
//                           constrainedToSize:textSize
//                               lineBreakMode:NSLineBreakByWordWrapping];
//                
//            }
            
            size = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                       constrainedToSize:textSize
                           lineBreakMode:NSLineBreakByWordWrapping];
            
            size.height += padding;
        }
        
        if([chatMessage.customParameters[@"fileID"]  length]>0 || [chatMessage.customParameters[@"isFileUploading"] length]>0 || [chatMessage.customParameters[@"locationID"] length]>1 ||[chatMessage.customParameters[@"isLocationUploading"] length]>0)
        {
            //float imageHeight = 225/[chatMessage.customParameters[@"imageRatio"] floatValue];
            /*if(imageHeight<=125)
             size.height += 125;
             else*/
            if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                size.height += 125;
            else
                size.height += 175;
        }
        if([chatMessage.customParameters[@"videoID"]  length]>0 || [chatMessage.customParameters[@"isVideoUploading"] integerValue]==1)
        {
            if(![chatMessage.customParameters[@"clicks"] isEqualToString:@"no"] && [chatMessage.customParameters[@"clicks"]length]>0)
            {
                size.height += 175;
            }
            else
            {
                size.height += 175;
            }
        }
        if([chatMessage.customParameters[@"audioID"]  length]>0 || [chatMessage.customParameters[@"isAudioUploading"] length]>0)
        {
            size.height += 49;
        }
        
        if([chatMessage.customParameters[@"card_heading"] length]>0)
        {
            if([chatMessage.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"nil"])
            {
                if([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",chatMessage.senderID]] )
                    size.height += 305;
                else
                    size.height += 380;
            }
            else
                size.height += 115;
        }
        
//        return size.height+padding-11;
         return size.height+padding;
    }
}

- (void)shareAcceptedPressed:(UIButton*)sender
{
    UIButton* sender_btn = (UIButton*)sender;
    UITableViewCell *cell;
    
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender_btn superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[[sender_btn superview] superview]superview ];
    }
    
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    //NSLog(@"%d",indexPath.row);
    
    QBChatMessage *chat_message;
    
    if(isChatHistoryOrNot == FALSE)
    {
        chat_message= [messages objectAtIndex:indexPath.row];
    }
    else
    {
        chat_message= [messages objectAtIndex:indexPath.row-1];
    }
    
    
//    if(messages.count < 20)
//    {
//        chat_message= [messages objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        chat_message= [messages objectAtIndex:indexPath.row-1];
//    }

    
    NSMutableDictionary *customObj = [[NSMutableDictionary alloc] init] ;
    [customObj addEntriesFromDictionary:chat_message.customParameters];
    [customObj setObject:@"yes" forKey:@"isAccepted"];
    [chat_message setCustomParameters:customObj];
    customObj = nil;
    
//    chat_message.customParameters[@"isAccepted"] = @"yes";
    
    //update share accepted status in local storage
    //////////////////////////////////////////////////////////// local storage/////////////////////////////////////////////////////////////////////////////////
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]];
    
    NSMutableArray *ArrayMessages;
    
    NSRange RangeMessages;
    if(messages.count > 20)
    {
        RangeMessages.location = [messages count] - 20;
        RangeMessages.length = 20;
    }
    else
    {
        RangeMessages.location = 0;
        RangeMessages.length = [messages count];
    }
    
    ArrayMessages = [[messages subarrayWithRange:RangeMessages] mutableCopy];
    
    NSMutableArray *arrCardStatus = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayCardStatus"])
    {
        arrCardStatus=nil;
        arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
    }
    
    NSMutableArray *arrTempImages = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayImagedata"])
    {
        arrTempImages = nil;
        arrTempImages = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
    }
    
    NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayAudioData"])
    {
        arrTempAudio = nil;
        arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
    }
    
    
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
    
    [prefs setObject:tempDict forKey:self.strRelationShipId];
    
    [prefs synchronize];
    
    ArrayMessages = nil;
    arrTempImages = nil;
    arrTempAudio = nil;
    arrCardStatus = nil;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    QBChatMessage * message = [[QBChatMessage alloc] init];
    message.text = @"SHARED.";
    //updatedMessage.customParameters = message.customParameters;
    
    
    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
    //[custom_Data addEntriesFromDictionary:message.customParameters];
    [custom_Data setObject:chat_message.customParameters[@"originalMessageID"] forKey:@"originalMessageID"];
    [custom_Data setObject:chat_message.customParameters[@"comment"] forKey:@"comment"];
    [custom_Data setObject:[NSString stringWithFormat:@"%@",@"shareAccepted"] forKey:@"shareStatus"];
    
    [custom_Data setObject:chat_message.customParameters[@"isMessageSender"] forKey:@"isMessageSender"];
    
    [custom_Data setObject:chat_message.customParameters[@"messageSenderID"] forKey:@"messageSenderID"];
    [custom_Data setObject:@"yes" forKey:@"isAccepted"];
    [custom_Data setObject:chat_message.customParameters[@"facebookToken"] forKey:@"facebookToken"];
    
    [custom_Data setObject:chat_message.customParameters[@"sharingMedia"] forKey:@"sharingMedia"];

    
    [message setCustomParameters:custom_Data];
    
    custom_Data = nil;
    chat_message = nil;
    
    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    
    message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
    
    //set custom object for message
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%ld%@%@",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[NSString stringWithFormat:@"%ld",(long)message.recipientID],dateString];
    
    message.ID = uniqueString;
    
    [self performSelector:@selector(callShareWebservice:) withObject:message afterDelay:0.1];
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:message.ID forKey:@"chatId"];
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    
    [object.fields setObject:@"1" forKey:@"type"];
    
    if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        Str = [Str stringByReplacingCharactersInRange:range withString:@""];
        
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    
    
    [object.fields setObject:@"" forKey:@"content"];
    
    
    
    
    NSArray *shared_array=[NSArray arrayWithObjects: message.customParameters[@"originalMessageID"],
                           message.customParameters[@"shareStatus"],
                           message.customParameters[@"messageSenderID"],
                           message.customParameters[@"isAccepted"],
                           message.customParameters[@"isMessageSender"],
                           message.customParameters[@"comment"],
                           message.customParameters[@"sharingMedia"],
                           message.customParameters[@"facebookToken"],
                           nil];
    [object.fields setObject:shared_array forKey:@"sharedMessage"];
    
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    [QBCustomObjects createObject:object delegate:chatmanager];
    


    
    [self.messages addObject:message];
    
    // NSLog(@"%@",self.messages);
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];

    
    //[[QBChat instance] sendMessage:message];
//    [chatmanager sendMessage:message];
    
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
    
    [self SendMessage:message dict:Tempdict];
    
    [self.tableView reloadData];
    
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }

}

- (void)shareRejectedPressed:(UIButton*)sender
{
    UIButton* sender_btn = (UIButton*)sender;
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender_btn superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[[sender_btn superview] superview]superview ];
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    
    QBChatMessage *chat_message;
    
    if(isChatHistoryOrNot == FALSE)
    {
        chat_message= [messages objectAtIndex:indexPath.row];
    }
    else
    {
        chat_message= [messages objectAtIndex:indexPath.row-1];
    }
    
//    if(messages.count < 20)
//    {
//        chat_message= [messages objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        chat_message= [messages objectAtIndex:indexPath.row-1];
//    }
    
    
    NSMutableDictionary *customObj = [[NSMutableDictionary alloc] init] ;
    [customObj addEntriesFromDictionary:chat_message.customParameters];
    [customObj setObject:@"no" forKey:@"isAccepted"];
    [chat_message setCustomParameters:customObj];
    customObj = nil;
//    chat_message.customParameters[@"isAccepted"] = @"no";
    
    //update share rejected status in local storage
    //////////////////////////////////////////////////////////// local storage/////////////////////////////////////////////////////////////////////////////////
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]];
    
    NSMutableArray *ArrayMessages;
    
    NSRange RangeMessages;
    if(messages.count > 20)
    {
        RangeMessages.location = [messages count] - 20;
        RangeMessages.length = 20;
    }
    else
    {
        RangeMessages.location = 0;
        RangeMessages.length = [messages count];
    }
    
    ArrayMessages = [[messages subarrayWithRange:RangeMessages] mutableCopy];
    
    NSMutableArray *arrCardStatus = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayCardStatus"])
    {
        arrCardStatus=nil;
        arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
    }
    
    NSMutableArray *arrTempImages = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayImagedata"])
    {
        arrTempImages = nil;
        arrTempImages = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
    }
    
    NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
    if([dict objectForKey:@"ArrayAudioData"])
    {
        arrTempAudio = nil;
        arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
    }
    
    
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
    
    [prefs setObject:tempDict forKey:self.strRelationShipId];
    
    [prefs synchronize];
    
    ArrayMessages = nil;
    arrTempImages = nil;
    arrTempAudio = nil;
    arrCardStatus = nil;
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    
    
    QBChatMessage * message = [[QBChatMessage alloc] init];
    message.text = @"SHARING DENIED.";
    //updatedMessage.customParameters = message.customParameters;
    
    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
    //[custom_Data addEntriesFromDictionary:message.customParameters];
    [custom_Data setObject:chat_message.customParameters[@"originalMessageID"] forKey:@"originalMessageID"];
    [custom_Data setObject:chat_message.customParameters[@"comment"] forKey:@"comment"];
    [custom_Data setObject:[NSString stringWithFormat:@"%@",@"shareRejected"] forKey:@"shareStatus"];
    
    [custom_Data setObject:chat_message.customParameters[@"isMessageSender"] forKey:@"isMessageSender"];
    
    [custom_Data setObject:chat_message.customParameters[@"messageSenderID"] forKey:@"messageSenderID"];
    
    [custom_Data setObject:@"no" forKey:@"isAccepted"];
    
    [custom_Data setObject:chat_message.customParameters[@"facebookToken"] forKey:@"facebookToken"];
    
    [custom_Data setObject:chat_message.customParameters[@"sharingMedia"] forKey:@"sharingMedia"];
    
    
    [message setCustomParameters:custom_Data];
    
    custom_Data = nil;
    chat_message = nil;
    
    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    
    message.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
    
    //set custom object for message
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[NSString stringWithFormat:@"%ld",(long)message.recipientID],dateString];
    
    message.ID = uniqueString;
    
    [self performSelector:@selector(callShareWebservice:) withObject:message afterDelay:0.1];
    
    [self.messages addObject:message];
    
    // NSLog(@"%@",self.messages);
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:message.ID forKey:@"chatId"];
    
    NSString *StrClicks = message.customParameters[@"clicks"];
    
    
    [object.fields setObject:@"1" forKey:@"type"];
    
    if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
    {
        [object.fields setObject:@"" forKey:@"clicks"];
        [object.fields setObject:message.text forKey:@"message"];
    }
    else
    {
        NSString *Str = [message.text substringWithRange:NSMakeRange(3, [message.text length]-3)];
        NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
        Str = [Str stringByReplacingCharactersInRange:range withString:@""];
        
        [object.fields setObject:Str forKey:@"message"];
        [object.fields setObject:StrClicks forKey:@"clicks"];
    }
    
    
    [object.fields setObject:@"" forKey:@"content"];
    
    [object.fields setObject:@"" forKey:@"video_thumb"];
    
    
    
    
    NSArray *shared_array=[NSArray arrayWithObjects: message.customParameters[@"originalMessageID"],
                           message.customParameters[@"shareStatus"],
                           message.customParameters[@"messageSenderID"],
                           message.customParameters[@"isAccepted"],
                           message.customParameters[@"isMessageSender"],
                           message.customParameters[@"comment"],
                           message.customParameters[@"sharingMedia"],
                           message.customParameters[@"facebookToken"],
                           nil];
    [object.fields setObject:shared_array forKey:@"sharedMessage"];
    
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    [QBCustomObjects createObject:object delegate:chatmanager];
    

    
    
    //[[QBChat instance] sendMessage:message];
//    [chatmanager sendMessage:message];
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
    
    [self SendMessage:message dict:Tempdict];
    
    [self.tableView reloadData];
    
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

- (void)cardCounteredPressed:(UIButton*)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_heading"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_content"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_url"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_clicks"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_owner"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_originator"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"is_CustomCard"];
    [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:@"card_DB_ID"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:rightTopHeaderClicks.text forKey:@"UserClicks"];
    
    PlayCardView *obj=[[PlayCardView alloc] init];
    
    QBChatMessage *chatMessage = (QBChatMessage *)[messages objectAtIndex:sender.tag];
    obj.card_id = chatMessage.customParameters[@"card_id"];
    obj.contentHeading = chatMessage.customParameters[@"card_heading"];
    obj.content = chatMessage.customParameters[@"card_content"];
    obj.imageUrl = chatMessage.customParameters[@"card_url"];
    obj.clicks = chatMessage.customParameters[@"card_clicks"];
    obj.card_owner = chatMessage.customParameters[@"card_owner"];
    obj.card_originator = chatMessage.customParameters[@"card_originator"];
    obj.is_CustomCard = chatMessage.customParameters[@"is_CustomCard"];
    obj.ID = chatMessage.customParameters[@"card_DB_ID"];
    
    
    obj.view.backgroundColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    //obj.view.superview.bounds = CGRectMake(0, 0, 550, 320);
    //[obj setTransitioningDelegate:transitionController];
    self.navigationController.modalPresentationStyle=UIModalPresentationCurrentContext;
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;
    chatMessage = nil;
    
    
    @try {
        int selected_index=-1;
        for(int i=0;i<card_accept_status.count;i++)
        {
            if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==sender.tag)
            {
                selected_index=[[[card_accept_status objectAtIndex:i] objectForKey:@"index"] integerValue];
                
                [card_countered_indexes setObject:[NSNumber numberWithInt:i] forKey:@"cardArrayIndex"];
                [card_countered_indexes setObject:[NSNumber numberWithInt:selected_index] forKey:@"selectedIndex"];
                
               /*
                NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",selected_index],@"index",@"1",@"status", nil];
                
                
                [card_accept_status replaceObjectAtIndex:i withObject:cardDict];*/
                break;
            }
        }
        
    }
    @catch (NSException *exception) {
        
    }

    
}

- (void)cardAcceptedPressed:(UIButton*)sender
{
    QBChatMessage *testMessage = [QBChatMessage message];
    NSString *Str_Partner_id = partner_QB_id;
    testMessage.recipientID = [Str_Partner_id intValue];
    [testMessage setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
    [self SendMessage:testMessage dict:nil];
    
    
    QBChatMessage *chatMessage = (QBChatMessage *)[messages objectAtIndex:sender.tag];
    
    /*int check_clicks;
    if([chatMessage.customParameters[@"card_owner"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]])
        check_clicks = addMyFriendClicks;
    else
        check_clicks = addMyClicks;
    
    if(check_clicks>=[chatMessage.customParameters[@"card_clicks"] intValue])
    {*/
    
    QBChatMessage *message = [QBChatMessage message];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *StrPartner_id = partner_QB_id;
    message.recipientID = [StrPartner_id intValue];
    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    NSLog(@"%d",[StrPartner_id intValue]);
    NSLog(@"%@",StrPartner_id);
    message.text = @" ";
    
    NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:chatMessage.customParameters[@"card_id"], @"card_id",                                       chatMessage.customParameters[@"card_clicks"],@"card_clicks",chatMessage.customParameters[@"card_heading"],@"card_heading",chatMessage.customParameters[@"card_content"],@"card_content",chatMessage.customParameters[@"card_url"],@"card_url", @"played",@"card_Played_Countered", @"accepted",@"card_Accepted_Rejected", chatMessage.customParameters[@"card_owner"], @"card_owner", chatMessage.customParameters[@"card_originator"], @"card_originator", chatMessage.customParameters[@"is_CustomCard"], @"is_CustomCard", chatMessage.customParameters[@"card_DB_ID"],  @"card_DB_ID",  nil];
    
    [message setCustomParameters:cards_data];
    
    if([chatMessage.customParameters[@"card_owner"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]])
    {
        addMyClicks += [chatMessage.customParameters[@"card_clicks"] intValue];
        leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
        
        addMyFriendClicks -= [chatMessage.customParameters[@"card_clicks"] intValue];
        rightTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyFriendClicks];
        //[self performSelector:@selector(playClicksChangesSound) withObject:nil afterDelay:0.2];
    }
    else
    {
        addMyClicks -= [chatMessage.customParameters[@"card_clicks"] intValue];
        leftTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyClicks];
        
        addMyFriendClicks += [chatMessage.customParameters[@"card_clicks"] intValue];
        rightTopHeaderClicks.text = [NSString stringWithFormat:@"%d",addMyFriendClicks];
        //[self performSelector:@selector(playClicksChangesSound) withObject:nil afterDelay:0.2];
    }
    
    switch ([rightTopHeaderClicks.text length])
    {
        case 1:
            LeftSmallClickImageView.frame = CGRectMake(69-5, 60,14, 15);
            rightTopHeaderClicks.frame = CGRectMake(48, 51,16, 32);
            break;
            
        case 2:
            LeftSmallClickImageView.frame = CGRectMake(79-5, 60,14, 15);
            rightTopHeaderClicks.frame = CGRectMake(48, 51,25, 32);
            break;
            
        case 3:
            LeftSmallClickImageView.frame = CGRectMake(89-5, 60,14, 15);
            rightTopHeaderClicks.frame = CGRectMake(48, 51,38, 32);
            break;
            
        case 4:
            LeftSmallClickImageView.frame = CGRectMake(99-5, 60,14, 15);
            rightTopHeaderClicks.frame = CGRectMake(48, 51,44, 32);
            break;
            
        default:
            break;
    }
    
    
    //set custom object for message
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
    
    NSLog(@"%@",uniqueString);
    
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:uniqueString forKey:@"chatId"];
    message.ID = uniqueString;
    
    [object.fields setObject:@"5" forKey:@"type"];
    
    [object.fields setObject:@"" forKey:@"clicks"];
    [object.fields setObject:message.text forKey:@"message"];
    [object.fields setObject:@"" forKey:@"content"];
    
    NSArray *cards_array=[NSArray arrayWithObjects: chatMessage.customParameters[@"card_id"],
                          chatMessage.customParameters[@"card_heading"],
                          chatMessage.customParameters[@"card_content"],
                          chatMessage.customParameters[@"card_url"],
                          chatMessage.customParameters[@"card_clicks"],
                          @"accepted",
                          chatMessage.customParameters[@"card_originator"],
                          chatMessage.customParameters[@"is_CustomCard"],
                          chatMessage.customParameters[@"card_DB_ID"],
                          nil];
    [object.fields setObject:cards_array forKey:@"cards"];
    [object.fields setObject:[prefs stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
    
    [QBCustomObjects createObject:object delegate:chatmanager];
    
    cards_array = nil;
    
    [self.messages addObject:message];
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];
    //[imagesURL addObject:@"-"];
    //[videosData addObject:@"-"];
    NSLog(@"local chat added: %@",self.messages);
    //[[QBChat instance] sendMessage:message];
    //[chatmanager sendMessage:message];
    
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData",nil];
    
    [self SendMessage:message dict:Tempdict];
    
    //[[QBChat instance] setDelegate:self];
    
    
    
    @try {
        int selected_index=-1;
        for(int i=0;i<card_accept_status.count;i++)
        {
            if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==sender.tag)
            {
                selected_index=[[[card_accept_status objectAtIndex:i] objectForKey:@"index"] integerValue];
                
                NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",selected_index],@"index",@"1",@"status", nil];
                
                [card_accept_status replaceObjectAtIndex:i withObject:cardDict];
                break;
            }
        }
        
        
    }
    @catch (NSException *exception) {
        
    }
    
    
    
    [self.tableView reloadData];
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    
   /*}

    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Clicks not enough to accept this card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        alert = nil;
    }*/

    // update card status for localstorage
    
    [self UpdateCardStatusLocalStorage:chatMessage];
    chatMessage = nil;
}

- (void)cardRejectedPressed:(UIButton*)sender
{
    QBChatMessage *testMessage = [QBChatMessage message];
    NSString *Str_Partner_id = partner_QB_id;
    testMessage.recipientID = [Str_Partner_id intValue];
    [testMessage setCustomParameters:[@{@"isComposing" : @"NO"} mutableCopy]];
    [self SendMessage:testMessage dict:nil];
    
    
    QBChatMessage *chatMessage = (QBChatMessage *)[messages objectAtIndex:sender.tag];
    
    QBChatMessage *message = [QBChatMessage message];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *StrPartner_id = partner_QB_id;
    message.recipientID = [StrPartner_id intValue];
    message.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    NSLog(@"%d",[StrPartner_id intValue]);
    NSLog(@"%@",StrPartner_id);
    message.text = @" ";
    
    NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:chatMessage.customParameters[@"card_id"], @"card_id",                                       chatMessage.customParameters[@"card_clicks"],@"card_clicks",chatMessage.customParameters[@"card_heading"],@"card_heading",chatMessage.customParameters[@"card_content"],@"card_content",chatMessage.customParameters[@"card_url"],@"card_url", @"played",@"card_Played_Countered", @"rejected",@"card_Accepted_Rejected", chatMessage.customParameters[@"card_originator"], @"card_originator", chatMessage.customParameters[@"is_CustomCard"], @"is_CustomCard", chatMessage.customParameters[@"card_DB_ID"],  @"card_DB_ID" , nil];
    
    [message setCustomParameters:cards_data];
    
    
    
    //set custom object for message
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],partner_QB_id,dateString];
    
    NSLog(@"%@",uniqueString);
    
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = QBchatTable; // your Class name
    
    //NSString *StrClicks = message.customParameters[@"clicks"];
    
    [object.fields setObject:uniqueString forKey:@"chatId"];
    message.ID = uniqueString;
    
    [object.fields setObject:@"5" forKey:@"type"];
    
    [object.fields setObject:@"" forKey:@"clicks"];
    [object.fields setObject:message.text forKey:@"message"];
    [object.fields setObject:@"" forKey:@"content"];
    
    NSArray *cards_array=[NSArray arrayWithObjects: chatMessage.customParameters[@"card_id"],
                          chatMessage.customParameters[@"card_heading"],
                          chatMessage.customParameters[@"card_content"],
                          chatMessage.customParameters[@"card_url"],
                          chatMessage.customParameters[@"card_clicks"],
                          @"rejected",
                          chatMessage.customParameters[@"card_originator"],
                          chatMessage.customParameters[@"is_CustomCard"],
                          chatMessage.customParameters[@"card_DB_ID"],
                          nil];
    [object.fields setObject:cards_array forKey:@"cards"];
    [object.fields setObject:[prefs stringForKey:@"relationShipId"] forKey:@"relationshipId"];
    [object.fields setObject:[NSString stringWithFormat:@"%@",[prefs stringForKey:@"QBUserName"]] forKey:@"userId"];
    [object.fields setObject:[prefs stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
    //[object.fields setObject:[NSString stringWithFormat:@"%d",(int)roundf([[NSDate date] timeIntervalSince1970])] forKey:@"sentOn"];
    [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
    
    //NSLog(@"%@",[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]]);
    
    [QBCustomObjects createObject:object delegate:chatmanager];
    
    cards_array = nil;
    
    
    [self.messages addObject:message];
    [imagesData addObject:[[NSData alloc] init]];
    [audioData addObject:[[NSData alloc] init]];
    //[imagesURL addObject:@"-"];
    //[videosData addObject:@"-"];
    NSLog(@"local chat added: %@",self.messages);
    //[[QBChat instance] sendMessage:message];
   // [chatmanager sendMessage:message];
    //[[QBChat instance] setDelegate:self];
    
    NSDictionary *Tempdict = [NSDictionary dictionaryWithObjectsAndKeys:[imagesData lastObject],@"imagesData",[audioData lastObject], @"audioData" ,nil];
    
    [self SendMessage:message dict:Tempdict];
    
    
    @try {
        int selected_index=-1;
        for(int i=0;i<card_accept_status.count;i++)
        {
            if([[[card_accept_status objectAtIndex:i] objectForKey:@"index"] intValue]==sender.tag)
            {
                selected_index=[[[card_accept_status objectAtIndex:i] objectForKey:@"index"] integerValue];
                
                NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",selected_index],@"index",@"1",@"status", nil];
                
                [card_accept_status replaceObjectAtIndex:i withObject:cardDict];
                break;
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    
    [self.tableView reloadData];
    if(isChatHistoryOrNot == TRUE)
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    else
    {
        if([messages count]>=1)
        {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    // update card status for localstorage
    
    [self UpdateCardStatusLocalStorage:chatMessage];
    
    chatMessage = nil;
    
}

-(void)UpdateCardStatusLocalStorage:(QBChatMessage *)message
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:self.strRelationShipId]]; //[prefs objectForKey:self.strRelationShipId];
    
    if([dict objectForKey:@"ArrayMessages"])
    {
        NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
        NSMutableArray *retrievedarray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        
        for(int i = 0 ; i < [retrievedarray count] ; i++)
        {
            if([((QBChatMessage *)[retrievedarray objectAtIndex:i]).ID isEqualToString:message.ID])
            {
                if([dict objectForKey:@"ArrayCardStatus"])
                {
                    NSMutableArray *arrCardStatus =[(NSArray*)[dict objectForKey:@"ArrayCardStatus"] mutableCopy];
                    
                    for (int j = 0 ;  j < arrCardStatus.count; j++)
                    {
                        NSDictionary *oldDict = (NSDictionary *)[arrCardStatus objectAtIndex:j];
                        if([[oldDict valueForKey:@"index"] integerValue] == i)
                        {
                            NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[[oldDict valueForKey:@"index"] integerValue]],@"index",@"1",@"status", nil];
                            
                            [arrCardStatus replaceObjectAtIndex:j withObject:newDict];
                            
                            NSMutableArray *ArrImagedata;
                            ArrImagedata=[[NSMutableArray alloc] init];
                            if([dict objectForKey:@"ArrayImagedata"])
                                [ArrImagedata addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];

                            NSMutableArray *ArrAudioData;
                            ArrAudioData=[[NSMutableArray alloc] init];
                            if([dict objectForKey:@"ArrayAudioData"])
                                [ArrAudioData addObjectsFromArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];

                            
                             NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:retrievedarray],@"ArrayMessages",ArrImagedata,@"ArrayImagedata",ArrAudioData,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
                            
                            [prefs setObject:tempDict forKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"]];
                            
                            [prefs synchronize];

                            
                            newDict = nil;
                            ArrImagedata = nil;
                            ArrAudioData = nil;
                            break;
                        }
                        oldDict = nil;
                    }
                    
                }
            }
        }
        retrievedarray = nil;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
