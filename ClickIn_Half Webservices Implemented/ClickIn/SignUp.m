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
#import "SSKeychain.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "VerifyPhoneNumberViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


#define CustomView_tag_ComplaintsView 2505
#define CustomIndicator_tag_ComplaintsView 2506

@interface SignUp ()

@end

@implementation SignUp

@synthesize StrCountryCode;

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
    
    
    // Setup the Network Info and create a CTCarrier object
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    // Get carrier name
    NSString *carrierName = [carrier carrierName];
    if (carrierName != nil)
        NSLog(@"Carrier: %@", carrierName);
    
    // Get mobile country code
    NSString *mcc = [carrier mobileCountryCode];
    if (mcc != nil)
        NSLog(@"Mobile Country Code (MCC): %@", mcc);
    
    // Get mobile network code
    NSString *mnc = [carrier mobileNetworkCode];
    if (mnc != nil)
        NSLog(@"Mobile Network Code (MNC): %@", mnc);
    
    
//  Get Country name
    NSString *CountryName = [carrier isoCountryCode];
    if (CountryName != nil)
        NSLog(@"Mobile Network Code (MNC): %@", CountryName);
    
    
    // Fetching Device country code
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    [dictCodes valueForKey:[CountryName uppercaseString]];
    
    StrCountryCode = [dictCodes valueForKey:[CountryName uppercaseString]];
    
    dictCodes = nil;
    
    
    //----Scroll View Implementation
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scroll.contentSize = CGSizeMake(320, 460);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    TopViewTransparentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [TopViewTransparentButton addTarget:self action:@selector(TopViewTransparentButton:) forControlEvents:UIControlEventTouchDown];
    //[TopViewTransparentButton setBackgroundImage:[UIImage imageNamed:@"letsgetclick.png"] forState:UIControlStateNormal];
    TopViewTransparentButton.frame = CGRectMake(0, 0, 320, 180);
    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            TopViewTransparentButton.frame = CGRectMake(0, 0, 320, 220);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            TopViewTransparentButton.frame = CGRectMake(0, 0, 320, 220);
        }
        else
        {
            TopViewTransparentButton.frame = CGRectMake(0, 0, 320, 180);
        }
    }
 //   [self.view addSubview:TopViewTransparentButton];
    
    //---UIimage View
    UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    compScreen.image=[UIImage imageNamed:@"signup-img640x1136.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"signup-img640-1.png"];
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
    [txt_DisplayName setKeyboardAppearance:UIKeyboardAppearanceDark];
    txt_DisplayName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_DisplayName.returnKeyType = UIReturnKeyNext;
  //[scroll addSubview:txt_DisplayName];
    
    //---Text Field Phone Number----
    txt_CountryCode = [[UITextField alloc]initWithFrame:CGRectMake(28,275-75-43, 58, 30)];
   // txt_CountryCode.backgroundColor = [UIColor greenColor];

    txt_PhoneNo=[[UITextField alloc]initWithFrame:CGRectMake(99,275-75-43, 238-38-5, 30)];
    [txt_PhoneNo setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txt_CountryCode setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            txt_PhoneNo.frame=CGRectMake(99,275-75, 238-38-5, 30) ;
            txt_CountryCode.frame=CGRectMake(28,275-75, 58, 30) ;
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            txt_CountryCode.frame=CGRectMake(28,275-75, 58, 30) ;
            txt_PhoneNo.frame=CGRectMake(99,275-75, 238-38-5, 30) ;
        }
        else
        {
            txt_CountryCode.frame=CGRectMake(28,275-75-45, 58, 30) ;
            txt_PhoneNo.frame=CGRectMake(99,275-75-45, 238-38-5, 30) ;
        }
    }
    //txt_PhoneNo.backgroundColor = [UIColor redColor];
    txt_PhoneNo.placeholder=@"Phone Number";
    txt_PhoneNo.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    [txt_PhoneNo setDelegate:self];
    txt_PhoneNo.secureTextEntry = NO;
    txt_PhoneNo.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    txt_PhoneNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_PhoneNo.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_PhoneNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_PhoneNo.keyboardType = UIKeyboardTypePhonePad;
    [txt_PhoneNo setKeyboardAppearance:UIKeyboardAppearanceDark];
    
//  txt_CountryCode.backgroundColor = [UIColor greenColor];
//  txt_PhoneNo.placeholder=@"Phone Number";
    txt_CountryCode.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    [txt_CountryCode setDelegate:self];
    txt_CountryCode.secureTextEntry = NO;
    txt_CountryCode.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    txt_CountryCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_CountryCode.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_CountryCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_CountryCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    txt_CountryCode.keyboardType = UIKeyboardTypePhonePad;
    [txt_CountryCode setKeyboardAppearance:UIKeyboardAppearanceDark];
    txt_CountryCode.text = [NSString stringWithFormat:@"+%@",StrCountryCode];

    txt_CountryCode.backgroundColor=[UIColor clearColor];
    
    [scroll addSubview:txt_PhoneNo];
    [scroll addSubview:txt_CountryCode];
    
    
    //---Btn Verification code
    btn_CheckMeOut = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_CheckMeOut.userInteractionEnabled=YES;
    [btn_CheckMeOut addTarget:self
                        action:@selector(clk_btn_CheckMeOut:)
              forControlEvents:UIControlEventTouchDown];
    [btn_CheckMeOut setBackgroundImage:[UIImage imageNamed:@"check-me-out.png"] forState:UIControlStateNormal];
//    [btn_VerifyPhone setTitle: @"VERIFY MY PHONE" forState: UIControlStateNormal];
    [btn_CheckMeOut.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:13]];
    btn_CheckMeOut.frame = CGRectMake(25, 270-70, 270, 45);

    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_CheckMeOut.frame=CGRectMake(25,315-70, 270, 45);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_CheckMeOut.frame=CGRectMake(25,315-70, 270, 45);
        
        else
            btn_CheckMeOut.frame=CGRectMake(25,270-70, 270, 45);
    }
    

    [btn_CheckMeOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_CheckMeOut.userInteractionEnabled = NO;
    [scroll addSubview:btn_CheckMeOut];
    
    
    //---Label
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
    //[scroll addSubview:lbl_Info];
    
    
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
    txt_VerificationCode.keyboardType = UIKeyboardTypeNumberPad;
    [txt_VerificationCode setKeyboardAppearance:UIKeyboardAppearanceDark];
  //[scroll addSubview:txt_VerificationCode];
    
    //---Btn btn_Go ---
    btn_Go = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Go.userInteractionEnabled=NO;
    [btn_Go addTarget:self
                        action:@selector(clk_btn_Go:)
              forControlEvents:UIControlEventTouchDown];
     [btn_Go setBackgroundImage:[UIImage imageNamed:@"gobutton.png"] forState:UIControlStateNormal];
    btn_Go.frame = CGRectMake(109, self.view.frame.size.height-51, 102, 51.0);
    //[scroll addSubview:btn_Go];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scroll addGestureRecognizer:tap];
    
    
    [self.view bringSubviewToFront:self.tintView];
    [self performSelector:@selector(openKeyboard) withObject:nil afterDelay:0.2];
    
}

-(void)openKeyboard
{
    [txt_PhoneNo becomeFirstResponder];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txt_PhoneNo resignFirstResponder];
    [txt_CountryCode resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clk_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Selector Functions

-(IBAction)TopViewTransparentButton:(id)sender
{
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    [txt_PhoneNo resignFirstResponder];
    [txt_DisplayName resignFirstResponder];
    [txt_VerificationCode resignFirstResponder];
}

-(void)clk_btn_CheckMeOut:(id)sender
{
//    UIViewController *addyourdetails = [story instantiateViewControllerWithIdentifier:@"AddYourDetails"];
//  [self.navigationController pushViewController:addyourdetails animated:YES];
    
    if (![self checkValidation:nil])
        return;
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    

     [self performSelector:@selector(createUserWebservice) withObject:nil afterDelay:0.1];
    
//    if (check_btn_VerifyPhoneClk == FALSE)
    {
        NSLog(@"check_btn_VerifyPhoneClk = False");
//        [btn_VerifyPhone setTitle: @"RE-SEND THE VERIFICATION CODE" forState: UIControlStateNormal];
////      lbl_Info.text=@"In case you did not recieve it!";
//        lbl_Info.text=@"";
//        check_btn_VerifyPhoneClk=TRUE;
        
        
    }
//    else
    {
        NSLog(@"check_btn_VerifyPhoneClk = TRUE");
   //     [self performSelector:@selector(ResendVcodeWebservice) withObject:nil afterDelay:0.1];
    }
    
    [txt_CountryCode resignFirstResponder];
    [txt_PhoneNo resignFirstResponder];
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];

//    int_VerifiCode=1234;
//    btn_Go.userInteractionEnabled=YES;
//    txt_VerificationCode.userInteractionEnabled=YES;
}

-(void)ResendVcodeWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
    //    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        //NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/resendvcode"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_PhoneNo.text,@"phone_no",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token",nil];
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
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User already verified." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"User already verified."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
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
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Please try again."
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


-(void)createUserWebservice
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSString stringWithFormat:@"%@%@",txt_CountryCode.text,txt_PhoneNo.text] forKey:@"phoneNumber"];
    
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
       // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
    //  NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/createuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%@",txt_CountryCode.text,txt_PhoneNo.text],@"phone_no",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token",nil];
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
                VerifyPhoneNumberViewController *verifyPhoneNo = [story instantiateViewControllerWithIdentifier:@"VerifyPhoneNumberViewController"];
                [self.navigationController pushViewController:verifyPhoneNo animated:YES];

              //  [btn_VerifyPhone setTitle: @"RE-SEND THE VERIFICATION CODE" forState: UIControlStateNormal];
              //      lbl_Info.text=@"In case you did not recieve it!";
              //  lbl_Info.text=@"";
              //  check_btn_VerifyPhoneClk=TRUE;
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"WE SENT YOU A CODE" message:@"Just to make sure you didn't send wrong number to us" delegate:nil cancelButtonTitle:@"GOT IT!" otherButtonTitles:nil];
//                //alert.backgroundColor = [UIColor redColor];
//                [alert show];
//                alert = nil;
            }
            else
            {
             //   check_btn_VerifyPhoneClk = FALSE;
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Try again."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

            }
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        else if([request responseStatusCode] == 500)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User with same phone no. already exists."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User with same phone no. already exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User with same phone no. already exists."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
            }
            else
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Try again."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
                
                //   check_btn_VerifyPhoneClk = FALSE;
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
            }

        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Please try again."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
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
        [alertView show];
        alertView = nil;

    }
    [activity hide];
}

-(void)VerifyMyPhoneNoButtonAction
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/verifycode"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_VerificationCode.text,@"vcode",txt_PhoneNo.text,@"phone_no",@"IOS", @"device_type",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token", nil];
        
//      NSDictionary *Dictionary = [NSDictionary    dictionaryWithObjectsAndKeys:txt_VerificationCode.text,@"vcode",txt_PhoneNo.text,@"phone_no",@"h3h3h3h3h4h4h4h4h4h4h4h4h4h4h4h4h4h4h4h4",@"device_token", @"IOS", @"device_type", nil];
        
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
                VerifyPhoneNumberViewController *verifyPhoneNo = [story instantiateViewControllerWithIdentifier:@"VerifyPhoneNumberViewController"];
                [self.navigationController pushViewController:verifyPhoneNo animated:YES];
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                [prefs setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"user_token"];
                [prefs setObject:[jsonResponse objectForKey:@"user_id"] forKey:@"user_id"];
                [prefs setObject:txt_PhoneNo.text forKey:@"phoneNumber"];
                [prefs setObject:txt_DisplayName.text forKey:@"user_name"];
                
                [prefs setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"QBPassword"];
                [prefs setObject:[jsonResponse objectForKey:@"user_id"] forKey:@"QBUserName"];
                
                NSLog(@">>>: %@",[prefs stringForKey:@"QBPassword"]);
                NSLog(@">>>: %@",[prefs stringForKey:@"QBUserName"]);
                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User already verified"])
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
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Verification code is not valid."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code is not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
            }
        }
        else
        {
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
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Verification code is not valid." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Verification code is not valid."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        
        [activity hide];
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
        [alertView show];
        alertView = nil;
        
    }
}


-(void)clk_btn_Go:(id)sender
{
    app.str_App_DisplayName=txt_DisplayName.text;
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    
    BOOL checkNumerics=[self isNumeric:txt_VerificationCode.text];
    
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
    [self performSelector:@selector(VerifyMyPhoneNoButtonAction) withObject:nil afterDelay:0.1];

}

-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
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

//-(void)drawOverlayView
//{
//    UIView *temp_noActionView = [[UIView alloc]initWithFrame:CGRectMake(0,0,320,568)];
//    [temp_noActionView setBackgroundColor:[UIColor blackColor]];
//    [temp_noActionView setAlpha:0.7];
//    [temp_noActionView setTag:CustomView_tag_ComplaintsView];
//    
//    UIActivityIndicatorView *temp_activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    temp_activityIndicator.hidesWhenStopped=YES;
//    temp_activityIndicator.frame = CGRectMake(150,200,20,20);
//    [temp_activityIndicator setTag:CustomIndicator_tag_ComplaintsView];
//    
//    [temp_noActionView addSubview:temp_activityIndicator];
//    [self.view addSubview:temp_noActionView];
//    
//    [temp_activityIndicator startAnimating];
//}


//-(void)removeTempView
//{
//    [(UIActivityIndicatorView*)[self.view viewWithTag:CustomIndicator_tag_ComplaintsView] stopAnimating];
//    [[self.view viewWithTag:CustomIndicator_tag_ComplaintsView] removeFromSuperview];
//    
//    [[self.view viewWithTag:CustomView_tag_ComplaintsView] removeFromSuperview];
//  
//}

#pragma mark Custom Functions

-(BOOL)checkValidation:(id)sender
{
    if ((txt_CountryCode.text.length == 0) || ([txt_CountryCode.text isEqualToString:@" "]))
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Please enter country code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Please enter country code"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        return FALSE;
    }
    
    else if ((txt_PhoneNo.text.length == 0) || ([txt_PhoneNo.text isEqualToString:@" "]))
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Please enter mobile number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Please enter mobile number"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;

        
        return FALSE;
    }
    
    else if (txt_PhoneNo.text.length<5)
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter correct mobile number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Enter correct mobile number"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;

        
        return FALSE;
    }
    
    else if (txt_PhoneNo.text.length>5)
    {
        BOOL checkNumerics=[self isNumeric:txt_PhoneNo.text];
        if (checkNumerics == FALSE)
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Enter numerics only" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                            description:@"Enter numerics only"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            
            return FALSE;
        }
    }
    return TRUE;
}

#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if(textField == txt_DisplayName)
//    {
//        [txt_PhoneNo becomeFirstResponder];
//    }
//    else
//    {
//        [txt_DisplayName resignFirstResponder];
//        [txt_PhoneNo resignFirstResponder];
//        [txt_VerificationCode resignFirstResponder];
//        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
//    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField == txt_DisplayName)
//    {
//        [txt_PhoneNo setKeyboardType: UIKeyboardTypeDefault];
//        if (IS_IOS_7)
//        {
//            [scroll setContentOffset:CGPointMake(0,0) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,12) animated:YES];
//        }
//        else
//        {
//            [scroll setContentOffset:CGPointMake(0,16) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,18) animated:YES];
//        }
//    }
//    else if (textField == txt_PhoneNo)
//    {
//        [txt_PhoneNo setKeyboardType: UIKeyboardTypePhonePad];
//        
//        
//        if (IS_IOS_7)
//        {
//            [scroll setContentOffset:CGPointMake(0,50) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,12) animated:YES];
//        }
//        else
//        {
//            [scroll setContentOffset:CGPointMake(0,60) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,18) animated:YES];
//        }
//        
//        
//    }
//    else if (textField == txt_VerificationCode)
//    {
//        [txt_VerificationCode setKeyboardType: UIKeyboardTypeNumbersAndPunctuation];
//        
//        if (IS_IOS_7)
//        {
//            [scroll setContentOffset:CGPointMake(0,135) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,90) animated:YES];
//        }
//        else
//        {
//            [scroll setContentOffset:CGPointMake(0,140) animated:YES];
//            if (IS_IPHONE_5)
//                [scroll setContentOffset:CGPointMake(0,100) animated:YES];
//        }
//        
//    }
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
    if(textField==txt_PhoneNo)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(newLength == 0)
        {
            [btn_CheckMeOut setBackgroundImage:[UIImage imageNamed:@"check-me-out.png"] forState:UIControlStateNormal];
            btn_CheckMeOut.userInteractionEnabled = NO;

        }
        else
        {
            [btn_CheckMeOut setBackgroundImage:[UIImage imageNamed:@"check-me-out-Active.png"] forState:UIControlStateNormal];
            btn_CheckMeOut.userInteractionEnabled = YES;
        }
    }
    
//   else if(textField==txt_VerificationCode)
//   {
//       if ([string intValue] || !string.length)
//       {
//           NSUInteger newLength = [textField.text length] + [string length] - range.length;
//           return (newLength >4) ? NO : YES;
//           return YES;
//       }
//   }
   return YES;
}
@end
