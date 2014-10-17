//
//  SettingsViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 17/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "SettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MFSideMenu.h"
#import "SignIn.h"
#import "EditProfileViewController.h"
#import "SpamAbuseViewController.h"
#import "DeactivateAccountView.h"
#import "TermConditionsAndPrivacypolicyViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize LblSettings,topBarImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [activity hide];
}

-(void)appplicationIsActive:(id)sender
{
    [activity hide];
}

-(void)viewWillAppear:(BOOL)animated
{
    [profilemanager.ownerDetails getProfileInfo:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ProfileInfoUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_RightMenuToggled object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    LblSettings.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    isSectionOpen = [[NSMutableArray alloc] init];
    for(int i=0;i<8;i++)
    {
        [isSectionOpen addObject:@"false"];
    }
    
    isRowOpen = [[NSMutableArray alloc] init];
    for(int i=0;i<8;i++)
    {
        [isRowOpen addObject:@"false"];
    }
    
    isFeedbackOpen = false;
    
    tblView = [[UITableView alloc] init];
    tblView.frame = CGRectMake(0, 45, 320, 435 + 100);
    tblView.backgroundColor = [UIColor whiteColor];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 45, 320, 523);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 45, 320, 523);
        }
        else
        {
            tblView.frame = CGRectMake(0, 45, 320, 435);
        }
    }
    
    tblView.dataSource = self;
    tblView.delegate = self;
    
    tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblView];
    
    //if(isFromSharingView)
    //topBarImageView.image = [UIImage imageNamed:@"comments_top"];
    
    [self.view bringSubviewToFront:topBarImageView];
    [self.view bringSubviewToFront:LblSettings];
    
    // notifications text
    notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    notification_text.center=CGPointMake(298, 18);
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

    [self.view bringSubviewToFront:self.tintView];
}

#pragma mark Notifications received
- (void)ProfileInfoNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    //notification count set
    notification_text.text=profilemanager.ownerDetails.notificationCount;
    
    if([notification_text.text isEqualToString:@"0"])
        notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    else
        notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
}

- (void)rightMenuToggled:(NSNotification *)notification //use notification method and logic
{
    notification_text.text = @"0";
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    
}

#pragma mark UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==4747)  // for image selection
    {
        if (buttonIndex == 0)
        {
            /*
            //logout current user
            [[QBChat instance] logout];
            
            [QBUsers logOutWithDelegate:self];
            
            //[QBAuth destroySessionWithDelegate:self];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"IsAutoLogin"];
            
            self.navigationController.viewControllers = [NSArray arrayWithObjects:[[SignIn alloc] init], nil];*/

        }
    }
}


//save password webservice call
-(void)savePasswordBtnPressed:(UIButton*)sender
{
    UITableViewCell *cell = (UITableViewCell *)[[[sender superview] superview] superview];
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[sender superview] superview];
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    UITextField *old_Password = (UITextField*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:indexPath.section]]) viewWithTag:55];
    
    UITextField *new_Password = (UITextField*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section]]) viewWithTag:66];
    
    UITextField *confirm_Password = (UITextField*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]]) viewWithTag:77];
    
    if(old_Password.text.length==0 || new_Password.text.length==0 || confirm_Password.text.length==0)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter values in all the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:@"Please enter values in all the fields."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;

        return;
    }
    else if(![new_Password.text isEqualToString:confirm_Password.text])
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"New password doesn't match. Try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:@"New password doesn't match. Try again"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        return;
    }
    else if(new_Password.text.length<8)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your password should be at least 8 characters long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:@"Your password should be at least 8 characters long."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        
        return;
    }
    else
    {
        //call webservice
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/changepassword"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSError *error;
            
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",old_Password.text,@"old_password",new_Password.text,@"new_password",confirm_Password.text,@"confirm_password",nil];
            
            
            
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
            
            NSError *error1 = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error1];
            if([request responseStatusCode] == 200)
            {
                
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Settings has been changed."] || [[jsonResponse objectForKey:@"message"] isEqualToString:@"Password has been changed."])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Password has been changed successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    alert.delegate = self;
//                    alert.tag = 4747;
//                    [alert show];
//                    alert = nil;

                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Password has been changed successfully"
                                                                                  okButtonTitle:@"OK"];
                    alertView.tag = 4747;
                    alertView.delegate = nil;
                    [alertView showForPresentView];
                    alertView = nil;
                    
                    
                    old_Password.text = @"";
                    new_Password.text = @"";
                    confirm_Password.text = @"";
                }
                
            }
            else if([request responseStatusCode] == 401)
            {
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Password did not match"])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Old password did not match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Old password did not match"
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView showForPresentView];
                    alertView = nil;
                }
                else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"New Password is not equal to old password."])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your new password is same as the old one." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Your new password is same as the old one."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView showForPresentView];
                    alertView = nil;
                    
                }
            }
            else
            {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the password. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"There was a problem in saving the password. Please try again"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
                
            }

            
            
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
        
        [activity hide];
    }
}

-(void)saveNotWorkingBtnPressed:(UIButton*)sender
{
    UITableViewCell *cell ;
    
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[sender superview] superview];
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    UITextView *commentText = (UITextView*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]]) viewWithTag:99];
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/reportaproblem"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSError *error;
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"notworking",@"problem_type", commentText.text, @"comment",nil];
        
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
//        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//        NSLog(@"responseString %@",[request responseString]);
        
        notWorkingText = @"";
        commentText.text = @"";
        [tblView reloadData];
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

-(void)saveFeedbackBtnPressed:(UIButton*)sender
{
    UITableViewCell *cell ;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[sender superview] superview];
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    UITextView *commentText = (UITextView*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]]) viewWithTag:119];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/reportaproblem"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSError *error;
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"feedback",@"problem_type", commentText.text, @"comment",nil];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
//        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//        NSLog(@"responseString %@",[request responseString]);
        
        feedbackText = @"";
        commentText.text = @"";
        [tblView reloadData];
        
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

-(void)yesBtnPressed:(UIButton*)sender
{
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    [[QBChat instance] logout];
    
    [QBUsers logOutWithDelegate:self];

    //[QBAuth destroySessionWithDelegate:self];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"IsAutoLogin"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"user_token"];
    
    [defaults setObject:@"" forKey:@"phoneNumber"];
    
    [defaults setObject:@"" forKey:@"QBPassword"];
    
    [defaults setObject:@"" forKey:@"QBUserName"];
    
    [defaults setObject:@"" forKey:@"QB_id"];
    
    [defaults setObject:@"" forKey:@"user_name"];
    
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    UINavigationController *navcon = (UINavigationController*)appDelegate.window.rootViewController;
    [navcon popToRootViewControllerAnimated:YES];
    
    [modelmanager.newsfeedManager.array_model_feeds removeAllObjects];
    
    //self.navigationController.viewControllers = [NSArray arrayWithObjects:[[SignIn alloc] init], nil];
}

-(void)noBtnPressed:(UIButton*)sender
{
    UITableViewCell *cell;
    
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[sender superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[sender superview] superview];
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    
    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]-1 inSection:[indexPath section]];
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]];
    
    
    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
    
    if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
    {
        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
        
        [tblView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
        //[tblView reloadData];
    }

}

//disable push notifications webservice call
-(void)enablePushWebservice:(BOOL)isEnabled
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/change"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSError *error;
    
        NSDictionary *Dictionary;
        if(isEnabled)
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"yes",@"is_enable_push_notification",nil];
        else
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"no",@"is_enable_push_notification",nil];
        
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        //NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        //NSLog(@"responseString %@",[request responseString]);
        
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

#pragma mark -
#pragma mark PrivacyPolicy & TermConditions

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

#pragma mark -
#pragma mark TableViewDataSource & TableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cellforsection";
    UITableViewCell *cell;
    cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        
        
        UILabel *heading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20,-3, 200, 60))];
        heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        heading.textAlignment = NSTextAlignmentLeft;
        heading.tag = 11;
        heading.backgroundColor = [UIColor clearColor];
        heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        heading.lineBreakMode = YES;
        heading.numberOfLines = 1;
        heading.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:heading];
        
        UISwitch *toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(245, 14, 75, 25)];
        toggleSwitch.on = YES;
        toggleSwitch.tag = 22;
        [toggleSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        toggleSwitch.onTintColor = [UIColor colorWithRed:81/255.0 green:202/255.0 blue:211/255.0 alpha:1];
        [cell.contentView addSubview:toggleSwitch];
        
        UIImageView *seperatorView=[[UIImageView alloc] initWithFrame:CGRectMake(4, 58, 312, 2)];
        seperatorView.image = [UIImage imageNamed:@"bar.png"];
        seperatorView.tag = 47;
        [cell.contentView addSubview:seperatorView];
        
        //sharing variables
        
        UIImageView *fbIconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5f, 32, 32)];
        fbIconView.backgroundColor = [UIColor clearColor];
        fbIconView.image = [UIImage imageNamed:@"fb_disable.png"];
        fbIconView.tag = 33;
        [cell.contentView addSubview:fbIconView];
        
        UILabel *fbUserName = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(140,0, 160, 60))];
        fbUserName.textColor = [UIColor blackColor];
        fbUserName.textAlignment = NSTextAlignmentRight;
        fbUserName.tag = 44;
        fbUserName.backgroundColor = [UIColor clearColor];
        fbUserName.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        fbUserName.lineBreakMode = YES;
        fbUserName.numberOfLines = 1;
        fbUserName.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:fbUserName];
        
        //change password variables
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        
        UITextField *oldPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20,15, 280, 35)];
        
        [oldPasswordField setLeftViewMode:UITextFieldViewModeAlways];
        [oldPasswordField setLeftView:spacerView];
        spacerView = nil;
        [oldPasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [oldPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        oldPasswordField.delegate = self;
        oldPasswordField.textColor = [UIColor darkGrayColor];
        oldPasswordField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        oldPasswordField.layer.cornerRadius=1.0f;
        oldPasswordField.layer.masksToBounds=YES;
        oldPasswordField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
        oldPasswordField.layer.borderWidth= 1.0f;
        oldPasswordField.placeholder = @"Old Password";
        oldPasswordField.returnKeyType = UIReturnKeyDefault;
        oldPasswordField.secureTextEntry = YES;
        oldPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        oldPasswordField.autocorrectionType=UITextAutocorrectionTypeNo;
        [oldPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        oldPasswordField.tag = 55;
        oldPasswordField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:oldPasswordField];
        
        UITextField *newPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20,15, 280, 35)];
        spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [newPasswordField setLeftViewMode:UITextFieldViewModeAlways];
        [newPasswordField setLeftView:spacerView];
        spacerView = nil;
        [newPasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [newPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        newPasswordField.delegate = self;
        newPasswordField.tag = 66;
        newPasswordField.textColor = [UIColor darkGrayColor];
        newPasswordField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        newPasswordField.layer.cornerRadius=1.0f;
        newPasswordField.layer.masksToBounds=YES;
        newPasswordField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
        newPasswordField.layer.borderWidth= 1.0f;
        newPasswordField.placeholder = @"New Password";
        newPasswordField.returnKeyType = UIReturnKeyDefault;
        newPasswordField.secureTextEntry = YES;
        [newPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        newPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        newPasswordField.autocorrectionType=UITextAutocorrectionTypeNo;
        newPasswordField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:newPasswordField];
        
        UITextField *confirmPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(20,15, 280, 35)];
        spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [confirmPasswordField setLeftViewMode:UITextFieldViewModeAlways];
        [confirmPasswordField setLeftView:spacerView];
        spacerView = nil;
        [confirmPasswordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [confirmPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        confirmPasswordField.delegate = self;
        confirmPasswordField.tag=77;
        confirmPasswordField.textColor = [UIColor darkGrayColor];
        confirmPasswordField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        confirmPasswordField.layer.cornerRadius=1.0f;
        confirmPasswordField.layer.masksToBounds=YES;
        confirmPasswordField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
        confirmPasswordField.layer.borderWidth= 1.0f;
        confirmPasswordField.placeholder = @"Confirm Password";
        confirmPasswordField.returnKeyType = UIReturnKeyDefault;
        confirmPasswordField.secureTextEntry = YES;
        [confirmPasswordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        confirmPasswordField.autocorrectionType=UITextAutocorrectionTypeNo;
        confirmPasswordField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:confirmPasswordField];

        UIButton *savePasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        savePasswordBtn.tag = 88;
        [savePasswordBtn addTarget:self
                       action:@selector(savePasswordBtnPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        [savePasswordBtn setBackgroundImage:[UIImage imageNamed:@"save_btn.png"] forState:UIControlStateNormal];
        savePasswordBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [savePasswordBtn setEnabled:YES];
        [cell.contentView addSubview:savePasswordBtn];
        
        //Report Problem variables
        UITextView *notWorkingTextView = [[UITextView alloc] init];
        notWorkingTextView.frame = CGRectMake(20, 10, 280, 90);
        notWorkingTextView.tag = 99;
        notWorkingTextView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        notWorkingTextView.delegate = self;
        notWorkingTextView.textColor = [UIColor darkGrayColor];
        notWorkingTextView.layer.cornerRadius=1.0f;
        notWorkingTextView.layer.masksToBounds=YES;
        [notWorkingTextView setKeyboardAppearance:UIKeyboardAppearanceDark];
        notWorkingTextView.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:notWorkingTextView];
        
        UILabel *notWorkingPlaceholder = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(24, 6, 272, 40))];
        notWorkingPlaceholder.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        notWorkingPlaceholder.textAlignment = NSTextAlignmentLeft;
        notWorkingPlaceholder.text = @"Briefly explain what happened.";
        notWorkingPlaceholder.tag = 100;
        notWorkingPlaceholder.backgroundColor = [UIColor clearColor];
        notWorkingPlaceholder.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        notWorkingPlaceholder.lineBreakMode = YES;
        notWorkingPlaceholder.numberOfLines = 1;
        notWorkingPlaceholder.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:notWorkingPlaceholder];
    
        UIButton *saveNotWorkingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveNotWorkingBtn.tag = 109;
        [saveNotWorkingBtn addTarget:self
                            action:@selector(saveNotWorkingBtnPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [saveNotWorkingBtn setBackgroundImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
        saveNotWorkingBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [saveNotWorkingBtn setEnabled:YES];
        [cell.contentView addSubview:saveNotWorkingBtn];
        
        UITextView *feedbackTextView = [[UITextView alloc] init];
        feedbackTextView.frame = CGRectMake(20, 10, 280, 90);
        feedbackTextView.tag = 119;
        feedbackTextView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        feedbackTextView.delegate = self;
        feedbackTextView.textColor = [UIColor darkGrayColor];
        feedbackTextView.layer.cornerRadius=1.0f;
        feedbackTextView.layer.masksToBounds=YES;
        [feedbackTextView setKeyboardAppearance:UIKeyboardAppearanceDark];
        feedbackTextView.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:feedbackTextView];
        
        UILabel *feedbackPlaceholder = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(24, 14, 272, 40))];
        feedbackPlaceholder.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        feedbackPlaceholder.textAlignment = NSTextAlignmentLeft;
        feedbackPlaceholder.text = @"Briefly explain what you love,hate or want us to improve on.";
        feedbackPlaceholder.tag = 120;
        feedbackPlaceholder.backgroundColor = [UIColor clearColor];
        feedbackPlaceholder.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        feedbackPlaceholder.lineBreakMode = YES;
        feedbackPlaceholder.numberOfLines = 2;
        feedbackPlaceholder.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:feedbackPlaceholder];
        
        UIButton *saveFeedbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveFeedbackBtn.tag = 129;
        [saveFeedbackBtn addTarget:self
                              action:@selector(saveFeedbackBtnPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        [saveFeedbackBtn setBackgroundImage:[UIImage imageNamed:@"send_btn.png"] forState:UIControlStateNormal];
        saveFeedbackBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [saveFeedbackBtn setEnabled:YES];
        [cell.contentView addSubview:saveFeedbackBtn];

        
        //logout variables
        
        UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yesBtn.tag = 139;
        [yesBtn addTarget:self
                              action:@selector(yesBtnPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        [yesBtn setBackgroundImage:[UIImage imageNamed:@"yes_btn.png"] forState:UIControlStateNormal];
        yesBtn.frame = CGRectMake(20, 5, 280/2-10, 65/2.0);
        [yesBtn setEnabled:YES];
        [cell.contentView addSubview:yesBtn];
        
        UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noBtn.tag = 149;
        [noBtn addTarget:self
                   action:@selector(noBtnPressed:)
         forControlEvents:UIControlEventTouchUpInside];
        [noBtn setBackgroundImage:[UIImage imageNamed:@"no_btn.png"] forState:UIControlStateNormal];
        noBtn.frame = CGRectMake(170, 5, 280/2-10, 65/2.0);
        [noBtn setEnabled:YES];
        [cell.contentView addSubview:noBtn];
        
    }
    
    UILabel *Heading=(UILabel*)[cell.contentView viewWithTag:11];
    UISwitch *ToggleSwitch=(UISwitch*)[cell.contentView viewWithTag:22];
    UIImageView *SeperatorView=(UIImageView*)[cell.contentView viewWithTag:47];
    UILabel *FbUserName=(UILabel*)[cell.contentView viewWithTag:44];
    UIImageView *FbIconView=(UIImageView*)[cell.contentView viewWithTag:33];
    UITextField *OldPassword=(UITextField*)[cell.contentView viewWithTag:55];
    UITextField *NewPassword=(UITextField*)[cell.contentView viewWithTag:66];
    UITextField *ConfirmPassword=(UITextField*)[cell.contentView viewWithTag:77];
    UITextField *SavePasswordBtn=(UITextField*)[cell.contentView viewWithTag:88];
    UITextView *NotWorkingTextView=(UITextView*)[cell.contentView viewWithTag:99];
    UILabel *NotWorkingPlaceholder=(UILabel*)[cell.contentView viewWithTag:100];
    UIButton *SaveNotWorkingBtn=(UIButton*)[cell.contentView viewWithTag:109];
    UITextView *FeedbackTextView=(UITextView*)[cell.contentView viewWithTag:119];
    UILabel *FeedbackPlaceholder=(UILabel*)[cell.contentView viewWithTag:120];
    UIButton *SaveFeedbackBtn=(UIButton*)[cell.contentView viewWithTag:129];
    
    UIButton *YesBtn=(UIButton*)[cell.contentView viewWithTag:139];
    UIButton *NoBtn=(UIButton*)[cell.contentView viewWithTag:149];

    Heading.frame = CGRectMake(20,-3, 200, 60);
    
    SeperatorView.frame = CGRectMake(4, 58, 312, 2);
    
    if(indexPath.section==0)
    {
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.text = @"Push Notifications";
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"pushEnabled"]==nil)
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"pushEnabled"];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"pushEnabled"] isEqualToString:@"yes"])
            [ToggleSwitch setOn:YES];
        else
            [ToggleSwitch setOn:NO];
        ToggleSwitch.hidden = NO;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
        
    }
    else if(indexPath.section==1)
    {
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.text = @"In-App Sounds";
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"inAppSounds"]==nil)
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"inAppSounds"];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"inAppSounds"] isEqualToString:@"yes"])
            [ToggleSwitch setOn:YES];
        else
            [ToggleSwitch setOn:NO];
        
        ToggleSwitch.hidden = NO;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
    }
    else if(indexPath.section==2)
    {
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
        
        if(indexPath.row==0)
        {
            Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            Heading.text = @"Sharing";
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            
            if([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            else
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
        }
        else if(indexPath.row==1)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"facebook";
            FbIconView.hidden = NO;
            FbUserName.hidden = NO;
            Heading.frame = CGRectMake(60,0, 100, 60);
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"fb_login"] == true)
            {
                FbUserName.text = [[[NSUserDefaults standardUserDefaults] stringForKey:@"fbUserName"] capitalizedString];
                
                FbIconView.image = [UIImage imageNamed:@"fb_enable.png"];
            }
            else
            {
                FbIconView.image = [UIImage imageNamed:@"fb_disable.png"];
                FbUserName.text = @"";
            }
            
        }
        
        ToggleSwitch.hidden = YES;
    }
    else if(indexPath.section==3)
    {
        if(indexPath.row==0)
        {
            Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            Heading.text = @"Account";
            OldPassword.hidden = YES;
            NewPassword.hidden = YES;
            ConfirmPassword.hidden = YES;
            SavePasswordBtn.hidden = YES;
            SeperatorView.hidden = NO;
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            
            if([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            else
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
        }
        else if(indexPath.row==1)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"Edit Profile";
            OldPassword.hidden = YES;
            NewPassword.hidden = YES;
            ConfirmPassword.hidden = YES;
            SavePasswordBtn.hidden = YES;
            SeperatorView.hidden = NO;
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            
            SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
        }
        else if(indexPath.row==2)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"Change Password";
            OldPassword.hidden = YES;
            NewPassword.hidden = YES;
            ConfirmPassword.hidden = YES;
            SavePasswordBtn.hidden = YES;
            SeperatorView.hidden = NO;
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
        }
        else if(indexPath.row==3)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"Deactivate Account";
            OldPassword.hidden = YES;
            NewPassword.hidden = YES;
            ConfirmPassword.hidden = YES;
            SavePasswordBtn.hidden = YES;
            SeperatorView.hidden = NO;
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
        }
        
        
        if([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
        {
            if(indexPath.row==3)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                OldPassword.hidden = NO;
                OldPassword.text = oldPassword;
                NewPassword.hidden = YES;
                ConfirmPassword.hidden = YES;
                SavePasswordBtn.hidden = YES;
                SeperatorView.hidden = YES;
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
            }
            else if(indexPath.row==4)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                OldPassword.hidden = YES;
                NewPassword.hidden = NO;
                NewPassword.text = newPassword;
                ConfirmPassword.hidden = YES;
                SavePasswordBtn.hidden = YES;
                SeperatorView.hidden = YES;
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            }
            else if(indexPath.row==5)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                OldPassword.hidden = YES;
                NewPassword.hidden = YES;
                ConfirmPassword.hidden = NO;
                ConfirmPassword.text = confirmPassword;
                SavePasswordBtn.hidden = YES;
                SeperatorView.hidden = YES;
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            }
            else if(indexPath.row==6)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                OldPassword.hidden = YES;
                NewPassword.hidden = YES;
                ConfirmPassword.hidden = YES;
                SavePasswordBtn.hidden = NO;
                SeperatorView.hidden = NO;
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            }
            else if(indexPath.row==7)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"Deactivate Account";
                OldPassword.hidden = YES;
                NewPassword.hidden = YES;
                ConfirmPassword.hidden = YES;
                SavePasswordBtn.hidden = YES;
                SeperatorView.hidden = NO;
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
            }

        }
        
        ToggleSwitch.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
    }
    else if(indexPath.section==4)
    {
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.text = @"Privacy Policy";
        ToggleSwitch.hidden = YES;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
    }
    else if(indexPath.section==5)
    {
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.text = @"Terms of Use";
        ToggleSwitch.hidden = YES;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
    }
    else if(indexPath.section==6)
    {
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
        if(indexPath.row==0)
        {
            Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            Heading.text = @"Report a Problem";
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            if([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            else
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
        }
        else if(indexPath.row==1)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"Spam or Abuse";
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
        }
        else if(indexPath.row==2)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"It's not working";
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
        }
        else if(indexPath.row==3)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];

            Heading.text = @"General feedback";
            NotWorkingTextView.hidden = YES;
            SaveNotWorkingBtn.hidden = YES;
            FeedbackTextView.hidden = YES;
            SaveFeedbackBtn.hidden = YES;
            FbIconView.hidden = YES;
            FbUserName.hidden = YES;
            NotWorkingPlaceholder.hidden = YES;
            FeedbackPlaceholder.hidden = YES;
            
            if(isFeedbackOpen==true)
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            else
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
        }
        
        if([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
        {
            if(indexPath.row==3)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                NotWorkingTextView.hidden = NO;
                NotWorkingTextView.text = notWorkingText;
                SaveNotWorkingBtn.hidden = YES;
                SeperatorView.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                if(NotWorkingTextView.text.length==0)
                    NotWorkingPlaceholder.hidden = NO;
                else
                    NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            }
            else if(indexPath.row==4)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = NO;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                
            }
            else if(indexPath.row==5)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                
                Heading.text = @"General feedback";
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
                if(isFeedbackOpen)
                    SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
                else
                    SeperatorView.frame = CGRectMake(4, 58, 312, 2);
            }

            if(isFeedbackOpen)
            {
                if(indexPath.row==6)
                {
                    Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                    Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                    Heading.text = @"";
                    NotWorkingTextView.hidden = YES;
                    SaveNotWorkingBtn.hidden = YES;
                    SeperatorView.hidden = YES;
                    FeedbackTextView.hidden = NO;
                    FeedbackTextView.text = feedbackText;
                    SaveFeedbackBtn.hidden = YES;
                    FbIconView.hidden = YES;
                    FbUserName.hidden = YES;
                    NotWorkingPlaceholder.hidden = YES;
                    if(FeedbackTextView.text.length==0)
                        FeedbackPlaceholder.hidden = NO;
                    else
                        FeedbackPlaceholder.hidden = YES;
                    SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
                }
                else if(indexPath.row==7)
                {
                    Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                    Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                    Heading.text = @"";
                    NotWorkingTextView.hidden = YES;
                    SaveNotWorkingBtn.hidden = YES;
                    FeedbackTextView.hidden = YES;
                    SaveFeedbackBtn.hidden = NO;
                    FbIconView.hidden = YES;
                    FbUserName.hidden = YES;
                    NotWorkingPlaceholder.hidden = YES;
                    FeedbackPlaceholder.hidden = YES;
                }

            }
        }
        else if(isFeedbackOpen)
        {
            if(indexPath.row==4)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                SeperatorView.hidden = YES;
                FeedbackTextView.hidden = NO;
                FeedbackTextView.text = feedbackText;
                SaveFeedbackBtn.hidden = YES;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                if(FeedbackTextView.text.length==0)
                    FeedbackPlaceholder.hidden = NO;
                else
                    FeedbackPlaceholder.hidden = YES;
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            }
            else if(indexPath.row==5)
            {
                Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
                Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
                Heading.text = @"";
                NotWorkingTextView.hidden = YES;
                SaveNotWorkingBtn.hidden = YES;
                FeedbackTextView.hidden = YES;
                SaveFeedbackBtn.hidden = NO;
                FbIconView.hidden = YES;
                FbUserName.hidden = YES;
                NotWorkingPlaceholder.hidden = YES;
                FeedbackPlaceholder.hidden = YES;
            }
            
        }

        

        ToggleSwitch.hidden = YES;
    }
    else if(indexPath.section==7)
    {
        Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
        Heading.text = @"Logout";
        ToggleSwitch.hidden = YES;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = NO;
        NotWorkingTextView.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        
        
        if(indexPath.row==0)
        {
            Heading.text = @"Logout";
            YesBtn.hidden = YES;
            NoBtn.hidden = YES;
            
            if([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                SeperatorView.frame = CGRectMake(8, 58, 304, 0.75f);
            else
                SeperatorView.frame = CGRectMake(4, 58, 312, 2);
        }
        else if(indexPath.row==1)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"Are you sure you want to log out?";
            YesBtn.hidden = YES;
            NoBtn.hidden = YES;
            SeperatorView.hidden = YES;
            
        }
        else if(indexPath.row==2)
        {
            Heading.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
            Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            Heading.text = @"";
            YesBtn.hidden = NO;
            NoBtn.hidden = NO;
        }

    }
    else if(indexPath.section==8)
    {
        Heading.text = @"";
        ToggleSwitch.hidden = YES;
        OldPassword.hidden = YES;
        NewPassword.hidden = YES;
        ConfirmPassword.hidden = YES;
        SavePasswordBtn.hidden = YES;
        SeperatorView.hidden = YES;
        NotWorkingTextView.hidden = YES;
        NotWorkingPlaceholder.hidden = YES;
        SaveNotWorkingBtn.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        SaveFeedbackBtn.hidden = YES;
        FbIconView.hidden = YES;
        FbUserName.hidden = YES;
        YesBtn.hidden = YES;
        NoBtn.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            
        case 1:
            return 1;
            
        case 2:
            if ([[isSectionOpen objectAtIndex:section] isEqualToString:@"true"]) {
                return 2;
            }
            else
            {
                return 1;
            }
            
        case 3:
            if ([[isSectionOpen objectAtIndex:section] isEqualToString:@"true"]) {
                if([[isRowOpen objectAtIndex:section] isEqualToString:@"true"])
                    return 4+4;
                else
                    return 4;
            }
            else
            {
                return 1;
            }

        case 4:
                return 1;
            
        case 5:
            return 1;
            
        case 6:
            if ([[isSectionOpen objectAtIndex:section] isEqualToString:@"true"]) {
                if([[isRowOpen objectAtIndex:section] isEqualToString:@"true"])
                    if(isFeedbackOpen)
                        return 4+2+2;
                    else
                        return 4+2;
                else if(isFeedbackOpen)
                    return 4+2;
                else
                    return 4;
            }
            else
            {
                return 1;
            }
            
        case 7:
            if ([[isSectionOpen objectAtIndex:section] isEqualToString:@"true"]) {
                return 3;
            }
            else
            {
                return 1;
            }
            
        default:
            return 1;
            break;
    }

    
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==6)
    {
        if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
        {
            if([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
            {
                if(indexPath.row==3)
                    return 100;
                if(isFeedbackOpen && indexPath.row==6)
                    return 100;
                    
            }
            else if(isFeedbackOpen && indexPath.row==4)
                return 100;
        }
    }
    else if(indexPath.section==8)
        return 100;
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch ([indexPath section]) {
        case 2: {
            
            switch ([indexPath row]) {
                case 0:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, nil];
                    
                    if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        
                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                case 1:
                {
                    if([[NSUserDefaults standardUserDefaults] boolForKey:@"fb_login"] == true)
                    {
                        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
                        [FBSession.activeSession closeAndClearTokenInformation];
                        [tableView reloadData];
                    }
                    else
                        [self FBButtonAction];
                    break;
                }

                default:
                {
                    break;
                }
            }
            
            break;
        }
        case 3: {
            
            switch ([indexPath row]) {
                case 0:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    NSIndexPath *path2 = [NSIndexPath indexPathForRow:[indexPath row]+3 inSection:[indexPath section]];
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, nil];
                    
                    if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        
                        oldPassword = @"";
                        newPassword = @"";
                        confirmPassword = @"";
                        
                        if ([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                        {
                            [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                            
                            NSIndexPath *path3 = [NSIndexPath indexPathForRow:[indexPath row]+4 inSection:[indexPath section]];
                            NSIndexPath *path4 = [NSIndexPath indexPathForRow:[indexPath row]+5 inSection:[indexPath section]];
                            NSIndexPath *path5 = [NSIndexPath indexPathForRow:[indexPath row]+6 inSection:[indexPath section]];
                            NSIndexPath *path6 = [NSIndexPath indexPathForRow:[indexPath row]+7 inSection:[indexPath section]];
                            
                            indexPathArray = nil;
                            indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, path3, path4, path5, path6, nil];
                            
                        }

                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        [tableView reloadData];
                    }
                    else
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                    
                case 1:
                {
                    EditProfileViewController *editProfile = [[EditProfileViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:editProfile animated:YES];
                    editProfile = nil;
                    break;

                }
                    
                case 2:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    NSIndexPath *path2 = [NSIndexPath indexPathForRow:[indexPath row]+3 inSection:[indexPath section]];
                    NSIndexPath *path3 = [NSIndexPath indexPathForRow:[indexPath row]+4 inSection:[indexPath section]];
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, path3, nil];
                    
                    if ([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        oldPassword = @"";
                        newPassword = @"";
                        confirmPassword = @"";
                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                
                case 3:
                {
                    if([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"false"])
                    {
                        DeactivateAccountView *obj = [[DeactivateAccountView alloc] initWithNibName:nil bundle:nil];
                        [self.navigationController pushViewController:obj animated:YES];
                        obj = nil;
                        break;
                    }
                }
                    
                case 7:
                {
                    DeactivateAccountView *obj = [[DeactivateAccountView alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:obj animated:YES];
                    obj = nil;
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
            
            break;
        }
        case 4:
        {
            [self clk_btn_PrivacyPolicy];
            break;
        }
        case 5:
        {
            [self clk_btn_TermConditions];
            break;
        }
        case 6: {
            
            switch ([indexPath row]) {
                case 0:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    NSIndexPath *path2 = [NSIndexPath indexPathForRow:[indexPath row]+3 inSection:[indexPath section]];
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, nil];
                    
                    if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        
                        notWorkingText = @"";
                        feedbackText = @"";
                        
                        if ([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                        {
                            [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                            
                            NSIndexPath *path3 = [NSIndexPath indexPathForRow:[indexPath row]+4 inSection:[indexPath section]];
                            NSIndexPath *path4 = [NSIndexPath indexPathForRow:[indexPath row]+5 inSection:[indexPath section]];
                            
                            indexPathArray = nil;
                            indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, path3, path4, nil];
                            
                            if(isFeedbackOpen)
                            {
                                isFeedbackOpen = false;
                                
                                NSIndexPath *path5 = [NSIndexPath indexPathForRow:[indexPath row]+6 inSection:[indexPath section]];
                                NSIndexPath *path6 = [NSIndexPath indexPathForRow:[indexPath row]+7 inSection:[indexPath section]];
                                indexPathArray = nil;
                                indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, path3, path4,path5,path6, nil];
                            }
                           
                            
                            
                        }
                        else if(isFeedbackOpen)
                        {
                            isFeedbackOpen = false;
                            
                            NSIndexPath *path3 = [NSIndexPath indexPathForRow:[indexPath row]+4 inSection:[indexPath section]];
                            NSIndexPath *path4 = [NSIndexPath indexPathForRow:[indexPath row]+5 inSection:[indexPath section]];
                            
                            indexPathArray = nil;
                            indexPathArray = [NSArray arrayWithObjects:path0, path1, path2, path3, path4, nil];
                        }

                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                    
                case 1:
                {
                    SpamAbuseViewController *obj = [[SpamAbuseViewController alloc] initWithNibName:nil bundle:nil];
                    [self.navigationController pushViewController:obj animated:YES];
                    obj = nil;

                    break;
                }
                    
                case 2:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                    
                    if ([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        notWorkingText = @"";
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        [isRowOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                case 3:
                {
                    if([[isRowOpen objectAtIndex:indexPath.section] isEqualToString:@"false"])
                    {
                    
                        NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                        NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                        
                        
                        NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                        
                        if (isFeedbackOpen)
                        {
                            isFeedbackOpen = false;
                            feedbackText = @"";
                            [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                            //[tableView reloadData];
                        }
                        else
                        {
                            isFeedbackOpen = true;
                            
                            [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                            
                            [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                            //[tableView reloadData];
                        }
                    }
                    
                    break;
                }
                case 5:
                {
                    
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                    
                    if (isFeedbackOpen)
                    {
                        isFeedbackOpen = false;
                        feedbackText = false;
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        isFeedbackOpen = true;
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
                default:
                {
                    break;
                }
            }
            
            break;
        }
            
        case 7: {
            
            switch ([indexPath row]) {
                case 0:
                {
                    NSIndexPath *path0 = [NSIndexPath indexPathForRow:[indexPath row]+1 inSection:[indexPath section]];
                    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[indexPath row]+2 inSection:[indexPath section]];
                    
                    
                    NSArray *indexPathArray = [NSArray arrayWithObjects:path0, path1, nil];
                    
                    if ([[isSectionOpen objectAtIndex:indexPath.section] isEqualToString:@"true"])
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"false"];
                        
                        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationMiddle];
                        //[tableView reloadData];
                    }
                    else
                    {
                        [isSectionOpen replaceObjectAtIndex:indexPath.section withObject:@"true"];
                        
                        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationTop];
                        
                        //[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
                        //[tableView reloadData];
                    }
                    
                    break;
                }
        
                default:
                {
                    break;
                }
            }
            
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}


#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==55)
        oldPassword = textField.text;
    else if(textField.tag == 66)
        newPassword = textField.text;
    else if(textField.tag == 77)
        confirmPassword = textField.text;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell ;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[textField superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[textField superview] superview];
    }
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return YES;
}

#pragma mark Text View Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // dismiss keyboard and send comment
    if([text isEqualToString:@"\n"]) {
        if(textView.text.length==0)
        {
            UITableViewCell *cell;
            
            if (IS_IOS_7)
            {
                cell=(UITableViewCell *)[[[textView superview] superview] superview];
            }
            else
            {
                cell=(UITableViewCell *)[[textView superview] superview];
            }
            //NSIndexPath *indexPath = [tblView indexPathForCell:cell];
            
            if(textView.tag==99)
            {
                UILabel *placeHolder1 = (UILabel*)[cell.contentView viewWithTag:100];
                placeHolder1.hidden = NO;
            }
            else if(textView.tag == 119)
            {
                UILabel *placeHolder2 = (UILabel*)[cell.contentView viewWithTag:120];
                placeHolder2.hidden = NO;
            }
        }
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewShouldBeginEditing:");
    
    UITableViewCell *cell ;
    
    if (IS_IOS_7)
    {
      cell  = (UITableViewCell *)[[[textView superview] superview] superview];
    }
    else
    {
        cell= (UITableViewCell *)[[textView superview] superview] ;
    }
    
    //NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    UILabel *placeHolder1 = (UILabel*)[cell.contentView viewWithTag:100];
    placeHolder1.hidden = YES;
    
    UILabel *placeHolder2 = (UILabel*)[cell.contentView viewWithTag:120];
    placeHolder2.hidden = YES;

    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing:");
    UITableViewCell *cell ;
    if (IS_IOS_7)
    {
        cell =(UITableViewCell *)[[[textView superview] superview] superview];
    }
    else
    {
        cell =(UITableViewCell *)[[textView superview] superview] ;
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
    
    if(textView.tag==99)
        notWorkingText = textView.text;
    else if(textView.tag == 119)
        feedbackText = textView.text;
}

- (void)switchValueChanged:(UISwitch *)theSwitch
{
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
         cell = (UITableViewCell *)[[[theSwitch superview] superview] superview];
    }
    else
    {
          cell = (UITableViewCell *)[[theSwitch superview] superview] ;
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    BOOL flag = theSwitch.on;
    
    if(indexPath.section==0)
    {
    
        if(!flag)
        {
            [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"pushEnabled"];
            //[self enablePushWebservice:false];
        }
        else
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"pushEnabled"];
            //[self enablePushWebservice:true];
        }
    }
    else if(indexPath.section==1)
    {
        if(flag)
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"inAppSounds"];
        else
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"inAppSounds"];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_InAppSoundsFlag object:nil userInfo:nil];
    }
}

-(void)FBButtonAction
{
    
        if(activity==nil)
            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        [activity show];
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream",@"publish_actions",nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES  completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            
            FBSession.activeSession = session;
            
            
            [self getuserID];  // get user details
            [activity hide];
            
        }
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
            [FBSession.activeSession closeAndClearTokenInformation];
            
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
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"fbUserName"];
            
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
            [alertView showForPresentView];
            alertView = nil;
            
            [activity hide];
            return;
            // [self showLoginView];
        }
            break;
        default:
            break;
    }
    
    if (error)
    {
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
        [alertView showForPresentView];
        alertView = nil;
        
        [activity hide];
    }
    
    [activity hide];
}

-(void)getuserID

{
    //[FBSettings setLoggingBehavior:[NSSet setWithObjects:
    // FBLoggingBehaviorFBRequests, nil]];
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         if (!error) {
             
             
             NSLog(@"fbUserName is : %@",user.name);
             
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:user.name forKey:@"fbUserName"];
             
             [tblView reloadData];
         }
         else
         {
             NSLog(@"error");
         }
     }];
}

-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}

#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}

- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
            
        }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
