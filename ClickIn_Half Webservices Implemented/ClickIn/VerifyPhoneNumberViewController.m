//
//  VerifyPhoneNumberViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 20/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"


#define ZERO_WIDTH_SPACE_STRING @"\u200B"

@interface VerifyPhoneNumberViewController ()

@end

@implementation VerifyPhoneNumberViewController

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
    
    VCodeString = @"";
    
    // Do any additional setup after loading the view from its nib.
    UIImageView *imgView;
    
    if (IS_IPHONE_5)
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        imgView.image = [UIImage imageNamed:@"5thscreen640x1136.png"];
    }
    else
    {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        imgView.image = [UIImage imageNamed:@"5thscreen.png"];
    }
    
    [self.view addSubview:imgView];
    
    HitMebutton = [UIButton buttonWithType:UIButtonTypeCustom];
   // [HitMebutton setTitle:@"HIT ME!" forState:UIControlStateNormal];
    if (IS_IPHONE_5)
    {
        HitMebutton.frame = CGRectMake(25.0, 255.0, 270.0, 38.0);
    }
    else
    {
        HitMebutton.frame = CGRectMake(25.0, 255.0, 270.0, 38.0);
    }
    HitMebutton.backgroundColor = [UIColor clearColor];
    [HitMebutton setImage:[UIImage imageNamed:@"hit-me-again.png"] forState:UIControlStateNormal];
    [HitMebutton addTarget:self
                    action:@selector(ResendVcodeWebservice:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:HitMebutton];
    
    text_Field = [[UITextField alloc] initWithFrame:CGRectMake(0, -200,320, 30)];
    text_Field.delegate = self;
    text_Field.keyboardType = UIKeyboardTypePhonePad;
    [text_Field setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self.view addSubview:text_Field];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//    [self.view addGestureRecognizer:tap];
    
    // fill verification boxes
    
    UIView *FillFirstBox = [[UIView alloc] initWithFrame:CGRectMake(92/2,236/2,107/2,146/2)];
    FillFirstBox.tag = 1;
    FillFirstBox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:FillFirstBox];
    
    UIView *FillSecondtBox = [[UIView alloc] initWithFrame:CGRectMake(209/2 ,236/2 ,107/2 ,146/2)];
    FillSecondtBox.tag = 2;
    FillSecondtBox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:FillSecondtBox];
    
    UIView *FillThirdBox = [[UIView alloc] initWithFrame:CGRectMake(325/2, 236/2, 107/2, 146/2)];
    FillThirdBox.tag = 3;
    FillThirdBox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:FillThirdBox];
    
    UIView *FillForthBox = [[UIView alloc] initWithFrame:CGRectMake(441/2 ,236/2 ,107/2 ,146/2)];
    FillForthBox.tag = 4;
    FillForthBox.backgroundColor = [UIColor clearColor];
    [self.view addSubview:FillForthBox];
    
    UILabel *LblfirstBox = [[UILabel alloc] init];
    LblfirstBox.textColor = [UIColor whiteColor];
    LblfirstBox.textAlignment = NSTextAlignmentCenter;
    [LblfirstBox setFrame:CGRectMake(92/2,236/2,107/2,146/2)];
    LblfirstBox.backgroundColor=[UIColor clearColor];
    LblfirstBox.textColor=[UIColor whiteColor];
    LblfirstBox.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:35];
    LblfirstBox.userInteractionEnabled=NO;
    LblfirstBox.text= @"";
    LblfirstBox.tag = 5;
    [self.view addSubview:LblfirstBox];

    UILabel *LblSecondBox = [[UILabel alloc] init];
    LblSecondBox.textColor = [UIColor whiteColor];
    LblSecondBox.textAlignment = NSTextAlignmentCenter;
    [LblSecondBox setFrame:CGRectMake(209/2 ,236/2 ,107/2 ,146/2)];
    LblSecondBox.backgroundColor=[UIColor clearColor];
    LblSecondBox.textColor=[UIColor whiteColor];
    LblSecondBox.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:35];
    LblSecondBox.userInteractionEnabled=NO;
    LblSecondBox.text= @"";
    LblSecondBox.tag = 6;
    [self.view addSubview:LblSecondBox];
    
    UILabel *LblThirdBox = [[UILabel alloc] init];
    LblThirdBox.textColor = [UIColor whiteColor];
    LblThirdBox.textAlignment = NSTextAlignmentCenter;
    [LblThirdBox setFrame:CGRectMake(325/2, 236/2, 107/2, 146/2)];
    LblThirdBox.backgroundColor=[UIColor clearColor];
    LblThirdBox.textColor=[UIColor whiteColor];
    LblThirdBox.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:35];
    LblThirdBox.userInteractionEnabled=NO;
    LblThirdBox.text= @"";
    LblThirdBox.tag = 7;
    [self.view addSubview:LblThirdBox];

    UILabel *LblFourthBox = [[UILabel alloc] init];
    LblFourthBox.textColor = [UIColor whiteColor];
    LblFourthBox.textAlignment = NSTextAlignmentCenter;
    [LblFourthBox setFrame:CGRectMake(441/2 ,236/2 ,107/2 ,146/2)];
    LblFourthBox.backgroundColor=[UIColor clearColor];
    LblFourthBox.textColor=[UIColor whiteColor];
    LblFourthBox.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:35];
    LblFourthBox.userInteractionEnabled=NO;
    LblFourthBox.text= @"";
    LblFourthBox.tag = 8;
    [self.view addSubview:LblFourthBox];
    
    // For Active Keypad
    UIButton *Transparentbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // [Transparentbutton setTitle:@"Show View" forState:UIControlStateNormal];
    [Transparentbutton addTarget:self action:@selector(TransparentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    if (IS_IPHONE_5)
    {
        Transparentbutton.frame = CGRectMake(40.0, 125.0, 240.0, 80.0);
    }
    else
    {
        Transparentbutton.frame = CGRectMake(40.0, 125.0, 240.0, 80.0);
    }
    //Transparentbutton.backgroundColor = [UIColor greenColor];
    [self.view addSubview:Transparentbutton];
    
    [self.view bringSubviewToFront:self.tintView];
    [self performSelector:@selector(openKeyboard) withObject:nil afterDelay:0.2];
}

-(void)openKeyboard
{
    [text_Field becomeFirstResponder];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"WE SENT YOU THE CODE!" message:@" Just to make sure you didn't wrong number us." delegate:nil cancelButtonTitle:@"GOT IT!" otherButtonTitles:nil];
//    //alert.backgroundColor = [UIColor redColor];
//    [alert show];
//    alert = nil;
    
    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"WE SENT YOU THE CODE!"
                                                                    description:@" Just to make sure you didn't wrong number us."
                                                                  okButtonTitle:@"GOT IT!"];
    alertView.delegate = nil;
    [alertView show];
    alertView = nil;
}

//- (void)alertViewDidDisappear:(MODropAlertView *)alertView
//{
//    NSLog(@"%s", __FUNCTION__);
//}
//
//
//- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
//{
//
//}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [text_Field resignFirstResponder];
}


-(void)TransparentButtonAction
{
    [text_Field becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength > 4)
    {
        return NO;
    }
    UIView *FirstVerifyBox;
    UIView *SecondVerifyBox;
    UIView *ThirdVerifyBox;
    UIView *FourthVerifyBox;
    UILabel*LblFirstBox;
    UILabel*LblSecondBox;
    UILabel*LblThirdBox;
    UILabel*LblFourthBox;
    
    if(textField==text_Field)
    {
        
        switch (newLength)
        {
            case 0:
                FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                
                LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
                FirstVerifyBox.backgroundColor = [UIColor clearColor];
                SecondVerifyBox.backgroundColor = [UIColor clearColor];
                ThirdVerifyBox.backgroundColor = [UIColor clearColor];
                FourthVerifyBox.backgroundColor = [UIColor clearColor];
                
                LblFirstBox.text = @"";
                LblSecondBox.text = @"";
                LblThirdBox.text = @"";
                LblFourthBox.text = @"";
                
            break;
                
            case 1:
                FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                FirstVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                SecondVerifyBox.backgroundColor = [UIColor clearColor];
                ThirdVerifyBox.backgroundColor = [UIColor clearColor];
                FourthVerifyBox.backgroundColor = [UIColor clearColor];
                
                
                LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
                if (range.length != 1)
                {
                    LblFirstBox.text = string;
                }
                
                
                LblSecondBox.text = @"";
                LblThirdBox.text = @"";
                LblFourthBox.text = @"";
                
            break;
                
            case 2:
                FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                FirstVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                SecondVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                ThirdVerifyBox.backgroundColor = [UIColor clearColor];
                FourthVerifyBox.backgroundColor = [UIColor clearColor];
                
                
                LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
                if (range.length != 1)
                {
                    LblSecondBox.text = string;
                }
                LblThirdBox.text = @"";
                LblFourthBox.text = @"";
            break;
                
            case 3:
                FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                FirstVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                SecondVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                ThirdVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                FourthVerifyBox.backgroundColor = [UIColor clearColor];
                
                
                LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
//              if ([string isEqualToString:ZERO_WIDTH_SPACE_STRING])
                if (range.length != 1)
                {
                    LblThirdBox.text = string;
                }
                LblFourthBox.text = @"";

            break;
                
            case 4:
                FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                FirstVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                SecondVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                ThirdVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                FourthVerifyBox.backgroundColor = [UIColor colorWithRed:(99.0/255.0) green:(176.0/255.0) blue:(197.0/255.0) alpha:1.0];
                
                LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
                if (range.length != 1)
                {
                    LblFourthBox.text = string;
                }
                
            break;
                
            default:
            break;
        }
    }
    
    if (range.length == 1)
    {
        VCodeString = [VCodeString substringToIndex:[VCodeString length]-1];
    }
    else
    {
        VCodeString = [VCodeString stringByAppendingString:string];
    }
    
    if(newLength == 4)
    {
        [text_Field resignFirstResponder];
        [self callVerifyService:VCodeString];
    }
    
    return YES;
}


-(void)callVerifyService:(NSString *)VCodeStr
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    BOOL checkNumerics=[self isNumeric:text_Field.text];
    
    if (checkNumerics == FALSE)
    {
        [activity hide];
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter numerics only" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Enter numerics only"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;

        
        return ;
    }
    [self performSelector:@selector(VerifyMyPhoneNoButtonAction:) withObject:VCodeStr afterDelay:0.1];
    
}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}

-(void)VerifyMyPhoneNoButtonAction:(NSString *)VcodeString
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/verifycode"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:VcodeString,@"vcode",[prefs stringForKey:@"phoneNumber"],@"phone_no",@"IOS", @"device_type",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token", nil];
        
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
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"user_token"];
                [prefs setObject:[jsonResponse objectForKey:@"user_id"] forKey:@"user_id"];
                
                [prefs setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"QBPassword"];
                [prefs setObject:[jsonResponse objectForKey:@"user_id"] forKey:@"QBUserName"];
                
                NSLog(@">>>: %@",[prefs stringForKey:@"QBPassword"]);
                NSLog(@">>>: %@",[prefs stringForKey:@"QBUserName"]);
                
                UIViewController *addyourdetails = [story instantiateViewControllerWithIdentifier:@"AddYourDetails"];
                [self.navigationController pushViewController:addyourdetails animated:YES];
                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User already verified"])
            {
                UIView *FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
                UIView *SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
                UIView *ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
                UIView *FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
                
                UILabel *LblFirstBox = (UILabel *)[self.view viewWithTag:5];
                UILabel *LblSecondBox = (UILabel *)[self.view viewWithTag:6];
                UILabel *LblThirdBox = (UILabel *)[self.view viewWithTag:7];
                UILabel *LblFourthBox = (UILabel *)[self.view viewWithTag:8];
                
                FirstVerifyBox.backgroundColor = [UIColor clearColor];
                SecondVerifyBox.backgroundColor = [UIColor clearColor];
                ThirdVerifyBox.backgroundColor = [UIColor clearColor];
                FourthVerifyBox.backgroundColor = [UIColor clearColor];
                
                LblFirstBox.text = @"";
                LblSecondBox.text = @"";
                LblThirdBox.text = @"";
                LblFourthBox.text = @"";
                VCodeString = @"";
                text_Field.text = @"";
                [text_Field resignFirstResponder];
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User already verified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User already verified."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

                
            }
            else
            {
                [HitMebutton setImage:[UIImage imageNamed:@"resend-code.png"] forState:UIControlStateNormal];

                [HitMebutton addTarget:self
                           action:@selector(ResendVcodeWebservice:)
                 forControlEvents:UIControlEventTouchUpInside];
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"OOPS! \n SOMETHING WENT WRONG." message:@"Please re-enter the code" delegate:nil cancelButtonTitle:@"TRY AGAIN" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"OOPS! \n SOMETHING WENT WRONG."
                                                                                description:@"Please re-enter the code"
                                                                              okButtonTitle:@"TRY AGAIN"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
            }
        }
        else
        {
            UIView *FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
            UIView *SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
            UIView *ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
            UIView *FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
            
            UILabel *LblFirstBox = (UILabel *)[self.view viewWithTag:5];
            UILabel *LblSecondBox = (UILabel *)[self.view viewWithTag:6];
            UILabel *LblThirdBox = (UILabel *)[self.view viewWithTag:7];
            UILabel *LblFourthBox = (UILabel *)[self.view viewWithTag:8];
            
            FirstVerifyBox.backgroundColor = [UIColor clearColor];
            SecondVerifyBox.backgroundColor = [UIColor clearColor];
            ThirdVerifyBox.backgroundColor = [UIColor clearColor];
            FourthVerifyBox.backgroundColor = [UIColor clearColor];
            
            LblFirstBox.text = @"";
            LblSecondBox.text = @"";
            LblThirdBox.text = @"";
            LblFourthBox.text = @"";
            VCodeString = @"";
            text_Field.text = @"";
            [text_Field resignFirstResponder];
            
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User already verified"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User already verified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User already verified."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

            }
            else
            {
                [HitMebutton setImage:[UIImage imageNamed:@"resend-code.png"] forState:UIControlStateNormal];
                
                [HitMebutton addTarget:self
                                action:@selector(ResendVcodeWebservice:)
                      forControlEvents:UIControlEventTouchUpInside];
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"OOPS! \n SOMETHING WENT WRONG." message:@"Please re-enter the code" delegate:self cancelButtonTitle:@"TRY AGAIN" otherButtonTitles:nil];
//                alert.tag = 1;
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"OOPS! \n SOMETHING WENT WRONG."
                                                                                description:@"Please re-enter the code"
                                                                              okButtonTitle:@"TRY AGAIN"];
                alertView.tag = 1;
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        
        [activity hide];
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

#pragma mark UIAlertview delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(alertView.tag == 1)
//    {
//        [HitMebutton setImage:[UIImage imageNamed:@"resend-code.png"] forState:UIControlStateNormal];
//    }
}

-(void)callResendCodeWebservice
{
    UIView *FirstVerifyBox = (UIView *)[self.view viewWithTag:1];
    UIView *SecondVerifyBox = (UIView *)[self.view viewWithTag:2];
    UIView *ThirdVerifyBox = (UIView *)[self.view viewWithTag:3];
    UIView *FourthVerifyBox = (UIView *)[self.view viewWithTag:4];
    
    UILabel *LblFirstBox = (UILabel *)[self.view viewWithTag:5];
    UILabel *LblSecondBox = (UILabel *)[self.view viewWithTag:6];
    UILabel *LblThirdBox = (UILabel *)[self.view viewWithTag:7];
    UILabel *LblFourthBox = (UILabel *)[self.view viewWithTag:8];
    
    FirstVerifyBox.backgroundColor = [UIColor clearColor];
    SecondVerifyBox.backgroundColor = [UIColor clearColor];
    ThirdVerifyBox.backgroundColor = [UIColor clearColor];
    FourthVerifyBox.backgroundColor = [UIColor clearColor];
    
    LblFirstBox.text = @"";
    LblSecondBox.text = @"";
    LblThirdBox.text = @"";
    LblFourthBox.text = @"";
    VCodeString = @"";
    text_Field.text = @"";
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/resendvcode"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token",nil];
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Vcode resent"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code has been resent on this phone." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Verification code has been resent on this phone."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
                [activity hide];
                
            }
            else
            {
                NSError *error = nil;
                NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Device Token is invalid"])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Device Token is invalid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Device Token is invalid."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
                    
                    
                }
                else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User already verified"])
                {
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"User already verified."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
                    
                    
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User already verified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                }
                else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Phone no. not registered."])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Phone no. not registered.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Phone no. not registered.."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
                    
                }
            }
            
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User with same phone no. already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Something went wrong. Please try again."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
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

-(void)ResendVcodeWebservice:(id)sender
{
    [text_Field becomeFirstResponder];
    
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    BOOL checkNumerics=[self isNumeric:text_Field.text];
    
    if (checkNumerics == FALSE)
    {
        [activity hide];
        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter numerics only" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Enter numerics only"
                                                                      okButtonTitle:@"Ok"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        return ;
    }
    [self performSelector:@selector(callResendCodeWebservice) withObject:nil afterDelay:0.1];
}




@end
