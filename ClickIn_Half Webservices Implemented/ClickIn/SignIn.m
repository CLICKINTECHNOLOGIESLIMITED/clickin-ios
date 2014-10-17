//
//  SignIn.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "SignIn.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "AppDelegate.h"
#import <Foundation/NSJSONSerialization.h>
#import "SSKeychain.h"
#import "InvitationViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "profile_owner.h"
#import "NotificationsViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


#define CustomView_tag_ComplaintsView 2505
#define CustomIndicator_tag_ComplaintsView 2506

@interface SignIn ()

@end

@interface NSString (MD5)

- (NSString *)MD5String;

@end

@implementation NSString (MD5)

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

@implementation SignIn

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
    
    // Models
    modelmanager=[ModelManager modelManager];
    chatmanager=modelmanager.chatManager;
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidLogin:)
                                                 name:Notification_ChatDidLogin object:nil];
    
    //    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if([[defaults stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    //    {
    //        [QBUsers logInWithUserLogin:[defaults stringForKey:@"QBUserName"] password:[defaults stringForKey:@"QBPassword"] delegate:self];
    //    }
    //    else
    {
        signup=[[SignUp alloc]init];
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
        
        TopViewTransparentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [TopViewTransparentButton addTarget:self action:@selector(TopViewTransparentButton:) forControlEvents:UIControlEventTouchDown];
        // [TopViewTransparentButton setBackgroundImage:[UIImage imageNamed:@"letsgetclick.png"] forState:UIControlStateNormal];
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
        //[self.view addSubview:TopViewTransparentButton];
        
        //---UIimage View
        UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        compScreen.image=[UIImage imageNamed:@"640x1136Signin.png"];
        
        if (!IS_IPHONE_5)
        {
            compScreen.image=[UIImage imageNamed:@"640x960Signin.png"];
        }
        
        [scroll addSubview:compScreen];
        
        //---Text Field Display Name----
        txt_Phone_mail=[[UITextField alloc]initWithFrame:CGRectMake(43,138,238,30)];
        
        if (IS_IOS_7)
        {
            if (IS_IPHONE_5)
                txt_Phone_mail.frame=CGRectMake(47,138, 238, 30) ;
        }
        else
        {
            if (IS_IPHONE_5)
                txt_Phone_mail.frame=CGRectMake(47,138, 238, 30) ;
            
            else
                txt_Phone_mail.frame=CGRectMake(47,138, 238, 30) ;
        }
        txt_Phone_mail.placeholder=@"Phone/Email";
        txt_Phone_mail.textColor=[UIColor darkGrayColor];
        [txt_Phone_mail setDelegate:self];
        txt_Phone_mail.secureTextEntry = NO;
        txt_Phone_mail.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
        txt_Phone_mail.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
        txt_Phone_mail.autocapitalizationType = UITextAutocapitalizationTypeNone;
        txt_Phone_mail.autocorrectionType=UITextAutocorrectionTypeNo;
        [txt_Phone_mail setKeyboardAppearance:UIKeyboardAppearanceDark];
        txt_Phone_mail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scroll addSubview:txt_Phone_mail];
        
        CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [networkInfo subscriberCellularProvider];
        NSString *CountryName = [carrier isoCountryCode];
        
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
        
        txt_Phone_mail.text = [NSString stringWithFormat:@"+%@",[dictCodes valueForKey:[CountryName uppercaseString]]];
        
        //---Text Field Phone Number----
        txt_Password=[[UITextField alloc]initWithFrame:CGRectMake(43,176+5,238,30)];
        
        if (IS_IOS_7)
        {
            if (IS_IPHONE_5)
                txt_Password.frame=CGRectMake(47,176+5, 238, 30) ;
        }
        else
        {
            if (IS_IPHONE_5)
                txt_Password.frame=CGRectMake(47,176+5, 238, 30) ;
            
            else
                txt_Password.frame=CGRectMake(47,176+5, 238, 30) ;
        }
        txt_Password.placeholder=@"Password";
        txt_Password.textColor=[UIColor darkGrayColor];
        [txt_Password setDelegate:self];
        txt_Password.secureTextEntry = YES;
        txt_Password.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
        txt_Password.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
        txt_Password.autocapitalizationType = UITextAutocapitalizationTypeNone;
        txt_Password.autocorrectionType=UITextAutocorrectionTypeNo;
        [txt_Password setKeyboardAppearance:UIKeyboardAppearanceDark];
        txt_Password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [scroll addSubview:txt_Password];
        
        //txt_Phone_mail.text=@"+915675675678";
        //txt_Password.text=@"aaaaaaaa";
        
        
        //---Btn get clickin code
        btn_ClickIn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_ClickIn addTarget:self
                        action:@selector(clk_btn_ClickIn:)
              forControlEvents:UIControlEventTouchDown];
        [btn_ClickIn setBackgroundImage:[UIImage imageNamed:@"get-click.png"] forState:UIControlStateNormal];
        btn_ClickIn.frame = CGRectMake(25, 229, 270, 45.0);
        
        if (IS_IOS_7)
        {
            if (IS_IPHONE_5)
                btn_ClickIn.frame=CGRectMake(25,229, 270, 45) ;
        }
        else
        {
            if (IS_IPHONE_5)
                btn_ClickIn.frame=CGRectMake(25,340, 270, 45) ;
            
            else
                btn_ClickIn.frame=CGRectMake(25,300, 270, 45) ;
        }
        [btn_ClickIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scroll addSubview:btn_ClickIn];
        
        //---Btn Forgot Password---
        btn_ForgotPass = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn_ForgotPass addTarget:self
                           action:@selector(clk_btn_ForgotPass:)
                 forControlEvents:UIControlEventTouchDown];
        
        if (IS_IPHONE_5)
        {
            btn_ForgotPass.frame = CGRectMake(25, self.view.frame.size.height-288, 105, 35);
        }
        else
        {
            btn_ForgotPass.frame = CGRectMake(25, self.view.frame.size.height-200, 105, 35);
        }
        [scroll addSubview:btn_ForgotPass];
        
        //---Btn SignUp---
        btn_SignUp = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_SignUp addTarget:self
                       action:@selector(clk_btn_SignUp:)
             forControlEvents:UIControlEventTouchDown];
        
        
        if (IS_IPHONE_5)
            btn_SignUp.frame = CGRectMake(240, self.view.frame.size.height-288, 55, 35.0);
        else
            btn_SignUp.frame = CGRectMake(240, self.view.frame.size.height-200, 55, 35.0);
        
        [scroll addSubview:btn_SignUp];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scroll addGestureRecognizer:tap];
    
    [self.view bringSubviewToFront:self.tintView];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_ChatDidLogin object:nil];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [txt_Password resignFirstResponder];
    [txt_Phone_mail resignFirstResponder];
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

-(void)clk_btn_SignUp:(id)sender
{
    NSString  *stringin;
    if(IS_IPAD)
        stringin=@"Main_iPad";
    else
        stringin=@"Main_iPhone";
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:stringin bundle:nil];
    UIViewController *first = [storyBoard instantiateViewControllerWithIdentifier:@"SignUp"];
    //SignUp *first = [[SignUp alloc] init];
    [self.navigationController pushViewController:first animated:YES];
}


-(void)clk_btn_ForgotPass:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your email:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.delegate = self;
    alert.tag = 4747;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    [alertTextField setBackgroundColor:[UIColor whiteColor]];
    alertTextField.delegate = self;
    alertTextField.borderStyle = UITextBorderStyleNone;
    alertTextField.frame = CGRectMake(15, 75, 255, 30);
    alertTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    alertTextField.placeholder = @"Preset Name";
    alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [alertTextField becomeFirstResponder];
    alertTextField.placeholder = @"Enter your emailID";
    [alert show];
}


- (void)alertViewPressButton:(MODropAlertView *)alertView buttonType:(DropAlertButtonType)buttonType
{
    if(alertView.tag==7777)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your email:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        alert.tag = 4747;
        UITextField * alertTextField = [alert textFieldAtIndex:0];
        [alertTextField setBackgroundColor:[UIColor whiteColor]];
        alertTextField.delegate = self;
        alertTextField.borderStyle = UITextBorderStyleNone;
        alertTextField.frame = CGRectMake(15, 75, 255, 30);
        alertTextField.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
        alertTextField.placeholder = @"Preset Name";
        alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
        [alertTextField becomeFirstResponder];
        alertTextField.placeholder = @"Enter your emailID";
        [alert show];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==4747)
    {
        NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
        
        if(buttonIndex==0)
        {
        }
        else
        {
            if(![self validEmail:[[alertView textFieldAtIndex:0] text]])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alert.delegate = self;
//                alert.tag = 7777;
//                [alert show];
//                alert = nil;
                
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                                description:@"Please enter a valid email address"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = self;
                alertView.tag = 7777;
                [alertView showForPresentView];
                alertView = nil;
                
            }
            else
            {
                //hit forgot password webservice
                if(activity==nil)
                    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
                [activity show];
                
                [self performSelector:@selector(updatePasswordWebservice:) withObject:[[alertView textFieldAtIndex:0] text] afterDelay:0.1];
            }
        }
    }
}

#pragma mark Selector Functions

-(BOOL)validEmail:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}


-(void)updatePasswordWebservice:(NSString*)email
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"settings/forgotpassword"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        
        NSError *error;
        
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",nil];
        
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
            
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"A password recovery link has been sent to your email."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"A password recovery link has been sent to your email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"A password recovery link has been sent to your email."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;

            }
            
        }
        else
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[jsonResponse objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                            description:[jsonResponse objectForKey:@"message"]
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


-(void)clk_btn_ClickIn:(id)sender
{
    if (![self checkValidation:nil])
        return;
    
    [txt_Phone_mail resignFirstResponder];
    [txt_Password resignFirstResponder];
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(SignInWebserviceCall) withObject:nil afterDelay:0.1];
}

-(void)SignInWebserviceCall
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/signin"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        //NSString *retrieveuuid = [SSKeychain passwordForService:@"your app identifier" account:@"user"];
        
        
        
        NSError *error;
        
        BOOL checkEmail=[self validEmail:txt_Phone_mail.text];
        NSDictionary *Dictionary;
        if(checkEmail == false)
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_Phone_mail.text,@"phone_no",txt_Password.text,@"password",@"IOS",@"device_type",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token",nil];
        }
        else
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_Phone_mail.text,@"email",txt_Password.text,@"password",@"IOS",@"device_type",[[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceToken"],@"device_token",nil];
        }
        
        //Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:txt_Phone_mail.text,@"phone_no",retrieveuuid,@"device_token",txt_Password.text,@"password",nil];
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User logged in."])
            {
                //              UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User logged in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //              [alert show];
                //              alert = nil;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:@"yes" forKey:@"IsAutoLogin"];
                
                [defaults setObject:txt_Phone_mail.text forKey:@"Phone_mail"];
                
                [defaults setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"user_token"];
                
                [defaults setObject:[jsonResponse objectForKey:@"phone_no"] forKey:@"phoneNumber"];
                
                [defaults setObject:[jsonResponse objectForKey:@"user_token"] forKey:@"QBPassword"];
                
                [defaults setObject:[jsonResponse objectForKey:@"user_id"] forKey:@"QBUserName"];
                
                [defaults setObject:[jsonResponse objectForKey:@"QB_id"] forKey:@"QB_id"];
                
                [defaults setInteger:(int)(unsigned long)[[jsonResponse objectForKey:@"QB_id"] longValue] forKey:@"SenderId"];
                
                if([jsonResponse objectForKey:@"user_pic"]!= [NSNull null])
                    [defaults setObject:[jsonResponse objectForKey:@"user_pic"] forKey:@"user_pic"];
                
                [defaults setObject:[jsonResponse objectForKey:@"user_name"] forKey:@"user_name"];
                
                //              NSString *md5 = [[jsonResponse objectForKey:@"user_token"] MD5String];
                
                [QBUsers logInWithUserLogin:[jsonResponse objectForKey:@"user_id"] password:[jsonResponse objectForKey:@"user_token"] delegate:(AppDelegate *)[[UIApplication sharedApplication]delegate]];
                
                [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.2];
                
                //[activity hide];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Wrong password"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"The Username/Password combination entered is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                
                
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"The Username/Password combination entered is incorrect"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
                
                [activity hide];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User not registered."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"The Username/Password combination entered is incorrect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"The Username/Password combination entered is incorrect"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;

                
                [activity hide];
            }
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Wrong password"])
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"The Username/Password combination entered is incorrect"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User not registered."])
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"The Username/Password combination entered is incorrect"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
            }
            else
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"The Username/Password combination entered is incorrect"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView showForPresentView];
                alertView = nil;
            }
            [activity hide];
        }
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
#pragma mark QBChatDelegate

- (void)completedWithResult:(Result *)result
{
    if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBUUserLogInResult *userResult = (QBUUserLogInResult *)result;
        NSLog(@"Logged In user=%d", (int)(unsigned long)userResult.user.ID);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSLog(@"%d",(int)(unsigned long)userResult.user.ID);
        [prefs setInteger:(int)(unsigned long)userResult.user.ID forKey:@"SenderId"];
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = userResult.user.ID; // your current user's ID
        //   NSString *md5 = [[prefs stringForKey:@"QBPassword"] MD5String];
        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
        
        [chatmanager loginWithUser:currentUser];
        //[QBChat instance].delegate = self;
        //[[QBChat instance] loginWithUser:currentUser];
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
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
    }
}

- (void)chatDidLogin:(NSNotification *)notification{
    //[self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
}

-(void)CallrelationshipsWebservice
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/getrelationships"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
        
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
            
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"])
            {
                //NSLog(@"VC>> %@",self.navigationController.viewControllers);
                UIViewController *ObjInvitationViewController = [story instantiateViewControllerWithIdentifier:@"InvitationViewController"];
                [self.navigationController pushViewController:ObjInvitationViewController animated:YES];
                //[self presentViewController:ObjInvitationViewController animated:YES completion:nil];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"])
            {
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSArray *TempArray = [[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"relationships"]];
                [[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"];
                [prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"]] forKey:@"partner_QB_id"];
                [prefs setObject:[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_pic"]] forKey:@"partner_pic"];
                
                NSLog(@"id: %@",[NSString stringWithFormat:@"%@",[[TempArray objectAtIndex:0] objectForKey:@"partner_QB_id"]]);
                
                // [self performSelector:@selector(callSlideMenu) withObject:self afterDelay:0.1];
                
                UIViewController *ObjInvitationViewController = [story instantiateViewControllerWithIdentifier:@"InvitationViewController"];
                [self.navigationController pushViewController:ObjInvitationViewController animated:YES];
            }
        }
        else if([request responseStatusCode] == 500)
        {
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Some error occured."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;

        }
        else if([request responseStatusCode] == 401)
        {
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Some error occured."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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


-(void)check
{
    UIViewController *ObjInvitationViewController = [story instantiateViewControllerWithIdentifier:@"InvitationViewController"];
    [self.navigationController pushViewController:ObjInvitationViewController animated:YES];
}

#pragma mark Custom Functions

-(IBAction)TopViewTransparentButton:(id)sender
{
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    [txt_Password resignFirstResponder];
    [txt_Phone_mail resignFirstResponder];
}

- (profile_owner *)demoController {
    // return [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    return [[profile_owner alloc] initWithNibName:nil bundle:nil];
}

- (UINavigationController *)navigationControllers {
    UINavigationController *nv = [[UINavigationController alloc]
                                  initWithRootViewController:[self demoController]];
    nv.navigationBarHidden = YES;
    return nv;
}

-(void)callSlideMenu
{
    [activity hide];
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


-(BOOL)isNumeric:(NSString*)inputString
{
    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[inputString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [inputString isEqualToString:filtered];
}


-(BOOL)checkValidation:(id)sender
{
    if ((txt_Phone_mail.text.length == 0) || ([txt_Phone_mail.text isEqualToString:@" "]))
    {
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Please enter Phone No./Email name"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        return FALSE;
    }
    
    else if (txt_Phone_mail.text.length>1)
    {
        BOOL checkNumerics=[self isNumeric:txt_Phone_mail.text];
        BOOL checkEmail=[self validEmail:txt_Phone_mail.text];
        
        if ((checkNumerics == FALSE) && (checkEmail == FALSE))
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"The Username/Password combination entered is incorrect" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                            description:@"The Username/Password combination entered is incorrect"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
            
            return FALSE;
        }
    }
    
    if ((txt_Password.text.length == 0) || ([txt_Password.text isEqualToString:@" "]))
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"ClickIn" message:@"Please enter password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"ClickIn'"
                                                                        description:@"Please enter password"
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;

        
        return FALSE;
    }
    
    return TRUE;
}

#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txt_Phone_mail)
    {
        [txt_Password becomeFirstResponder];
    }
    else if (textField == txt_Password)
    {
        [txt_Password resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //    if (textField == txt_Phone_mail)
    //    {
    //        textField.returnKeyType = UIReturnKeyNext;
    //        if (!IS_IPHONE_5)
    //            [scroll setContentOffset:CGPointMake(0,50) animated:YES];
    //
    //    }
    //    else if (textField == txt_Password)
    //    {
    //        textField.returnKeyType = UIReturnKeyDone;
    //        [scroll setContentOffset:CGPointMake(0,50) animated:YES];
    //        if (IS_IPHONE_5)
    //            [scroll setContentOffset:CGPointMake(0,10) animated:YES];
    //    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txt_Phone_mail)
    {
        
    }
    else if (textField == txt_Password)
    {
        
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==txt_Phone_mail)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >30) ? NO : YES;
        return YES;
    }
    
    else if(textField==txt_Password)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength >20) ? NO : YES;
        return YES;
    }
    
    return YES;
}

@end
