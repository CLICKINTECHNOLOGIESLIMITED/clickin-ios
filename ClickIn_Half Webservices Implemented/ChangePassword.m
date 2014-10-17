//
//  ChangePassword.m
//  ClickIn
//
//  Created by Dinesh Gulati on 31/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "ChangePassword.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import <Foundation/NSJSONSerialization.h>
#import "SSKeychain.h"


@interface ChangePassword ()

@end

@implementation ChangePassword

@synthesize strPhoneNumber;

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
    compScreen.image=[UIImage imageNamed:@"signinpage640x1136.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"signinpage.png"];
    }
    
    [scroll addSubview:compScreen];
    
    //---Text Field Display Name----
    txtOLDPassword=[[UITextField alloc]initWithFrame:CGRectMake(47,230,238,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txtOLDPassword.frame=CGRectMake(47,274, 238, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txtOLDPassword.frame=CGRectMake(47,264, 238, 30) ;
        
        else
            txtOLDPassword.frame=CGRectMake(47,220, 238, 30) ;
    }
    txtOLDPassword.placeholder=@"Old Password";
    txtOLDPassword.textColor=[UIColor darkGrayColor];
    [txtOLDPassword setDelegate:self];
    txtOLDPassword.secureTextEntry = NO;
    txtOLDPassword.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    txtOLDPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtOLDPassword.autocorrectionType=UITextAutocorrectionTypeNo;
    [txtOLDPassword setKeyboardAppearance:UIKeyboardAppearanceDark];
    txtOLDPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scroll addSubview:txtOLDPassword];
    
    //---Text Field Phone Number----
    txtNewPassword=[[UITextField alloc]initWithFrame:CGRectMake(47,276,238,30)];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txtNewPassword.frame=CGRectMake(47,320, 238, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txtNewPassword.frame=CGRectMake(47,308, 238, 30) ;
        
        else
            txtNewPassword.frame=CGRectMake(47,264, 238, 30) ;
    }
    txtNewPassword.placeholder=@"New Password";
    txtNewPassword.textColor=[UIColor darkGrayColor];
    [txtNewPassword setDelegate:self];
    txtNewPassword.secureTextEntry = YES;
    txtNewPassword.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    txtNewPassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txtNewPassword.autocorrectionType=UITextAutocorrectionTypeNo;
    [txtNewPassword setKeyboardAppearance:UIKeyboardAppearanceDark];
    txtNewPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scroll addSubview:txtNewPassword];
    
    
    //---Btn Verification code
    btn_ClickIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_ClickIn addTarget:self
                    action:@selector(clk_btn_ClickIn:)
          forControlEvents:UIControlEventTouchDown];
    [btn_ClickIn setBackgroundImage:[UIImage imageNamed:@"letsgetclick.png"] forState:UIControlStateNormal];
    //    [btn_ClickIn setTitle: @"VERIFY MY PHONE" forState: UIControlStateNormal];
    //    [btn_ClickIn.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:13]];
    btn_ClickIn.frame = CGRectMake(50, 310, 220, 42.0);
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_ClickIn.frame=CGRectMake(50,350, 220, 42) ;
    }
    else
    {
        if (IS_IPHONE_5)
            btn_ClickIn.frame=CGRectMake(50,340, 220, 42) ;
        
        else
            btn_ClickIn.frame=CGRectMake(50,300, 220, 42) ;
    }
    [btn_ClickIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [scroll addSubview:btn_ClickIn];
    
    UILabel  * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 320, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter; // UITextAlignmentCenter, UITextAlignmentLeft
    label.textColor=[UIColor darkGrayColor];
    label.numberOfLines=0;
    label.text = @"Change Password";
    [scroll addSubview:label];
    
     [self.view bringSubviewToFront:self.tintView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ChangePasswordWebserviceCall
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/changepassword"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        
        NSError *error;
        
        NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
        NSString *StrPhone_mail = [defaults stringForKey:@"Phone_mail"];
        
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:StrPhone_mail,@"phone_no",retrieveuuid,@"user_token",txtNewPassword.text,@"new_password",txtOLDPassword.text,@"old_password",nil];
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"success"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"success"
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Wrong password"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Wrong password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Wrong password"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User not registered."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"WE DONT HAVE A USERNAME" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"WE DON'T HAVE A USERNAME"
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
#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txtOLDPassword)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >30) ? NO : YES;
        return YES;
    }
    
    else if(textField==txtNewPassword)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >20) ? NO : YES;
        return YES;
    }
    return YES;
}

-(void)clk_btn_ClickIn:(id)sender
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(ChangePasswordWebserviceCall) withObject:nil afterDelay:0.1];
}

@end
