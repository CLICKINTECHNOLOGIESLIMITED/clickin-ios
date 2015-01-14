//
//  AppDelegate.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MFSideMenu.h"
#import "Mixpanel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,QBActionStatusDelegate,UIAlertViewDelegate,MODropAlertViewDelegate>
{
    Reachability *internetReach;
    int internetWorking;
    NSString *str_App_DisplayName;
    BOOL isFlowFromNotification;
    bool isAppLaunching; //for app launched
    bool play_chatAnimation; // for bouncing animations of chat messages
    
    NSString *version;
}

@property bool isChatLoggedIn;

//google analytics code
@property (nonatomic, retain) id tracker;
@property BOOL isFlowFromNotification;
@property bool isAppLaunching;
@property bool play_chatAnimation;
@property bool isAppLaunchedFirstTime;
@property bool isRelationsFetchedFirstTime;
@property (strong, nonatomic)NSString *str_App_DisplayName;

@property int unreadNotificationsCount;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *internetReach;
@property int internetWorking;
@property (strong,nonatomic)MFSideMenuContainerViewController *slideContainer;

-(void) updateInterfaceWithReachability: (Reachability*) curReach;
-(void)CheckInternetConnection;

@end
