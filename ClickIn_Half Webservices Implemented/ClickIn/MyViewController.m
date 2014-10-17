/*
 File: MyViewController.m
 Abstract: The root view controller for the iPhone design of this app.
 Version: 1.5
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "MyViewController.h"

@interface MyViewController ()
{
    int pageNumber;
}
@end

@implementation MyViewController

// load the view nib and initialize the pageNumber ivar
- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super initWithNibName:@"MyView" bundle:nil])
    {
        pageNumber = page;
    }
    return self;
}

// set the label and background color when the view has finished loading
- (void)viewDidLoad
{
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %d", pageNumber + 1];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    
    btn_PrivacyPolicy = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_PrivacyPolicy addTarget:self
                           action:@selector(clk_btn_PrivacyPolicy:)
                 forControlEvents:UIControlEventTouchUpInside];
    
    btn_PrivacyPolicy.backgroundColor = [UIColor clearColor];
    if (!IS_IPHONE_5)
    {
        btn_PrivacyPolicy.frame = CGRectMake(160, 330, 80, 30);
    }
    else
    {
        btn_PrivacyPolicy.frame = CGRectMake(160, 340+47, 80, 30);
    }

    btn_TermConditions = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_TermConditions.backgroundColor = [UIColor clearColor];
    [btn_TermConditions addTarget:self
                   action:@selector(clk_btn_TermConditions:)
         forControlEvents:UIControlEventTouchUpInside];
    
    if (!IS_IPHONE_5)
    {
        btn_TermConditions.frame = CGRectMake(80, 330, 70, 30);
    }
    else
    {
        btn_TermConditions.frame = CGRectMake(80, 340+47, 70, 30);
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        
    }
    else
    {
        [self.view addSubview:btn_TermConditions];
        [self.view addSubview:btn_PrivacyPolicy];
    }
    btn_TermConditions.hidden = YES;
    btn_PrivacyPolicy.hidden = YES;

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    btn_SignIn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_SignIn setBackgroundImage:[UIImage imageNamed:@"login_btnNew.png"] forState:UIControlStateNormal];
    [btn_SignIn setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateSelected];
    
    [btn_SignIn addTarget:self
                   action:@selector(clk_btn_SignIn:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    if (!IS_IPHONE_5)
        btn_SignIn.frame = CGRectMake(106.5, self.view.frame.size.height-54, 214/2, 75/2);
    else
        btn_SignIn.frame = CGRectMake(106.5, 512, 215/2, 75/2);
    
    
    btn_SignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_SignUp setBackgroundImage:[UIImage imageNamed:@"signupNew.png"] forState:UIControlStateNormal];
    [btn_SignUp setBackgroundImage:[UIImage imageNamed:@"signupNew.png"] forState:UIControlStateSelected];
    [btn_SignUp addTarget:self
                   action:@selector(clk_btn_SignUp:)
         forControlEvents:UIControlEventTouchUpInside];
    //  btn_SignUp.frame = CGRectMake(170, self.view.frame.size.height-55, 215/2, 75/2);
    
    if (!IS_IPHONE_5)
    {
        btn_SignUp.frame = CGRectMake(100.5, 183, 240/2, 238/2);
    }
    else
    {
        btn_SignUp.frame = CGRectMake(100.5, 240, 240/2, 238/2);
    }
    
    if([[defaults stringForKey:@"IsAutoLogin"] isEqualToString:@"yes"])
    {
        
    }
    else
    {
        [self.view addSubview:btn_SignUp];
        [self.view addSubview:btn_SignIn];
    }
    
    btn_SignUp.hidden = YES;
    btn_SignIn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showloginSignUpButton) name:@"postnotificationForShowButtons" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideloginSignUpButton) name:@"postnotificationForHideButtons" object:nil];
}

-(void)HideloginSignUpButton
{
    btn_SignUp.hidden = YES;
    btn_SignIn.hidden = YES;
    
    btn_TermConditions.hidden = YES;
    btn_PrivacyPolicy.hidden = YES;

}

-(void)showloginSignUpButton
{
    btn_SignUp.hidden = NO;
    btn_SignIn.hidden = NO;
    
    btn_TermConditions.hidden = NO;
    btn_PrivacyPolicy.hidden = NO;

}

-(void)clk_btn_PrivacyPolicy:(id)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForPrivacyPolicy" object:nil];
}

-(void)clk_btn_TermConditions:(id)sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForTermConditions" object:nil];
}

-(void)clk_btn_SignIn:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"appIntro"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForSignin" object:nil];
}

-(void)clk_btn_SignUp:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"no" forKey:@"appIntro"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postnotificationForSignup" object:nil];
}




@end
