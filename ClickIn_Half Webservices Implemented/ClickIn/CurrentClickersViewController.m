//
//  CurrentClickersViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 24/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "CurrentClickersViewController.h"


#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "SSKeychain.h"
#import "MFSideMenu.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import <AddressBook/AddressBook.h>
#import "UIImageView+WebCache.h"
#import "NotificationsViewController.h"
#import "InvitationViewController.h"


@interface CurrentClickersViewController ()

@end

@implementation CurrentClickersViewController
@synthesize arrContacts;
@synthesize isFromMenu;

AppDelegate *appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)appplicationIsActive:(id)sender
{
    [activity hide];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
 
    intValue = 1;
    // Do any additional setup after loading the view from its nib.
    float ScreenHeight;
    if (IS_IPHONE_5)
        ScreenHeight=568;
    else
        ScreenHeight=480;
    
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight)];
    backgroundView.image=[UIImage imageNamed:@"640x960followFriends.png"];
    
    if(IS_IPHONE_5)
        backgroundView.image=[UIImage imageNamed:@"1136x960followFriends.png"];
    
    [self.view addSubview:backgroundView];
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(callAddressBookContacts) withObject:nil afterDelay:0.1];
    
    
    
    //  tblView = nil;
    
    //...........................................................................................................................
    
    // -----Top Tab Buttons------
    
    phonebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phonebookBtn addTarget:self action:@selector(phonebookBtnPressed)
           forControlEvents:UIControlEventTouchUpInside];
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_pink.png"] forState:UIControlStateNormal];
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateHighlighted];
    if(IS_IPHONE_5)
        phonebookBtn.frame = CGRectMake(23.5, ScreenHeight*0.26, 136.5, 34);
    else
        phonebookBtn.frame = CGRectMake(23.5, ScreenHeight*0.28, 136.5, 34);
    [self.view addSubview:phonebookBtn];
    
    facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookBtn addTarget:self action:@selector(facebookBtnPressed)
          forControlEvents:UIControlEventTouchUpInside];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        facebookBtn.frame = CGRectMake(160, ScreenHeight*0.26, 136.5, 34);
    else
        facebookBtn.frame = CGRectMake(160, ScreenHeight*0.28, 136.5, 34);
    [self.view addSubview:facebookBtn];
    
    twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterBtn addTarget:self action:@selector(twitterBtnPressed)
         forControlEvents:UIControlEventTouchDown];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, ScreenHeight*0.26, 67, 33);
    else
        twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, ScreenHeight*0.28, 67, 33);
   // [self.view addSubview:twitterBtn];
    
    googleplusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [googleplusBtn addTarget:self action:@selector(googleplusBtnPressed)
            forControlEvents:UIControlEventTouchDown];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, ScreenHeight*0.26, 66, 33);
    else
        googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, ScreenHeight*0.28, 66, 33);
   // [self.view addSubview:googleplusBtn];
    
    
    scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollToTopBtn addTarget:self action:@selector(scrollToTopBtnPressed)
             forControlEvents:UIControlEventTouchDown];
    [scrollToTopBtn setBackgroundImage:nil forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, ScreenHeight*0.15, 250, 52);
    else
        scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, ScreenHeight*0.1, 250, 52);
    scrollToTopBtn.backgroundColor=[UIColor clearColor];
    //[self.view addSubview:scrollToTopBtn];
    
    //---Bottom Buttons---
    
    inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteBtn addTarget:self action:@selector(btn_InviteButtonAction:)forControlEvents:UIControlEventTouchDown];
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"invite.png"] forState:UIControlStateNormal];
    [inviteBtn setBackgroundImage:[UIImage imageNamed:@"invitegrey.png"] forState:UIControlStateHighlighted];
    inviteBtn.frame = CGRectMake(self.view.frame.size.width/2 - 36, ScreenHeight-44, 72 , 44);
   // [self.view addSubview:inviteBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, ScreenHeight-56, 270, 56)];
    imgView.image = [UIImage imageNamed:@"back-next.png"];
    [self.view addSubview:imgView];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnPressed)
      forControlEvents:UIControlEventTouchDown];
    backBtn.frame = CGRectMake(25, ScreenHeight-50, 100, 50);
    [self.view addSubview:backBtn];
    
    UIButton *NextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [NextButton addTarget:self action:@selector(NextButtonPressed)
      forControlEvents:UIControlEventTouchDown];
    NextButton.frame = CGRectMake(inviteBtn.frame.origin.x+72, ScreenHeight-50, 100, 50);
    [self.view addSubview:NextButton];
    
    if([isFromMenu isEqualToString:@"true"])
    {
        backBtn.hidden = YES;
        NextButton.hidden = YES;
        UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        BackBtn.backgroundColor = [UIColor clearColor];
        [BackBtn setBackgroundImage:[UIImage imageNamed:@"Back_blue.png"] forState:UIControlStateNormal];
        [BackBtn addTarget:self
                    action:@selector(backBtnPressed)
          forControlEvents:UIControlEventTouchUpInside];
        if (IS_IPHONE_5)
            BackBtn.frame = CGRectMake(160 - 271/2.0, 568-56, 271, 56.0);
        else
            BackBtn.frame = CGRectMake(160 - 271/2.0, 480-56, 271, 56.0);
        [self.view addSubview:BackBtn];
    }
}

-(void)callAddressBookContacts
{
    arrContacts = [[NSArray alloc] initWithArray:[self collectAddressBookContacts]];
    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    arrContacts = [arrContacts sortedArrayUsingDescriptors:sortDescriptors];
    
    existingContacts=[[NSMutableArray alloc] init];
    existingNames = [[NSMutableArray alloc] init];
    existingPhotos = [[NSMutableArray alloc] init];
    existingPhotosUrl = [[NSMutableArray alloc] init];
    existingFollowing = [[NSMutableArray alloc] init];
    
    selectedContacts = [[NSMutableArray alloc] init];
    invitedContacts=[[NSMutableArray alloc] init];
    
    
    NSMutableArray *contactNums=[[NSMutableArray alloc] init];
    
    for(int i=0;i<arrContacts.count;i++)
        [contactNums addObject:[[arrContacts objectAtIndex:i] valueForKey:@"phoneNumber"]];
    
    [self getExistingContacts:contactNums];
    
    for(int i=0;i<existingContacts.count;i++)
    {
        int index=[contactNums indexOfObject:[existingContacts objectAtIndex:i]];
        [existingNames addObject:[[arrContacts objectAtIndex:index] objectForKey:@"name"]];
        [existingPhotos addObject:[[arrContacts objectAtIndex:index] objectForKey:@"photo"]];
    }
    
    for(int i=0;i<nonExisitingContacts.count;i++)
    {
        int index=[contactNums indexOfObject:[nonExisitingContacts objectAtIndex:i]];
        [nonExisitingNames addObject:[[arrContacts objectAtIndex:index] objectForKey:@"name"]];
        [nonExisitingPhotos addObject:[[arrContacts objectAtIndex:index] objectForKey:@"photo"]];
    }
    
    tblViewFBUsers = [[UITableView alloc] initWithFrame:CGRectMake(30,240,260,260) style:UITableViewStylePlain];
    tblViewFBUsers.dataSource = self;
    tblViewFBUsers.delegate = self;
    tblViewFBUsers.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblViewFBUsers.backgroundColor=[UIColor clearColor];
    tblViewFBUsers.hidden = YES;
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            tblViewFBUsers.frame = CGRectMake(30,220+30,260,345-30-70);
        else
            tblViewFBUsers.frame = CGRectMake(30,175+40+20,260,205);
    }
    else
    {
        if (IS_IPHONE_5)
            tblViewFBUsers.frame = CGRectMake(30,210+30,260,250);
        else
            tblViewFBUsers.frame = CGRectMake(30,165+30,260,225);
    }
    [self.view addSubview:tblViewFBUsers];
    
    tblView = [[UITableView alloc] initWithFrame:CGRectMake(30,240,260,260) style:UITableViewStylePlain];
    tblView.dataSource = self;
    tblView.delegate = self;
    tblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblView.backgroundColor=[UIColor clearColor];
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            tblView.frame = CGRectMake(30,220+30,260,345-30-50);
        else
            tblView.frame = CGRectMake(30,175+40+20,260,205);
    }
    else
    {
        if (IS_IPHONE_5)
            tblView.frame = CGRectMake(30,210+30,260,250);
        else
            tblView.frame = CGRectMake(30,165+30,260,225);
    }
    [self.view addSubview:tblView];
}


- (profile_owner *)demoController
{
    return [[profile_owner alloc] initWithNibName:Nil bundle:nil];
}

- (UINavigationController *)navigationControllers
{
    UINavigationController *nv = [[UINavigationController alloc]
                                  initWithRootViewController:[self demoController]];
    nv.navigationBarHidden = YES;
    return nv;
}

-(void) phonebookBtnPressed
{
   // [[Mixpanel sharedInstance] track:@"FindFriendsThroughPhonebook"];
    
    [[Mixpanel sharedInstance] track:@"LeftMenuFindFriendsButtonClicked" properties:@{@"Activity":@"FindFriendsThroughPhonebook"}];
    
    intValue = 1;
    tblViewFBUsers.hidden = YES;
    tblView.hidden = NO;
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_pink.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
  ///  [self callAddressBookContacts];
}


-(void) facebookBtnPressed
{
    //[[Mixpanel sharedInstance] track:@"FindFriendsThroughFacebook"];
    [[Mixpanel sharedInstance] track:@"LeftMenuFindFriendsButtonClicked" properties:@{@"Activity":@"FindFriendsThroughFacebook"}];
    tblView.hidden=YES;
    tblViewFBUsers.hidden=NO;
    intValue = 2;
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_pinkd.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    NSArray *permissions =
    [NSArray arrayWithObjects:@"publish_stream",@"publish_actions",nil];
    
    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error)
     {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            [activity hide];
            //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            
            NSLog(@"%@",session.accessTokenData.accessToken);
            
            FBSession.activeSession = session;
            
            appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate performSelector:@selector(CheckInternetConnection)];
            if(appDelegate.internetWorking == 0)//0: internet working
            {
                NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/fetchfbfriends"];
                NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                
                NSError *error;
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSDictionary *Dictionary;
                Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",session.accessTokenData.accessToken,@"access_token",nil];
                
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
                    if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User have facebook friend(s)."])
                    {
                        FBusersOnCLickin = [[NSArray arrayWithArray:[jsonResponse objectForKey:@"fbfriends"]] mutableCopy];
                        [tblViewFBUsers reloadData];
//                        [selectedContacts removeAllObjects];
//                        [tblView reloadData];
//                        [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        
//                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Invitation Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                        alert = nil;
                    }
                }
                else if([request responseStatusCode] == 500)
                {
                    NSError *error = nil;
                    NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];

                    if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User don't have facebook friend."])
                    {
                        
                    }
                }
                else if([request responseStatusCode] == 401)
                {
                    NSError *error = nil;
                    NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
                    if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
                    {
//                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                        [alert show];
//                        alert = nil;
                        
                        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                        description:@"User Token is not valid"
                                                                                      okButtonTitle:@"OK"];
                        alertView.delegate = nil;
                        [alertView show];
                        alertView = nil;
                    }
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
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
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



-(void) twitterBtnPressed
{
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
}


-(void) googleplusBtnPressed
{
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplus.png"] forState:UIControlStateNormal];
}

-(void) scrollToTopBtnPressed
{
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


-(void)BackBtnAction
{
    
    
}


- (void) backBtnPressed
{
    if([isFromMenu isEqualToString:@"true"])
    {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
//        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//        [navigationController popViewControllerAnimated:YES];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (void) NextButtonPressed
{
    if([isFromMenu isEqualToString:@"true"])
    {
        InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
        sendinvite.isFromMenu = @"true";
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        [navigationController pushViewController:sendinvite animated:YES];
        sendinvite = nil;
    }
    
    else
    {

        if(existingFollowing.count == 0 && FBusersOnCLickin == 0)
        {
            InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
            
            sendinvite.arrContacts = [[NSArray alloc] init];
            
            sendinvite.existingContacts=[[NSMutableArray alloc] init];
            sendinvite.existingNames = [[NSMutableArray alloc] init];
            sendinvite.existingPhotos = [[NSMutableArray alloc] init];
            sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
            sendinvite.existingFollowing = [[NSMutableArray alloc] init];
            sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
            sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
            sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
            
            sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
            [sendinvite.existingContacts addObjectsFromArray:existingContacts];
            [sendinvite.existingNames addObjectsFromArray:existingNames];
            [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
            [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
            //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
            [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
            [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
            [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
            
            [self.navigationController pushViewController:sendinvite animated:YES];
        
        }
        else if(existingFollowing.count != 0)
        {
            if([existingFollowing containsObject:@"1"])
            {
                InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
                
                sendinvite.arrContacts = [[NSArray alloc] init];
                
                sendinvite.existingContacts=[[NSMutableArray alloc] init];
                sendinvite.existingNames = [[NSMutableArray alloc] init];
                sendinvite.existingPhotos = [[NSMutableArray alloc] init];
                sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
                sendinvite.existingFollowing = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
                
                sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
                [sendinvite.existingContacts addObjectsFromArray:existingContacts];
                [sendinvite.existingNames addObjectsFromArray:existingNames];
                [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
                [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
                //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
                [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
                [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
                [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
                
                [self.navigationController pushViewController:sendinvite animated:YES];
            }
            else
            {
                for(int i = 0 ; i < FBusersOnCLickin.count ; i++)
                {
                    if([[[FBusersOnCLickin objectAtIndex:i] objectForKey:@"follow_status"] isEqualToString:@"pending"])
                    {
                        is_FbUsersOnClickin = true;
                        break;
                    }
                }
                
                if(is_FbUsersOnClickin == true)
                {
                    InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
                    
                    sendinvite.arrContacts = [[NSArray alloc] init];
                    
                    sendinvite.existingContacts=[[NSMutableArray alloc] init];
                    sendinvite.existingNames = [[NSMutableArray alloc] init];
                    sendinvite.existingPhotos = [[NSMutableArray alloc] init];
                    sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
                    sendinvite.existingFollowing = [[NSMutableArray alloc] init];
                    sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
                    sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
                    sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
                    
                    sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
                    [sendinvite.existingContacts addObjectsFromArray:existingContacts];
                    [sendinvite.existingNames addObjectsFromArray:existingNames];
                    [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
                    [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
                    //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
                    [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
                    [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
                    [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
                    
                    [self.navigationController pushViewController:sendinvite animated:YES];
                }
                else
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You Haven't Followed Anyone, Your friends are sharing clicks and cards on Clickin'. Follow them to see what they are sharing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"SKIP",nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"You Haven't Followed Anyone, Your friends are sharing clicks and cards on Clickin'. Follow them to see what they are sharing"
                                                                                  okButtonTitle:@"SKIP"
                                                                              cancelButtonTitle:@"OK"];
                    
                    alertView.delegate = self;
                    [alertView show];
                    alertView = nil;
                }
            }
            
        }
        else if(FBusersOnCLickin.count != 0)
        {
          
            for(int i = 0 ; i < FBusersOnCLickin.count ; i++)
            {
                if([[[FBusersOnCLickin objectAtIndex:i] objectForKey:@"follow_status"] isEqualToString:@"pending"])
                {
                    is_FbUsersOnClickin = true;
                    break;
                }
            }
            
            if(is_FbUsersOnClickin == true)
            {
                InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
                
                sendinvite.arrContacts = [[NSArray alloc] init];
                
                sendinvite.existingContacts=[[NSMutableArray alloc] init];
                sendinvite.existingNames = [[NSMutableArray alloc] init];
                sendinvite.existingPhotos = [[NSMutableArray alloc] init];
                sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
                sendinvite.existingFollowing = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
                sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
                
                sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
                [sendinvite.existingContacts addObjectsFromArray:existingContacts];
                [sendinvite.existingNames addObjectsFromArray:existingNames];
                [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
                [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
                //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
                [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
                [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
                [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
                
                [self.navigationController pushViewController:sendinvite animated:YES];
            }
            else
            {
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"You Haven't Followed Anyone, Your friends are sharing clicks and cards on Clickin'. Follow them to see what they are sharing" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"SKIP",nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"You Haven't Followed Anyone, Your friends are sharing clicks and cards on Clickin'. Follow them to see what they are sharing"
                                                                              okButtonTitle:@"SKIP"
                                                                          cancelButtonTitle:@"OK"];
                
                alertView.delegate = self;
                [alertView show];
                alertView = nil;
            }
        }

       
    }
}


-(void) getExistingContacts:(NSArray*)contactArray
{
   
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/checkregisteredfriends"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        //      NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        
        // NSString *countrydevice =  [[UIDevice currentDevice] model];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",contactArray,@"phone_nos",nil];
        
        
        
        // NSLog(@"%@",Dictionary.description);
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Phone nos. listed."])
            {
                
                NSArray *TempArray = [[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"phone_nos"]];
                
                for(int i=0;i<TempArray.count;i++)
                {
                    if([[[TempArray objectAtIndex:i] objectForKey:@"exists"] integerValue]==0)
                    {
//                        [nonExisitingContacts addObject:[[TempArray objectAtIndex:i] objectForKey:@"phone_no"]];
                    }
                    else if([[[TempArray objectAtIndex:i] objectForKey:@"exists"] integerValue]==1)
                    {
                        [existingContacts addObject:[[TempArray objectAtIndex:i] objectForKey:@"phone_no"]];
                        if(![[[TempArray objectAtIndex:i] objectForKey:@"user_pic"] isEqual:[NSNull null]] )
                            [existingPhotosUrl addObject:[[TempArray objectAtIndex:i] objectForKey:@"user_pic"]];
                        else
                            [existingPhotosUrl addObject:@"-"];
                        if([[[TempArray objectAtIndex:i] objectForKey:@"following"] integerValue]==1)
                            [existingFollowing addObject:@"1"];
                        else
                            [existingFollowing addObject:@"0"];
                    }
                }
            }
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is not valid"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
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


-(void)btn_InviteButtonAction:(id)sender
{
    
    [invitedContacts addObjectsFromArray:selectedContacts];
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/inviteandfollowusers"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        //      NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        
        // NSString *countrydevice =  [[UIDevice currentDevice] model];
        
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",selectedContacts,@"followee_phone_nos",nil];
        
        
        
        //NSLog(@"%@",Dictionary.description);
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following users"])
            {
                
                /*
                 [(UIButton*)sender setEnabled:false];
                 [(UIButton*)sender setHidden:true];
                 [existingFollowing replaceObjectAtIndex:indexPath.row withObject:@"1"];
                 [tblView reloadData];
                 [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];*/
                
                [selectedContacts removeAllObjects];
                
                
                [tblView reloadData];
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Click sent - waiting for them to accept" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Click sent - waiting for them to accept"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
            
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is not valid"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
 
    [activity hide];
    
}

-(void)callSlideMenu
{
    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationControllers]
                                                    leftMenuViewController:leftMenuViewController
                                                    
                                                    rightMenuViewController:rightMenuViewController];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).slideContainer=container;
    
    [self presentViewController:container animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark UIAlertView delegate

- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if (buttonType == 0)
    {
        InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
        
        sendinvite.arrContacts = [[NSArray alloc] init];
        
        sendinvite.existingContacts=[[NSMutableArray alloc] init];
        sendinvite.existingNames = [[NSMutableArray alloc] init];
        sendinvite.existingPhotos = [[NSMutableArray alloc] init];
        sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
        sendinvite.existingFollowing = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
        
        sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
        [sendinvite.existingContacts addObjectsFromArray:existingContacts];
        [sendinvite.existingNames addObjectsFromArray:existingNames];
        [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
        [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
        //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
        [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
        [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
        [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
        
        [self.navigationController pushViewController:sendinvite animated:YES];
    }
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:Nil bundle:nil];
        
        sendinvite.arrContacts = [[NSArray alloc] init];
        
        sendinvite.existingContacts=[[NSMutableArray alloc] init];
        sendinvite.existingNames = [[NSMutableArray alloc] init];
        sendinvite.existingPhotos = [[NSMutableArray alloc] init];
        sendinvite.existingPhotosUrl = [[NSMutableArray alloc] init];
        sendinvite.existingFollowing = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingContacts = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingNames = [[NSMutableArray alloc] init];
        sendinvite.nonExisitingPhotos = [[NSMutableArray alloc] init];
        
        sendinvite.arrContacts = [NSArray arrayWithArray:arrContacts];
        [sendinvite.existingContacts addObjectsFromArray:existingContacts];
        [sendinvite.existingNames addObjectsFromArray:existingNames];
        [sendinvite.existingPhotos addObjectsFromArray:existingPhotos];
        [sendinvite.existingPhotosUrl addObjectsFromArray:existingPhotosUrl];
        //[sendinvite.existingFollowing addObjectsFromArray:existingFollowing];
        [sendinvite.nonExisitingContacts addObjectsFromArray:nonExisitingContacts];
        [sendinvite.nonExisitingNames addObjectsFromArray:nonExisitingNames];
        [sendinvite.nonExisitingPhotos addObjectsFromArray:nonExisitingPhotos];
        
        [self.navigationController pushViewController:sendinvite animated:YES];
    }
}*/

#pragma mark -
#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView ==tblViewFBUsers)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblViewFBUsers)
    {
        if(FBusersOnCLickin.count == 0)
        return 1;
        else
        return [FBusersOnCLickin count];
    }
    else
    {
        if(section==0)
        {
            if(existingContacts.count==0)
                return 1;
            else
                return [existingContacts count];
        }
        else
            return [nonExisitingContacts count];
    }
    return 0;
}


/*- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 2)];
    //footerView.backgroundColor=[UIColor blackColor];
    //return footerView;
    return nil;
}
*/
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
 {
 if(section==0)
 return @"FRIENDS ALREADY ON CLICKIN";
 else
 return @"GET THEM TO START CLICKIN";
 }*/
/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:11]];
    NSString *string;
    if(section==0)
        string=@"FRIENDS ALREADY ON CLICKIN";
    else
        string=@"GET THEM TO START CLICKIN";
    
    [label setText:string];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor lightGrayColor];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]]; //your background color...
    return nil;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // if(tableView ==tblViewFBUsers)
    static NSString *CellIdentifier1 = @"Cell_Section1";
    static NSString *CellIdentifier2 = @"Cell_Section2";
    
    UITableViewCell *cell;
    
    if(indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    }
    else if(indexPath.section==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    }
    
    if (cell == nil)
    {
        if(indexPath.section==0)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            UILabel *contactName = [[UILabel alloc] init];
            [contactName setFrame:CGRectMake(50, 8, 130, 25)];
            [contactName setFont:[UIFont systemFontOfSize:14.0]];
            [contactName setTextColor:[UIColor blackColor]];
            contactName.textAlignment=NSTextAlignmentLeft;
            contactName.numberOfLines=1;
            contactName.adjustsFontSizeToFitWidth=YES;
            contactName.minimumScaleFactor=0.25f;
            contactName.tag=11111;
            contactName.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14.0];
            [cell addSubview:contactName];
            
            UIImageView *photoImageView = [[UIImageView alloc] init];
            [photoImageView setFrame:CGRectMake(2, 1, 40, 40)];
            photoImageView.tag=22222;
            [cell addSubview:photoImageView];
            
            if(intValue == 2)
            {
                if(FBusersOnCLickin.count>0)
                {
                    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    followBtn.frame = CGRectMake(185, 10 , 70 , 22);
                    followBtn.tag=33333;
                    [followBtn addTarget:self action:@selector(followBtnPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
                    [followBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                    
                    //                if([[existingFollowing objectAtIndex:indexPath.row] isEqualToString:@"1"])
                    //                {
                    //                    [followBtn setEnabled:false];
                    //                    followBtn.hidden=true;
                    //                }
                    
                    [cell.contentView addSubview:followBtn];
                }
            }
            else
            {
                if(existingContacts.count>0)
                {
                    UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    followBtn.frame = CGRectMake(185, 10 , 70 , 22);
                    followBtn.tag=33333;
                    [followBtn addTarget:self action:@selector(followBtnPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
                    [followBtn setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                    
                    //                if([[existingFollowing objectAtIndex:indexPath.row] isEqualToString:@"1"])
                    //                {
                    //                    [followBtn setEnabled:false];
                    //                    followBtn.hidden=true;
                    //                }
                    [cell.contentView addSubview:followBtn];
                }
            }
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            
            UILabel *contactName = [[UILabel alloc] init];
            [contactName setFrame:CGRectMake(50, 8, 130, 25)];
            [contactName setFont:[UIFont systemFontOfSize:14.0]];
            [contactName setTextColor:[UIColor blackColor]];
            contactName.textAlignment=NSTextAlignmentLeft;
            contactName.numberOfLines=1;
            contactName.adjustsFontSizeToFitWidth=YES;
            contactName.minimumScaleFactor=0.25f;
            contactName.tag=11111;
            [cell addSubview:contactName];
            
            UIImageView *photoImageView = [[UIImageView alloc] init];
            [photoImageView setFrame:CGRectMake(2, 1, 40, 40)];
            photoImageView.tag=22222;
            [cell addSubview:photoImageView];
            
            
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBtn.tag=44444;
            [checkBtn addTarget:self action:@selector(checkBtnPressed:)
               forControlEvents:UIControlEventTouchUpInside];
          
            checkBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            checkBtn.frame = CGRectMake(220, 6 , 30 , 30);
            [cell.contentView addSubview:checkBtn];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.section==0)
    {
        if(intValue == 2)
        {
            if(FBusersOnCLickin.count == 0)
            {
                ((UILabel*)[cell viewWithTag:11111]).text =@"No Data Found";
                ((UIImageView*)[cell viewWithTag:22222]).image = nil;
                ((UIButton*)[cell.contentView viewWithTag:33333]).hidden=true;
            }
            else
            {
                if([[FBusersOnCLickin objectAtIndex:indexPath.row]objectForKey:@"fb_user_pic_url"] == nil)
                {
                    [(UIImageView*)[cell viewWithTag:22222] sd_setImageWithURL:[NSURL URLWithString:[[FBusersOnCLickin objectAtIndex:indexPath.row]objectForKey:@"fb_user_pic_url"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                }
                else
                    [(UIImageView*)[cell viewWithTag:22222] sd_setImageWithURL:[NSURL URLWithString:[[FBusersOnCLickin objectAtIndex:indexPath.row]objectForKey:@"fb_user_pic_url"]]];
                
                ((UILabel*)[cell viewWithTag:11111]).text = [[FBusersOnCLickin objectAtIndex:indexPath.row]objectForKey:@"fb_name"];
                
                if([[[FBusersOnCLickin objectAtIndex:indexPath.row] objectForKey:@"follow_status"] isEqualToString:@"notrequested"])
                {
                    [(UIButton*)[cell.contentView viewWithTag:33333] setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                }
                else if([[[FBusersOnCLickin objectAtIndex:indexPath.row] objectForKey:@"follow_status"] isEqualToString:@"pending"])
                {
                    [(UIButton*)[cell.contentView viewWithTag:33333] addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                    [(UIButton*)[cell.contentView viewWithTag:33333] setBackgroundImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];
                }
                else if([[[FBusersOnCLickin objectAtIndex:indexPath.row] objectForKey:@"follow_status"] isEqualToString:@"accepted"])
                {
                    [(UIButton*)[cell.contentView viewWithTag:33333] addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
                    [(UIButton*)[cell.contentView viewWithTag:33333] setBackgroundImage:[UIImage imageNamed:@"profile_following_button.png"] forState:UIControlStateNormal];
                }
            }
        }
        else if (intValue == 1)
        {
            if(existingContacts.count==0)
            {
                ((UILabel*)[cell viewWithTag:11111]).text =@"No Data Found";
                ((UIImageView*)[cell viewWithTag:22222]).image = nil;
                ((UIButton*)[cell.contentView viewWithTag:33333]).hidden=true;
            }
            else
            {
                //((UIImageView*)[cell viewWithTag:22222]).image = [UIImage imageWithData:[existingPhotos objectAtIndex:indexPath.row]];
                if(![[existingPhotosUrl objectAtIndex:indexPath.row] isEqualToString:@"-"])
                    [(UIImageView*)[cell viewWithTag:22222] sd_setImageWithURL:[NSURL URLWithString:[existingPhotosUrl objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                else
                    ((UIImageView*)[cell viewWithTag:22222]).image = [UIImage imageWithData:[existingPhotos objectAtIndex:indexPath.row]];
                
                ((UILabel*)[cell viewWithTag:11111]).text = [existingNames objectAtIndex:indexPath.row];
                
                if([[existingFollowing objectAtIndex:indexPath.row] isEqualToString:@"1"])
                {
                    //[(UIButton*)[cell.contentView viewWithTag:33333] setEnabled:false];
                    //((UIButton*)[cell.contentView viewWithTag:33333]).hidden=true;
                    [(UIButton*)[cell.contentView viewWithTag:33333] setImage:[UIImage imageNamed:@"requested.png"] forState:UIControlStateNormal];
                }
                
                else
                {
                    //[(UIButton*)[cell.contentView viewWithTag:33333] setEnabled:true];
                    //((UIButton*)[cell.contentView viewWithTag:33333]).hidden=false;
                    [(UIButton*)[cell.contentView viewWithTag:33333] setImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                }
            }
        }
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seprater_line.png"]];
    imgView.frame = CGRectMake(0, 42, 260, 1);
    [cell.contentView addSubview:imgView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == tblViewFBUsers)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"Checked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tblView reloadData];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"Checked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tblViewFBUsers reloadData];
    }
}

-(void)callFollowUserService:(id)sender
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        //      NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        
        // NSString *countrydevice =  [[UIDevice currentDevice] model];
        NSIndexPath *indexPath;
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
      
        if(intValue == 1)
        {
            
            indexPath = [tblView indexPathForCell:cell];
        }
        else
        {
            indexPath = [tblViewFBUsers indexPathForCell:cell];
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        if(intValue == 1)
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[existingContacts objectAtIndex:indexPath.row],@"followee_phone_no",nil];
        }
        else
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[FBusersOnCLickin objectAtIndex:indexPath.row] objectForKey:@"phone_no"],@"followee_phone_no",nil];
        }
        //NSLog(@"%@",Dictionary.description);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        if(intValue == 1)
        {
            [existingFollowing replaceObjectAtIndex:indexPath.row withObject:@"1"];
            [tblView reloadData];
            [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else
        {
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[FBusersOnCLickin objectAtIndex:indexPath.row];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"pending" forKey:@"follow_status"];
            [FBusersOnCLickin replaceObjectAtIndex:indexPath.row withObject:newDict];
            newDict = nil;
            oldDict = nil;
            
            [tblViewFBUsers reloadData];
            [tblViewFBUsers scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

        
        
//        if([request responseStatusCode] == 200)
//        {
//            NSError *error = nil;
//            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
//            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
//            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following"])
//            {
//                if(intValue == 1)
//                {
//                    [existingFollowing replaceObjectAtIndex:indexPath.row withObject:@"1"];
//                    [tblView reloadData];
//                    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//                else
//                {
//                    NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
//                    NSDictionary *oldDict = (NSDictionary *)[FBusersOnCLickin objectAtIndex:indexPath.row];
//                    [newDict addEntriesFromDictionary:oldDict];
//                    [newDict setObject:@"pending" forKey:@"follow_status"];
//                    [FBusersOnCLickin replaceObjectAtIndex:indexPath.row withObject:newDict];
//                    newDict = nil;
//                    oldDict = nil;
//                    
//                    [tblViewFBUsers reloadData];
//                    [tblViewFBUsers scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//                
//                /* UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully following user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                 [alert show];
//                 alert = nil;*/
//            }
//            
//        }
//        else if([request responseStatusCode] == 401)
//        {
//            NSError *error = nil;
//            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
//            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
//            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
//            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
//            }
//        }
        
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


-(void)followBtnPressed:(id)sender
{
    UIImage *img=[(UIButton *) sender imageForState:UIControlStateNormal];
    
    if([img  isEqual:[UIImage imageNamed:@"follow.png"] ])
    {
        //If do something
    }
    else
    {
        return;
    }
    
//    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
//    [activity show];
//    [self performSelector:@selector(callFollowUserService:) withObject:sender afterDelay:0.1];
    
    [self callFollowUserService:sender];
}

-(void)checkBtnPressed:(id)sender
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

    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    if([selectedContacts containsObject:[nonExisitingContacts objectAtIndex:indexPath.row]])
    {
        //remove contact from the array
        int index=-1;
        index = [selectedContacts indexOfObject:[nonExisitingContacts objectAtIndex:indexPath.row]];
        
        NSLog(@"index value....%i    selected array count is...%d",index,selectedContacts.count);
        
        for(int i=index;i<selectedContacts.count-1;i++)
        {
            [selectedContacts replaceObjectAtIndex:index withObject:[selectedContacts objectAtIndex:index+1]];
        }
        [selectedContacts removeLastObject];
        
        //[((UIButton*)[((UITableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:((UIButton*)sender).tag-100000 inSection:1]]).contentView viewWithTag:((UIButton*)sender).tag]) setBackgroundImage:[UIImage imageNamed:@"bullet.png"] forState:UIControlStateNormal];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"bullet.png"] forState:UIControlStateNormal];
    }
    else
    {
        //add contact in the array
        [selectedContacts addObject:[nonExisitingContacts objectAtIndex:indexPath.row]];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"bullet_selected.png"] forState:UIControlStateNormal];
    }
}


#pragma mark -
#pragma mark Custom methods
/*
 - (NSArray*)printAddressBook
 {
 
 ABAddressBookRef addressBook = ABAddressBookCreate();
 NSArray *arrayOfAllPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(addressBook);
 NSUInteger peopleCounter = 0;
 for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
 ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
 NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
 
 ABMultiValueRef PhoneNumber = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
 
 for (NSUInteger PNoCounter = 0; PNoCounter < ABMultiValueGetCount(PhoneNumber); PNoCounter++)
 {
 NSString *number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(PhoneNumber, PNoCounter);
 if([name length] != 0 || [number length] != 0)
 {
 NSMutableDictionary *personDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"name",number,@"phoneNumber", nil];
 [mutableData addObject:personDict];
 }
 }
 }
 CFRelease(addressBook);
 return [NSArray arrayWithArray:mutableData];
 }
 */


// returns an array of dictionaries
// each dictionary has values: Name, phoneNumbers, photo



- (NSArray *)collectAddressBookContacts
{
  
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    NSArray *arrayOfAllPeople;
    NSMutableArray *mutableData = [NSMutableArray new];
    
    if (accessGranted) {
        
        arrayOfAllPeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        // Do whatever you need with thePeople...
        NSUInteger peopleCounter = 0;
        for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
            ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
            NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(thisPerson);
            if(imgData==nil)
                imgData=  UIImagePNGRepresentation([UIImage imageNamed:@"contact_icon.png"]);
            
            
            ABMultiValueRef PhoneNumber = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
            
            NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
            NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
            
            
            for (NSUInteger PNoCounter = 0; PNoCounter < ABMultiValueGetCount(PhoneNumber); PNoCounter++)
            {
                NSString *number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(PhoneNumber, PNoCounter);
                
                number = [[number componentsSeparatedByCharactersInSet:
                           [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                            invertedSet]]
                          componentsJoinedByString:@""];
                
                if([name length] != 0 && [number length] != 0)
                {
                    NSMutableDictionary *personDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"name",number,@"phoneNumber",imgData,@"photo", nil];
                    [mutableData addObject:personDict];
                }
            }
            
            currentLocale=nil;
            countryCode=nil;
        }
        
    }
    
    if(addressBook)
        CFRelease(addressBook);
    return [NSArray arrayWithArray:mutableData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
