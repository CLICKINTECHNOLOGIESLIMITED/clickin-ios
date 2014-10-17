//
//  PhotoController.m
//  SimpleSample-Content
//
//  Created by kirill on 7/17/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "PhotoViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "Base64.h"


@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize messageID;

-(id)initWithImage:(UIImage*)imageToDisplay{
    self = [super init];
    if (self)
    {
        TempDisplayPicture = imageToDisplay;
        NSData *data = UIImageJPEGRepresentation(imageToDisplay, 1.0f);
        [Base64 initialize];
        StrEncoded = [Base64 encode:data];
        data=nil;

        
        self.view.backgroundColor=[UIColor blackColor];
        // Show full screen image
        UIImageView* photoDisplayer = [[UIImageView alloc] init];
        if(IS_IPHONE_5)
        {
            [photoDisplayer setFrame:CGRectMake(0, 0, 320, 568)];
        }
        else
        {
            [photoDisplayer setFrame:CGRectMake(0, 0, 320, 480)];
        }
        
        photoDisplayer.opaque = NO;
        [photoDisplayer setImage:imageToDisplay];
        photoDisplayer.contentMode=UIViewContentModeScaleAspectFit;
        [self.view addSubview:photoDisplayer];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//        [photoDisplayer addGestureRecognizer:tap];
        
        photoDisplayer = nil;
        
        //back button
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn addTarget:self action:@selector(backButtonAction)forControlEvents:UIControlEventTouchDown];
        [backBtn setImage:[UIImage imageNamed:@"back ButtonBLK.png"] forState:UIControlStateNormal];
        backBtn.frame = CGRectMake(10, self.view.frame.size.height-40, 35 , 25);
        [self.view addSubview:backBtn];
        
        //ThreeDotsButtons Top right corner
        UIButton *ThreeDotsButtons = [UIButton buttonWithType:UIButtonTypeCustom];
        [ThreeDotsButtons addTarget:self action:@selector(ThreeDotsButtonAction)forControlEvents:UIControlEventTouchDown];
        [ThreeDotsButtons setImage:[UIImage imageNamed:@"3 dotBLK.png"] forState:UIControlStateNormal];
 //     [ThreeDotsButtons setBackgroundImage:[UIImage imageNamed:@"3_dot.png"] forState:UIControlStateNormal];
        ThreeDotsButtons.frame = CGRectMake(280, 10, 25 , 14);
    //    [self.view addSubview:ThreeDotsButtons];
        
        //back button
        UIButton *ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ShareBtn addTarget:self action:@selector(ShareButtonAction)forControlEvents:UIControlEventTouchDown];
        [ShareBtn setImage:[UIImage imageNamed:@"share buttonBLK.png"] forState:UIControlStateNormal];
        ShareBtn.frame = CGRectMake(280, self.view.frame.size.height-40, 35 , 25);
     //   [self.view addSubview:ShareBtn];
        
        HoverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(104, 0, 216, 89)];
        HoverImgView.image = [UIImage imageNamed:@"hover.png"];
        
        SaveToLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [SaveToLibraryBtn addTarget:self action:@selector(SaveToLibraryBtnAction)forControlEvents:UIControlEventTouchDown];
//        [SaveToLibraryBtn setImage:[UIImage imageNamed:@"bottom_right.png"] forState:UIControlStateNormal];
        SaveToLibraryBtn.frame = CGRectMake(104, 0, 216 , 44);
//        SaveToLibraryBtn.backgroundColor = [UIColor redColor];
        [self.view addSubview:SaveToLibraryBtn];
        
        SetAsDisplayPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [SetAsDisplayPictureBtn addTarget:self action:@selector(SetAsDisplayPictureBtnAction)forControlEvents:UIControlEventTouchDown];
//      [SetAsDisplayPictureBtn setImage:[UIImage imageNamed:@"bottom_right.png"] forState:UIControlStateNormal];
        SetAsDisplayPictureBtn.frame = CGRectMake(104, 44, 216 , 45);
//      SetAsDisplayPictureBtn.backgroundColor = [UIColor redColor];
        [self.view addSubview:SetAsDisplayPictureBtn];
        
        [self.view addSubview:HoverImgView];
        [self.view bringSubviewToFront:SetAsDisplayPictureBtn];
        [self.view bringSubviewToFront:SaveToLibraryBtn];
        
        HoverImgView.hidden = YES;
        SaveToLibraryBtn.hidden = YES;
        SetAsDisplayPictureBtn.hidden =  YES;
        
        //-----sharing scroll view-----
        shareScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, self.view.frame.size.height-50, 290, 50)];
        shareScrollView.contentSize = CGSizeMake(290, 50);
        shareScrollView.showsHorizontalScrollIndicator = NO;
        shareScrollView.showsVerticalScrollIndicator = NO;
        shareScrollView.scrollsToTop = NO;
        shareScrollView.delegate = self;
      //  [self.view addSubview:shareScrollView];
        
        UIButton *iconShareBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];   // for googleplus
        iconShareBtn1.tag=111111;
        [iconShareBtn1 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
        [iconShareBtn1 setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
        iconShareBtn1.frame = CGRectMake(0, 0, 45 ,45);
        [shareScrollView addSubview:iconShareBtn1];
        
        UIButton *iconShareBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];   // for twitter
        iconShareBtn2.tag=222222;
        [iconShareBtn2 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
        [iconShareBtn2 setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
        iconShareBtn2.frame = CGRectMake(50, 0, 45 ,45);
        [shareScrollView addSubview:iconShareBtn2];
        
        UIButton *iconShareBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];   // for facebook
        iconShareBtn3.tag=333333;
        [iconShareBtn3 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
        [iconShareBtn3 setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
        iconShareBtn3.frame = CGRectMake(100, 0, 45 ,45);
        [shareScrollView addSubview:iconShareBtn3];
        
        UIButton *iconShareBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];   // for inapp clickin
        iconShareBtn4.tag=444444;
        [iconShareBtn4 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
        [iconShareBtn4 setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
        iconShareBtn4.frame = CGRectMake(150, 0, 45 ,45);
        [shareScrollView addSubview:iconShareBtn4];
        
        UIButton *iconShareBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];   // for sharing
        iconShareBtn5.tag=555555;
        [iconShareBtn5 addTarget:self action:@selector(ShareButtonsAction:)forControlEvents:UIControlEventTouchDown];
        [iconShareBtn5 setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        iconShareBtn5.frame = CGRectMake(200, 0, 88 ,45);
        [shareScrollView addSubview:iconShareBtn5];
        shareScrollView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark Custom Functions

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    HoverImgView.hidden = YES;
    SaveToLibraryBtn.hidden = YES;
    SetAsDisplayPictureBtn.hidden =  YES;
    shareScrollView.hidden = YES;
}

-(void)ShareButtonAction
{
    shareScrollView.hidden = NO;
}

-(void) ShareButtonsAction:(UIButton*)sender
{
    if(sender.tag==111111)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharegoogleplus.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharegoogleplusS.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
            [sender setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
    }
    if(sender.tag==222222)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharetwitter.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharetwitterS.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
            [sender setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
        
     }
    if(sender.tag==333333)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"sharefacebook.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharefacebookS.png"] forState:UIControlStateNormal];
            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
            [activity show];
            
            //facebook login
            NSArray *permissions =
            [NSArray arrayWithObjects:@"publish_stream",@"publish_actions",nil];
            
            [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES  completionHandler:
             ^(FBSession *session,
               FBSessionState state, NSError *error) {
                 [self sessionStateChanged:session state:state error:error];
             }];
            
            
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
        }
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
    }
    if(sender.tag==444444)
    {
        if(sender.currentBackgroundImage == [UIImage imageNamed:@"clickin.png"])
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"clickinS.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"shareOnClickin"];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
        }
        else
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"shareOnClickin"];
        }
        
        if([(UIButton*)[sender.superview viewWithTag:111111] currentBackgroundImage]==[UIImage imageNamed:@"sharegoogleplus.png"] &&
           [(UIButton*)[sender.superview viewWithTag:222222] currentBackgroundImage]==[UIImage imageNamed:@"sharetwitter.png"] &&
           [(UIButton*)[sender.superview viewWithTag:333333] currentBackgroundImage]==[UIImage imageNamed:@"sharefacebook.png"] &&
           [(UIButton*)[sender.superview viewWithTag:444444] currentBackgroundImage]==[UIImage imageNamed:@"clickin.png"] )
        {
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
    }
    
    if(sender.tag==555555)
    {
        
        NSLog(@"%@",((UIButton*)[sender.superview viewWithTag:555555]).currentBackgroundImage);
        
        //if(((UIButton*)[sender.superview viewWithTag:555555]).currentBackgroundImage == [UIImage imageNamed:@"share_btnS.png"])
        if ([[((UIButton*)[sender.superview viewWithTag:555555]) backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"share_btnS.png"]])
        {
            
            [UIView animateWithDuration:0.5 animations:^() {
                shareScrollView.alpha = 0;
            }];
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate performSelector:@selector(CheckInternetConnection)];
            if(appDelegate.internetWorking == 0)//0: internet working
            {
                NSString *str = [NSString stringWithFormat:DomainNameUrl@"/chats/share"];
                NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                NSError *error;
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSDictionary *Dictionary;
                
                NSLog(@"%@",[prefs stringForKey:@"phoneNumber"]);
                
                NSString *sharing_media = [NSString stringWithFormat:@""];
                if([[prefs stringForKey:@"shareOnClickin"] isEqualToString:@"yes"])
                {
                    if(sharing_media.length==0)
                        sharing_media = [sharing_media stringByAppendingString:@"clickin"];
                    else
                        sharing_media = [sharing_media stringByAppendingString:@",clickin"];
                }
                if([[prefs stringForKey:@"fb_accesstoken"] length]>0)
                {
                    if(sharing_media.length==0)
                        sharing_media = [sharing_media stringByAppendingString:@"facebook"];
                    else
                        sharing_media = [sharing_media stringByAppendingString:@",facebook"];
                }
                Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", messageID ,@"chat_id" , [prefs stringForKey:@"relationShipId"] ,@"relationship_id",
                              sharing_media, @"media", [prefs stringForKey:@"fb_accesstoken"], @"fb_access_token", @"", @"twitter_access_token", @"" , @"googleplus_access_token" ,nil];
                
                
                NSLog(@"%@",Dictionary);
                sharing_media = nil;
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
                
                [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                
                [request appendPostData:jsonData];
                
                [request setRequestMethod:@"POST"];
                [request setDelegate:self];
                [request setTimeOutSeconds:200];
                [request startAsynchronous];
                NSLog(@"responseStatusCode %i",[request responseStatusCode]);
                NSLog(@"responseString %@",[request responseString]);
                
                if([request responseStatusCode] == 200)
                {
                    NSError *error = nil;
                    NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
                    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
                    if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Newsfeed has been saved."])
                    {
                    }
                }
                
                else if([request responseStatusCode] == 401)
                {
//                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Some error occured." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [alert show];
//                    alert = nil;
                    MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                    description:@"Some error occured."
                                                                                  okButtonTitle:@"OK"];
                    alertView.delegate = nil;
                    [alertView show];
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
                [alertView show];
                alertView = nil;

            }
            [activity hide];
            //[(UIButton*)[sender.superview viewWithTag:555555] setEnabled:false];
            [(UIButton*)[sender.superview viewWithTag:111111] setBackgroundImage:[UIImage imageNamed:@"sharegoogleplus.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:222222] setBackgroundImage:[UIImage imageNamed:@"sharetwitter.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:333333] setBackgroundImage:[UIImage imageNamed:@"sharefacebook.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:444444] setBackgroundImage:[UIImage imageNamed:@"clickin.png"] forState:UIControlStateNormal];
            [(UIButton*)[sender.superview viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btn.png"] forState:UIControlStateNormal];
        }
        
        else
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please select media to share with" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Please select media to share with"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = self;
            [alertView show];
            alertView = nil;

        }
        
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
            //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:session.accessTokenData.accessToken forKey:@"fb_accesstoken"];
            
            FBSession.activeSession = session;
            
            if(shareScrollView.alpha==1)
            {
                [(UIButton*)[shareScrollView viewWithTag:555555] setBackgroundImage:[UIImage imageNamed:@"share_btnS.png"] forState:UIControlStateNormal];
            }
            
            //[self getuserID];  // get user email
            [activity hide];
            
        }
            break;
        case FBSessionStateClosed:
        {
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
            [activity hide];
        }
            break;
            
        case FBSessionStateClosedLoginFailed:
        {
            // Once the user has logged in, we want them to
            // be looking at the root view.
            // [self.navController popToRootViewControllerAnimated:NO];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"fb_login"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"fb_accesstoken"];
            
            //[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"fb_email"];
            [FBSession.activeSession closeAndClearTokenInformation];
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"GIVE US ACCESS."
                                                                            description:@"Please allow Clickin' to access your Facebook account from the phone Settings"
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
            
            [activity hide];
            return;
            // [self showLoginView];
        }
            break;
        default:
            break;
    }
    
    if (error)
    {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:@"Error"
                                                                        description:error.localizedDescription
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
        [activity hide];
    }
}



- (void)ThreeDotsButtonAction
{
    HoverImgView.hidden = NO;
    SaveToLibraryBtn.hidden = NO;
    SetAsDisplayPictureBtn.hidden = NO;
}


- (void) SetAsDisplayPictureBtnAction
{
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    [self performSelector:@selector(updateprofileWebservice) withObject:nil afterDelay:0.1];
    
    HoverImgView.hidden = YES;
    SaveToLibraryBtn.hidden = YES;
    SetAsDisplayPictureBtn.hidden = YES;
}

- (void) SaveToLibraryBtnAction
{
    //UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);
    UIImageWriteToSavedPhotosAlbum(TempDisplayPicture, nil, nil, nil);
    HoverImgView.hidden = YES;
    SaveToLibraryBtn.hidden = YES;
    SetAsDisplayPictureBtn.hidden =  YES;
}


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
        
        [prefs stringForKey:@"DateOfBirth"];
        [prefs stringForKey:@"str_Gender"];

        NSError *error;
        
        NSDictionary *Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[prefs objectForKey:@"DateOfBirth"]],@"dob",StrEncoded,@"user_pic",[NSString stringWithFormat:@"%@",[prefs objectForKey:@"user_token"]],@"user_token",[prefs stringForKey:@"phoneNumber"],@"phone_no",[NSString stringWithFormat:@"%@",[prefs objectForKey:@"str_Gender"]],@"gender",nil];
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Profile updated"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Set display picture successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Set display picture successfully."
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


- (void) backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
