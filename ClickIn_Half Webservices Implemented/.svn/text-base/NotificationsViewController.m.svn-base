//
//  NotificationsViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 10/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "NotificationsViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "NewsfeedViewController.h"
#import "CenterViewController.h"
#import "follower_owner.h"
#import "following_owner.h"
#import "profile_owner.h"
#import "LeftViewController.h"
#import "StarredViewController.h"
#import "CommentsViewController.h"
#import "CommentStarCommonView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

@synthesize refreshHeaderView,refreshLabel,refreshArrow,refreshSpinner,textPull,textRelease,textLoading,textLoad,LoadingImageView;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    notification_ID = [[NSMutableArray alloc] init];
    notificationType = [[NSMutableArray alloc] init];
    notificationMsgs = [[NSMutableArray alloc] init];
    newsfeed_ID = [[NSMutableArray alloc] init];
    
    //screen bg
    UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_bg.png"]];
    bg.center=CGPointMake(160, 240);
    if(IS_IPHONE_5)
    {
        bg.frame=CGRectMake(0, 0, 320, 569);
        bg.center=CGPointMake(160, 283);
    }
    [self.view addSubview:bg];
    [self.view sendSubviewToBack:bg];
    
    [self.view bringSubviewToFront:self.topBarLabel];
    self.topBarLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];

    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 480-50) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
    table.frame=CGRectMake(0,50, 320, 568-50);
    table.backgroundColor = [UIColor clearColor];
    //table_feeds.allowsSelection=NO;
    //table.userInteractionEnabled=YES;
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:table];
    //table.bounces=NO;
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //[table setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 60)];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    isChatHistoryOrNot = false;
    [self addPullToRefreshHeader];
    [self setupStrings];
    
    isFetchingEarlier = false;
    isHistoryAvailable = true;
    
    //[self performSelector:@selector(CallGetNotificationWebservice) withObject:nil afterDelay:0.1];

//    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self
//                                           selector:@selector(AutoRefreshNotificationsWebservice)
//                                           userInfo:nil
//                                            repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
//    if(!timer)
//        timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self
//                                               selector:@selector(AutoRefreshNotificationsWebservice)
//                                               userInfo:nil
//                                                repeats:YES];
    
   /*if(self.menuContainerViewController.menuState == MFSideMenuStateRightMenuOpen)
   {
       isFetchingEarlier = false;
       isHistoryAvailable = true;
       [self performSelector:@selector(AutoRefreshNotificationsWebservice:) withObject:nil afterDelay:0.1];
   }*/
    
}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    isFetchingEarlier = false;
    isHistoryAvailable = true;
    //[self performSelector:@selector(AutoRefreshNotificationsWebservice:) withObject:nil afterDelay:0.1];
    [self AutoRefreshNotificationsWebservice:false];
}

-(void)viewDidDisappear:(BOOL)animated
{
//    if(timer)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
    unreadCount = 0;
    [table reloadData];
}

-(void)AutoRefreshNotificationsWebservice:(BOOL)fetchEarlier
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/notification/fetchnotifications"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *Dictionary;
        
        if(isFetchingEarlier && fetchEarlier)
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", [notification_ID lastObject], @"last_notification_id", nil];
        else
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
        //      Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
        //        if([self.messages count] == 0)
        //        {
        //            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        //        }
        //        else
        //        {
        //            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",@"",@"last_newsfeed_id",nil];
        //        }
        
        NSLog(@"%@",Dictionary);
        
        if(notification_ID.count>0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[notification_ID objectAtIndex:0] forKey:@"latestNotificationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDidFinishSelector:@selector(requestFinished_info:)];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
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

- (void)requestFinished_info:(ASIHTTPRequest *)request
{
    if(!isFetchingEarlier)
    {
        [notification_ID removeAllObjects];
        [notificationMsgs removeAllObjects];
        [notificationType removeAllObjects];
        [newsfeed_ID removeAllObjects];
        [self.messages removeAllObjects];
    }

    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    NSError *errorr = nil;
    //NSData *Data = [[[request responseString] stringByReplacingOccurrencesOfString:@"null" withString:@""] dataUsingEncoding:NSASCIIStringEncoding];
    
    NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorr];
    
    
    if([request responseStatusCode] == 200)
    {
        NSMutableArray *TempArrayChatHistory = [[NSMutableArray alloc] init];
        
        if([[[NSUserDefaults standardUserDefaults] stringForKey:@"latestNotificationID"] length]==0)
        {
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            unreadCount = appDelegate.unreadNotificationsCount;
            appDelegate.unreadNotificationsCount = 0;
            appDelegate = nil;
            
            
//            unreadCount = [[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] count];
        }
        
        for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] count]; i++)
        {
            
            if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"] == nil)
            {
                [notification_ID addObject:@""];
            }
            else
            {
                [notification_ID addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"]];
                
                if([[[NSUserDefaults standardUserDefaults] stringForKey:@"latestNotificationID"] isEqualToString:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"]] && !isFetchingEarlier)
                {
                    unreadCount = i;
                }
            }
            
            if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"] == nil)
            {
                [notificationType addObject:@""];
            }
            else
                [notificationType addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"]];
            
            if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"] == nil)
            {
                [notificationMsgs addObject:@""];
            }
            else
                [notificationMsgs addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"]];
            
            
            if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"] == nil)
            {
                [newsfeed_ID addObject:@""];
            }
            else
                [newsfeed_ID addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"]];
            
            
            if([[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] != (NSDictionary*)[NSNull null] && [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] != nil && [[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] count] != 0)
            {
                
                QBChatMessage *message = [[QBChatMessage alloc] init];
                
                
                
                
                NSString *MessageText = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"] == nil)
                {
                    MessageText = @"";
                }
                
                NSString *MessageClicks = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"] == nil)
                {
                    MessageClicks = @"";
                }
                
                
                NSString *chatId = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"] == nil)
                {
                    chatId = @"";
                }
                
                
                
                
                
                
                
                message.ID = chatId;
                if(![MessageClicks isEqual:[NSNull null]])
                {
                    if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
                    {
                        message.text = MessageText;
                        
                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                    }
                    else
                    {
                        [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
                        message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
                        
                    }
                }
                else
                {
                    message.text = MessageText;
                    [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                }
                
                
                
                //check for image data
                NSString *contentURL = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"] == nil)
                {
                    contentURL = @"";
                }
                
                NSNumber *type = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"] == nil)
                {
                    type= 0;
                }
                
                
                
                NSString *imageRatio = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"];
                if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"] == nil)
                {
                    imageRatio = @"1";
                }
                
                
                
                if([type intValue]==2 && contentURL.length>0)
                {
                    
                    
                    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
                    [message setCustomParameters:custom_Data];
                    custom_Data = nil;
                    
                }
                
                //location data
                if([type intValue]==6 && contentURL.length>0)
                {
                    NSString *locationCoordinates = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"location_coordinates"];
                    if([locationCoordinates isEqual:[NSNull null]])
                        locationCoordinates = @"";
                    
                    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
                    //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
                    
                    [message setCustomParameters:custom_Data];
                    custom_Data = nil;
                    
                }
                
                
                
                //fetching video data
                if([type intValue]==4 && contentURL.length>0)
                {
                    NSString * video_thumbnail = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"video_thumb"];
                    
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
                    
                    
                    NSMutableDictionary *audio_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                       message.customParameters[@"clicks"] ,@"clicks", contentURL,@"audioID",
                                                       nil];
                    
                    [message setCustomParameters:audio_Data];
                    audio_Data = nil;
                    
                }
                
                //fetching cards data
                if([type intValue]==5)
                {
                    message.text=@"";
                    
                    NSArray *cards_array = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"cards"];
                    
                    NSString *card_actionText;
                    
                    if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
                        card_actionText = @"ACCEPTED!";
                    else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
                        card_actionText = @"REJECTED!";
                    else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
                        card_actionText = @"COUNTERED CARD";
                    else
                        card_actionText = @"PLAYED A CARD";
                    
                    
                    if(cards_array.count>5)
                    {
                        
                        NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[cards_array objectAtIndex:4],@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", nil];
                        
                        [message setCustomParameters:cards_data];
                    }
                    
                    
                    
                    cards_array=nil;
                    card_actionText=nil;
                }
                
                [TempArrayChatHistory addObject:message];
                
                message = nil;
            }
        }
        
        isChatHistoryOrNot = FALSE;
        //            if(TempArrayChatHistory.count < 20)
        //            {
        //                isChatHistoryOrNot = FALSE;
        //            }
        //            else
        //            {
        //                isChatHistoryOrNot = TRUE;
        //            }
        
        //          NSArray *ArrTemp = [NSArray arrayWithArray:self.messages];
        //          NSLog(@"%d",[self.messages count]);
        
        [self.messages addObjectsFromArray:TempArrayChatHistory];
        // [self.messages addObjectsFromArray:ArrTemp];
        
        //    NSLog(@"%d",[messages count]-[ArrTemp count]-1);
        [table reloadData];
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        /*if(isFetchingEarlier)
            [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        else
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];*/
        
        //            if(TempArrayChatHistory.count < 20)
        //            {
        //                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //            }
        //            else
        //            {
        //
        //                if(isFromEariler == FALSE)
        //                {
        //                    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //                }
        //                else
        //                {
        //                    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //                }
        //            }
        TempArrayChatHistory = nil;
        
        isFetchingEarlier = false;
        isHistoryAvailable = true;
    }
    if([request responseStatusCode] == 500)
    {
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User don't have any notification."])
        {
            //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User don't have any newsfeed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //                [alert show];
            //                alert = nil;
            isHistoryAvailable =false;
            [table reloadData];
            [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    
    [activity hide];
}

-(void)CallGetNotificationWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/notification/fetchnotifications"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *Dictionary;
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
        //      Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
        //        if([self.messages count] == 0)
        //        {
        //            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        //        }
        //        else
        //        {
        //            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",@"",@"last_newsfeed_id",nil];
        //        }
        
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
        
        NSError *errorr = nil;
        //NSData *Data = [[[request responseString] stringByReplacingOccurrencesOfString:@"null" withString:@""] dataUsingEncoding:NSASCIIStringEncoding];
        
        NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorr];
        
        
        if([request responseStatusCode] == 200)
        {
            NSMutableArray *TempArrayChatHistory = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] count]; i++)
            {
                if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"] == nil)
                {
                    [notification_ID addObject:@""];
                }
                else
                    [notification_ID addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"_id"]];
                
                if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"] == nil)
                {
                    [notificationType addObject:@""];
                }
                else
                    [notificationType addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"type"]];
                
                if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"] == nil)
                {
                    [notificationMsgs addObject:@""];
                }
                else
                    [notificationMsgs addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"notification_msg"]];
                
                if([[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"] == [NSNull null] || [[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"] == nil)
                {
                    [newsfeed_ID addObject:@""];
                }
                else
                    [newsfeed_ID addObject:[[[jsonResponse objectForKey:@"notificationArray"] objectAtIndex:i] objectForKey:@"newsfeed_id"]];
                
                
                if([[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] != (NSDictionary*)[NSNull null] && [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] != nil && [[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] count] != 0)
                {
                    
                    QBChatMessage *message = [[QBChatMessage alloc] init];
                    
                    
                    
                    
                    NSString *MessageText = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"message"] == nil)
                    {
                        MessageText = @"";
                    }
                    
                    NSString *MessageClicks = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"clicks"] == nil)
                    {
                        MessageClicks = @"";
                    }
                    
                    
                    NSString *chatId = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"chatId"] == nil)
                    {
                        chatId = @"";
                    }
                    
                    
                    
                    
                    
                    
                    
                    message.ID = chatId;
                    if(![MessageClicks isEqual:[NSNull null]])
                    {
                        if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
                        {
                            message.text = MessageText;
                            
                            [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                        }
                        else
                        {
                            [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
                            message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
                            
                        }
                    }
                    else
                    {
                        message.text = MessageText;
                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                    }
                    
                    
                    
                    //check for image data
                    NSString *contentURL = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"content"] == nil)
                    {
                        contentURL = @"";
                    }
                    
                    NSNumber *type = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"type"] == nil)
                    {
                        type= 0;
                    }
                    
                    
                    
                    NSString *imageRatio = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"];
                    if([NSNull null] == [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"] || [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"imageRatio"] == nil)
                    {
                        imageRatio = @"1";
                    }
                    
                    
                    
                    if([type intValue]==2 && contentURL.length>0)
                    {
                        
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }
                    
                    //location data
                    if([type intValue]==6 && contentURL.length>0)
                    {
                        NSString *locationCoordinates = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"location_coordinates"];
                        if([locationCoordinates isEqual:[NSNull null]])
                            locationCoordinates = @"";
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
                        //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
                        
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }
                    
                    
                    
                    //fetching video data
                    if([type intValue]==4 && contentURL.length>0)
                    {
                        NSString * video_thumbnail = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"video_thumb"];
                        
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
                        
                        
                        NSMutableDictionary *audio_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"audioID",
                                                           nil];
                        
                        [message setCustomParameters:audio_Data];
                        audio_Data = nil;
                        
                    }
                    
                    //fetching cards data
                    if([type intValue]==5)
                    {
                        message.text=@"";
                        
                        NSArray *cards_array = [[[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"notificationArray"]] objectAtIndex:i] objectForKey:@"Notification"] objectForKey:@"chatDetail"] objectForKey:@"Chat"] objectForKey:@"cards"];
                        
                        NSString *card_actionText;
                        
                        if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
                            card_actionText = @"ACCEPTED!";
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
                            card_actionText = @"REJECTED!";
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
                            card_actionText = @"COUNTERED CARD";
                        else
                            card_actionText = @"PLAYED A CARD";
                        
                        
                        if(cards_array.count>5)
                        {
                            
                            NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[cards_array objectAtIndex:4],@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", nil];
                            
                            [message setCustomParameters:cards_data];
                        }
                        
                        
                        
                        cards_array=nil;
                        card_actionText=nil;
                    }
                    
                    [TempArrayChatHistory addObject:message];
                    
                    message = nil;
                }
            }
           
            isChatHistoryOrNot = FALSE;
            //            if(TempArrayChatHistory.count < 20)
            //            {
            //                isChatHistoryOrNot = FALSE;
            //            }
            //            else
            //            {
            //                isChatHistoryOrNot = TRUE;
            //            }
            
            //          NSArray *ArrTemp = [NSArray arrayWithArray:self.messages];
            //          NSLog(@"%d",[self.messages count]);
            //[self.messages removeAllObjects];
            [self.messages addObjectsFromArray:TempArrayChatHistory];
            // [self.messages addObjectsFromArray:ArrTemp];
            
            //    NSLog(@"%d",[messages count]-[ArrTemp count]-1);
            [table reloadData];
            
            
            
            //            if(TempArrayChatHistory.count < 20)
            //            {
            //                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //            }
            //            else
            //            {
            //
            //                if(isFromEariler == FALSE)
            //                {
            //                    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //                }
            //                else
            //                {
            //                    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[messages count]-[ArrTemp count] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //                }
            //            }
            TempArrayChatHistory = nil;
        }
        if([request responseStatusCode] == 500)
        {
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User don't have any newsfeed."])
            {
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User don't have any newsfeed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alert show];
                //                alert = nil;
            }
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
    [activity hide];
}

#pragma mark - pull to refresh methods

- (void)setupStrings{
    textPull = [@"Pull down to refresh" uppercaseString];
    textRelease = [@"Release to refresh" uppercaseString];
    textLoading = [@"Loading" uppercaseString];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.0];
    refreshLabel.textColor = [UIColor colorWithRed:(127.0/255.0) green:(127.0/255.0) blue:(127.0/255.0) alpha:1.0];
    
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up_arrow.png"]];
    refreshArrow.frame = CGRectMake(125,
                                    (floorf(REFRESH_HEADER_HEIGHT - 18/2) / 2)+15,
                                    27/2, 18/2); // X = floorf((REFRESH_HEADER_HEIGHT - 27/2) / 2)
    
//    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
//    refreshSpinner.hidesWhenStopped = YES;
    
    
    if(!LoadingImageView)
    {
        LoadingImageView = [[UIImageView alloc] init];
    }
    LoadingImageView.frame = CGRectMake(130.0,(floorf(REFRESH_HEADER_HEIGHT - 18/2) / 2)+15,15,3.5);
    [refreshHeaderView addSubview:LoadingImageView];

    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
   // [refreshHeaderView addSubview:refreshSpinner];
    [table addSubview:refreshHeaderView];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LoadingImageView.image = nil;
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            table.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            table.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = self.textRelease;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = self.textPull;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        table.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
//        [refreshSpinner startAnimating];
        
        loadingtimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
    }];
    
    // Refresh action!
    [self refresh];
}


-(void) startTimerThread
{
    loadingtimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
}

-(void)startTime
{
    if([LoadingImageView.image isEqual:[UIImage imageNamed:@"1loader.png"]])
    {
        LoadingImageView.image = [UIImage imageNamed:@"2loader.png"];
    }
    else if([LoadingImageView.image isEqual:[UIImage imageNamed:@"2loader.png"]])
    {
        LoadingImageView.image = [UIImage imageNamed:@"3loader.png"];
    }
    else if([LoadingImageView.image isEqual:[UIImage imageNamed:@"3loader.png"]])
    {
        LoadingImageView.image = [UIImage imageNamed:@"1loader.png"];
    }
    else
    {
        LoadingImageView.image = [UIImage imageNamed:@"1loader.png"];
    }
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        table.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
//    [refreshSpinner stopAnimating];
    
    [loadingtimer invalidate];
    loadingtimer = nil;
    //NSLog(@"done");
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    //NSLog(@"refresh");
    isFetchingEarlier = false;
    isChatHistoryOrNot = true;
    [self AutoRefreshNotificationsWebservice:false];
    
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<notificationType.count)
    {
    CGSize notificationSize;
    CGSize textSize = { 230.0, 8846.15 }; // for 520 >> 9615.0
//    notificationSize = [[notificationMsgs objectAtIndex:indexPath.row] sizeWithFont:[UIFont boldSystemFontOfSize:18]
//                                                                  constrainedToSize:textSize
//                                                                      lineBreakMode:NSLineBreakByWordWrapping];
     
        
     
        
     notificationSize = [[[notificationMsgs objectAtIndex:indexPath.row] capitalizedString] sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18]
                                       constrainedToSize:textSize
                                           lineBreakMode:NSLineBreakByWordWrapping];
        
        NSLog(@"%@ >>>>>>  H: %lf ,W: %lf",[notificationMsgs objectAtIndex:indexPath.row],notificationSize.height,notificationSize.width);
    return 30 + notificationSize.height;
    }
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [notificationType count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell;
    if(indexPath.section==0) //section 1
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor=[UIColor clearColor];
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            //cell.userInteractionEnabled=NO;
            //-------------------------------------------------------------------------
            //background selected view
            UIView *viewSelectedBackgroundView=[[UIView alloc]init];
            viewSelectedBackgroundView.backgroundColor=[UIColor colorWithRed:117/255.0 green:213/255.0 blue:217/255.0 alpha:1.0];
            cell.selectedBackgroundView=viewSelectedBackgroundView;
            //-------------------------------------------------------------------------
            
            
            UIImageView *iconView=[[UIImageView alloc] initWithFrame:CGRectMake(4, 18, 20, 20)];
            iconView.tag=111111;
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:iconView];
            
            
            UITextView *notificationMessage=[[UITextView alloc] init];
            [notificationMessage setBackgroundColor:[UIColor clearColor]];
            notificationMessage.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18.0];
            notificationMessage.textColor = [UIColor whiteColor];
            [notificationMessage setEditable:NO];
            [notificationMessage setScrollEnabled:NO];
            notificationMessage.tag = 222222;
            [notificationMessage sizeToFit];
            [notificationMessage setContentInset:UIEdgeInsetsMake(0, 0, 5,0)];
            [cell.contentView addSubview:notificationMessage];
            
            
            UIView *topSeperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
            topSeperatorLine.backgroundColor = [UIColor colorWithRed:(100.0/255.0) green:(113.0/255.0) blue:(143.0/255.0) alpha:1.0];
            [cell.contentView addSubview:topSeperatorLine];
            
            UILabel *load_more = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(-20, 5, 320, 20))];
            load_more.textColor = [UIColor blackColor];
            load_more.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            load_more.tag = 333333;
            load_more.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            load_more.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
            load_more.lineBreakMode = YES;
            load_more.numberOfLines = 1;
            load_more.text = @"Loading more...";
            load_more.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:load_more];
            
            UIActivityIndicatorView *activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activitySpinner.tag=444444;
            activitySpinner.frame = CGRectMake(55, 6, 20, 20);
            activitySpinner.hidesWhenStopped = YES;
            [cell.contentView addSubview:activitySpinner];
            
        }
        
        if(indexPath.row<notificationType.count)
        {
            
            
        UIImageView *iconView=(UIImageView*)[cell.contentView viewWithTag:111111];
        if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"share"])
            iconView.image = [UIImage imageNamed:@"shareN.png"];
        else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"follow"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followstatus"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followrequest"])
                iconView.image = [UIImage imageNamed:@"requestfollowN.png"];
        else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"invite"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationrequest"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationstatus"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationdelete"])
            iconView.image = [UIImage imageNamed:@"click-requestN.png"];
        else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"newsfeed"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"star"])
            iconView.image = [UIImage imageNamed:@"starN.png"];
        else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"comment"])
            iconView.image = [UIImage imageNamed:@"cloudN.png"];
        else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationship"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationvisibility"] )
            iconView.image = [UIImage imageNamed:@"relationshipN.png"];
        
        
        CGSize notificationSize;
            CGSize textSize = { 230.0, 8846.15 };//{ 250.0, 9615.0 };
        notificationSize = [[[notificationMsgs objectAtIndex:indexPath.row] capitalizedString] sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18]
                    constrainedToSize:textSize
                        lineBreakMode:NSLineBreakByWordWrapping];
        
        UITextView *name=(UITextView*)[cell.contentView viewWithTag:222222];
        name.frame = CGRectMake(25, 6, 250, notificationSize.height+30);
        name.text=[[notificationMsgs objectAtIndex:indexPath.row] capitalizedString];
            
            UILabel *LoadMore=(UILabel*)[cell.contentView viewWithTag:333333];
            UIActivityIndicatorView *activitySpinner=(UIActivityIndicatorView*)[cell.contentView viewWithTag:444444];
            LoadMore.hidden = true;
            [activitySpinner stopAnimating];
            

        }
        else
        {
            UIImageView *iconView=(UIImageView*)[cell.contentView viewWithTag:111111];
            iconView.image = nil;
            UITextView *name=(UITextView*)[cell.contentView viewWithTag:222222];
            name.text = @"";
            
            if([notification_ID count]>=25 && isHistoryAvailable)
            {
                UILabel *LoadMore=(UILabel*)[cell.contentView viewWithTag:333333];
                UIActivityIndicatorView *activitySpinner=(UIActivityIndicatorView*)[cell.contentView viewWithTag:444444];
                LoadMore.hidden = false;
                [activitySpinner startAnimating];
            }
            else
            {
                UILabel *LoadMore=(UILabel*)[cell.contentView viewWithTag:333333];
                UIActivityIndicatorView *activitySpinner=(UIActivityIndicatorView*)[cell.contentView viewWithTag:444444];
                LoadMore.hidden = true;
                [activitySpinner stopAnimating];
            }
            
        }
        
        
        if(indexPath.row < unreadCount)
            cell.backgroundColor=[UIColor colorWithRed:95/255.0 green:110/255.0 blue:135/255.0 alpha:1];
        else
            cell.backgroundColor=[UIColor clearColor];
        
        
        for(UIView * cellSubviews in cell.subviews)
        {
            cellSubviews.userInteractionEnabled = NO;
        }
        
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        
            if(indexPath.row==notificationType.count && !isFetchingEarlier && [notification_ID count]>=25 && isHistoryAvailable)
            {
                isFetchingEarlier = true;
                [self AutoRefreshNotificationsWebservice:true];
            }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<notificationType.count)
    {
    
    if ([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"newsfeed"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"share"] /*|| [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"comment"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"star"]*/) //newsfeed
    {
        NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
        ObjNewsfeed.firstTimeLoad = @"yes";
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        [controllers addObject:ObjNewsfeed];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        ObjNewsfeed = nil;
    }
    else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"follow"] /*|| [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followstatus"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followrequest"]*/ || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationship"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationvisibility"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"invite"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationrequest"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationstatus"] || [[notificationType objectAtIndex:indexPath.row] isEqualToString:@"relationdelete"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
       // profile_owner *profile = [[profile_owner alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        ((profile_owner*)[controllers objectAtIndex:0]).isFromNotification = true;
       // [controllers addObject:profile];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

    }
    else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followrequest"])
    {
        //redirect to owner's followers page
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
        follower_owner *followerowner = [[follower_owner alloc] initWithNibName:nil bundle:nil];
        followerowner.is_Owner = @"true";
        NSArray *substrings = [[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString] componentsSeparatedByString:@" "];
        if([substrings count] != 0)
        {
            NSString *first = [substrings objectAtIndex:0];
            followerowner.name = [first uppercaseString];
        }
        else
        {
            followerowner.name = @"FOLLOWERS";
        }

        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        [controllers addObject:followerowner];
        navigationController.viewControllers = controllers;
        //[navigationController pushViewController:followerowner animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        followerowner = nil;
    }
    else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"followstatus"])
    {
        //redirect to owner's following page
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
        following_owner *followingowner = [[following_owner alloc] initWithNibName:nil bundle:nil];
        followingowner.is_Owner = @"true";
        NSArray *substrings = [[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString] componentsSeparatedByString:@" "];
        if([substrings count] != 0)
        {
            NSString *first = [substrings objectAtIndex:0];
            followingowner.name = [first uppercaseString];
        }
        else
        {
            followingowner.name = @"FOLLOWERS";
        }
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        [controllers addObject:followingowner];
        navigationController.viewControllers = controllers;
        //[navigationController pushViewController:followingowner animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        followingowner = nil;
    }
    else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"comment"])
    {
        //redirect to comments screen
        if([[newsfeed_ID objectAtIndex:indexPath.row] length]>0)
        {
            //CommentsViewController *obj=[[CommentsViewController alloc] init];
            CommentStarCommonView *obj=[[CommentStarCommonView alloc] init];
            obj.isNotificationSelected = @"true";
            obj.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
            obj.selectedNewsfeed = [[Newsfeed alloc] init];
            obj.selectedNewsfeed.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
        
            [self presentViewController:obj animated:YES completion:nil];
            obj=nil;
        }
    }
    else if([[notificationType objectAtIndex:indexPath.row] isEqualToString:@"star"])
    {
        //redirect to star scrren
        if([[newsfeed_ID objectAtIndex:indexPath.row] length]>0)
        {
            /*StarredViewController *obj=[[StarredViewController alloc] init];
            obj.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
            obj.selectedNewsfeed = [[Newsfeed alloc] init];
            obj.selectedNewsfeed.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
            [self presentViewController:obj animated:YES completion:nil];
            obj=nil;*/
            
            
//            NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
//            ObjNewsfeed.firstTimeLoad = @"yes";
//            ObjNewsfeed.scrollToNewsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
//            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//            
//            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//            while (controllers.count>1) {
//                [controllers removeLastObject];
//            }
//            [controllers addObject:ObjNewsfeed];
//            navigationController.viewControllers = controllers;
//            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//            ObjNewsfeed = nil;
//            
//            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
            
            CommentStarCommonView *obj=[[CommentStarCommonView alloc] init];
            obj.isNotificationSelected = @"true";
            obj.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
            obj.selectedNewsfeed = [[Newsfeed alloc] init];
            obj.selectedNewsfeed.newsfeedID = [newsfeed_ID objectAtIndex:indexPath.row];
            
            [self presentViewController:obj animated:YES completion:nil];
            obj=nil;

        }
    }
    }
}

#pragma mark -
#pragma mark - UIBarButtonItem Callbacks


- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
