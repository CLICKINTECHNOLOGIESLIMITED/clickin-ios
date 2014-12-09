//
//  NewsfeedViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 27/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "NewsfeedViewController.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "NewsfeedTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "PhotoViewController.h"
#import "MapWebView.h"
#import "StarredViewController.h"
#import "CommentsViewController.h"
#import "profile_otheruser.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface NewsfeedViewController ()

@end

@implementation NewsfeedViewController
@synthesize  LblNewsfeed,topBarImageView;
@synthesize refreshHeaderView,refreshLabel,refreshArrow,refreshSpinner,textPull,textRelease,textLoading,textLoad,firstTimeLoad,isFromSharingView,scrollToNewsfeedID,LoadingImageView;

float padding = 2;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [timer invalidate];
    timer = nil;
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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(NotificationReceived:)
     name:Notification_NewsfeedsUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(StarredNotificationReceived:)
     name:Notification_NewsfeedUserStarred
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(FollowersFollowingUpdated:)
     name:Notification_FollowersFollowingUpdated
     object:nil];
    
    // Models
    modelmanager=[ModelManager modelManager];
    newsfeedmanager=modelmanager.newsfeedManager;
    profilemanager=modelmanager.profileManager;
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@ >>>>>>>>>>>>>>>> %@",[prefs stringForKey:@"user_id"],[prefs stringForKey:@"user_token"]);
    //[QBUsers logInWithUserLogin:[prefs stringForKey:@"QBUserName"] password:[prefs stringForKey:@"QBPassword"] delegate:self];
    
    LblNewsfeed.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    tblView.frame = CGRectMake(0, 45, 320, 435);
    tblView.backgroundColor = [UIColor clearColor];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 45, 320, 523);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 45, 320, 523);
        }
        else
        {
            tblView.frame = CGRectMake(0, 45, 320, 435);
        }
    }
    
    
    //if(isFromSharingView)
        //topBarImageView.image = [UIImage imageNamed:@"comments_top"];
    
    [self.view bringSubviewToFront:topBarImageView];
    [self.view bringSubviewToFront:LblNewsfeed];
    
    // notifications text
    notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    notification_text.center=CGPointMake(298, 18);
    notification_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    notification_text.tag = 5;
    notification_text.backgroundColor = [UIColor clearColor];
    // header_text = [UIFont fontWithName:@"Halvetica" size:10];
    notification_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
    notification_text.lineBreakMode = YES;
    notification_text.numberOfLines = 0;
    notification_text.lineBreakMode = NSLineBreakByTruncatingTail;
    notification_text.text=@"0";
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    notification_text.text = [NSString stringWithFormat:@"%i",appDelegate.unreadNotificationsCount];
    appDelegate = nil;
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
    
    [self.view addSubview:notification_text];
    
    //notification btn
    notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationsBtn addTarget:self
                         action:@selector(notificationBtnPressed)
               forControlEvents:UIControlEventTouchDown];
    notificationsBtn.backgroundColor = [UIColor clearColor];
    notificationsBtn.frame =CGRectMake(320-70, 0, 70, 45);
    [self.view addSubview:notificationsBtn];
    
    [self getprofileinfo];

    
    
    isChatHistoryOrNot = false;
    
    [self addPullToRefreshHeader];
    [self setupStrings];
    //[self getfollowinglist];
    
    [activity show];
    
    
   // [self performSelector:@selector(CallGetChatHistoryWebservice) withObject:nil afterDelay:0.1];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self                                           selector:@selector(AutoRefreshCallGetChatHistoryWebservice) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(customViewDidLoad) withObject:nil afterDelay:0.1];
    
}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    notification_text.text = @"0";
    
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    
}


-(void)customViewDidLoad
{
    if(profilemanager.ownerDetails.followingArray.count==0)
        [profilemanager.ownerDetails getFollowerFollowingListSynchronous:true];
    else
        [profilemanager.ownerDetails getFollowerFollowingList:true];

    //fetch newsfeed from NewsfeedManager Model
    [newsfeedmanager getFeeds:YES isFetchingEarlier:NO];
    [activity hide];
    [tblView reloadData];
    
    firstTimeLoad = @"yes";
}

#pragma mark Notifications received
- (void)NotificationReceived:(NSNotification *)notification //use notification method and logic
{
    if(newsfeedmanager.array_model_feeds.count == 0)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(41,100, 476/2, 204/2)];
        imgView.image = [UIImage imageNamed:@"24Text.png"];
        [self.view addSubview:imgView];
    }
    for(int i=0;i<newsfeedmanager.array_model_feeds.count;i++)
    {
    
    for(int j = 0; j < profilemanager.ownerDetails.followingArray.count; j++)
    {
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:i]).senderID isEqualToString:[NSString stringWithFormat:@"%@",[[profilemanager.ownerDetails.followingArray objectAtIndex:j] objectForKey:@"followee_id"]]])
        {
            ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:i]).isSenderFollower = @"true";
            break;
        }
    }
    }
    
    for(int i=0;i<newsfeedmanager.array_model_feeds.count;i++)
    {
        
        for(int j = 0; j < profilemanager.ownerDetails.followingArray.count; j++)
        {
            if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:i]).receiverID isEqualToString:[NSString stringWithFormat:@"%@",[[profilemanager.ownerDetails.followingArray objectAtIndex:j] objectForKey:@"followee_id"]]])
            {
                ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:i]).isReceiverFollower = @"true";
                break;
            }
        }
    }
    
    // reload table data
    [tblView reloadData];
    
    if(scrollToNewsfeedID.length>0)
    {
        for(int l=0;l<newsfeedmanager.array_model_feeds.count;l++)
        {
            if([scrollToNewsfeedID isEqualToString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:l]).newsfeedID])
            {
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0  inSection:l] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                scrollToNewsfeedID = @"";
                break;
            }
        }
    }
}

- (void)FollowersFollowingUpdated:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [tblView reloadData];
}



- (void)StarredNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [tblView reloadData];
    [tblView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}


-(void)getprofileinfo
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo"];
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
    [request setDidFinishSelector:@selector(requestFinished_notify:)];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}


- (void)requestFinished_notify:(ASIHTTPRequest *)request
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
            
            if([notification_text.text isEqualToString:@"0"])
                notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
            else
                notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
            
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.unreadNotificationsCount = [notification_text.text integerValue];
            appDelegate = nil;
            
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:errorl.description
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;

            
        }
    }
}




-(void)getfollowinglist
{
    /*
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow"];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //    NSError *error;
    //
    //    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    //
    //    NSLog(@"%@",str);
    //    NSLog(@"%@",Dictionary);
    
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //    [request appendPostData:jsonData];
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startSynchronous];
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if(success)
        {
            for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"following"]] count]; i++)
            {
                
                if([[[jsonResponse objectForKey:@"following"] objectAtIndex:i] objectForKey:@"followee_id"] != (NSDictionary*)[NSNull null] && [[[jsonResponse objectForKey:@"following"] objectAtIndex:i] objectForKey:@"followee_id"] != nil && [[[[jsonResponse objectForKey:@"following"] objectAtIndex:i] objectForKey:@"followee_id"] length] != 0)
                {
                    [self.followingIDS addObject:[[[jsonResponse objectForKey:@"following"] objectAtIndex:i] objectForKey:@"followee_id"]];
                }
                
                
            }
            
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
        NSLog(@"%@",self.followingIDS);
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        
        
    }
    */
}


-(void)viewWillAppear:(BOOL)animated
{
    if([firstTimeLoad isEqualToString:@"no"])
    {
        [self performSelector:@selector(callGetNewsfeed) withObject:nil afterDelay:1];
    }
    
    firstTimeLoad = @"no";
}

-(void)callGetNewsfeed
{
    [newsfeedmanager getFeeds:YES isFetchingEarlier:NO];
}

-(void)loadearlierButtonAction
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    isFromEariler = TRUE;
}

-(void)showFullScreenPicture:(id)sender{
    UIButton* img_btn = (UIButton*)sender;
    
    PhotoViewController* photoController = [[PhotoViewController alloc] initWithImage:img_btn.imageView.image];
    [self.navigationController pushViewController:photoController animated:YES];
    photoController =nil;
}

-(void) playAudio:(id)sender{
    UIButton* play_btn = (UIButton*)sender;
    
    
    QBChatMessage *messageBody;
    messageBody= ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:play_btn.tag]).message;
    
    
    MPMoviePlayerViewController *mpvc;
    if([messageBody.customParameters[@"audioID"] length]>1)
    {
        
        
        mpvc = [[MPMoviePlayerViewController alloc] init];
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [mpvc.moviePlayer setContentURL:[NSURL URLWithString:messageBody.customParameters[@"audioID"]]];
        
        
        [mpvc.moviePlayer prepareToPlay];
        
        [[NSNotificationCenter defaultCenter] removeObserver:mpvc  name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
        
        
        [self presentMoviePlayerViewControllerAnimated:mpvc] ;
        mpvc = nil;
        
    }
    
}


-(void)showFullScreenVideo:(id)sender{
    UIButton* play_btn = (UIButton*)sender;
    
    
    QBChatMessage *messageBody;
    messageBody= ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:play_btn.tag]).message;
    
    
    MPMoviePlayerViewController *mpvc;
    if([messageBody.customParameters[@"videoID"] length]>1)
    {
        mpvc = [[MPMoviePlayerViewController alloc] init];
        mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        [mpvc.moviePlayer setContentURL:[NSURL URLWithString:messageBody.customParameters[@"videoID"]]];
    }
    
    [mpvc.moviePlayer prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] removeObserver:mpvc  name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(videoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:mpvc.moviePlayer];
    
    
    [self presentMoviePlayerViewControllerAnimated:mpvc] ;
    mpvc = nil;
}

-(void)videoFinished:(NSNotification*)aNotification{
    int value = [[aNotification.userInfo valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (value == MPMovieFinishReasonUserExited) {
        [self dismissMoviePlayerViewControllerAnimated];
    }
}

-(void)showMapView:(UIButton*)sender
{
    NewsfeedTableViewCell *cell;
    if (IS_IOS_7)
    {
        cell  = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(NewsfeedTableViewCell *)[[sender superview] superview];
    }
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    MapWebView *Obj= [[MapWebView alloc] init];
    
    QBChatMessage *messageBody;
    
    if(isChatHistoryOrNot)
        messageBody= ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section-1]).message;
    else
        messageBody= ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).message;
    
    if([messageBody.customParameters[@"location_coordinates"] length]>0)
        Obj.location_coordinates = messageBody.customParameters[@"location_coordinates"];
    
    //[self.navigationController pushViewController:Obj animated:YES];
    [self presentViewController:Obj animated:YES completion:nil];
    
    Obj = nil;
    
}


-(void)commentBtnPressed:(UIButton*)sender
{
    CommentsViewController *obj=[[CommentsViewController alloc] init];
    NewsfeedTableViewCell *cell ;
    if (IS_IOS_7)
    {
        cell  = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(NewsfeedTableViewCell *)[[sender superview] superview];
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    obj.selectedNewsfeed = (Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section];
    obj.isNotificationSelected = @"false";
    
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;

}

-(void)starBtnPressed:(UIButton*)sender
{
    NewsfeedTableViewCell *cell ;
    if (IS_IOS_7)
    {
       cell  = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(NewsfeedTableViewCell *)[[sender superview] superview];
    }
    
   
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starCount integerValue]>0)
    {
        StarredViewController *obj=[[StarredViewController alloc] init];
        //obj.newsfeedID = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).newsfeedID;
        obj.selectedNewsfeed = (Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section];
        [self presentViewController:obj animated:YES completion:nil];
        obj=nil;
    }
}

-(void)markStarredBtnPressed:(UIButton*)sender
{
    UIImage *CurrentImage = [sender imageForState:UIControlStateNormal];
    
    if([CurrentImage isEqual:[UIImage imageNamed:@"star_grey_btn.png"] ])
    {
        NewsfeedTableViewCell *cell;
        if (IS_IOS_7)
        {
            cell= (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
        }
        else
        {
             cell= (NewsfeedTableViewCell *)[[sender superview] superview] ;
        }
        NSIndexPath *indexPath = [tblView indexPathForCell:cell];
        [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]) addStarredUser];
        
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"],@"user_name", nil];
        [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage addObject:Dictionary];
        
        [tblView reloadData];
        [tblView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [sender setImage:[UIImage imageNamed:@"star_pink_btn.png"] forState:UIControlStateNormal];
    }
    else
    {
        //unstarr feed
        NewsfeedTableViewCell *cell ;
        if (IS_IOS_7)
        {
            cell= (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
        }
        else
        {
            cell= (NewsfeedTableViewCell *)[[sender superview] superview];
        }
      
        NSIndexPath *indexPath = [tblView indexPathForCell:cell];
        [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]) removeStarredUser];
        
        
        for(int i=0;i<((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage.count;i++)
        {
            if([[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage objectAtIndex:i] objectForKey:@"user_name"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"]])
            {
                [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage removeObjectAtIndex:i];
                break;
            }
        }
        
        [tblView reloadData];
        [tblView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [sender setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
    }
    
}

-(void)reportBtnPressed:(UIButton*)sender
{
    NewsfeedTableViewCell *cell;
    if (IS_IOS_7)
    {
      cell  = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell  = (NewsfeedTableViewCell *)[[sender superview] superview] ;
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns)
    {
        ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns = false;
        cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
    }
    else
    {
        ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns = true;
        cell.reportImgView.contentMode=UIViewContentModeScaleAspectFill;
    }
    [tblView reloadData];
}

-(void)removeNewsfeedBtnPressed:(UIButton*)sender
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    [self performSelector:@selector(removeNewsfeedWebserviceCall:) withObject:sender afterDelay:2.0];
}


-(void)removeNewsfeedWebserviceCall:(UIButton*)sender
{
    NewsfeedTableViewCell *cell ;
    if (IS_IOS_7)
    {
        cell= (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell= (NewsfeedTableViewCell *)[[sender superview] superview] ;
    }
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    @try
    {
        [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]) deleteNewsfeed];
    }
    @catch (NSException *exception)
    {
        
    }
    @finally
    {
        
    }
    ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns = false;
    cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
    
    for(int i= indexPath.section;i < newsfeedmanager.array_model_feeds.count-1;i++)
    {
        [newsfeedmanager.array_model_feeds replaceObjectAtIndex:i withObject:[newsfeedmanager.array_model_feeds objectAtIndex:i+1]];
    }
    [newsfeedmanager.array_model_feeds removeLastObject];
    //[sender setEnabled:false];
    [tblView reloadData];
    [activity hide];
}

-(void)reportInappBtnPressed:(UIButton*)sender
{
    NewsfeedTableViewCell *cell;
    if (IS_IOS_7)
    {
        cell= (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell= (NewsfeedTableViewCell *)[[sender superview] superview] ;
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]) reportNewsfeedInappropriate];
    
    ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns = false;
    cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
    
    [tblView reloadData];
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
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.0];
    refreshLabel.textColor = [UIColor colorWithRed:(127.0/255.0) green:(127.0/255.0) blue:(127.0/255.0) alpha:1.0];
    
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up_arrow.png"]];
    refreshArrow.frame = CGRectMake(154,
                                    (floorf(REFRESH_HEADER_HEIGHT - 18/2) / 2)+15,
                                    27/2, 18/2); // X = floorf((REFRESH_HEADER_HEIGHT - 27/2) / 2)
    
//  refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//  refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
//  refreshSpinner.hidesWhenStopped = YES;
    
    if(!LoadingImageView)
    {
        LoadingImageView = [[UIImageView alloc] init];
    }
    LoadingImageView.frame = CGRectMake(153.0,(floorf(REFRESH_HEADER_HEIGHT - 18/2) / 2)+15,15,3.5);
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:LoadingImageView];
    [tblView addSubview:refreshHeaderView];
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
            tblView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            tblView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
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
        tblView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = self.textLoading;
        refreshArrow.hidden = YES;
        //[refreshSpinner startAnimating];
        
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

- (void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        tblView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    //[refreshSpinner stopAnimating];
    [loadingtimer invalidate];
    loadingtimer = nil;
    //NSLog(@"done");
}

- (void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
    //NSLog(@"refresh");
    [newsfeedmanager getFeeds:YES isFetchingEarlier:NO];
}


#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cell for row %d",[self.messages count]);
	static NSString *CellIdentifier = @"MessageCellIdentifier";
    
    // Create cell
	NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
    {
		cell = [[NewsfeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
	}
    cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = YES;
    cell.contentView.userInteractionEnabled=YES;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    
    if(indexPath.section<newsfeedmanager.array_model_feeds.count)
    {
        cell.load_more.frame = CGRectZero;
        cell.activitySpinner.frame = CGRectZero;
        
    /*cell.NextIconArrowImage.frame =  CGRectMake(self.view.frame.size.width/2 - 18 ,8 ,36,34);
    cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
    
    cell.LeftsideUIImageView.frame =  CGRectMake(2 , 2, 50, 50);
    cell.RightSideUIImageView.frame =  CGRectMake(268 , 2, 50, 50);
    cell.LblLeftSideName.frame =  CGRectMake(55 , 2, 100, 28);
    cell.LblRightSideName.frame =  CGRectMake(170 , 2, 100, 28);
    
    cell.LblLeftSideTime.frame =  CGRectMake(2 , 82, 50, 12);
    cell.LblRightSideTime.frame =  CGRectMake(268 , 7, 50, 12);*/
        
        cell.LeftsideUIImageView.frame = CGRectZero;
        cell.RightSideUIImageView.frame = CGRectZero;
        cell.LblLeftSideName.frame = CGRectZero;
        cell.LblRightSideName.frame = CGRectZero;
        cell.LblLeftSideTime.frame = CGRectZero;
        cell.LblRightSideTime.frame = CGRectZero;
        cell.NextIconArrowImage.frame = CGRectZero;
    
    int index=0;
    if(isChatHistoryOrNot == TRUE)
    {
        index = 1;
    }
    
    
    
    
    if(indexPath.section == 0 && isChatHistoryOrNot)
    {
        cell.load_earlierBtn.frame = CGRectMake(10,10,300,30);
        [cell.load_earlierBtn setBackgroundImage:[UIImage imageNamed:@"load-message.png"] forState:UIControlStateNormal];
        [cell.load_earlierBtn addTarget:self action:@selector(loadearlierButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        cell.message.frame = CGRectZero;
        cell.LeftsideUIImageView.frame = CGRectZero;
        cell.RightSideUIImageView.frame = CGRectZero;
        cell.LblLeftSideName.frame = CGRectZero;
        cell.LblRightSideName.frame = CGRectZero;
        cell.LblLeftSideTime.frame = CGRectZero;
        cell.LblRightSideTime.frame = CGRectZero;
        cell.clicksImageView.frame = CGRectZero;
        cell.imageSentView.frame = CGRectZero;
        cell.PhotoView.frame = CGRectZero;
        cell.VideoSentView.frame = CGRectZero;
        cell.ThumbnailPhotoView.frame = CGRectZero;
        cell.play_btn.frame=CGRectZero;
        cell.sound_iconView.frame=CGRectZero;
        cell.sound_bgView.frame=CGRectZero;
        cell.NextIconArrowImage.frame = CGRectZero;
        cell.reportButton.frame = CGRectZero;
        cell.reportImgView.frame = CGRectZero;
        cell.comment1.frame = CGRectZero;
        cell.comment2.frame = CGRectZero;
        cell.comment3.frame = CGRectZero;
        cell.viewAllCommentsBtn.frame =CGRectZero;
        cell.removeNewsfeedBtn.frame =CGRectZero;
        cell.reportInapproriateBtn.frame =CGRectZero;
        
        cell.starCount.frame = CGRectZero;
        cell.commentCount.frame = CGRectZero;
        cell.feedCountImgView.frame = CGRectZero;
        cell.feedStarImgView.frame = CGRectZero;
        cell.topBarImgView.frame = CGRectZero;
        cell.bottomBarImgView.frame = CGRectZero;
        
        cell.footerImgView.frame = CGRectZero;
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
        cell.NextIconArrowImage.frame = CGRectZero;
        
    }
    else
    {
        
        
        cell.load_earlierBtn.frame = CGRectZero;
        
        
        // Message
        
        // NSLog(@"cellForRowIndex %d",[indexPath row]-1);
        
        cell.NextIconArrowImage.frame =  CGRectMake(self.view.frame.size.width/2 - 18 ,8 ,36,34);
        
        
        //        cell.LeftsideUIImageView.frame =  CGRectMake(2 , 4, 50, 50);
        //        cell.RightSideUIImageView.frame =  CGRectMake(268 , 4, 50, 50);
        //        cell.LblLeftSideName.frame =  CGRectMake(2 , 54, 120, 28);
        //        cell.LblRightSideName.frame =  CGRectMake(198 , 54, 120, 28);
        //
        //        cell.LblLeftSideTime.frame =  CGRectMake(2 , 82, 50, 10);
        //        cell.LblRightSideTime.frame =  CGRectMake(268 , 82, 50, 10);
        //
        //        [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:[senderImageUrl objectAtIndex:indexPath.section - index]] placeholderImage:[UIImage imageNamed:@""] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //        [cell.RightSideUIImageView setImageWithURL:[NSURL URLWithString:[receiverImageUrl objectAtIndex:indexPath.section - index]] placeholderImage:[UIImage imageNamed:@""] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //
        //        cell.LblLeftSideName.text = [senderName objectAtIndex:indexPath.section - index];
        //        cell.LblRightSideName.text = [receiverName objectAtIndex:indexPath.section - index];
        //
        //        cell.LblLeftSideTime.text = [senderTime objectAtIndex:indexPath.section - index];
        //        cell.LblRightSideTime.text = [receiverTime objectAtIndex:indexPath.section - index];
        
        
        
        QBChatMessage *messageBody = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section-index]).message;
        NSString *message;
        
        cell.message.textColor = [UIColor blackColor];
        cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        
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
        }
        else
        {
            message = [messageBody text];
            
            
            
            if(message== (NSString*)[NSNull null] || message == nil)
                message = @"";
            
            // font setting when sending the clicks
            
            UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            UIColor *foregroundColor = [UIColor whiteColor];//[UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
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
            
            //cell.message.text = message;
            cell.message.textColor = [UIColor whiteColor];
            //cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
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
            
            float imageHeight = 316/[messageBody.customParameters[@"imageRatio"] floatValue];
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            
            
            cell.imageSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, imageHeight);
            
            
            
            cell.imageSentView.enabled=false;
            
            cell.PhotoView.frame=cell.imageSentView.frame;
            
            [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"fileID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
            {
                [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal];
                cell.imageSentView.enabled=true;
                cell.PhotoView.alpha = 0;
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
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
            
            cell.VideoSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, 254);
            
            cell.VideoSentView.enabled=false;
            
            cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
            
            if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"videoThumbnail"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                    [cell.VideoSentView setImage:[UIImage imageNamed:@"PlayButtonFeed.png"] forState:UIControlStateNormal];
                    cell.VideoSentView.enabled=true;
                    
                 } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                 
            cell.VideoSentView.tag = indexPath.section - index;
            [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                         forControlEvents:UIControlEventTouchUpInside];
            
            //
            
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
            
            cell.sound_bgView.frame=CGRectMake(padding ,padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316, 150);
            cell.sound_iconView.frame=CGRectMake(padding + 100, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height + 25 , 180, 100);
            cell.play_btn.frame = CGRectMake(padding + 15, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height + 37.5f , 75, 75);
            
            cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
            
            cell.play_btn.tag = indexPath.section - index;
            [cell.play_btn setImage:[UIImage imageNamed:@"PlayButtonFeed.png"] forState:UIControlStateNormal];
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
            [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            
            float imageHeight = 316/[messageBody.customParameters[@"imageRatio"] floatValue];
            if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                imageHeight = 125;
            
            
            cell.LocationSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, imageHeight);
            
            
            
            cell.LocationSentView.enabled=false;
            
            cell.LocationView.frame=cell.LocationSentView.frame;
            
            [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"locationID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error)
                {
                    [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal];
                    cell.LocationSentView.enabled=true;
                    cell.LocationView.alpha = 0;

                }
            } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
             
        [cell.LocationSentView addTarget:self action:@selector(showMapView:)
                            forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        else
        {
            [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
            cell.LocationSentView.frame=CGRectZero;
            
            cell.LocationView.image=nil;
            cell.LocationView.frame=CGRectZero;
            cell.LocationView.alpha = 1;
            
            
            
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
        
        CGSize textSize = { 316.0, 12153.85 };
        
        CGSize size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0]
                          constrainedToSize:textSize
                              lineBreakMode:NSLineBreakByWordWrapping];
        
        if(![StrClicks isEqualToString:@"no"])
        {
            size.width+=10.0;
        }
        
        size.width += (padding*10/2);
        [cell setBackgroundColor:[UIColor clearColor]];
        
        if((messageBody.text == (NSString*)[NSNull null] && [messageBody.customParameters[@"card_heading"] length]==0) || ([messageBody.text isEqualToString:@""] && [messageBody.customParameters[@"card_heading"] length]==0))
            size = CGSizeZero;
        
        // Left/Right message box
        
        
        
        if([messageBody.customParameters[@"card_heading"] length]==0)
        {
            
            if([messageBody.customParameters[@"fileID"] length]>1)
            {
                cell.message.frame=CGRectMake(padding, padding + cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height, 316, size.height+padding*15);
            }
            else if([messageBody.customParameters[@"locationID"] length]>1)
            {
                 cell.message.frame=CGRectMake(padding, padding + cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height, 316, size.height+padding*15);
            }
            else if([messageBody.customParameters[@"videoID"] length]>1)
            {
                cell.message.frame=CGRectMake(padding, padding + cell.ThumbnailPhotoView.frame.origin.y + cell.ThumbnailPhotoView.frame.size.height, 316, size.height+padding*15);
            }
            else if([messageBody.customParameters[@"audioID"] length]>1)
            {
                cell.message.frame=CGRectMake(padding, padding + cell.sound_bgView.frame.origin.y + cell.sound_bgView.frame.size.height, 316, size.height+padding*15);
            }
            else
                [cell.message setFrame:CGRectMake(padding, padding + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316 , size.height+padding*15)];
            
            
            
            
            //for clicks image in the textview
            if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
            {
                if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+31,
                                                              cell.message.frame.origin.y+12,
                                                              14,15)];
                else
                    [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                              cell.message.frame.origin.y+12,
                                                              14,15)];
                
                cell.clicksImageView.image=[UIImage imageNamed:@"headerIconWhite.png"];
                //[cell.message setBackgroundColor:[UIColor colorWithRed:(247.0/255.0) green:(228.0/255.0) blue:(224.0/255.0) alpha:1.0]];
                [cell.message setBackgroundColor:[UIColor colorWithRed:(245.0/255.0) green:(161/255.0) blue:(155/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 2.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]]; // owner gray chat popup
                cell.message.layer.borderWidth = 0.0f;
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
            }
        }
        else
        {
            [cell.message setFrame:CGRectZero];
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            cell.message.layer.borderWidth = 0.0f;
            [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]]; // owner gray chat popup
        }
        
        if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"videoID"] length]>1  || [messageBody.customParameters[@"audioID"] length]>1  || [messageBody.customParameters[@"locationID"] length]>1)
        {
            if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
            {
                //[cell.message setBackgroundColor:[UIColor colorWithRed:(247.0/255.0) green:(228.0/255.0) blue:(224.0/255.0) alpha:1.0]];
                [cell.message setBackgroundColor:[UIColor colorWithRed:(245.0/255.0) green:(161/255.0) blue:(155/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 3.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 3.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            
            if((cell.message.text.length==0 && [messageBody.customParameters[@"clicks"] isEqualToString:@"no"]) || ( cell.message.text.length==0 && [messageBody.customParameters[@"clicks"]length]==0))
            {
                //[cell.message setFrame:CGRectZero];
                
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                //                [cell.message setBackgroundColor:[UIColor whiteColor]];
                cell.message.layer.borderWidth = 0.0f;
            }
        }
        else if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
        {
            cell.message.layer.borderWidth = 2.0f;
            cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
        }
        else
        {
            cell.message.layer.borderWidth = 0.0f;
        }
        
        
        
        
        //-------for displaying cards------------
        if([messageBody.customParameters[@"card_heading"] length]>0)
        {
            
            [cell.message setFrame:CGRectMake(padding, padding*3 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316 , 128+padding*10)];
            
            [cell.clicksImageView setFrame:CGRectZero];
            cell.clicksImageView.image=nil;
            [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]];
            cell.message.layer.borderWidth = 0.0f;
            
            cell.PhotoView.frame=CGRectZero;
            cell.PhotoView.image=nil;
            
            cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x + 55,cell.message.frame.origin.y + 10, 95, 125);
            cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
            
            cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
            cell.cardHeading.text = messageBody.customParameters[@"card_heading"];
            
            cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
            cell.cardContent.text = messageBody.customParameters[@"card_content"];
            
            cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
            cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
            
            cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
            cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
            
            if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
            {
                cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x +  4 ,cell.cardImageView.frame.origin.y + 10 + 6 , 95-6, 125 -36);
                cell.cardHeading.numberOfLines=4;
                cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
            }
            else
            {
                cell.cardHeading.numberOfLines=2;
                cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
            }
            
            
            cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
            cell.cardSender.text = [cell.LblLeftSideName.text capitalizedString];
            //cell.cardSender.text = @"You";
            
            
            cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 10, 120, 40);
            cell.cardPlayed_Countered.text = messageBody.customParameters[@"card_Played_Countered"];
            
            
            cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 40, 90, 2);
            cell.cardBarView.image = [UIImage imageNamed:@"bar.png"];
            
            
            if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
            {
                cell.cardAccepted.frame=CGRectZero;
                cell.cardRejected.frame=CGRectZero;
                cell.cardCountered.frame=CGRectZero;
                
                cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 50 - 5, 81, 80);
                cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                
            }
            else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
            {
                cell.cardAccepted.frame=CGRectZero;
                cell.cardRejected.frame=CGRectZero;
                cell.cardCountered.frame=CGRectZero;
                
                cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 50 - 5, 81, 80);
                cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                
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
        
        cell.topBarImgView.frame = CGRectMake(2, cell.message.frame.origin.y + cell.message.frame.size.height + padding*2, 316, 3);
        cell.topBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
        
        
        
        cell.feedCountImgView.frame = CGRectMake(10, cell.message.frame.origin.y + cell.message.frame.size.height + padding*26, 35/2.0, 30/2);
        cell.feedCountImgView.image = [UIImage imageNamed:@"grey_cloud.png"];
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]>0)
        {
            for(int k=0;k<((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count;k++)
            {
                NSString *commentText = [NSString stringWithFormat:@"%@  %@",[[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString], [[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"comment"]];
            
            UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
            UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15.0];
            UIColor *foregroundColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:209/255.0 alpha:1];
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   boldFont, NSFontAttributeName,nil];
            NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
            const NSRange range = NSMakeRange(0,[[[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString] length]);
            NSMutableAttributedString *attributedText =
            [[NSMutableAttributedString alloc] initWithString:commentText
                                                   attributes:attrs];
            [attributedText setAttributes:subAttrs range:range];
                
                
            CGFloat width = 275;
            CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

                
            if(k==0)
            {
                [cell.comment1 setAttributedText:attributedText];
                cell.comment1.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*24, 275, rect.size.height);
                
            }
            else if(k==1)
            {
                [cell.comment2 setAttributedText:attributedText];
                cell.comment2.frame = CGRectMake(40, cell.comment1.frame.origin.y + cell.comment1.frame.size.height +  padding*3, 275, rect.size.height);
            }
            else if(k==2)
            {
                [cell.comment3 setAttributedText:attributedText];
                cell.comment3.frame = CGRectMake(40, cell.comment2.frame.origin.y + cell.comment2.frame.size.height + padding*3, 275, rect.size.height);
            }
            
            }
            
            
            
            
            if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==1)
            {
                cell.comment2.frame = CGRectZero;
                cell.comment3.frame = CGRectZero;
                comments_offsetY = 20;
                cell.commentCount.frame = CGRectZero;
                cell.viewAllCommentsBtn.frame = CGRectZero;
            }
            else if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==2)
            {
                cell.comment3.frame = CGRectZero;
                comments_offsetY = 10;
                cell.commentCount.frame = CGRectZero;
                cell.viewAllCommentsBtn.frame = CGRectZero;
            }
            else
            {
                comments_offsetY = 0;
                
                if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]>3)
                {
                    comments_offsetY = -4;
                    
                    cell.commentCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*22, 275, 20);
                    cell.commentCount.text = [NSString stringWithFormat:@"View all %i comments",[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]];
                    cell.comment1.frame = CGRectMake(40, cell.comment1.frame.origin.y+15, 275, cell.comment1.frame.size.height);
                    cell.comment2.frame = CGRectMake(40, cell.comment2.frame.origin.y+15, 275, cell.comment2.frame.size.height);
                    cell.comment3.frame = CGRectMake(40, cell.comment3.frame.origin.y+15, 275, cell.comment3.frame.size.height);
                    
                    cell.viewAllCommentsBtn.frame = CGRectMake(0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*20, 160, 25);
                    [cell.viewAllCommentsBtn addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    cell.commentCount.frame = CGRectZero;
                    cell.viewAllCommentsBtn.frame = CGRectZero;
                }
            }
            
            
        }
        else
        {
            cell.comment1.frame = CGRectZero;
            cell.comment2.frame = CGRectZero;
            cell.comment3.frame = CGRectZero;
            
            comments_offsetY = 24;
            
            cell.commentCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*24, 275, 20);
            cell.commentCount.text = @"No Comments";//[NSString stringWithFormat:@"%@",((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount];
            
            cell.viewAllCommentsBtn.frame = CGRectZero;
        }
        
        //cell.commentCount.frame = CGRectMake(50, cell.message.frame.origin.y + cell.message.frame.size.height + padding*30, 265, 54/2);
        //cell.commentCount.text = [NSString stringWithFormat:@"%@",((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount];
        
        cell.feedStarImgView.frame = CGRectMake(10, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 37/2.0, 36/2);
        cell.feedStarImgView.image = [UIImage imageNamed:@"grey_star.png"];
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starCount integerValue]>5 || [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starCount integerValue] == 0)
        {
            cell.starCount.numberOfLines=1;
            [cell.starCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
            [cell.starCount setTextColor:[UIColor colorWithRed:115/255.0 green:119/255.0 blue:118/255.0 alpha:1]];
            cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 275, 20);
            if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starCount integerValue] == 0)
                cell.starCount.text = [NSString stringWithFormat:@"No Stars"];
            else
                cell.starCount.text = [NSString stringWithFormat:@"%@ Stars", ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starCount];
        }
        else
        {
            NSString *starredList = @"";
            for(int k=0;k<((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage.count;k++)
            {
                starredList = [starredList stringByAppendingString:[[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString]];
                
                if(k!=((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).starredArrayNewsfeedPage.count-1)
                    starredList = [starredList stringByAppendingString:@", "];
                
            }
            
            CGSize listSize = [starredList sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
            if(listSize.width>265)
            {
                cell.starCount.numberOfLines=2;
                cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*4, 275, 40);
            }
            else
            {
                cell.starCount.numberOfLines=1;
                cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 275, 20);
            }
            
            [cell.starCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
            [cell.starCount setTextColor:[UIColor colorWithRed:78/255.0 green:194/255.0 blue:209/255.0 alpha:1]];
            
            cell.starCount.text = starredList;
        }
        
        int heightOffset;
        if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==1)
        {
            heightOffset = cell.comment1.frame.origin.y+cell.comment1.frame.size.height;
        }
        else if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==2)
        {
             heightOffset = cell.comment2.frame.origin.y+cell.comment2.frame.size.height;
        }
        else
        {
            if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count!=0)
            {
                heightOffset = cell.comment3.frame.origin.y+cell.comment3.frame.size.height;
//                if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]>3)
//                {
//                    heightOffset = cell.comment2.frame.origin.y+cell.comment2.frame.size.height;
//                }
            }
            else
            {
                heightOffset = cell.message.frame.origin.y + cell.message.frame.size.height + padding*62 - 35;
            }
        }
        
        
        
        cell.starButton.frame = CGRectMake(5, cell.message.frame.origin.y + cell.message.frame.size.height + padding*4, 125, 42);
        [cell.starButton addTarget:self action:@selector(starBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.bottomBarImgView.frame = CGRectMake(2, heightOffset + padding*3, 316, 3);
        cell.bottomBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
        
        cell.commentButton.frame = CGRectMake(96, heightOffset + padding*9, 209/2.0, 69/2.0);
        [cell.commentButton setImage:[UIImage imageNamed:@"comment_grey_btn.png"] forState:UIControlStateNormal];
        [cell.commentButton addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).userCommented boolValue])
        {
            [cell.commentButton setImage:[UIImage imageNamed:@"comment_pink_btn.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.commentButton setImage:[UIImage imageNamed:@"comment_grey_btn.png"] forState:UIControlStateNormal];
        }

        
        
        
        cell.markStarredButton.frame = CGRectMake(8, heightOffset + padding*9, 148/2.0, 69/2.0);
        [cell.markStarredButton setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
        [cell.markStarredButton addTarget:self action:@selector(markStarredBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).userStarred boolValue])
        {
            //cell.markStarredButton.enabled =false;
            [cell.markStarredButton setImage:[UIImage imageNamed:@"star_pink_btn.png"] forState:UIControlStateNormal];
        }
        else
        {
            //cell.markStarredButton.enabled =true;
            [cell.markStarredButton setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
        }
        
        
        
        cell.removeNewsfeedBtn.frame = CGRectMake(315-432/2.0, heightOffset + padding*5-96, 432/2.0, 87/2.0);
        [cell.removeNewsfeedBtn setImage:[UIImage imageNamed:@"removeNewsfeed.png"] forState:UIControlStateNormal];
        [cell.removeNewsfeedBtn addTarget:self action:@selector(removeNewsfeedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.reportInapproriateBtn.frame = CGRectMake(315-432/2.0, heightOffset + padding*5-53 , 432/2.0, 87/2.0);
        [cell.reportInapproriateBtn setImage:[UIImage imageNamed:@"reportInappropriate.png"] forState:UIControlStateNormal];
        [cell.reportInapproriateBtn addTarget:self action:@selector(reportInappBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if (!((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns)
        {
            cell.removeNewsfeedBtn.hidden = YES;
            cell.reportInapproriateBtn.hidden = YES;
            cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
        }
        else
        {
            if([[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).senderName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]] || [[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).receiverName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
            {
                cell.removeNewsfeedBtn.hidden = NO;
                cell.reportInapproriateBtn.hidden = NO;
            }
            else
            {
                cell.removeNewsfeedBtn.hidden = YES;
                cell.reportInapproriateBtn.hidden = NO;
            }
            cell.reportImgView.contentMode=UIViewContentModeScaleAspectFill;
        }
        
        cell.reportImgView.frame = CGRectMake(275+41/4.0, heightOffset + padding*10, 41/2.0f, 11/2.0f);
        if(!((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).showReportBtns)
            cell.reportImgView.image = [UIImage imageNamed:@"3_dot.png"];
        else
            cell.reportImgView.image = [UIImage imageNamed:@"cross.png"];
        
        cell.reportButton.frame = CGRectMake(270, heightOffset + padding*10, 50, 30);
        [cell.reportButton addTarget:self action:@selector(reportBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.footerImgView.frame = CGRectZero;
        //cell.footerImgView.frame = CGRectMake(0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*80, 320, 15);
        //cell.footerImgView.image = [UIImage imageNamed:@"userlistBtm.png"];
    }
    
    }
    else
    {
        cell.load_more.frame = CGRectMake(0, 5, 320, 20);
        cell.activitySpinner.frame = CGRectMake(70, 6, 20, 20);
        
        if([newsfeedmanager.array_model_feeds count]>=25 && newsfeedmanager.isHistoryAvailable)
        {
            cell.load_more.hidden = false;
            [cell.activitySpinner startAnimating];
        }
        else
        {
            cell.load_more.hidden = true;
            [cell.activitySpinner stopAnimating];
        }

        
        cell.message.frame = CGRectZero;
        cell.LeftsideUIImageView.frame = CGRectZero;
        cell.RightSideUIImageView.frame = CGRectZero;
        cell.LblLeftSideName.frame = CGRectZero;
        cell.LblRightSideName.frame = CGRectZero;
        cell.LblLeftSideTime.frame = CGRectZero;
        cell.LblRightSideTime.frame = CGRectZero;
        cell.clicksImageView.frame = CGRectZero;
        cell.imageSentView.frame = CGRectZero;
        cell.PhotoView.frame = CGRectZero;
        cell.VideoSentView.frame = CGRectZero;
        cell.ThumbnailPhotoView.frame = CGRectZero;
        cell.play_btn.frame=CGRectZero;
        cell.sound_iconView.frame=CGRectZero;
        cell.sound_bgView.frame=CGRectZero;
        cell.NextIconArrowImage.frame = CGRectZero;
        
        cell.starCount.frame = CGRectZero;
        cell.commentCount.frame = CGRectZero;
        cell.feedCountImgView.frame = CGRectZero;
        cell.feedStarImgView.frame = CGRectZero;
        cell.topBarImgView.frame = CGRectZero;
        cell.bottomBarImgView.frame = CGRectZero;
        cell.reportButton.frame = CGRectZero;
        cell.reportImgView.frame = CGRectZero;
        cell.comment1.frame = CGRectZero;
        cell.comment2.frame = CGRectZero;
        cell.comment3.frame = CGRectZero;
        cell.viewAllCommentsBtn.frame =CGRectZero;
        cell.removeNewsfeedBtn.frame =CGRectZero;
        cell.reportInapproriateBtn.frame =CGRectZero;
        
        cell.footerImgView.frame = CGRectZero;
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
        cell.NextIconArrowImage.frame = CGRectZero;

    }

    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        
        if(indexPath.section==newsfeedmanager.array_model_feeds.count && !newsfeedmanager.isFetchingEarlier && [newsfeedmanager.array_model_feeds count]>=25 && newsfeedmanager.isHistoryAvailable)
        {
            newsfeedmanager.isFetchingEarlier = true;
            [newsfeedmanager getFeeds:YES isFetchingEarlier:YES];
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int index=0;
    
    if(isChatHistoryOrNot == TRUE)
    {
        index = 1;
    }
    return [newsfeedmanager.array_model_feeds count]+index + 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section<newsfeedmanager.array_model_feeds.count)
    {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 68)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *whiteBgImageView = [[UIImageView alloc] init];
        whiteBgImageView.backgroundColor = [UIColor whiteColor];
        whiteBgImageView.alpha = 0.94f;
        [whiteBgImageView setFrame:CGRectMake(0 , 9, 320, 60)];
        [headerView addSubview:whiteBgImageView];
        
        UIImageView *LeftsideUIImageView = [[UIImageView alloc] init];
        LeftsideUIImageView.backgroundColor = [UIColor lightGrayColor];
        [LeftsideUIImageView setFrame:CGRectMake(2 , 12, 50, 50)];
        //LeftsideUIImageView.contentMode=UIViewContentModeScaleAspectFit;
        LeftsideUIImageView.layer.cornerRadius = 0.0f;
        LeftsideUIImageView.layer.borderWidth = 0.0f;
        LeftsideUIImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[headerView addSubview:LeftsideUIImageView];
        
        UILabel *LblLeftSideName = [[UILabel alloc] init] ;
        [LblLeftSideName setFrame:CGRectMake(56 , 9, 95, 28)];
        LblLeftSideName.numberOfLines=1;
        LblLeftSideName.tag = section;
        LblLeftSideName.textAlignment=NSTextAlignmentLeft;
        [LblLeftSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:17]];
        [LblLeftSideName setTextColor:[UIColor colorWithRed:79/255.0 green:194/255.0 blue:210/255.0 alpha:1]];
        [headerView addSubview:LblLeftSideName];
        
        UILabel *LblRightSideName = [[UILabel alloc] init] ;
        [LblRightSideName setFrame:CGRectMake(174 , 9, 100, 28)];
        LblRightSideName.numberOfLines=1;
        LblRightSideName.tag = section;
        LblRightSideName.textAlignment=NSTextAlignmentLeft;
        [LblRightSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:17]];
        [LblRightSideName setTextColor:[UIColor colorWithRed:131/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
        [headerView addSubview:LblRightSideName];
        
        UIImageView *NextIconArrowImage = [[UIImageView alloc] init];
        NextIconArrowImage.backgroundColor = [UIColor clearColor];
        NextIconArrowImage.frame =  CGRectMake(self.view.frame.size.width/2 - 33/4.0 ,17 ,33/2.0,31/2.0);
        NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
        NextIconArrowImage.contentMode=UIViewContentModeScaleAspectFit;
        NextIconArrowImage.layer.cornerRadius = 0.0f;
        NextIconArrowImage.layer.borderWidth = 0.0f;
		[headerView addSubview:NextIconArrowImage];
        
        
        UILabel *LblRightSideTime = [[UILabel alloc] init] ;
        [LblRightSideTime setFrame:CGRectMake(268 , 16, 50, 12)];
        LblRightSideTime.numberOfLines=1;
        LblRightSideTime.textAlignment=NSTextAlignmentRight;
        [LblRightSideTime setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:10]];
        [LblRightSideTime setTextColor:[UIColor colorWithRed:(148.0/255.0) green:(148.0/255.0) blue:(148.0/255.0) alpha:1]];
        [headerView addSubview:LblRightSideTime];
        
        UIImageView *topBarImgView = [[UIImageView alloc] init];
        topBarImgView.backgroundColor = [UIColor clearColor];
        [topBarImgView setFrame:CGRectZero];
        topBarImgView.contentMode=UIViewContentModeScaleAspectFit;
        topBarImgView.frame = CGRectMake(2, 65, 316, 3);
        topBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
		[headerView addSubview:topBarImgView];
        
        
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isSenderFollower isEqualToString:@"true"] && [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isReceiverFollower isEqualToString:@"false"])
        {
            
            [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
            
            
            LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
            LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
            
            
            LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverTime;
            
            NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
        }
        else if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isSenderFollower isEqualToString:@"false"] && [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isReceiverFollower isEqualToString:@"true"])
        {
            [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
            LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
            
            
            LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderTime;
            
            NextIconArrowImage.image = [UIImage imageNamed:@"preIcon.png"];
        }
        else if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isSenderFollower isEqualToString:@"true"] && [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isReceiverFollower isEqualToString:@"true"])
        {
            [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
            LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
            
            
            LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverTime;
            
            NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
        }
        else if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isSenderFollower isEqualToString:@"false"] && [((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).isReceiverFollower isEqualToString:@"false"])
        {
            if([[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
            {
                [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
                LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
                
                
                LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverTime;
                
                NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            }
            else if([[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
            {
                [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
                LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
                
                
                LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderTime;
                
                NextIconArrowImage.image = [UIImage imageNamed:@"preIcon.png"];
            }
            else
            {
                [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
                LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
                
                
                LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverTime;
                
                NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            }

        }
        else
        {
            [LeftsideUIImageView setImageWithURL:[NSURL URLWithString:((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            
            LblLeftSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).senderName;
            LblRightSideName.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverName;
            
            
            LblRightSideTime.text = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:section]).receiverTime;
            
            NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
        }
        
        CGSize leftNameSize = [LblLeftSideName.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:17]];
        
        CGSize rightNameSize = [LblRightSideName.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:17]];
        
        if(leftNameSize.width > 94)
        {
            [LblLeftSideName setFrame:CGRectMake(56 , 9, 190, 28)];
            LblLeftSideName.textAlignment = NSTextAlignmentLeft;
            LblRightSideName.textAlignment = NSTextAlignmentLeft;
            [LblRightSideName setFrame:CGRectMake(56 , 30, 190, 28)];
            NextIconArrowImage.frame =  CGRectMake(250 ,17 ,33/2.0,31/2.0);
            //NextIconArrowImage.frame =  CGRectMake(LblLeftSideName.frame.origin.x + leftNameSize.width - 10 ,17 ,33/2.0,31/2.0);
        }
        else
        {
            LblLeftSideName.textAlignment = NSTextAlignmentLeft;
            LblRightSideName.textAlignment = NSTextAlignmentLeft;
        }

        NextIconArrowImage.frame =  CGRectMake(LblLeftSideName.frame.origin.x + leftNameSize.width + 4,17 ,33/2.0,31/2.0);
        
        float remainingWidth = 212 - leftNameSize.width - 22;
        if(remainingWidth<rightNameSize.width)
            [LblRightSideName setFrame:CGRectMake(56 , 30, 190, 28)];
        else
            [LblRightSideName setFrame:CGRectMake(LblLeftSideName.frame.origin.x + leftNameSize.width + NextIconArrowImage.frame.size.width+8 , 9.5f, 100, 28)];
        
        
        
        //make usernames clickable
        LblLeftSideName.userInteractionEnabled = YES;
        LblRightSideName.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureLeft =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
        UITapGestureRecognizer *tapGestureRight =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
        [LblLeftSideName addGestureRecognizer:tapGestureLeft];
        [LblRightSideName addGestureRecognizer:tapGestureRight];
        /////////////////////////////////////
    
        return headerView;
    }
    
    return Nil;
        

}

- (void) labelTap:(UITapGestureRecognizer*)gestureRecognizer
{
    UILabel *sender = (UILabel *)[gestureRecognizer view];
    
    if([[sender.text uppercaseString] isEqualToString:[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).senderName uppercaseString]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
     
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).senderID isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"QBUserName"]] ])
        {
            //open my profile
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromLeft;
            [navigationController.view.layer addAnimation:transition forKey:nil];
            
            
            [navigationController popToRootViewControllerAnimated:NO];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else
        {
            profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
            RelationInfo *relationObj = [[RelationInfo alloc] init];
            relationObj.partnerPhoneNumber = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).senderPhoneNo;
            relationObj.partnerName = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).senderName;
            profile_other.relationObject = relationObj;
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            navigationController.viewControllers = controllers;
            [navigationController pushViewController:profile_other animated:YES];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LeftMenuPartnerQBId"];
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).receiverID isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"QBUserName"]] ])
        {
            //open my profile
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            transition.type = kCATransitionReveal;
            transition.subtype = kCATransitionFromLeft;
            [navigationController.view.layer addAnimation:transition forKey:nil];
            
            
            [navigationController popToRootViewControllerAnimated:NO];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else
        {
            profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
            RelationInfo *relationObj = [[RelationInfo alloc] init];
            relationObj.partnerPhoneNumber = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).receiverPhoneNo;
            relationObj.partnerName = ((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:sender.tag]).receiverName;
            profile_other.relationObject = relationObj;
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            navigationController.viewControllers = controllers;
            [navigationController pushViewController:profile_other animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section<newsfeedmanager.array_model_feeds.count)
        return 68;
    else
        return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section<newsfeedmanager.array_model_feeds.count)
    {
    int index=0;
    QBChatMessage *chatMessage;
    if(isChatHistoryOrNot == TRUE)
    {
        index = 1;
    }
    CGSize size;
    if(index == 1)
    {
        if(indexPath.section == 0)
        {
            return 50;
        }
        else
        {
            chatMessage = (QBChatMessage *)((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section-index]).message;
        }
    }
    else
    {
        chatMessage = (QBChatMessage *)((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).message;
    }
    
    NSString *text = chatMessage.text;
    CGSize textSize = { 316.0, 12153.85 };
    
    
    if((chatMessage.text == (NSString*)[NSNull null] && [chatMessage.customParameters[@"card_heading"] length]==0) || ([chatMessage.text isEqualToString:@""] && [chatMessage.customParameters[@"card_heading"] length]==0))
        size = CGSizeZero;
    else
    {
        size = [text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0]
                constrainedToSize:textSize
                    lineBreakMode:NSLineBreakByWordWrapping];
        size.height += padding;
    }
    
    if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"locationID"] length]>1)
    {
        float imageHeight = 316/[chatMessage.customParameters[@"imageRatio"] floatValue];
        /*if(imageHeight<=125)
         size.height += 125;
         else*/
        if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
            size.height += 125;
        else
            size.height += imageHeight;
    }
    
    if([chatMessage.customParameters[@"videoID"]  length]>0)
    {
        size.height += 259;
    }
    
    if([chatMessage.customParameters[@"audioID"]  length]>0)
    {
        size.height += 155;
    }
    
    if([chatMessage.customParameters[@"card_heading"] length]>0)
    {
        size.height += 115;
    }
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]>0)
        {
            
            int comment1height = 0 ,comment2height = 0,comment3height = 0;
            
            for(int k=0;k<((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count;k++)
            {
                NSString *commentText = [NSString stringWithFormat:@"%@  %@",[[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString], [[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"comment"]];
                
                UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
                UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15.0];
                UIColor *foregroundColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:209/255.0 alpha:1];
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       boldFont, NSFontAttributeName,nil];
                NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
                const NSRange range = NSMakeRange(0,[[[[((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString] length]);
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:commentText
                                                       attributes:attrs];
                [attributedText setAttributes:subAttrs range:range];
                
                CGFloat width = 275;
                CGRect Rect = [attributedText boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                
                if(k==0)
                {
                    comment1height = Rect.size.height;
                }
                else if(k==1)
                {
                    comment2height = Rect.size.height;
                }
                else if(k==2)
                {
                    comment3height = Rect.size.height;
                }
                
            }
        
            if(comment3height == 0)
            {
                comment3height = -20;
            }
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==1)
        {
            comments_offsetY = 20;
        }
        else if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count==2)
        {
            comments_offsetY = 10;
        }
        else if([((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount integerValue]>3)
        {
            comments_offsetY = -4;
        }
        else if(((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentsArrayNewsfeedPage.count>2)
        {
            comments_offsetY = 0;
        }
        else
        {
            comments_offsetY = 35;
        }

            NSLog(@"%f",size.height+padding+140+20);
            NSLog(@"%d",comment1height);
            NSLog(@"%d",comment2height);
            NSLog(@"%d",comment3height);
            return size.height+padding+140 + 20 + comment1height + comment2height + comment3height;
    }
    else
    {
        return size.height+padding+140 + 46 - 20;
    }
    
    }

    return 0;
}


#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    if([isFromSharingView isEqualToString:@"true"])
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
    }
    else
    {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
