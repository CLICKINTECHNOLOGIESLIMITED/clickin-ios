//
//  LeftViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "following_owner.h"
#import "profile_owner.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "CenterViewController.h"
#import "NewsfeedViewController.h"
#import "AppDelegate.h"


@interface following_owner ()

@end

@implementation following_owner

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
    followingArray = [[NSMutableArray alloc] init];
    
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
    UIImageView *header_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 53)];
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
        header_text.text=@"FOLLOWING";
    
    
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

    
    headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(10, 54, 200, 30))];
    headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
    headertext.textAlignment = NSTextAlignmentLeft;
    headertext.backgroundColor = [UIColor clearColor];
    headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
    headertext.lineBreakMode = YES;
    headertext.numberOfLines = 0;
    headertext.text=@"FOLLOWING";
    headertext.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:headertext];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(10, 90, 300, 480-64-26) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(10,90, 300, 568-64-26);
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
    
    //    followerArray=[[NSMutableArray alloc] init];
    
    //[self getfollowerslist];
    
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
    [followingArray removeAllObjects];
    if([is_Owner isEqualToString:@"false"])
    {
        [followingArray addObjectsFromArray:otherUser.followingArray];
    }
    else
        [followingArray addObjectsFromArray:profilemanager.ownerDetails.followingArray];
    
    
    if(followingArray.count == 0 && ![is_Owner isEqualToString:@"false"])
    {
        headertext.text = @"";
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(41,100, 476/2, 204/2)];
        imgView.image = [UIImage imageNamed:@"20Text.png"];
        [self.view addSubview:imgView];
    }
    
    
    [table reloadData];
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
    //NSLog(@"%@",Dictionary);
    
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
    [request startAsynchronous];
    NSLog(@"%@",request);*/
}

-(void)alertForUnfollowButton:(id)sender
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
    selected_row = indexPath.row;
    
    UIImage *CurrentImage = button.currentBackgroundImage;
    
    if([CurrentImage isEqual:[UIImage imageNamed:@"requested.png"] ])
        btn_state = 1;
    else if([CurrentImage isEqual:[UIImage imageNamed:@"follow-profile-slctd.png"]])
        btn_state = 2;
    else
        btn_state = 3;
    
    if(btn_state == 1 || btn_state == 2)
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
    else
    {
        //hit unfollow user webservice
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            [button setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//[UIImage imageNamed:@"follow-profile.png"]
            
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[followingArray objectAtIndex:selected_row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSNull null] forKey:@"accepted"];
            [followingArray replaceObjectAtIndex:selected_row withObject:newDict];
            newDict = nil;
            oldDict = nil;
            
            
            
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSError *error;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[followingArray objectAtIndex:selected_row] objectForKey:@"phone_no"],@"followee_phone_no",nil];
            NSLog(@"%@",Dictionary);
            
            
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
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                            description:alertNetRechMessage
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
        }

    }
}


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==44)
    {
        if(buttonType==0)
        {
            [[Mixpanel sharedInstance] track:@"LeftMenuFindFriendsButtonClicked" properties:@{@"Activity":@"UnfollowUser"}];
           // [[Mixpanel sharedInstance] track:@"UnfollowUser"];
            [self FollowingButtonAction];
        }
    }
}


/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==44)  // unfollow button service
    {
        if(buttonIndex==0)
        {
            [self FollowingButtonAction];
        }
    }
}
 */


-(void)FollowingButtonAction
{
    /*UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    NSLog(@"%d",indexPath.row);*/
    
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/unfollowuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followingArray objectAtIndex:selected_row] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"true", @"following", nil];
        
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
        
        //[followingArray removeObjectAtIndex:selected_row];
        /*for(int i=selected_row;i<followingArray.count-1;i++)
        {
            [followingArray replaceObjectAtIndex:i withObject:[followingArray objectAtIndex:i+1]];
        }
        [followingArray removeLastObject];*/
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[followingArray objectAtIndex:selected_row];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:@"false" forKey:@"accepted"];
        [followingArray replaceObjectAtIndex:selected_row withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
        
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [table reloadData];
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
        [alertView showForPresentView];
        alertView = nil;
    }
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    /*if(request.tag == 12)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                //followingArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"following"]];
                [followingArray removeAllObjects];
                
                NSMutableArray *followerArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"following"]];
                
                for(int i=0;i<followerArray.count;i++)
                {
                    //[followingArray addObject:[[followerArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    [followingArray addObject:[followerArray objectAtIndex:i]];
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
    else*/ if (request.tag == 13)
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
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:errorl.description
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
                
            }
        }
        else
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
            
        }

    }
}
#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/*

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1) // only for section 2
    {
        if (followingArray.count!=0)
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
            headertext.text=@"FOLLOWING";
            
            
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
    if(section==1) // only for section 2
    {
        if (followingArray.count!=0)
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
        return 0;
    if(indexPath.section==1)
    {
        if(followingArray.count==0)
            return 0;
        else
            return 65;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0)
        return 1;
    if(section==1)
    {
        if(followingArray.count==0)
            return 0;
        else
            return followingArray.count;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifiersection1 = @"Cellforsection1";
    static NSString *CellIdentifiersection2 = @"Cellforsection2";
    static NSString *CellIdentifiersection3 = @"Cellforsection3";
    UITableViewCell *cell;
    
    if(indexPath.section==0)  //section 1
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection2];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
        }
    }
    if(indexPath.section==1)  //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection3];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            //cell bg
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 60)];
            av.backgroundColor = [UIColor clearColor];
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
            // name.alpha=0.4;
            
            //            UIImageView *settingsicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingicon_dark.png"]];
            //            settingsicon.center=CGPointMake(250, 35);
            //            settingsicon.tag=6;
            //            [cell.contentView addSubview:settingsicon];
            
            //            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48, 320-70, 2)];
            //            line.image=[UIImage imageNamed:@"clickin_line.png"];
            //            line.alpha=0.5;
            //            line.tag=7;
            //            [cell.contentView addSubview:line];
            
            UIButton *FollowingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            FollowingButton.tag = 11;
            [FollowingButton addTarget:self action:@selector(alertForUnfollowButton:) forControlEvents:UIControlEventTouchDown];
            
            FollowingButton.frame = CGRectMake(205.0, 20.0, 79.0, 21.0);
            [cell.contentView addSubview:FollowingButton];
        }
        
        
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
        
        UIButton *FollowBtn=(UIButton*)[cell.contentView viewWithTag:11];
        
        if([[followingArray objectAtIndex:indexPath.row] objectForKey:@"accepted"] == [NSNull null] || [[followingArray objectAtIndex:indexPath.row] objectForKey:@"accepted"]==nil)
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//follow-requested image
        
        else if([[[followingArray objectAtIndex:indexPath.row] objectForKey:@"accepted"] boolValue]==false)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile.png"] forState:UIControlStateNormal];
        }
    
        else if((bool)[[followingArray objectAtIndex:indexPath.row] objectForKey:@"accepted"]==true)
           [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile-slctd.png"] forState:UIControlStateNormal];//follow-profile-slctd.png
        

            
        
            //profile pic
            if([[followingArray objectAtIndex:indexPath.row] objectForKey:@"followee_pic"] != [NSNull null])//followee_pic
                [profile_pic sd_setImageWithURL:[NSURL URLWithString:[[followingArray objectAtIndex:indexPath.row] objectForKey:@"followee_pic"]]];
            //name text
            if([[followingArray objectAtIndex:indexPath.row] objectForKey:@"followee_name"] != [NSNull null])//followee_name
                name.text=[[[followingArray objectAtIndex:indexPath.row] objectForKey:@"followee_name"] capitalizedString];
        
        if([is_Owner isEqualToString:@"false"])
            FollowBtn.hidden = YES;
        
    }
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0)
    {
        
    }
    if(indexPath.section==1)
    {
        
            if(![[[followingArray objectAtIndex:indexPath.row] objectForKey:@"phone_no"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]]) // if user is not created
            {
                profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
                /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                 profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
                 profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
                
                RelationInfo *relationObj = [[RelationInfo alloc] init];
                relationObj.partnerPhoneNumber = [[followingArray objectAtIndex:indexPath.row] objectForKey:@"phone_no"];
                relationObj.partnerName = [[followingArray objectAtIndex:indexPath.row] objectForKey:@"followee_name"];
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
