//
//  PreviewAttachment_View.h
//  ClickIn
//
//  Created by Kabir Chandoke on 10/16/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@protocol AttachmentProtocol <NSObject>

@required
-(void)addAttachment;
-(void)cancelAttachment;
@end

@interface PreviewAttachment_View : UIView
{
    UIImageView *imgViewAttachment;
    MPMoviePlayerViewController *moviePlayerController;
}
@property (nonatomic,retain) UIImage *imgAttachment;
@property (nonatomic,readwrite) BOOL isAttachmentImage;// This bool will be yes in case the attachment is an image .
@property (nonatomic,readwrite) BOOL isFromCamera;
@property (nonatomic,retain) NSURL *videoURL;
@property (nonatomic,weak) id <AttachmentProtocol> attachmentDelegate;
@end
