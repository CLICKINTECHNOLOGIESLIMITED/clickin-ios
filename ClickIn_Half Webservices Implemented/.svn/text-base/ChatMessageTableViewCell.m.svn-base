//
//  ChatMessageTableViewCell.m
//  SimpleSample-chat_users-ios
//
//  Created by Ruslan on 9/21/12.
//  Copyright (c) 2012 QuickBlox. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation ChatMessageTableViewCell

@synthesize animationView;
@synthesize message;
@synthesize date;
@synthesize backgroundImageView,imageSentView,bubbleImageView,downloadingView,PhotoView;
@synthesize VideoSentView,ThumbnailPhotoView;
@synthesize cardImageView,cardAccepted,cardBottomClicks,cardContent,cardCountered,cardHeading,cardPlayed_Countered,cardRejected,cardSender,cardTopClicks,cardBarView,cardAcceptedView,shareHeading,shareBarImgView,shareBottomBarImgView,shareAccepted,shareRejected,deliveredIcon;
//@synthesize VideoWebView;
//@synthesize videoplayer;
//@synthesize slider;
@synthesize play_btn,sound_iconView,sound_bgView;
@synthesize share_btn,load_earlierBtn,LocationView,LocationSentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // create container for animations
        animationView = [[CSAnimationView alloc] initWithFrame:self.frame];
        [self.contentView addSubview:animationView];
        animationView.userInteractionEnabled=YES;
        
        
        date = [[[UILabel alloc] init] autorelease];
//        [self.date setFont:[UIFont systemFontOfSize:11.0]];
        [self.date setTextColor:[UIColor colorWithRed:(146.0/255.0) green:(146.0/255.0) blue:(146.0/255.0) alpha:1.0]];
        self.date.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:11.0];
        [animationView addSubview:self.date];
        
        backgroundImageView = [[[UIImageView alloc] init] autorelease];
        [self.backgroundImageView setFrame:CGRectZero];
        self.backgroundImageView.layer.cornerRadius = 4.0f;
		[animationView addSubview:self.backgroundImageView];
        
		message = [[[UITextView alloc] init] autorelease];
        [self.message setBackgroundColor:[UIColor whiteColor]];
        [self.message setEditable:NO];
        [self.message setScrollEnabled:NO];
		[self.message sizeToFit];
        [self.message setContentInset:UIEdgeInsetsMake(0, 0, 5,0)];
        //self.message.layer.borderWidth = 1.0f;
        //self.message.layer.borderColor = [[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0] CGColor];
        self.message.layer.cornerRadius = 4.0f;
        
		[animationView addSubview:self.message];
        
        
        shareHeading = [[[UILabel alloc] init] autorelease];
        self.shareHeading.numberOfLines = 1;
        [self.shareHeading setTextColor:[UIColor colorWithRed:(110.0/255.0) green:(129.0/255.0) blue:(146.0/255.0) alpha:1.0]];
        [self.shareHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16]];
        [animationView addSubview:self.shareHeading];
        
        self.shareBarImgView = [[[UIImageView alloc] init] autorelease];
        [self.shareBarImgView setFrame:CGRectZero];
		[animationView addSubview:self.shareBarImgView];
        
        self.shareBottomBarImgView = [[[UIImageView alloc] init] autorelease];
        [self.shareBottomBarImgView setFrame:CGRectZero];
		[animationView addSubview:self.shareBottomBarImgView];
        
        shareAccepted = [UIButton buttonWithType:UIButtonTypeCustom];
        shareAccepted.backgroundColor=[UIColor clearColor];
        [shareAccepted setFrame:CGRectZero];
        shareAccepted.imageView.contentMode=UIViewContentModeScaleAspectFit;
        shareAccepted.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.shareAccepted];
        
        shareRejected = [UIButton buttonWithType:UIButtonTypeCustom];
        shareRejected.backgroundColor=[UIColor clearColor];
        [shareRejected setFrame:CGRectZero];
        shareRejected.imageView.contentMode=UIViewContentModeScaleAspectFit;
        shareRejected.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.shareRejected];
        
        self.deliveredIcon = [[[UIImageView alloc] init] autorelease];
        [self.deliveredIcon setFrame:CGRectZero];
		[animationView addSubview:self.deliveredIcon];
        
        self.clicksImageView = [[[UIImageView alloc] init] autorelease];
        [self.clicksImageView setFrame:CGRectZero];
		[animationView addSubview:self.clicksImageView];
        
        
        PhotoView = [[[UIImageView alloc] init] autorelease];
        [self.PhotoView setFrame:CGRectZero];
        self.PhotoView.contentMode=UIViewContentModeScaleAspectFit;
        PhotoView.layer.cornerRadius = 0.0f;
      //  PhotoView.layer.borderWidth = 3.0f;
        //PhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.PhotoView];

        
        imageSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        imageSentView.backgroundColor=[UIColor clearColor];
        [imageSentView setFrame:CGRectZero];
        imageSentView.imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageSentView.contentMode=UIViewContentModeScaleAspectFill;
        imageSentView.imageView.layer.cornerRadius = 0.0f;
        //imageSentView.imageView.layer.borderWidth = 3.0f;
        //imageSentView.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.imageSentView];
        
        
        ThumbnailPhotoView = [[[UIImageView alloc] init] autorelease];
        [self.ThumbnailPhotoView setFrame:CGRectZero];
        self.ThumbnailPhotoView.contentMode=UIViewContentModeScaleAspectFit;
        ThumbnailPhotoView.layer.cornerRadius = 0.0f;
       // ThumbnailPhotoView.layer.borderWidth = 3.0f;
       // ThumbnailPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.ThumbnailPhotoView];
        
        VideoSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        VideoSentView.backgroundColor=[UIColor clearColor];
        [VideoSentView setFrame:CGRectZero];
        VideoSentView.imageView.contentMode=UIViewContentModeScaleAspectFit;
        VideoSentView.contentMode=UIViewContentModeScaleAspectFit;
        VideoSentView.imageView.layer.cornerRadius = 3.0f;
        //VideoSentView.imageView.layer.borderWidth = 0.0f;
        //VideoSentView.imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
		[animationView addSubview:self.VideoSentView];
        
//        videoplayer = [[MPMoviePlayerController alloc] init];
//        videoplayer.shouldAutoplay = NO;
//        videoplayer.scalingMode=MPMovieScalingModeAspectFill;
//        videoplayer.view.frame=CGRectZero;
//        [self.contentView addSubview:self.videoplayer.view];
//        videoplayer.movieSourceType=MPMovieSourceTypeStreaming;
        
        /*VideoWebView = [[UIWebView alloc] init];
        VideoWebView.autoresizesSubviews = YES;
        VideoWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
       [self.contentView addSubview:self.VideoWebView];*/
        
        /*slider = [[UISlider alloc] initWithFrame:CGRectZero];
        [slider setBackgroundColor:[UIColor lightGrayColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 50.0;
        slider.continuous = YES;
        slider.value = 0.0;
        [slider setThumbImage: [[[UIImage alloc] init] autorelease] forState:UIControlStateNormal];
        [self.contentView addSubview:self.slider];*/
        
        sound_bgView = [[[UIImageView alloc] init] autorelease];
        [self.sound_bgView setFrame:CGRectZero];
        sound_bgView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        sound_bgView.contentMode=UIViewContentModeScaleAspectFit;
        sound_bgView.layer.cornerRadius = 0.0f;
        //sound_bgView.layer.borderWidth = 3.0f;
        //sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.sound_bgView];
        
        play_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        play_btn.backgroundColor=[UIColor clearColor];
        [play_btn setFrame:CGRectZero];
        play_btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        play_btn.contentMode=UIViewContentModeScaleAspectFit;
        play_btn.imageView.layer.cornerRadius = 3.0f;
        play_btn.imageView.layer.borderWidth = 0.0f;
        play_btn.imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
		[animationView addSubview:self.play_btn];
        
        sound_iconView = [[[UIImageView alloc] init] autorelease];
        [self.sound_iconView setFrame:CGRectZero];
        sound_iconView.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.sound_iconView];
        
        
        LocationView = [[[UIImageView alloc] init] autorelease];
        [self.LocationView setFrame:CGRectZero];
        self.LocationView.contentMode=UIViewContentModeScaleAspectFit;
        LocationView.layer.cornerRadius = 0.0f;
       // LocationView.layer.borderWidth = 3.0f;
       // LocationView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.LocationView];
        
        
        LocationSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        LocationSentView.backgroundColor=[UIColor clearColor];
        [LocationSentView setFrame:CGRectZero];
        LocationSentView.imageView.contentMode=UIViewContentModeScaleAspectFill;
        LocationSentView.contentMode=UIViewContentModeScaleAspectFill;
        LocationSentView.imageView.layer.cornerRadius = 0.0f;
       // LocationSentView.imageView.layer.borderWidth = 3.0f;
      //  LocationSentView.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[animationView addSubview:self.LocationSentView];
        
        
        share_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        share_btn.backgroundColor=[UIColor clearColor];
        [share_btn setFrame:CGRectZero];
        share_btn.imageView.contentMode=UIViewContentModeScaleAspectFit;
        share_btn.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.share_btn];
        
        load_earlierBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        load_earlierBtn.frame = CGRectZero;
        load_earlierBtn.backgroundColor=[UIColor clearColor];
        [animationView addSubview:load_earlierBtn];
        
        cardImageView = [[[UIImageView alloc] init] autorelease];
        [self.cardImageView setFrame:CGRectZero];
		[animationView addSubview:self.cardImageView];
        
        cardHeading = [[[UILabel alloc] init] autorelease];
        cardHeading.numberOfLines=2;
        cardHeading.textAlignment=NSTextAlignmentCenter;
        [self.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
        [animationView addSubview:self.cardHeading];
        
        cardContent = [[[UILabel alloc] init] autorelease];
        [self.cardContent setFrame:CGRectZero];
        cardContent.numberOfLines=2;
        cardContent.textAlignment=NSTextAlignmentCenter;
        cardContent.textColor=[UIColor whiteColor];
        [cardContent setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12]];
        [animationView addSubview:self.cardContent];
        
        cardTopClicks = [[[UILabel alloc] init] autorelease];
        cardTopClicks.textAlignment=NSTextAlignmentCenter;
        [self.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardTopClicks setTextColor:[UIColor whiteColor]];
        [animationView addSubview:self.cardTopClicks];
        
        cardBottomClicks = [[[UILabel alloc] init] autorelease];
        cardBottomClicks.textAlignment=NSTextAlignmentCenter;
        [self.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardBottomClicks setTextColor:[UIColor whiteColor]];
        [animationView addSubview:self.cardBottomClicks];
        
        cardSender = [[[UILabel alloc] init] autorelease];
        [self.cardSender setFrame:CGRectZero];
        cardSender.textAlignment=NSTextAlignmentLeft;
        cardSender.numberOfLines = 1;
        cardSender.textColor=[UIColor blackColor];
        [cardSender setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]];
        [animationView addSubview:self.cardSender];
        
        cardPlayed_Countered = [[[UILabel alloc] init] autorelease];
        [self.cardPlayed_Countered setFrame:CGRectZero];
        cardPlayed_Countered.textColor=[UIColor blackColor];
        cardPlayed_Countered.textAlignment=NSTextAlignmentLeft;
        [cardPlayed_Countered setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [animationView addSubview:self.cardPlayed_Countered];
        
        cardBarView = [[[UIImageView alloc] init] autorelease];
        [self.cardBarView setFrame:CGRectZero];
		[animationView addSubview:self.cardBarView];
        
        cardAccepted = [UIButton buttonWithType:UIButtonTypeCustom];
        cardAccepted.backgroundColor=[UIColor clearColor];
        [cardAccepted setFrame:CGRectZero];
        cardAccepted.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardAccepted.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.cardAccepted];
        
        cardRejected = [UIButton buttonWithType:UIButtonTypeCustom];
        cardRejected.backgroundColor=[UIColor clearColor];
        [cardRejected setFrame:CGRectZero];
        cardRejected.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardRejected.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.cardRejected];
        
        cardCountered = [UIButton buttonWithType:UIButtonTypeCustom];
        cardCountered.backgroundColor=[UIColor clearColor];
        [cardCountered setFrame:CGRectZero];
        cardCountered.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardCountered.contentMode=UIViewContentModeScaleAspectFit;
		[animationView addSubview:self.cardCountered];
        
        cardAcceptedView = [[[UIImageView alloc] init] autorelease];
        [self.cardAcceptedView setFrame:CGRectZero];
		[animationView addSubview:self.cardAcceptedView];
        
        self.downloadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.downloadingView.autoresizingMask = UIViewAutoresizingNone;
        //self.downloadingView.frame=CGRectZero;
        self.downloadingView.hidesWhenStopped = YES;
        self.downloadingView.tag=4444;
        [animationView addSubview:self.downloadingView];
        
        bubbleImageView = [[[UIImageView alloc] init] autorelease];
        [self.bubbleImageView setFrame:CGRectZero];
		[animationView addSubview:self.bubbleImageView];
        
    }
    return self;
}

@end
