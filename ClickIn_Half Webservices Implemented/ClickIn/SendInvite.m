//
//  SendInvite.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 17/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "SendInvite.h"
#import "InvitationViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MFSideMenu.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "CenterViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "NotificationsViewController.h"
#import "CurrentClickersViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>



@interface SendInvite ()

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

@implementation SendInvite
@synthesize ProfileImg,StrCountryCode;
@synthesize dict;
@synthesize isFromMenu;

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
    
    [dictCodes valueForKey:countryCode];
    
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *CountryName = [carrier isoCountryCode];
    if (CountryName != nil)
    {
        StrCountryCode = [dictCodes valueForKey:[CountryName uppercaseString]];
    }
    
    dictCodes = nil;
    
    
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
    if([dict count] > 0)
    {
        compScreen.image=[UIImage imageNamed:@"640X1136Search.png"];
    }
    else
    {
        compScreen.image=[UIImage imageNamed:@"640X1136invt.png"];
    }
    
    if (!IS_IPHONE_5)
    {
        if([dict count] > 0)
        {
            compScreen.image=[UIImage imageNamed:@"640X960Search.png"];
        }
        else
        {
            compScreen.image=[UIImage imageNamed:@"640X960invt.png"];
        }
    }
    
    [scroll addSubview:compScreen];
    //---Text Field Phone Number----
    if([dict count] > 0)
    {
        txt_CountryCode = [[UITextField alloc]initWithFrame:CGRectMake(40,210+8, 58+10, 30+5)];
        txt_PhoneNo=[[UITextField alloc]initWithFrame:CGRectMake(94+10+9,210+8, 238-68-15+10, 30+5)];
    }
    else
    {
        txt_CountryCode = [[UITextField alloc]initWithFrame:CGRectMake(40,155+26, 58+10, 30+5)];
        txt_PhoneNo=[[UITextField alloc]initWithFrame:CGRectMake(94+10+9,155+26, 238-68-15+10, 30+5)];
    }
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            if([dict count] > 0)
            {
                txt_PhoneNo.frame=CGRectMake(94+10+9,195+65, 238-68-15+10, 30+5) ;
                txt_CountryCode.frame=CGRectMake(40,195+65, 58+10, 30+5);
            }
            else
            {
                txt_PhoneNo.frame=CGRectMake(94+10+9,185+10-5-2, 238-68-15+10, 30+5) ;
                txt_CountryCode.frame=CGRectMake(40,185+10-5-2, 58+10, 30+5) ;
            }
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            txt_PhoneNo.frame=CGRectMake(94+10+10,185, 238-68-15, 30+5) ;
            txt_CountryCode.frame=CGRectMake(38,185, 58, 30+5) ;
        }
        else
        {
            txt_CountryCode.frame=CGRectMake(38,142-5, 58, 30) ;
            txt_PhoneNo.frame=CGRectMake(94+10,142-5, 238-38, 30) ;
        }
    }
  //txt_PhoneNo.backgroundColor = [UIColor redColor];
    txt_PhoneNo.placeholder=@"Phone Number";
    txt_PhoneNo.textColor=[UIColor darkGrayColor];
    [txt_PhoneNo setDelegate:self];
    txt_PhoneNo.secureTextEntry = NO;
    txt_PhoneNo.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    txt_PhoneNo.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    txt_PhoneNo.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_PhoneNo.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_PhoneNo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_PhoneNo.keyboardType = UIKeyboardTypePhonePad;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [txt_PhoneNo setLeftViewMode:UITextFieldViewModeAlways];
    [txt_PhoneNo setLeftView:spacerView];

    [txt_PhoneNo setKeyboardAppearance:UIKeyboardAppearanceDark];
    
  
    
   // txt_CountryCode.backgroundColor = [UIColor greenColor];
    //    txt_PhoneNo.placeholder=@"Phone Number";
    txt_CountryCode.textColor=[UIColor darkGrayColor];
    [txt_CountryCode setDelegate:self];
    txt_CountryCode.secureTextEntry = NO;
    txt_CountryCode.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    txt_CountryCode.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    txt_CountryCode.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_CountryCode.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_CountryCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt_CountryCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    txt_CountryCode.keyboardType = UIKeyboardTypePhonePad;
    [txt_CountryCode setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    
//    if(![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"+"] && ![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"00"])
//    {
//        //if([[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"0"])
//        NSLog(@"local number");
//    }
    
    NSDictionary *dict_Codes = [NSDictionary dictionaryWithObjectsAndKeys:@"IL", @"972",
                               @"AF", @"93", @"AL", @"355", @"DZ", @"213", @"AS", @"1",
                               @"AD", @"376", @"AO", @"244", @"", @"1", @"AG", @"1",
                               @"AR", @"54", @"AM", @"374", @"AW", @"297", @"AU", @"61",
                               @"AT", @"43", @"AZ", @"994", @"BS", @"1", @"BH", @"973",
                               @"BD", @"880", @"BB", @"1", @"BY", @"375", @"BE", @"32",
                               @"BZ", @"501", @"BJ", @"229", @"BM", @"1", @"BT", @"975",
                               @"BA", @"387", @"BW", @"267", @"BR", @"55", @"IO", @"246",
                               @"BG", @"246", @"BF", @"226", @"BI", @"257", @"KH", @"855",
                               @"CM", @"237", @"CA", @"1", @"CV", @"238", @"KY", @"245",
                               @"CF", @"236", @"TD", @"235", @"CL", @"56", @"CN", @"86",
                               @"CX", @"61", @"CO", @"57", @"KM", @"269", @"CG", @"242",
                               @"CK", @"682", @"CR", @"506", @"HR", @"385", @"CU", @"53",
                               @"CY", @"537", @"CZ", @"420", @"DK", @"45", @"DJ", @"253",
                               @"DM", @"1", @"DO", @"1", @"EC", @"593", @"EG", @"20",
                               @"SV", @"503", @"GQ", @"240", @"ER", @"291", @"EE", @"372",
                               @"ET", @"251", @"FO", @"298", @"FJ", @"679", @"FI", @"358",
                               @"FR", @"33", @"GF", @"594", @"PF", @"689", @"GA", @"241",
                               @"GM", @"220", @"GE", @"995", @"DE", @"49", @"GH", @"233",
                               @"GI", @"350", @"GR", @"30", @"GL", @"299", @"GD", @"1",
                               @"GP", @"590", @"GU", @"1", @"GT", @"502", @"GN", @"224",
                               @"GW", @"245", @"GY", @"595", @"HT", @"509", @"HN", @"504",
                               @"HU", @"36", @"IS", @"354", @"IN", @"91", @"ID", @"62",
                               @"IQ", @"964", @"IE", @"353", @"IL", @"972", @"IT", @"39",
                               @"JM", @"1", @"JP", @"81", @"JO", @"962", @"KZ", @"77",
                               @"KE", @"254", @"KI", @"686", @"KW", @"965", @"KG", @"996",
                               @"LV", @"371", @"LB", @"961", @"LS", @"266", @"LR", @"231",
                               @"LI", @"423", @"LT", @"370", @"LU", @"352", @"MG", @"261",
                               @"MW", @"265", @"MY", @"60", @"MV", @"960", @"ML", @"223",
                               @"MT", @"356", @"MH", @"692", @"MQ", @"596", @"MR", @"222",
                               @"MU", @"230", @"YT", @"262", @"MX", @"52", @"MC", @"377",
                               @"MN", @"976", @"ME", @"382", @"MS", @"1", @"MA", @"212",
                               @"MM", @"95", @"NA", @"264", @"NR", @"674", @"NP", @"977",
                               @"NL", @"31", @"AN", @"599", @"NC", @"687", @"NZ", @"64",
                               @"NI", @"505", @"NE", @"227", @"NG", @"234", @"NU", @"683",
                               @"NF", @"672", @"MP", @"1", @"NO", @"47", @"OM", @"968",
                               @"PK", @"92", @"PW", @"680", @"PA", @"507", @"PG", @"675",
                               @"PY", @"595", @"PE", @"51", @"PH", @"63", @"PL", @"48",
                               @"PT", @"351", @"PR", @"1", @"QA", @"974", @"RO", @"40",
                               @"RW", @"250", @"WS", @"685", @"SM", @"378", @"SA", @"966",
                               @"SN", @"221", @"RS", @"381", @"SC", @"248", @"SL", @"232",
                               @"SG", @"65", @"SK", @"421", @"SI", @"386", @"SB", @"677",
                               @"ZA", @"27", @"GS", @"500", @"ES", @"34", @"LK", @"94",
                               @"SD", @"249", @"SR", @"597", @"SZ", @"268", @"SE", @"46",
                               @"CH", @"41", @"TJ", @"992", @"TH", @"66", @"TG", @"228",
                               @"TK", @"290", @"TO", @"676", @"TT", @"1", @"TN", @"216",
                               @"TR", @"90", @"TM", @"993", @"TC", @"1", @"TV", @"688",
                               @"UG", @"256", @"UA", @"380", @"AE", @"971", @"GB", @"44",
                               @"US", @"1", @"UY", @"598", @"UZ", @"998", @"VU", @"678",
                               @"WF", @"681", @"YE", @"967", @"ZM", @"260", @"ZW", @"263",
                               @"BO", @"591", @"BN", @"673", @"CC", @"61", @"CD", @"243",
                               @"CI", @"225", @"FK", @"500", @"GG", @"44", @"VA", @"379",
                               @"HK", @"852", @"IR", @"98", @"IM", @"44", @"JE", @"44",
                               @"KP", @"850", @"KR", @"82", @"LA", @"856", @"LY", @"218",
                               @"MO", @"853", @"MK", @"389", @"FM", @"691", @"MD", @"373",
                               @"MZ", @"258", @"PS", @"970", @"PN", @"872", @"RE", @"262",
                               @"RU", @"7", @"BL", @"590", @"SH", @"290", @"KN", @"1",
                               @"LC", @"1", @"MF", @"590", @"PM", @"508", @"VC", @"1",
                               @"ST", @"239", @"SO", @"252", @"SJ", @"47", @"SY", @"963",
                               @"TW", @"886", @"TZ", @"255", @"TL", @"670", @"VE", @"58",
                               @"VN", @"84", @"VG", @"1", @"VI", @"1", nil];

    NSString *strPhoneNumber;
    strPhoneNumber = [dict objectForKey:@"phoneNumber"];
    
    if([[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"0"] && ![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"00"] && ![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"+"])
    {
        NSLog(@"local number");
        txt_CountryCode.text = [NSString stringWithFormat:@"+%@",StrCountryCode];
        
        
        if ([strPhoneNumber hasPrefix:@"0"] && [strPhoneNumber length] > 1)
        {
            strPhoneNumber = [strPhoneNumber substringFromIndex:1];
        }
    
    
    }
    else if (![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"00"] && ![[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"+"])
    {
        NSLog(@"local number");
        txt_CountryCode.text = [NSString stringWithFormat:@"+%@",StrCountryCode];
    }
    else
    {
        if ([[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"00"])
        {
             strPhoneNumber = [strPhoneNumber substringFromIndex:2];
        }
        
         if ([[NSString stringWithFormat:@"%@",(NSString*)[dict objectForKey:@"phoneNumber"]] hasPrefix:@"+"])
         {
             strPhoneNumber = [strPhoneNumber substringFromIndex:1];
         }
        
        NSString *TmpString;
        
        NSLog(@"%@",[dict objectForKey:@"phoneNumber"]);
        
        
        for(int i = 4 ; i >= 1 ; i--)
        {
            TmpString = [strPhoneNumber substringToIndex:i];
            
            if ([dict_Codes objectForKey:TmpString])
            {
                // key exists
                NSLog(@"%@",TmpString);
                
                strPhoneNumber = [strPhoneNumber substringFromIndex:TmpString.length];
                
                txt_CountryCode.text =[NSString stringWithFormat:@"+%@",TmpString];
                
                break;
            }
        }
    }
    
    if([dict count] > 0)
    {
        txt_PhoneNo.text = strPhoneNumber;
    }
    
    
    [scroll addSubview:txt_PhoneNo];
    [scroll addSubview:txt_CountryCode];
    //---Btn Verification code
    GetClickin = [UIButton buttonWithType:UIButtonTypeCustom];
    GetClickin.enabled=YES;
    GetClickin.tag = 2;
    [GetClickin addTarget:self
                       action:@selector(clk_Btn:)
             forControlEvents:UIControlEventTouchDown];
    [GetClickin setBackgroundImage:[UIImage imageNamed:@"get-click.png"] forState:UIControlStateNormal];
    //    [btn_VerifyPhone setTitle: @"VERIFY MY PHONE" forState: UIControlStateNormal];
    [GetClickin.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:13]];
    
    if([dict count] > 0)
        GetClickin.frame = CGRectMake(38, 220+47, 242, 45);
    else
       GetClickin.frame = CGRectMake(38, 220-5+24, 242, 45);
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            if([dict count] > 0)
            {
                GetClickin.frame=CGRectMake(38,322, 242, 45);
            }
            else
            {
                GetClickin.frame=CGRectMake(38,245, 242, 45);
            }
        }
    }
    else
    {
        if (IS_IPHONE_5)
            GetClickin.frame=CGRectMake(38,315-70, 242, 45);
        
        else
            GetClickin.frame=CGRectMake(38,270-70, 242, 45);
    }
    
    [GetClickin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([txt_PhoneNo.text length] < 9)
    {
        GetClickin.enabled = NO;
    }
    
    [scroll addSubview:GetClickin];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnPressed)
      forControlEvents:UIControlEventTouchDown];
    backBtn.frame = CGRectMake(25, self.view.frame.size.height-50, 270, 50);
    [self.view addSubview:backBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scroll addGestureRecognizer:tap];
    
    if([dict count] > 0)
    {
        UIImageView *imgView;
        if (IS_IPHONE_5)
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 158+30-3, 39, 39)];
        else
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(37, 158, 30, 30)];
        imgView.image = [UIImage imageWithData:[dict objectForKey:@"photo"]];
        [self.view addSubview:imgView];
     // Name
     // phoneNumber
        UILabel *lblName;
        lblName.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
        lblName.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];

        if (IS_IPHONE_5)
        {
            lblName = [[UILabel alloc] initWithFrame:CGRectMake(84,158+32, 150, 30)];
        }
        else
        {
            lblName = [[UILabel alloc] initWithFrame:CGRectMake(77, 158, 150, 30)];
        }
        lblName.text = [dict objectForKey:@"Name"];
        [self.view addSubview:lblName];
    }
    
     [self.view bringSubviewToFront:self.tintView];
}

- (void) backBtnPressed
{
    if([isFromMenu isEqualToString:@"true"])
    {
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        //[navigationController popViewControllerAnimated:YES];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromLeft;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

/*{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@ >>>>>>>>>>>>>>>> %@",[prefs stringForKey:@"user_id"],[prefs stringForKey:@"user_token"]);
    
//  NSString *md5 = [[prefs stringForKey:@"QBPassword"] MD5String];

    [QBUsers logInWithUserLogin:[prefs stringForKey:@"QBUserName"] password:[prefs stringForKey:@"QBPassword"] delegate:self];

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
    compScreen.image=[UIImage imageNamed:@"startclickin640x1136.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"startclickin.png"];
    }
    
    [scroll addSubview:compScreen];
    
    
    id firstcontroller= [self.navigationController.viewControllers objectAtIndex:0];
    if(![firstcontroller isKindOfClass:[profile_owner class]]) // check for profilesign up
    {
        
   //--- Image View for Profile Pic---
    if (IS_IOS_7)
    img_ProfilePic=[[UIImageView alloc]initWithFrame:CGRectMake(47, 33, 45, 45)];
    else
    img_ProfilePic=[[UIImageView alloc]initWithFrame:CGRectMake(47, 23, 45, 45)];
    
    img_ProfilePic.image=ProfileImg;
//  img_ProfilePic.backgroundColor=[UIColor greenColor];
    [scroll addSubview:img_ProfilePic];
    
    //----UILabel Implematation---
    //----Lbl Name----
    if (IS_IOS_7)
        lbl_Name=[[UILabel alloc]initWithFrame:CGRectMake(103, 27, 180, 25)];
    else
        lbl_Name=[[UILabel alloc]initWithFrame:CGRectMake(103, 17, 180, 25)];
    lbl_Name.numberOfLines=0;
    //lbl_Name.textAlignment=NSTextAlignmentCenter;
    lbl_Name.backgroundColor=[UIColor clearColor];
    lbl_Name.textColor=[UIColor grayColor];
    lbl_Name.hidden=NO;
    
    NSObject * object = [prefs objectForKey:@"UName"];
    if(object != nil)
    {
        lbl_Name.text=[NSString stringWithFormat:@"%@",[prefs objectForKey:@"UName"]];
    }
    else
    {
        lbl_Name.text=@"";
    }
    
    lbl_Name.font=[UIFont fontWithName:@"AvenirNext-Bold" size:16];
    [scroll addSubview:lbl_Name];
    
    //----Lbl Email----
    if (IS_IOS_7)
        lbl_Email=[[UILabel alloc]initWithFrame:CGRectMake(103, 48, 180, 15)];
    else
        lbl_Email=[[UILabel alloc]initWithFrame:CGRectMake(103, 39, 180, 15)];
    lbl_Email.numberOfLines=0;
    //lbl_Name.textAlignment=NSTextAlignmentCenter;
    lbl_Email.backgroundColor=[UIColor clearColor];
    lbl_Email.textColor=[UIColor grayColor];
    lbl_Email.hidden=NO;
    NSObject * objectEmail = [prefs objectForKey:@"EMail"];
    if(objectEmail != nil)
    {
        lbl_Email.text=[NSString stringWithFormat:@"%@",[prefs objectForKey:@"EMail"]];
    }
    else
    {
        lbl_Email.text=@"";
    }
    lbl_Email.font=[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:13];
    [scroll addSubview:lbl_Email];

    
    //----Lbl DOB----
    if (IS_IOS_7)
        lbl_DOB=[[UILabel alloc]initWithFrame:CGRectMake(103, 64, 180, 15)];
    else
        lbl_DOB=[[UILabel alloc]initWithFrame:CGRectMake(103, 54, 180, 15)];
    lbl_DOB.numberOfLines=0;
    //lbl_Name.textAlignment=NSTextAlignmentCenter;
    lbl_DOB.backgroundColor=[UIColor clearColor];
    lbl_DOB.textColor=[UIColor grayColor];
    lbl_DOB.hidden=NO;
    NSObject * objectBDay = [prefs objectForKey:@"BDay"];
    if(objectBDay != nil)
    {
        lbl_DOB.text=[NSString stringWithFormat:@"%@",[prefs objectForKey:@"BDay"]];
    }
    else
    {
        lbl_DOB.text=@"";
    }
    lbl_DOB.font=[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:13];
    [scroll addSubview:lbl_DOB];

        
        //--- Buttons code----
        
        btn_Edit = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_Edit.tag=1;
        [btn_Edit setBackgroundImage:[UIImage imageNamed:@"dragicon.png"] forState:UIControlStateNormal];
        [btn_Edit addTarget:self
                     action:@selector(clk_Btn:)
           forControlEvents:UIControlEventTouchDown];
        if (IS_IOS_7)
            btn_Edit.frame = CGRectMake(280, 40, 30, 30.0);
        else
            btn_Edit.frame = CGRectMake(280, 30, 30, 30.0);
        [scroll addSubview:btn_Edit];
        
        
}// if profile sign up page

    //---UIText Field----
    txt_name_Number=[[UITextField alloc]initWithFrame:CGRectMake(60,315,220,30)];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            txt_name_Number.frame=CGRectMake(60,360, 220, 30) ;
    }
    else
    {
        if (IS_IPHONE_5)
            txt_name_Number.frame=CGRectMake(60,360, 220, 30) ;
        
        else
            txt_name_Number.frame=CGRectMake(60,315, 220, 30) ;
    }
    txt_name_Number.placeholder=@"Name/Number from your Phonebook";
    //txt_name_Number.textColor=[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    txt_name_Number.textColor=[UIColor darkGrayColor];
    txt_name_Number.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15];
    [txt_name_Number setDelegate:self];
    txt_name_Number.secureTextEntry = NO;
    txt_name_Number.autocapitalizationType = UITextAutocapitalizationTypeNone;
    txt_name_Number.autocorrectionType=UITextAutocorrectionTypeNo;
    txt_name_Number.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [scroll addSubview:txt_name_Number];

   
    
    
    btn_SendInvite = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_SendInvite setBackgroundImage:[UIImage imageNamed:@"sendinvite.png"] forState:UIControlStateNormal];
    btn_SendInvite.tag=2;
    [btn_SendInvite addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    btn_SendInvite.frame = CGRectMake(48, self.view.frame.size.height-110, 224, 36);
    [scroll addSubview:btn_SendInvite];
    
    //---Btn Bottom Buttons code
    
    btn_Back = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn_Back.backgroundColor=[UIColor redColor];
    btn_Back.tag=3;
    [btn_Back addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"dontbckbtn.png"] forState:UIControlStateNormal];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"backbtngrey.png"] forState:UIControlStateHighlighted];
    btn_Back.frame = CGRectMake(80, self.view.frame.size.height-26, 41, 26.0);
    [scroll addSubview:btn_Back];
    
    btn_Done = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn_Done.backgroundColor=[UIColor yellowColor];
    btn_Done.tag=4;
    [btn_Done addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    [btn_Done setBackgroundImage:[UIImage imageNamed:@"donebtn.png"] forState:UIControlStateNormal];
    [btn_Done setBackgroundImage:[UIImage imageNamed:@"donebtngrey.png"] forState:UIControlStateHighlighted];
    btn_Done.frame = CGRectMake(121, self.view.frame.size.height-47, 77, 47);
    [scroll addSubview:btn_Done];
    
    btn_Skip = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn_Skip.backgroundColor=[UIColor greenColor];
    btn_Skip.tag=5;
    [btn_Skip addTarget:self
                 action:@selector(clk_Btn:)
       forControlEvents:UIControlEventTouchDown];
    [btn_Skip setBackgroundImage:[UIImage imageNamed:@"dontskpkbtn.png"] forState:UIControlStateNormal];
    [btn_Skip setBackgroundImage:[UIImage imageNamed:@"dontskpkbtn-grey.png"] forState:UIControlStateHighlighted];
    btn_Skip.frame = CGRectMake(198, self.view.frame.size.height-26, 41, 26.0);
    [scroll addSubview:btn_Skip];
    
    //[NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
}*/


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

#pragma mark -
#pragma mark navigationController methods



/*
- (void)completedWithResult:(Result *)result
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBASessionCreationRequest *extendedAuthRequest = [QBASessionCreationRequest request];
        extendedAuthRequest.userLogin = [prefs stringForKey:@"QBUserName"];
        extendedAuthRequest.userPassword = [prefs stringForKey:@"QBPassword"];
        [QBAuth createSessionWithExtendedRequest:extendedAuthRequest delegate:self];
    }
    else if(result.success && [result isKindOfClass:QBAAuthSessionCreationResult.class])
    {
        QBAAuthSessionCreationResult *res = (QBAAuthSessionCreationResult *)result;
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = res.session.userID; // your current user's ID
        [prefs setInteger:(int)(unsigned long)res.session.userID forKey:@"SenderId"];
        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
        [QBChat instance].delegate = self;
        [[QBChat instance] loginWithUser:currentUser];
        
//        QBUUserLogInResult *userResult = (QBUUserLogInResult *)result;
//        NSLog(@"Logged In user=%d", (int)(unsigned long)userResult.user.ID);
//        [prefs setInteger:(int)(unsigned long)userResult.user.ID forKey:@"SenderId"];
//        QBUUser *currentUser = [QBUUser user];
//        currentUser.ID = userResult.user.ID; // your current user's ID
//        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
//        [QBChat instance].delegate = self;
//        [[QBChat instance] loginWithUser:currentUser];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:[result.errors description]
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
}
*/



#pragma mark -
#pragma mark SMS Feature

-(void) sendInAppSMS
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    controller.delegate = self;
    
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Hey ! Lets you and I get Clickin' ! Download now - https://itunes.apple.com/us/app/clickin-keep-scoring/id901882470?ls=1&mt=8";
        controller.recipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@",txt_CountryCode.text,txt_PhoneNo.text],nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result)
    {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
            break;
		case MessageComposeResultFailed:
			NSLog(@"Failed..");
            break;
		case MessageComposeResultSent:
            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //            [alert show];
            //            alert = nil;
            
            break;
		default:
            break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Selector Function

-(void)CallRelationShipWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        [txt_PhoneNo resignFirstResponder];
        [txt_CountryCode resignFirstResponder];
        
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/newrequest"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSString *Str = [[NSString stringWithFormat:@"%@%@",txt_CountryCode.text,txt_PhoneNo.text] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        Str = [Str stringByReplacingOccurrencesOfString:@"(" withString:@""];
        Str = [Str stringByReplacingOccurrencesOfString:@")" withString:@""];
        Str = [Str stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",Str,@"partner_phone_no",nil];
        
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
            if([[jsonResponse objectForKey:@"user_exists"] boolValue] == 0)
            {
                [self sendInAppSMS];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request sent to partner"])
            {
//              [[self navigationController] setNavigationBarHidden:YES animated:NO];
//              [self performSelector:@selector(tempAction) withObject:self afterDelay:0.1];
//
                if([isFromMenu isEqualToString:@"true"])
                {
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    //[controllers addObject:profile_other];
                    navigationController.viewControllers = controllers;
                }
                
                else
                {
                    UIViewController *first = [story instantiateViewControllerWithIdentifier:@"CurrentClickersViewController"];
                    [self.navigationController pushViewController:first animated:YES];
                }
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request has already been made to the user"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Request has already been made to the user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Request has already been made to the user."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

                
                if([isFromMenu isEqualToString:@"true"])
                {
                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                    
                    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                    while (controllers.count>1) {
                        [controllers removeLastObject];
                    }
                    //[controllers addObject:profile_other];
                    navigationController.viewControllers = controllers;
                }
                
                else
                {
                    UIViewController *first = [story instantiateViewControllerWithIdentifier:@"CurrentClickersViewController"];
                    [self.navigationController pushViewController:first animated:YES];
                }
            }
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is not valid"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

            }
            else if ([[jsonResponse objectForKey:@"message"] isEqualToString:@"Phone no. not registered yet."])
            {
                [self sendInAppSMS];
            }
        }
        else if([request responseStatusCode] == 400)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Phone no. cannot be blank" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Phone no. cannot be blank"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
        if([request responseStatusCode] == 500)
        {
//            if([[jsonResponse objectForKey:@"user_exists"] boolValue] == 0)
//            {
//                [self sendInAppSMS];
//                return;
//            }
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
         
            if([isFromMenu isEqualToString:@"true"])
            {
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                //[controllers addObject:profile_other];
                navigationController.viewControllers = controllers;
            }
            else
            {
                UIViewController *first = [story instantiateViewControllerWithIdentifier:@"CurrentClickersViewController"];
                [self.navigationController pushViewController:first animated:YES];
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
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void)clk_Btn:(id)sender
{
    UIButton *clk_Btn=(UIButton *)sender;
    
    if (clk_Btn.tag == 1)
    {
        NSLog(@"Btn clicked: Edit");
    }
    else if (clk_Btn.tag == 2)
    {
        [txt_PhoneNo resignFirstResponder];
        [txt_CountryCode resignFirstResponder];
        NSLog(@"Btn clicked: Send Invite");
        //[self.navigationController popViewControllerAnimated:YES];
        if([txt_PhoneNo.text length] >= 5)
        {
            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
            [activity show];
            [self performSelector:@selector(CallRelationShipWebservice) withObject:self afterDelay:0.1];
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"The phone number your have entered is invalid. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"The phone number your have entered is invalid. Please try again"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
    }
    
    else if (clk_Btn.tag == 3)
    {
        NSLog(@"Btn clicked: Back");
        if([isFromMenu isEqualToString:@"true"])
        {
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            [navigationController popViewControllerAnimated:YES];
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
    }
    else if (clk_Btn.tag == 4)
    {
//        if (![self checkValidation:nil])
//            return;
        
        NSLog(@"Btn clicked: Done");
    }
    else if (clk_Btn.tag == 5)
    {
        NSLog(@"Btn clicked: Skip");
        
//        UIViewController *addyourdetails = [story instantiateViewControllerWithIdentifier:@"AddYourDetails"];
//        [self.navigationController pushViewController:addyourdetails animated:YES];
    }
    else if (clk_Btn.tag == 4)
    {
//        NSLog(@"Btn clicked: Try Onother");
//        txt_email.text=@"";
//        lbl_Info.hidden=YES;
    }
    else if (clk_Btn.tag == 5)
    {
//        NSLog(@"Btn clicked: Forgot Password");
    }
}

- (profile_owner *)demoController {
    return [[profile_owner alloc] initWithNibName:Nil bundle:nil];
}

- (UINavigationController *)navigationControllers {
    UINavigationController *nv = [[UINavigationController alloc]
                                  initWithRootViewController:[self demoController]];
    nv.navigationBarHidden = YES;
    return nv;
}

-(MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


-(void)callSlideMenu
{
    LeftViewController *leftMenuViewController = [[LeftViewController alloc] init];
    NotificationsViewController *rightMenuViewController = [[NotificationsViewController alloc] init];
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:[self navigationControllers]
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:rightMenuViewController];
    
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).slideContainer=container;
    
    [self presentViewController:container animated:YES completion:^{
        
    }];
}

-(void)tempAction
{
    id firstcontroller= [self.navigationController.viewControllers objectAtIndex:0];
    if([firstcontroller isKindOfClass:[profile_owner class]])
    {
        // do somthing
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
    UIViewController *ObjInvitationViewController = [story instantiateViewControllerWithIdentifier:@"InvitationViewController"];
    [self.navigationController pushViewController:ObjInvitationViewController animated:YES];
    
   // NSLog(@" nav controllers : %@",self.navigationController.viewControllers.description);
    }
}

#pragma mark Text Field Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  
 
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == txt_PhoneNo)
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
            [GetClickin setBackgroundImage:[UIImage imageNamed:@"get-click.png"] forState:UIControlStateNormal];
            GetClickin.enabled = NO;
            
        }
        else
        {
            [GetClickin setBackgroundImage:[UIImage imageNamed:@"get-click.png"] forState:UIControlStateNormal];
            GetClickin.enabled = YES;
        }
    }
    return YES;
}

@end
