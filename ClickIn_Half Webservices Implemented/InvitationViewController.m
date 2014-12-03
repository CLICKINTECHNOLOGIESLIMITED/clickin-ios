//
//  InvitationViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 07/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "InvitationViewController.h"
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


@interface InvitationViewController ()

@end

@implementation InvitationViewController
@synthesize arrContacts,existingContacts,existingNames,existingPhotos,existingPhotosUrl,existingFollowing,nonExisitingContacts,nonExisitingNames,nonExisitingPhotos;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//  Do any additional setup after loading the view.
    
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.image=[UIImage imageNamed:@"640x960Spread.png"];
    
    if(IS_IPHONE_5)
        backgroundView.image=[UIImage imageNamed:@"640x1136Spread.png"];
    
    [self.view addSubview:backgroundView];
    
    
    if([isFromMenu isEqualToString:@"true"])
    {
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        [activity show];
        [self performSelector:@selector(customViewDidLoad) withObject:self afterDelay:0.1];
    }
    
    
    //arrContacts = [[NSArray alloc] initWithArray:[self collectAddressBookContacts]];
    
//    existingContacts=[[NSMutableArray alloc] init];
//    existingNames = [[NSMutableArray alloc] init];
//    existingPhotos = [[NSMutableArray alloc] init];
//    existingPhotosUrl = [[NSMutableArray alloc] init];
//    existingFollowing = [[NSMutableArray alloc] init];
//    nonExisitingContacts = [[NSMutableArray alloc] init];
//    nonExisitingNames = [[NSMutableArray alloc] init];
//    nonExisitingPhotos = [[NSMutableArray alloc] init];
    
    else
    {
        selectedContacts = [[NSMutableArray alloc] init];
        invitedContacts=[[NSMutableArray alloc] init];
        
        
        NSMutableArray *contactNumbers=[[NSMutableArray alloc] init];
        
        for(int i=0;i<arrContacts.count;i++)
            [contactNumbers addObject:[[arrContacts objectAtIndex:i] objectForKey:@"phoneNumber"]];
        
        [nonExisitingContacts removeAllObjects];
        
        for(int i=0;i<contactNumbers.count;i++)
        {
            bool numberExists = false;
            for(int j=0;j<existingContacts.count;j++)
            {
                if([[contactNumbers objectAtIndex:i] isEqualToString:[existingContacts objectAtIndex:j]])
                {
                    numberExists = true;
                    break;
                }
            }
            
            if(numberExists == false)
                [nonExisitingContacts addObject:[contactNumbers objectAtIndex:i]];
        }
        
        for(int i=0;i<nonExisitingContacts.count;i++)
        {
            int index=[contactNumbers indexOfObject:[nonExisitingContacts objectAtIndex:i]];
            [nonExisitingNames addObject:[[arrContacts objectAtIndex:index] objectForKey:@"name"]];
            [nonExisitingPhotos addObject:[[arrContacts objectAtIndex:index] objectForKey:@"photo"]];
        }
        
        
        tblView = [[UITableView alloc] initWithFrame:CGRectMake(30,250,260,275) style:UITableViewStylePlain];
        tblView.dataSource = self;
        tblView.delegate = self;
        tblView.separatorStyle=UITableViewCellSeparatorStyleNone;
        tblView.backgroundColor=[UIColor clearColor];
        
        
        if (IS_IOS_7)
        {
            if (IS_IPHONE_5)
                tblView.frame = CGRectMake(30,220+5,260,265+17);
            else
                tblView.frame = CGRectMake(30,175+30+12,260,305-30-50-12);
        }
        else
        {
            if (IS_IPHONE_5)
                tblView.frame = CGRectMake(30,210+30,260,345-30);
            else
                tblView.frame = CGRectMake(30,165+30,260,305-30);
        }
        [self.view addSubview:tblView];
        //  tblView = nil;
        
        //...........................................................................................................................
        
        
        // -----Top Tab Buttons------
        
        phonebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phonebookBtn addTarget:self action:@selector(phonebookBtnPressed)
               forControlEvents:UIControlEventTouchDown];
        [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_pink.png"] forState:UIControlStateNormal];
        [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateHighlighted];
        if(IS_IPHONE_5)
            phonebookBtn.frame = CGRectMake(23.5, self.view.frame.size.height*0.24, 136.5, 34);
        else
            phonebookBtn.frame = CGRectMake(23.5, self.view.frame.size.height*0.28, 136.5, 34);
        [self.view addSubview:phonebookBtn];
        
        facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [facebookBtn addTarget:self action:@selector(facebookBtnPressed)
              forControlEvents:UIControlEventTouchDown];
        [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
        if(IS_IPHONE_5)
            facebookBtn.frame = CGRectMake(160, self.view.frame.size.height*0.24, 136.5, 34);
        else
            facebookBtn.frame = CGRectMake(160, self.view.frame.size.height*0.28, 136.5, 34);
        [self.view addSubview:facebookBtn];
        
        twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [twitterBtn addTarget:self action:@selector(twitterBtnPressed)
             forControlEvents:UIControlEventTouchDown];
        [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
        if(IS_IPHONE_5)
            twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.24, 67, 33);
        else
            twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.28, 67, 33);
        //  [self.view addSubview:twitterBtn];
        
        googleplusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [googleplusBtn addTarget:self action:@selector(googleplusBtnPressed)
                forControlEvents:UIControlEventTouchDown];
        [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
        if(IS_IPHONE_5)
            googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, self.view.frame.size.height*0.24, 66, 33);
        else
            googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, self.view.frame.size.height*0.28, 66, 33);
        //  [self.view addSubview:googleplusBtn];
        
        
        scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scrollToTopBtn addTarget:self action:@selector(scrollToTopBtnPressed)
                 forControlEvents:UIControlEventTouchDown];
        [scrollToTopBtn setBackgroundImage:nil forState:UIControlStateNormal];
        if(IS_IPHONE_5)
            scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height*0.15, 250, 52);
        else
            scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height*0.1, 250, 52);
        scrollToTopBtn.backgroundColor=[UIColor clearColor];
        [self.view addSubview:scrollToTopBtn];
        
        //---Bottom Buttons---
        
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, self.view.frame.size.height-56, 270, 56)];
            if([isFromMenu isEqualToString:@"true"])
            {
                imgView.image = [UIImage imageNamed:@"buttom-buttonWithoutSkip.png"];
            }
            else
            {
                imgView.image = [UIImage imageNamed:@"buttom-button.png"];
            }
            [self.view addSubview:imgView];
        
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(backBtnPressed)
          forControlEvents:UIControlEventTouchDown];
        backBtn.frame = CGRectMake(25, self.view.frame.size.height-50, 100, 50);
        [self.view addSubview:backBtn];
        
        UIButton *NextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // NextButton.backgroundColor = [UIColor redColor];
        [NextButton addTarget:self action:@selector(NextButtonPressed)
             forControlEvents:UIControlEventTouchDown];
        NextButton.frame = CGRectMake(inviteBtn.frame.origin.x+200, self.view.frame.size.height-50, 100, 50);
        [self.view addSubview:NextButton];
        
        inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // inviteBtn.backgroundColor = [UIColor blueColor];
        [inviteBtn addTarget:self action:@selector(btn_InviteButtonAction:)forControlEvents:UIControlEventTouchDown];
        //inviteBtn.backgroundColor = [UIColor redColor];
        inviteBtn.frame = CGRectMake(self.view.frame.size.width/2 - 36, self.view.frame.size.height-44, 72 , 44);
        [self.view addSubview:inviteBtn];
        //..........................................................................................................................

    
    }
    
//    [self getExistingContacts:contactNumbers];
//    
//    
//    for(int i=0;i<existingContacts.count;i++)
//    {
//        int index=[contactNumbers indexOfObject:[existingContacts objectAtIndex:i]];
//        [existingNames addObject:[[arrContacts objectAtIndex:index] objectForKey:@"name"]];
//        [existingPhotos addObject:[[arrContacts objectAtIndex:index] objectForKey:@"photo"]];
//    }
//    
    
//
}

-(void)customViewDidLoad
{
    arrContacts = [[NSArray alloc] initWithArray:[self collectAddressBookContacts]];
    
    //existingContacts=[[NSMutableArray alloc] init];
    nonExisitingContacts = [[NSMutableArray alloc] init];
    nonExisitingNames = [[NSMutableArray alloc] init];
    nonExisitingPhotos = [[NSMutableArray alloc] init];
    
    selectedContacts = [[NSMutableArray alloc] init];
    invitedContacts=[[NSMutableArray alloc] init];
    
    NSMutableArray *contactNumbers=[[NSMutableArray alloc] init];
    
    for(int i=0;i<arrContacts.count;i++)
        [contactNumbers addObject:[[arrContacts objectAtIndex:i] objectForKey:@"phoneNumber"]];
    
    
    [self getExistingContacts:contactNumbers];
    
    for(int i=0;i<nonExisitingContacts.count;i++)
    {
        int index=[contactNumbers indexOfObject:[nonExisitingContacts objectAtIndex:i]];
        [nonExisitingNames addObject:[[arrContacts objectAtIndex:index] objectForKey:@"name"]];
        [nonExisitingPhotos addObject:[[arrContacts objectAtIndex:index] objectForKey:@"photo"]];
    }

    
    tblView = [[UITableView alloc] initWithFrame:CGRectMake(30,250,260,275) style:UITableViewStylePlain];
    tblView.dataSource = self;
    tblView.delegate = self;
    tblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tblView.backgroundColor=[UIColor clearColor];
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            tblView.frame = CGRectMake(30,220+5,260,265+17);
        else
            tblView.frame = CGRectMake(30,175+30+12,260,305-30-50-12);
    }
    else
    {
        if (IS_IPHONE_5)
            tblView.frame = CGRectMake(30,210+30,260,345-30);
        else
            tblView.frame = CGRectMake(30,165+30,260,305-30);
    }
    [self.view addSubview:tblView];
    //  tblView = nil;
    
    //...........................................................................................................................
    
    
    // -----Top Tab Buttons------
    
    phonebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phonebookBtn addTarget:self action:@selector(phonebookBtnPressed)
           forControlEvents:UIControlEventTouchDown];
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_pink.png"] forState:UIControlStateNormal];
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_grey-1.png"] forState:UIControlStateHighlighted];
    if(IS_IPHONE_5)
        phonebookBtn.frame = CGRectMake(23.5, self.view.frame.size.height*0.24, 136.5, 34);
    else
        phonebookBtn.frame = CGRectMake(23.5, self.view.frame.size.height*0.28, 136.5, 34);
    [self.view addSubview:phonebookBtn];
    
    facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookBtn addTarget:self action:@selector(facebookBtnPressed)
          forControlEvents:UIControlEventTouchDown];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        facebookBtn.frame = CGRectMake(160, self.view.frame.size.height*0.24, 136.5, 34);
    else
        facebookBtn.frame = CGRectMake(160, self.view.frame.size.height*0.28, 136.5, 34);
    [self.view addSubview:facebookBtn];
    
    twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterBtn addTarget:self action:@selector(twitterBtnPressed)
         forControlEvents:UIControlEventTouchDown];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.24, 67, 33);
    else
        twitterBtn.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height*0.28, 67, 33);
    //  [self.view addSubview:twitterBtn];
    
    googleplusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [googleplusBtn addTarget:self action:@selector(googleplusBtnPressed)
            forControlEvents:UIControlEventTouchDown];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, self.view.frame.size.height*0.24, 66, 33);
    else
        googleplusBtn.frame = CGRectMake(self.view.frame.size.width/2+67, self.view.frame.size.height*0.28, 66, 33);
    //  [self.view addSubview:googleplusBtn];
    
    
    scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scrollToTopBtn addTarget:self action:@selector(scrollToTopBtnPressed)
             forControlEvents:UIControlEventTouchDown];
    [scrollToTopBtn setBackgroundImage:nil forState:UIControlStateNormal];
    if(IS_IPHONE_5)
        scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height*0.15, 250, 52);
    else
        scrollToTopBtn.frame = CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height*0.1, 250, 52);
    scrollToTopBtn.backgroundColor=[UIColor clearColor];
    [self.view addSubview:scrollToTopBtn];
    
    //---Bottom Buttons---
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, self.view.frame.size.height-56, 270, 56)];
    if([isFromMenu isEqualToString:@"true"])
    {
        imgView.image = [UIImage imageNamed:@"buttom-buttonWithoutSkip.png"];
    }
    else
    {
        imgView.image = [UIImage imageNamed:@"buttom-button.png"];
    }
    [self.view addSubview:imgView];

    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnPressed)
      forControlEvents:UIControlEventTouchDown];
    backBtn.frame = CGRectMake(25, self.view.frame.size.height-50, 100, 50);
    [self.view addSubview:backBtn];
    
    UIButton *NextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // NextButton.backgroundColor = [UIColor redColor];
    [NextButton addTarget:self action:@selector(NextButtonPressed)
         forControlEvents:UIControlEventTouchDown];
    NextButton.frame = CGRectMake(inviteBtn.frame.origin.x+200, self.view.frame.size.height-50, 100, 50);
    [self.view addSubview:NextButton];
    
    inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // inviteBtn.backgroundColor = [UIColor blueColor];
    [inviteBtn addTarget:self action:@selector(btn_InviteButtonAction:)forControlEvents:UIControlEventTouchDown];
    //inviteBtn.backgroundColor = [UIColor redColor];
    inviteBtn.frame = CGRectMake(self.view.frame.size.width/2 - 36, self.view.frame.size.height-44, 72 , 44);
    [self.view addSubview:inviteBtn];
    //..........................................................................................................................

    [activity hide];
}

- (void) backBtnPressed
{
    if([isFromMenu isEqualToString:@"true"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];

    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void) NextButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"yes" forKey:@"IsAutoLogin"];

    if([isFromMenu isEqualToString:@"true"])
    {
        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//        transition.type = kCATransitionReveal;
//        transition.subtype = kCATransitionFromLeft;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        [self.navigationController popViewControllerAnimated:NO];
        
    }
    else
        [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
}


- (profile_owner *)demoController {
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
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebook_pink.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
}


-(void) facebookBtnPressed
{
//    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebookgrey.png"] forState:UIControlStateNormal];
//    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
//    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
//    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
    
//    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     @"12120000000000000", @"suggestions",
//                                     @"data", @"data",
//                                     @"Facebook SDK for iOS", @"name",
//                                     @"https://itunes.apple.com/us/app/celebfix/id747769943?mt=8", @"link",
//                                     nil];
    
    //[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString]
    
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:[NSString stringWithFormat:@"%@",[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] capitalizedString]]
     title:nil
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
    {
         if (error)
         {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         }
         else
         {
             if (result == FBWebDialogResultDialogNotCompleted)
             {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             }
             else
             {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"])
                 {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 }
                 else
                 {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
    
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
-(void) twitterBtnPressed
{
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebookgrey.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplusgrey.png"] forState:UIControlStateNormal];
}


-(void) googleplusBtnPressed
{
    [phonebookBtn setBackgroundImage:[UIImage imageNamed:@"phonebookgrey.png"] forState:UIControlStateNormal];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb_grey1.png"] forState:UIControlStateNormal];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twittergrey.png"] forState:UIControlStateNormal];
    [googleplusBtn setBackgroundImage:[UIImage imageNamed:@"googleplus.png"] forState:UIControlStateNormal];
}

-(void) scrollToTopBtnPressed
{
  //  [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


- (void) skipBtnPressed
{
    [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
    skipBtn.enabled = false;
    //UIViewController *invitationView = [story instantiateViewControllerWithIdentifier:@"SendInvite"];
    //[self.navigationController pushViewController:invitationView animated:YES];
}


-(void) getExistingContacts:(NSArray*)contactArray
{
    //activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    //[activity show];
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
                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Request sent to partner" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //                [alert show];
                //                alert = nil;
                
                //[[self navigationController] setNavigationBarHidden:YES animated:NO];
                
                //[self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
                
                
                NSArray *TempArray = [[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"phone_nos"]];
                
                for(int i=0;i<TempArray.count;i++)
                {
                    if([[[TempArray objectAtIndex:i] objectForKey:@"exists"] integerValue]==0)
                    {
                       [nonExisitingContacts addObject:[[TempArray objectAtIndex:i] objectForKey:@"phone_no"]];
                    }
//                    else if([[[TempArray objectAtIndex:i] objectForKey:@"exists"] integerValue]==1)
//                    {
//                        [existingContacts addObject:[[TempArray objectAtIndex:i] objectForKey:@"phone_no"]];
//                        if(![[[TempArray objectAtIndex:i] objectForKey:@"user_pic"] isEqual:[NSNull null]] )
//                            [existingPhotosUrl addObject:[[TempArray objectAtIndex:i] objectForKey:@"user_pic"]];
//                        else
//                            [existingPhotosUrl addObject:@"-"];
//                        if([[[TempArray objectAtIndex:i] objectForKey:@"following"] integerValue]==1)
//                            [existingFollowing addObject:@"1"];
//                        else
//                            [existingFollowing addObject:@"0"];
//                    }
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
                if([isFromMenu isEqualToString:@"true"])
                {
                    [alertView showForPresentView];
                }
                else
                {
                    [alertView show];
                }
                alertView = nil;

            }
        }
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
        if([isFromMenu isEqualToString:@"true"])
        {
            [alertView showForPresentView];
        }
        else
        {
            [alertView show];
        }
        alertView = nil;
    }
    
    [activity hide];
}

-(void)callInviteAndFollowusersWebService
{
    [invitedContacts addObjectsFromArray:selectedContacts];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/inviteandfollowusers"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
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
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Click sent - waiting for them to accept" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Click sent - waiting for them to accept"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                if([isFromMenu isEqualToString:@"true"])
                {
                    [alertView showForPresentView];
                }
                else
                {
                    [alertView show];
                }
                alertView = nil;
                
                //[self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
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
                if([isFromMenu isEqualToString:@"true"])
                {
                    [alertView showForPresentView];
                }
                else
                {
                    [alertView show];
                }
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
        if([isFromMenu isEqualToString:@"true"])
        {
            [alertView showForPresentView];
        }
        else
        {
            [alertView show];
        }
        alertView = nil;
    }
    [activity hide];
}

-(void)btn_InviteButtonAction:(id)sender
{
    if([selectedContacts count] == 0)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"First select the contacts" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:@"First select the contacts"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        if([isFromMenu isEqualToString:@"true"])
        {
            [alertView showForPresentView];
        }
        else
        {
            [alertView show];
        }
        alertView = nil;
    }
    else
    {
        NSLog(@"selected contacts: %@",selectedContacts);
        
        [self performSelector:@selector(sendInAppSMS:) withObject:selectedContacts afterDelay:0.1];
        
//        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
//        [activity show];
//       
//        [self performSelector:@selector(callInviteAndFollowusersWebService) withObject:self afterDelay:0.1];
        
    }
  /*  activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/newrequest"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
//      NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
  
        NSString *Str = [[NSString stringWithFormat:@"%@",[[arrContacts objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"Checked"]] valueForKey:@"phoneNumber"]] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        Str = [Str stringByReplacingOccurrencesOfString:@"(" withString:@""];
        Str = [Str stringByReplacingOccurrencesOfString:@")" withString:@""];
        Str = [Str stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        Str = [Str substringFromIndex: [Str length] - 10];
        
        NSLog(@"%@",Str);
        
        if ([Str rangeOfString:@"+91"].location == NSNotFound)
        {
            Str = [NSString stringWithFormat:@"+91%@",Str];
        }
        else
        {
            NSLog(@"string contains bla!");
        }

    //    NSLog(@"%@",Str);
    
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",Str,@"partner_phone_no",nil];
        
       // NSLog(@"%@",Dictionary);
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request sent to partner"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Request sent to partner" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;

                [[self navigationController] setNavigationBarHidden:YES animated:NO];
                
                [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request has already been made to the user"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Request has already been made to the user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
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
    [activity hide];*/
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
    
//    [self presentViewController:container animated:YES completion:^{
//    
//    }];
    [self.navigationController pushViewController:container animated:YES];
}


#pragma mark -
#pragma mark SMS Feature

-(void) sendInAppSMS:(NSArray*)SelectedContacts
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.delegate = self;
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Hey! Come join us on Clickin' - Download Now - https://itunes.apple.com/us/app/clickin-keep-scoring/id901882470?ls=1&mt=8";
        controller.recipients = SelectedContacts;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
            break;
		case MessageComposeResultFailed:
			NSLog(@"Failed..");
            break;
		case MessageComposeResultSent:
            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            //            alert = nil;
            
            break;
		default:
            break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0)
    {
//        if(existingContacts.count==0)
//            return 1;
//        else
//            return [existingContacts count];
        
        
    }
    return [nonExisitingContacts count];
}


//- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    //UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 2)];
//    //footerView.backgroundColor=[UIColor blackColor];
//    //return footerView;
//    return nil;
//}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if(section==0)
        return @"FRIENDS ALREADY ON CLICKIN";
    else
        return @"GET THEM TO START CLICKIN";
}*/

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:11]];
//    NSString *string;
//    if(section==0)
//        string=@"FRIENDS ALREADY ON CLICKIN";
//    else
//        string=@"GET THEM TO START CLICKIN";
//   
//    [label setText:string];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.textColor=[UIColor lightGrayColor];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1]]; //your background color...
//    return nil;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"Cell_Section1";
    static NSString *CellIdentifier2 = @"Cell_Section2";
    
    UITableViewCell *cell;
    
    if(indexPath.section==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    }
    else if(indexPath.section==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    }
    
    
    if (cell == nil)
    {
        if(indexPath.section==1)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            
            
            UILabel *contactName = [[UILabel alloc] init];
            [contactName setFrame:CGRectMake(50, 8, 130, 20)];
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
            [photoImageView setFrame:CGRectMake(2, 8, 40, 40)];
            photoImageView.tag=22222;
            [cell addSubview:photoImageView];

            
            if(existingContacts.count>0)
            {
                UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                followBtn.tag=33333;
                [followBtn addTarget:self action:@selector(followBtnPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
                [followBtn setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
                followBtn.frame = CGRectMake(185, 10 , 70 , 22);
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            //cell.contentView.backgroundColor=[UIColor yellowColor];
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
            [photoImageView setFrame:CGRectMake(2, 8, 40, 40)];
            photoImageView.tag=22222;
            [cell addSubview:photoImageView];
            
            
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBtn.tag=44444;
            [checkBtn addTarget:self action:@selector(checkBtnPressed:)
               forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel *lblPhoneNum=[[UILabel alloc] initWithFrame:CGRectMake(50,35 ,100 , 20)];
            [lblPhoneNum setFont:[UIFont systemFontOfSize:14.0]];
            [lblPhoneNum setBackgroundColor:[UIColor clearColor]];
            [lblPhoneNum setTextColor:[UIColor blackColor]];
            lblPhoneNum.textAlignment=NSTextAlignmentLeft;
            lblPhoneNum.numberOfLines=1;
            lblPhoneNum.adjustsFontSizeToFitWidth=YES;
            lblPhoneNum.minimumScaleFactor=0.25f;
            lblPhoneNum.tag=5555;
            [cell.contentView addSubview:lblPhoneNum];
            
//            if([invitedContacts containsObject:[nonExisitingContacts objectAtIndex:indexPath.row]])
//            {
//                [checkBtn setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
//                [checkBtn setEnabled:false];
//                checkBtn.hidden=true;
//            }
//            else
//            {
//                if([selectedContacts containsObject:[nonExisitingContacts objectAtIndex:indexPath.row]])
//                    [checkBtn setImage:[UIImage imageNamed:@"strip-selected.png"] forState:UIControlStateNormal];
//                else
//                    [checkBtn setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
//            }
            checkBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
            checkBtn.frame = CGRectMake(220, 5 , 32 , 32);
            [cell.contentView addSubview:checkBtn];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    /*
    if([[arrContacts objectAtIndex:indexPath.row] objectForKey:@"photo"] != nil)
        ((UIImageView*)[cell viewWithTag:222]).image = [UIImage imageWithData:[[arrContacts objectAtIndex:indexPath.row] objectForKey:@"photo"]];
    else
        ((UIImageView*)[cell viewWithTag:222]).image = [UIImage imageNamed:@"contact_icon.png"];
    
    ((UILabel*)[cell viewWithTag:111]).text = [[arrContacts objectAtIndex:indexPath.row] objectForKey:@"name"];*/
    
    
    /*if(indexPath.section==0 && existingContacts.count>0)
    {
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.tag=indexPath.row;
        [followBtn addTarget:self action:@selector(followBtnPressed:)
            forControlEvents:UIControlEventTouchDown];
        [followBtn setBackgroundImage:[UIImage imageNamed:@"follow.png"] forState:UIControlStateNormal];
        followBtn.frame = CGRectMake(185, 10 , 70 , 22);
        if([[existingFollowing objectAtIndex:indexPath.row] isEqualToString:@"1"])
        {
            [followBtn setEnabled:false];
            followBtn.hidden=true;
        }

        [cell.contentView addSubview:followBtn];
        
    }
    else*/ /*if(indexPath.section==1)
    {
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBtn.tag=indexPath.row+100000;
        [checkBtn addTarget:self action:@selector(checkBtnPressed:)
           forControlEvents:UIControlEventTouchDown];
        if([invitedContacts containsObject:[nonExisitingContacts objectAtIndex:checkBtn.tag-100000]])
        {
            [checkBtn setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
            [checkBtn setEnabled:false];
            checkBtn.hidden=true;
        }
        else
        {
            if([selectedContacts containsObject:[nonExisitingContacts objectAtIndex:checkBtn.tag-100000]])
                [checkBtn setImage:[UIImage imageNamed:@"strip-selected.png"] forState:UIControlStateNormal];
            else
                [checkBtn setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
        }
        checkBtn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        checkBtn.frame = CGRectMake(220, 6 , 30 , 30);
        [cell.contentView addSubview:checkBtn];
    }*/

    
    
    if(indexPath.section==1)
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
                [(UIButton*)[cell.contentView viewWithTag:33333] setEnabled:false];
                ((UIButton*)[cell.contentView viewWithTag:33333]).hidden=true;
            }
            else
            {
                [(UIButton*)[cell.contentView viewWithTag:33333] setEnabled:true];
                ((UIButton*)[cell.contentView viewWithTag:33333]).hidden=false;
            }
        }
    }
    else if(indexPath.section==0)
    {
        
        ((UIImageView*)[cell viewWithTag:22222]).image = [UIImage imageWithData:[nonExisitingPhotos objectAtIndex:indexPath.row]];
        
        
        ((UILabel*)[cell viewWithTag:11111]).text = [nonExisitingNames objectAtIndex:indexPath.row];
        
        
        if([invitedContacts containsObject:[nonExisitingContacts objectAtIndex:indexPath.row]])
        {
            [(UIButton*)[cell.contentView viewWithTag:44444] setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
            [(UIButton*)[cell.contentView viewWithTag:44444] setEnabled:false];
            ((UIButton*)[cell.contentView viewWithTag:44444]).hidden=true;
           
        }
        else
        {
            if([selectedContacts containsObject:[nonExisitingContacts objectAtIndex:indexPath.row]])
                [(UIButton*)[cell.contentView viewWithTag:44444] setImage:[UIImage imageNamed:@"strip-selected.png"] forState:UIControlStateNormal];
            else
                [(UIButton*)[cell.contentView viewWithTag:44444] setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
            
            [(UIButton*)[cell.contentView viewWithTag:44444] setEnabled:true];
            ((UIButton*)[cell.contentView viewWithTag:44444]).hidden=false;
            UILabel *lblNum= (UILabel *)[cell.contentView viewWithTag:5555];
            lblNum.text=[nonExisitingContacts objectAtIndex:indexPath.row];
        }
        
        
    }
    
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"Checked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tblView reloadData];
}


-(void)followBtnPressed:(id)sender
{
    if(activity==nil)
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
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
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[existingContacts objectAtIndex:indexPath.row],@"followee_phone_no",nil];
        
        
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following"])
            {
                [(UIButton*)sender setEnabled:false];
                [(UIButton*)sender setHidden:true];
                [existingFollowing replaceObjectAtIndex:indexPath.row withObject:@"1"];
                [tblView reloadData];
                [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully following user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Successfully following user"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                if([isFromMenu isEqualToString:@"true"])
                {
                    [alertView showForPresentView];
                }
                else
                {
                    [alertView show];
                }
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
                if([isFromMenu isEqualToString:@"true"])
                {
                    [alertView showForPresentView];
                }
                else
                {
                    [alertView show];
                }
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
        if([isFromMenu isEqualToString:@"true"])
        {
            [alertView showForPresentView];
        }
        else
        {
            [alertView show];
        }
        alertView = nil;
    }
    [activity hide];

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
        
        //[((UIButton*)[((UITableViewCell*)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:((UIButton*)sender).tag-100000 inSection:1]]).contentView viewWithTag:((UIButton*)sender).tag]) setBackgroundImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"strip-unselect.png"] forState:UIControlStateNormal];
    }
    else
    {
        //add contact in the array
        [selectedContacts addObject:[nonExisitingContacts objectAtIndex:indexPath.row]];
        [(UIButton*)sender setImage:[UIImage imageNamed:@"strip-selected.png"] forState:UIControlStateNormal];
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
    
    if (ABAddressBookRequestAccessWithCompletion != NULL)
    { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else
    { // we're on iOS 5 or older
        accessGranted = YES;
    }
    NSArray *arrayOfAllPeople;
    NSMutableArray *mutableData = [NSMutableArray new];
    
    if (accessGranted)
    {
        
        arrayOfAllPeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        // Do whatever you need with thePeople...
        NSUInteger peopleCounter = 0;
        for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++)
        {
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
                
                /*number = [number stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];*/
                
                
                number = [[number componentsSeparatedByCharactersInSet:
                                               [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                                                invertedSet]]
                                              componentsJoinedByString:@""];
                
                if([name length] != 0 && [number length] != 0 && [number length] > 9)
                {
                    
                   // NSLog(@"Number......%@",number);
                    
                    if(number.length==10)
                    {
                        if ([countryCode.lowercaseString isEqualToString:@"in"])
                        {
                            number = [NSString stringWithFormat:@"+91%@",number];
                        }
                    
                        else if ([countryCode.lowercaseString isEqualToString:@"us"])
                        {
                            number = [NSString stringWithFormat:@"+1%@",number];
                        }
                    }
                    else
                    {
                        if(number.length==11)
                        {
                            if([[number substringToIndex:1] integerValue]==0)
                            {
                                number = [number substringFromIndex: [number length] - 10];
                                if ([countryCode.lowercaseString isEqualToString:@"in"])
                                {
                                    number = [NSString stringWithFormat:@"+91%@",number];
                                }
                                
                                else if ([countryCode.lowercaseString isEqualToString:@"us"])
                                {
                                    number = [NSString stringWithFormat:@"+1%@",number];
                                }
                            }
                        }
                        else if([[number substringToIndex:1] isEqualToString:@"+"])
                        {
                            //number already contains country code
                        }
                        else if(number.length<14)
                        {
                            number = [number substringFromIndex: [number length] - 10];
                            if ([countryCode.lowercaseString isEqualToString:@"in"])
                            {
                                number = [NSString stringWithFormat:@"+91%@",number];
                            }
                        
                            else if ([countryCode.lowercaseString isEqualToString:@"us"])
                            {
                                number = [NSString stringWithFormat:@"+1%@",number];
                            }
                        }
                    }
                    
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

    
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    mutableData = [[mutableData sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    return [NSArray arrayWithArray:mutableData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
