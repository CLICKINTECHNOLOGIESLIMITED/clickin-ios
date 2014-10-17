//
//  LeftViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "follower_owner.h"
#import "profile_owner.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "CenterViewController.h"
#import "NewsfeedViewController.h"
#import "AppDelegate.h"


@interface NSDictionary (JRAdditions)
- (NSDictionary *) dictionaryByReplacingNullsWithStrings;
@end

@implementation NSDictionary (JRAdditions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}
@end

@interface follower_owner ()

@end

@implementation follower_owner

@synthesize is_Owner,otheruser_phone_no,name;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
-(void)viewWillAppear:(BOOL)animated
{
    if(activity==nil)
    {
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        [activity show];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self getfollowerslist];
    [self getprofileinfo];
}
-(void)viewDidDisappear:(BOOL)animated
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
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(FollowersFollowingUpdated:)
     name:Notification_FollowersFollowingUpdated
     object:nil];
    
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;

    
    //screen bg
    UIImageView *screen_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (IS_IPHONE_5) {
        screen_bg.frame=CGRectMake(0, 0, 320, 568);
    }
    screen_bg.image=[UIImage imageNamed:@"background1140.png"];
    [self.view addSubview:screen_bg];
    
    // header bg
    UIImageView *header_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, -0.5, 321, 53.5)];
    header_bg.image=[UIImage imageNamed:@"top_hedder.png"];
    [self.view addSubview:header_bg];
    
    // header text
    UILabel *header_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 150, 20))];
    header_text.textColor = [UIColor whiteColor];
    header_text.center=CGPointMake(160, 22);
    header_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    header_text.tag = 5;
    header_text.backgroundColor = [UIColor clearColor];
    // header_text = [UIFont fontWithName:@"Halvetica" size:10];
    header_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
    header_text.lineBreakMode = YES;
    header_text.numberOfLines = 0;
    header_text.lineBreakMode = NSLineBreakByTruncatingTail;
    if([is_Owner isEqualToString:@"false"])
        header_text.text=name;
    else
        header_text.text=@"FOLLOWERS";
    [self.view addSubview:header_text];
    
    //left menu button
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton addTarget:self
                   action:@selector(leftbuttonpressed)
         forControlEvents:UIControlEventTouchDown];
    //[leftbutton setTitle:@"Show View" forState:UIControlStateNormal];
    leftbutton.frame = CGRectMake(0, 0, 44, 44);
    [self.view addSubview:leftbutton];
    
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
    
//    UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(10, 54, 200, 30))];
//    headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
//    headertext.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
//    headertext.backgroundColor = [UIColor clearColor];
//    //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
//    headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
//    headertext.lineBreakMode = YES;
//    headertext.numberOfLines = 0;
//    headertext.text=@"FOLLOWERS";
//    headertext.lineBreakMode = NSLineBreakByTruncatingTail;
//    [self.view addSubview:headertext];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(10, 64, 300, 480-64) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(10,64, 300, 568-64);
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
    
//  followerArray=[[NSMutableArray alloc] init];
    
    followerSection1Array = [[NSMutableArray alloc] init];
    followerSection2Array = [[NSMutableArray alloc] init];
    
    
    
    //[self getfollowerslist];
//    if(timer==nil)
//        timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self
//                                           selector:@selector(autoUpdateScreen)
//                                           userInfo:nil
//                                            repeats:YES];
}

- (void)ProfileInfoNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    //set notification count set
    notification_text.text=profilemanager.ownerDetails.notificationCount;
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
    
}


- (void)FollowersFollowingUpdated:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [followerSection1Array removeAllObjects];
    [followerSection2Array removeAllObjects];
    
    if([is_Owner isEqualToString:@"false"])
    {
        [followerSection1Array addObjectsFromArray:otherUser.followerRequestedArray];
        [followerSection2Array addObjectsFromArray:otherUser.followerArray];
    }
    else
    {
        [followerSection1Array addObjectsFromArray:profilemanager.ownerDetails.followerRequestedArray];
        [followerSection2Array addObjectsFromArray:profilemanager.ownerDetails.followerArray];
    }
    
    
    if(followerSection1Array.count == 0 && followerSection2Array.count == 0 && ![is_Owner isEqualToString:@"false"])
    {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(41,100, 476/2, 204/2)];
        imgView.image = [UIImage imageNamed:@"21Text.png"];
        [self.view addSubview:imgView];
    }
    
    
    [table reloadData];
    [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [activity hide];
}


-(void)autoUpdateScreen
{
    //[self getfollowerslist];
    //[self getprofileinfo];
}

-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}


-(void)leftbuttonpressed
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    [self.navigationController popViewControllerAnimated:NO];
}




-(void)getprofileinfo
{
    [profilemanager.ownerDetails getProfileInfo:YES];
    
    /*
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
    else
    {
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        
    }
}
*/


-(void)getfollowerslist
{
    if([is_Owner isEqualToString:@"false"])
    {
        if(otherUser==nil)
            otherUser = [[UserInfo alloc] init];
        otherUser.phoneNumber = otheruser_phone_no;
        [otherUser getFollowerFollowingList:NO];
    }
    else
        [profilemanager.ownerDetails getFollowerFollowingList:YES];
    
    
    /*
    NSString *str ;
    if([is_Owner isEqualToString:@"true"])
        str= [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow"];
    else
    {
        str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow/profile_phone_no:%s",[otheruser_phone_no UTF8String]];
        str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //  NSError *error;
    //  NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //  Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    //  NSLog(@"%@",str);
    //  NSLog(@"%@",Dictionary);
    
    //  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //  [request appendPostData:jsonData];
    request.tag = 12;
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];*/
}


-(void)AcceptFollower:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[button superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[button superview] superview];
    }

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    
    [profilemanager.ownerDetails acceptFollower:indexPath.row-1];
    
    /*AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/followupdatestatus"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerSection1Array objectAtIndex:indexPath.row] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"true", @"accepted", nil];
        
        NSLog(@"%@",Dictionary);
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[followerSection1Array objectAtIndex:indexPath.row];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"is_following"];
        [newDict setObject:@"false" forKey:@"following_accepted"];
        [newDict setObject:@"true" forKey:@"accepted"];
        [followerSection1Array replaceObjectAtIndex:indexPath.row withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
        request.tag = 14;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [followerSection2Array addObject:[followerSection1Array objectAtIndex:indexPath.row]];
        
        for(int i=indexPath.row;i<followerSection1Array.count-1;i++)
        {
            [followerSection1Array replaceObjectAtIndex:i withObject:[followerSection1Array objectAtIndex:i+1]];
        }
        [followerSection1Array removeLastObject];
        
        [table reloadData];
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }*/
}

-(void)RejectFollower:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[button superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[button superview] superview];
    }

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);
    
    [profilemanager.ownerDetails rejectFollower:indexPath.row-1];
    
    /*
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/followupdatestatus"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerSection1Array objectAtIndex:indexPath.row] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"false", @"accepted", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 14;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        for(int i=indexPath.row;i<followerSection1Array.count-1;i++)
        {
            [followerSection1Array replaceObjectAtIndex:i withObject:[followerSection1Array objectAtIndex:i+1]];
        }
        [followerSection1Array removeLastObject];
        [table reloadData];
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }*/
}


-(void)alertForFollowButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[button superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[button superview] superview];
    }

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    selected_row = indexPath.row-1;
    
    UIImage *CurrentImage = button.currentBackgroundImage;
    
    if(CurrentImage == [UIImage imageNamed:@"follow-profile.png"])
        btn_state = 1;
    else if(CurrentImage == [UIImage imageNamed:@"follow-profile-slctd.png"])
        btn_state = 2;
    
    if(btn_state == 1)
        [self FollowButtonAction];
    else if(btn_state == 2)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to unfollow the selected user?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
//        alert.tag = 44;
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:@"Do you want to unfollow the selected user?"
                                                                      okButtonTitle:@"OK"
                                                                  cancelButtonTitle:@"Cancel"];
        
        alertView.tag = 44;
        alertView.delegate = self;
        [alertView showForPresentView];
        alertView = nil;

    }
}


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==44)  // unfollow button service
    {
        if(buttonType==0)
        {
            [self FollowButtonAction];
        }
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==44)  // unfollow button service
    {
        if(buttonIndex==0)
        {
            [self FollowButtonAction];
        }
    }
}
*/




-(void)FollowButtonAction
{
    //UIButton *button = (UIButton *)sender;
    //UIImage *CurrentImage = button.currentBackgroundImage;
    UIButton *button = ((UIButton*)[((UITableViewCell*)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected_row+1 inSection:1]]).contentView viewWithTag:11]);
    UIImage *CurrentImage = button.currentBackgroundImage;
    
    if(CurrentImage == [UIImage imageNamed:@"follow-profile.png"])
    {
        [profilemanager.ownerDetails followUserAction:selected_row];
        
        /*AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            [button setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//[UIImage imageNamed:@"follow-profile.png"]
         
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[followerSection2Array objectAtIndex:selected_row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSNumber numberWithBool:true] forKey:@"is_following"];
            [newDict setObject:@"false" forKey:@"following_accepted"];
            [followerSection2Array replaceObjectAtIndex:selected_row withObject:newDict];
            newDict = nil;
            oldDict = nil;

            
            
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSError *error;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[followerSection2Array objectAtIndex:selected_row] objectForKey:@"phone_no"],@"followee_phone_no",nil];
            NSLog(@"%@",Dictionary);
            
            request.tag = 13;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
            
            [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request appendPostData:jsonData];
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request setTimeOutSeconds:200];
            [request startAsynchronous];
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [table reloadData];
            [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }*/
    }
    else if(CurrentImage == [UIImage imageNamed:@"follow-profile-slctd.png"])
    {
        [profilemanager.ownerDetails unfollowUserAction:selected_row];
        
        /*
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            [button setBackgroundImage:[UIImage imageNamed:@"follow-profile.png"] forState:UIControlStateNormal];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[followerSection2Array objectAtIndex:selected_row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSNumber numberWithBool:false] forKey:@"is_following"];
            [newDict setObject:@"false" forKey:@"following_accepted"];
            [followerSection2Array replaceObjectAtIndex:selected_row withObject:newDict];
            newDict = nil;
            oldDict = nil;
            
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/unfollowuser"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSError *error;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerSection2Array objectAtIndex:selected_row] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"false", @"following", nil];
            
            NSLog(@"%@",Dictionary);
            
            request.tag = 14;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
            
            [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request appendPostData:jsonData];
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request setTimeOutSeconds:200];
            [request startAsynchronous];
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            //[followerSection2Array removeObjectAtIndex:indexPath.row];
            [table reloadData];
            [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
        */
    }
}


/*
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    
    if(request.tag == 12)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                [followerSection1Array removeAllObjects];
                [followerSection2Array removeAllObjects];
                    NSMutableArray *followerArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"follower"]];
                    
                    for(int i=0;i<followerArray.count;i++)
                    {
                        if([[followerArray objectAtIndex:i] objectForKey:@"accepted"]==[NSNull null] || [[followerArray objectAtIndex:i] objectForKey:@"accepted"]==nil)
                        {
                            if([is_Owner isEqualToString:@"true"])
                                [followerSection1Array addObject:[followerArray objectAtIndex:i]];
                        }
                        else
                            [followerSection2Array addObject:[[followerArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    }
                
                followerArray = nil;
                
                
                [table reloadData];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
        else
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
    }
    else if (request.tag == 13)
    {
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
    }
    else if(request.tag == 14)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
        }
        
    }
    
    
}
*/



#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        if (followerSection1Array.count!=0)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 15, 200, 30))];
            headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
            headertext.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            headertext.backgroundColor = [UIColor clearColor];
            //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
            headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
            headertext.lineBreakMode = YES;
            headertext.numberOfLines = 0;
            headertext.text=@"FOLLOW REQUESTS";
            headertext.lineBreakMode = NSLineBreakByTruncatingTail;
            [headerView addSubview:headertext];
            
            return headerView;
            
        }
        else
            return Nil;

    }
    if(section==1) // only for section 2
    {
        if (followerSection2Array.count!=0)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 15, 200, 30))];
            headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
            headertext.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            headertext.backgroundColor = [UIColor clearColor];
            //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
            headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
            headertext.lineBreakMode = YES;
            headertext.numberOfLines = 0;
            headertext.text=@"FOLLOWERS";
            
            headertext.lineBreakMode = NSLineBreakByTruncatingTail;
            [headerView addSubview:headertext];
            return headerView;
            
        }
        else
            return Nil;
    }
    return Nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        if (followerSection1Array.count!=0)
        {
            return 50;
        }
        else
            return 0;
    }
    if(section==1) // only for section 2
    {
        if (followerSection2Array.count!=0)
        {
            return 50;
        }
        else
            return 0;
    }
    return 0;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(followerSection1Array.count==0)
            return 0;
        else
        {
            if([is_Owner isEqualToString:@"false"])
            {
                return 0;
            }
            else
            {
                if(indexPath.row==0)
                    return 40;
                else
                    return 65;
            }
        }
    }
    if(indexPath.section==1)
    {
        if(followerSection2Array.count==0)
            return 0;
        else
        {
            if(indexPath.row==0)
                return 40;
            else
                return 65;
        }
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
    {
        if(followerSection1Array.count==0)
            return 0;
        else
        {
            if([is_Owner isEqualToString:@"false"])
            {
                return 0;
            }
            else
            {
                return followerSection1Array.count+1;
            }
        }
    }
    if(section==1)
    {
        if(followerSection2Array.count==0)
            return 0;
        else
            return followerSection2Array.count+1;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifiersection1 = @"Cellforsection1";
    static NSString *CellIdentifiersection2 = @"Cellforsection2";
    static NSString *CellIdentifiersection3 = @"Cellforsection3";
    UITableViewCell *cell;
    
    if(indexPath.section==0)  //section 1
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            
            
            //cell bg
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 60)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.tag = 56;
            av.image = [UIImage imageNamed:@"follow_list_bg.png"];
            [cell.contentView addSubview:av];
            
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(70, 20, 125, 20))];
            name.textColor = [UIColor colorWithRed:(50.0/255.0) green:(50.0/255.0) blue:(50.0/255.0) alpha:1.0];
            name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 1;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            
            UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            acceptButton.tag = 11;
            
            [acceptButton addTarget:self action:@selector(AcceptFollower:) forControlEvents:UIControlEventTouchDown];
            [acceptButton setBackgroundImage:[UIImage imageNamed:@"acceptIcon.png"] forState:UIControlStateNormal];
            
            acceptButton.frame = CGRectMake(200.0, 15.0, 32, 32.0);
            if([is_Owner isEqualToString:@"false"])
                acceptButton.hidden = YES;
            
            [cell.contentView addSubview:acceptButton];
            
            
            UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            rejectButton.tag = 12;
            
            [rejectButton addTarget:self action:@selector(RejectFollower:) forControlEvents:UIControlEventTouchDown];
            [rejectButton setBackgroundImage:[UIImage imageNamed:@"rejectIcon.png"] forState:UIControlStateNormal];
            
            rejectButton.frame = CGRectMake(245.0, 15.0, 32.0, 32.0);
            if([is_Owner isEqualToString:@"false"])
                rejectButton.hidden = YES;
            [cell.contentView addSubview:rejectButton];
            
            UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 5, 200, 30))];
            headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
            headertext.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            headertext.backgroundColor = [UIColor clearColor];
            //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
            headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
            headertext.lineBreakMode = YES;
            headertext.tag = 74;
            headertext.numberOfLines = 0;
            headertext.text=@"FOLLOW REQUESTS";
            headertext.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:headertext];

        }
        
        int adjustIndex=0;
        if(indexPath.row>0)
            adjustIndex = indexPath.row-1;
        
        UILabel *headerText=(UILabel*)[cell.contentView viewWithTag:74];
        
        UIImageView *avImgView=(UIImageView*)[cell.contentView viewWithTag:56];
        
        UIImageView *clickinadd=(UIImageView*)[cell.contentView viewWithTag:1];
        clickinadd.hidden=YES;
        UIImageView *clickinadd_icon=(UIImageView*)[cell.contentView viewWithTag:2];
        clickinadd_icon.hidden=YES;
        UILabel *clickinadd_text=(UILabel*)[cell.contentView viewWithTag:3];
        clickinadd_text.hidden=YES;
        
        UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
        profile_pic.hidden=NO;
        UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
        name.hidden=NO;
        //          UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
        //          settingsicon.hidden=NO;
        UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
        line.hidden=NO;
        
        
        //profile pic
        if([[followerSection1Array objectAtIndex:adjustIndex] objectForKey:@"follower_pic"] != [NSNull null])//followee_pic
            [profile_pic setImageWithURL:[NSURL URLWithString:[[followerSection1Array objectAtIndex:adjustIndex] objectForKey:@"follower_pic"]]];
        //name text
        if([[followerSection1Array objectAtIndex:adjustIndex] objectForKey:@"follower_name"] != [NSNull null])//followee_name
            name.text=[[[followerSection1Array objectAtIndex:adjustIndex] objectForKey:@"follower_name"] capitalizedString];
        
        UIButton *acceptBtn=(UIButton*)[cell.contentView viewWithTag:11];
        UIButton *rejectBtn=(UIButton*)[cell.contentView viewWithTag:12];
        if(indexPath.row==0)
        {
            headerText.hidden=NO;
            avImgView.hidden = YES;
            profile_pic.hidden=YES;
            name.hidden=YES;
            line.hidden=YES;
            acceptBtn.hidden=YES;
            rejectBtn.hidden=YES;
        }
        else
        {
            headerText.hidden=YES;
            avImgView.hidden = NO;
            profile_pic.hidden=NO;
            name.hidden=NO;
            line.hidden=NO;
            acceptBtn.hidden=NO;
            rejectBtn.hidden=NO;
        }
    }
    if(indexPath.section==1)  //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            
            //cell bg
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 60)];
            av.backgroundColor = [UIColor clearColor];
            av.tag=56;
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"follow_list_bg.png"];
            [cell.contentView addSubview:av];
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(70,15, 128, 30))];
            name.textColor = [UIColor colorWithRed:(50.0/255.0) green:(50.0/255.0) blue:(50.0/255.0) alpha:1.0];
            name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 1;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            
            UIButton *FollowingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            FollowingButton.tag = 11;
            
            [FollowingButton addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
            
            
            FollowingButton.frame = CGRectMake(205.0, 20.0, 79.0, 21.0);
            [cell.contentView addSubview:FollowingButton];
            
            UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 5, 200, 30))];
            headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
            headertext.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            headertext.backgroundColor = [UIColor clearColor];
            //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
            headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
            headertext.lineBreakMode = YES;
            headertext.tag = 75;
            headertext.numberOfLines = 0;
            
            headertext.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:headertext];
        }
        
        
        
        int adjustIndex=0;
        if(indexPath.row>0)
            adjustIndex = indexPath.row-1;
        
        UIImageView *clickinadd=(UIImageView*)[cell.contentView viewWithTag:1];
        clickinadd.hidden=YES;
        UIImageView *clickinadd_icon=(UIImageView*)[cell.contentView viewWithTag:2];
        clickinadd_icon.hidden=YES;
        UILabel *clickinadd_text=(UILabel*)[cell.contentView viewWithTag:3];
        clickinadd_text.hidden=YES;
        
        UIImageView *avImgView=(UIImageView*)[cell.contentView viewWithTag:56];
        
        UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
        profile_pic.hidden=NO;
        UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
        name.hidden=NO;
        //          UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
        //          settingsicon.hidden=NO;
        UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
        line.hidden=NO;
        
        UIButton *FollowBtn=(UIButton*)[cell.contentView viewWithTag:11];
        
        
        if([[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"is_following"] integerValue]==1 && [[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"following_accepted"] boolValue] == false)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//follow requested image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
            
        }
        else if([[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"following_accepted"] boolValue] == true)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile-slctd.png"] forState:UIControlStateNormal];//following image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }
        else if([[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"is_following"] integerValue]==1)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//follow requested image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }
        else
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile.png"] forState:UIControlStateNormal];//follow image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }
        
        if([[NSString stringWithFormat:@"%@",[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"phone_no"]] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]])
        {
            FollowBtn.hidden = YES;
        }
        else
            FollowBtn.hidden = NO;
        
            //profile pic
            if([[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"follower_pic"] != [NSNull null])//followee_pic
                [profile_pic setImageWithURL:[NSURL URLWithString:[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"follower_pic"]]];
            //name text
            if([[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"follower_name"] != [NSNull null])//followee_name
                name.text=[[[followerSection2Array objectAtIndex:adjustIndex] objectForKey:@"follower_name"] capitalizedString];
        
        UILabel *headerText=(UILabel*)[cell.contentView viewWithTag:75];
        if(indexPath.row==0)
        {
            headerText.text=@"FOLLOWERS";
            headerText.hidden=NO;
            avImgView.hidden = YES;
            profile_pic.hidden=YES;
            name.hidden=YES;
            line.hidden=YES;
            FollowBtn.hidden=YES;
        }
        else
        {
            headerText.text=@"";
            headerText.hidden=YES;
            avImgView.hidden = NO;
            profile_pic.hidden=NO;
            name.hidden=NO;
            line.hidden=NO;
            FollowBtn.hidden=NO;
        }
        
        if([is_Owner isEqualToString:@"false"])
            FollowBtn.hidden = YES;

    }
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        
        if(indexPath.row != 0)
        {
            if(![[[followerSection1Array objectAtIndex:indexPath.row-1] objectForKey:@"phone_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]]) // if user is not created
            {
                profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
                /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                 profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
                 profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
                
                RelationInfo *relationObj = [[RelationInfo alloc] init];
                relationObj.partnerPhoneNumber = [[followerSection1Array objectAtIndex:indexPath.row-1] objectForKey:@"phone_no"];
                relationObj.partnerName = [[followerSection1Array objectAtIndex:indexPath.row-1] objectForKey:@"follower_name"];
                profile_other.relationObject = relationObj;
                relationObj = nil;
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                //[controllers addObject:profile_other];
                navigationController.viewControllers = controllers;
                [navigationController pushViewController:profile_other animated:YES];
            }
        }

    }
    if(indexPath.section==1)
    {
        if(indexPath.row != 0)
        {
            if(![[[followerSection2Array objectAtIndex:indexPath.row-1] objectForKey:@"phone_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]]) // if user is not created
            {
                profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
                /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                 profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
                 profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
                
                RelationInfo *relationObj = [[RelationInfo alloc] init];
                relationObj.partnerPhoneNumber = [[followerSection2Array objectAtIndex:indexPath.row-1] objectForKey:@"phone_no"];
                relationObj.partnerName = [[followerSection2Array objectAtIndex:indexPath.row-1] objectForKey:@"follower_name"];
                profile_other.relationObject = relationObj;
                relationObj = nil;
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                //[controllers addObject:profile_other];
                navigationController.viewControllers = controllers;
                [navigationController pushViewController:profile_other animated:YES];
            }
        }
    }
    
    if(indexPath.section == 2)
    {
        
        if (indexPath.row==1)
        {
            SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:sendinvite];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
