//
//  SpamAbuseViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 30/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "SpamAbuseViewController.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

@interface SpamAbuseViewController ()

@end

@implementation SpamAbuseViewController

@synthesize LblSettings,topBarImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [profilemanager.ownerDetails getProfileInfo:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    
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
    
    selectedIndex = 0;
    selectedOption = @"Hacked accounts.";
    
    feedbackText = @"";
    
    LblSettings.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    UILabel *Heading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0,55, 320, 30))];
    Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
    Heading.text = @"Spam or Abuse";
    Heading.textAlignment = NSTextAlignmentCenter;
    Heading.backgroundColor = [UIColor clearColor];
    Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
    Heading.lineBreakMode = YES;
    Heading.numberOfLines = 1;
    Heading.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:Heading];
    
    UILabel *SubHeading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20,92, 140, 25))];
    SubHeading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
    SubHeading.text = @"Report something.";
    SubHeading.textAlignment = NSTextAlignmentLeft;
    SubHeading.backgroundColor = [UIColor clearColor];
    SubHeading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
    SubHeading.lineBreakMode = YES;
    SubHeading.numberOfLines = 1;
    SubHeading.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:SubHeading];
    
    UILabel *SubHeading2 = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(142,92, 120, 25))];
    SubHeading2.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
    SubHeading2.text = @"Choose One";
    SubHeading2.textAlignment = NSTextAlignmentLeft;
    SubHeading2.backgroundColor = [UIColor clearColor];
    SubHeading2.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
    SubHeading2.lineBreakMode = YES;
    SubHeading2.numberOfLines = 1;
    SubHeading2.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:SubHeading2];
    
    UIImageView *SeperatorView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 123, 300, 2)];
    SeperatorView.image = [UIImage imageNamed:@"bar.png"];
    [self.view addSubview:SeperatorView];
    
    
    tblView = [[UITableView alloc] init];
    tblView.frame = CGRectMake(0, 125, 320, 480-125);
    tblView.backgroundColor = [UIColor whiteColor];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 125, 320, 568-125);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 125, 320, 568-125);
        }
        else
        {
            tblView.frame = CGRectMake(0, 125, 320, 480-125);
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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//    [self.view addGestureRecognizer:tap];
    
    [self.view bringSubviewToFront:self.tintView];

}

//- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
//{
//    [self.view endEditing:YES];
//}

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
        
        
        UILabel *heading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(55,-2, 225, 40))];
        heading.textColor = [UIColor blackColor];
        heading.textAlignment = NSTextAlignmentLeft;
        heading.tag = 11;
        heading.backgroundColor = [UIColor clearColor];
        heading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        heading.lineBreakMode = YES;
        heading.numberOfLines = 1;
        heading.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:heading];
        
        
        UIImageView *seperatorView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 38, 300, 2)];
        seperatorView.image = [UIImage imageNamed:@"bar.png"];
        seperatorView.tag = 22;
        [cell.contentView addSubview:seperatorView];
        
        //sharing variables
        
        UIImageView *radioIconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, 22, 22)];
        radioIconView.backgroundColor = [UIColor clearColor];
        radioIconView.image = [UIImage imageNamed:@"bubble_inactive.png"];
        radioIconView.tag = 33;
        [cell.contentView addSubview:radioIconView];
        
        
        UITextView *feedbackTextView = [[UITextView alloc] init];
        feedbackTextView.frame = CGRectMake(20, 10, 280, 90);
        feedbackTextView.tag = 44;
        feedbackTextView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        feedbackTextView.delegate = self;
        feedbackTextView.textColor = [UIColor darkGrayColor];
        feedbackTextView.layer.cornerRadius=1.0f;
        feedbackTextView.layer.masksToBounds=YES;
        [feedbackTextView setKeyboardAppearance:UIKeyboardAppearanceDark];
        feedbackTextView.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:feedbackTextView];
        
        UILabel *feedbackPlaceholder = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(24, 12, 272, 20))];
        feedbackPlaceholder.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        feedbackPlaceholder.textAlignment = NSTextAlignmentLeft;
        feedbackPlaceholder.text = @"Please provide details.";
        feedbackPlaceholder.tag = 55;
        feedbackPlaceholder.backgroundColor = [UIColor clearColor];
        feedbackPlaceholder.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        feedbackPlaceholder.lineBreakMode = YES;
        feedbackPlaceholder.numberOfLines = 1;
        feedbackPlaceholder.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:feedbackPlaceholder];
        
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reportBtn.tag = 66;
        [reportBtn addTarget:self
                            action:@selector(reportBtnPressed:)
                  forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setBackgroundImage:[UIImage imageNamed:@"report_btn.png"] forState:UIControlStateNormal];
        reportBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [reportBtn setEnabled:YES];
        [cell.contentView addSubview:reportBtn];
        
        
        
        
    }
    
    UILabel *Heading=(UILabel*)[cell.contentView viewWithTag:11];
    
    UIImageView *SeperatorView=(UIImageView*)[cell.contentView viewWithTag:22];
    
    UIImageView *RadioIconView=(UIImageView*)[cell.contentView viewWithTag:33];
    
    UITextView *FeedbackTextView=(UITextView*)[cell.contentView viewWithTag:44];
    UILabel *FeedbackPlaceholder=(UILabel*)[cell.contentView viewWithTag:55];
    UIButton *ReportBtn=(UIButton*)[cell.contentView viewWithTag:66];
    
    RadioIconView.hidden = YES;
    FeedbackTextView.hidden = YES;
    FeedbackPlaceholder.hidden = YES;
    ReportBtn.hidden = YES;
    
    Heading.frame = CGRectMake(55,-2, 225, 40);
    
    SeperatorView.frame = CGRectMake(10, 38, 300, 2);
    
    if(indexPath.row == selectedIndex)
        RadioIconView.image = [UIImage imageNamed:@"bubble.png"];
    else
        RadioIconView.image = [UIImage imageNamed:@"bubble_inactive.png"];
    
    
    if(indexPath.row==0)
    {
        Heading.text = @"Hacked accounts.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==1)
    {
        Heading.text = @"Impersonation accounts.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==2)
    {
        Heading.text = @"Underage.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==3)
    {
        Heading.text = @"Intellectual Property.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==4)
    {
        Heading.text = @"Self-harm";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==5)
    {
        Heading.text = @"Spam";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==6)
    {
        Heading.text = @"Abuse";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==7)
    {
        Heading.text = @"Exploitation";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==8)
    {
        Heading.text = @"Other";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==9)
    {
        Heading.text = @"";
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = NO;
        FeedbackPlaceholder.hidden = NO;
        FeedbackTextView.text = feedbackText;
        if(FeedbackTextView.text.length==0)
            FeedbackPlaceholder.hidden = NO;
        else
            FeedbackPlaceholder.hidden = YES;
        
        ReportBtn.hidden = YES;
        SeperatorView.frame = CGRectZero;
    }
    else if(indexPath.row==10)
    {
        Heading.text = @"";
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = NO;
        SeperatorView.frame = CGRectZero;
    }
    else if(indexPath.row==11)
    {
        Heading.text = @"";
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
        SeperatorView.frame = CGRectZero;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==9)
        return 100;
    else if(indexPath.row==10)
        return 60;
    else if(indexPath.row==11)
        return 160;
    else
        return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==0)
    {
        selectedOption = @"Hacked accounts.";
    }
    else if(indexPath.row==1)
    {
        selectedOption = @"Impersonation accounts.";
    }
    else if(indexPath.row==2)
    {
        selectedOption = @"Underage.";
    }
    else if(indexPath.row==3)
    {
        selectedOption = @"Intellectual Property.";
    }
    else if(indexPath.row==4)
    {
        selectedOption = @"Self-harm";
    }
    else if(indexPath.row==5)
    {
        selectedOption = @"Spam";
    }
    else if(indexPath.row==6)
    {
        selectedOption = @"Abuse";
    }
    else if(indexPath.row==7)
    {
        selectedOption = @"Exploitation";
    }
    else if(indexPath.row==8)
    {
        selectedOption = @"Other";
    }

    if(indexPath.row<9)
    {
        selectedIndex = indexPath.row;
        [tblView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//call webservice
-(void)reportBtnPressed:(UIButton*)sender
{
    
 //   [[Mixpanel sharedInstance] track:@"ReportProblemSpamOrAbuse"];

    [[Mixpanel sharedInstance] track:@"LeftMenuSettingsButtonClicked" properties:@{
                                                            @"Activity": @"ReportProblemSpamOrAbuse"
                                                            }];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/reportaproblem"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSError *error;
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"spamorabuse",@"problem_type", selectedOption,@"spam_or_abuse_type", feedbackText, @"comment",nil];
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
//                NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//                NSLog(@"responseString %@",[request responseString]);
        
        feedbackText = @"";
        [tblView reloadData];
        
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
                cell= (UITableViewCell *)[[[textView superview] superview] superview];
            }
            else
            {
                cell=(UITableViewCell *)[[textView superview] superview] ;
            }
          
            //NSIndexPath *indexPath = [tblView indexPathForCell:cell];
            
            if(textView.tag==44)
            {
                UILabel *placeHolder1 = (UILabel*)[cell.contentView viewWithTag:55];
                placeHolder1.hidden = NO;
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
        cell= (UITableViewCell *)[[[textView superview] superview] superview];
    }
    else
    {
       cell = (UITableViewCell *)[[textView superview] superview] ;
    }
    
    //NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    UILabel *placeHolder1 = (UILabel*)[cell.contentView viewWithTag:55];
    placeHolder1.hidden = YES;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing:");
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
       cell = (UITableViewCell *)[[[textView superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[textView superview] superview] ;
    }
    
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
    
    if(textView.tag == 44)
        feedbackText = textView.text;
}

- (IBAction)leftSideMenuButtonPressed:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
