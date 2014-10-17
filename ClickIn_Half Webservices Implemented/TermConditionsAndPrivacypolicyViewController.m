//
//  TermConditionsAndPrivacypolicyViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 10/07/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "TermConditionsAndPrivacypolicyViewController.h"

@interface TermConditionsAndPrivacypolicyViewController ()

@end

@implementation TermConditionsAndPrivacypolicyViewController

@synthesize lblHeader,StrHeader;

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
    
    lblHeader.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    lblHeader.text = [StrHeader uppercaseString];
    
    UIWebView *webview;
    if (IS_IPHONE_5)
    {
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 52, 320,518)];
    }
    else
    {
        webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 52, 320,430)];
    }
    
    webview.backgroundColor = [UIColor whiteColor];
    
    NSString *url;
    if([StrHeader isEqualToString:@"Terms Of Use"])
    {
        url = @"http://api.clickinapp.com/pages/term-of-use";
    }
    else
    {
        url = @"http://api.clickinapp.com/pages/privacy-policy"; // Privacy Policy
    }

    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
