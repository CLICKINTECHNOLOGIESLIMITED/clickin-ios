//
//  MapWebView.m
//  ClickIn
//
//  Created by Dinesh Gulati on 05/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "MapWebView.h"

@interface MapWebView ()

@end

@implementation MapWebView
@synthesize activityIndicator,location_coordinates;

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
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@ >>>>>>>>>>>>>>>> %@",[prefs stringForKey:@"user_id"],[prefs stringForKey:@"user_token"]);
    //[QBUsers logInWithUserLogin:[prefs stringForKey:@"QBUserName"] password:[prefs stringForKey:@"QBPassword"] delegate:self];
    
    UIWebView *webview;
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [webview addSubview:self.activityIndicator];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    [self.activityIndicator startAnimating];
    
    

    if(IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
        }
    }
    else
    {
        if (IS_IPHONE_5)
        {
            webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,568)];
        }
        else
        {
            webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320,480)];
        }
    }
    
//  NSString *url=@"http://maps.google.com.au/maps?ll=-15.623037,18.388672&spn=65.61535,79.013672";
//  NSString *url=@"http://maps.google.com/?q=-15.623037,18.388672";
    NSString *url;
    if(self.location_coordinates.length>0)
    {
        NSArray *coordinates = [location_coordinates componentsSeparatedByString:@","];
        url=[NSString stringWithFormat:@"http://maps.google.com/?q=%@,%@",[coordinates objectAtIndex:0],[coordinates objectAtIndex:1]];
        coordinates = nil;
    }
    else
    {
        url=@"http://maps.google.com";
        //share button
        UIButton *ShareLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        [ShareLocation addTarget:self action:@selector(ShareLocationButtonAction)forControlEvents:UIControlEventTouchDown];
        [ShareLocation setImage:[UIImage imageNamed:@"Sharelocation.png"] forState:UIControlStateNormal];
        if (IS_IPHONE_5)
        {
            ShareLocation.frame = CGRectMake(150, 542, 172 , 26);
        }
        else
        {
            ShareLocation.frame = CGRectMake(150, 452, 172 , 26);
        }
        [webview addSubview:ShareLocation];
    }
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    webview.delegate = self;
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
    
    //back button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backButtonAction)forControlEvents:UIControlEventTouchDown];
    [backBtn setImage:[UIImage imageNamed:@"backiconNew.png"] forState:UIControlStateNormal];
    if (IS_IPHONE_5)
    {
        backBtn.frame = CGRectMake(0, 512, 72 , 72);
    }
    else
    {
        backBtn.frame = CGRectMake(0, 425, 72 , 72);
    }
    [webview addSubview:backBtn];

    
    webview = nil;
}

-(UIImage *)reSizeImage:(UIImage *)image
{
//    float actualHeight = image.size.height;
//    float actualWidth = image.size.width;
//    float imgRatio = actualWidth/actualHeight;
//    float maxRatio = 275.0/416.0;
//    
//    if(imgRatio!=maxRatio){
//        if(imgRatio < maxRatio){
//            imgRatio = 416.0 / actualHeight;
//            actualWidth = imgRatio * actualWidth;
//            actualHeight = 416.0;
//        }
//        else{
//            imgRatio = 255.0 / actualWidth;
//            actualHeight = imgRatio * actualHeight;
//            actualWidth = 275.0;
//        }
//    }
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 535.0/810.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 810.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 810.0;
        }
        else{
            imgRatio = 535.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 535.0;
        }
    }
    
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"w: %f -- h : %f",image.size.width,image.size.height);
    NSLog(@"w: %f -- h : %f",img.size.width,img.size.height);
    return img;
}


#pragma mark -

-(void)ShareLocationButtonAction
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imageView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGRect rect = CGRectMake(0,50 ,320, 475);
    CGImageRef imageRef = CGImageCreateWithImageInRect([viewImage CGImage], rect);
    
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    
    
    
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();*/
    
    
    imageView = [self reSizeImage:imageView];
    
    NSData *imageData = UIImageJPEGRepresentation(imageView, 0.4 );
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:imageData forKey:@"locationimagedata"];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [locationManager stopUpdatingLocation];
    CLLocation *location = [locationManager location];
    if (IS_IOS_8)
    {
        //[locationManager requestAlwaysAuthorization];
        [locationManager requestWhenInUseAuthorization];
    }
    
    // Configure the new event with information from the location
    
    float longitude=location.coordinate.longitude;
    float latitude=location.coordinate.latitude;
    
    NSLog(@"dLongitude : %f", longitude);
    NSLog(@"dLatitude : %f", latitude);
    
    [prefs setObject:[NSString stringWithFormat:@"%f,%f",latitude, longitude] forKey:@"locationCoordinates"];
    
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark -
#pragma mark QBChatDelegate

- (void)completedWithResult:(Result *)result
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBUUserLogInResult *userResult = (QBUUserLogInResult *)result;
        NSLog(@"Logged In user=%d", (int)(unsigned long)userResult.user.ID);
        [prefs setInteger:(int)(unsigned long)userResult.user.ID forKey:@"SenderId"];
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = userResult.user.ID; // your current user's ID
        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
        [QBChat instance].delegate = self;
        [[QBChat instance] loginWithUser:currentUser];
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

-(void)chatDidFailWithError:(int)code
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    QBUUser *currentUser = [QBUUser user];
    currentUser.ID = [prefs integerForKey:@"SenderId"]; // your current user's ID
    currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
    [QBChat instance].delegate = self;
    [[QBChat instance] loginWithUser:currentUser];
}


// Chat delegate
-(void) chatDidLogin
{
    [NSTimer scheduledTimerWithTimeInterval:60 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
}
*/


#pragma mark -
#pragma mark webview methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",[error description]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
    self.activityIndicator = nil;
}

- (void) backButtonAction
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
