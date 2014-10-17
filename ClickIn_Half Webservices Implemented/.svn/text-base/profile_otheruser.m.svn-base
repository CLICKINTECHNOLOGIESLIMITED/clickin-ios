//
//  profile_owner.m
//  ClickIn
//
//  Created by Leo Macbook on 21/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "profile_otheruser.h"
#import "AppDelegate.h"


@interface profile_otheruser ()

@end

@implementation profile_otheruser
@synthesize relationObject,isFromSearchByName;//otheruser_phone_no,relationship_id,otheruser_name;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(MFSideMenuContainerViewController *)menuContainerViewController
{
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
-(void)viewWillAppear:(BOOL)animated
{
   
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    if(isFromSearchByName==true)
//    {
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(rightMenuToggled:)
//         name:Notification_RightMenuToggled
//         object:nil];
//        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(RelationsNotificationReceived:)
//         name:Notification_RelationsUpdated
//         object:nil];
//        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(RelationRequestNotificationReceived:)
//         name:Notification_RelationRequestSent
//         object:nil];
//        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(ProfileInfoNotificationReceived:)
//         name:Notification_ProfileInfoUpdated
//         object:nil];
//        
//        
//        //    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//        //    [imageCache clearMemory];
//        [self getuserrelations]; // get relations
//        [self getprofileinfo];  // get owner info
//    }
//
//}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RightMenuToggled object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ProfileInfoUpdated object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RelationsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RelationRequestSent object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(rightMenuToggled:)
//     name:Notification_RightMenuToggled
//     object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(RelationsNotificationReceived:)
//     name:Notification_RelationsUpdated
//     object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(RelationRequestNotificationReceived:)
//     name:Notification_RelationRequestSent
//     object:nil];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(ProfileInfoNotificationReceived:)
//     name:Notification_ProfileInfoUpdated
//     object:nil];
    
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;
    
    clickInStatus=0;
    for(int i=0;i<profilemanager.nonAcceptedRelationArray.count;i++)
    {
        if([((RelationInfo*)[profilemanager.nonAcceptedRelationArray objectAtIndex:i]).partnerPhoneNumber isEqualToString:relationObject.partnerPhoneNumber])
        {
            clickInStatus = 1;
            break;
        }
    }
    
    for(int i=0;i<profilemanager.relationshipArray.count;i++)
    {
        if([((RelationInfo*)[profilemanager.relationshipArray objectAtIndex:i]).partnerPhoneNumber isEqualToString:relationObject.partnerPhoneNumber])
        {
            clickInStatus = 2;
            break;
        }
    }
    
    
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
    UIImageView *header_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 53.5)];
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
    header_text.text=[relationObject.partnerName uppercaseString];
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
    notification_text.numberOfLines = 1;
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
    Name.text=[relationObject.partnerName uppercaseString];
    [self.view addSubview:Name];
    
    //profile pic
    owner_profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 140, 140)];
    [self.view addSubview:owner_profilepic];
    //[owner_profilepic setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]];
    
    // profile edit icon button
    //    UIImageView *profile_edit_icon=[[UIImageView alloc] initWithFrame:CGRectMake(135, 225, 37, 37)];
    //    profile_edit_icon.image=[UIImage imageNamed:@"profile_edit_icon.png"];
    //    [self.view addSubview:profile_edit_icon];
    
    //    UIButton *profile_editbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [profile_editbutton addTarget:self
    //                   action:@selector(editbuttonpressed)
    //         forControlEvents:UIControlEventTouchDown];
    //    [profile_editbutton setImage:[UIImage imageNamed:@"profile_edit_icon.png"] forState:UIControlStateNormal];
    //    profile_editbutton.frame =CGRectMake(130, 220, 40, 40);
    //    [self.view addSubview:profile_editbutton];
    
    // user info line 1
    userinfo1 = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 245, 150, 20))];
    userinfo1.textColor = [UIColor colorWithRed:(120.0/255.0) green:(120.0/255.0) blue:(120.0/255.0) alpha:1.0];
    userinfo1.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
    userinfo1.tag = 5;
    userinfo1.backgroundColor = [UIColor clearColor];
    // userinfo1 = [UIFont fontWithName:@"Halvetica" size:10];
    userinfo1.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:13.0];
    userinfo1.lineBreakMode = YES;
    userinfo1.numberOfLines = 0;
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
    UIImageView *followers_bg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 315, 155, 44)];
    followers_bg.image=[UIImage imageNamed:@"followers_text.png"];
    [self.view addSubview:followers_bg];
    followers_bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *followergesture = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(followersPressed)];
    followergesture.delegate = self;
    [followers_bg addGestureRecognizer:followergesture];
    
    // followers count text
    followers_count_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 332-5, 50, 20))];
    
    followers_count_text.textColor = [UIColor colorWithRed:(170.0/255.0) green:(170.0/255.0) blue:(170.0/255.0) alpha:1.0];
    followers_count_text.textAlignment = NSTextAlignmentRight;  //(for iOS 6.0)
    followers_count_text.tag = 5;
    followers_count_text.backgroundColor = [UIColor clearColor];
    // userinfo3 = [UIFont fontWithName:@"Halvetica" size:10];
    followers_count_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
    followers_count_text.lineBreakMode = YES;
    followers_count_text.numberOfLines = 0;
    followers_count_text.lineBreakMode = NSLineBreakByTruncatingTail;
    followers_count_text.text=@"0";
    [self.view addSubview:followers_count_text];
    
    // following text bg
    UIImageView *following_bg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 373, 155, 44)];
    following_bg.image=[UIImage imageNamed:@"following_text.png"];
    [self.view addSubview:following_bg];
    following_bg.userInteractionEnabled = YES;
    UITapGestureRecognizer *followinggesture = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(followingPressed)];
    followinggesture.delegate = self;
    [following_bg addGestureRecognizer:followinggesture];
    
    // following count text
    following_count_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(120, 395-10, 50, 20))];
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
    
    //follow following count
    UIButton *followbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    followbutton.tag = 13;
    [followbutton addTarget:self
                     action:@selector(followbuttonpressed)
           forControlEvents:UIControlEventTouchUpInside];
//    [followbutton setImage:[UIImage imageNamed:@"profile_follow_button.png"] forState:UIControlStateNormal];
    followbutton.frame =CGRectMake(10, 430, 155, 44);
//    followbutton.enabled=NO;
    [self.view addSubview:followbutton];
    
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
    //get relations service
    //    [self getuserrelations];
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RightMenuToggled object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ProfileInfoUpdated object:nil];;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RelationsUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RelationRequestSent object:nil];
   
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RelationsNotificationReceived:)
     name:Notification_RelationsUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RelationRequestNotificationReceived:)
     name:Notification_RelationRequestSent
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    [self getuserrelations]; // get relations
    [self getprofileinfo];  // get owner info

}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    notification_text.text = @"0";
    
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
}


- (void)RelationsNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [relationArray removeAllObjects];
    [relationArray addObjectsFromArray:profilemanager.othersRelationshipArray];
    [table reloadData];
}

- (void)RelationRequestNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    clickInStatus = 1;
    [table reloadData];
}

#pragma mark Notifications received
- (void)ProfileInfoNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    //[activity hide];
    //set the profile pic
    [owner_profilepic setImageWithURL:[NSURL URLWithString:relationObject.userDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
    
    //set age and gender
   // userinfo1.text=[NSString stringWithFormat:@"%@, %@",relationObject.userDetails.gender,relationObject.userDetails.age];
    
    if(relationObject.userDetails.gender.length == 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@",relationObject.userDetails.age];
    }
    
    if(relationObject.userDetails.age.length == 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@",relationObject.userDetails.gender];
    }
    
    if (relationObject.userDetails.age.length == 0  && relationObject.userDetails.gender.length == 0)
    {
        userinfo1.text=@"";
    }
    
    if (relationObject.userDetails.age.length != 0  && relationObject.userDetails.gender.length != 0)
    {
        userinfo1.text=[NSString stringWithFormat:@"%@, %@",relationObject.userDetails.gender,relationObject.userDetails.age];
    }
    
 //   NSLog(@"%@",[NSString stringWithFormat:@"%@,%@",relationObject.userDetails.city,relationObject.userDetails.country]);
    
    
    if(relationObject.userDetails.city.length == 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@",relationObject.userDetails.country];
    }
    
    if(relationObject.userDetails.country.length == 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@",relationObject.userDetails.city];
    }
    
    if (relationObject.userDetails.country.length == 0  && relationObject.userDetails.city.length == 0)
    {
        lblCityAndCountry.text = @"";
    }
    
    if (relationObject.userDetails.country.length != 0  && relationObject.userDetails.city.length != 0)
    {
        lblCityAndCountry.text = [NSString stringWithFormat:@"%@,%@",relationObject.userDetails.city,relationObject.userDetails.country];
    }
    
    
    //notification count set
    notification_text.text=relationObject.userDetails.notificationCount;
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
    
    //followers count
    followers_count_text.text=relationObject.userDetails.followerCount;
    //following count
    following_count_text.text=relationObject.userDetails.followingCount;
    
    //follow button
    UIButton *followbutton = (UIButton *)[self.view viewWithTag:13];
    
    if(relationObject.userDetails.isFollowingRequested==true)
    {
            [followbutton setImage:[UIImage imageNamed:@"BTNRequest.png"] forState:UIControlStateNormal];
    }
    else
    {
        if(relationObject.userDetails.isFollowed==false)
        {
            
            [followbutton setImage:[UIImage imageNamed:@"profile_follow_button.png"] forState:UIControlStateNormal];
            //followbutton.enabled=YES;
        }
        else
        {
            [followbutton setImage:[UIImage imageNamed:@"profile_following_button.png"] forState:UIControlStateNormal];//
            //followbutton.enabled = NO;
        }
    }
        
}



-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}

-(void)followersPressed
{
    NSLog(@"followers pressed");
    
    //if(![followers_count_text.text isEqualToString:@"0"])
    {
        follower_owner *followerowner = [[follower_owner alloc] initWithNibName:nil bundle:nil];
        followerowner.is_Owner = @"false";
        NSArray *substrings = [relationObject.partnerName componentsSeparatedByString:@" "];
        if([substrings count] != 0)
        {
            NSString *first = [substrings objectAtIndex:0];
            followerowner.name = [first uppercaseString];
        }
        else
        {
            followerowner.name = @"FOLLOWERS";
        }
        
        followerowner.otheruser_phone_no = relationObject.partnerPhoneNumber;
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
//        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//        while (controllers.count>1) {
//            [controllers removeLastObject];
//        }
        //[controllers addObject:followerowner];
//        navigationController.viewControllers = controllers;
        [navigationController pushViewController:followerowner animated:YES];
    }
}

-(void)followingPressed
{
    NSLog(@"following pressed");
    //if(![following_count_text.text isEqualToString:@"0"])
    {
        following_owner *followingowner = [[following_owner alloc] initWithNibName:nil bundle:nil];
        followingowner.is_Owner = @"false";
        
        NSArray *substrings = [relationObject.partnerName componentsSeparatedByString:@" "];
        if([substrings count] != 0)
        {
            NSString *first = [substrings objectAtIndex:0];
            followingowner.name = [first uppercaseString];
        }
        else
        {
            followingowner.name = @"FOLLOWERS";
        }
        
        followingowner.otheruser_phone_no = relationObject.partnerPhoneNumber;
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
//        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//        while (controllers.count>1) {
//            [controllers removeLastObject];
//        }
//        navigationController.viewControllers = controllers;
        [navigationController pushViewController:followingowner animated:YES];
    }
}


-(void)leftbuttonpressed
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        
    }];
}
-(void)followbuttonpressed
{
    //[activity show];
    
    
     // for async call
     
     UIButton *followbutton = (UIButton *)[self.view viewWithTag:13];
     
     if(relationObject.userDetails.isFollowed==false)
     {
     [followbutton setImage:[UIImage imageNamed:@"BTNRequest.png"] forState:UIControlStateNormal];
     [relationObject.userDetails followUserAction];
     }
     else
     {
     [followbutton setImage:[UIImage imageNamed:@"profile_follow_button.png"] forState:UIControlStateNormal];
     [relationObject.userDetails unfollowUserAction];
     }
    
//    if(relationObject.userDetails.isFollowed==false)
//        [relationObject.userDetails followUserAction];
//    else
//        [relationObject.userDetails unfollowUserAction];
    
    /*bool is_following=[[userinfo objectForKey:@"is_following"] boolValue];
    if(!is_following) // is not following
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationObject.partnerPhoneNumber,@"followee_phone_no",nil];
        
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
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following"] || success)
            {
                [self getprofileinfo];
                [followbutton setImage:[UIImage imageNamed:@"profile_following_button.png"] forState:UIControlStateNormal];
                [self getprofileinfo];
                
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully following" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
            else if(!success)
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[jsonResponse objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
        else if([request responseStatusCode] == 500)
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Already Following" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            
        }
        else
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            //
            //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //        [alert show];
            //        alert = nil;
            
        }
    } // end if not following
    */
}
-(void)getprofileinfo
{
    relationObject.userDetails.phoneNumber = relationObject.partnerPhoneNumber;
    [relationObject.userDetails getProfileInfo:false];
    /*
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo/profile_phone_no:%s",[relationObject.partnerPhoneNumber UTF8String]];
    //str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
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
-(void)getuserrelations
{
    [profilemanager getOtherUserRelations:YES otherUserNo:relationObject.partnerPhoneNumber];
    
    /*
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilerelationships/profile_phone_no:%s",[otheruser_phone_no UTF8String]];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //        NSError *error;
    //
    //        NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:otheruser_phone_no,@"phone_no",user_token,@"user_token",nil];
    //
    //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //[request appendPostData:jsonData];
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];*/
}
/*- (void)requestFinished_info:(ASIHTTPRequest *)request
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
            userinfo=[jsonResponse objectForKey:@"user"];
            
            [owner_profilepic setImageWithURL:[NSURL URLWithString:[userinfo objectForKey:@"user_pic"]]]; //set the profile pic for other user
            
            NSString *gender=[userinfo objectForKey:@"gender"];
            if([gender isEqualToString:@"guy"])
            {
                gender=@"Male";
            }
            else
            {
                gender=@"Female";
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
            //followers count
            followers_count_text.text=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"follower"]];
            //following count
            following_count_text.text=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"following"]];
            UIButton *followbutton = (UIButton *)[self.view viewWithTag:13];

            //follow button
            followbutton.enabled=YES;
            bool is_following=[[userinfo objectForKey:@"is_following"] boolValue];
            if(!is_following)
            {
                [followbutton setImage:[UIImage imageNamed:@"profile_follow_button.png"] forState:UIControlStateNormal];
            }
            else
            {
                [followbutton setImage:[UIImage imageNamed:@"profile_following_button.png"] forState:UIControlStateNormal];
            }
            
            if([[userinfo objectForKey:@"QB_id"] integerValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"QB_id"] integerValue])
                [followbutton setEnabled:false];
            
        }
        //        else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
        //        {
        //
        //        }
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
}*/
- (void)requestFinished:(ASIHTTPRequest *)request
{
    /*
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"] || success)
        {
            
            relationArray=[jsonResponse objectForKey:@"relationships"];
            [table reloadData];
        }
        else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
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
        //NSError *errorl = nil;
        //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
        //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
        
    }*/
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1) // only for section 2
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
    if(section==1) // only for section 2
    {
        if (relationArray.count!=0)
        {
            return 33;
        }
        else
            return 0;
    }
    if (section==0) {
        return 0;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==1)
    {
        if(relationArray.count==0)
            return 0;
        else
            return relationArray.count;
    }
    if (section==0) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifiersection2 = @"Cellforsection2";
    static NSString *CellIdentifiersection3 = @"Cellforsection3";
    UITableViewCell *cell;
    
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
            cellbg.image = [UIImage imageNamed:@"profile_cell_bg_white.png"];
            cellbg.tag=1;
            [cell.contentView addSubview:cellbg];
            
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(47, 20, 75, 75)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
//            UIButton *relation_delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [relation_delete_button addTarget:self
//                                   action:@selector(relationcancelpressed:)
//                         forControlEvents:UIControlEventTouchDown];
//            [relation_delete_button setImage:[UIImage imageNamed:@"relation_cancel_icon.png"] forState:UIControlStateNormal];
//            relation_delete_button.frame =CGRectMake(-5+10, 40, 40, 40);
//            [cell.contentView addSubview:relation_delete_button];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 2, 165, 20))];//
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
            
            //            UILabel *relation_clicks = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(91+10, 22, 32, 15))];
            //            relation_clicks.textAlignment = NSTextAlignmentRight;  //(for iOS 6.0)
            //            relation_clicks.tag = 6;
            //            relation_clicks.backgroundColor = [UIColor clearColor];
            //            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            //            relation_clicks.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.0];
            //            relation_clicks.lineBreakMode = YES;
            //            relation_clicks.numberOfLines = 0;
            //            relation_clicks.lineBreakMode = NSLineBreakByTruncatingTail;
            //            [cell.contentView addSubview:relation_clicks];
            //            relation_clicks.text=@"234";
            //            relation_clicks.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15+10, 108, 125, 2)];
            line.backgroundColor = [UIColor colorWithRed:(200.0/255.0) green:(200.0/255.0) blue:(200.0/255.0) alpha:1.0];
            line.tag=7;
            [cell.contentView addSubview:line];
            
            //            //public or private
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
            
            
            //profile pic
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl.length>0)
                [profile_pic setImageWithURL:[NSURL URLWithString:((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            //name text
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length>0)
                name.text=[((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName capitalizedString];
            
            // clicks text
            //            UILabel *relation_clicks=(UILabel*)[cell.contentView viewWithTag:6];
            //            relation_clicks.text=[[relationArray objectAtIndex:indexPath.row] objectForKey:@"user_clicks"];
            
            //            UILabel *relation_clicks=(UILabel*)[cell.contentView viewWithTag:6];
            //            NSString *userclicks=[NSString stringWithFormat:@"%@",[[relationArray objectAtIndex:indexPath.row] objectForKey:@"user_clicks"]];
            //            if([userclicks isEqualToString:@"<null>"])
            //                userclicks=@"0";
            //            relation_clicks.text=userclicks;
            
            
            //            //scope image
            //            UIImageView *scope_pic=(UIImageView*)[cell.contentView viewWithTag:8];
            //            if([[[relationArray objectAtIndex:indexPath.row] objectForKey:@"public"] boolValue])
            //                scope_pic.image=[UIImage imageNamed:@"profile_public_scope.png"];
            //            else
            //                scope_pic.image=[UIImage imageNamed:@"profile_private_scope.png"];
            
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
        }
    }
    if(indexPath.section==0) //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection3];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection3];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            cell.layer.cornerRadius=10;
            
            UIImageView *profile_add=[[UIImageView alloc] initWithFrame:CGRectMake(0+10, 20, 146, 53)];
            profile_add.tag = 333;
            profile_add.image=[UIImage imageNamed:@"profile_other_click_with.png"];
            [cell.contentView addSubview:profile_add];
            
            UILabel *heading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15+10, 0, 100, 20))];
            heading.center=CGPointMake(85,25);
            heading.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            heading.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:10.0];
            heading.lineBreakMode = YES;
            heading.numberOfLines = 0;
            heading.tag = 444;
            heading.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:heading];
            heading.text=@"";
            heading.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15+10, 50, 100, 20))];
            name.tag = 222;
            name.center=CGPointMake(85,60);
            name.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            name.text=[relationObject.partnerName uppercaseString];
//            name.textColor = [UIColor colorWithRed:(57.0/255.0) green:(196.0/255.0) blue:(216.0/255.0) alpha:1.0];
            name.textColor = [UIColor whiteColor];
            
            UIButton *clickInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            clickInButton.tag = 777;
            
            [clickInButton addTarget:self action:@selector(sendClickInRequest:) forControlEvents:UIControlEventTouchUpInside];
            [clickInButton setBackgroundImage:nil forState:UIControlStateNormal];
            clickInButton.backgroundColor = [UIColor clearColor];
            clickInButton.frame = CGRectMake(0+10, 0, 146, 53);
            [cell.contentView addSubview:clickInButton];
            
        }
        
        UILabel *Heading=(UILabel*)[cell.contentView viewWithTag:444];
        UIButton *ClickInButton=(UIButton*)[cell.contentView viewWithTag:777];
        UIImageView *imgView=(UIImageView*)[cell.contentView viewWithTag:333];
        UILabel *lblName=(UILabel*)[cell.contentView viewWithTag:222];

        if(clickInStatus==2)
        {
            lblName.frame = CGRectMake(10, 46, 146, 20);
            imgView.frame = CGRectMake(0+10, 0, 146, 145/2);
            imgView.image = [UIImage imageNamed:@"boxAlreadyClickin.png"];
            Heading.text=@"";
            ClickInButton.enabled = false;
        }
        else if(clickInStatus==1)
        {
            lblName.frame = CGRectMake(10, 46, 146, 20);
            imgView.frame = CGRectMake(0+10, 0, 146, 145/2);
            imgView.image=[UIImage imageNamed:@"boxRequestedClickin.png"];
            Heading.text = @"";
            ClickInButton.enabled = false;
        }
        else
        {
            lblName.frame = CGRectMake(10, 30, 146, 20);
            imgView.frame = CGRectMake(0+10, 0, 146, 53);
            imgView.image=[UIImage imageNamed:@"profile_other_click_with.png"];
            Heading.text=@"";
            ClickInButton.enabled = true;
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==1)
    {
        if(relationArray.count==0)
            return 0;
        else
            return 110;
    }
    if (indexPath.section==0)
    {
    if(clickInStatus==1 || clickInStatus == 2)
        return 53+20+20; // 20 for gap
    else
        return 53+20;
    }
    return 50;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==1)
    {
        if(![((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName  isEqualToString:@"<null>"] && ![((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]]) // if user is not created
        {
            profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
            /*profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
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

-(void)sendClickInRequest:(UIButton*)sender
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure" message:[NSString stringWithFormat:@"you want to click with \n %@",relationObject.partnerName] delegate:self cancelButtonTitle:@"Yes Please" otherButtonTitles:@"No Thanks", nil];
//    alert.tag = 44;
//    [alert show];
//    alert = nil;
    
    
    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Are you sure"
                                                                    description:[NSString stringWithFormat:@"you want to click with \n %@",relationObject.partnerName]
                                                                  okButtonTitle:@"Yes Please"
                                                              cancelButtonTitle:@"No Thanks"];
    
    alertView.delegate = self;
    alertView.tag = 44;
    [alertView show];
    alertView = nil;
}


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==44)// send clickIn request
    {
        if(buttonType==0)
        {
            [profilemanager sendClickInRequest:relationObject.partnerPhoneNumber];
        }
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==44)  // send clickIn request
    {
        if(buttonIndex==0)
        {
            [profilemanager sendClickInRequest:relationObject.partnerPhoneNumber];
        }
    }
}
*/

//-(void)relationcancelpressed:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
//    NSIndexPath *indexPath = [table indexPathForCell:cell];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
