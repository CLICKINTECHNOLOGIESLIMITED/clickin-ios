//
//  SignUp.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "SignUp.h"
#import "RegisterYourEmail.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import <Foundation/NSJSONSerialization.h>
#define CustomView_tag_ComplaintsView 2505
#define CustomIndicator_tag_ComplaintsView 2506

@interface SignUp ()

@end

@implementation SignUp

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
    compScreen.image=[UIImage imageNamed:@"signuppage960x1136.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"signuppage.png"];
    }
    
    [scroll addSubview:compScreen];
    
    //---Text Field Display Name----
    txt_DisplayName=[[UITextField alloc]initWithFrame:CGRectMake(53,188,238,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_DisplayName.frame=CGRectMake(53,232, 238, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_DisplayName.frame=CGRectMake(53,222, 238, 30) ;
        
        else
            txt_DisplayName.frame=CGRectMake(53,180, 238, 30) ;
    }
    txt_DisplayName.placeholder=@"Display Name";
    txt_DisplayName.textColor=[UIColor darkGrayColor];
    [txt_DisplayName setDelegate:self];
    txt_DisplayName.secureTextEntry = NO;
    txt_DisplayName.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    txt_DisplayName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_DisplayName.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_DisplayName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scroll addSubview:txt_DisplayName];
    
    //---Text Field Phone Number----
    txt_PhoneNo=[[UITextField alloc]initWithFrame:CGRectMake(53,231,238,30)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_PhoneNo.frame=CGRectMake(53,275, 238, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_PhoneNo.frame=CGRectMake(53,263, 238, 30) ;
        
        else
            txt_PhoneNo.frame=CGRectMake(53,221, 238, 30) ;
    }
    txt_PhoneNo.placeholder=@"Phone Number";
    txt_PhoneNo.textColor=[UIColor darkGrayColor];
    [txt_PhoneNo setDelegate:self];
    txt_PhoneNo.secureTextEntry = NO;
    txt_PhoneNo.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    txt_PhoneNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_PhoneNo.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_PhoneNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scroll addSubview:txt_PhoneNo];
    
    
    //---Btn Verification code
    btn_VerifyPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_VerifyPhone.userInteractionEnabled=YES;
    [btn_VerifyPhone addTarget:self
                        action:@selector(clk_btn_VerifyPhone:)
              forControlEvents:UIControlEventTouchDown];
    [btn_VerifyPhone setBackgroundImage:[UIImage imageNamed:@"Verify-button.png"] forState:UIControlStateNormal];
    [btn_VerifyPhone setTitle: @"VERIFY MY PHONE" forState: UIControlStateNormal];
    [btn_VerifyPhone.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:13]];
    btn_VerifyPhone.frame = CGRectMake(40, 270, 239, 36.0);
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_VerifyPhone.frame=CGRectMake(40,315, 239, 35) ;
    }
    else
    {
        if (IS_IPHONE_5)
            btn_VerifyPhone.frame=CGRectMake(40,305, 239, 35) ;
        
        else
            btn_VerifyPhone.frame=CGRectMake(40,260, 239, 35) ;
    }
    

    [btn_VerifyPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scroll addSubview:btn_VerifyPhone];
    
    
    //---Lable
    lbl_Info=[[UILabel alloc]initWithFrame:CGRectMake(60, 310, 200, 60)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            lbl_Info.frame=CGRectMake(60, 350, 200, 60);
    }
    else
    {
        if (IS_IPHONE_5)
            lbl_Info.frame=CGRectMake(55,335, 210, 60) ;
        
        else
            lbl_Info.frame=CGRectMake(55,295, 210, 60) ;
    }
    
    lbl_Info.numberOfLines=0;
    lbl_Info.textAlignment=NSTextAlignmentCenter;
    lbl_Info.backgroundColor=[UIColor clearColor];
    lbl_Info.textColor=[UIColor grayColor];
    [lbl_Info setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
    lbl_Info.text=@"An SMS will be sent to your phone with a verification code";
    lbl_Info.font=[UIFont boldSystemFontOfSize:14];
    [scroll addSubview:lbl_Info];
    
    
    //---Text Field Verification code----
    txt_VerificationCode=[[UITextField alloc]initWithFrame:CGRectMake(53,363,238,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_VerificationCode.frame=CGRectMake(53,407, 238, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_VerificationCode.frame=CGRectMake(53,391, 238, 30) ;
        
        else
            txt_VerificationCode.frame=CGRectMake(53,346, 238, 30) ;
    }
    
    txt_VerificationCode.placeholder=@"Verification Code";
    txt_VerificationCode.textColor=[UIColor darkGrayColor];
    txt_VerificationCode.userInteractionEnabled=NO;
    [txt_VerificationCode setDelegate:self];
    txt_VerificationCode.secureTextEntry = NO;
    txt_VerificationCode.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    txt_VerificationCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_VerificationCode.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_VerificationCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_VerificationCode.hidden=NO;
    [scroll addSubview:txt_VerificationCode];
    
    //---Btn btn_Go ---
    btn_Go = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Go.userInteractionEnabled=NO;
    [btn_Go addTarget:self
                        action:@selector(clk_btn_Go:)
              forControlEvents:UIControlEventTouchDown];
     [btn_Go setBackgroundImage:[UIImage imageNamed:@"gobutton.png"] forState:UIControlStateNormal];
    btn_Go.frame = CGRectMake(109, self.view.frame.size.height-51, 102, 51.0);
    [scroll addSubview:btn_Go];
    
    
    //---Activity Indicator-----
    
    activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame=CGRectMake(120, 140, 80, 80) ;
    if (IS_IPHONE_5)
        activityView.frame=CGRectMake(120, 180, 80, 80) ;
    activityView.backgroundColor=[UIColor grayColor];
    [self.view addSubview:activityView];
    
    
    [activityView.layer setCornerRadius:10.0f];
    
    [activityView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [activityView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [activityView.layer setShadowColor:[UIColor blackColor].CGColor];
    [activityView.layer setShadowOpacity:0.8];
    [activityView.layer setShadowRadius:3.0];
    [activityView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    //[activityView startAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clk_Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Selector Functions

-(void)clk_btn_VerifyPhone:(id)sender
{
    
    if (![self checkValidation:nil])
        return;
    [activityView startAnimating];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (check_btn_VerifyPhoneClk == FALSE)
    {
        NSLog(@"check_btn_VerifyPhoneClk = False");
        [btn_VerifyPhone setTitle: @"RE-SEND THE VERIFICATION CODE" forState: UIControlStateNormal];
        lbl_Info.text=@"In case you did not recieve it!";
        check_btn_VerifyPhoneClk=TRUE;
        
        [self performSelector:@selector(createUserWebservice) withObject:nil afterDelay:0.1];
    }
    else
    {
        NSLog(@"check_btn_VerifyPhoneClk = TRUE");
    }
    
    [txt_DisplayName resignFirstResponder];
    [txt_PhoneNo resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];

    int_VerifiCode=1234;
    btn_Go.userInteractionEnabled=YES;
    txt_VerificationCode.userInteractionEnabled=YES;
    
}

-(void)createUserWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        [self performSelector:@selector(drawOverlayView) withObject:nil afterDelay:0.1];
        
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/createuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_DisplayName.text,@"name",txt_PhoneNo.text,@"phone_no",nil];
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Created"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code has been sent on this phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User with same phone no. already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
        }
        [self performSelector:@selector(removeTempView) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
    [activityView stopAnimating];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)VerifyMyPhoneNoButtonAction
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        [activityView startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/verifycode"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1234",@"vcode",txt_PhoneNo.text,@"phone_no",nil];
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Verified"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Verified" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alert.tag =  2;
//                [alert show];
//                alert = nil;

                RegisterYourEmail *registeryouremail = [story instantiateViewControllerWithIdentifier:@"RegisterYourEmail"];
                [self.navigationController pushViewController:registeryouremail animated:YES];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"user_token"];
                [prefs setObject:txt_PhoneNo.text forKey:@"phoneNumber"];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User already verified"])
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User already verified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code is not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert = nil;
            }
          
        }
        
        [activityView stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
    else
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert = nil;
    }
    
}



-(void)clk_btn_Go:(id)sender
{
    app.str_App_DisplayName=txt_DisplayName.text;
    
    BOOL checkNumerics=[self isNumeric:txt_VerificationCode.text];
    
    
    if (checkNumerics == FALSE)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter numerics only" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    
    if ([txt_VerificationCode.text  isEqual: @"1234"])
    {
        [self performSelector:@selector(VerifyMyPhoneNoButtonAction) withObject:nil afterDelay:0.1];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Enter correct verification code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    
    
    
}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}


#pragma mark -
#pragma mark UIAlertView methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==  2)
    {
        RegisterYourEmail *registeryouremail = [story instantiateViewControllerWithIdentifier:@"RegisterYourEmail"];
        [self.navigationController pushViewController:registeryouremail animated:YES];
    }
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

#pragma mark Custom Functions

-(BOOL)checkValidation:(id)sender
{
    if ((txt_DisplayName.text.length == 0) || ([txt_DisplayName.text isEqualToString:@" "]))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Please enter display name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return FALSE;
    }
    
    else if ((txt_PhoneNo.text.length == 0) || ([txt_PhoneNo.text isEqualToString:@" "]))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Please enter mobile number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return FALSE;
    }
    
    else if (txt_PhoneNo.text.length<10)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter correct mobile number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return FALSE;
    }
    
    else if (txt_PhoneNo.text.length>10)
    {
        BOOL checkNumerics=[self isNumeric:txt_PhoneNo.text];
        if (checkNumerics == FALSE)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter numerics only" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return FALSE;
        }
    
    }
    return TRUE;
}


#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txt_DisplayName resignFirstResponder];
    [txt_PhoneNo resignFirstResponder];
    [txt_VerificationCode resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txt_DisplayName)
    {
        [txt_PhoneNo setKeyboardType: UIKeyboardTypeDefault];
        if (IS_IOS_7)
        {
            [scroll setContentOffset:CGPointMake(0,0) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,12) animated:YES];
        }
        else
        {
            [scroll setContentOffset:CGPointMake(0,16) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,18) animated:YES];
        }
    }
    else if (textField == txt_PhoneNo)
    {
        [txt_PhoneNo setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
        
        
        if (IS_IOS_7)
        {
            [scroll setContentOffset:CGPointMake(0,50) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,12) animated:YES];
        }
        else
        {
            [scroll setContentOffset:CGPointMake(0,60) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,18) animated:YES];
        }
        
        
    }
    else if (textField == txt_VerificationCode)
    {
        [txt_VerificationCode setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
        
        if (IS_IOS_7)
        {
            [scroll setContentOffset:CGPointMake(0,135) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,90) animated:YES];
        }
        else
        {
            [scroll setContentOffset:CGPointMake(0,140) animated:YES];
            if (IS_IPHONE_5)
                [scroll setContentOffset:CGPointMake(0,100) animated:YES];
        }
        
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txt_DisplayName)
    {
        
    }
    else if (textField == txt_PhoneNo)
    {
        
    }
    else if (textField == txt_VerificationCode)
    {
        
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txt_DisplayName)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >30) ? NO : YES;
        return YES;
    }
    
   else if(textField==txt_PhoneNo)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >20) ? NO : YES;
        return YES;
    }
    
   else if(textField==txt_VerificationCode)
   {
       NSUInteger newLength = [textField.text length] + [string length] - range.length;
       return (newLength >4) ? NO : YES;
       return YES;
   }
    
    return YES;

}
@end
