//
//  AddYourDetails.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 16/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "AddYourDetails.h"
//#import "DemoImageEditor.h"
#import "SendInvite.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "Base64.h"
#import "RegisterYourEmail.h"





@interface AddYourDetails ()

//@property(nonatomic,retain) DemoImageEditor *imageEditor;
//@property(nonatomic,retain) ALAssetsLibrary *library;
@property (strong, nonatomic) UIImagePickerController *imgPicker;
//@property (strong, nonatomic) XWPhotoEditorViewController *photoEditor;

@end

@implementation AddYourDetails

AppDelegate *appDelegate;

//@synthesize library = _library;
//@synthesize imageEditor = _imageEditor;
@synthesize imgPicker = _imgPicker;



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
    
    _imgPicker = [[UIImagePickerController alloc] init];
    //_library = [[ALAssetsLibrary alloc] init];
    
    
    
    str_Gender = @"";
    arrMonth = [NSArray arrayWithObjects:@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC",nil];
    //----FBSession closed here----
    [FBSession.activeSession closeAndClearTokenInformation];
    
    //---UIimage View
    UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    compScreen.image=[UIImage imageNamed:@"640x1136a.png"];
    
    if (!IS_IPHONE_5)
    {
        compScreen.image=[UIImage imageNamed:@"640X960-1.png"];
    }
    
    [self.view addSubview:compScreen];
    
    //----Scroll View Implementation
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height-130-56)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(320, 700-25);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];

    //---grab facebook details box----
    UIImageView *FBDetailsimgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 270.5, 126)];
    FBDetailsimgView.image = [UIImage imageNamed:@"5d_03.png"];//5d_03-1.png
    
    //FBDetailsimgView.contentMode = UIViewContentModeCenter;
    
    [scroll addSubview: FBDetailsimgView];
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
        
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
        
        }
        else
        {
        
        }
    }

    UIImageView *PersonalDetailsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 150, 270.5, 455.5)];
    PersonalDetailsImgView.image = [UIImage imageNamed:@"5d_03-1.png"];
    [scroll addSubview:PersonalDetailsImgView];
    
    //---UIButton btn_PicFromGallery---
    
    btn_PicFromGallery = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_PicFromGallery.tag=1;
    [btn_PicFromGallery addTarget:self
               action:@selector(clk_btn:)
     forControlEvents:UIControlEventTouchDown];
    [btn_PicFromGallery setBackgroundImage:[UIImage imageNamed:@"gallery-icon.png"] forState:UIControlStateNormal];
    btn_PicFromGallery.frame = CGRectMake(57, 161, 87, 33);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_PicFromGallery.frame = CGRectMake(57, 205, 87, 33);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_PicFromGallery.frame = CGRectMake(57, 197, 87, 33);
        
        else
            btn_PicFromGallery.frame = CGRectMake(57, 154, 87, 33);
    }
    //[scroll addSubview:btn_PicFromGallery];
    
    
    //---UIButton btn_PicFromCamera---
    
    btn_PicFromCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_PicFromCamera.tag=2;
    [btn_PicFromCamera addTarget:self
                           action:@selector(clk_btn:)
                 forControlEvents:UIControlEventTouchDown];
    [btn_PicFromCamera setBackgroundImage:[UIImage imageNamed:@"take-icon.png"] forState:UIControlStateNormal];
    btn_PicFromCamera.frame = CGRectMake(57, 208, 87, 33);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_PicFromCamera.frame = CGRectMake(57, 252, 87, 33);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_PicFromCamera.frame = CGRectMake(57, 243, 87, 33);
        
        else
            btn_PicFromCamera.frame = CGRectMake(57, 199, 87, 33);
    }
//    [scroll addSubview:btn_PicFromCamera];
    
  
    //------------------------------
    //---UIButton Gender Buttons---
    
    btn_Girl = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Girl.tag=3;
    [btn_Girl addTarget:self
                          action:@selector(clk_btn:)
                forControlEvents:UIControlEventTouchDown];
    [btn_Girl setBackgroundImage:[UIImage imageNamed:@"girl-button.png"] forState:UIControlStateNormal];
    btn_Girl.frame = CGRectMake(165, 325, 121, 33.5);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_Girl.frame = CGRectMake(165, 325, 121, 33.5);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_Girl.frame = CGRectMake(165, 325, 121, 33.5);
        
        else
            btn_Girl.frame = CGRectMake(165, 325, 121, 33.5);
    }
    [scroll addSubview:btn_Girl];
    
    
    btn_Guy = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Guy.tag=4;
    [btn_Guy addTarget:self
                          action:@selector(clk_btn:)
                forControlEvents:UIControlEventTouchDown];
    [btn_Guy setBackgroundImage:[UIImage imageNamed:@"guy-button.png"] forState:UIControlStateNormal];
    btn_Guy.frame = CGRectMake(42.5-8, 325, 121, 33.5);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_Guy.frame = CGRectMake(42.5-8, 325, 121, 33.5);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_Guy.frame = CGRectMake(42.5-8, 325, 121, 33.5);
        
        else
            btn_Guy.frame = CGRectMake(42.5-8, 325, 121, 33.5);
    }
    [scroll addSubview:btn_Guy];
    
    //-----------------------
    //---UIButton Facebook---
    
    btn_Facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Facebook.tag=5;
    [btn_Facebook addTarget:self
                action:@selector(clk_btn:)
      forControlEvents:UIControlEventTouchDown];
   // [btn_Facebook setBackgroundImage:[UIImage imageNamed:@"grabbutton.png"] forState:UIControlStateNormal];
    btn_Facebook.frame = CGRectMake(40, 45-20-7, 226+16, 35);
   // btn_Facebook.backgroundColor = [UIColor redColor];
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
            btn_Facebook.frame = CGRectMake(40, 45-20-7, 226+16, 45);
    }
    else
    {
        if (IS_IPHONE_5)
            btn_Facebook.frame = CGRectMake(40, 30-20-7, 226+16, 35);
        
        else
            btn_Facebook.frame = CGRectMake(40, 77-20-7, 226+16, 35);
    }
    [scroll addSubview:btn_Facebook];
    
    //---Bottom Buttons---
    btn_Back = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Back.tag=6;
    [btn_Back addTarget:self
                     action:@selector(clk_btn:)
           forControlEvents:UIControlEventTouchDown];
    //[btn_Back setBackgroundColor:[UIColor redColor]];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"backbtn.png"] forState:UIControlStateNormal];
    [btn_Back setBackgroundImage:[UIImage imageNamed:@"backbtngrey.png"] forState:UIControlStateHighlighted];
    btn_Back.frame = CGRectMake(100, self.view.frame.size.height-45, 60, 45);
 //   [scroll addSubview:btn_Back];
    
    btn_Next = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Next.tag=7;
    [btn_Next addTarget:self
                     action:@selector(clk_btn:)
           forControlEvents:UIControlEventTouchDown];
    //[btn_Next setBackgroundColor:[UIColor yellowColor]];
    [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
   // [btn_Next setBackgroundImage:[UIImage imageNamed:@"nextbtngrey.png"] forState:UIControlStateHighlighted];
    btn_Next.frame = CGRectMake(25, self.view.frame.size.height-56, 270.5, 56);
    [self.view addSubview:btn_Next];
    
    DOBbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    DOBbutton.frame = CGRectMake(42.5-8, 535.0-7, 253.0, 66.5);
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            DOBbutton.frame = CGRectMake(42.5-8, 535.0-7, 253.0, 66.5);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            DOBbutton.frame = CGRectMake(42.5-8, 523.0, 253.0, 66.5);
        }
        else
        {
            DOBbutton.frame = CGRectMake(42.5-8, 580.0-7, 253.0, 66.5);
        }
    }
    
    [DOBbutton setBackgroundImage:[UIImage imageNamed:@"sign Up 18th.png"] forState:UIControlStateNormal];
    DOBbutton.clipsToBounds = YES;
    [DOBbutton addTarget:self action:@selector(AddingPickerView) forControlEvents:UIControlEventTouchDown];
    
    datePickerlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 250, 40)];
    datePickerlabel.backgroundColor = [UIColor clearColor];
    datePickerlabel.textAlignment = NSTextAlignmentLeft;
    datePickerlabel.textColor=[UIColor darkGrayColor];
    datePickerlabel.numberOfLines=1;
    datePickerlabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];

   // datePickerlabel.lineBreakMode=UILineBreakModeWordWrap;
    datePickerlabel.text = @"       01                      JAN                    1996";
    [DOBbutton addSubview:datePickerlabel];
    
    [scroll addSubview:DOBbutton];
    
    CGRect pickerFrame;
    pickerFrame = CGRectMake(0,288,0,0);
    ObjToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,245, 320, 50)];
    //---ToolBar in which we add our PikerVIew and its Bar
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            ObjToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 312, 320, 50)];
            pickerFrame = CGRectMake(0,355,0,0);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            ObjToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 290, 320, 50)];
            pickerFrame = CGRectMake(0,332,0,0);
        }
        else
        {
            ObjToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 203, 320, 50)];
            pickerFrame = CGRectMake(0,245,0,0);
        }
    }
    
    [ObjToolBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.view addSubview:ObjToolBar];
    [ObjToolBar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *btn_Done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePicker)];
    NSArray *itemsArray = [NSArray arrayWithObjects:flexButton,btn_Done, nil];
    [ObjToolBar setItems:itemsArray];
    
    
    DatePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    DatePicker.backgroundColor = [UIColor whiteColor];
    DatePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    DatePicker.locale = locale;
    DatePicker.calendar = [locale objectForKey:NSLocaleCalendar];
    [DatePicker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:DatePicker];
    
    
    [DatePicker setHidden:YES];
  	[ObjToolBar setHidden:YES];
    
    Gallerybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    Gallerybutton.frame = CGRectMake(57.0+60+4, 244-85, 71.0, 71.0);
   // Gallerybutton.backgroundColor = [UIColor redColor];
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            Gallerybutton.frame = CGRectMake(57.0+60+4, 205.0-46, 71.0, 71.0);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            Gallerybutton.frame = CGRectMake(57.0+60+4, 197.0-46, 71.0, 71.0);
        }
        else
        {
            Gallerybutton.frame = CGRectMake(57.0+60+4, 155.0-46, 71.0, 71.0);
        }
    }
    
    Gallerybutton.clipsToBounds = YES;
    [Gallerybutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
    [scroll addSubview:Gallerybutton];
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    FirstNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(34.5,220+15,250,40)];
    [FirstNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [FirstNameTxtField setLeftView:spacerView];
    [FirstNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [FirstNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    FirstNameTxtField.delegate = self;
    FirstNameTxtField.textColor = [UIColor darkGrayColor];
    FirstNameTxtField.backgroundColor=[UIColor whiteColor];
    FirstNameTxtField.layer.cornerRadius=1.0f;
    FirstNameTxtField.layer.masksToBounds=YES;
    FirstNameTxtField.layer.borderColor=[[UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0] CGColor];
    FirstNameTxtField.layer.borderWidth= 1.0f;
    FirstNameTxtField.placeholder = @"First Name *";
    FirstNameTxtField.returnKeyType = UIReturnKeyNext;
    FirstNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [scroll addSubview:FirstNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    LastNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(34.5,265+15,250,40)];
    [LastNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [LastNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    LastNameTxtField.delegate = self;
    LastNameTxtField.textColor = [UIColor darkGrayColor];
    LastNameTxtField.backgroundColor=[UIColor whiteColor];
    LastNameTxtField.placeholder = @"Last Name *";
    LastNameTxtField.layer.cornerRadius=1.0f;
    LastNameTxtField.layer.masksToBounds=YES;
    LastNameTxtField.layer.borderColor=[[UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0] CGColor];
    LastNameTxtField.layer.borderWidth= 1.0f;
    LastNameTxtField.returnKeyType = UIReturnKeyNext;
    LastNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [LastNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [LastNameTxtField setLeftView:spacerView];
    [scroll addSubview:LastNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    CityNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(34.5,348.5+15,250,40)];
    [CityNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [CityNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    CityNameTxtField.delegate = self;
    CityNameTxtField.textColor = [UIColor darkGrayColor];
    CityNameTxtField.backgroundColor=[UIColor whiteColor];
    CityNameTxtField.placeholder = @"City Name";
    CityNameTxtField.layer.cornerRadius=1.0f;
    CityNameTxtField.layer.masksToBounds=YES;
    CityNameTxtField.layer.borderColor=[[UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0] CGColor];
    CityNameTxtField.layer.borderWidth= 1.0f;
    CityNameTxtField.returnKeyType = UIReturnKeyNext;
    CityNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [CityNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [CityNameTxtField setLeftView:spacerView];
    [scroll addSubview:CityNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    CountryNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(34.5,348.5+45+15,250,40)];
    [CountryNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [CountryNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    CountryNameTxtField.delegate = self;
    CountryNameTxtField.textColor = [UIColor darkGrayColor];
    CountryNameTxtField.backgroundColor=[UIColor whiteColor];
    CountryNameTxtField.placeholder = @"Country Name";
    CountryNameTxtField.layer.cornerRadius=1.0f;
    CountryNameTxtField.layer.masksToBounds=YES;
    CountryNameTxtField.layer.borderColor=[[UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0] CGColor];
    CountryNameTxtField.layer.borderWidth= 1.0f;
    CountryNameTxtField.returnKeyType = UIReturnKeyNext;
    CountryNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [CountryNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [CountryNameTxtField setLeftView:spacerView];
    [scroll addSubview:CountryNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    EmailTxtField = [[UITextField alloc] initWithFrame:CGRectMake(34.5,348.5+45+45+15,250,40)];
    [EmailTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [EmailTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    EmailTxtField.delegate = self;
    EmailTxtField.textColor = [UIColor darkGrayColor];
    EmailTxtField.backgroundColor=[UIColor whiteColor];
    EmailTxtField.placeholder = @"Email *";
    EmailTxtField.layer.cornerRadius=1.0f;
    EmailTxtField.layer.masksToBounds=YES;
    EmailTxtField.layer.borderColor=[[UIColor colorWithRed:(244.0/255.0) green:(244.0/255.0) blue:(244.0/255.0) alpha:1.0] CGColor];
    EmailTxtField.layer.borderWidth= 1.0f;
    [EmailTxtField setKeyboardType:UIKeyboardTypeEmailAddress];
    EmailTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
    [EmailTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [EmailTxtField setLeftView:spacerView];
    EmailTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scroll addSubview:EmailTxtField];
    spacerView = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:tap];
  
    
     [self.view bringSubviewToFront:self.tintView];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if([FirstNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([LastNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];//buttonNextActivated.png
    }
    
    [FirstNameTxtField resignFirstResponder];
    [LastNameTxtField resignFirstResponder];
    [CityNameTxtField resignFirstResponder];
    [CountryNameTxtField resignFirstResponder];
    [EmailTxtField resignFirstResponder];
    [DatePicker setHidden:YES];
  	[ObjToolBar setHidden:YES];
}

#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == FirstNameTxtField)
    {
        [FirstNameTxtField resignFirstResponder];
        [LastNameTxtField becomeFirstResponder];
    }
    else if (textField == LastNameTxtField)
    {
        [LastNameTxtField resignFirstResponder];
        [CityNameTxtField becomeFirstResponder];
    }
    else if (textField == CityNameTxtField)
    {
        [CityNameTxtField resignFirstResponder];
        [CountryNameTxtField becomeFirstResponder];
    }
    else if (textField == CountryNameTxtField)
    {
        [CountryNameTxtField resignFirstResponder];
        [EmailTxtField becomeFirstResponder];
    }
    else if (textField == EmailTxtField)
    {
        [EmailTxtField resignFirstResponder];
        [CountryNameTxtField resignFirstResponder];
        [CityNameTxtField resignFirstResponder];
        [FirstNameTxtField resignFirstResponder];
        [LastNameTxtField resignFirstResponder];
        
        if([FirstNameTxtField.text isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if([LastNameTxtField.text isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if([CityNameTxtField.text isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if([CountryNameTxtField.text isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if([EmailTxtField.text isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if([str_Gender isEqualToString:@""])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if ([StrEncoded length]==0)
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else if(![self validEmail:EmailTxtField.text])
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn_Next setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];
        }
    }
  
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == FirstNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,145) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,60) animated:YES];
    }
    else if (textField == LastNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,110+85) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,110) animated:YES];
    }
    else if (textField == CityNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,190+85) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,190) animated:YES];
    }
    else if (textField == CountryNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,240+85) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,240) animated:YES];
    }
    else if (textField == EmailTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,280+85) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,285) animated:YES];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Selector Functions

-(BOOL)validEmail:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

-(void)AddingPickerView
{
    [DatePicker setHidden:NO];
  	[ObjToolBar setHidden:NO];
}

-(void)hidePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:pickerSelectedDate];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *output = [formatter stringFromDate:date];
    NSLog(@"output : %@",output);
    
    if (![self dateComparision:output])
    {
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"OOPS!"
                                                                        description:@"Too young to be clickin' \n Come back later... "
                                                                      okButtonTitle:@"Ok"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS!" message:@"Too young to be clickin' \n Come back later... " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        return ;
    }
    [DatePicker setHidden:YES];
  	[ObjToolBar setHidden:YES];
    
    
    
    if([FirstNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([LastNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];//buttonNextActivated.png
    }
}

- (void)pickerChanged:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSLog(@"value: %@",[sender date]);
    
    pickerSelectedDate=[NSString stringWithFormat:@"%@",[sender date]];
    
    NSString *SUBStringYear = [[NSString stringWithFormat:@"%@",[sender date]] substringToIndex:4];
    
    NSString *SUBStringMonth = [[NSString stringWithFormat:@"%@",[sender date]] substringWithRange:NSMakeRange(5,2)];
    NSLog(@"SUBStringMonth : %@",SUBStringMonth);
    
    NSLog(@"%@",[arrMonth objectAtIndex:[SUBStringMonth intValue]-1]);
    
    NSString *SUBStringDate = [[NSString stringWithFormat:@"%@",[sender date]] substringWithRange:NSMakeRange(8,2)];
    
    [prefs setObject:[NSString stringWithFormat:@"%@-%@-%@",[arrMonth objectAtIndex:[SUBStringMonth intValue]-1],SUBStringDate,SUBStringYear] forKey:@"BDay"];
    
    datePickerlabel.text = [NSString stringWithFormat:@"       %@                      %@                    %@",SUBStringDate,[arrMonth objectAtIndex:[SUBStringMonth intValue]-1],SUBStringYear];
}

/*
 -(void)CaptureFromCamara
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
//    picker = nil;
    if(!self.library)
    {
        self.library = [[ALAssetsLibrary alloc] init] ;
    }
    if(!self.imageEditor)
    {
        self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil] ;
    }
    self.imageEditor.checkBounds = NO;
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled)
    {
        if(!canceled)
        {
            UIImage *compressedImage = [self scaleImage:editedImage toSize:CGSizeMake(320.0,480.0)];
            
            tempProfilePic = compressedImage;
            
            NSData *data = UIImageJPEGRepresentation(compressedImage, 1.0f);
            [Base64 initialize];
            StrEncoded = [Base64 encode:data];
            
            // NSLog(@"%@",StrEncoded);
            
            UIButton *Camerabutton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *EditCamerabutton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            EditCamerabutton.frame = CGRectMake(128.0, 227.0, 33.0, 30.5);
            Camerabutton.frame = CGRectMake(57.0, 162.0, 87.0, 87.0);
            
            
            if (IS_IOS_7)
            {
                if (IS_IPHONE_5)
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 267.0, 31.0, 30.5);
                    Camerabutton.frame = CGRectMake(57.0, 205.0, 87.0, 87.0);
                }
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 260.0, 31.0, 30.5);
                    Camerabutton.frame = CGRectMake(57.0, 197.0, 87.0, 85.0);
                }
                else
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 220.0, 31.0, 30.5);
                    Camerabutton.frame = CGRectMake(57.0, 155.0, 87.0, 85.0);
                }
            }
            
            [Camerabutton setBackgroundImage:editedImage forState:UIControlStateNormal];
            Camerabutton.clipsToBounds = YES;
            [Camerabutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
            [scroll addSubview:Camerabutton];
            
            [EditCamerabutton setBackgroundImage:[UIImage imageNamed:@"dragicon.png"] forState:UIControlStateNormal];
            EditCamerabutton.clipsToBounds = YES;
            [EditCamerabutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
            [scroll addSubview:EditCamerabutton];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    picker = nil;
}*/

/*
-(void)CaptureFromGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    //..     [picker release];
    self.library = [[ALAssetsLibrary alloc] init] ;
    self.imageEditor = [[DemoImageEditor alloc] initWithNibName:@"DemoImageEditor" bundle:nil] ;
    self.imageEditor.checkBounds = NO;
    
    self.imageEditor.doneCallback = ^(UIImage *editedImage, BOOL canceled){
        if(!canceled)
        {
            //  UIImageWriteToSavedPhotosAlbum(editedImage, nil, nil, nil);
            
            
            UIImage *compressedImage = [self scaleImage:editedImage toSize:CGSizeMake(320.0,480.0)];
            
            tempProfilePic = compressedImage;
            
            NSData *data = UIImageJPEGRepresentation(compressedImage, 1.0f);
            
            [Base64 initialize];
            StrEncoded = [Base64 encode:data];
            
            //   NSLog(@"%@",StrEncoded);
            
            UIButton *Gallerybutton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *EditCamerabutton = [UIButton buttonWithType:UIButtonTypeCustom];
            EditCamerabutton.frame = CGRectMake(128.0, 227.0, 33.0, 30.5);
            Gallerybutton.frame = CGRectMake(57.0, 162.0, 87.0, 87.0);
            
            
            if (IS_IOS_7)
            {
                if (IS_IPHONE_5)
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 267.0, 31.0, 30.5);
                    Gallerybutton.frame = CGRectMake(57.0, 205.0, 87.0, 87.0);
                }
            }
            else
            {
                if (IS_IPHONE_5)
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 260.0, 31.0, 30.5);
                    Gallerybutton.frame = CGRectMake(57.0, 197.0, 87.0, 85.0);
                }
                else
                {
                    EditCamerabutton.frame = CGRectMake(130.0, 220.0, 31.0, 30.5);
                    Gallerybutton.frame = CGRectMake(57.0, 155.0, 87.0, 85.0);
                }
            }
            
            [Gallerybutton setBackgroundImage:editedImage forState:UIControlStateNormal];
            Gallerybutton.clipsToBounds = YES;
            [Gallerybutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
            [scroll addSubview:Gallerybutton];
            
            [EditCamerabutton setBackgroundImage:[UIImage imageNamed:@"dragicon.png"] forState:UIControlStateNormal];
            EditCamerabutton.clipsToBounds = YES;
            [EditCamerabutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
            [scroll addSubview:EditCamerabutton];
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    picker = nil;
}*/

-(void)AlertForSeLectionTheImageCapturing
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Add your selfie" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"TAKE A PICTURE",@"FROM YOUR GALLERY",nil];
    [alert show];
    alert = nil;
    
//    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
//                                                                    description:@"Add your selfie"
//                                                                  okButtonTitle:@"TAKE A PICTURE",@"FROM YOUR GALLERY",
//                                                              cancelButtonTitle:@"Cancel"];
//    alertView.delegate = nil;
//    [alertView show];
}

-(void)clk_btn:(id)sender
{
    UIButton *clk_Btn=(UIButton *)sender;
    
    if (clk_Btn.tag == 1)
    {
        NSLog(@"Btn clicked: Gallery");
        //[self CaptureFromGallery];
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if (clk_Btn.tag == 2)
    {
        NSLog(@"Btn clicked: Camera");
        //[self CaptureFromCamara];
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
    else if (clk_Btn.tag == 3)
    {
        NSLog(@"Btn clicked: Girl");
        
        [btn_Girl setBackgroundImage:[UIImage imageNamed:@"girl-button-1.png"] forState:UIControlStateNormal];//pink
        [btn_Guy setBackgroundImage:[UIImage imageNamed:@"guy-button.png"] forState:UIControlStateNormal];// gray
        str_Gender=@"girl";
        
    }
    
    else if (clk_Btn.tag == 4)
    {
        NSLog(@"Btn clicked: Guy");

        [btn_Guy setBackgroundImage:[UIImage imageNamed:@"guy-button-2.png"] forState:UIControlStateNormal];
        [btn_Girl setBackgroundImage:[UIImage imageNamed:@"girl-button.png"] forState:UIControlStateNormal];
        str_Gender=@"guy";
    }
    
    else if (clk_Btn.tag == 5)
    {

        NSLog(@"Btn clicked: Facebook");
        [self openSession];
    }
    
    else if (clk_Btn.tag == 6)
    {
        NSLog(@"Btn clicked: Back");
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (clk_Btn.tag == 7)
    {
        NSLog(@"Btn clicked: Next");
        if([FirstNameTxtField.text isEqualToString:@""])
        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your First Name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Please enter your First Name"
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            return;
        }
        if([LastNameTxtField.text isEqualToString:@""])
        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your Last Name" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Please enter your Last Name"
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            return;
        }
//        if([CityNameTxtField.text isEqualToString:@""])
//        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your city" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
//        if([CountryNameTxtField.text isEqualToString:@""])
//        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your country" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        if([EmailTxtField.text isEqualToString:@""])
        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your email address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Please enter your email address"
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            return;
        }
//        if([str_Gender isEqualToString:@""])
//        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please select your Gender" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter your Date of Birth" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Please enter your Date of Birth"
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            return;
        }
//        else if ([StrEncoded length]==0)
//        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please select your profile image." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//        }
        else if(![self validEmail:EmailTxtField.text])
        {
//            UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"Please enter a valid email address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Please enter a valid email address"
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            return;
        }
        else if (![self isUnderAge])
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS!" message:@"Too young to be clickin' \n Come back later... " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                            description:@"Too young to be clickin' \n Come back later... "
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            return ;
        }
        else
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:EmailTxtField.text forKey:@"EmailSaved"];

            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
            [activity show];
            
            [self performSelector:@selector(updateprofileWebservice) withObject:nil afterDelay:0.1];
        }
    }
}


-(BOOL)isUnderAge
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    NSDate *date = [formatter dateFromString:pickerSelectedDate];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *output = [formatter stringFromDate:date];
    NSLog(@"output : %@",output);
    
    if (![self dateComparision:output])
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS!" message:@"Too young to be clickin' \n Come back later... " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        return NO;
    }
    return YES;
}

#pragma mark Custom Functions

-(void)updateprofileWebservice
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/updateprofile"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        [prefs setObject:datePickerlabel.text forKey:@"DateOfBirth"];
        [prefs setObject:str_Gender forKey:@"str_Gender"];
        
        NSError *error;

       [prefs setObject:[NSString stringWithFormat:@"%@ %@",FirstNameTxtField.text,LastNameTxtField.text] forKey:@"user_name"];
        
        if([StrEncoded length] == 0)
        {
            StrEncoded = @"";
        }
        
        if([str_Gender length] == 0 && [StrEncoded length] == 0)
        {
            str_Gender = @"";
            NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"default male avatar.jpg"], 1.0f);
            [Base64 initialize];
            StrEncoded = [Base64 encode:data];
            data=nil;
        }
        else
        {
            if([str_Gender isEqualToString:@"guy"] && [StrEncoded length] == 0)
            {
                NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"default male avatar.jpg"], 1.0f);
                [Base64 initialize];
                StrEncoded = [Base64 encode:data];
                data=nil;
            }
            else if([str_Gender isEqualToString:@"girl"] && [StrEncoded length] == 0)
            {
                NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"default female avatar.jpg"], 1.0f);
                [Base64 initialize];
                StrEncoded = [Base64 encode:data];
                data=nil;
            }
        }
            
        
        if([CountryNameTxtField.text length] == 0)
        {
            CountryNameTxtField.text = @"";
        }
        if([CityNameTxtField.text length] == 0)
        {
            CityNameTxtField.text = @"";
        }

        
        
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:datePickerlabel.text,@"dob",StrEncoded,@"user_pic",[NSString stringWithFormat:@"%@",[prefs objectForKey:@"user_token"]],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",str_Gender,@"gender",CityNameTxtField.text,@"city",CountryNameTxtField.text,@"country",EmailTxtField.text,@"email",FirstNameTxtField.text,@"first_name",LastNameTxtField.text,@"last_name",[prefs stringForKey:@"fb_accesstoken"],@"fb_access_token",nil];
        
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
           
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Profile updated"])
            {
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:@"yes" forKey:@"IsAutoLogin"];
                
//                SendInvite *ObjSendInvite = [story instantiateViewControllerWithIdentifier:@"SendInvite"];
//                ObjSendInvite.ProfileImg = tempProfilePic;
//                [self.navigationController pushViewController:ObjSendInvite animated:YES];
                
                RegisterYourEmail *registeryouremail = [story instantiateViewControllerWithIdentifier:@"RegisterYourEmail"];
                [self.navigationController pushViewController:registeryouremail animated:YES];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                description:@"Email already exists"
                                                                              okButtonTitle:@"Ok"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                

            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in saving the image"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                description:@"There was a problem in saving the image."
                                                                              okButtonTitle:@"Ok"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        else if([request responseStatusCode] == 500)
        {
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                description:@"Email already exists"
                                                                              okButtonTitle:@"Ok"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
            }
            else
            {
                NSError *error = nil;
                NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
                if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in saving the image"])
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                    description:@"There was a problem in saving the image."
                                                                                  okButtonTitle:@"Ok"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
                }
            }
        }
        else
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in saving the image"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                description:@"There was a problem in saving the image."
                                                                              okButtonTitle:@"Ok"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"Ok"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    
    [activity hide];
}


-(BOOL)dateComparision:(id)sender
{
//    NSDateFormatter* df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"MM/dd/yyyy"];
//    NSDate* d = [df dateFromString:@"2011-06-10 14:50:00 +0000"];
//    NSLog(@"%@", d);
    
    NSString *passedDate=(NSString *)sender;
    NSLog(@"DOB : %@",passedDate);
    
    NSDate *today = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [df stringFromDate:today];
    NSLog(@"Current Date : %@", dateString);
   
    NSDateFormatter* dfNew = [[NSDateFormatter alloc] init];
    [dfNew setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *fixedDate = [df dateFromString:dateString];
    NSDate *birthDate = [dfNew dateFromString:passedDate];
    NSLog(@"DOB String Date : %@", birthDate);
    
    NSTimeInterval fixedDateDiff = [fixedDate timeIntervalSinceNow];
    NSTimeInterval birthDateDiff = [birthDate timeIntervalSinceNow];
    NSTimeInterval dateDiff = (fixedDateDiff - birthDateDiff)/86400;
    NSLog(@"Days:%f",dateDiff);
    if (dateDiff > 6209 )
    {
        NSLog(@"Age: Valid User");
        return  TRUE;
    }
    else
    {
         NSLog(@"Age: InValid User");
        return  FALSE;
    }
    
    return TRUE;
}
#pragma mark UIAlertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //[self CaptureFromCamara];
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
    else if (buttonIndex == 2)
    {
        //[self CaptureFromGallery];
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}


#pragma mark -
#pragma mark UIPickerView Delegates

-(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/*
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset)
     {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        self.imageEditor.sourceImage = image;
        self.imageEditor.previewImage = preview;
        [self.imageEditor reset:NO];
        
        [picker pushViewController:self.imageEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get asset from library");
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    /*_photoEditor = [[XWPhotoEditorViewController alloc] initWithNibName:@"XWPhotoEditorViewController" bundle:nil];
    
    // set photo editor value
    _photoEditor.panEnabled = YES;
    _photoEditor.scaleEnabled = YES;
    _photoEditor.tapToResetEnabled = YES;
    _photoEditor.rotateEnabled = NO;
    _photoEditor.delegate = self;
    // crop window's value
    _photoEditor.cropSize = CGSizeMake(300, 300);*/
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //NSURL *assetURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    /*
    //testing code
    int imageWidth = (int) (image.size.width);
    
    CGRect rect;
    if (imageWidth > 1936)
        rect = CGRectMake(0.0, 0.0, 960 , 640);
    
    else
        rect = CGRectMake(0.0, 0.0, 640 , 960);
    
    UIImage *newimage=[self imageWithImage:image scaledToSize:rect.size];
    simpleImageEditorView = [[AGSimpleImageEditorView alloc] initWithImage:newimage];
    simpleImageEditorView.frame=CGRectMake(32, 20, 256, 256) ;
    [picker dismissViewControllerAnimated:YES completion:nil];
    cropView.backgroundColor=[UIColor whiteColor];
    [self.view bringSubviewToFront:cropView];
    [cropView addSubview:simpleImageEditorView];
    simpleImageEditorView.ratio = 2./1.;
    
    //testing code
    */
   
    /*[self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        self.photoEditor.sourceImage = image;
        //[self dismissViewControllerAnimated:YES completion:^{[self presentViewController:self.photoEditor animated:YES completion:nil];}];
        //[self presentViewController:self.photoEditor animated:YES completion:nil];
        [picker pushViewController:self.photoEditor animated:YES];
        [picker setNavigationBarHidden:YES animated:NO];
    } failureBlock:^(NSError *error) {
        NSLog(@"failed to get asset from library");
    }];
    */
    
    tempProfilePic = image;
    if(tempProfilePic.size.width>320 || tempProfilePic.size.height>480)
        tempProfilePic = [self scaleImage:tempProfilePic toSize:CGSizeMake(320, 480)];
    
    NSData *data = UIImageJPEGRepresentation(tempProfilePic, 0.1f);
    [Base64 initialize];
    StrEncoded = [Base64 encode:data];
    data=nil;
    
    if([FirstNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([LastNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];//buttonNextActivated.png
    }
    
    
 /*   if(Gallerybutton==nil)
    {
        Gallerybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        Gallerybutton.frame = CGRectMake(57.0+60+5, 162.0-46, 70.0, 70.0);
        
        if (IS_IOS_7)
        {
            if (IS_IPHONE_5)
            {
                Gallerybutton.frame = CGRectMake(57.0+60+5, 205.0-46, 70.0, 70.0);
            }
        }
        else
        {
            if (IS_IPHONE_5)
            {
                Gallerybutton.frame = CGRectMake(57.0+60+5, 197.0-46, 70.0, 70.0);
            }
            else
            {
                Gallerybutton.frame = CGRectMake(57.0+60+5, 155.0-46, 70.0, 70.0);
            }
        }
        
        [Gallerybutton setBackgroundImage:tempProfilePic forState:UIControlStateNormal];
        Gallerybutton.clipsToBounds = YES;
        [Gallerybutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
        [scroll addSubview:Gallerybutton];
    }
  */
    [Gallerybutton setBackgroundImage:tempProfilePic forState:UIControlStateNormal];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if([FirstNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([LastNameTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([datePickerlabel.text isEqualToString:@"       01                      JAN                    1996"])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_Next setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];//buttonNextActivated.png
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
-(void)finish:(UIImage *)image didCancel:(BOOL)cancel {
    if (!cancel) {
        // store this new picture in the library
        [_library
         writeImageToSavedPhotosAlbum:[image CGImage]
         orientation:(ALAssetOrientation)image.imageOrientation
         completionBlock:^(NSURL *assetURL, NSError *error){
             if (error) {
                 UIAlertView *alert =
                 [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles: nil];
                 [alert show];
             }
         }];
        
        tempProfilePic = image;
        
        NSData *data = UIImageJPEGRepresentation(tempProfilePic, 1.0f);
        [Base64 initialize];
        StrEncoded = [Base64 encode:data];
        data=nil;
        
        [Gallerybutton setBackgroundImage:tempProfilePic forState:UIControlStateNormal];
        [self.view bringSubviewToFront:Gallerybutton];
        [self.view bringSubviewToFront:EditCamerabutton];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    _photoEditor=nil;
}
*/
-(void)showImagePicker:(UIImagePickerControllerSourceType) sourceType {
    
    @try {
        _imgPicker.sourceType = sourceType;
        [_imgPicker setAllowsEditing:YES];
        _imgPicker.delegate = self;
        if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            _imgPicker.showsCameraControls = YES;
            _imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [self presentViewController:_imgPicker animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
    }
    
}

#pragma mark - Facebook Login

- (void)openSession
{
    //clear old tokens
    [FBSession.activeSession closeAndClearTokenInformation];
    
    NSArray *permissions =
    [NSArray arrayWithObjects:@"user_photos",@"user_about_me",@"user_birthday",@"user_hometown",@"user_location",@"basic_info",@"email",@"user_videos",@"user_checkins",@"friends_checkins",@"user_status",@"read_friendlists",@"friends_photos", nil];
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error)
    {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
        {
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            NSLog(@"accessToken= %@",session.accessTokenData.accessToken);
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            
            FBSession.activeSession = session;
            
            [self getuserID];  // get user email
            
            
        }
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_accesstoken"];
            
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
        }
            break;
            
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
            // [self.navController popToRootViewControllerAnimated:NO];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_accesstoken"];
            
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
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
                                                                          okButtonTitle:@"Ok"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            
        }
            
        break;
        default:
            break;
    }
    
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:error.localizedDescription
                                                                      okButtonTitle:@"Ok"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
    }
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
             
             NSLog(@"Birthday is : %@",user.birthday);
            // NSLog(@"Email is : %@",user.email);
            // NSLog(@"Gender is : %@",user.gender);
             NSLog(@"Gender is : %@",user.username);
             
             
             NSDateFormatter* myFormatter = [[NSDateFormatter alloc] init];
             [myFormatter setDateFormat:@"MM/dd/yyyy"];//@"yyyy-MM-dd HH:mm:ss Z" //@"MM/dd/yyyy"
             NSDate* myDate = [myFormatter dateFromString:user.birthday];
             
             [myFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
              myDate = [myFormatter dateFromString:[NSString stringWithFormat:@"%@",myDate]];

             NSLog(@"%@", myDate);
             pickerSelectedDate = [myFormatter stringFromDate:myDate];
             
             NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
             [prefs setObject:user.username forKey:@"UName"];
             [prefs setObject:user.birthday forKey:@"BDay"];
             
             str_FBBirthday=user.birthday;
             //str_FBEmail=user.email;
             //str_Gender=user.gender;
             
             if (![self dateComparision:str_FBBirthday])
             {
//                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Clickin'" message:@"You are not qualified to use this App" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
//                 [alert show];
//                 alert = nil;
                 
                 MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Clickin'"
                                                                                 description:@"You are not qualified to use this App"
                                                                               okButtonTitle:@"Ok"];
                 alertView.delegate = nil;
                 [alertView show];
                 alertView = nil;
                 
                 return ;
             }
             
             NSString* m = [str_FBBirthday substringToIndex:2];
             NSString* d = [[str_FBBirthday substringFromIndex:3] substringToIndex:2];
             NSString* y = [[str_FBBirthday substringFromIndex:6] substringToIndex:4];
             
             NSLog(@"%@, %@, %@ ", y, m, d);
             int value = [m intValue];
             datePickerlabel.text = [NSString stringWithFormat:@"       %@                      %@                    %@",d,[arrMonth objectAtIndex:value-1],y];
           //  NSLog(@"%@",datePickerlabel.text);
             
             NSString *gender =[user objectForKey:@"gender"];
             if ([gender isEqualToString:@"female"])
             {
                 [btn_Girl setBackgroundImage:[UIImage imageNamed:@"girl-button-1.png"] forState:UIControlStateNormal];
                 [btn_Guy setBackgroundImage:[UIImage imageNamed:@"guy-button.png"] forState:UIControlStateNormal];
                 str_Gender=@"girl";
             }
             
             else if ([gender isEqualToString:@"male"])
             {
                 [btn_Guy setBackgroundImage:[UIImage imageNamed:@"guy-button-2.png"] forState:UIControlStateNormal];
                 [btn_Girl setBackgroundImage:[UIImage imageNamed:@"girl-button.png"] forState:UIControlStateNormal];
                 str_Gender=@"guy";
             }
             
             // Initialize the profile picture
             self.profilePictureView = [[FBProfilePictureView alloc] init];
             self.profilePictureView.tag = 564;
             // Set the size
             
//             self.profilePictureView.frame = CGRectMake(57.0+60+4, 244-85, 71.0, 71.0);
//             if (IS_IOS_7)
//             {
//                 if (IS_IPHONE_5)
//                 {
//                     self.profilePictureView.frame = CGRectMake(57.0+60+4, 205.0-46, 71.0, 71.0);
//                 }
//             }
//             else
//             {
//                 if (IS_IPHONE_5)
//                 {
//                     self.profilePictureView.frame = CGRectMake(57.0, 188.0, 87.0, 85.0);
//                 }
//                 else
//                 {
//                     self.profilePictureView.frame = CGRectMake(57.0, 155.0, 87.0, 85.0);
//                 }
//             }
             self.profilePictureView.frame =  CGRectZero;
             // Show the profile picture for a user
             self.profilePictureView.profileID = user.id;
             //Add the profile picture view to the main view
//             [scroll addSubview:self.profilePictureView];
             
             FirstNameTxtField.text = user.first_name;
             LastNameTxtField.text = user.last_name;
             NSArray *tempArr = [NSArray arrayWithArray:[user.location.name componentsSeparatedByString:@","]];
             
             if([tempArr count] >= 1)
             CityNameTxtField.text = [tempArr objectAtIndex:0];

             if([tempArr count] > 1 )
             CountryNameTxtField.text = [tempArr objectAtIndex:1];
//           EmailTxtField.text = user.email;
             EmailTxtField.text = user[@"email"];
             
             UIImage *tempImg = [self imageWithView:self.profilePictureView];
             
             [Gallerybutton setBackgroundImage:tempImg forState:UIControlStateNormal];
             
             NSData *data = UIImageJPEGRepresentation(tempImg, 1.0f);
             [Base64 initialize];
             StrEncoded = [Base64 encode:data];
             data=nil;
             
             [self performSelector:@selector(getUserImageFromFBView) withObject:nil afterDelay:3.0];
         }
         else
         {
             NSLog(@"error");
         }
     }];
}

- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)getUserImageFromFBView
{
    UIImage *img = nil;
    
    for (NSObject *obj in [self.profilePictureView subviews]) {
        if ([obj isMemberOfClass:[UIImageView class]]) {
            UIImageView *objImg = (UIImageView *)obj;
            img = objImg.image;
            break;
        }
    }

    UIButton *ProfileBtn = [UIButton buttonWithType:UIButtonTypeCustom];

//    UIButton *EditCamerabutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    EditCamerabutton.frame = CGRectMake(128.0, 227.0, 33.0, 30.5);
    ProfileBtn.frame = CGRectMake(57.0+60+4, 244-85, 71.0, 71.0);
    
    
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
//          EditCamerabutton.frame = CGRectMake(130.0, 267.0, 31.0, 30.5);
            ProfileBtn.frame = CGRectMake(57.0+60+4, 205.0-46, 71.0, 71.0);
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
  //          EditCamerabutton.frame = CGRectMake(130.0, 260.0, 31.0, 30.5);
            ProfileBtn.frame = CGRectMake(57.0+60+4, 205.0-46, 71.0, 71.0);
        }
        else
        {
   //         EditCamerabutton.frame = CGRectMake(130.0, 220.0, 31.0, 30.5);
            ProfileBtn.frame = CGRectMake(57.0+60+4, 244-85, 71.0, 71.0);
        }
    }
    
    [ProfileBtn setBackgroundImage:img forState:UIControlStateNormal];
    ProfileBtn.clipsToBounds = YES;
    [ProfileBtn addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
  //  [scroll addSubview:ProfileBtn];
    
    [Gallerybutton setBackgroundImage:img forState:UIControlStateNormal];
    
    
    NSData *data = UIImageJPEGRepresentation(img, 1.0f);
    [Base64 initialize];
    StrEncoded = [Base64 encode:data];
    data=nil;
    
//    [EditCamerabutton setBackgroundImage:[UIImage imageNamed:@"dragicon.png"] forState:UIControlStateNormal];
//    EditCamerabutton.clipsToBounds = YES;
//    [EditCamerabutton addTarget:self action:@selector(AlertForSeLectionTheImageCapturing) forControlEvents:UIControlEventTouchDown];
  //  [scroll addSubview:EditCamerabutton];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

}


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.profilePictureView.profileID = nil;
}

@end
