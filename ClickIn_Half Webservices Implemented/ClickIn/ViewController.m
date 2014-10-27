//
//  ViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "ViewController.h"
#import "AddYourDetails.h"
#import "RegisterYourEmail.h"
#import "MFSideMenu.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import "NotificationsViewController.h"
#import "AppDelegate.h"
#import "profile_owner.h"
#import "MyViewController.h"
#import "TermConditionsAndPrivacypolicyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (profile_owner *)demoController
{
    // return [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    return [[profile_owner alloc] initWithNibName:nil bundle:nil];
}

- (UINavigationController *)navigationControllers
{
    UINavigationController *nv = [[UINavigationController alloc]
                                  initWithRootViewController:[self demoController]];
    nv.navigationBarHidden = YES;
    return nv;
}


-(void)callSlideMenu
{
    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationControllers]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:rightMenuViewController];
    
    // appdeleget slide container copy
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).slideContainer=container;
    
    //    [self presentViewController:container animated:YES completion:^{
    //
    //    }];
    [self.navigationController pushViewController:container animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ChatDidLogin object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
    }
    else
    {
        [self.view addSubview:btn_SignUp];
        [self.view addSubview:btn_SignIn];
        
        //Pagging flow
        if (!IS_IPHONE_5)
            contentList = [NSArray arrayWithObjects:@"1phnee.png",@"2phnee.png",@"3phnee.png",@"4phnee.png",@"5phnee.png",@"6phnee.png",nil];
        else
            contentList = [NSArray arrayWithObjects:@"bbg1.png",@"bbg2.png",@"bbg3.png",@"bbg4.png",@"bbg5.png",@"bbg6.png",nil];
        
        NSUInteger numberPages = contentList.count;
        
        // view controllers are created lazily
        // in the meantime, load the array with placeholders which will be replaced on demand
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < numberPages; i++)
        {
            [controllers addObject:[NSNull null]];
        }
        viewControllers = controllers;
        
        //  [defaults setObject:@"no" forKey:@"appIntro"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        
        NSLog(@"%@",[defaults stringForKey:@"appIntro"]);
        
        if(![[defaults stringForKey:@"appIntro"] isEqualToString:@"no"])
        {
            // a page is the width of the scroll view
            if (!IS_IPHONE_5)
                scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            else
                scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            
            scrollView.pagingEnabled = YES;
            scrollView.backgroundColor = [UIColor colorWithRed:(67.0/255.0) green:(83.0/255.0) blue:(115.0/255.0) alpha:1.0];
            scrollView.contentSize =
            CGSizeMake(CGRectGetWidth(scrollView.frame) * numberPages, CGRectGetHeight(scrollView.frame));
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.scrollsToTop = NO;
            scrollView.delegate = self;
            [self.view addSubview:scrollView];
            
            if (!IS_IPHONE_5)
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,120 , 320, 26)];
            else
                pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,135 , 320, 26)];
            
            pageControl.numberOfPages = numberPages;
            pageControl.currentPage = 0;
            //pageControl.pageIndicatorTintColor = [UIColor purpleColor];
            pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(122.0/255.0) green:(197.0/255.0) blue:(213.0/255.0) alpha:1.0];
            [self.view addSubview:pageControl];
            
            // pages are created on demand
            // load the visible page
            // load the page on either side to avoid flashes when the user starts scrolling
            
            [self loadScrollViewWithPage:0];
            [self loadScrollViewWithPage:1];
            
            scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                           target:self
                                                         selector:@selector(changePage:)
                                                         userInfo:nil
                                                          repeats:YES];
        }
        else
        {
            [scrollView removeFromSuperview];
            [pageControl removeFromSuperview];
        }
        
    }

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Models
    modelmanager=[ModelManager modelManager];
    chatmanager=modelmanager.chatManager;
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidLogin:)
                                                 name:Notification_ChatDidLogin object:nil];
    
    //[QBAuth createSessionWithDelegate:self];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    compScreen.image=[UIImage imageNamed:@"splash-screen640x1136.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"splash-screen.png"];
    }
    
    [self.view addSubview:compScreen];
    
    btn_SignIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_SignIn setBackgroundImage:[UIImage imageNamed:@"sign-in-button.png"] forState:UIControlStateNormal];
    [btn_SignIn addTarget:self
                   action:@selector(clk_btn_SignIn)
         forControlEvents:UIControlEventTouchDown];
    
    
    if (IS_IPAD)
    {
        
    }
    else
    {
        btn_SignIn.frame = CGRectMake(60, self.view.frame.size.height-80, 85, 35);
    }
    
    
    btn_SignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_SignUp setBackgroundImage:[UIImage imageNamed:@"signupbutton.png"] forState:UIControlStateNormal];
    [btn_SignUp addTarget:self
                   action:@selector(clk_btn_SignUp)
         forControlEvents:UIControlEventTouchDown];
    btn_SignUp.frame = CGRectMake(170, self.view.frame.size.height-80, 85, 35);
    if (IS_IPAD)
    {
        
    }
    else
    {
        btn_SignUp.frame = CGRectMake(170, self.view.frame.size.height-80, 85, 35);
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        
    }
    else
    {
        [self.view addSubview:btn_SignUp];
        [self.view addSubview:btn_SignIn];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clk_btn_SignIn) name:@"postnotificationForSignin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clk_btn_SignUp) name:@"postnotificationForSignup" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clk_btn_PrivacyPolicy) name:@"postnotificationForPrivacyPolicy" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clk_btn_TermConditions) name:@"postnotificationForTermConditions" object:nil];

 /*
    
    //Pagging flow
    if (!IS_IPHONE_5)
        contentList = [NSArray arrayWithObjects:@"1phnee.png",@"2phnee.png",@"3phnee.png",@"4phnee.png",@"5phnee.png",@"6phnee.png",nil];
    else
        contentList = [NSArray arrayWithObjects:@"bbg1.png",@"bbg2.png",@"bbg3.png",@"bbg4.png",@"bbg5.png",@"bbg6.png",nil];
    
    NSUInteger numberPages = contentList.count;
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    viewControllers = controllers;
    
    //  [defaults setObject:@"no" forKey:@"appIntro"];
    
    NSLog(@"%@",[defaults stringForKey:@"appIntro"]);
    
    if(![[defaults stringForKey:@"appIntro"] isEqualToString:@"no"])
    {
        // a page is the width of the scroll view
        if (!IS_IPHONE_5)
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        else
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        
        scrollView.pagingEnabled = YES;
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.contentSize =
        CGSizeMake(CGRectGetWidth(scrollView.frame) * numberPages, CGRectGetHeight(scrollView.frame));
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        
        if (!IS_IPHONE_5)
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,120 , 320, 26)];
        else
            pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,135 , 320, 26)];
        
        pageControl.numberOfPages = numberPages;
        pageControl.currentPage = 0;
        //pageControl.pageIndicatorTintColor = [UIColor purpleColor];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(122.0/255.0) green:(197.0/255.0) blue:(213.0/255.0) alpha:1.0];
        [self.view addSubview:pageControl];
        
        // pages are created on demand
        // load the visible page
        // load the page on either side to avoid flashes when the user starts scrolling
        
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
        
        scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                       target:self
                                                     selector:@selector(changePage:)
                                                     userInfo:nil
                                                      repeats:YES];
    }
  */
}

#pragma mark -
#pragma mark Pagging methods

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    NSLog(@"loadScrollViewWithPage");
    if (page >= contentList.count)
        return;
    
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        
        NSString *numberItem = [contentList objectAtIndex:page];
        controller.numberImage.image = [UIImage imageNamed:numberItem];
    }
}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    
    [scrollTimer invalidate];
    scrollTimer = nil;
    scrollTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                   target:self
                                                 selector:@selector(changePage:)
                                                 userInfo:nil
                                                  repeats:YES];
    
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    if(pageControl.currentPage == 5)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForShowButtons" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForHideButtons" object:nil];
    }
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)gotoPage:(BOOL)animated
{
    NSLog(@"gotoPage");
    
    NSInteger page = pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect bounds = scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    NSLog(@"changePage");
    
    pageControl.currentPage++;
    
    NSLog(@"%d",pageControl.currentPage);
    
    [self gotoPage:YES];    // YES = animate
    
    if(pageControl.currentPage == 5)
    {
        [scrollTimer invalidate];
        scrollTimer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForShowButtons" object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForHideButtons" object:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result{
    
    // QuickBlox session creation  result
    if([result isKindOfClass:[QBAAuthSessionCreationResult class]]){
        
        // Success result
        if(result.success)
        {
            NSLog(@"session created");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if([[defaults stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
            {
                [QBUsers logInWithUserLogin:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"] password:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] delegate:self];
            }
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
//                                                            message:[result.errors description]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles: nil];
//            [alert show];
            
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Errors"
                                                                            description:[result.errors description]
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = self;
            [alertView show];
            alertView = nil;
            
        }
    }
    else if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]; // your current user's ID
        currentUser.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"]; // your current user's password
        
        
        [chatmanager loginWithUser:currentUser];
        
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
//                                                        message:[result.errors description]
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles: nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Errors"
                                                                        description:[result.errors description]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = self;
        [alertView show];
        alertView = nil;
        
    }
}

- (void)chatDidLogin:(NSNotification *)notification{
    //[self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
}

#pragma mark Selctor Functions

-(void)clk_btn_SignIn
{
    // google analytics
  

    NSLog(@"Signin:");
    [scrollTimer invalidate];
    scrollTimer = nil;
    UIViewController *first = [story instantiateViewControllerWithIdentifier:@"SignIn"];
    [self.navigationController pushViewController:first animated:YES];
}

-(void)clk_btn_SignUp
{
    NSLog(@"SignUp:");
    [scrollTimer invalidate];
    scrollTimer = nil;
    UIViewController *first = [story instantiateViewControllerWithIdentifier:@"SignUp"];
    [self.navigationController pushViewController:first animated:YES];
    
    //CurrentClickersViewController
    
    //    UIViewController *CurrentClickersViewController = [story instantiateViewControllerWithIdentifier:@"CurrentClickersViewController"];
    //    [self.navigationController pushViewController:CurrentClickersViewController animated:YES];
    
    //    UIViewController *SearchContactsViewController = [story instantiateViewControllerWithIdentifier:@"SearchContactsViewController"];
    //    [self.navigationController pushViewController:SearchContactsViewController animated:YES];
    
    //      RegisterYourEmail *registeryouremail = [story instantiateViewControllerWithIdentifier:@"RegisterYourEmail"];
    //      [self.navigationController pushViewController:registeryouremail animated:YES];
    //    UIViewController *addyourdetails = [story instantiateViewControllerWithIdentifier:@"AddYourDetails"];
    //    [self.navigationController pushViewController:addyourdetails animated:YES];
    
//    SendInvite *ObjSendInvite = [story instantiateViewControllerWithIdentifier:@"SendInvite"];
//    ObjSendInvite.ProfileImg =[UIImage imageNamed:@"bluebtn.png"];
//    
//    NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
//                        @"Nitin",@"name",
//                        @"sharma",@"lastName",
//                        nil];
//    ObjSendInvite.dict=dict;
//    ObjSendInvite.ProfileImg =[UIImage imageNamed:@"bluebtn.png"];
//    
//    [self.navigationController pushViewController:ObjSendInvite animated:YES];
    
}


-(void)clk_btn_PrivacyPolicy
{
    TermConditionsAndPrivacypolicyViewController *TermConditionsAndPrivacyPolicy = [[TermConditionsAndPrivacypolicyViewController alloc] initWithNibName:@"TermConditionsAndPrivacypolicyViewController" bundle:nil];
    TermConditionsAndPrivacyPolicy.StrHeader = @"Privacy Policy";
    [self.navigationController pushViewController:TermConditionsAndPrivacyPolicy animated:YES];
    TermConditionsAndPrivacyPolicy = nil;
}


-(void)clk_btn_TermConditions
{
    TermConditionsAndPrivacypolicyViewController *TermConditionsAndPrivacyPolicy = [[TermConditionsAndPrivacypolicyViewController alloc] initWithNibName:@"TermConditionsAndPrivacypolicyViewController" bundle:nil];
    TermConditionsAndPrivacyPolicy.StrHeader = @"Terms Of Use";
    [self.navigationController pushViewController:TermConditionsAndPrivacyPolicy animated:YES];
    TermConditionsAndPrivacyPolicy = nil;

}

@end
