//
//  NewsfeedTableViewCell.m
//  ClickIn
//
//  Created by Dinesh Gulati on 27/01/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "NewsfeedTableViewCell.h"

@implementation NewsfeedTableViewCell
@synthesize message;
@synthesize imageSentView,PhotoView,LocationView,LocationSentView;
@synthesize VideoSentView,ThumbnailPhotoView;
@synthesize cardImageView,cardAccepted,cardBottomClicks,cardContent,cardCountered,cardHeading,cardPlayed_Countered,cardRejected,cardSender,cardTopClicks,cardBarView,cardAcceptedView;
@synthesize play_btn,sound_iconView,sound_bgView;
@synthesize load_earlierBtn;
@synthesize LblLeftSideName,LblRightSideName,clicksImageView,LblLeftSideTime,LblRightSideTime;
@synthesize topBarImgView,bottomBarImgView,feedCountImgView,feedStarImgView,footerImgView,commentCount,starCount,commentButton,starButton,markStarredButton,reportButton,reportImgView,comment1,comment2,comment3,viewAllCommentsBtn,reportInapproriateBtn,removeNewsfeedBtn;
@synthesize load_more,activitySpinner;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.NextIconArrowImage = [[[UIImageView alloc] init] autorelease];
        self.NextIconArrowImage.backgroundColor = [UIColor clearColor];
        [self.NextIconArrowImage setFrame:CGRectZero];
        self.NextIconArrowImage.contentMode=UIViewContentModeScaleAspectFit;
        self.NextIconArrowImage.layer.cornerRadius = 0.0f;
        self.NextIconArrowImage.layer.borderWidth = 0.0f;
		[self.contentView addSubview:self.NextIconArrowImage];
        
        self.LeftsideUIImageView = [[[UIImageView alloc] init] autorelease];
        self.LeftsideUIImageView.backgroundColor = [UIColor lightGrayColor];
        [self.LeftsideUIImageView setFrame:CGRectZero];
//        self.LeftsideUIImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.LeftsideUIImageView.layer.cornerRadius = 0.0f;
        self.LeftsideUIImageView.layer.borderWidth = 0.0f;
        self.LeftsideUIImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.LeftsideUIImageView];
        
        self.RightSideUIImageView = [[[UIImageView alloc] init] autorelease];
        self.RightSideUIImageView.backgroundColor = [UIColor lightGrayColor];
        [self.RightSideUIImageView setFrame:CGRectZero];
//        self.RightSideUIImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.RightSideUIImageView.layer.cornerRadius = 0.0f;
        self.RightSideUIImageView.layer.borderWidth = 0.0f;
        self.RightSideUIImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.RightSideUIImageView];
        
        self.topBarImgView = [[[UIImageView alloc] init] autorelease];
        self.topBarImgView.backgroundColor = [UIColor clearColor];
        [self.topBarImgView setFrame:CGRectZero];
        self.topBarImgView.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.topBarImgView];
        
        self.bottomBarImgView = [[[UIImageView alloc] init] autorelease];
        self.bottomBarImgView.backgroundColor = [UIColor clearColor];
        [self.bottomBarImgView setFrame:CGRectZero];
        self.bottomBarImgView.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.bottomBarImgView];
        
        
        self.feedCountImgView = [[[UIImageView alloc] init] autorelease];
        self.feedCountImgView.backgroundColor = [UIColor clearColor];
        [self.feedCountImgView setFrame:CGRectZero];
        self.feedCountImgView.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.feedCountImgView];
        
        self.feedStarImgView = [[[UIImageView alloc] init] autorelease];
        self.feedStarImgView.backgroundColor = [UIColor clearColor];
        [self.feedStarImgView setFrame:CGRectZero];
        self.feedStarImgView.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.feedStarImgView];
        
        self.footerImgView = [[[UIImageView alloc] init] autorelease];
        self.footerImgView.backgroundColor = [UIColor clearColor];
        [self.footerImgView setFrame:CGRectZero];
        self.footerImgView.contentMode=UIViewContentModeScaleToFill;
		[self.contentView addSubview:self.footerImgView];
        
        
        commentCount = [[[UILabel alloc] init] autorelease];
        [self.commentCount setFrame:CGRectZero];
        commentCount.numberOfLines=1;
        commentCount.textAlignment=NSTextAlignmentLeft;
        [commentCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
        [commentCount setTextColor:[UIColor colorWithRed:115/255.0 green:119/255.0 blue:118/255.0 alpha:1]];
        [self.contentView addSubview:self.commentCount];
        
        starCount = [[[UILabel alloc] init] autorelease];
        [self.starCount setFrame:CGRectZero];
        starCount.numberOfLines=0;
        starCount.textAlignment=NSTextAlignmentLeft;
        
        [starCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
        [starCount setTextColor:[UIColor colorWithRed:115/255.0 green:119/255.0 blue:118/255.0 alpha:1]];
        [self.contentView addSubview:self.starCount];
        
        
        comment1 = [[[UILabel alloc] init] autorelease];
        [self.comment1 setFrame:CGRectZero];
        comment1.numberOfLines=0;
        comment1.textAlignment=NSTextAlignmentLeft;
        [comment1 setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
        [comment1 setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.comment1];
        
        comment2 = [[[UILabel alloc] init] autorelease];
        [self.comment2 setFrame:CGRectZero];
        comment2.numberOfLines=0;
        comment2.textAlignment=NSTextAlignmentLeft;
        [comment2 setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
        [comment2 setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.comment2];
        
        comment3 = [[[UILabel alloc] init] autorelease];
        [self.comment3 setFrame:CGRectZero];
        comment3.numberOfLines=0;
        comment3.textAlignment=NSTextAlignmentLeft;
        [comment3 setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
        [comment3 setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:self.comment3];
        
        viewAllCommentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewAllCommentsBtn.backgroundColor=[UIColor clearColor];
        [viewAllCommentsBtn setFrame:CGRectZero];
        [self.contentView addSubview:self.viewAllCommentsBtn];
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.backgroundColor=[UIColor clearColor];
        [commentButton setFrame:CGRectZero];
        [self.contentView addSubview:self.commentButton];
        
        starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        starButton.backgroundColor=[UIColor clearColor];
        [starButton setFrame:CGRectZero];
        [self.contentView addSubview:self.starButton];

        markStarredButton = [UIButton buttonWithType:UIButtonTypeCustom];
        markStarredButton.backgroundColor=[UIColor clearColor];
        [markStarredButton setFrame:CGRectZero];
        [self.contentView addSubview:self.markStarredButton];
        
        reportImgView = [[[UIImageView alloc] init] autorelease];
        reportImgView.backgroundColor = [UIColor clearColor];
        [reportImgView setFrame:CGRectZero];
        reportImgView.image = [UIImage imageNamed:@"3_dot.png"];
        reportImgView.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:reportImgView];
        
        reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reportButton.backgroundColor=[UIColor clearColor];
        [reportButton setFrame:CGRectZero];
        [self.contentView addSubview:self.reportButton];
        
        reportInapproriateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reportInapproriateBtn.backgroundColor=[UIColor clearColor];
        [reportInapproriateBtn setFrame:CGRectZero];
        [self.contentView addSubview:self.reportInapproriateBtn];
        
        removeNewsfeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeNewsfeedBtn.backgroundColor=[UIColor clearColor];
        [removeNewsfeedBtn setFrame:CGRectZero];
        [self.contentView addSubview:self.removeNewsfeedBtn];

        
        
        LblLeftSideName = [[[UILabel alloc] init] autorelease];
        [self.LblLeftSideName setFrame:CGRectZero];
        LblLeftSideName.numberOfLines=1;
        LblLeftSideName.textAlignment=NSTextAlignmentCenter;
        [LblLeftSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:17]];
        [LblLeftSideName setTextColor:[UIColor colorWithRed:79/255.0 green:194/255.0 blue:210/255.0 alpha:1]];
        [self.contentView addSubview:self.LblLeftSideName];
        
        LblRightSideName = [[[UILabel alloc] init] autorelease];
        [self.LblRightSideName setFrame:CGRectZero];
        LblRightSideName.numberOfLines=1;
        LblRightSideName.textAlignment=NSTextAlignmentCenter;
        [LblRightSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:17]];
        [LblRightSideName setTextColor:[UIColor colorWithRed:131/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
        [self.contentView addSubview:self.LblRightSideName];
        
        LblLeftSideTime = [[[UILabel alloc] init] autorelease];
        [self.LblLeftSideTime setFrame:CGRectZero];
        LblLeftSideTime.numberOfLines=1;
        LblLeftSideTime.textAlignment=NSTextAlignmentLeft;
        [LblLeftSideTime setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:10]];
        [LblLeftSideTime setTextColor:[UIColor colorWithRed:(148.0/255.0) green:(148.0/255.0) blue:(148.0/255.0) alpha:1]];
        [self.contentView addSubview:self.LblLeftSideTime];
        
        self.LblRightSideTime = [[[UILabel alloc] init] autorelease];
        [self.LblRightSideTime setFrame:CGRectZero];
        self.LblRightSideTime.numberOfLines=1;
        self.LblRightSideTime.textAlignment=NSTextAlignmentRight;
        [self.LblRightSideTime setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:10]];
        [self.LblRightSideTime setTextColor:[UIColor colorWithRed:(148.0/255.0) green:(148.0/255.0) blue:(148.0/255.0) alpha:1]];
        [self.contentView addSubview:self.LblRightSideTime];
        
        message = [[[UITextView alloc] init] autorelease];
        [self.message setBackgroundColor:[UIColor whiteColor]];
        [self.message setEditable:NO];
        [self.message setScrollEnabled:NO];
		[self.message sizeToFit];
        [self.message setContentInset:UIEdgeInsetsMake(0, 0, 5,0)];
        //self.message.layer.borderWidth = 1.0f;
        //self.message.layer.borderColor = [[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0] CGColor];
        self.message.layer.cornerRadius = 0.0f;
        
		[self.contentView addSubview:self.message];
        
        self.clicksImageView = [[[UIImageView alloc] init] autorelease];
        [self.clicksImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.clicksImageView];
        PhotoView = [[[UIImageView alloc] init] autorelease];
        [self.PhotoView setFrame:CGRectZero];
        self.PhotoView.contentMode=UIViewContentModeScaleAspectFit;
        PhotoView.layer.cornerRadius = 0.0f;
        PhotoView.layer.borderWidth = 3.0f;
        PhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.PhotoView];
        imageSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        imageSentView.backgroundColor=[UIColor clearColor];
        [imageSentView setFrame:CGRectZero];
        imageSentView.imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageSentView.contentMode=UIViewContentModeScaleAspectFill;
        imageSentView.imageView.layer.cornerRadius = 0.0f;
        imageSentView.imageView.layer.borderWidth = 3.0f;
        imageSentView.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.imageSentView];
        
        
        ThumbnailPhotoView = [[[UIImageView alloc] init] autorelease];
        [self.ThumbnailPhotoView setFrame:CGRectZero];
        self.ThumbnailPhotoView.contentMode=UIViewContentModeScaleToFill;
        ThumbnailPhotoView.layer.cornerRadius = 0.0f;
        ThumbnailPhotoView.layer.borderWidth = 3.0f;
        ThumbnailPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.ThumbnailPhotoView];
        
        VideoSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        VideoSentView.backgroundColor=[UIColor clearColor];
        [VideoSentView setFrame:CGRectZero];
        VideoSentView.imageView.contentMode=UIViewContentModeScaleAspectFit;
        VideoSentView.contentMode=UIViewContentModeScaleAspectFit;
        VideoSentView.imageView.layer.cornerRadius = 3.0f;
        VideoSentView.imageView.layer.borderWidth = 0.0f;
        VideoSentView.imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
		[self.contentView addSubview:self.VideoSentView];
        sound_bgView = [[[UIImageView alloc] init] autorelease];
        [self.sound_bgView setFrame:CGRectZero];
        sound_bgView.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        sound_bgView.contentMode=UIViewContentModeScaleAspectFit;
        sound_bgView.layer.cornerRadius = 0.0f;
        sound_bgView.layer.borderWidth = 3.0f;
        sound_bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.sound_bgView];
        
        LocationView = [[[UIImageView alloc] init] autorelease];
        [self.LocationView setFrame:CGRectZero];
        self.LocationView.contentMode=UIViewContentModeScaleAspectFit;
        LocationView.layer.cornerRadius = 0.0f;
        LocationView.layer.borderWidth = 3.0f;
        LocationView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.LocationView];
        
        
        LocationSentView = [UIButton buttonWithType:UIButtonTypeCustom];
        LocationSentView.backgroundColor=[UIColor clearColor];
        [LocationSentView setFrame:CGRectZero];
        LocationSentView.imageView.contentMode=UIViewContentModeScaleAspectFill;
        LocationSentView.contentMode=UIViewContentModeScaleAspectFill;
        LocationSentView.imageView.layer.cornerRadius = 0.0f;
        LocationSentView.imageView.layer.borderWidth = 3.0f;
        LocationSentView.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		[self.contentView addSubview:self.LocationSentView];
        
        play_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        play_btn.backgroundColor=[UIColor clearColor];
        [play_btn setFrame:CGRectZero];
        play_btn.imageView.contentMode=UIViewContentModeScaleAspectFill;
        play_btn.contentMode=UIViewContentModeScaleAspectFit;
        play_btn.imageView.layer.cornerRadius = 3.0f;
        play_btn.imageView.layer.borderWidth = 0.0f;
        play_btn.imageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
		[self.contentView addSubview:self.play_btn];
        
        sound_iconView = [[[UIImageView alloc] init] autorelease];
        [self.sound_iconView setFrame:CGRectZero];
        sound_iconView.contentMode=UIViewContentModeScaleAspectFill;
		[self.contentView addSubview:self.sound_iconView];
        
        load_earlierBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        load_earlierBtn.frame = CGRectZero;
        load_earlierBtn.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:load_earlierBtn];
        
        cardImageView = [[[UIImageView alloc] init] autorelease];
        [self.cardImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.cardImageView];
        
        cardHeading = [[[UILabel alloc] init] autorelease];
        cardHeading.numberOfLines=2;
        cardHeading.textAlignment=NSTextAlignmentCenter;
        [self.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
        [self.contentView addSubview:self.cardHeading];
        
        cardContent = [[[UILabel alloc] init] autorelease];
        [self.cardContent setFrame:CGRectZero];
        cardContent.numberOfLines=2;
        cardContent.textAlignment=NSTextAlignmentCenter;
        cardContent.textColor=[UIColor whiteColor];
        [cardContent setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12]];
        [self.contentView addSubview:self.cardContent];
        
        cardTopClicks = [[[UILabel alloc] init] autorelease];
        cardTopClicks.textAlignment=NSTextAlignmentCenter;
        [self.cardTopClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardTopClicks setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.cardTopClicks];
        
        cardBottomClicks = [[[UILabel alloc] init] autorelease];
        cardBottomClicks.textAlignment=NSTextAlignmentCenter;
        [self.cardBottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.cardBottomClicks setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.cardBottomClicks];
        
        cardSender = [[[UILabel alloc] init] autorelease];
        [self.cardSender setFrame:CGRectZero];
        cardSender.textAlignment=NSTextAlignmentLeft;
        cardSender.textColor=[UIColor blackColor];
        [cardSender setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]];
        [self.contentView addSubview:self.cardSender];
        
        cardPlayed_Countered = [[[UILabel alloc] init] autorelease];
        [self.cardPlayed_Countered setFrame:CGRectZero];
        cardPlayed_Countered.textColor=[UIColor blackColor];
        cardPlayed_Countered.textAlignment=NSTextAlignmentLeft;
        [cardPlayed_Countered setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
        [self.contentView addSubview:self.cardPlayed_Countered];
        
        cardBarView = [[[UIImageView alloc] init] autorelease];
        [self.cardBarView setFrame:CGRectZero];
		[self.contentView addSubview:self.cardBarView];
        
        cardAccepted = [UIButton buttonWithType:UIButtonTypeCustom];
        cardAccepted.backgroundColor=[UIColor clearColor];
        [cardAccepted setFrame:CGRectZero];
        cardAccepted.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardAccepted.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.cardAccepted];
        
        cardRejected = [UIButton buttonWithType:UIButtonTypeCustom];
        cardRejected.backgroundColor=[UIColor clearColor];
        [cardRejected setFrame:CGRectZero];
        cardRejected.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardRejected.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.cardRejected];
        
        cardCountered = [UIButton buttonWithType:UIButtonTypeCustom];
        cardCountered.backgroundColor=[UIColor clearColor];
        [cardCountered setFrame:CGRectZero];
        cardCountered.imageView.contentMode=UIViewContentModeScaleAspectFit;
        cardCountered.contentMode=UIViewContentModeScaleAspectFit;
		[self.contentView addSubview:self.cardCountered];
        
        cardAcceptedView = [[[UIImageView alloc] init] autorelease];
        [self.cardAcceptedView setFrame:CGRectZero];
		[self.contentView addSubview:self.cardAcceptedView];
        
        
        load_more = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 5, 320, 20))];
        load_more.textColor = [UIColor blackColor];
        load_more.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
        load_more.backgroundColor = [UIColor clearColor];
        // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
        load_more.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:15.0];
        load_more.lineBreakMode = YES;
        load_more.numberOfLines = 1;
        load_more.text = @"Loading more...";
        load_more.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:load_more];
        
        activitySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activitySpinner.frame = CGRectMake(70, 6, 20, 20);
        activitySpinner.hidesWhenStopped = YES;
        [self.contentView addSubview:activitySpinner];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
