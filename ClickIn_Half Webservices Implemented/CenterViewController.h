//
//  CenterViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TransitionDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "HPGrowingTextView.h"
#import "TKTintedKeyboardViewController.h"
#import "ModelManager.h"
#import "RelationInfo.h"
#import "ShareViewController.h"
#import "CSAnimationView.h"
#import "PreviewAttachment_View.h"


@interface CenterViewController : TKTintedKeyboardViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,FBLoginViewDelegate,FBViewControllerDelegate,HPGrowingTextViewDelegate,SharedMessageDelegate,CenterchatReceiveProtocol,CenterCustomObjectProtocol,MODropAlertViewDelegate,AttachmentProtocol>
{
    // models references
    ModelManager *modelmanager;
    ChatManager *chatmanager;
    ProfileManager *profilemanager;
    //
    
    LabeledActivityIndicatorView *activity;
    int addMyClicks,addMyFriendClicks;
    
    
    BOOL checkforClicks; // don't call celfor row at index path
    AVAudioPlayer *click;
    BOOL isFadeinFadeOut;
    
    AVAudioPlayer *attachmentSound;
    AVAudioPlayer *ClicksChangedSound;
    
    AVAudioPlayer *outgoingMsgSound;
    
    UIScrollView *CardsScrollview; // for cards buttons option
    UIScrollView *mediaScrollview; // for media buttons option
    UIScrollView *HeaderChatHistoryScrollView; // for header Chat History Button
    UIScrollView *shareScrollView; // for sharing option
    
    //NSMutableArray *imagesURL;
    NSMutableArray *imagesData;
    NSMutableArray *images_indexes; //for images downloading stack
    NSMutableArray *imagesUploading_indexes; //for images uploading stack
    
    NSData *tempMediaData; // to store the picked image temporarily
    float tempImageRatio; // for storing width/height ratio of picked image
    
    NSURL *tempVideoUrl; // to store temporarily picked video
    
    //NSMutableArray *videosData;
    //NSMutableArray *video_indexes;  //for video downloading stack
    NSMutableArray *videoUploading_indexes;  //for video downloading stack
    bool isVideoPickedFromLibrary;
    
    NSMutableArray *audioUploading_indexes; // for audio uploading stack
    NSMutableArray *audioData;
    
    NSMutableArray *card_accept_status;
    NSMutableArray *card_status_webHistory; // for checking whether card accepted in chat history
    
    NSString *strChatIdOfFirstRecord;
    BOOL isChatHistoryOrNot;
    NSString *strRelationShipId;
    
    bool headerOptionsScrolled;
    
    BOOL isFromEariler;
    //BOOL isFetchingHistoryOr
    NSString *MyTotalClicks;     //my total clicks fetched from getrelationships webserviceleft
    NSString *FriendTotalClicks; //my friends total clicks fetched from getrelationships webservice
    
    NSTimer *timer; // history button enable and disable while scrolling history button
    
    
    UIView *startRecordingView;
    
    AVAudioRecorder *recorder;
    bool isMusicPlaying;
    //AVAudioPlayer *player;
    /*NSTimer *player_timer;
    BOOL isPaused;
    BOOL scrubbing;*/
    
    UILabel *notification_text;
    
    NSTimer *timer_notify;  // for notifications
    
    IBOutlet UIImageView *ImgViewBGOfSlider;
    
    BOOL CheckIfAttachBtnContainMedia;
    BOOL CheckIfTextViewIncreasedByHeight;
    
    UIView *containerView;
    HPGrowingTextView *textView;
    
    //for keeping track of card countered
    NSMutableDictionary *card_countered_indexes;
    
    UIImageView *overLayImgView;
    UIButton *okGotItButton;
    UIView *view;
    
    int previous_SliderValue;
    
    IBOutlet UIImageView *BgImageView;
    
    BOOL is_loadeariler;
    
    
    CSAnimationView *attachmentAnimationView;
    PreviewAttachment_View *viewAttachment;
    UIImage *imgAttachment;
    
}
@property (retain, nonatomic) IBOutlet UIImageView *LeftSmallClickImageView;
@property (retain, nonatomic) IBOutlet UILabel *PartnerNameLbl;
@property (nonatomic, retain) NSString *MyTotalClicks;;
@property (nonatomic, retain) NSString *FriendTotalClicks;
@property (nonatomic, retain) NSString *strRelationShipId;
@property (nonatomic, retain) NSString *strChatIdOfFirstRecord;
@property (nonatomic, retain) NSMutableArray *messages;
@property (retain, nonatomic) IBOutlet UILabel *leftTopHeaderClicks,*rightTopHeaderClicks;
@property (retain, nonatomic) IBOutlet UITextView *sendMessageField;
@property (retain, nonatomic) IBOutlet UIButton *mediaAttachButton;
@property (retain, nonatomic) IBOutlet UIButton    *sendMessageButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *ChatBgImgView;
@property (retain, nonatomic) IBOutlet UIView *ChatBgWhiteView;
@property (retain, nonatomic) IBOutlet UISlider *SliderBar;
@property (retain, nonatomic) IBOutlet UIButton *MediaButton;
//@property (retain, nonatomic) IBOutlet UIView *OverLayView;
@property (retain, nonatomic) IBOutlet UIImageView *UserImgView;
@property (retain, nonatomic) IBOutlet UIImageView *PartnerImgView;
@property (retain, nonatomic) NSString *PartnerPhoneNumber;

@property (retain, nonatomic) IBOutlet UIButton *BtnPartnerImg;

@property (retain, nonatomic) IBOutlet UIButton *BtnUserImg;


@property (strong, nonatomic) UIImagePickerController *imgPicker;

//@property (nonatomic, strong) TransitionDelegate *transitionController;  // for transparency in modal view presentation

@property (retain, nonatomic) IBOutlet UIButton *HistoryButton;

@property (retain, nonatomic) IBOutlet UIButton *ContentButton;

@property(strong,nonatomic)NSString *partner_QB_id;
@property(strong,nonatomic)NSString *partner_pic;
@property(strong,nonatomic)NSString *partner_name;

@property (nonatomic)int int_leftmenuIndex;

@property(strong,nonatomic)RelationInfo *relationObject;

@property (retain, nonatomic) IBOutlet UILabel *lblTyping;

-(IBAction)SlideBarAction:(id)sender;
-(IBAction)chatButton:(id)sender;
-(IBAction)leftSideMenuButtonPressed:(id)sender;
-(IBAction)rightSideMenuButtonPressed:(id)sender;
-(IBAction)mediaButton:(id)sender;  // media btn
-(IBAction)TopNotificationButton:(id)sender;

-(IBAction)topCardButton:(id)sender; // click action of top middle card button


-(IBAction)btnUserImgAction:(id)sender;
-(IBAction)btnPartnarImgAction:(id)sender;

-(void)sendMessageData:(NSDictionary *)dictionary;

@end
