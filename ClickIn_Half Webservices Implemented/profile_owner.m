//
//  profile_owner.m
//  ClickIn
//
//  Created by Leo Macbook on 21/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "profile_owner.h"
#import "AppDelegate.h"
#import "RelationInfo.h"
#import "SearchContactsViewController.h"
#import "EditProfileViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"


@interface profile_owner ()

@end

@implementation profile_owner

@synthesize isFromNotification;

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
    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
    //[self getuserrelations]; // get relations
    //[self getprofileinfo];  // get owner info
    [profilemanager.ownerDetails getProfileInfo:YES];
    if(profileLoadedFirstTime || isFromNotification)
    {
        [profilemanager getRelations:YES];
        profileLoadedFirstTime = false;
        isFromNotification = false;
    }
    NSLog(@"user pic %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]);
//    // update pic
    [owner_profilepic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]] placeholderImage:owner_profilepic.image options:SDWebImageRefreshCached | SDWebImageRetryFailed];
}

-(void)imageUpdated:(NSData*)imageData
{
    
    UIImage *image=[UIImage imageWithData:imageData];
    
    [owner_profilepic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]] placeholderImage:image options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    profileLoadedFirstTime = true;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RelationsNotificationReceived:)
     name:Notification_RelationsUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RelationVisibiltyChanged:)
     name:Notification_RelationVisibilityUpdated
     object:nil];

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hitProfileInfoService:)
     name:Notification_UpdateProfile
     object:nil];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(hitGetRelationsService:)
     name:Notification_updateOwnerRelations
     object:nil];
    
    
    
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@ >>>>>>>>>>>>>>>> %@",[prefs stringForKey:@"user_id"],[prefs stringForKey:@"user_token"]);
    //[QBUsers logInWithUserLogin:[prefs stringForKey:@"QBUserName"] password:[prefs stringForKey:@"QBPassword"] delegate:self];
    
    //screen bg
    UIImageView *screen_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (IS_IPHONE_5) {
        screen_bg.frame=CGRectMake(0, 0, 320, 568);
    }
    screen_bg.image=[UIImage imageNamed:@"background1140.png"];
    [self.view addSubview:screen_bg];
    
    // header bg
    UIImageView *header_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.5, 53.5)];
    header_bg.image=[UIImage imageNamed:@"profile_head.png"];
    [self.view addSubview:header_bg];
    
    // header text
    UILabel *header_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 150, 20))];
    header_text.textColor = [UIColor whiteColor];
    header_text.center=CGPointMake(160, 22);
    header_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
    header_text.tag = 5;
    header_text.backgroundColor = [UIColor clearColor];
    // header_text = [UIFont fontWithName:@"Halvetica" size:10];
    header_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    header_text.lineBreakMode = YES;
    header_text.numberOfLines = 1;
    header_text.lineBreakMode = NSLineBreakByTruncatingTail;
    header_text.text=@"PROFILE";
    [self.view addSubview:header_text];
    
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
    
    // profile info bg
    UIImageView *profile_info_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 165, 238)];
    profile_info_bg.image=[UIImage imageNamed:@"profile_info_bg.png"];
    [self.view addSubview:profile_info_bg];
    
    //left menu button
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton addTarget:self
                   action:@selector(leftbuttonpressed)
         forControlEvents:UIControlEventTouchDown];
    //[leftbutton setTitle:@"Show View" forState:UIControlStateNormal];
    leftbutton.frame = CGRectMake(0, 0, 44, 44);
    [self.view addSubview:leftbutton];
    
    // user name
    Name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(10, 65, 150, 40))];
    Name.textColor = [UIColor colorWithRed:(245.0/255.0) green:(143.0/255.0) blue:(144.0/255.0) alpha:1.0];
    Name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
    Name.tag = 5;
    Name.backgroundColor = [UIColor clearColor];
    // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
    Name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
    Name.lineBreakMode = YES;
    Name.numberOfLines = 0;
    Name.lineBreakMode = NSLineBreakByTruncatingTail;
    Name.text=[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString];
    [self.view addSubview:Name];
    
    //profile pic
    owner_profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 140, 140)];
    [self.view addSubview:owner_profilepic];
    //[owner_profilepic setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]];
    
    // profile edit icon button
    //    UIImageView *profile_edit_icon=[[UIImageView alloc] initWithFrame:CGRectMake(135, 225, 37, 37)];
    //    profile_edit_icon.image=[UIImage imageNamed:@"profile_edit_icon.png"];
    //    [self.view addSubview:profile_edit_icon];
    
    UIButton *profile_editbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profile_editbutton addTarget:self
                           action:@selector(editbuttonpressed)
                 forControlEvents:UIControlEventTouchDown];
    [profile_editbutton setImage:[UIImage imageNamed:@"profile_edit_icon.png"] forState:UIControlStateNormal];
    profile_editbutton.frame =CGRectMake(130, 220, 40, 40);
    [self.view addSubview:profile_editbutton];
    
    // user info line 1
    userinfo1 = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 245, 150, 20))];
    userinfo1.textColor = [UIColor colorWithRed:(120.0/255.0) green:(120.0/255.0) blue:(120.0/255.0) alpha:1.0];
    userinfo1.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
    userinfo1.tag = 5;
    userinfo1.backgroundColor = [UIColor clearColor];
    // userinfo1 = [UIFont fontWithName:@"Halvetica" size:10];
    userinfo1.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:13.0];
    userinfo1.lineBreakMode = YES;
    userinfo1.numberOfLines = 1;
    userinfo1.lineBreakMode = NSLineBreakByTruncatingTail;
    //userinfo1.text=@"Male,28 years old";
    [self.view addSubview:userinfo1];
    
    // set City And Country
    lblCityAndCountry = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 265, 150, 20))];
    lblCityAndCountry.textColor = [UIColor colorWithRed:(120.0/255.0) green:(120.0/255.0) blue:(120.0/255.0) alpha:1.0];
    lblCityAndCountry.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
//    lblCityAndCountry.tag = 5;
    lblCityAndCountry.backgroundColor = [UIColor clearColor];
    lblCityAndCountry.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:13.0];
    lblCityAndCountry.lineBreakMode = YES;
    lblCityAndCountry.numberOfLines = 1;
    lblCityAndCountry.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:lblCityAndCountry];
    
    // followers text bg
    UIImageView *followers_bg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 320, 155, 44)];
    followers_bg.image=[UIImage imageNamed:@"followers_text.png"];
    [self.view addSubview:followers_bg];
    followers_bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *followergesture = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(followersPressed)];
    followergesture.delegate = self;
    [followers_bg addGestureRecognizer:followergesture];
    
    // followers count text
    followers_count_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 332, 50, 20))];
    followers_count_text.textColor = [UIColor colorWithRed:(170.0/255.0) green:(170.0/255.0) blue:(170.0/255.0) alpha:1.0];
    followers_count_text.textAlignment = NSTextAlignmentRight;  //(for iOS 6.0)
    followers_count_text.tag = 5;
    followers_count_text.backgroundColor = [UIColor clearColor];
    followers_count_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
    followers_count_text.lineBreakMode = YES;
    followers_count_text.numberOfLines = 0;
    followers_count_text.lineBreakMode = NSLineBreakByTruncatingTail;
    followers_count_text.text=@"0";
    [self.view addSubview:followers_count_text];
    followers_count_text.userInteractionEnabled = YES;
    UITapGestureRecognizer *followergesturecount = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(followersPressed)];
    followergesturecount.delegate = self;
    [followers_bg addGestureRecognizer:followergesturecount];
    
    // following text bg
    UIImageView *following_bg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 383, 155, 44)];
    following_bg.image=[UIImage imageNamed:@"following_text.png"];
    [self.view addSubview:following_bg];
    following_bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *followinggesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(followingPressed)];
    followinggesture.delegate = self;
    [following_bg addGestureRecognizer:followinggesture];
    
    // following count text
    following_count_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(120, 395, 50, 20))];
    following_count_text.textColor = [UIColor colorWithRed:(170.0/255.0) green:(170.0/255.0) blue:(170.0/255.0) alpha:1.0];
    following_count_text.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
    following_count_text.tag = 5;
    following_count_text.backgroundColor = [UIColor clearColor];
    // following_count_text = [UIFont fontWithName:@"Halvetica" size:10];
    following_count_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
    following_count_text.lineBreakMode = YES;
    following_count_text.numberOfLines = 0;
    following_count_text.lineBreakMode = NSLineBreakByTruncatingTail;
    following_count_text.text=@"0";
    [self.view addSubview:following_count_text];
    following_count_text.userInteractionEnabled = YES;
    UITapGestureRecognizer *followinggesturecount = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(followingPressed)];
    followinggesturecount.delegate = self;
    [following_count_text addGestureRecognizer:followinggesturecount];
    
    
    
    //notification btn
    notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationsBtn addTarget:self
                     action:@selector(notificationBtnPressed)
           forControlEvents:UIControlEventTouchDown];
    notificationsBtn.backgroundColor = [UIColor clearColor];
    notificationsBtn.frame =CGRectMake(320-70, 0, 70, 45);
    [self.view addSubview:notificationsBtn];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(165,64, 165, 480-64) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(165,64, 165, 568-64);
    table.backgroundColor = [UIColor clearColor];
    //table_feeds.allowsSelection=NO;
    //table.userInteractionEnabled=YES;
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:table];
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //[table setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 60)];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    table.layer.cornerRadius = 10;
    //table.bounces=NO;
    relationArray=[[NSMutableArray alloc] init];
    nonAcceptedUsersArray=[[NSMutableArray alloc] init];
    //get relations service
    //[self getuserrelations];
    
    
}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    notification_text.text = @"0";
    
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    
}


#pragma mark Notifications received
- (void)ProfileInfoNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    Name.text = [profilemanager.ownerDetails.name capitalizedString];
    
    NSLog(@"profilemanager.ownerDetails.profilePicUrl %@",profilemanager.ownerDetails.profilePicUrl);
    //set the profile pic

//    [owner_profilepic sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    
    //set age and gender
    
    
//    userinfo1.text=[NSString stringWithFormat:@"%@, %@",profilemanager.ownerDetails.gender,profilemanager.ownerDetails.age];
    
    if(profilemanager.ownerDetails.gender.length == 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@",profilemanager.ownerDetails.age];
    }
    
    if(profilemanager.ownerDetails.age.length == 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@",profilemanager.ownerDetails.gender];
    }
    
    if (profilemanager.ownerDetails.age.length == 0  && profilemanager.ownerDetails.gender.length == 0)
    {
        userinfo1.text=@"";
    }
    
    if (profilemanager.ownerDetails.age.length != 0  && profilemanager.ownerDetails.gender.length != 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@, %@",profilemanager.ownerDetails.gender,profilemanager.ownerDetails.age];
    }
    
    
    
    if(profilemanager.ownerDetails.city.length == 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@",profilemanager.ownerDetails.country];
    }
    
    if(profilemanager.ownerDetails.country.length == 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@",profilemanager.ownerDetails.city];
    }
    
    if (profilemanager.ownerDetails.country.length == 0  && profilemanager.ownerDetails.city.length == 0)
    {
        lblCityAndCountry.text = @"";
    }
    
    if (profilemanager.ownerDetails.country.length != 0  && profilemanager.ownerDetails.city.length != 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@,%@",profilemanager.ownerDetails.city,profilemanager.ownerDetails.country];
    }
    
    //notification count set
    notification_text.text=profilemanager.ownerDetails.notificationCount;
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
    
    //followers count
    followers_count_text.text=profilemanager.ownerDetails.followerCount;
    //following count
    following_count_text.text=profilemanager.ownerDetails.followingCount;
}

- (void)RelationsNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [activity hide];
    [relationArray removeAllObjects];
    [nonAcceptedUsersArray removeAllObjects];
    [relationArray addObjectsFromArray:profilemanager.relationshipArray];
    [nonAcceptedUsersArray addObjectsFromArray:profilemanager.nonAcceptedRelationArray];
    [table reloadData];
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:3];
}
-(void)reloadTableView
{
    [table reloadData];
}
- (void)RelationVisibiltyChanged:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [table reloadData];
}


- (void)hitProfileInfoService:(NSNotification *)notification //use notification method and logic
{
    [profilemanager.ownerDetails getProfileInfo:YES];
}


- (void)hitGetRelationsService:(NSNotification *)notification //use notification method and logic
{
    [profilemanager getRelations:YES];
}


-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}

-(void)followersPressed
{
    NSLog(@"followers pressed");
    //[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString]
    //if(![followers_count_text.text isEqualToString:@"0"])
    {
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
        
//        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//        while (controllers.count>1) {
//            [controllers removeLastObject];
//        }
//        navigationController.viewControllers = controllers;
        [navigationController pushViewController:followerowner animated:YES];
    }
}

-(void)followingPressed
{
    NSLog(@"following pressed");
   // if(![following_count_text.text isEqualToString:@"0"])
    {
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
        navigationController.viewControllers = controllers;

        [navigationController pushViewController:followingowner animated:YES];
    }
}
-(void)leftbuttonpressed
{
//    [[NSNotificationCenter defaultCenter]
//     postNotificationName:@"resignKeyboardLeftMenu"
//     object:nil];
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(void)editbuttonpressed
{
    EditProfileViewController *editProfile = [[EditProfileViewController alloc] initWithNibName:nil bundle:nil];
    editProfile.delegate_imageupdated=self;
    [self.navigationController pushViewController:editProfile animated:YES];
    editProfile = nil;
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
    [request setDidFinishSelector:@selector(requestFinished_info:)];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}
-(void)getuserrelations
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/getrelationships"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request appendPostData:jsonData];
    request.tag = 15;
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
    
}
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
            // NSArray *userinfoarray=[jsonResponse objectForKey:@"user"];
            NSDictionary *userinfo=[jsonResponse objectForKey:@"user"];
            NSString *gender=[userinfo objectForKey:@"gender"];
            
            if([userinfo objectForKey:@"user_pic"]!= [NSNull null])
                [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"user_pic"] forKey:@"user_pic"];
            NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]);
            [owner_profilepic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]]; //set the profile pic
            
            
            if([gender isEqualToString:@"guy"])
            {
                gender=@"Male";
            }
            else if([gender isEqualToString:@"girl"])
            {
                gender=@"Female";
            }
            else
            {
                gender=@"";
            }
            NSString *datetext=[userinfo objectForKey:@"dob"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMM dd yyyy"];
            NSDate *dobDate = [df dateFromString: datetext];
            NSTimeInterval secondsBetween = [dobDate timeIntervalSinceNow];
            
            int minutes = floor(secondsBetween/60) * -1;
            int hours=floor(minutes/60);
            int days=floor(hours/24);
            int years=floor(days/365);
            
            datetext=[NSString stringWithFormat:@"%d years old",years];
            
            //set age and gender
            userinfo1.text=[NSString stringWithFormat:@"%@, %@",gender,datetext];
            
            //notification count set
            notification_text.text=[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]];
            
            if([notification_text.text isEqualToString:@"0"])
                notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
            else
                notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
            
            //followers count
            followers_count_text.text=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"follower"]];
            //following count
            following_count_text.text=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"following"]];
            
        }
        //        else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
        //        {
        //
        //        }
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
    else
    {
        //NSError *errorl = nil;
        //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
        //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
    }
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if(request.tag==44)
    {
        if([request responseStatusCode] == 200)
        {
            //success
        }
        else
        {
            
        }
    }
    else if(request.tag==15)
    {
        if([request responseStatusCode] == 200)
        {
            [relationArray removeAllObjects];
            [nonAcceptedUsersArray removeAllObjects];
            
                NSError *errorl = nil;
                NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
                
                BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"] || success)
                {
                    NSLog(@"relationship description : %@",jsonResponse.description);
                    if([jsonResponse objectForKey:@"user_pic"]!= [NSNull null])
                        [[NSUserDefaults standardUserDefaults] setObject:[jsonResponse objectForKey:@"user_pic"] forKey:@"user_pic"];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]);
                    [owner_profilepic sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]] ]; //set the profile pic
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    tempArray=[jsonResponse objectForKey:@"relationships"];
                    
                    for (int i = 0; i<[tempArray count]; i++)
                    {
                        if([[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"accepted"]] isEqualToString:@"1"])
                        {
                            [relationArray addObject:[tempArray objectAtIndex:i]];
                        }
                        else
                        {
                            [nonAcceptedUsersArray addObject:[tempArray objectAtIndex:i]];
                        }
                    }
                    
                    //          relationArray=[jsonResponse objectForKey:@"relationships"];
                    [table reloadData];
                }
                else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
                {
                    
                }
                else
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:errorl.description
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
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
            [alertView show];
            alertView = nil;
            
        }
        [activity hide];
    }
    else
    {
        //NSError *errorl = nil;
        //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
        //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
//        
    }
    
    
}
#pragma mark -
#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        if (nonAcceptedUsersArray.count!=0)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0+13, 0, tableView.bounds.size.width-15, 33)];
            UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clickin-request2.png"]]; //set your image
            
            headerImage.frame = CGRectMake(0+13, 0, tableView.bounds.size.width-15, 33);
            
            [headerView addSubview:headerImage];
            return headerView;
        }
        else
            return Nil;
    }
    if(section == 1) // only for section 2
    {
        if (relationArray.count!=0)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0+13, 0, tableView.bounds.size.width-15, 33)];
            UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_relation_header_bg.png"]]; //set your image
            
            headerImage.frame = CGRectMake(0+13, 0, tableView.bounds.size.width-15, 33);
            
            [headerView addSubview:headerImage];
            return headerView;
        }
        else
            return Nil;
    }
    
    return Nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        if (nonAcceptedUsersArray.count!=0)
        {
            return 61;
        }
        else
            return 0;
    }
    if(section==1) // only for section 2
    {
        if (relationArray.count!=0)
        {
            return 33;
        }
        else
            return 0;
    }
    if (section==2)
    {
        return 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
        if(nonAcceptedUsersArray.count==0)
            return 0;
        else
            return nonAcceptedUsersArray.count;
    }
    if(section==1)
    {
        if(relationArray.count==0)
            return 0;
        else
            return relationArray.count;
    }
    if (section==2) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifiersection2 = @"Cellforsection2";
    static NSString *CellIdentifiersection3 = @"Cellforsection3";
    static NSString *CellIdentifiersection4 = @"Cellforsection4";
    UITableViewCell *cell;
    
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection4];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection4];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            //            //cell bg
            UIImageView *cellbg = [[UIImageView alloc] initWithFrame:CGRectMake(3+10, -29, 146, 132)];
            cellbg.backgroundColor = [UIColor clearColor];
            cellbg.opaque = NO;
            cellbg.image = [UIImage imageNamed:@"profile_relation_bg2.png"];
            cellbg.tag=1;
            [cell.contentView addSubview:cellbg];
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(47, 20-24, 75, 75)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            //relation cancel button
            UIButton *relation_delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [relation_delete_button addTarget:self
                                       action:@selector(relationcancelpressed:)
                             forControlEvents:UIControlEventTouchUpInside];
            [relation_delete_button setImage:[UIImage imageNamed:@"relation_cancel_icon.png"] forState:UIControlStateNormal];
            relation_delete_button.frame =CGRectMake(16, 40-28, 37, 37);
            [cell.contentView addSubview:relation_delete_button];
            
            //name
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(14.5f, -22, 140, 20))];
            name.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            name.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            
            //pendingText
            UILabel *pendingText = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(65, 100-24, 100, 20))];
            pendingText.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            pendingText.tag = 13;
            pendingText.backgroundColor = [UIColor clearColor];
            pendingText.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14.0];
            pendingText.lineBreakMode = YES;
            pendingText.numberOfLines = 0;
            pendingText.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:pendingText];
            pendingText.textColor = [UIColor lightGrayColor];
            
            //relation clicks
            UILabel *relation_clicks = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(91+10, 22-28, 32, 15))];
            relation_clicks.textAlignment = NSTextAlignmentRight;  //(for iOS 6.0)
            relation_clicks.tag = 6;
            relation_clicks.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            relation_clicks.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.0];
            relation_clicks.lineBreakMode = YES;
            relation_clicks.numberOfLines = 0;
            relation_clicks.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:relation_clicks];
            relation_clicks.text=@"234";
            relation_clicks.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            //line
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15+10, 118-24, 125, 2)];
            line.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0];
            line.tag=7;
            [cell.contentView addSubview:line];
            
            //public or private
            
            UIButton *scope_pic = [UIButton buttonWithType:UIButtonTypeCustom];
//            [scope_pic addTarget:self
//                          action:@selector(Deletebuttonpressed:)
//                forControlEvents:UIControlEventTouchDown];
            [scope_pic setImage:[UIImage imageNamed:@"relation_cancel_icon.png"] forState:UIControlStateNormal];
            scope_pic.frame =CGRectMake(109+7, 40-24, 37, 37);//(109+7, 40, 37, 37)
            [cell.contentView addSubview:scope_pic];
            scope_pic.tag=8;
            
            //relation cancel button
            UIButton *relation_Accept_button = [UIButton buttonWithType:UIButtonTypeCustom];
            relation_Accept_button.tag =  14;
            relation_Accept_button.frame =CGRectMake(109+7, 40-24, 37, 37);
            [cell.contentView addSubview:relation_Accept_button];
            
//          UIImageView *scope_pic=[[UIImageView alloc] initWithFrame:CGRectMake(109, 45, 36, 36)];
//          scope_pic.tag=8;
//          [cell.contentView addSubview:scope_pic];
        }
        
        if(nonAcceptedUsersArray.count!=0)
        {
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            profile_pic.hidden=NO;
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            name.hidden=NO;
            //            UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
            //            settingsicon.hidden=NO;
            UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
            line.hidden=NO;
            
            
            UILabel *PendingTxt=(UILabel*)[cell.contentView viewWithTag:13];
            PendingTxt.hidden=NO;
            
            UIButton *AcceptButton=(UIButton*)[cell.contentView viewWithTag:14];
            [AcceptButton addTarget:self
                                       action:@selector(AcceptButtonAction:)
                             forControlEvents:UIControlEventTouchUpInside];
            [AcceptButton setImage:[UIImage imageNamed:@"acceptIocn-red.png"] forState:UIControlStateNormal];
            
            UIButton *scope_pic=(UIButton*)[cell.contentView viewWithTag:8];
            [scope_pic setImage:[UIImage imageNamed:@"74x.png"] forState:UIControlStateNormal];

            if(((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).isRequestInitiator)
            {
                PendingTxt.text= @"PENDING";
                AcceptButton.alpha = 0;
                scope_pic.alpha = 1;
            }
            else
            {
                PendingTxt.text= @"";
                AcceptButton.alpha = 1;
                scope_pic.alpha = 0;
            }

            //profile pic
            if(((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerPicUrl.length>0)
            {
                [profile_pic sd_setImageWithURL:[NSURL URLWithString:((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerPicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            }
            else
            {
                profile_pic.image = [UIImage imageNamed:@"contact_icon.png"];
            }
            //name text
            if(((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerName.length>0)
            {
                name.text=[((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerName capitalizedString];
                
            }
            else
            {
                name.text= ((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                
            }
            
            // clicks text
            UILabel *relation_clicks=(UILabel*)[cell.contentView viewWithTag:6];
            /*NSString *userclicks=[NSString stringWithFormat:@"%@",((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).ownerClicks];
            if([userclicks isEqualToString:@"<null>"])
                userclicks=@"0";
            relation_clicks.text=userclicks;*/
            relation_clicks.text=@"";
            
            //scope image
//            UIButton *scope_pic=(UIButton*)[cell.contentView viewWithTag:8];
//            if(((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).isRelationPublic)
//            {
//                // scope_pic.image=[UIImage imageNamed:@"profile_public_scope.png"];
//                [scope_pic setImage:[UIImage imageNamed:@"profile_public_scope.png"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                // scope_pic.image=[UIImage imageNamed:@"profile_private_scope.png"];
//                [scope_pic setImage:[UIImage imageNamed:@"profile_private_scope.png"] forState:UIControlStateNormal];
//            }
//            [scope_pic setImage:nil forState:UIControlStateNormal];
            
            //show line border for cell and last cell check
            if(indexPath.row==nonAcceptedUsersArray.count-1)
            {
                line.hidden=YES;
                // round corner last cell bg
                UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellbg.bounds
                                                               byRoundingCorners:UIRectCornerBottomLeft
                                                                     cornerRadii:CGSizeMake(15.0, 15.0)];
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = cellbg.bounds;
                maskLayer.path = maskPath.CGPath;
                cellbg.layer.mask=maskLayer;
            }
            else
            {
                line.hidden=NO;
                UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                cellbg.layer.mask=Nil;
            }
            
            if(((RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row]).partnerName.length == 0)
            {
                UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                cellbg.image = [UIImage imageNamed:@"profile_relation_bg2.png"];
                if(indexPath.row==nonAcceptedUsersArray.count-1)
                {
                    line.hidden = YES;
                }
                else
                {
                    line.hidden=NO;
                }
                
                relation_clicks.text= @"";
               // [scope_pic setImage:nil forState:UIControlStateNormal];
            }
        }
    }
    if(indexPath.section==1)  //section 1
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            //            //cell bg
            UIImageView *cellbg = [[UIImageView alloc] initWithFrame:CGRectMake(3+10, -1, 146, 112)];
            cellbg.backgroundColor = [UIColor clearColor];
            cellbg.opaque = NO;
            cellbg.image = [UIImage imageNamed:@"profile_relation_bg.png"];
            cellbg.tag=1;
            [cell.contentView addSubview:cellbg];
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(47, 20, 75, 75)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            //relation cancel button
            UIButton *relation_delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [relation_delete_button addTarget:self
                                       action:@selector(Deletebuttonpressed:)
                             forControlEvents:UIControlEventTouchUpInside];
            [relation_delete_button setImage:[UIImage imageNamed:@"relation_cancel_icon.png"] forState:UIControlStateNormal];
            relation_delete_button.frame =CGRectMake(16, 40, 37, 37);
            [cell.contentView addSubview:relation_delete_button];
            
            //name
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(14.5f, 2, 140, 20))];
            name.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            name.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            
            //pendingText
            UILabel *pendingText = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(100, 90, 100, 20))];
            pendingText.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            pendingText.tag = 13;
            pendingText.backgroundColor = [UIColor clearColor];
            pendingText.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
            pendingText.lineBreakMode = YES;
            pendingText.numberOfLines = 0;
            pendingText.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:pendingText];
            pendingText.textColor = [UIColor lightGrayColor];
            
            //relation clicks
            UILabel *relation_clicks = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(91+10, 22, 32, 15))];
            relation_clicks.textAlignment = NSTextAlignmentRight;  //(for iOS 6.0)
            relation_clicks.tag = 6;
            relation_clicks.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            relation_clicks.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.0];
            relation_clicks.lineBreakMode = YES;
            relation_clicks.numberOfLines = 0;
            relation_clicks.lineBreakMode = NSLineBreakByTruncatingTail;
         //   [cell.contentView addSubview:relation_clicks];
            relation_clicks.text=@"234";
            relation_clicks.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            //line
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15+10, 108, 125, 2)];
            line.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0];
            line.tag=7;
            [cell.contentView addSubview:line];
            
            //public or private
            
            UIButton *scope_pic = [UIButton buttonWithType:UIButtonTypeCustom];
            [scope_pic addTarget:self
                          action:@selector(alertForPublicOrPrivate:)
                forControlEvents:UIControlEventTouchUpInside];
            [scope_pic setImage:[UIImage imageNamed:@"relation_cancel_icon.png"] forState:UIControlStateNormal];
            scope_pic.frame =CGRectMake(109+7, 40, 37, 37);
            [cell.contentView addSubview:scope_pic];
            scope_pic.tag=8;
            
            //            UIImageView *scope_pic=[[UIImageView alloc] initWithFrame:CGRectMake(109, 45, 36, 36)];
            //            scope_pic.tag=8;
            //            [cell.contentView addSubview:scope_pic];
        }
        
        if(relationArray.count!=0)
        {
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            profile_pic.hidden=NO;
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            name.hidden=NO;
            //            UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
            //            settingsicon.hidden=NO;
            UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
            line.hidden=NO;

            UILabel *PendingTxt=(UILabel*)[cell.contentView viewWithTag:13];
            PendingTxt.hidden=NO;
            
            //profile pic
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl.length>0)
            {
                
                NSLog(@"URL IS %@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl);
               NSURL *url= [NSURL URLWithString:((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl];
                [profile_pic sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    if (image)
                    {
                        NSLog(@"Done Successfully %d",indexPath.row);
                       // [table reloadData];
                    }
                } ];
               
                PendingTxt.text= @"";
            }
            else
            {
                PendingTxt.text= @"PENDING";
                profile_pic.image = [UIImage imageNamed:@"contact_icon.png"];
            }
            //name text
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length>0)
            {
                name.text=[((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName capitalizedString];
                PendingTxt.text= @"";
            }
            else
            {
                name.text= ((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                PendingTxt.text= @"PENDING";
            }
            
            // clicks text
            UILabel *relation_clicks=(UILabel*)[cell.contentView viewWithTag:6];
            NSString *userclicks=[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).ownerClicks];
            if([userclicks isEqualToString:@"<null>"])
                userclicks=@"0";
            relation_clicks.text=userclicks;
            
            //scope image
            UIButton *scope_pic=(UIButton*)[cell.contentView viewWithTag:8];
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).isRelationPublic)
            {
                // scope_pic.image=[UIImage imageNamed:@"profile_public_scope.png"];
                [scope_pic setImage:[UIImage imageNamed:@"profile_public_scope.png"] forState:UIControlStateNormal];
            }
            else
            {
                // scope_pic.image=[UIImage imageNamed:@"profile_private_scope.png"];
                [scope_pic setImage:[UIImage imageNamed:@"profile_private_scope.png"] forState:UIControlStateNormal];
            }
            
            //show line border for cell and last cell check
            if(indexPath.row==relationArray.count-1)
            {
                line.hidden=YES;
                // round corner last cell bg
                UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellbg.bounds
                                                               byRoundingCorners:UIRectCornerBottomLeft
                                                                     cornerRadii:CGSizeMake(15.0, 15.0)];
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = cellbg.bounds;
                maskLayer.path = maskPath.CGPath;
                cellbg.layer.mask=maskLayer;
            }
            else
            {
                line.hidden=NO;
                UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                cellbg.layer.mask=Nil;
            }
            
             if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length == 0)
             {
                 UIImageView *cellbg=(UIImageView*)[cell.contentView viewWithTag:1];
                  cellbg.image = [UIImage imageNamed:@"profile_relation_bg2.png"];
                if(indexPath.row==relationArray.count-1)
                {
                    line.hidden = YES;
                }
                else
                {
                    line.hidden=NO;
                }

                 relation_clicks.text= @"";
                 [scope_pic setImage:nil forState:UIControlStateNormal];
             }
        }
        
    }
    if(indexPath.section==2) //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection3];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            cell.layer.cornerRadius=10;
            
            UIButton *profile_add=[UIButton buttonWithType:UIButtonTypeCustom];
            profile_add.frame = CGRectMake(0+10, 20, 146, 77);
            [profile_add setBackgroundImage:[UIImage imageNamed:@"profile_add_clickin.png"] forState:UIControlStateNormal];
            [profile_add addTarget:self
                          action:@selector(addSomeOneToClick:)
                forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:profile_add];
            
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(nonAcceptedUsersArray.count==0)
            return 0;
        else
            return 120;
    }
    if(indexPath.section==1)
    {
        if(relationArray.count==0)
            return 0;
        else
            return 110;
    }
    if (indexPath.section==2) {
        return 77+20; // 88 for row and 30 for gap
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
//        if(([[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"partner_pic"] == [NSNull null]) && ([[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"partner_name"] == [NSNull null]))
//        {
//            
//        }
//        else
//        {
//            if(![[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"accepted"]  isEqualToString:@"<null>"]) // if user is not created
//            {
//                profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
//                profile_other.otheruser_phone_no=[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"phone_no"];
//                profile_other.relationship_id=[[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"id"] objectForKey:@"$id"];
//                profile_other.otheruser_name=[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"partner_name"];
//                
//                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//                
//                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//                while (controllers.count>1) {
//                    [controllers removeLastObject];
//                }
//                //[controllers addObject:profile_other];
//                navigationController.viewControllers = controllers;
//                [navigationController pushViewController:profile_other animated:YES];
//            }
//        }
    }
    if(indexPath.section==1)
    {
        if((((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl.length==0) && (((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length==0))
        {
            
        }
        else
        {
            if(![((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName  isEqualToString:@"<null>"]) // if user is not created
            {
                ((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker = [[GAI sharedInstance] defaultTracker];
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]).tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Browsing Profile"
                                                                                                                                   action:@"Browsing user's profile"
                                                                                                                                    label:@"Browsing user's profile"
                                                                                                                                    value:nil] build]];
                
                profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
               /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
                profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
                profile_other.relationObject = ((RelationInfo*)[relationArray objectAtIndex:indexPath.row]);
                
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
}

-(void)addSomeOneToClick:(UIButton*)sender
{
    SearchContactsViewController *sendinvite = [[SearchContactsViewController alloc] initWithNibName:nil bundle:nil];
    sendinvite.isFromMenu = @"true";
    //SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
    while (controllers.count>1) {
        [controllers removeLastObject];
    }
    //[controllers addObject:sendinvite];
    navigationController.viewControllers = controllers;
    [navigationController pushViewController:sendinvite animated:YES];
    //[self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}


-(void)AcceptButtonAction:(id)sender
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
    cell = (UITableViewCell *)[[[button superview] superview] superview];
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    
    NSLog(@"%d",indexPath.row);
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    [self performSelector:@selector(CallwebServiceAcceptButton:) withObject:indexPath afterDelay:0.1];
}

-(void)CallwebServiceAcceptButton:(NSIndexPath *)indexPath
{
    [profilemanager acceptRelation:(RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row] atIndex:indexPath.row];
    /*
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/updatestatus"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    NSString *RelationShip_ID = [[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"id"] objectForKey:@"$id"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",RelationShip_ID,@"relationship_id",@"true",@"accepted",nil];
    
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
        [nonAcceptedUsersArray removeObjectAtIndex:indexPath.row];
        [table reloadData];
        
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationship successfully accepted"] || success)
        {
            //[self getuserrelations]; // get relations
            [profilemanager getRelations:YES];
            NSLog(@"relationship description : %@",jsonResponse.description);
        }
        else
        {
            
        }
    }*/
}


-(void)relationcancelpressedSectionOne:(id)sender
{
}

-(void)relationcancelpressed:(id)sender
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
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(callWebServiceRejectuser:) withObject:indexPath afterDelay:0.1];
}

-(void)callWebServiceRejectuser:(NSIndexPath *)indexPath
{
    [profilemanager rejectRelation:(RelationInfo*)[nonAcceptedUsersArray objectAtIndex:indexPath.row] atIndex:indexPath.row];
    /*
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/updatestatus"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    NSString *RelationShip_ID = [[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"id"] objectForKey:@"$id"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",RelationShip_ID,@"relationship_id",@"false",@"accepted",nil];
    
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
        [nonAcceptedUsersArray removeObjectAtIndex:indexPath.row];
        [table reloadData];
        
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationship successfully accepted"] || success)
        {
            NSLog(@"relationship description : %@",jsonResponse.description);
        }
        else
        {
            
        }
    }
    [activity hide];*/
}

-(void)alertForPublicOrPrivate:(id)sender
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
    
    MODropAlertView *alertView;
    
    if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"profile_public_scope.png"]])
    {
        
        alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil  description:[NSString stringWithFormat:@"Are you sure you want to make your relationship with %@ private?",[((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName capitalizedString]]
                                                     okButtonTitle:@"OK"
                                                 cancelButtonTitle:@"Cancel"];
        alertView.delegate = self;
    }
    else
    {
        alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil  description:[NSString stringWithFormat:@"Are you sure you want to make your relationship with %@ public?",[((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName capitalizedString]]
                                                     okButtonTitle:@"OK"
                                                 cancelButtonTitle:@"Cancel"];
        alertView.delegate = self;
    }
    alertView.tag = 44;
    [alertView showForPresentView];
    alertView = nil;
}



-(void)Deletebuttonpressed:(id)sender
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
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(CallwebServiceDeleteButton:) withObject:indexPath afterDelay:0.1];
   
}

-(void)CallwebServiceDeleteButton:(NSIndexPath *)indexPath
{
    [profilemanager deleteRelation:(RelationInfo*)[relationArray objectAtIndex:indexPath.row] atIndex:indexPath.row];
}


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==44)// send clickIn request
    {
        if(buttonType==0)
        {
            [self scopebuttonpressed];
        }
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==44)  // unfollow button service
    {
        if(buttonIndex==0)
        {
            [self scopebuttonpressed];
        }
    }
}*/

-(void)scopebuttonpressed
{
    bool relation_visibility;
    UIButton *button = ((UIButton*)[((UITableViewCell*)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected_row inSection:1]]).contentView viewWithTag:8]);
    if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"profile_public_scope.png"]])
        relation_visibility = false;
    else
        relation_visibility=true;
    
    [(RelationInfo*)[relationArray objectAtIndex:selected_row] setRelationVisibility:relation_visibility];
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    /*
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/changevisibility"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        bool relation_visibility;
        UIButton *button = ((UIButton*)[((UITableViewCell*)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selected_row inSection:1]]).contentView viewWithTag:8]);
        if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"profile_public_scope.png"]])
            relation_visibility = false;
        else
            relation_visibility=true;
     
         NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
         NSDictionary *oldDict = (NSDictionary *)[relationArray objectAtIndex:selected_row];
         [newDict addEntriesFromDictionary:oldDict];
         [newDict setObject:[NSNumber numberWithBool:relation_visibility] forKey:@"public"];
         [relationArray replaceObjectAtIndex:selected_row withObject:newDict];
         newDict = nil;
         oldDict = nil;
     
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[relationArray objectAtIndex:selected_row] objectForKey:@"id"] objectForKey:@"$id"],@"relationship_id", [NSNumber numberWithBool:relation_visibility], @"public", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 44;
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
    }
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
