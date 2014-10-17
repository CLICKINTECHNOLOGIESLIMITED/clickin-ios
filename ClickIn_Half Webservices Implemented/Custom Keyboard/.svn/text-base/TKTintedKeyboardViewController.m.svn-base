//
//  TKTintedKeyboardViewController.m
//  TintedKeyboard
//
//  Created by Mike Keller on 12/5/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//  A UIViewController subclass that adds keyboard notifications and "tints" the keyboard when shown. Portrait-only right now.
//

#import "TKTintedKeyboardViewController.h"

static NSInteger kKeyboardTintViewTag = 12345;

@interface TKTintedKeyboardViewController ()

@end

@implementation TKTintedKeyboardViewController

@synthesize tintView;

#pragma mark - Setup

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tintView = [[UIView alloc] init];
//    tintView.backgroundColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    [self.view addSubview:tintView];
    tintView.hidden=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowTintedKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideTintedKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard Notifications

- (void) handleShowTintedKeyboard:(NSNotification*)notification
{
   // NSLog(@"show keyboard");
    tintView.hidden=NO;
    NSDictionary *userInfo = notification.userInfo;
    
    // Get keyboard frames
    CGRect keyboardBeginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
//    __block UIView *tintView = [[UIView alloc] initWithFrame:keyboardBeginFrame];
//    tintView.tag = kKeyboardTintViewTag;
   // tintView.frame=keyboardBeginFrame;
//    tintView.backgroundColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
//    [self.view addSubview:tintView];
    
    // Begin animation.
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         tintView.frame = keyboardEndFrame;
                     }
                     completion:^(BOOL finished)
    {
        tintView.backgroundColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
    }];
}
- (void) handleHideTintedKeyboard:(NSNotification*)notification
{
   // NSLog(@"Hide keyboard");
    tintView.hidden=YES;
    NSDictionary *userInfo = notification.userInfo;
    
    //Get keyboard frame
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Create animation.
    //__block UIView *tintView = [self.view viewWithTag:kKeyboardTintViewTag];
    
    // Begin animation.
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         tintView.frame = keyboardEndFrame;
                     }
                     completion:^(BOOL finished) {
                         //[tintView removeFromSuperview];
                         
                     }];
}
#pragma mark - Teardown

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    [tintView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
