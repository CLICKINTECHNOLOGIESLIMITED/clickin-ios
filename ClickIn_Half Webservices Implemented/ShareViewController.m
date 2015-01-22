//
//  ShareViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 28/04/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "ShareViewController.h"
#import "MFSideMenu.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "LableInsets.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "NewsfeedViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize ImageData,VideoData,AudioData;
@synthesize message,ShareButtonsView,lightGrayBGView,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fb_accesstoken"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    NSLog(@"[message customParameters]%@" ,[message customParameters]);
//    NSLog(@"[message customObjectsAdditionalParameters]%@" ,[message customObjectsAdditionalParameters]);
//    
//    NSMutableDictionary *dict=[message customParameters];
//    if ([[dict valueForKey:@"videoURL"] length]>0)
//    {
//        
//        NSString *str=[dict valueForKey:@"videoURL"];
//        NSURL *videoUrl=[NSURL URLWithString:str];
        /*
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
        
        CMTime duration = playerItem.duration;
        float seconds = CMTimeGetSeconds(duration);
        NSLog(@"duration: %.2f", seconds);
         */
//        AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
//        CMTime duration = sourceAsset.duration;
//        float seconds = CMTimeGetSeconds(duration);
//        NSLog(@"duration: %.2f", seconds);
    
//        AVAsset *testAsset = [AVAsset assetWithURL:videoUrl];
//        CMTime duration = testAsset.duration;
//        float seconds = CMTimeGetSeconds(duration);
//        NSLog(@"duration: %.2f", seconds);
//    }
//    else if ([[dict valueForKey:@"videoURL"] length]>0)
//    {
//        
//    }

    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    
    
    
    HeaderLbl.text = @"SHARE";
    HeaderLbl.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
    HeaderLbl.textColor = [UIColor whiteColor];
    
    txtView.text = @"Write your caption here...";
    txtView.textColor = [UIColor lightGrayColor];
    [txtView setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 11, 90, 90)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [lightGrayBGView addSubview:imgView];
    
    lblText = [[LableInsets alloc] initWithFrame:CGRectMake(10,101, 300, 45)];
    lblText.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
    lblText.backgroundColor = [UIColor colorWithRed:(226.0/255.0) green:(128.0/255.0) blue:(125.0/255.0) alpha:1.0];
    lblText.textColor =  [UIColor whiteColor];
    lblText.numberOfLines = 0;
    [lightGrayBGView addSubview:lblText];
    
    if (IS_IPHONE_5)
    {
        lightGrayBGView.frame = CGRectMake(lightGrayBGView.frame.origin.x, lightGrayBGView.frame.origin.y - 80, lightGrayBGView.frame.size.width, lightGrayBGView.frame.size.height);
        ShareButtonsView.frame = CGRectMake(ShareButtonsView.frame.origin.x, ShareButtonsView.frame.origin.y - 80, ShareButtonsView.frame.size.width, ShareButtonsView.frame.size.height);
        //lblText.frame = CGRectMake(lblText.frame.origin.x, lblText.frame.origin.y - 80, lblText.frame.size.width, lblText.frame.size.height);
    }

    
    CGSize textSize = { 280.0, 11535.0};
    if(message.text.length > 0)
    {
        CGSize size;
        size= [message.text sizeWithFont:lblText.font
                               constrainedToSize:textSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"%f",size.height);
        
        
        
        lblText.text=message.text;
        //size = [lblText sizeThatFits:textSize];
        /*if (IS_IPHONE_5)
            lblText.frame =  CGRectMake(10,101-80, 300, size.height+25);
        else*/
            lblText.frame =  CGRectMake(10,101, 300, size.height+25);
        
        int noOfline = ceil(size.height / lblText.font.lineHeight);
        
        if(size.height > 30)
        {
            Scroll.contentSize = CGSizeMake(320, 524+size.height);
        }
        
        if(size.height > 30)
        {
            ClicksImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 14, 15)];
            
            if([[message.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                [ClicksImage setFrame:CGRectMake(35,16,13,14)];
            else
                [ClicksImage setFrame:CGRectMake(40,16,13,14)];
            ClicksImage.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
            [lblText addSubview:ClicksImage];
        }
        else
        {
            ClicksImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 14, 15)];
            
            if([[message.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
            {
                if(noOfline>=2)
                    [ClicksImage setFrame:CGRectMake(35,6,13,14)];
                else
                    [ClicksImage setFrame:CGRectMake(35,15,13,14)];
            }
            else
            {
                if(noOfline>=2)
                    [ClicksImage setFrame:CGRectMake(40,6,13,14)];
                else
                    [ClicksImage setFrame:CGRectMake(40,15,13,14)];
            }
            ClicksImage.image=[UIImage imageNamed:@"headerIconRedWhiteColor.png"];
            [lblText addSubview:ClicksImage];
        }
        
    }

    if(message.text == (NSString*)[NSNull null] || message.text == nil)
        message.text = @"";
    
     NSString *StrClicks = message.customParameters[@"clicks"];
     
     NSLog(@"%@",StrClicks);
     
     if([StrClicks isEqualToString:@"no"])
     {
     
     }
     else
     {
     
     }
     
     //check for image sent
     
     if([message.customParameters[@"fileID"] length]>1)
     {
         [imgView setImageWithURL:[NSURL URLWithString:message.customParameters[@"fileID"]]  placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         imgView.contentMode = UIViewContentModeScaleAspectFit;
     }
     else if([message.customParameters[@"isFileUploading"] length]>0)
     {
         imgView.image = [UIImage imageWithData:ImageData];
         imgView.contentMode = UIViewContentModeScaleAspectFit;
     }
     
     // check for video sent
     if([message.customParameters[@"videoID"] length]>1)
     {
         [imgView setImageWithURL:[NSURL URLWithString:message.customParameters[@"videoThumbnail"] ] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     }
     else if([message.customParameters[@"isVideoUploading"] integerValue]==1)
     {
         imgView.image = [UIImage imageWithData:ImageData];
     //imagedata
     }
     
     //audio data
     if([message.customParameters[@"audioID"] length]>1)
     {
         imgView.image = [UIImage imageNamed:@"Soundicon2.png"];
     }
     else if([message.customParameters[@"isAudioUploading"] length]>0)
     {
         imgView.image = [UIImage imageNamed:@"Soundicon2.png"];
     }
     
     
     if([message.customParameters[@"locationID"] length]>1)
     {
         imgView.contentMode = UIViewContentModeScaleToFill;
         [imgView setImageWithURL:[NSURL URLWithString:message.customParameters[@"locationID"]]  placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     }
     else if([message.customParameters[@"isLocationUploading"] length]>0)
     {
         imgView.contentMode = UIViewContentModeScaleToFill;
         imgView.image = [UIImage imageWithData:ImageData];
     }
     
    lblText.hidden = YES;
    
    if (IS_IPHONE_5)
    {
        lightGrayBGView.frame = CGRectMake(0,90-80,320,101);
        ShareButtonsView.frame = CGRectMake(0,190-80,320,265);
    }
    else
    {
        lightGrayBGView.frame = CGRectMake(0,90,320,101);
        ShareButtonsView.frame = CGRectMake(0,190,320,265);
    }
     if([message.customParameters[@"card_heading"] length]==0)
     {
     
     }
    if([message.customParameters[@"fileID"] length]>1 || [message.customParameters[@"videoID"] length]>1  || [message.customParameters[@"audioID"] length]>1  || [message.customParameters[@"locationID"] length]>1 || [message.customParameters[@"isLocationUploading"] length]>0 || [message.customParameters[@"isFileUploading"] length]>0 || [message.customParameters[@"isVideoUploading"] integerValue]==1 || [message.customParameters[@"isAudioUploading"] length]>0)
     {
         if(![message.customParameters[@"clicks"] isEqualToString:@"no"] && [message.customParameters[@"clicks"]length]>0)
         {
             lblText.hidden = NO;
             if (IS_IPHONE_5)
             {
                 lightGrayBGView.frame = CGRectMake(0,90-80,320,190+45+lblText.frame.size.height-45);
                 ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45 - 80,320,265);
             }
             else
             {
                 lightGrayBGView.frame = CGRectMake(0,90,320,190+45+lblText.frame.size.height-45);
                 ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45,320,265);
             }
             lblText.text = message.text;
         }
         else
         {
             if(message.text.length > 0)
             {
                 lblText.hidden = NO;
                 if (IS_IPHONE_5)
                 {
                     lightGrayBGView.frame = CGRectMake(0,90-80,320,190+45+lblText.frame.size.height-45);
                     ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45 - 80,320,265);
                 }
                 else
                 {
                     lightGrayBGView.frame = CGRectMake(0,90,320,190+45+lblText.frame.size.height-45);
                     ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45,320,265);
                 }

                 lblText.backgroundColor = [UIColor whiteColor];
                 ClicksImage.hidden = YES;
                 lblText.textColor = [UIColor blackColor];
                 lblText.text = message.text;
             }
             else
             {

             }
         }
        
        if(((NSNull*)message.text == [NSNull null] && [message.customParameters[@"clicks"] isEqualToString:@"no"]) || ((NSNull*)message.text == [NSNull null]   && [message.customParameters[@"clicks"]length]==0))
         {
             lblText.hidden = YES;
             if (IS_IPHONE_5)
             {
                 lightGrayBGView.frame = CGRectMake(0,90 - 80,320,101);
                 ShareButtonsView.frame = CGRectMake(0,190 - 80,320,265);
             }
             else
             {
                 lightGrayBGView.frame = CGRectMake(0,90,320,101);
                 ShareButtonsView.frame = CGRectMake(0,190,320,265);
             }
         }
     }
     else if(![message.customParameters[@"clicks"] isEqualToString:@"no"] && [message.customParameters[@"clicks"]length]>0)
     {
         imgView.hidden = YES;
         ClicksBGView.hidden = NO;
         lblText.hidden = NO;
         txtView.frame = CGRectMake(20, 20, 280, 72);
         if (IS_IPHONE_5)
         {
             lightGrayBGView.frame = CGRectMake(0,90 - 80,320,190+45+lblText.frame.size.height-45);
    
             ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45 - 80,320,265);
         }
         else
         {
             lightGrayBGView.frame = CGRectMake(0,90,320,190+45+lblText.frame.size.height-45);
             
             ShareButtonsView.frame = CGRectMake(0,190+45+lblText.frame.size.height-45,320,265);
         }

         lblText.text = message.text;
     }
    
    if([message.customParameters[@"card_heading"] length]>0)
    {
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.hidden = NO;
        lblText.hidden = YES;
        if (IS_IPHONE_5)
        {
            lightGrayBGView.frame = CGRectMake(0,90-80,320,101);
            ShareButtonsView.frame = CGRectMake(0,190-80,320,265);
        }
        else
        {
            lightGrayBGView.frame = CGRectMake(0,90,320,101);
            ShareButtonsView.frame = CGRectMake(0,190,320,265);
        }
        
        
        if([message.customParameters[@"is_CustomCard"] isEqualToString:@"false"])
            [imgView setImageWithURL:[NSURL URLWithString:message.customParameters[@"card_url"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        else
        {
            cardHeading = [[UILabel alloc] init];
            cardHeading.frame = CGRectMake(imgView.frame.origin.x+14 ,imgView.frame.origin.y + 18 , 63, imgView.frame.origin.y + imgView.frame.size.height - 50);
            cardHeading.text = @"test card";
            cardHeading.numberOfLines=4;
            cardHeading.textAlignment=NSTextAlignmentCenter;
            [cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:8]];
            [cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
            cardHeading.text = [message.customParameters[@"card_heading"] uppercaseString];
            [lightGrayBGView addSubview:cardHeading];
            [lightGrayBGView bringSubviewToFront:cardHeading];
            imgView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
        }
        
        
        //setting clicks label on card image
        UILabel *cardClicksTop = [[UILabel alloc] init];
        cardClicksTop.frame = CGRectMake(imgView.frame.origin.x+7 ,imgView.frame.origin.y-5 , 25, 25);
        cardClicksTop.numberOfLines=1;
        cardClicksTop.textAlignment=NSTextAlignmentCenter;
        [cardClicksTop setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:10]];
        [cardClicksTop setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
        cardClicksTop.text = [NSString stringWithFormat:@"%02d", [message.customParameters[@"card_clicks"] integerValue]];
        [lightGrayBGView addSubview:cardClicksTop];
        [lightGrayBGView bringSubviewToFront:cardClicksTop];
        
        
        UILabel *cardClicksBottom = [[UILabel alloc] init];
        cardClicksBottom.frame = CGRectMake(imgView.frame.origin.x+ imgView.frame.size.width - 48 ,imgView.frame.origin.y + imgView.frame.size.height - 20 , 25, 25);
        if([message.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
            cardClicksBottom.frame = CGRectMake(imgView.frame.origin.x+ imgView.frame.size.width - 49 ,imgView.frame.origin.y + imgView.frame.size.height - 23 , 25, 25);
        cardClicksBottom.numberOfLines=1;
        cardClicksBottom.textAlignment=NSTextAlignmentRight;
        [cardClicksBottom setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:10]];
        [cardClicksBottom setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
        cardClicksBottom.text = [NSString stringWithFormat:@"%02d", [message.customParameters[@"card_clicks"] integerValue]];
        [lightGrayBGView addSubview:cardClicksBottom];
        [lightGrayBGView bringSubviewToFront:cardClicksBottom];


    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:tap];
    
     [self.view bringSubviewToFront:self.tintView];
    
    UIButton *btnFB=(UIButton *)[self.view viewWithTag:100];
    [btnFB setSelected:NO];
    [btnFB setBackgroundImage:[UIImage imageNamed:@"fb_grey.png"]
                      forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(chatLoginStatusChanged:)
     name:Notification_ChatLoginStatusChanged
     object:nil];
}


- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txtView resignFirstResponder];
}

-(IBAction)FBButtonAction:(id)sender
{
    UIImage *img=[(UIButton *) sender backgroundImageForState:UIControlStateNormal];
    UIButton *buttonFB=(UIButton *)sender;
    
    if([img isEqual:[UIImage imageNamed:@"fb_grey.png"] ])
    {
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        //[activity show];
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream",@"publish_actions",nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES  completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error)
        {
             [self sessionStateChanged:session state:state error:error];
        }];
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
        [FBSession.activeSession closeAndClearTokenInformation];
        [buttonFB setSelected:NO];
        [buttonFB setBackgroundImage:[UIImage imageNamed:@"fb_grey.png"]
                          forState:UIControlStateNormal];
    }
}

-(IBAction)GooglePlusButtonAction:(id)sender
{
    UIImage *img=[(UIButton *) sender currentBackgroundImage];
    UIButton *button = (UIButton*)sender;

    if(img == [UIImage imageNamed:@"google_button.png"])
    {
        [button setBackgroundImage:[UIImage imageNamed:@"google_blue.png"]
                          forState:UIControlStateNormal];

    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"google_button.png"]
                          forState:UIControlStateNormal];
    }

}

-(IBAction)TwitterButtonAction:(id)sender
{
    UIImage *img=[(UIButton *) sender currentBackgroundImage];
    UIButton *button = (UIButton*)sender;

    if(img == [UIImage imageNamed:@"grey_twitter.png"])
    {
        [button setBackgroundImage:[UIImage imageNamed:@"twitter_button.png"]
                          forState:UIControlStateNormal];
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"grey_twitter.png"]
                          forState:UIControlStateNormal];
    }
}
-(void)postImageToFacebook
{
    NSString *strText=txtView.text;
    if ([strText isEqualToString:@"Write your caption here..."])
    {
        strText=@"";
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   strText, @"caption",
                                   ImageData, @"picture",
                                   nil];
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         [activity hide];
         if (error)
         {
             //showing an alert for failure
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Post Failed"
                                       message:error.localizedDescription
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         }
         else
         {
             
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Success"
                                       message:@"Successfully posted on wall."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
             
             UIButton *btnFB=(UIButton *)[self.view viewWithTag:100];
             [btnFB setSelected:NO];
             [btnFB setBackgroundImage:[UIImage imageNamed:@"fb_grey.png"]
                              forState:UIControlStateNormal];
         }
     }];
}
#pragma mark -
#pragma mark TextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        NSLog(@"Return pressed, do whatever you like here");
        return NO; // or true, whetever you's like
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    txtView.text = @"";
    txtView.textColor = [UIColor darkGrayColor];

    return  YES;
}

#pragma mark - 

-(IBAction)ShareButtonAction:(id)sender
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(!appDelegate.isChatLoggedIn)
        return;
    
    appDelegate = nil;
 //   UIButton *btnFB=(UIButton *)[self.view viewWithTag:100];
//    UIImage *img=[btnFB backgroundImageForState:UIControlStateNormal];
    
//    if ([btnFB isSelected])
//    {
//        NSLog(@"Posted");
//        [self postImageToFacebook];
//    }
    
//    [activity show];
//    [self performSelector:@selector(callShareWebservice) withObject:nil afterDelay:0.1];
    QBChatMessage * updatedMessage = [[QBChatMessage alloc] init];
    updatedMessage.text = message.text;
    
    //updatedMessage.customParameters = message.customParameters;
    
    updatedMessage.senderID = [[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] intValue];
    
    updatedMessage.recipientID = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"]] intValue];
    
    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
    [custom_Data addEntriesFromDictionary:message.customParameters];
    if([message.customParameters[@"card_heading"] length]>0)
    {
        [custom_Data setObject:[NSString stringWithFormat:@"%@",@"played"] forKey:@"card_Played_Countered"];
    }
    
    if([message.customParameters[@"audioStreamURL"] length]>0)
    {
        [custom_Data setObject:message.customParameters[@"audioStreamURL"] forKey:@"audioID"];
    }
    
    if([message.customParameters[@"videoStreamURL"] length]>0)
    {
        [custom_Data setObject:message.customParameters[@"videoStreamURL"] forKey:@"videoID"];
        [custom_Data setObject:message.customParameters[@"imageURL"] forKey:@"videoThumbnail"];
    }
    
    if([message.customParameters[@"isLocationUploading"] length]>0)
    {
        [custom_Data setObject:message.customParameters[@"imageURL"] forKey:@"locationID"];
    }

    
    [custom_Data setObject:[NSString stringWithFormat:@"%@",message.ID] forKey:@"originalMessageID"];
    [custom_Data setObject:[NSString stringWithFormat:@"%@",txtView.text] forKey:@"comment"];
    [custom_Data setObject:[NSString stringWithFormat:@"%@",@"shared"] forKey:@"shareStatus"];
    [custom_Data setObject:@"" forKey:@"isDelivered"];
    if(message.senderID == updatedMessage.senderID)
    {
        [custom_Data setObject:@"true" forKey:@"isMessageSender"];
    }
    else
        [custom_Data setObject:@"false" forKey:@"isMessageSender"];
    
    [custom_Data setObject:[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] forKey:@"messageSenderID"];
    
    [custom_Data setObject:@"null" forKey:@"isAccepted"];
    
    NSString *sharing_media = [NSString stringWithFormat:@""];
    
    if(sharing_media.length==0)
        sharing_media = [sharing_media stringByAppendingString:@"clickin"];
    else
        sharing_media = [sharing_media stringByAppendingString:@",clickin"];
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"fb_accesstoken"] length]>0)
    {
        if(sharing_media.length==0)
            sharing_media = [sharing_media stringByAppendingString:@"facebook"];
        else
            sharing_media = [sharing_media stringByAppendingString:@",facebook"];
        
        [custom_Data setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"fb_accesstoken"]] forKey:@"facebookToken"];
    }
    else
    {
        [custom_Data setObject:@"-" forKey:@"facebookToken"];
    }

    [custom_Data setObject:sharing_media forKey:@"sharingMedia"];
    sharing_media = nil;
    
    [updatedMessage setCustomParameters:custom_Data];
    custom_Data = nil;
    
    //set custom object for message
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"dateString: %@",dateString);
    
    NSString *uniqueString = [NSString stringWithFormat:@"%d%@%@",[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"],[NSString stringWithFormat:@"%ld",(long)updatedMessage.recipientID],dateString];
    
    updatedMessage.ID = uniqueString;
    
    // notify observers
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDidReceiveSharedMessage
//                                                        object:nil userInfo:@{@"sharedMessage": updatedMessage, @"imageData" : ImageData}];
    
    [delegate sendMessageData:@{@"sharedMessage": updatedMessage, @"imageData" : ImageData}];
    
    updatedMessage = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callShareWebservice
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
        
        NSString *sharing_media = [NSString stringWithFormat:@""];
        
        if(sharing_media.length==0)
            sharing_media = [sharing_media stringByAppendingString:@"clickin"];
        else
            sharing_media = [sharing_media stringByAppendingString:@",clickin"];
        
        if([[prefs stringForKey:@"fb_accesstoken"] length]>0)
        {
            if(sharing_media.length==0)
                sharing_media = [sharing_media stringByAppendingString:@"facebook"];
            else
                sharing_media = [sharing_media stringByAppendingString:@",facebook"];
        }
        
        NSLog(@"%@",[prefs stringForKey:@"fb_accesstoken"]);
        
        NSString *strText;
        if([txtView.text isEqualToString:@"Write your caption here..."])
        {
            strText = @"";
        }
        else
        {
            strText = txtView.text;
        }
        
        if([prefs stringForKey:@"fb_accesstoken"] == nil)
            [prefs setObject:@"" forKey:@"fb_accesstoken"];
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", message.ID ,@"chat_id" , [prefs stringForKey:@"relationShipId"] ,@"relationship_id",
                      sharing_media, @"media", [prefs stringForKey:@"fb_accesstoken"], @"fb_access_token", @"", @"twitter_access_token", @"" , @"googleplus_access_token" ,strText,@"comment",nil];
        
        NSLog(@"%@",Dictionary);
        sharing_media = nil;
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Newsfeed has been saved."])
            {
                /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Shared successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 alert = nil;*/
                
                NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
                ObjNewsfeed.firstTimeLoad = @"yes";
                ObjNewsfeed.isFromSharingView = @"true";
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
                [self.navigationController pushViewController:ObjNewsfeed animated:YES];
                ObjNewsfeed = nil;
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
- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            UIButton *btnFB=(UIButton*)[self.view viewWithTag:100];
            [btnFB setSelected:YES];
            [btnFB setBackgroundImage:[UIImage imageNamed:@"facebook_blue.png"]
                              forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            [FBSession setActiveSession:session];
            
//            if(shareScrollView.alpha==1)
//            {
//                [(UIButton*)[shareScrollView viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
//            }
            //[activity show];
            [self getuserID];  // get user email
           
            
            
        }
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
            [FBSession.activeSession closeAndClearTokenInformation];
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
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
            [FBSession.activeSession closeAndClearTokenInformation];
            
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"GIVE US ACCESS."
//                                      message:@"Please allow Clickin' to access your Facebook account from the phone Settings"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            
            
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"GIVE US ACCESS."
                                                                            description:@"Please allow Clickin' to access your Facebook account from the phone Settings"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;

            
            [activity hide];
            return;
            // [self showLoginView];
        }
            break;
        default:
            break;
    }
    
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:error.localizedDescription
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        [activity hide];
    }
}

-(void)getuserID
{
    //[FBSettings setLoggingBehavior:[NSSet setWithObjects:
    // FBLoggingBehaviorFBRequests, nil]];
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error)
         {
             
             
             NSLog(@"fbUserName is : %@",user.name);
             
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:user.name forKey:@"fbUserName"];
             
         }
         else
         {
             NSLog(@"error");
         }
     }];
}

- (void)chatLoginStatusChanged:(NSNotification *)notification //use notification method and logic
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *btnShare=(UIButton *)[self.view viewWithTag:4747];

    if(appDelegate.isChatLoggedIn)
        [btnShare setEnabled:true];
    else
        [btnShare setEnabled:false];
    
    appDelegate = nil;
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ChatLoginStatusChanged object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
