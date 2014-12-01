//
//  PreviewAttachment_View.m
//  ClickIn
//
//  Created by Kabir Chandoke on 10/16/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "PreviewAttachment_View.h"

@implementation PreviewAttachment_View
@synthesize isAttachmentImage;
@synthesize imgAttachment;
@synthesize videoURL;
@synthesize attachmentDelegate;
@synthesize isFromCamera;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    // Drawing code
//    self.backgroundColor=[UIColor colorWithRed:(41/255.f) green:(47/255.f) blue:(74/255.f) alpha:1.0];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:self.frame];
    [imgView setUserInteractionEnabled:TRUE];
    if (IS_IPHONE_5)
    {
        if (isAttachmentImage)
        {
            imgView.image=[UIImage imageNamed:@"backtophotos640*1136.png" ];
        }
        else
        {
             imgView.image=[UIImage imageNamed: @"backtovideos640*1136.png"];
        }
    }
    else
    {
        if (isAttachmentImage)
        {
            imgView.image=[UIImage imageNamed:@"backtophotos640*960.png" ];
        }
        else
        {
            imgView.image=[UIImage imageNamed: @"backtovideos640*960.png"];
        }
    }
    [self addSubview:imgView];
    
    if (isFromCamera)
    {
        if (IS_IPHONE_5)
    {
         imgView.image=[UIImage imageNamed:@"backtophotosplain_640_1136.png" ];
    }
        else
        {
            imgView.image=[UIImage imageNamed:@"backtophotosplain_640_960.png" ];
        }
    }
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(10, 20, 103, 20)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
//    [btnBack setImage:[UIImage imageNamed:@"backPhotos.png"] forState:UIControlStateNormal];
    //[btnBack setBackgroundColor:[UIColor redColor]];
    //[btnBack setTitle:@"Back to photos" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBack];
    
    
    UIButton *btnCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setFrame:CGRectMake(10, self.frame.size.height - 60, 145, 50)];
    [btnCancel setImage:[UIImage imageNamed:@"cancelBtn.png"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
    
    UIButton *btnAttach=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnAttach setFrame:CGRectMake(165, self.frame.size.height - 60, 145, 50)];
    [btnAttach setImage:[UIImage imageNamed:@"attachBtn.png"] forState:UIControlStateNormal];
    [btnAttach addTarget:self action:@selector(btnAttachAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAttach];
    
    if (isAttachmentImage)
    {
        imgViewAttachment=[[UIImageView alloc] initWithImage:imgAttachment];
        imgViewAttachment.frame=CGRectMake(20, 100,280 , 350);
        imgViewAttachment.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:imgViewAttachment];
    }
    else
    {
        moviePlayerController = [[MPMoviePlayerViewController alloc] init];
        moviePlayerController.moviePlayer.view.frame=CGRectMake(20, 100, 280, 350);
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [moviePlayerController.moviePlayer setContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        [self addSubview:moviePlayerController.moviePlayer.view];
    }
}

#pragma mark custom 
-(void)btnBackAction
{
    [self removeFromSuperview];
}
-(void)btnAttachAction
{
    if ([attachmentDelegate respondsToSelector:@selector(addAttachment)])
    {
        [attachmentDelegate addAttachment];
    }
}
-(void)btnCancelAction
{
    if ([attachmentDelegate respondsToSelector:@selector(cancelAttachment)])
    {
        [attachmentDelegate cancelAttachment];
    }
}
@end

