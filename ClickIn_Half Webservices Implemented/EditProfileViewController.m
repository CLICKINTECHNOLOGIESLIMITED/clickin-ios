//
//  EditProfileViewController.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 02/06/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "EditProfileViewController.h"
#import "MFSideMenu.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Base64.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize imgPicker = _imgPicker;
@synthesize delegate_imageupdated;

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
    // Do any additional setup after loading the view from its nib.
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(rightMenuToggled:)
     name:Notification_RightMenuToggled
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(ProfileInfoNotificationReceived:)
     name:Notification_ProfileInfoUpdated
     object:nil];
    
    _imgPicker = [[UIImagePickerController alloc] init];
    
    //screen bg
    UIImageView *screen_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (IS_IPHONE_5) {
        screen_bg.frame=CGRectMake(0, 0, 320, 568);
    }
    screen_bg.image=[UIImage imageNamed:@"background1140.png"];
    [self.view addSubview:screen_bg];
    [self.view sendSubviewToBack:screen_bg];
    screen_bg = nil;
    
    [self.view bringSubviewToFront:self.topBarImageView];
    [self.view bringSubviewToFront:self.LblEditProfile];
    
    self.LblEditProfile.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    // notifications text
    notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
    notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
    notification_text.center=CGPointMake(298, 19);
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
    
    //----Scroll View Implementation
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-70-56)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.contentSize = CGSizeMake(320, 600);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    //scroll.scrollEnabled = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    editPhotoView = [[UIImageView alloc] init];
    [editPhotoView setFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 2, 541/2.0, 201/2.0)];
    [editPhotoView setImage:[UIImage imageNamed:@"editPhotoView.png"]];
    [scroll addSubview:editPhotoView];
    
    
    profileImageView = [[UIImageView alloc] init];
    [profileImageView setFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 2, 201/2.0, 201/2.0)];
    //[profileImageView setImage:[UIImage imageNamed:@"editPhotoView.png"]];
//    [profileImageView setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl]];
    
    [profileImageView sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSData *data = UIImageJPEGRepresentation(profileImageView.image, 0.1f);
        [Base64 initialize];
        StrEncoded = [Base64 encode:data];
        data=nil;
        
        if([NameTxtField.text isEqualToString:@""] || [LastNameTxtField.text isEqualToString:@""] || [EmailTxtField.text isEqualToString:@""] || [StrEncoded length]==0)
        {
            [saveButton setEnabled:NO];
        }
        else
            [saveButton setEnabled:YES];

    }];
    [scroll addSubview:profileImageView];
    
 
    
    
    btn_PicFromGallery = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_PicFromGallery.tag=1;
    [btn_PicFromGallery addTarget:self
                           action:@selector(clk_btn:)
                 forControlEvents:UIControlEventTouchDown];
    [btn_PicFromGallery setBackgroundColor:[UIColor clearColor]];
    btn_PicFromGallery.frame = CGRectMake(self.view.frame.size.width/2 -30, 92-70, 80, 80);
    [scroll addSubview:btn_PicFromGallery];
    
    
    //---UIButton btn_PicFromCamera---
    
    btn_PicFromCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_PicFromCamera.tag=2;
    [btn_PicFromCamera addTarget:self
                          action:@selector(clk_btn:)
                forControlEvents:UIControlEventTouchDown];
    [btn_PicFromCamera setBackgroundColor:[UIColor clearColor]];
    btn_PicFromCamera.frame = CGRectMake(self.view.frame.size.width/2 + 50, 92-70, 80, 80);
    [scroll addSubview:btn_PicFromCamera];
    
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:self
                           action:@selector(saveBtnPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"saveBtn.png"] forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(self.view.frame.size.width/2 - 541/4.0, self.view.frame.size.height/2 + 116-20, 541/2.0, 65/2.0);
    [saveButton setEnabled:NO];
    [scroll addSubview:saveButton];
    
    NSString *firstName;
    NSString *lastName;
    NSScanner *scanner = [NSScanner scannerWithString:[profilemanager.ownerDetails.name capitalizedString]];
    [scanner scanUpToString:@" " intoString:&firstName]; // Scan all characters up to the first space
    [scanner scanUpToString:@"" intoString:&lastName]; // Scan remaining characters
    
  
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    NameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 200 - 70, 541/2.0, 66/2.0)];
    [NameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [NameTxtField setLeftView:spacerView];
    [NameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [NameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    NameTxtField.delegate = self;
    NameTxtField.textColor = [UIColor darkGrayColor];
    NameTxtField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    NameTxtField.layer.cornerRadius=1.0f;
    NameTxtField.layer.masksToBounds=YES;
    NameTxtField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
    NameTxtField.layer.borderWidth= 1.0f;
    NameTxtField.placeholder = @"FIRST NAME";
    if (firstName != nil)
    {
        NameTxtField.text = firstName;
    }
    else
    {
        NameTxtField.text = @"";
    }
//    NameTxtField.text = [profilemanager.ownerDetails.name capitalizedString];
    NameTxtField.returnKeyType = UIReturnKeyNext;
    NameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];
    [scroll addSubview:NameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    LastNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 250 - 70, 541/2.0, 66/2.0)];
    [LastNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [LastNameTxtField setLeftView:spacerView];
    [LastNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [LastNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    LastNameTxtField.delegate = self;
    LastNameTxtField.textColor = [UIColor darkGrayColor];
    LastNameTxtField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    LastNameTxtField.layer.cornerRadius=1.0f;
    LastNameTxtField.layer.masksToBounds=YES;
    LastNameTxtField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
    LastNameTxtField.layer.borderWidth= 1.0f;
    LastNameTxtField.placeholder = @"LAST NAME";
    if (lastName != nil)
    {
        LastNameTxtField.text = lastName;
    }
    else
    {
        LastNameTxtField.text = @"";
    }
//    LastNameTxtField.text = [profilemanager.ownerDetails.name capitalizedString];
    LastNameTxtField.returnKeyType = UIReturnKeyNext;
    LastNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];
    [scroll addSubview:LastNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    EmailTxtField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 300-70, 541/2.0, 66/2.0)];
    [EmailTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [EmailTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    EmailTxtField.delegate = self;
    EmailTxtField.textColor = [UIColor darkGrayColor];
    EmailTxtField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    EmailTxtField.placeholder = @"EMAIL";
    EmailTxtField.text = profilemanager.ownerDetails.email;
    EmailTxtField.layer.cornerRadius=1.0f;
    EmailTxtField.layer.masksToBounds=YES;
    EmailTxtField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
    EmailTxtField.layer.borderWidth= 1.0f;
    [EmailTxtField setKeyboardType:UIKeyboardTypeEmailAddress];
    EmailTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];
    [EmailTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [EmailTxtField setLeftView:spacerView];
    [EmailTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    EmailTxtField.returnKeyType = UIReturnKeyNext;
    [scroll addSubview:EmailTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    CityNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 350-70, 541/2.0, 66/2.0)];
    [CityNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [CityNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    CityNameTxtField.delegate = self;
    CityNameTxtField.textColor = [UIColor darkGrayColor];
    CityNameTxtField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    CityNameTxtField.placeholder = @"CITY NAME";
    CityNameTxtField.text = [profilemanager.ownerDetails.city capitalizedString];
    CityNameTxtField.layer.cornerRadius=1.0f;
    CityNameTxtField.layer.masksToBounds=YES;
    CityNameTxtField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
    CityNameTxtField.layer.borderWidth= 1.0f;
    CityNameTxtField.returnKeyType = UIReturnKeyNext;
    CityNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];
    [CityNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [CityNameTxtField setLeftView:spacerView];
    [CityNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [scroll addSubview:CityNameTxtField];
    spacerView = nil;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    CountryNameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 541/4.0, 400-70, 541/2.0, 66/2.0)];
    [CountryNameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [CountryNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    CountryNameTxtField.delegate = self;
    CountryNameTxtField.textColor = [UIColor darkGrayColor];
    CountryNameTxtField.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    CountryNameTxtField.placeholder = @"COUNTRY";
    CountryNameTxtField.text = [profilemanager.ownerDetails.country capitalizedString];
    CountryNameTxtField.layer.cornerRadius=1.0f;
    CountryNameTxtField.layer.masksToBounds=YES;
    CountryNameTxtField.layer.borderColor=[[UIColor colorWithRed:(206.0/255.0) green:(205.0/255.0) blue:(205.0/255.0) alpha:1.0] CGColor];
    CountryNameTxtField.layer.borderWidth= 1.0f;
    CountryNameTxtField.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:18];
    [CountryNameTxtField setLeftViewMode:UITextFieldViewModeAlways];
    [CountryNameTxtField setLeftView:spacerView];
    [CountryNameTxtField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [scroll addSubview:CountryNameTxtField];
    spacerView = nil;
    
    if([NameTxtField.text isEqualToString:@""] || [LastNameTxtField.text isEqualToString:@""] ||
//       [CityNameTxtField.text isEqualToString:@""] ||
//       [CountryNameTxtField.text isEqualToString:@""] ||
       [EmailTxtField.text isEqualToString:@""]||
       [StrEncoded length]==0)
    {
        [saveButton setEnabled:NO];
    }
    else
        [saveButton setEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:tap];
    
     [self.view bringSubviewToFront:self.tintView];
}

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

-(void)viewWillAppear:(BOOL)animated
{
    [profilemanager.ownerDetails getProfileInfo:YES];
}


- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [EmailTxtField resignFirstResponder];
    [CountryNameTxtField resignFirstResponder];
    [CityNameTxtField resignFirstResponder];
    [NameTxtField resignFirstResponder];
    
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    //scroll.scrollEnabled = NO;
    
    if([NameTxtField.text isEqualToString:@""])
    {
        [saveButton setEnabled:NO];
    }
    if([LastNameTxtField.text isEqualToString:@""])
    {
        [saveButton setEnabled:NO];
    }
    
//    else if([CityNameTxtField.text isEqualToString:@""])
//    {
//        [saveButton setEnabled:NO];
//    }
//    else if([CountryNameTxtField.text isEqualToString:@""])
//    {
//        [saveButton setEnabled:NO];
//    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [saveButton setEnabled:NO];
    }
    else if ([StrEncoded length]==0)
    {
        [saveButton setEnabled:NO];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [saveButton setEnabled:NO];
    }
    else
    {
        [saveButton setEnabled:YES];
    }

}


-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}

-(void)saveBtnPressed:(UIButton*)sender
{
    if([NameTxtField.text isEqualToString:@""] || [LastNameTxtField.text isEqualToString:@""] || [EmailTxtField.text isEqualToString:@""] || [StrEncoded length]==0)
    {
        [saveButton setEnabled:NO];
    }
    else
    {
//        NSArray *nameComponents = [NameTxtField.text componentsSeparatedByString:@" "];
//        
//        NSString *firstName,*lastName=@"";
//        if(nameComponents.count!=0)
//        {
//            firstName = [nameComponents objectAtIndex:0];
//            for(int j=1;j<nameComponents.count;j++)
//                lastName = [lastName stringByAppendingString:[NSString stringWithFormat:@"%@ ",[nameComponents objectAtIndex:j]]];
//        }
//
//        lastName = [lastName stringByTrimmingCharactersInSet:
//                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if(lastName.length==0)
//        {
//            [saveButton setEnabled:NO];
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Last name cannot be blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
//
//        }
//        else
        {
            if(activity==nil)
                activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
            [activity show];
            
            [self performSelector:@selector(updateprofileWebservice) withObject:nil afterDelay:0.1];
    //        SDImageCache *imageCache = [SDImageCache sharedImageCache];
    //        [imageCache clearMemory];
        }
    }
}

#pragma mark Custom Functions

-(void)updateprofileWebservice
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/updateprofile"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        
        
        NSError *error;
        
//       NSArray *nameComponents = [NameTxtField.text componentsSeparatedByString:@" "];
        
//        NSString *firstName,*lastName=@"";
//        if(nameComponents.count!=0)
//        {
//            firstName = [nameComponents objectAtIndex:0];
//            for(int j=1;j<nameComponents.count;j++)
//                lastName = [lastName stringByAppendingString:[NSString stringWithFormat:@"%@ ",[nameComponents objectAtIndex:j]]];
//        }
        
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:StrEncoded,@"user_pic",[NSString stringWithFormat:@"%@",[prefs objectForKey:@"user_token"]],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",CityNameTxtField.text,@"city",CountryNameTxtField.text,@"country",EmailTxtField.text,@"email",NameTxtField.text,@"first_name",LastNameTxtField.text,@"last_name",@"",@"fb_access_token",nil];
        
//        firstName = lastName = nil;
//        nameComponents = nil;
        
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
//                [[SDImageCache sharedImageCache] queryDiskCacheForKey:profilemanager.ownerDetails.profilePicUrl done:^(UIImage *image, SDImageCacheType cacheType)
//                {
//                    //UIImage *img=image;
//                    NSLog(@"%i",cacheType);
//                }];
                [[SDImageCache sharedImageCache] removeImageForKey:profilemanager.ownerDetails.profilePicUrl fromDisk:YES];
                
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:StrEncoded options:0];
                [delegate_imageupdated imageUpdated:decodedData];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Email already exists"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in saving the image"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"There was a problem in saving the image."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
            }
        }
        else if([request responseStatusCode] == 500)
        {
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Email already exists"])
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Email already exists"
                                                                              okButtonTitle:@"OK"];
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
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"There was a problem in saving the image."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
                    alertView = nil;
                }
            }
        }
        else if([request responseStatusCode] == 400)
        {
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Last name cannot be blank."])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Last name cannot be blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;

                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Last name cannot be blank."
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"There was a problem in saving the image"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"There was a problem in saving the image." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"There was a problem in saving the image."
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
}

-(void)showImagePicker:(UIImagePickerControllerSourceType) sourceType {
    
    @try {
        _imgPicker.sourceType = sourceType;
        [_imgPicker setAllowsEditing:YES];
        _imgPicker.delegate = self;
        if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            _imgPicker.showsCameraControls = YES;
        }
        if ( [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [self presentViewController:_imgPicker animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
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



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    
    tempProfilePic = image;
    if(tempProfilePic.size.width>320 || tempProfilePic.size.height>480)
        tempProfilePic = [self scaleImage:tempProfilePic toSize:CGSizeMake(320, 480)];
    
    NSData *data = UIImageJPEGRepresentation(tempProfilePic, 0.1f);
    [Base64 initialize];
    StrEncoded = [Base64 encode:data];
    data=nil;
    
    /*
    if([NameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    
    else if([CityNameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([CountryNameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([StrEncoded length]==0)
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];
    }
    */
    
    
    [profileImageView setImage:tempProfilePic];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    /*if([NameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    
    else if([CityNameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([CountryNameTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if([EmailTxtField.text isEqualToString:@""])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if ([StrEncoded length]==0)
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else if(![self validEmail:EmailTxtField.text])
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    }
    else
    {
        [saveButton setBackgroundImage:[UIImage imageNamed:@"buttonNextActivated.png"] forState:UIControlStateNormal];
    }
     */
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Selector Functions

-(BOOL)validEmail:(NSString*)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}



#pragma mark Text Field Delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == NameTxtField)
    {
        [NameTxtField resignFirstResponder];
        [LastNameTxtField becomeFirstResponder];
    }
    else if (textField == LastNameTxtField)
    {
        [LastNameTxtField resignFirstResponder];
        [EmailTxtField becomeFirstResponder];
    }
    else if (textField == EmailTxtField )
    {
        [EmailTxtField resignFirstResponder];
        [CityNameTxtField becomeFirstResponder];
    }
    else if (textField == CityNameTxtField  )
    {
        [CityNameTxtField resignFirstResponder];
        [CountryNameTxtField becomeFirstResponder];
    }
    else if (textField == CountryNameTxtField)
    {
        [EmailTxtField resignFirstResponder];
        [CountryNameTxtField resignFirstResponder];
        [CityNameTxtField resignFirstResponder];
        [NameTxtField resignFirstResponder];
        [LastNameTxtField resignFirstResponder];
        
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        //scroll.scrollEnabled = NO;
        
        if([NameTxtField.text isEqualToString:@""])
        {
            [saveButton setEnabled:NO];
        }
        
        if([LastNameTxtField.text isEqualToString:@""])
        {
            [saveButton setEnabled:NO];
        }
        
//        else if([CityNameTxtField.text isEqualToString:@""])
//        {
//            [saveButton setEnabled:NO];
//        }
//        else if([CountryNameTxtField.text isEqualToString:@""])
//        {
//            [saveButton setEnabled:NO];
//        }
        else if([EmailTxtField.text isEqualToString:@""])
        {
            [saveButton setEnabled:NO];
        }
        else if ([StrEncoded length]==0)
        {
            [saveButton setEnabled:NO];
        }
        else if(![self validEmail:EmailTxtField.text])
        {
            [saveButton setEnabled:NO];
        }
        else
        {
            [saveButton setEnabled:YES];
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //scroll.scrollEnabled = YES;
    if (textField == NameTxtField)
    {
        if (!IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,65) animated:YES];
    }
    if (textField == LastNameTxtField)
    {
        if (!IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,85) animated:YES];
    }
    else if (textField == EmailTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,100) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,80) animated:YES];
    }
    else if (textField == CityNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,150) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,105) animated:YES];
    }
    else if (textField == CountryNameTxtField)
    {
        [scroll setContentOffset:CGPointMake(0,200) animated:YES];
        if (IS_IPHONE_5)
            [scroll setContentOffset:CGPointMake(0,130) animated:YES];
    }
    
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([NameTxtField.text isEqualToString:@""] ||
//       [CityNameTxtField.text isEqualToString:@""] ||
//       [CountryNameTxtField.text isEqualToString:@""] ||
       [EmailTxtField.text isEqualToString:@""]||
       [StrEncoded length]==0 || ![self validEmail:EmailTxtField.text])
    {
        [saveButton setEnabled:NO];
    }
    else
    {
        [saveButton setEnabled:YES];
    }
    
    return YES;
}



#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
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
