//
//  MODropAlertView.m
//  MODropAlertDemo
//
//  Created by Ahn JungMin on 2014. 7. 1..
//  Copyright (c) 2014년 Ahn JungMin. All rights reserved.
//

#import "MODropAlertView.h"
#import "UIImage+ImageEffects.h"

static const CGFloat kAlertButtonBottomMargin = 15;
static const CGFloat kAlertButtonSideMargin = 15;
static const CGFloat kAlertButtonsBetweenMargin = 3;
static const CGFloat kAlertButtonHeight = 30;

static const CGFloat kAlertTitleLabelHeight = 30;
static const CGFloat kAlertTitleLabelTopMargin = 40;
static const CGFloat kALertDescriptionLabelTopMargin = 40;
static const CGFloat kAlertDescriptionLabelHeight = 100;

static const CGFloat kAlertTitleLabelFontSize = 24;
static const CGFloat kAlertDescriptionLabelFontSize = 16;
static const CGFloat kAlertButtonFontSize = 14;

static NSString* kAlertOKButtonNormalColor = @"#3ACAD3";
static NSString* kAlertOKButtonHighlightColor = @"#23b0b9";
static NSString* kAlertCancelButtonNormalColor = @"#F19691";
static NSString* kAlertCancelButtonHighlightColor = @"#d47671";

@implementation MODropAlertView {
    
@private
    NSString *okButtonTitleStr;
    NSString *cancelButtonTitleString;
    NSString *titleStr;
    NSString *descrptionString;
    
    UIImageView *backgroundView;
    UIView *alertView;
    
    UILabel *titleLabel;
    UILabel *descriptionLabel;
    
    UIButton *okButton;
    UIButton *cancelButton;
    
    DropAlertViewType kType;
    UIColor *okButtonColor;
    UIColor *cancelButtonColor;
    blk successBlockCallback;
    blk failureBlockCallback;
    
    UIWindow *window;
}

#pragma mark - Initialized Drop Alert Methods
- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:nil
                          okButtonColor:nil
                      cancelButtonColor:nil
                              alertType:DropAlertDefault];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:cancelButtonTitle
                          okButtonColor:nil
                      cancelButtonColor:nil
                              alertType:DropAlertDefault];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:nil
                          okButtonColor:okBtnColor
                      cancelButtonColor:nil
                              alertType:DropAlertCustom];
}
- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                     cancelButtonColor:(UIColor *)cancelBtnColor
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:cancelButtonTitle
                          okButtonColor:okBtnColor
                      cancelButtonColor:cancelBtnColor
                              alertType:DropAlertCustom];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                     cancelButtonColor:(UIColor *)cancelBtnColor
                             alertType:(DropAlertViewType)alertType
{
    self = [super init];
    if (self) {
        okButtonTitleStr = okButtonTitle;
        cancelButtonTitleString = cancelButtonTitle;
        descrptionString = description;
        titleStr = title;
        kType = alertType;
        okButtonColor = okBtnColor;
        cancelButtonColor = cancelBtnColor;
        [self initDropAlert];
    }
    return self;
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                          successBlock:(blk)successBlock
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:nil
                          okButtonColor:nil
                      cancelButtonColor:nil
                           successBlock:successBlock
                           failureBlock:nil
                              alertType:DropAlertDefault];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                          successBlock:(blk)successBlock
                          failureBlock:(blk)failureBlock
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:cancelButtonTitle
                          okButtonColor:nil
                      cancelButtonColor:nil
                           successBlock:successBlock
                           failureBlock:failureBlock
                              alertType:DropAlertDefault];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                          successBlock:(blk)successBlock
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:nil
                          okButtonColor:okButtonColor
                      cancelButtonColor:nil
                           successBlock:successBlock
                           failureBlock:nil
                              alertType:DropAlertCustom];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                     cancelButtonColor:(UIColor *)cancelBtnColor
                          successBlock:(blk)successBlock
                          failureBlock:(blk)failureBlock
{
    return [self initDropAlertWithTitle:title
                            description:description
                          okButtonTitle:okButtonTitle
                      cancelButtonTitle:cancelButtonTitle
                          okButtonColor:okButtonColor
                      cancelButtonColor:cancelButtonColor
                           successBlock:successBlock
                           failureBlock:failureBlock
                              alertType:DropAlertCustom];
}

- (instancetype)initDropAlertWithTitle:(NSString *)title
                           description:(NSString *)description
                         okButtonTitle:(NSString *)okButtonTitle
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                         okButtonColor:(UIColor *)okBtnColor
                     cancelButtonColor:(UIColor *)cancelBtnColor
                          successBlock:(blk)successBlock
                          failureBlock:(blk)failureBlock
                             alertType:(DropAlertViewType)alertType
{
    self = [super init];
    if (self) {
        okButtonTitleStr = okButtonTitle;
        cancelButtonTitleString = cancelButtonTitle;
        descrptionString = description;
        titleStr = title;
        kType = alertType;
        okButtonColor = okBtnColor;
        cancelButtonColor = cancelBtnColor;
        successBlockCallback = successBlock;
        failureBlockCallback = failureBlock;
        [self initDropAlert];
    }
    return self;
}

- (void)initDropAlert
{
    self.frame = [self mainScreenFrame];
    self.opaque = YES;
    self.backgroundColor = [UIColor clearColor];
    
    
//    [self makeBackgroundBlur];
//    [self makeAlertPopupView];
//    
//    [self makeAlertButton:cancelButtonTitleString ? YES : NO];
//    [self makeAlertTitleLabel];
//    [self makeAlertDescriptionLabel];
    
    //[self moveAlertPopupView];
}

#pragma mark - View Layout Methods
- (void)makeBackgroundBlur
{
    backgroundView = [[UIImageView alloc]initWithFrame:[self mainScreenFrame]];
    
    UIImage *image = [UIImage convertViewToImage];
    UIImage *blurSnapshotImage = nil;
    blurSnapshotImage = [image applyBlurWithRadius:5.0
                                         tintColor:[UIColor colorWithWhite:0.2
                                                                     alpha:0.7]
                             saturationDeltaFactor:1.8
                                         maskImage:nil];
    
    backgroundView.image = blurSnapshotImage;
    backgroundView.alpha = 0;
    
    [self addSubview:backgroundView];
}


- (void)makeAlertPopupViewForPresentView
{
    CGSize textSize = { 200.0, 7692.0 };
    
    CGSize listSize = [descrptionString sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:kAlertDescriptionLabelFontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize TitleSize = [titleStr sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertTitleLabelFontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect frame = CGRectMake(0, 0, 200, listSize.height+125+TitleSize.height);
    CGRect screen = [self mainScreenFrame];
    
    alertView = [[UIView alloc]initWithFrame:frame];
    
    alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 8;
    alertView.backgroundColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:102/255.0 alpha:1];
    
    [self addSubview:alertView];
    
    //    window = [UIApplication sharedApplication].windows.lastObject;
    //    [window addSubview:alertView];
    //    [window bringSubviewToFront:alertView];
}
- (void)makeAlertPopupView
{
    CGSize textSize = { 200.0, 7692.0 };
    
    CGSize listSize = [descrptionString sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:kAlertDescriptionLabelFontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize TitleSize = [titleStr sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertTitleLabelFontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];

    
    CGRect frame = CGRectMake(0, 0, 200, listSize.height+125+TitleSize.height);
    CGRect screen = [self mainScreenFrame];
    
    alertView = [[UIView alloc]initWithFrame:frame];
    
    alertView.center = CGPointMake(CGRectGetWidth(screen)/2, CGRectGetHeight(screen)/2);
    
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 8;
    alertView.backgroundColor = [UIColor colorWithRed:54/255.0 green:69/255.0 blue:102/255.0 alpha:1];
    
//    [self addSubview:alertView];
    
    window = [UIApplication sharedApplication].windows.lastObject;
    [window addSubview:alertView];
//    [window bringSubviewToFront:alertView];
}

- (void)makeAlertTitleLabel
{
    CGSize textSize = { 200.0, 7692.0 };
    CGSize TitleSize = [titleStr sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertTitleLabelFontSize] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) - kAlertButtonSideMargin, TitleSize.height)];
    titleLabel.center = CGPointMake(CGRectGetWidth(alertView.frame)/2, kAlertTitleLabelTopMargin);
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertTitleLabelFontSize];// [titleLabel.font fontWithSize:kAlertTitleLabelFontSize];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    [alertView addSubview:titleLabel];
}

- (void)makeAlertDescriptionLabel
{
    
    
    
    descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) , kAlertDescriptionLabelHeight)];
    descriptionLabel.center = CGPointMake((CGRectGetWidth(alertView.frame)/2), kAlertTitleLabelTopMargin + CGRectGetHeight(titleLabel.frame) + kALertDescriptionLabelTopMargin);
    descriptionLabel.text = descrptionString;
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:kAlertDescriptionLabelFontSize]; //[descriptionLabel.font fontWithSize:kAlertDescriptionLabelFontSize];
    
    // Line Breaking
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [descriptionLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    CGSize size = [descriptionLabel.text sizeWithFont:descriptionLabel.font
                                    constrainedToSize:CGSizeMake(180, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGRect labelFrame = descriptionLabel.frame;
    labelFrame.size.height = size.height;
    descriptionLabel.frame = labelFrame;
    
//    [descriptionLabel sizeToFit];
    
    [alertView addSubview:descriptionLabel];
}

- (void)makeAlertButton:(BOOL)hasCancelButton
{
    okButton = [[UIButton alloc]init];
    
    CALayer *btnLayer = [okButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:5.0f];

    if (hasCancelButton) {
        cancelButton = [[UIButton alloc]init];

        CALayer *btnLayer = [cancelButton layer];
        [btnLayer setMasksToBounds:YES];
        [btnLayer setCornerRadius:5.0f];
        
        [okButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertButtonFontSize]];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertButtonFontSize]];
        
        [okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        [cancelButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame)/2 - kAlertButtonSideMargin, kAlertButtonHeight)];
        
        [okButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)/4 + kAlertButtonsBetweenMargin,
                                        CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
        [cancelButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)*3/4 - kAlertButtonsBetweenMargin,
                                            CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
        
        if (cancelButtonColor) {
            [cancelButton setBackgroundImage:[UIImage imageWithColor:cancelButtonColor] forState:UIControlStateNormal];
        } else {
            [cancelButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertCancelButtonNormalColor]] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertCancelButtonHighlightColor]] forState:UIControlStateHighlighted];
        }
        
        [cancelButton setTitle:cancelButtonTitleString
                      forState:UIControlStateNormal];
        //[cancelButton.titleLabel setFont:[cancelButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
        [cancelButton addTarget:self
                         action:@selector(pressAlertButton:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self setShadowLayer:cancelButton.layer];
        
        [alertView addSubview:cancelButton];
        
    } else {
        
        [okButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertButtonFontSize]];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:kAlertButtonFontSize]];
        [okButton setFrame:CGRectMake(0, 0, CGRectGetWidth(alertView.frame) - (kAlertButtonSideMargin * 2), kAlertButtonHeight)];
        [okButton setCenter:CGPointMake(CGRectGetWidth(alertView.frame)/2, CGRectGetHeight(alertView.frame) - CGRectGetHeight(okButton.frame)/2 - kAlertButtonBottomMargin)];
    }
    [self setShadowLayer:okButton.layer];
    
    if (okButtonColor) {
        [okButton setBackgroundImage:[UIImage imageWithColor:okButtonColor] forState:UIControlStateNormal];
    } else {
        [okButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertOKButtonNormalColor]] forState:UIControlStateNormal];
        [okButton setBackgroundImage:[UIImage imageWithColor:[self colorFromHexString:kAlertOKButtonHighlightColor]] forState:UIControlStateHighlighted];
    }
    
    [okButton setTitle:okButtonTitleStr
              forState:UIControlStateNormal];
    //[okButton.titleLabel setFont:[okButton.titleLabel.font fontWithSize:kAlertButtonFontSize]];
    [okButton addTarget:self
                 action:@selector(pressAlertButton:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [alertView addSubview:okButton];
    
    [alertView bringSubviewToFront:okButton];
}

#pragma mark - View Animation Methods
- (void)moveAlertPopupView
{
    CGRect screen = [self mainScreenFrame];
    CATransform3D move = CATransform3DIdentity;
    CGFloat initAlertViewYPosition = (CGRectGetHeight(screen) + CGRectGetHeight(alertView.frame)) / 2;
    
    move = CATransform3DMakeTranslation(0, -initAlertViewYPosition, 0);
    move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    
    alertView.layer.transform = move;
}

- (void)showForPresentView
{
    [self makeBackgroundBlur];
    [self makeAlertPopupViewForPresentView];
    [self makeAlertButton:cancelButtonTitleString ? YES : NO];
    [self makeAlertTitleLabel];
    [self makeAlertDescriptionLabel];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    if( [self.delegate respondsToSelector:@selector(alertViewWillAppear:)] ) {
        [self.delegate alertViewWillAppear:self];
    }
    
    [self showAnimation];
}

- (void)show
{
    [self makeBackgroundBlur];
    [self makeAlertPopupView];
    [self makeAlertButton:cancelButtonTitleString ? YES : NO];
    [self makeAlertTitleLabel];
    [self makeAlertDescriptionLabel];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    if( [self.delegate respondsToSelector:@selector(alertViewWillAppear:)] ) {
        [self.delegate alertViewWillAppear:self];
    }
    
    [self showAnimation];
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.3f animations:^{
        backgroundView.alpha = 1.0f;
    }];
    
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         alertView.layer.transform = init;
                         
                     }
                     completion:^(BOOL finished) {
                         if( [self.delegate respondsToSelector:@selector(alertViewDidAppear:)] && finished) {
                             [self.delegate alertViewDidAppear:self];
                         }
                     }];
}

- (void)dismiss:(DropAlertButtonType)buttonType
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(alertViewWilldisappear:buttonType:)] ) {
        [self.delegate alertViewWilldisappear:self buttonType:buttonType];
    }
    
    [self dismissAnimation:buttonType];
}

- (void)dismissAnimation:(DropAlertButtonType)buttonType
{
    blk cb;
    switch (buttonType) {
        case DropAlertButtonOK:
            successBlockCallback ? cb = successBlockCallback: nil;
            break;
        case DropAlertButtonFail:
            failureBlockCallback ? cb = failureBlockCallback: nil;
        default:
            break;
    }
//    [UIView animateWithDuration:0.8f
//                          delay:0.0f
//         usingSpringWithDamping:1.0f
//          initialSpringVelocity:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//                         CGRect screen = [self mainScreenFrame];
//                         CATransform3D move = CATransform3DIdentity;
//                         CGFloat initAlertViewYPosition = CGRectGetHeight(screen);
//                         
//                         move = CATransform3DMakeTranslation(0, initAlertViewYPosition, 0);
//                         move = CATransform3DRotate(move, -40 * M_PI/180, 0, 0, 1.0f);
//                         alertView.layer.transform = move;
//                         
//                         backgroundView.alpha = 0.0;
//                     }
//                     completion:^(BOOL finished) {
//                         [self removeFromSuperview];
//                         if (cb) {
//                             cb();
//                         }
//                         else if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisappear:buttonType:)] && finished) {
//                             [self.delegate alertViewDidDisappear:self buttonType:buttonType];
//                         }
//                     }];
    
  
    [alertView removeFromSuperview];
    
    [self removeFromSuperview];
//                             if (cb) {
//                                 cb();
//                             }
//                             else if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidDisappear:buttonType:)]) {
//                                 [self.delegate alertViewDidDisappear:self buttonType:buttonType];
//                             }
}

#pragma mark - Button Methods
- (IBAction)pressAlertButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    DropAlertButtonType buttonType;
    BOOL blockFlag = false;
    
    if( [button isEqual:okButton] ) {
        NSLog(@"Pressed Button is OkButton");
        buttonType = DropAlertButtonOK;
        if (successBlockCallback) {
            blockFlag = true;
        }
    }
    else {
        NSLog(@"Pressed Button is CancelButton");
        buttonType = DropAlertButtonFail;
        if (failureBlockCallback) {
            blockFlag = true;
        }
    }
    
    if ( !blockFlag && [self.delegate respondsToSelector:@selector(alertViewPressButton:buttonType:)]) {
        [self.delegate alertViewPressButton:self buttonType:buttonType];
    }
    
    [self dismiss:buttonType];
    
}

#pragma mark - Util Methods
- (CGRect)mainScreenFrame
{
    return [UIScreen mainScreen].bounds;
}

- (void)setShadowLayer:(CALayer *)layer
{
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowRadius = 0.6;
    layer.shadowOpacity = 0.3;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end