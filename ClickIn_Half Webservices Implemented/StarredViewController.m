//
//  StarredViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 25/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "StarredViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"

@interface StarredViewController ()

@end

@implementation StarredViewController

@synthesize newsfeedID,selectedNewsfeed,LblStars;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    usersArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(NotificationReceived:)
     name:Notification_NewsfeedStarredUsersUpdated
     object:nil];
    
    //screen bg
    UIImageView *screen_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (IS_IPHONE_5) {
        screen_bg.frame=CGRectMake(0, 0, 320, 568);
    }
    screen_bg.image=[UIImage imageNamed:@"background1140.png"];
    [self.view addSubview:screen_bg];
    
    [self.view sendSubviewToBack:screen_bg];
    
    LblStars.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    /*
    //top header text above tableview
    UILabel *headertext = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 55, 320, 30))];
    headertext.textColor = [UIColor colorWithRed:(178.0/255.0) green:(178.0/255.0) blue:(178.0/255.0) alpha:1.0];
    headertext.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    headertext.backgroundColor = [UIColor clearColor];
    //headertext.font = [UIFont fontWithName:@"Halvetica" size:10];
    headertext.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
    headertext.lineBreakMode = YES;
    headertext.numberOfLines = 0;
    headertext.text=@"PEOPLE WHO STARRED THIS";
    [self.view addSubview:headertext];
    
    
    headertext.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    // notifications text
    notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
    notification_text.textColor = [UIColor whiteColor];
    notification_text.center=CGPointMake(298, 21);
    notification_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    notification_text.tag = 5;
    notification_text.backgroundColor = [UIColor clearColor];
    // header_text = [UIFont fontWithName:@"Halvetica" size:10];
    notification_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
    notification_text.lineBreakMode = YES;
    notification_text.numberOfLines = 0;
    notification_text.lineBreakMode = NSLineBreakByTruncatingTail;
    notification_text.text=@"0";
    [self.view addSubview:notification_text];
    
    //notification btn
    notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationsBtn addTarget:self
                         action:@selector(notificationBtnPressed)
               forControlEvents:UIControlEventTouchDown];
    notificationsBtn.backgroundColor = [UIColor clearColor];
    notificationsBtn.frame =CGRectMake(320-70, 0, 70, 45);
    [self.view addSubview:notificationsBtn];*/
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(10, 58, 300, 480-58) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(10,58, 300, 568-58);
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
    
    
    //activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    //[activity show];
    
    //[self performSelector:@selector(fetchStarredUsersWebService) withObject:nil afterDelay:0.1];

}
#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    //[self getprofileinfo];
    if(activity==nil)
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    //[self performSelector:@selector(fetchStarredUsersWebService) withObject:nil afterDelay:0.1];
    [selectedNewsfeed getStarredUsers:YES];
    
}

#pragma mark Notifications received
- (void)NotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    usersArray = selectedNewsfeed.starredArray;
    [table reloadData];
    
    [activity hide];
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if (request.tag == 15)
    {
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
    }
    else if(request.tag == 16)
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
            //notification_text.text=[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]];
            
        }
        else
        {
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:errorl.description
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
    return 1;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        if (usersArray.count!=0)
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
            headertext.text=@"PEOPLE WHO STARRED THIS";
            
            
            headertext.lineBreakMode = NSLineBreakByTruncatingTail;
            [headerView addSubview:headertext];
            return headerView;
        }
        else
            return Nil;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        if (usersArray.count!=0)
        {
            return 50;
        }
        else
            return 0;
    
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(usersArray.count==0)
            return 0;
        else
            return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if(usersArray.count==0)
            return 0;
        else
            return usersArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifiersection1 = @"Cellforsection1";
    static NSString *CellIdentifiersection = @"Cellforsection";
    
    UITableViewCell *cell;
    
    if(indexPath.section==0)  //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            //cell bg
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 55)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"follow_list_bg.png"];
            [cell.contentView addSubview:av];
            
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60, 17.5f, 140, 20))];
            name.textColor = [UIColor colorWithRed:(83.0/255.0) green:(83.0/255.0) blue:(83.0/255.0) alpha:1.0];
            name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            
            UIButton *FollowingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            FollowingButton.tag = 11;
            [FollowingButton addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
            
            FollowingButton.frame = CGRectMake(205.0, 17.5f, 79.0, 21.0);
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
        UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
        line.hidden=NO;
        
        UIButton *FollowBtn=(UIButton*)[cell.contentView viewWithTag:11];
        
        
        if([[[usersArray objectAtIndex:indexPath.row] objectForKey:@"is_user_following"] integerValue]==1 && [[[usersArray objectAtIndex:indexPath.row] objectForKey:@"is_user_following_acceptance"] boolValue] == false)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//follow requested image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
            
        }
        else if([[[usersArray objectAtIndex:indexPath.row] objectForKey:@"is_user_following_acceptance"] boolValue] == true)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile-slctd.png"] forState:UIControlStateNormal];//following image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }
        else if([[[usersArray objectAtIndex:indexPath.row] objectForKey:@"is_user_following"] integerValue]==1)
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//follow requested image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }
        else
        {
            [FollowBtn setBackgroundImage:[UIImage imageNamed:@"follow-profile.png"] forState:UIControlStateNormal];//follow image
            [FollowBtn addTarget:self action:@selector(alertForFollowButton:) forControlEvents:UIControlEventTouchDown];
        }

        if([[[usersArray objectAtIndex:indexPath.row] objectForKey:@"user_follow_phone_no"] length]==0)
            FollowBtn.hidden = YES;
        else
            FollowBtn.hidden = NO;
            
        
        
        
        //profile pic
        if([[usersArray objectAtIndex:indexPath.row] objectForKey:@"user_pic"] != [NSNull null])//followee_pic
            [profile_pic setImageWithURL:[NSURL URLWithString:[[usersArray objectAtIndex:indexPath.row] objectForKey:@"user_pic"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        //name text
        if([[usersArray objectAtIndex:indexPath.row] objectForKey:@"user_name"] != [NSNull null])//followee_name
            name.text=[[[usersArray objectAtIndex:indexPath.row] objectForKey:@"user_name"] capitalizedString];
        
    }
    
    return cell;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}


-(void)alertForFollowButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
          cell = (UITableViewCell *)[[[button superview] superview] superview];
    }
  else
  {
       cell = (UITableViewCell *)[[button superview] superview] ;
  }
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    selected_row = indexPath.row;
    
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
                                                                      okButtonTitle:@"Cancel"
                                                                  cancelButtonTitle:@"Ok"];
        
        alertView.delegate = self;
        
        alertView.tag = 44;
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


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag==44)  // unfollow button service
//    {
//        if(buttonIndex==0)
//        {
//            [self FollowButtonAction];
//        }
//    }
//}





-(void)FollowButtonAction
{
    //UIButton *button = (UIButton *)sender;
    //UIImage *CurrentImage = button.currentBackgroundImage;
    UIButton *button = ((UIButton*)[((UITableViewCell*)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected_row inSection:0]]).contentView viewWithTag:11]);
    UIImage *CurrentImage = button.currentBackgroundImage;
    
    if(CurrentImage == [UIImage imageNamed:@"follow-profile.png"])
    {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            [button setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];//[UIImage imageNamed:@"follow-profile.png"]
            /*UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
             NSIndexPath *indexPath = [table indexPathForCell:cell];
             NSLog(@"%d",indexPath.row);*/
            
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[usersArray objectAtIndex:selected_row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSNumber numberWithBool:true] forKey:@"is_user_following"];
            [newDict setObject:@"false" forKey:@"is_user_following_acceptance"];
            [usersArray replaceObjectAtIndex:selected_row withObject:newDict];
            newDict = nil;
            oldDict = nil;
            
            
            
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSError *error;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[usersArray objectAtIndex:selected_row] objectForKey:@"user_follow_phone_no"],@"followee_phone_no",nil];
            NSLog(@"%@",Dictionary);
            
            request.tag = 15;
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
    else if(CurrentImage == [UIImage imageNamed:@"follow-profile-slctd.png"])
    {
        
        
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            [button setBackgroundImage:[UIImage imageNamed:@"follow-profile.png"] forState:UIControlStateNormal];
            /*UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
             NSIndexPath *indexPath = [table indexPathForCell:cell];
             NSLog(@"%d",indexPath.row);*/
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[usersArray objectAtIndex:selected_row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSNumber numberWithBool:false] forKey:@"is_user_following"];
            [newDict setObject:@"false" forKey:@"is_user_following_acceptance"];
            [usersArray replaceObjectAtIndex:selected_row withObject:newDict];
            newDict = nil;
            oldDict = nil;
            
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/unfollowuser"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSError *error;
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[usersArray objectAtIndex:selected_row] objectForKey:@"user_follow_id"] objectForKey:@"$id"],@"follow_id", @"false", @"following", nil];
            
            NSLog(@"%@",Dictionary);
            
            request.tag = 16;
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
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                            description:alertNetRechMessage
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
        }
        
    }
}





- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
