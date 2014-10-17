//
//  DeactivateAccountView.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 02/07/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "DeactivateAccountView.h"
#import "MFSideMenu.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SignIn.h"


@interface DeactivateAccountView ()

@end

@implementation DeactivateAccountView

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
    
    selectedIndex = 1;
    selectedOption = @"This is temporary. I'll be back.";
    isEmailOpted = true;
    
    feedbackText = @"";
    passwordString =@"";
    
    LblSettings.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    UILabel *Heading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0,52, 320, 30))];
    Heading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
    Heading.text = @"Deactivate account";
    Heading.textAlignment = NSTextAlignmentCenter;
    Heading.backgroundColor = [UIColor clearColor];
    Heading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20.0];
    Heading.lineBreakMode = YES;
    Heading.numberOfLines = 1;
    Heading.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:Heading];
    
    UILabel *SubHeading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20,85, 280, 100))];
    SubHeading.textColor = [UIColor blackColor];
    SubHeading.text = @"Deactivating your account will disable your profile and remove your name and picture from your friends' list. Some information may still be visible to others, such as posts shared on the Feed.";
    SubHeading.textAlignment = NSTextAlignmentLeft;
    SubHeading.backgroundColor = [UIColor clearColor];
    SubHeading.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
    SubHeading.lineBreakMode = YES;
    SubHeading.numberOfLines = 5;
    SubHeading.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.view addSubview:SubHeading];
    
    
    tblView = [[UITableView alloc] init];
    tblView.frame = CGRectMake(0, 192, 320, 480-192);
    tblView.backgroundColor = [UIColor whiteColor];
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 192, 320, 568-192);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            tblView.frame = CGRectMake(0, 192, 320, 568-192);
        }
        else
        {
            tblView.frame = CGRectMake(0, 192, 320, 480-192);
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
        
        UILabel *topHeading = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20,8, 265, 25))];
        topHeading.textColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:103/255.0 alpha:1];
        topHeading.text = @"Reason for leaving.";
        topHeading.textAlignment = NSTextAlignmentLeft;
        topHeading.backgroundColor = [UIColor clearColor];
        topHeading.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
        topHeading.lineBreakMode = YES;
        topHeading.numberOfLines = 1;
        topHeading.tag = 1111;
        topHeading.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:topHeading];
        
        UILabel *topHeading2 = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(145,8, 120, 25))];
        topHeading2.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        topHeading2.text = @"Choose One";
        topHeading2.textAlignment = NSTextAlignmentLeft;
        topHeading2.backgroundColor = [UIColor clearColor];
        topHeading2.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        topHeading2.lineBreakMode = YES;
        topHeading2.numberOfLines = 1;
        topHeading2.tag = 2222;
        topHeading2.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:topHeading2];

        
        
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
        feedbackTextView.frame = CGRectMake(20, 6, 280, 90);
        feedbackTextView.tag = 44;
        feedbackTextView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        feedbackTextView.delegate = self;
        feedbackTextView.textColor = [UIColor darkGrayColor];
        feedbackTextView.layer.cornerRadius=1.0f;
        feedbackTextView.layer.masksToBounds=YES;
        [feedbackTextView setKeyboardAppearance:UIKeyboardAppearanceDark];
        feedbackTextView.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:feedbackTextView];
        
        UILabel *feedbackPlaceholder = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(24, 8, 272, 20))];
        feedbackPlaceholder.textColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
        feedbackPlaceholder.textAlignment = NSTextAlignmentLeft;
        feedbackPlaceholder.text = @"Please explain further.";
        feedbackPlaceholder.tag = 55;
        feedbackPlaceholder.backgroundColor = [UIColor clearColor];
        feedbackPlaceholder.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
        feedbackPlaceholder.lineBreakMode = YES;
        feedbackPlaceholder.numberOfLines = 1;
        feedbackPlaceholder.lineBreakMode = NSLineBreakByTruncatingTail;
        [cell.contentView addSubview:feedbackPlaceholder];
        
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        
        UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20,2, 280, 35)];
        
        [passwordField setLeftViewMode:UITextFieldViewModeAlways];
        [passwordField setLeftView:spacerView];
        spacerView = nil;
        [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [passwordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        passwordField.delegate = self;
        passwordField.textColor = [UIColor darkGrayColor];
        passwordField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        passwordField.layer.cornerRadius=1.0f;
        passwordField.layer.masksToBounds=YES;
        passwordField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
        passwordField.layer.borderWidth= 1.0f;
        passwordField.placeholder = @"Your Password";
        passwordField.returnKeyType = UIReturnKeyDefault;
        passwordField.secureTextEntry = YES;
        passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passwordField.autocorrectionType=UITextAutocorrectionTypeNo;
        [passwordField setKeyboardAppearance:UIKeyboardAppearanceDark];
        passwordField.tag = 66;
        passwordField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
        [cell.contentView addSubview:passwordField];

        
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reportBtn.tag = 77;
        [reportBtn addTarget:self
                      action:@selector(reportBtnPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setBackgroundImage:[UIImage imageNamed:@"goodbye_btn.png"] forState:UIControlStateNormal];
        reportBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [reportBtn setEnabled:YES];
        [cell.contentView addSubview:reportBtn];
        
        UIButton *stayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        stayBtn.tag = 88;
        [stayBtn addTarget:self
                      action:@selector(stayBtnPressed:)
            forControlEvents:UIControlEventTouchUpInside];
        [stayBtn setBackgroundImage:[UIImage imageNamed:@"stay_btn.png"] forState:UIControlStateNormal];
        stayBtn.frame = CGRectMake(20, 12, 280, 65/2.0);
        [stayBtn setEnabled:YES];
        [cell.contentView addSubview:stayBtn];
        
    }
    
    UILabel *TopHeading=(UILabel*)[cell.contentView viewWithTag:1111];
    TopHeading.text = @"Reason for leaving.";
    UILabel *TopHeading2=(UILabel*)[cell.contentView viewWithTag:2222];
    
    UILabel *Heading=(UILabel*)[cell.contentView viewWithTag:11];
    
    UIImageView *SeperatorView=(UIImageView*)[cell.contentView viewWithTag:22];
    
    UIImageView *RadioIconView=(UIImageView*)[cell.contentView viewWithTag:33];
    
    UITextView *FeedbackTextView=(UITextView*)[cell.contentView viewWithTag:44];
    UILabel *FeedbackPlaceholder=(UILabel*)[cell.contentView viewWithTag:55];
    UITextField *PasswordField=(UITextField*)[cell.contentView viewWithTag:66];
    UIButton *ReportBtn=(UIButton*)[cell.contentView viewWithTag:77];
    UIButton *StayBtn=(UIButton*)[cell.contentView viewWithTag:88];
    
    TopHeading.hidden = YES;
    TopHeading2.hidden = YES;
    RadioIconView.hidden = YES;
    FeedbackTextView.hidden = YES;
    FeedbackPlaceholder.hidden = YES;
    PasswordField.hidden = YES;
    ReportBtn.hidden = YES;
    StayBtn.hidden = YES;
    
    Heading.frame = CGRectMake(55,-2, 225, 40);
    Heading.numberOfLines = 1;
    
    SeperatorView.frame = CGRectMake(10, 38, 300, 2);
    
    if(indexPath.row == selectedIndex)
        RadioIconView.image = [UIImage imageNamed:@"bubble.png"];
    else
        RadioIconView.image = [UIImage imageNamed:@"bubble_inactive.png"];
    
    
    if(indexPath.row==0)
    {
        Heading.text = @"";
        TopHeading.hidden = NO;
        TopHeading2.hidden = NO;
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==1)
    {
        Heading.text = @"This is temporary. I'll be back.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==2)
    {
        Heading.text = @"I have a privacy concern.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==3)
    {
        Heading.text = @"I don't understand how to use Clickin'.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==4)
    {
        Heading.text = @"I have another account.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==5)
    {
        Heading.text = @"I just don't like it.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==6)
    {
        Heading.text = @"I am addicted and now need rehab.";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==7)
    {
        Heading.text = @"Other";
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
    }
    else if(indexPath.row==8)
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
        SeperatorView.frame = CGRectMake(10, 102, 300, 2);
    }
    else if(indexPath.row==9)
    {
        Heading.text = @"";
        TopHeading.hidden = NO;
        TopHeading.text = @"Email opt out";
        TopHeading2.hidden = YES;
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;

    }
    else if(indexPath.row==10)
    {
        Heading.frame = CGRectMake(55,-2, 225, 60);
        Heading.text = @"Opt out of receiving future emails about cool new features :(";
        Heading.numberOfLines = 2;
        RadioIconView.hidden = NO;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
        SeperatorView.frame = CGRectMake(10, 58, 300, 2);
        
        if(isEmailOpted)
            RadioIconView.image = [UIImage imageNamed:@"bubble.png"];
        else
            RadioIconView.image = [UIImage imageNamed:@"bubble_inactive.png"];
        
    }
    else if(indexPath.row==11)
    {
        Heading.text = @"";
        TopHeading.hidden = NO;
        TopHeading.text = @"Enter password to confirm deactivation";
        TopHeading2.hidden = YES;
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
        SeperatorView.frame = CGRectZero;
        
    }
    else if(indexPath.row==12)
    {
        Heading.text = @"";
        TopHeading.hidden = YES;
        TopHeading2.hidden = YES;
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
        PasswordField.hidden = NO;
        PasswordField.text = passwordString;
        SeperatorView.frame = CGRectZero;
    }
    else if(indexPath.row==13)
    {
        Heading.text = @"";
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = NO;
        SeperatorView.frame = CGRectZero;
    }
    else if(indexPath.row==14)
    {
        Heading.text = @"";
        RadioIconView.hidden = YES;
        FeedbackTextView.hidden = YES;
        FeedbackPlaceholder.hidden = YES;
        ReportBtn.hidden = YES;
        SeperatorView.frame = CGRectZero;
        StayBtn.hidden = NO;
    }
    else if(indexPath.row==15)
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
    return 16;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==8)
        return 104;
    else if(indexPath.row==10)
        return 60;
    else if(indexPath.row==14)
        return 150;
    else
        return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==1)
    {
        selectedOption = @"This is temporary. I'll be back.";
    }
    else if(indexPath.row==2)
    {
        selectedOption = @"I have a privacy concern.";
    }
    else if(indexPath.row==3)
    {
        selectedOption = @"I don't understand how to use Clickin'.";
    }
    else if(indexPath.row==4)
    {
        selectedOption = @"I have another account.";
    }
    else if(indexPath.row==5)
    {
        selectedOption = @"I just don't like it.";
    }
    else if(indexPath.row==6)
    {
        selectedOption = @"I am addicted and now need rehab.";
    }
    else if(indexPath.row==7)
    {
        selectedOption = @"Other";
    }
    
    
    if(indexPath.row<8 && indexPath.row>0)
    {
        selectedIndex = indexPath.row;
        [tblView reloadData];
    }
    
    if(indexPath.row==10)
    {
        if(isEmailOpted)
            isEmailOpted = false;
        else
            isEmailOpted = true;
        
        [tblView reloadData];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

//stay button action
-(void)stayBtnPressed:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//call webservice
-(void)reportBtnPressed:(UIButton*)sender
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
    
    UITextField *passwordField = (UITextField*)[((UITableViewCell *)[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]]) viewWithTag:66];
    if(passwordField.text.length==0 )
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter password first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:@"Please enter password first."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        return;
    }
    else if(passwordField.text.length<8)
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
    
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate performSelector:@selector(CheckInternetConnection)];
        if(appDelegate.internetWorking == 0)//0: internet working
        {
            NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/deactivateaccount"];
            NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            NSError *error;
            
            NSString *emailOpted;
            if(isEmailOpted)
                emailOpted = @"yes";
            else
                emailOpted = @"no";
            
            NSDictionary *Dictionary;
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs objectForKey:@"user_token"],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no", selectedOption,@"reason_type", feedbackText, @"other_reason", passwordField.text,@"password", emailOpted,@"email_opt_out",nil];
            
            emailOpted = nil;
            
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
            
            feedbackText = @"";
            passwordString = @"";
            [tblView reloadData];
            
            
            NSError *error1 = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error1];
            if([request responseStatusCode] == 200)
            {
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Your account has been deactivated."])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Account has been deactivated successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    alert.tag = 4747;
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Account has been deactivated successfully"
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView showForPresentView];
                    alertView.tag = 4747;
                    alertView = nil;

                    
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
                    
                    //self.navigationController.viewControllers = [NSArray arrayWithObjects:[[SignIn alloc] init], nil];
                    
                }
                
            }
            else if([request responseStatusCode] == 401)
            {
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Password did not match"])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter correct password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Please enter correct password."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView showForPresentView];
                    alertView = nil;
                    
                }
                
            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in deactivating the account. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"There was a problem in deactivating the account. Please try again"
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
    
    }

}


#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField.tag == 66)
        passwordString = textField.text;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell;
    if (IS_IOS_7)
    {
        cell=(UITableViewCell *)[[[textField superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[textField superview] superview];
    }
    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
        cell=(UITableViewCell *)[[[textView superview] superview] superview];
    }
    else
    {
        cell=(UITableViewCell *)[[textView superview] superview];
    }

    NSIndexPath *indexPath = [tblView indexPathForCell:cell];
    
    [tblView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
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
