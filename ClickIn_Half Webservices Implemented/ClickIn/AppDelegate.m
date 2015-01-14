//
//  AppDelegate.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "AppDelegate.h"
#import "SSKeychain.h"
#import <Security/Security.h>
#import <Crashlytics/Crashlytics.h>
#import "LeftViewController.h"
#import "NotificationsViewController.h"
#import "CenterViewController.h"
#import "CommentsViewController.h"
#import "NewsfeedViewController.h"
#import "profile_owner.h"
#import <Quickblox/Quickblox.h>
#import "CommentStarCommonView.h"
#import <AVFoundation/AVFoundation.h>
#import "GAI.h"


@implementation AppDelegate
@synthesize internetReach,internetWorking;
@synthesize str_App_DisplayName;
@synthesize slideContainer;
@synthesize isFlowFromNotification,isAppLaunching,play_chatAnimation,isAppLaunchedFirstTime,isRelationsFetchedFirstTime,isChatLoggedIn;
@synthesize tracker;

- (NSString *)createNewUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string ;
}

- (BOOL)isExternalAudioPlaying
{
    UInt32 audioPlaying = 0;
    UInt32 audioPlayingSize = sizeof(audioPlaying); AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &audioPlayingSize, &audioPlaying);
    return (BOOL)audioPlaying;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /////////////////////MIXPANEL CODE //////////////////////
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
   
    // google analytics code
    [GAI sharedInstance].trackUncaughtExceptions = YES; // Enable exception reporting
    
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    //tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-53544001-1"];
    tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-52963679-1"];
    /*[QBSettings setApplicationID:4999];
    [QBSettings setAuthorizationKey:@"O5dZmmYdPEmwa2K"];
    [QBSettings setAuthorizationSecret:@"LYUZAtkQSgbbpfu"];*/
    
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
    
    isChatLoggedIn = false;
    
    isAppLaunchedFirstTime = true;
    isRelationsFetchedFirstTime = true;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"no" forKey:@"is_typing"];
    
    [QBSettings setApplicationID:6768];
    [QBSettings setAuthorizationKey:@"QVr4uK5tt6cu6dN"];
    [QBSettings setAuthorizationSecret:@"4thHbq-eyLVJrhe"];
    [QBSettings setAccountKey:@"gBv3BjZnFzkVPUZEqEXm"];

    // Live QuickBlox
//    [QBSettings setApplicationID:5];
//    [QBSettings setAuthorizationKey:@"6QQJq2FSKKzHK2-"];
//    [QBSettings setAuthorizationSecret:@"k9cTQAeFWrkEAWv"];
//   
//    [QBSettings setServerChatDomain:@"chatclickin.quickblox.com"];
//    [QBSettings setServerApiDomain:@"https://apiclickin.quickblox.com"];
//    [QBSettings setContentBucket:@"qb-clickin"];
//    [QBSettings setAccountKey:@"pFfuTqT7DxQiGUiqFABc"];
    
    
    [Crashlytics startWithAPIKey:@"b1409c5492785c7335d721bdcd1bb08ca9248515"];
    // Override point for customization after application launch.
    
    [QBSettings enableSessionExpirationAutoHandler:YES];
    
    [QBAuth createSessionWithDelegate:self];
    
    
    //check app version
//    if([[NSUserDefaults standardUserDefaults] stringForKey:@"AppVersion"]==nil)
//        [self fetchCurrentVersionOfApp];
//    else
//        [self compareCurrentVersionOfApp];
    
    //set up audio session
    //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
    
    /*
    bool isPlayingAudio=false;
    
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
    {
        isPlayingAudio = true;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    if(isPlayingAudio)
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
    else
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    
    
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    */
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    CFArrayRef addressBookData = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    
//    CFIndex count = CFArrayGetCount(addressBookData);
//    
//    NSMutableArray *contactsArray = [NSMutableArray new];
//    
//    for (CFIndex idx = 0; idx < count; idx++)
//    {
//        ABRecordRef person = CFArrayGetValueAtIndex(addressBookData, idx);
//        
//        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
//        
//        if (firstName)
//        {
//            NSDictionary *dict = [NSDictionary dictionaryWithObject:firstName forKey:@"name"];
//            [contactsArray addObject:dict];
//        }
//    }
//    CFRelease(addressBook);
//    CFRelease(addressBookData);
//    
//    NSLog(@"%@",contactsArray);

    // getting the unique key (if present ) from keychain , assuming "your app identifier" as a key
    NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
    if (retrieveuuid == nil)
    { // if this is the first time app lunching , create key for device
        NSString *uuid = [self createNewUUID];
        // save newly created key to Keychain
        [SSKeychain setPassword:uuid forService:@"your app identifier" account:@"user"];
        // this is the one time process
    }
    
    
    if (launchOptions != nil && [[[NSUserDefaults standardUserDefaults] stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
	{
		NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (userInfo != nil)
		{
			NSLog(@"Launched from push notification: %@", userInfo);
			
            if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CRA"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"chat"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"clk"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"media"] ||[[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"card"])
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"didFinishLaunchingWithOptions" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//                [alert show];
//                alert = nil;

                isFlowFromNotification = true;
                isAppLaunching = true;
                CenterViewController *center = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
                center.partner_QB_id=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"pQBid"]];
//              center.partner_pic=[NSString stringWithFormat:@"http://api.clickinapp.com/images/user_pics/%@/profile_pic.jpg",[[userInfo objectForKey:@"extra"]objectForKey:@"pid"]];// for aws
                center.partner_pic=[NSString stringWithFormat:@"https://s3.amazonaws.com/clickin-production/user_pics/%@_profile_pic.jpg",[[userInfo objectForKey:@"extra"]objectForKey:@"pid"]];// for live
                
                center.strRelationShipId=[[userInfo objectForKey:@"extra"]objectForKey:@"Rid"];
                center.partner_name=[[userInfo objectForKey:@"extra"]objectForKey:@"pname"];
                
                
                RelationInfo *relationObject = [[RelationInfo alloc] init];
                
                relationObject.partnerPhoneNumber = [[userInfo objectForKey:@"extra"]objectForKey:@"phn"];
                relationObject.partnerName = [[userInfo objectForKey:@"extra"]objectForKey:@"pname"];
                center.relationObject = relationObject;

                
                if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"clk"]] isEqualToString:@"<null>"])
                {
                    center.MyTotalClicks= @"0";
                }
                else
                {
                    center.MyTotalClicks = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"clk"]];
                }
                
                if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"uclk"]] isEqualToString:@"<null>"])
                {
                    center.FriendTotalClicks = @"0";
                }
                else
                {
                    center.FriendTotalClicks = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"uclk"]];
                }
                
                
                if(slideContainer)
                {
                    NSLog(@"in the if condition");
                    
                    //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"in the IF part" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
                    //                [alert show];
                    //                alert = nil;
                    UINavigationController *navigationController = slideContainer.centerViewController;
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:center.partner_QB_id forKey:@"LeftMenuPartnerQBId"];
                    navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [slideContainer.centerViewController pushViewController:center animated:NO];
                    [slideContainer setMenuState:MFSideMenuStateClosed];
                }
                else
                {
                    UINavigationController *nv = [[UINavigationController alloc]
                                                  initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                    [nv pushViewController:center animated:NO];
                    nv.navigationBarHidden = YES;
                    
                    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:center.partner_QB_id forKey:@"LeftMenuPartnerQBId"];
             
                    
                    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                    containerWithCenterViewController:nv
                                                                    leftMenuViewController:leftMenuViewController
                                                                    rightMenuViewController:rightMenuViewController];
                    nv.interactivePopGestureRecognizer.enabled = NO;
                    self.window.rootViewController = container;
                    slideContainer=container;
                }
            }
            
            else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CR"])
            {
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                nv.interactivePopGestureRecognizer.enabled = NO;
                self.window.rootViewController = container;
                slideContainer=container;
            }
            
            else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"cmt"])
            {
//                CommentsViewController *obj=[[CommentsViewController alloc] init];
//                obj.isNotificationSelected = @"true";
//                obj.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
//                obj.selectedNewsfeed = [[Newsfeed alloc] init];
//                obj.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                
                CommentStarCommonView *obj=[[CommentStarCommonView alloc] init];
                obj.isNotificationSelected = @"true";
                obj.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                obj.selectedNewsfeed = [[Newsfeed alloc] init];
                obj.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                
                
                if(slideContainer)
                {
                    NSLog(@"in the if condition");
                    
                    UINavigationController *navigationController = slideContainer.centerViewController;
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [slideContainer.centerViewController presentViewController:obj animated:YES completion:nil];
                    [slideContainer setMenuState:MFSideMenuStateClosed];
                }
                else
                {
                    
                    UINavigationController *nv = [[UINavigationController alloc]
                                                  initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                    
                    obj.isViewPushed = @"true";
                    [nv pushViewController:obj animated:true];
                    
                    nv.navigationBarHidden = YES;
                    
                    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                    
                    
                    
                    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                    containerWithCenterViewController:nv
                                                                    leftMenuViewController:leftMenuViewController
                                                                    rightMenuViewController:rightMenuViewController];
                    nv.interactivePopGestureRecognizer.enabled = NO;
                    self.window.rootViewController = container;
                    slideContainer=container;
                }
                
                obj=nil;
                
            }

            else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"str"])
            {
                if(slideContainer)
                {
                    NSLog(@"in the if condition");
                    
                    CommentStarCommonView *ObjNewsfeed=[[CommentStarCommonView alloc] init];
                    ObjNewsfeed.isNotificationSelected = @"true";
                    ObjNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    ObjNewsfeed.selectedNewsfeed = [[Newsfeed alloc] init];
                    ObjNewsfeed.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    
                    
//                    NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
//                    ObjNewsfeed.firstTimeLoad = @"yes";
//                    ObjNewsfeed.scrollToNewsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    
                    UINavigationController *navigationController = slideContainer.centerViewController;
                    
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    [controllers addObject:ObjNewsfeed];
                    navigationController.viewControllers = controllers;
                    navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [slideContainer setMenuState:MFSideMenuStateClosed];
                    ObjNewsfeed = nil;
                }
                else
                {
//                    NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
//                    ObjNewsfeed.firstTimeLoad = @"yes";
//                    ObjNewsfeed.scrollToNewsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    
                    CommentStarCommonView *ObjNewsfeed=[[CommentStarCommonView alloc] init];
                    ObjNewsfeed.isNotificationSelected = @"true";
                    ObjNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    ObjNewsfeed.selectedNewsfeed = [[Newsfeed alloc] init];
                    ObjNewsfeed.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                    
                    
                    UINavigationController *nv = [[UINavigationController alloc]
                                                  initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                    ObjNewsfeed.isViewPushed = @"true";
                    [nv pushViewController:ObjNewsfeed animated:NO];
                    nv.navigationBarHidden = YES;
                    
                    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                    containerWithCenterViewController:nv
                                                                    leftMenuViewController:leftMenuViewController
                                                                    rightMenuViewController:rightMenuViewController];
                    nv.interactivePopGestureRecognizer.enabled = NO;
                    self.window.rootViewController = container;
                    slideContainer=container;
                    ObjNewsfeed = nil;
                }
                
            }
            else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"FR"])
            {
                if(slideContainer)
                {
                    NSLog(@"in the if condition");
                    
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
                    
                    UINavigationController *navigationController = slideContainer.centerViewController;
                    
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    [controllers addObject:followerowner];
                    navigationController.viewControllers = controllers;
                    navigationController.interactivePopGestureRecognizer.enabled = NO;
                    [slideContainer setMenuState:MFSideMenuStateClosed];
                    followerowner = nil;
                }
                else
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
                    
                    
                    UINavigationController *nv = [[UINavigationController alloc]
                                                  initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                    [nv pushViewController:followerowner animated:NO];
                    nv.navigationBarHidden = YES;
                    
                    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                    containerWithCenterViewController:nv
                                                                    leftMenuViewController:leftMenuViewController
                                                                    rightMenuViewController:rightMenuViewController];
                    nv.interactivePopGestureRecognizer.enabled = NO;
                    self.window.rootViewController = container;
                    slideContainer=container;
                    followerowner = nil;
                }
                
            }
            else
            {
                
                
                NSString  *stringin;
                if(IS_IPAD)
                    stringin=@"Main_iPad";
                else
                    stringin=@"Main_iPhone";
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:stringin bundle:nil];
                UIViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"Home"];
                self.window.rootViewController = view;
                UINavigationController *navcon = [[UINavigationController alloc] init];
                [navcon pushViewController:view animated:NO];
                navcon.navigationBar.hidden=YES;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
                navcon.interactivePopGestureRecognizer.enabled = NO;
                self.window.rootViewController = navcon;
            }


            
		}
	}
    else
    {// ALSO CALLED IN CASE OF
        /*
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        NSLog(@"mixpanel.distinctId %@",mixpanel.distinctId);
        [mixpanel identify:str];
        */
        
        NSString  *stringin;
        if(IS_IPAD)
            stringin=@"Main_iPad";
        else
            stringin=@"Main_iPhone";
    
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:stringin bundle:nil];
        UIViewController *view = [storyBoard instantiateViewControllerWithIdentifier:@"Home"];
        self.window.rootViewController = view;
        UINavigationController *navcon = [[UINavigationController alloc] init];
        [navcon pushViewController:view animated:NO];
        navcon.navigationBar.hidden=YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        navcon.interactivePopGestureRecognizer.enabled = NO;
        self.window.rootViewController = navcon;
        
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor colorWithRed:60/255.0 green:112/255.0 blue:204/255.0 alpha:1];
    
    [self.window makeKeyAndVisible];
    
//    // Let the device know we want to receive push notifications
//	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    // enable push notifications old ios7.0 & ios 8 code
    //-- Set Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self iniAudio];
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

    NSLog(@"received notification%@",userInfo.description);
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    if(state == UIApplicationStateActive)
    {
        if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CRA"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CR"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"cmt"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"str"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"FR"])
        {
            //post notification to play notification sound
            //[[NSNotificationCenter defaultCenter] postNotificationName:Notification_PlaySound object:nil userInfo:Nil];
            
            if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CRA"])
            {
                //post notification to update owners relations
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_updateOwnerRelations object:nil userInfo:Nil];
            }
        }
    }
    else if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        
        if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CRA"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"chat"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"clk"] || [[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"media"] ||[[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"card"])
        {
            isFlowFromNotification = true;
            CenterViewController *center = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
            center.partner_QB_id=[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"pQBid"]];
//          center.partner_pic=[NSString stringWithFormat:@"http://api.clickinapp.com/images/user_pics/%@/profile_pic.jpg",[[userInfo objectForKey:@"extra"]objectForKey:@"pid"]];// for aws
            center.partner_pic=[NSString stringWithFormat:@"https://s3.amazonaws.com/clickin-production/user_pics/%@_profile_pic.jpg",[[userInfo objectForKey:@"extra"]objectForKey:@"pid"]];// for live
            center.strRelationShipId=[[userInfo objectForKey:@"extra"]objectForKey:@"Rid"];
            center.partner_name=[[userInfo objectForKey:@"extra"]objectForKey:@"pname"];
            
            RelationInfo *relationObject = [[RelationInfo alloc] init];
            
            relationObject.partnerPhoneNumber = [[userInfo objectForKey:@"extra"]objectForKey:@"phn"];
            relationObject.partnerName = [[userInfo objectForKey:@"extra"]objectForKey:@"pname"];
            center.relationObject = relationObject;
            
            if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"clk"]] isEqualToString:@"<null>"])
            {
                center.MyTotalClicks= @"0";
            }
            else
            {
                center.MyTotalClicks = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"clk"]];
            }
            
            if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"uclk"]] isEqualToString:@"<null>"])
            {
                center.FriendTotalClicks = @"0";
            }
            else
            {
                center.FriendTotalClicks = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"uclk"]];
            }
            
            
            
            if(slideContainer)
            {
                NSLog(@"allocated");
                
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"in the IF part" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//                [alert show];
//                alert = nil;
                UINavigationController *navigationController = slideContainer.centerViewController;
                
                NSArray *viewControlles = [navigationController viewControllers];
                BOOL isCenterAvailable=false;
                
                for (int i = 0 ; i <viewControlles.count; i++){
                    if ([[viewControlles objectAtIndex:i] isKindOfClass:[CenterViewController class]]) {
                        //Execute your code
                        
                        isCenterAvailable=true;
                        break;
                        
                    }
                }
                if(!isCenterAvailable)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:center.partner_QB_id forKey:@"LeftMenuPartnerQBId"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    ModelManager *modelmanager=[ModelManager modelManager];
                    modelmanager.chatManager.CenterMessageReceiveDelegate=center;
                    [slideContainer.centerViewController pushViewController:center animated:NO];
                    [slideContainer.centerViewController dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSArray *viewControlles = [navigationController viewControllers];
                    CenterViewController *obj ;
                    
                    for (int i = 0 ; i <viewControlles.count; i++){
                        if ([[viewControlles objectAtIndex:i] isKindOfClass:[CenterViewController class]]) {
                            //Execute your code
                            obj = (CenterViewController*)[viewControlles objectAtIndex:i];
                           
                            break;
                            
                        }
                    }
                    if(![obj.partner_QB_id isEqualToString:center.partner_QB_id])
                    {
                        
                        //ModelManager *modelmanager=[ModelManager modelManager];
                       // modelmanager.chatManager.CenterMessageReceiveDelegate=center;
                        [slideContainer.centerViewController popViewControllerAnimated:NO];
                        [slideContainer.centerViewController pushViewController:center animated:NO];
                        [slideContainer.centerViewController dismissViewControllerAnimated:YES completion:nil];
                        [[NSUserDefaults standardUserDefaults] setObject:center.partner_QB_id forKey:@"LeftMenuPartnerQBId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
               
                [slideContainer setMenuState:MFSideMenuStateClosed];
            }
            else
            {
                
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"in the else part" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//                [alert show];
//                alert = nil;
                
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                [nv pushViewController:center animated:NO];
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                [[NSUserDefaults standardUserDefaults] setObject:center.partner_QB_id forKey:@"LeftMenuPartnerQBId"];
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                
                self.window.rootViewController = container;
                slideContainer=container;
            }
        }
        else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"CR"])
        {
            if(slideContainer)
            {
                UINavigationController *navigationController = slideContainer.centerViewController;
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                ((profile_owner*)[controllers objectAtIndex:0]).isFromNotification = true;
                [slideContainer.centerViewController dismissViewControllerAnimated:YES completion:nil];
                [slideContainer setMenuState:MFSideMenuStateClosed];
            }
            else
            {
                profile_owner *profile = [[profile_owner alloc] initWithNibName:nil bundle:nil];
                profile.isFromNotification = true;
                
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:profile];
                
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                
                self.window.rootViewController = container;
                slideContainer=container;
            }


        }
        else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"cmt"])
        {
//            CommentsViewController *obj=[[CommentsViewController alloc] init];
//            obj.isNotificationSelected = @"true";
//            obj.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
//            obj.selectedNewsfeed = [[Newsfeed alloc] init];
//            obj.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
            
            CommentStarCommonView *obj=[[CommentStarCommonView alloc] init];
            obj.isNotificationSelected = @"true";
            obj.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
            obj.selectedNewsfeed = [[Newsfeed alloc] init];
            obj.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];

            
            
            if(slideContainer)
            {
                NSLog(@"in the if condition");
                
                UINavigationController *navigationController = slideContainer.centerViewController;
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                [slideContainer.centerViewController dismissViewControllerAnimated:NO completion:nil];
                
                [self performSelector:@selector(presentViewForCommentsPush:) withObject:obj afterDelay:0.3f];
                //[slideContainer.centerViewController presentViewController:obj animated:YES completion:nil];
                [slideContainer setMenuState:MFSideMenuStateClosed];
            }
            else
            {
                
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                [nv pushViewController:obj animated:true];
                obj.isViewPushed = @"true";
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                
                
                
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                
                self.window.rootViewController = container;
                slideContainer=container;
            }
            
            obj=nil;
            
        }
        else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"str"])
        {
            if(slideContainer)
            {
                NSLog(@"in the if condition");
                
//                NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
//                ObjNewsfeed.firstTimeLoad = @"yes";
//                ObjNewsfeed.scrollToNewsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                
                CommentStarCommonView *ObjNewsfeed=[[CommentStarCommonView alloc] init];
                ObjNewsfeed.isNotificationSelected = @"true";
                ObjNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                ObjNewsfeed.selectedNewsfeed = [[Newsfeed alloc] init];
                ObjNewsfeed.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                
                UINavigationController *navigationController = slideContainer.centerViewController;
                
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
//                [controllers addObject:ObjNewsfeed];
//                navigationController.viewControllers = controllers;
//                [slideContainer.centerViewController dismissViewControllerAnimated:YES completion:nil];
//                [slideContainer setMenuState:MFSideMenuStateClosed];
                
                [slideContainer.centerViewController dismissViewControllerAnimated:NO completion:nil];
                [self performSelector:@selector(presentViewForCommentsPush:) withObject:ObjNewsfeed afterDelay:0.3f];
                //[slideContainer.centerViewController presentViewController:obj animated:YES completion:nil];
                [slideContainer setMenuState:MFSideMenuStateClosed];
                
                ObjNewsfeed = nil;
            }
            else
            {
//                NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
//                ObjNewsfeed.firstTimeLoad = @"yes";
//                ObjNewsfeed.scrollToNewsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                
                CommentStarCommonView *ObjNewsfeed=[[CommentStarCommonView alloc] init];
                ObjNewsfeed.isNotificationSelected = @"true";
                ObjNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];
                ObjNewsfeed.selectedNewsfeed = [[Newsfeed alloc] init];
                ObjNewsfeed.selectedNewsfeed.newsfeedID = [NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Nid"]];

                
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                ObjNewsfeed.isViewPushed = @"true";
                [nv pushViewController:ObjNewsfeed animated:NO];
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                
                self.window.rootViewController = container;
                ObjNewsfeed = nil;
                slideContainer=container;
            }

        }
        else if([[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"extra"]objectForKey:@"Tp"]] isEqualToString:@"FR"])
        {
            if(slideContainer)
            {
                NSLog(@"in the if condition");
                
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

                UINavigationController *navigationController = slideContainer.centerViewController;
                
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                [controllers addObject:followerowner];
                navigationController.viewControllers = controllers;
                [slideContainer.centerViewController dismissViewControllerAnimated:YES completion:nil];
                [slideContainer setMenuState:MFSideMenuStateClosed];
                followerowner = nil;
            }
            else
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
                
                
                UINavigationController *nv = [[UINavigationController alloc]
                                              initWithRootViewController:[[profile_owner alloc] initWithNibName:nil bundle:nil]];
                [nv pushViewController:followerowner animated:NO];
                nv.navigationBarHidden = YES;
                
                LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
                NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
                MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                containerWithCenterViewController:nv
                                                                leftMenuViewController:leftMenuViewController
                                                                rightMenuViewController:rightMenuViewController];
                
                self.window.rootViewController = container;
                slideContainer=container;
                followerowner = nil;
            }
            
        }


    }
    
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token---%@", token);
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
}

-(void)presentViewForCommentsPush:(id)Object
{
    [slideContainer.centerViewController presentViewController:(CommentStarCommonView*)Object animated:YES completion:nil];

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[QBChat instance] logout];
    isChatLoggedIn = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endistyping" object:nil];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSDate *sessionExpiratioDate = [QBBaseModule sharedModule].tokenExpirationDate;
    NSDate *currentDate = [NSDate date];
    NSTimeInterval interval = [currentDate timeIntervalSinceDate:sessionExpiratioDate];
    
    [self CheckInternetConnection];
    if(interval > 0)
    {
        if(internetWorking == 0)
            [QBAuth createSessionWithDelegate:self];
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
        }
    }
    else if([[[NSUserDefaults standardUserDefaults] stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        if(internetWorking == 0)
        {
            // Models
            ModelManager *modelmanager=[ModelManager modelManager];
            ChatManager *chatmanager=modelmanager.chatManager;
            [QBChat instance].delegate = chatmanager;
            //post notification to create chat session
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateChatSession object:nil userInfo:Nil];
            // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
        }
    }
    
    /*
    //set audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionCategoryError = nil;
    if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
    {
        [session setCategory:AVAudioSessionCategoryAmbient error:&sessionCategoryError];
        [[MPMusicPlayerController iPodMusicPlayer] play];
    }
    else
    {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionCategoryError];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        
    }
    
    [session setActive:YES error:nil];
    */
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatLoginStatusChanged object:nil userInfo:Nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

  // [QBAuth createSessionWithDelegate:self];
    
    
    //reset badge count
    
    application.applicationIconBadgeNumber = 0;
    
    [self CheckInternetConnection];
    if(internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"chats/resetbadgecount"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSError *error;
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",nil];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
//      NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//      NSLog(@"responseString %@",[request responseString]);
        
    }
    
    
    //check app version
//    if([[NSUserDefaults standardUserDefaults] stringForKey:@"AppVersion"]==nil)
//        [self fetchCurrentVersionOfApp];
//    else
    [self compareCurrentVersionOfApp];
    
    
}


- (void)completedWithResult:(Result *)result
{
    if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class] && [[[NSUserDefaults standardUserDefaults] stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
        [QBUsers logInWithUserLogin:[Prefs stringForKey:@"QBUserName"] password:[Prefs stringForKey:@"QBPassword"] delegate:self];
    }
    if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
//        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//        QBUUser *currentUser = [QBUUser user];
//        currentUser.ID = [prefs integerForKey:@"SenderId"]; // your current user's ID
//        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
//        [QBChat instance].delegate = self;
//        [[QBChat instance] loginWithUser:currentUser];
        
        
        // Models
        ModelManager *modelmanager=[ModelManager modelManager];
        ChatManager *chatmanager=modelmanager.chatManager;
         [QBChat instance].delegate = chatmanager;
        //post notification to create chat session
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CreateChatSession object:nil userInfo:Nil];
        
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark audio 
-(void)iniAudio
{ // set up Audio so that user can play own music
    
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
}
#pragma mark -FaceBook

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


#pragma mark -Check App Version

-(void)fetchCurrentVersionOfApp
{
    [self CheckInternetConnection];
    if(internetWorking == 0)//0: internet working
    {
        version = @"";
        //change app ID
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=901882470"];
        ASIFormDataRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
        [versionRequest setDidFinishSelector:@selector(requestFinished_VersionInfo:)];
        [versionRequest setRequestMethod:@"GET"];
        [versionRequest setDelegate:self];
        [versionRequest setTimeOutSeconds:180];
        [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [versionRequest startAsynchronous];
    }
}

- (void)requestFinished_VersionInfo:(ASIHTTPRequest *)versionRequest
{
    //Response string of our REST call
    NSLog(@"responseStatusCode %i",[versionRequest responseStatusCode]);
    NSLog(@"responseString %@",[versionRequest responseString]);
    if([versionRequest responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[versionRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
    
    
        NSArray *configData = [jsonResponse valueForKey:@"results"];
        
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"AppVersion"];
        }
    }
}



-(void)compareCurrentVersionOfApp
{
    [self CheckInternetConnection];
    if(internetWorking == 0)//0: internet working
    {
        version = @"";
        //change app ID
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=901882470"];
        ASIFormDataRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
        [versionRequest setDidFinishSelector:@selector(requestFinished_CompareVersion:)];
        [versionRequest setRequestMethod:@"GET"];
        [versionRequest setDelegate:self];
        [versionRequest setTimeOutSeconds:180];
        [versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
        [versionRequest startAsynchronous];
    }
}
    
- (void)requestFinished_CompareVersion:(ASIHTTPRequest *)versionRequest
{
    //Response string of our REST call
    NSLog(@"responseStatusCode %i",[versionRequest responseStatusCode]);
    NSLog(@"responseString %@",[versionRequest responseString]);
    if([versionRequest responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[versionRequest responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        
        NSArray *configData = [jsonResponse valueForKey:@"results"];
        
        for (id config in configData)
        {
            version = [config valueForKey:@"version"];
        }
        
        NSString *current_version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        //Check your version with the version in app store
        if (![version isEqualToString:current_version])
        {
            NSArray *subVersions = [version componentsSeparatedByString:@"."];
            if(subVersions.count==2)
            {
//                UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:@"New Version!!" message: @"A new version of Clickin' is available to download" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Download", nil];
//                createUserResponseAlert.delegate = self;
//                [createUserResponseAlert show];
//                createUserResponseAlert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"New Version!!"
                                                                                description:@"A new version of Clickin' is available to download"
                                                                              okButtonTitle:@"Download"];
                alertView.delegate = self;
                [alertView show];
                alertView = nil;
            }
            subVersions = nil;
        }
    }
}

//uialertview delegates


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"ButtonType %d", buttonType);
    
    NSString *iTunesLink = @"https://itunes.apple.com/us/app/clickin-keep-scoring/id901882470?ls=1&mt=8"; // @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=901882470&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    
    //[alertView dismiss:buttonType];
}

/*
 - (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the download buttons
    if (buttonIndex == 0)
    {
        //change itunes link
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/clickin-keep-scoring/id901882470?ls=1&mt=8"; // @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=901882470&mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}
*/

#pragma mark Internet Reachability Methods

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
	if(curReach == internetReach)
	{
		NetworkStatus netStatus = [curReach currentReachabilityStatus];
		switch (netStatus)
		{
			case NotReachable:
			{
				self.internetWorking = -1;
				break;
			}
			case ReachableViaWiFi:
			{
				self.internetWorking = 0;
				break;
			}
			case ReachableViaWWAN:
			{
				self.internetWorking = 0;
				break;
				
			}
		}
	}
}


-(void)CheckInternetConnection
{
	internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability: internetReach];
}



@end
