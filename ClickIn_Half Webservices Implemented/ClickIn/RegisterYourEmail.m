//
//  RegisterYourEmail.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 15/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "RegisterYourEmail.h"
#import "AddYourDetails.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import <Foundation/NSJSONSerialization.h>
#define CustomView_tag_ComplaintsView 2505
#define CustomIndicator_tag_ComplaintsView 2506


@interface RegisterYourEmail ()

@end

@implementation RegisterYourEmail
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
	// Do any additional setup after loading the view.
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //----Scroll View Implementation
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.contentSize = CGSizeMake(320, 460);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    //---UIimage View
    UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    compScreen.image=[UIImage imageNamed:@"new2-1.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"new-1.png"];
    }
    
    [scroll addSubview:compScreen];
    
    
    //---UILabel Display Name----
    
    lbl_DisplayName=[[UILabel alloc]initWithFrame:CGRectMake(94, 138, 140, 15)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            lbl_DisplayName.frame=CGRectMake(94, 182, 140, 15);
    }
    else
    {
        if (IS_IPHONE_5)
            lbl_DisplayName.frame=CGRectMake(94, 175, 140, 15);
        
        else
            lbl_DisplayName.frame=CGRectMake(94, 132, 140, 15);
    }
    
    lbl_DisplayName.numberOfLines=0;
    lbl_DisplayName.textAlignment=NSTextAlignmentCenter;
    lbl_DisplayName.backgroundColor=[UIColor clearColor];
    lbl_DisplayName.textColor=[UIColor colorWithRed:232/255.0f green:152/255.0f blue:144/255.0f alpha:1];
    lbl_DisplayName.text=app.str_App_DisplayName;
    lbl_DisplayName.font=[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12];
   // [scroll addSubview:lbl_DisplayName];
    
    //---Text Field Email----
    txt_email=[[UITextField alloc]initWithFrame:CGRectMake(52,233,230,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_email.frame=CGRectMake(52,277, 230, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_email.frame=CGRectMake(52,265, 230, 30) ;
        
        else
            txt_email.frame=CGRectMake(52,221, 230, 30) ;
    }
    txt_email.placeholder=@"Email";
    txt_email.textColor=[UIColor darkGrayColor];
    txt_email.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [txt_email setDelegate:self];
    txt_email.secureTextEntry = NO;
    txt_email.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_email.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_email.keyboardType = UIKeyboardTypeEmailAddress;
    [txt_email setKeyboardAppearance:UIKeyboardAppearanceDark];
    txt_email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //[scroll addSubview:txt_email];
    
    //---UIlabel Info---
    lbl_Info=[[UILabel alloc]initWithFrame:CGRectMake(40, 260, 240, 25)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            lbl_Info.frame=CGRectMake(42, 304, 240, 25);
    }
    else
    {
        if (IS_IPHONE_5)
            lbl_Info.frame=CGRectMake(42, 293, 240, 25) ;
        
        else
            lbl_Info.frame=CGRectMake(40, 249, 240, 25) ;
    }
    
    lbl_Info.numberOfLines=0;
    lbl_Info.textAlignment=NSTextAlignmentCenter;
    lbl_Info.backgroundColor=[UIColor clearColor];
    lbl_Info.textColor=[UIColor grayColor];
    lbl_Info.hidden=YES;
    lbl_Info.text=@"The Email you registered is already on our system.";
    lbl_Info.font=[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12];
    //[scroll addSubview:lbl_Info];

    
    
    //---UIButons btn_TryAnother---
    
    btn_TryAnother = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_TryAnother.backgroundColor=[UIColor clearColor];
    btn_TryAnother.hidden=YES;
    btn_TryAnother.tag=4;
    [btn_TryAnother addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    [btn_TryAnother setBackgroundImage:[UIImage imageNamed:@"trybutton.png"] forState:UIControlStateNormal];
    btn_TryAnother.frame = CGRectMake(47, 290, 96, 35.0);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_TryAnother.frame=CGRectMake(47,335, 96, 35.0) ;
    }
    else
    {
        if (IS_IPHONE_5)
            btn_TryAnother.frame=CGRectMake(47,322, 96, 35.0) ;
        
        else
            btn_TryAnother.frame=CGRectMake(47,277, 96, 35.0) ;
    }
    
   // [scroll addSubview:btn_TryAnother];
    
    //---UIButons btn_ForgotPassword---
    
    btn_ForgotPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_ForgotPassword.tag=5;
    btn_ForgotPassword.hidden=YES;
    [btn_ForgotPassword addTarget:self
                       action:@selector(clk_Btn:)
             forControlEvents:UIControlEventTouchDown];
    [btn_ForgotPassword setBackgroundImage:[UIImage imageNamed:@"forgotpassword.png"] forState:UIControlStateNormal];
    btn_ForgotPassword.frame = CGRectMake(150, 290, 123, 35.0);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_ForgotPassword.frame=CGRectMake(150,335, 123, 35.0) ;
    }
    else
    {
        if (IS_IPHONE_5)
            btn_ForgotPassword.frame=CGRectMake(150,322, 123, 35.0) ;
        
        else
            btn_ForgotPassword.frame=CGRectMake(150,277, 123, 35.0) ;
    }
   // [scroll addSubview:btn_ForgotPassword];
    
    //---Text Field Password----
    txt_Password=[[UITextField alloc]initWithFrame:CGRectMake(38+5,156,242-5,30)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_Password.frame=CGRectMake(38+5,151, 242-5, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_Password.frame=CGRectMake(38+5,152, 242-5, 30) ;
        
        else
            txt_Password.frame=CGRectMake(38+5,152, 242-5, 30) ;
    }
    txt_Password.placeholder=@"Enter Password";
    txt_Password.backgroundColor = [UIColor whiteColor];
    txt_Password.textColor=[UIColor darkGrayColor];
    txt_Password.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    txt_Password.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    [txt_Password setDelegate:self];
    txt_Password.secureTextEntry = YES;
    txt_Password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_Password.autocorrectionType=UITextAutocorrectionTypeNo;
    [txt_Password setKeyboardAppearance:UIKeyboardAppearanceDark];
    txt_Password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [txt_Password setReturnKeyType:UIReturnKeyNext];
    [scroll addSubview:txt_Password];
    
    
    //---Text Field Re-Type password code----
    txt_RePass=[[UITextField alloc]initWithFrame:CGRectMake(38+5,223,242-5,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_RePass.frame=CGRectMake(38+5,215, 242-5, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_RePass.frame=CGRectMake(38+5,218, 242-5, 30) ;
        
        else
            txt_RePass.frame=CGRectMake(38+5,218, 242-5, 30) ;
    }
    
    txt_RePass.placeholder=@"Re-enter Password";
    txt_RePass.backgroundColor = [UIColor clearColor];
    txt_RePass.textColor=[UIColor darkGrayColor];
    [txt_RePass setDelegate:self];
    txt_RePass.secureTextEntry = YES;
    txt_RePass.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    txt_RePass.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_RePass.autocorrectionType=UITextAutocorrectionTypeNo;
    [txt_RePass setKeyboardAppearance:UIKeyboardAppearanceDark];
    txt_RePass.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_RePass.hidden=NO;
    [scroll addSubview:txt_RePass];
    
    //---Btn Bottom Buttons code
    
    
    
    btn_Done = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Done.tag=2;
    [btn_Done addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    //[btn_Next setBackgroundColor:[UIColor yellowColor]];
    [btn_Done setBackgroundImage:[UIImage imageNamed:@"light_done.png"] forState:UIControlStateNormal];//light_done.png //dark_done.png
    // [btn_Next setBackgroundImage:[UIImage imageNamed:@"nextbtngrey.png"] forState:UIControlStateHighlighted];
    if (IS_IPHONE_5)
        btn_Done.frame = CGRectMake(25, self.view.frame.size.height-300, 270.5, 52.5);
    else
        btn_Done.frame = CGRectMake(25, self.view.frame.size.height-200, 270.5, 52.5);
    [scroll addSubview:btn_Done];
    
    [self.view bringSubviewToFront:self.tintView];
    
    
    [self performSelector:@selector(openKeyboard) withObject:nil afterDelay:0.2];
}

-(void)openKeyboard
{
    [txt_Password becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Selector Functions

-(void)clk_Btn:(id)sender
{
    UIButton *clk_Btn=(UIButton *)sender;

    if (clk_Btn.tag == 1)
    {
        NSLog(@"Btn clicked: Back");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (clk_Btn.tag == 2)
    {
        if (![self checkValidation:nil])
            return;
        
        [txt_Password resignFirstResponder];
        
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        [activity show];
        [self performSelector:@selector(DoneButtonAction) withObject:nil afterDelay:0.1];

        NSLog(@"Btn clicked: Done");
    }
    else if (clk_Btn.tag == 3)
    {
         NSLog(@"Btn clicked: Skip");
        
        UIViewController *addyourdetails = [story instantiateViewControllerWithIdentifier:@"AddYourDetails"];
        [self.navigationController pushViewController:addyourdetails animated:YES];
    }
    else if (clk_Btn.tag == 4)
    {
        NSLog(@"Btn clicked: Try Onother");
        [txt_email becomeFirstResponder];
        lbl_Info.hidden=YES;
        btn_TryAnother.hidden=YES;
        btn_ForgotPassword.hidden=YES;
    }
    else if (clk_Btn.tag == 5)
    {
        NSLog(@"Btn clicked: Forgot Password");
    }
}

#pragma mark Custom Functions
-(void)DoneButtonAction
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/insertemail"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:[prefs stringForKey:@"EmailSaved"] forKey:@"EMail"];
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[prefs stringForKey:@"EmailSaved"],@"email",txt_Password.text,@"password",nil];
        
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
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email updated"])
            {
                /////////A USER ACCOUNT HAS BEEN CREATED SUCCESSFULLY , CREATE AN ALIAS USER FOR MIXPANEL /////////
                
                UIViewController *SearchContactsViewController = [story instantiateViewControllerWithIdentifier:@"SearchContactsViewController"];
                [self.navigationController pushViewController:SearchContactsViewController animated:YES];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"yes" forKey:@"IsAutoLogin"];
                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
                lbl_Info.hidden=NO;
                btn_ForgotPassword.hidden = NO;
                btn_TryAnother.hidden = NO;
            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is invalid."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        else
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];

            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
                lbl_Info.hidden=NO;
                btn_ForgotPassword.hidden = NO;
                btn_TryAnother.hidden = NO;
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in verifying the user."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in verifying the user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"There was a problem in verifying the user."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;


            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is invalid."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

            }
        }
       
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


-(BOOL)checkValidation:(id)sender
{
    if (txt_Password.text.length<8)
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Your password should be at least 8 characters long." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                        description:@"Your password should be at least 8 characters long."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        return FALSE;
    }
    else if(![txt_Password.text isEqualToString:txt_RePass.text])
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Password doesn't match. Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                        description:@"Password doesn't match. Please try again"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        return FALSE;
    }
    
    return TRUE;
}



#pragma mark -
#pragma mark ActivityIndicatorView methods

-(void)drawOverlayView
{
    UIView *temp_noActionView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,568)];
    [temp_noActionView setBackgroundColor:[UIColor blackColor]];
    [temp_noActionView setAlpha:0.7];
    [temp_noActionView setTag:CustomView_tag_ComplaintsView];
    
    UIActivityIndicatorView *temp_activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    temp_activityIndicator.hidesWhenStopped=YES;
    temp_activityIndicator.frame = CGRectMake(150,200,20,20);
    [temp_activityIndicator setTag:CustomIndicator_tag_ComplaintsView];
    
    [temp_noActionView addSubview:temp_activityIndicator];
    [self.view addSubview:temp_noActionView];
    
    [temp_activityIndicator startAnimating];
}


-(void)removeTempView
{
    [(UIActivityIndicatorView*)[self.view viewWithTag:CustomIndicator_tag_ComplaintsView] stopAnimating];
    [[self.view viewWithTag:CustomIndicator_tag_ComplaintsView] removeFromSuperview];
    
    [[self.view viewWithTag:CustomView_tag_ComplaintsView] removeFromSuperview];
    
}


#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_Password)
    {
        [txt_RePass becomeFirstResponder];
    }
    else
    {
        [txt_Password resignFirstResponder];
        [txt_RePass resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    }
   
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == txt_email)
//    {
//        lbl_Info.hidden=YES;
//        btn_TryAnother.hidden=YES;
//        btn_ForgotPassword.hidden=YES;
//        [scroll setContentOffset:CGPointMake(0,110) animated:YES];
//        if (IS_IPHONE_5)
//            [scroll setContentOffset:CGPointMake(0,65) animated:YES];
//    }
//    else if (textField == txt_Password)
//    {
//        [scroll setContentOffset:CGPointMake(0,155) animated:YES];
//        if (IS_IPHONE_5)
//            [scroll setContentOffset:CGPointMake(0,110) animated:YES];
//        
//    }
//    else if (textField == txt_RePass)
//    {
//        [scroll setContentOffset:CGPointMake(0,155) animated:YES];
//        if (IS_IPHONE_5)
//            [scroll setContentOffset:CGPointMake(0,110) animated:YES];
//    }
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txt_email)
    {
        
    }
    else if (textField == txt_Password)
    {
        
    }
    else if (textField == txt_RePass)
    {
        
    }
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if (textField==txt_Password)
        {
            if(newLength == 0)
            {
                [btn_Done setBackgroundImage:[UIImage imageNamed:@"light_done.png"] forState:UIControlStateNormal];//light_done.png //dark_done.png
                btn_Done.userInteractionEnabled = NO;
                
            }
            else
            {
                [btn_Done setBackgroundImage:[UIImage imageNamed:@"dark_done.png"] forState:UIControlStateNormal];//light_done.png //dark_done.png
                btn_Done.userInteractionEnabled = YES;
            }
            return (newLength >20) ? NO : YES;
        }
        return YES;
}

@end
