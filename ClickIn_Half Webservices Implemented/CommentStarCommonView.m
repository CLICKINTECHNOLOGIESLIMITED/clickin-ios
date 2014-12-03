//
//  CommentStarCommonView.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 07/07/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "CommentStarCommonView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "NewsfeedTableViewCell.h"
#import "StarredViewController.h"
#import "CommentsViewController.h"
#import "HPGrowingTextView.h"

@interface CommentStarCommonView ()

@end

@implementation CommentStarCommonView

@synthesize  isNotificationSelected,selectedNewsfeed,newsfeedID,LblComments,isViewPushed;

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
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(NotificationReceived:)
     name:Notification_NewsfeedByID
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(StarredNotificationReceived:)
     name:Notification_NewsfeedUserStarred
     object:nil];
    
    usersArray = [[NSMutableArray alloc] init];
    
    //sendMessageField.delegate = self;
    
    padding = 2;
    
    LblComments.font=[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18];
    
    //screen bg
    UIImageView *screen_bg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (IS_IPHONE_5) {
        screen_bg.frame=CGRectMake(0, 0, 320, 568);
    }
    screen_bg.image=[UIImage imageNamed:@"background1140.png"];
    [self.view addSubview:screen_bg];
    
    [self.view sendSubviewToBack:screen_bg];
    
    /*
     // notifications text
     notification_text = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(15, 240, 30, 22))];
     notification_text.textColor = [UIColor whiteColor];
     notification_text.center=CGPointMake(298, 21);
     notification_text.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
     notification_text.tag = 5;
     notification_text.backgroundColor = [UIColor clearColor];
     // header_text = [UIFont fontWithName:@"Halvetica" size:10];
     notification_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
     notification_text.lineBreakMode = YES;
     notification_text.numberOfLines = 0;
     notification_text.lineBreakMode = NSLineBreakByTruncatingTail;
     notification_text.text=@"0";
     [self.view addSubview:notification_text];
     
     //notification btn
     notificationsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [notificationsBtn addTarget:self
     action:@selector(notificationBtnPressed)
     forControlEvents:UIControlEventTouchDown];
     notificationsBtn.backgroundColor = [UIColor clearColor];
     notificationsBtn.frame =CGRectMake(320-70, 0, 70, 45);
     [self.view addSubview:notificationsBtn];*/
    
    
    if([isNotificationSelected isEqualToString:@"true"])
    {
        //self.followingIDS = [[NSMutableArray alloc] init];
        
        [self performSelector:@selector(customViewDidLoad) withObject:nil afterDelay:0.1];
        //        [self.view sendSubviewToBack:self.txtFieldBackgroundView];
        //        [self.view sendSubviewToBack:self.txtFieldBoxView];
        //        [self.view sendSubviewToBack:self.sendMessageField];
        [self.view sendSubviewToBack:containerView];
    }
    else
    {
        
        table=[[UITableView alloc] initWithFrame:CGRectMake(2.5f, 55, 315, 480-60) style:UITableViewStylePlain];
        if(IS_IPHONE_5)
            table.frame=CGRectMake(2.5f,55, 315, 568-60);
        table.backgroundColor = [UIColor clearColor];
        //table_feeds.allowsSelection=NO;
        //table.userInteractionEnabled=YES;
        table.delegate=self;
        table.dataSource=self;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.view addSubview:table];
        //table.bounces=NO;
        //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
        //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        //[table setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 60)];
        table.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        //if(activity==nil)
        //activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        //[activity show];
    }
    
    
    if(activity==nil)
        activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    
}

#pragma mark Notifications received
- (void)NotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [table reloadData];
    [self.view bringSubviewToFront:table];
    //[self.view bringSubviewToFront:containerView];
    [activity hide];
}

- (void)StarredNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    // reload table data
    [table reloadData];
    [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


-(void)customViewDidLoad
{
    //fetch followings
    //[self getfollowinglist];
    //fetch newsfeed
    [selectedNewsfeed getNewsfeedByID:YES];
    //[self CallGetNewsfeedWebservice];
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 55, 320, 480-60) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(0,55, 320, 568-60);
    table.backgroundColor = [UIColor clearColor];
    //table_feeds.allowsSelection=NO;
    //table.userInteractionEnabled=YES;
    table.delegate=self;
    table.dataSource=self;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:table];
    
    //send view elements to back till the comments come from webservice
    //[self.view sendSubviewToBack:table];
    
    
    
    //table.bounces=NO;
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    //[table setSeparatorColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.0]];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //[table setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 60)];
    table.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    //if(activity==nil)
    //  activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    //[activity show];
    
    //[self performSelector:@selector(fetchCommentsUsersWebService) withObject:nil afterDelay:0];
    //[selectedNewsfeed getNewsfeedComments:YES];
}

#pragma mark -
#pragma mark - UIBarButtonItem Callbacks

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


-(void)notificationBtnPressed
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
        
    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    //[self getprofileinfo];
    
    [selectedNewsfeed getNewsfeedByID:NO];
    //[selectedNewsfeed getNewsfeedComments:YES];
    
    if(![isNotificationSelected isEqualToString:@"true"])
    {
        if(activity==nil)
            activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
        [activity show];
        
        [selectedNewsfeed getNewsfeedComments:YES];
    }
    
}



-(void)getprofileinfo
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //NSError *error;
    
    //NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    //
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //[request appendPostData:jsonData];
    [request setDidFinishSelector:@selector(requestFinished_notify:)];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}


- (void)requestFinished_notify:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User details found."] || success)
        {
            //notification count set
            notification_text.text=[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]];
            
            if([notification_text.text isEqualToString:@"0"])
                notification_text.textColor = [UIColor colorWithRed:(52.0/255.0) green:(63.0/255.0) blue:(96.0/255.0) alpha:1.0];
            else
                notification_text.textColor = [UIColor colorWithRed:(80/255.0) green:(202/255.0) blue:(210/255.0) alpha:1.0];
            
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.unreadNotificationsCount = [notification_text.text integerValue];
            appDelegate = nil;
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:errorl.description
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
    }
}

-(void)commentBtnPressed:(UIButton*)sender
{
    CommentsViewController *obj=[[CommentsViewController alloc] init];
    obj.newsfeedID = self.newsfeedID;
    obj.selectedNewsfeed = [[Newsfeed alloc] init];
    obj.selectedNewsfeed.newsfeedID = self.newsfeedID;
    obj.isNotificationSelected = @"false";
    
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;
}



-(void)starBtnPressed:(UIButton*)sender
{
    StarredViewController *obj=[[StarredViewController alloc] init];
    //obj.newsfeedID = selectedNewsfeed.newsfeedID ;
    obj.selectedNewsfeed = selectedNewsfeed;
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;
}


-(void)playAudio:(id)sender
{
    
}

-(void)showFullScreenVideo:(id)sender
{
    
}


-(void)showFullScreenPicture:(id)sender
{
    
}


-(void)reportBtnPressed:(UIButton*)sender
{
    NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    //NSIndexPath *indexPath = [table indexPathForCell:cell];
    if(selectedNewsfeed.showReportBtns)
    {
        selectedNewsfeed.showReportBtns = false;
        cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
    }
    else
    {
        selectedNewsfeed.showReportBtns = true;
        cell.reportImgView.contentMode=UIViewContentModeScaleAspectFill;
    }
    [table reloadData];
}

-(void)removeNewsfeedBtnPressed:(UIButton*)sender
{
    
}

-(void)reportInappBtnPressed:(UIButton*)sender
{
    NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
    //NSIndexPath *indexPath = [table indexPathForCell:cell];
    
    [selectedNewsfeed reportNewsfeedInappropriate];
    
    selectedNewsfeed.showReportBtns = false;
    cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
    
    [table reloadData];
}


-(void)markStarredBtnPressed:(UIButton*)sender
{
    // [selectedNewsfeed addStarredUser];
    
    // [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIImage *CurrentImage = sender.currentImage;
    
    if(CurrentImage == [UIImage imageNamed:@"star_grey_btn.png"])
    {
        NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        [selectedNewsfeed addStarredUser];
        
        
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"],@"user_name", nil];
        [selectedNewsfeed.starredArrayNewsfeedPage addObject:Dictionary];
        
        [table reloadData];
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [sender setImage:[UIImage imageNamed:@"star_pink_btn.png"] forState:UIControlStateNormal];
    }
    else
    {
        //unstarr feed
        NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[[[sender superview] superview] superview];
        NSIndexPath *indexPath = [table indexPathForCell:cell];
        [selectedNewsfeed removeStarredUser];
        
        
        for(int i=0;i<selectedNewsfeed.starredArrayNewsfeedPage.count;i++)
        {
            if([[[selectedNewsfeed.starredArrayNewsfeedPage objectAtIndex:i] objectForKey:@"user_name"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"user_name"]])
            {
                [selectedNewsfeed.starredArrayNewsfeedPage removeObjectAtIndex:i];
                break;
            }
        }
        
        [table reloadData];
        [table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [sender setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
    }
    
}


#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if([isNotificationSelected isEqualToString:@"false"])
            return 0;
        
        
        int index=0;
        QBChatMessage *chatMessage;
        CGSize size;
        if(index == 1)
        {
            if(indexPath.row == 0)
            {
                return 50;
            }
            else
            {
                chatMessage = (QBChatMessage *)selectedNewsfeed.message ;
            }
        }
        else
        {
            chatMessage = (QBChatMessage *)selectedNewsfeed.message ;
        }
        
        NSString *text = chatMessage.text;
        CGSize textSize = { 316.0, 12153.85 };
        
        
        if((chatMessage.text == (NSString*)[NSNull null] && [chatMessage.customParameters[@"card_heading"] length]==0) || ([chatMessage.text isEqualToString:@""] && [chatMessage.customParameters[@"card_heading"] length]==0))
            size = CGSizeZero;
        else
        {
            size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16]
                    constrainedToSize:textSize
                        lineBreakMode:NSLineBreakByWordWrapping];
            size.height += padding;
        }
        
        if([chatMessage.customParameters[@"fileID"] length]>1 || [chatMessage.customParameters[@"locationID"] length]>1)
        {
            float imageHeight = 316/[chatMessage.customParameters[@"imageRatio"] floatValue];
            /*if(imageHeight<=125)
             size.height += 125;
             else*/
            if(chatMessage.customParameters[@"imageRatio"] == [NSNull null] || chatMessage.customParameters[@"imageRatio"]==nil)
                size.height += 125;
            else
                size.height += imageHeight;
        }
        
        if([chatMessage.customParameters[@"videoID"]  length]>0)
        {
            size.height += 259;
        }
        
        if([chatMessage.customParameters[@"audioID"]  length]>0)
        {
            size.height += 155;
        }
        
        if([chatMessage.customParameters[@"card_heading"] length]>0)
        {
            size.height += 115;
        }
        
        if(selectedNewsfeed.commentsArrayNewsfeedPage.count==1)
        {
            comments_offsetY = 20;
        }
        else if(selectedNewsfeed.commentsArrayNewsfeedPage.count==2)
        {
            comments_offsetY = 10;
        }
        else if([selectedNewsfeed.commentCount integerValue]>3)
        {
            comments_offsetY = -4;
        }
        else if(selectedNewsfeed.commentsArrayNewsfeedPage.count>2)
        {
            comments_offsetY = 0;
        }
        else
        {
            comments_offsetY = 24;
        }
        
        
        return size.height+padding+140 + 40 - comments_offsetY + 74;
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifiersection0 = @"CellforsectionTop";
    
    
        if([isNotificationSelected isEqualToString:@"true"])
        {
            
            NewsfeedTableViewCell *cell = (NewsfeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifiersection0];
            if (cell == nil) {
                cell = [[NewsfeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifiersection0];
            }
            
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = YES;
            cell.contentView.userInteractionEnabled=YES;
            
            cell.load_more.frame = CGRectZero;
            cell.activitySpinner.frame = CGRectZero;
            
            
            
            int index=0;
            
            [cell.LeftsideUIImageView setFrame:CGRectMake(2 , 12, 50, 50)];
            [cell.LblLeftSideName setFrame:CGRectMake(56 , 9, 95, 28)];
            cell.LblLeftSideName.numberOfLines=1;
            cell.LblLeftSideName.textAlignment=NSTextAlignmentLeft;
            [cell.LblLeftSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:17]];
            [cell.LblLeftSideName setTextColor:[UIColor colorWithRed:79/255.0 green:194/255.0 blue:210/255.0 alpha:1]];
            [cell.LblRightSideName setFrame:CGRectMake(174 , 9, 100, 28)];
            cell.LblRightSideName.numberOfLines=1;
            cell.LblRightSideName.textAlignment=NSTextAlignmentLeft;
            [cell.LblRightSideName setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:17]];
            [cell.LblRightSideName setTextColor:[UIColor colorWithRed:131/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
            
            
            cell.NextIconArrowImage.frame =  CGRectMake(self.view.frame.size.width/2 - 33/4.0 ,17 ,33/2.0,31/2.0);
            cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            
            
            
            
            [cell.LblRightSideTime setFrame:CGRectMake(268 , 16, 50, 12)];
            cell.LblRightSideTime.numberOfLines=1;
            cell.LblRightSideTime.textAlignment=NSTextAlignmentRight;
            [cell.LblRightSideTime setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:10]];
            [cell.LblRightSideTime setTextColor:[UIColor colorWithRed:(148.0/255.0) green:(148.0/255.0) blue:(148.0/255.0) alpha:1]];
            
            cell.topBarImgView.backgroundColor = [UIColor clearColor];
            cell.topBarImgView.frame = CGRectMake(2, 65, 316, 3);
            cell.topBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
            
            
            if([selectedNewsfeed.isSenderFollower isEqualToString:@"true"] && [selectedNewsfeed.isReceiverFollower isEqualToString:@"false"])
            {
                
                [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                cell.LblLeftSideName.text = selectedNewsfeed.senderName;
                cell.LblRightSideName.text = selectedNewsfeed.receiverName;
                cell.LblRightSideTime.text = selectedNewsfeed.receiverTime;
                cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            }
            else if([selectedNewsfeed.isSenderFollower isEqualToString:@"false"] && [selectedNewsfeed.isReceiverFollower isEqualToString:@"true"])
            {
                [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.receiverImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                cell.LblLeftSideName.text = selectedNewsfeed.receiverName;
                cell.LblRightSideName.text = selectedNewsfeed.senderName;
                cell.LblRightSideTime.text = selectedNewsfeed.senderTime;
                cell.NextIconArrowImage.image = [UIImage imageNamed:@"preIcon.png"];
            }
            else if([selectedNewsfeed.isSenderFollower isEqualToString:@"true"] && [selectedNewsfeed.isReceiverFollower isEqualToString:@"true"])
            {
                [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                cell.LblLeftSideName.text = selectedNewsfeed.senderName;
                cell.LblRightSideName.text = selectedNewsfeed.receiverName;
                
                
                cell.LblRightSideTime.text = selectedNewsfeed.receiverTime;
                
                cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            }
            else if([selectedNewsfeed.isSenderFollower isEqualToString:@"false"] && [selectedNewsfeed.isReceiverFollower isEqualToString:@"false"])
            {
                if([[selectedNewsfeed.senderName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
                {
                    [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    cell.LblLeftSideName.text = selectedNewsfeed.senderName;
                    cell.LblRightSideName.text = selectedNewsfeed.receiverName;
                    
                    
                    cell.LblRightSideTime.text = selectedNewsfeed.receiverTime;
                    
                    cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
                }
                else if([[selectedNewsfeed.receiverName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
                {
                    [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.receiverImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    cell.LblLeftSideName.text = selectedNewsfeed.receiverName;
                    cell.LblRightSideName.text = selectedNewsfeed.senderName;
                    
                    
                    cell.LblRightSideTime.text = selectedNewsfeed.senderTime;
                    
                    cell.NextIconArrowImage.image = [UIImage imageNamed:@"preIcon.png"];
                }
                else
                {
                    [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    
                    cell.LblLeftSideName.text = selectedNewsfeed.senderName;
                    cell.LblRightSideName.text = selectedNewsfeed.receiverName;
                    
                    
                    cell.LblRightSideTime.text = selectedNewsfeed.receiverTime;
                    
                    cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
                }
                
            }
            else
            {
                [cell.LeftsideUIImageView setImageWithURL:[NSURL URLWithString:selectedNewsfeed.senderImageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                
                cell.LblLeftSideName.text = selectedNewsfeed.senderName;
                cell.LblRightSideName.text = selectedNewsfeed.receiverName;
                cell.LblRightSideTime.text = selectedNewsfeed.receiverTime;

                cell.NextIconArrowImage.image = [UIImage imageNamed:@"nextIcon.png"];
            }
            
            CGSize leftNameSize = [cell.LblLeftSideName.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:17]];
            
            CGSize rightNameSize = [cell.LblRightSideName.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:17]];
            
            if(leftNameSize.width>94)
            {
                [cell.LblLeftSideName setFrame:CGRectMake(56 , 9, 190, 28)];
                cell.LblLeftSideName.textAlignment = NSTextAlignmentLeft;
                cell.LblRightSideName.textAlignment = NSTextAlignmentLeft;
                [cell.LblRightSideName setFrame:CGRectMake(56 , 30, 190, 28)];
                cell.NextIconArrowImage.frame =  CGRectMake(250 ,17 ,33/2.0,31/2.0);
            }
            else
            {
                cell.LblLeftSideName.textAlignment = NSTextAlignmentLeft;
                cell.LblRightSideName.textAlignment = NSTextAlignmentLeft;
            }
            
            
            
            cell.NextIconArrowImage.frame =  CGRectMake(cell.LblLeftSideName.frame.origin.x + leftNameSize.width + 4,17 ,33/2.0,31/2.0);
            
            float remainingWidth = 212 - leftNameSize.width - 22;
            if(remainingWidth<rightNameSize.width)
                [cell.LblRightSideName setFrame:CGRectMake(56 , 30, 190, 28)];
            else
                [cell.LblRightSideName setFrame:CGRectMake(cell.LblLeftSideName.frame.origin.x + leftNameSize.width + cell.NextIconArrowImage.frame.size.width+8 , 9.5f, 100, 28)];
            
            
            
            cell.topBarImgView.frame = CGRectMake(2, 94, 316, 3);
            cell.topBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
            
            
            QBChatMessage *messageBody = selectedNewsfeed.message ;
            NSString *message;
            
            NSString *StrClicks = messageBody.customParameters[@"clicks"];
            
            NSLog(@"%@",StrClicks);
            
            if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
            {
                // set message's text
                message = [messageBody text];
                if(message== (NSString*)[NSNull null])
                {
                    message = @"";
                    cell.message.text = @"";
                }
                else
                    cell.message.text = message;
                cell.message.textColor = [UIColor blackColor];
                cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            }
            else
            {
                message = [messageBody text];
                
                
                
                if(message== (NSString*)[NSNull null] || message == nil)
                    message = @"";
                
                // font setting when sending the clicks
                
                UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
                UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
                UIColor *foregroundColor = [UIColor whiteColor];//[UIColor colorWithRed:(227.0/255.0) green:(133.0/255.0) blue:(119.0/255.0) alpha:1.0];
                NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       boldFont, NSFontAttributeName,nil];
                NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                          regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
                const NSRange range = NSMakeRange(0,[StrClicks length]);
                NSMutableAttributedString *attributedText =
                [[NSMutableAttributedString alloc] initWithString:message
                                                       attributes:attrs];
                [attributedText setAttributes:subAttrs range:range];
                [cell.message setAttributedText:attributedText];
                
                //cell.message.text = message;
                cell.message.textColor = [UIColor whiteColor];
                //cell.message.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            }
            //check for image sent
            
            if([messageBody.customParameters[@"fileID"] length]>1)
            {
                cell.PhotoView.image=nil;
                cell.PhotoView.frame = CGRectZero;
                cell.PhotoView.alpha = 1;
                
                [cell.imageSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight = 316/[messageBody.customParameters[@"imageRatio"] floatValue];
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                
                
                cell.imageSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, imageHeight);
                
                
                
                cell.imageSentView.enabled=false;
                
                cell.PhotoView.frame=cell.imageSentView.frame;
                
                [cell.PhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"fileID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    [cell.imageSentView setImage:cell.PhotoView.image forState:UIControlStateNormal]; cell.imageSentView.enabled=true; cell.PhotoView.alpha = 0;
                    
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                
                
                [cell.imageSentView addTarget:self action:@selector(showFullScreenPicture:)
                             forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                [cell.imageSentView setImage:nil forState:UIControlStateNormal];
                cell.imageSentView.frame=CGRectZero;
                
                cell.PhotoView.image=nil;
                cell.PhotoView.frame=CGRectZero;
                cell.PhotoView.alpha = 1;
                
                
            }
            
            // check for video sent
            if([messageBody.customParameters[@"videoID"] length]>1)
            {
                /*cell.ThumbnailPhotoView.image=nil;
                 cell.ThumbnailPhotoView.frame = CGRectZero;
                 [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
                 cell.ThumbnailPhotoView.frame = CGRectZero;*/
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                cell.VideoSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, 254);
                
                cell.VideoSentView.enabled=false;
                
                cell.ThumbnailPhotoView.frame=cell.VideoSentView.frame;
                
                if(messageBody.customParameters[@"videoThumbnail"]!= [NSNull null])
                    [cell.ThumbnailPhotoView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"videoThumbnail"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                        [cell.VideoSentView setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal]; cell.VideoSentView.enabled=true;
                } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ];
                     
                cell.VideoSentView.tag = indexPath.row - index;
                [cell.VideoSentView addTarget:self action:@selector(showFullScreenVideo:)
                             forControlEvents:UIControlEventTouchUpInside];
                
                //
                
            }
            else
            {
                [cell.VideoSentView setImage:nil forState:UIControlStateNormal];
                cell.VideoSentView.frame=CGRectZero;
                
                cell.ThumbnailPhotoView.image=nil;
                cell.ThumbnailPhotoView.frame=CGRectZero;
                
                
            }
            
            
            //audio data
            if([messageBody.customParameters[@"audioID"] length]>1)
            {
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                cell.sound_bgView.frame=CGRectMake(padding ,padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316, 150);
                cell.sound_iconView.frame=CGRectMake(padding + 100, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height + 25 , 180, 100);
                cell.play_btn.frame = CGRectMake(padding + 15, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height + 37.5f , 75, 75);
                
                cell.sound_iconView.image = [UIImage imageNamed:@"Sound-icon.png"];
                
                cell.play_btn.tag = indexPath.row - index;
                [cell.play_btn setImage:[UIImage imageNamed:@"Play_Button.png"] forState:UIControlStateNormal];
                [cell.play_btn addTarget:self action:@selector(playAudio:)
                        forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                [cell.play_btn setImage:nil forState:UIControlStateNormal];
                cell.play_btn.frame=CGRectZero;
                
                cell.sound_iconView.frame=CGRectZero;
                cell.sound_bgView.frame=CGRectZero;
                //[cell.slider setThumbImage: [[UIImage alloc] init] forState:UIControlStateNormal];
            }
            
            
            if([messageBody.customParameters[@"locationID"] length]>1)
            {
                cell.LocationView.image=nil;
                cell.LocationView.frame = CGRectZero;
                cell.LocationView.alpha = 1;
                [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                
                float imageHeight = 316/[messageBody.customParameters[@"imageRatio"] floatValue];
                if(messageBody.customParameters[@"imageRatio"] == [NSNull null] || messageBody.customParameters[@"imageRatio"]==nil)
                    imageHeight = 125;
                
                
                cell.LocationSentView.frame=CGRectMake(padding, padding*2 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height , 316, imageHeight);
                
                
                
                cell.LocationSentView.enabled=false;
                
                cell.LocationView.frame=cell.LocationSentView.frame;
                
                [cell.LocationView setImageWithURL:[NSURL URLWithString:messageBody.customParameters[@"locationID"]] placeholderImage:[UIImage imageNamed:@"loadingggggg.png"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                {
                    [cell.LocationSentView setImage:cell.LocationView.image forState:UIControlStateNormal];
                    cell.LocationSentView.enabled=true;
                    cell.LocationView.alpha = 0;
                }
                       usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                 
                 
                 
                 
                
                //                [cell.LocationSentView addTarget:self action:@selector(showMapView:)
                //                                forControlEvents:UIControlEventTouchUpInside];
                
                
            }
            else
            {
                [cell.LocationSentView setImage:nil forState:UIControlStateNormal];
                cell.LocationSentView.frame=CGRectZero;
                
                cell.LocationView.image=nil;
                cell.LocationView.frame=CGRectZero;
                cell.LocationView.alpha = 1;
            }
            
            
            // message's datetime
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"hh:mm a"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
            NSString *OldTime = [formatter stringFromDate:messageBody.datetime];
            NSString *time;
            //..NSLog(@"%@",[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]]);
            if([[NSString stringWithFormat:@"%@",[OldTime substringFromIndex:MAX((int)[OldTime length]-2, 0)]] isEqualToString:@"pm"])
            {
                time = [OldTime substringToIndex:[OldTime length]-2];
                time = [time stringByAppendingString:@"PM"];
            }
            else
            {
                time = [OldTime substringToIndex:[OldTime length]-2];
                time = [time stringByAppendingString:@"AM"];
            }
            
            CGSize textSize = { 316.0, 12153.85 };
            
            
            CGSize size = [message sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0]
                              constrainedToSize:textSize
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            if(![StrClicks isEqualToString:@"no"])
            {
                size.width+=10.0;
            }
            
            size.width += (padding*10/2);
            
            
            if((messageBody.text == (NSString*)[NSNull null] && [messageBody.customParameters[@"card_heading"] length]==0) || ([messageBody.text isEqualToString:@""] && [messageBody.customParameters[@"card_heading"] length]==0))
                size = CGSizeZero;
            
            // Left/Right message box
            
            
            
            if([messageBody.customParameters[@"card_heading"] length]==0)
            {
                
                if([messageBody.customParameters[@"fileID"] length]>1)
                {
                    cell.message.frame=CGRectMake(padding, padding + cell.imageSentView.frame.origin.y + cell.imageSentView.frame.size.height, 316, size.height+padding*15);
                }
                else if([messageBody.customParameters[@"locationID"] length]>1)
                {
                    cell.message.frame=CGRectMake(padding, padding + cell.LocationSentView.frame.origin.y + cell.LocationSentView.frame.size.height, 316, size.height+padding*15);
                }
                else if([messageBody.customParameters[@"videoID"] length]>1)
                {
                    cell.message.frame=CGRectMake(padding, padding + cell.ThumbnailPhotoView.frame.origin.y + cell.ThumbnailPhotoView.frame.size.height, 316, size.height+padding*15);
                }
                else if([messageBody.customParameters[@"audioID"] length]>1)
                {
                    cell.message.frame=CGRectMake(padding, padding + cell.sound_bgView.frame.origin.y + cell.sound_bgView.frame.size.height, 316, size.height+padding*15);
                }
                else
                    [cell.message setFrame:CGRectMake(padding, padding + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316 , size.height+padding*15)];
                
                
                
                
                //for clicks image in the textview
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    if([[messageBody.customParameters[@"clicks"] substringToIndex:1] isEqualToString:@"-"])
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+31,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    else
                        [cell.clicksImageView setFrame:CGRectMake(cell.message.frame.origin.x+38,
                                                                  cell.message.frame.origin.y+12,
                                                                  14,15)];
                    
                    cell.clicksImageView.image=[UIImage imageNamed:@"headerIconWhite.png"];
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(245.0/255.0) green:(161/255.0) blue:(155/255.0) alpha:1.0]];
                    cell.message.layer.borderWidth = 2.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]]; // owner gray chat popup
                    cell.message.layer.borderWidth = 0.0f;
                    [cell.clicksImageView setFrame:CGRectZero];
                    cell.clicksImageView.image=nil;
                }
            }
            else
            {
                [cell.message setFrame:CGRectZero];
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                cell.message.layer.borderWidth = 0.0f;
                [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]]; // owner gray chat popup
            }
            
            if([messageBody.customParameters[@"fileID"] length]>1 || [messageBody.customParameters[@"videoID"] length]>1  || [messageBody.customParameters[@"audioID"] length]>1  || [messageBody.customParameters[@"locationID"] length]>1)
            {
                if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
                {
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(245.0/255.0) green:(161/255.0) blue:(155/255.0) alpha:1.0]];
                    cell.message.layer.borderWidth = 3.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                else
                {
                    [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]];
                    cell.message.layer.borderWidth = 3.0f;
                    cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
                }
                
                if((cell.message.text.length==0 && [messageBody.customParameters[@"clicks"] isEqualToString:@"no"]) || ( cell.message.text.length==0 && [messageBody.customParameters[@"clicks"]length]==0))
                {
                    //[cell.message setFrame:CGRectZero];
                    
                    [cell.clicksImageView setFrame:CGRectZero];
                    cell.clicksImageView.image=nil;
                    //                [cell.message setBackgroundColor:[UIColor whiteColor]];
                    cell.message.layer.borderWidth = 0.0f;
                }
            }
            else if(![messageBody.customParameters[@"clicks"] isEqualToString:@"no"] && [messageBody.customParameters[@"clicks"]length]>0)
            {
                cell.message.layer.borderWidth = 2.0f;
                cell.message.layer.borderColor = [[UIColor whiteColor] CGColor];
            }
            else
            {
                cell.message.layer.borderWidth = 0.0f;
            }
            
            
            
            
            //-------for displaying cards------------
            if([messageBody.customParameters[@"card_heading"] length]>0)
            {
                
                [cell.message setFrame:CGRectMake(padding, padding*3 + cell.LeftsideUIImageView.frame.origin.y  + cell.LeftsideUIImageView.frame.size.height, 316 , 128+padding*10)];
                
                [cell.clicksImageView setFrame:CGRectZero];
                cell.clicksImageView.image=nil;
                [cell.message setBackgroundColor:[UIColor colorWithRed:(246.0/255.0) green:(246.0/255.0) blue:(246.0/255.0) alpha:1.0]];
                cell.message.layer.borderWidth = 0.0f;
                
                cell.PhotoView.frame=CGRectZero;
                cell.PhotoView.image=nil;
                
                cell.cardImageView.frame = CGRectMake(cell.message.frame.origin.x + 55,cell.message.frame.origin.y + 10, 95, 125);
                cell.cardImageView.image = [UIImage imageNamed:@"steamy-shower_chat.png"];
                
                cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 25, 75, 42);
                cell.cardHeading.text = messageBody.customParameters[@"card_heading"];
                
                cell.cardContent.frame = CGRectMake(cell.cardImageView.frame.origin.x + 10, cell.cardImageView.frame.origin.y + 68, 75, 42);
                cell.cardContent.text = messageBody.customParameters[@"card_content"];
                
                cell.cardTopClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + 2, cell.cardImageView.frame.origin.y + 1, 20, 20);
                cell.cardTopClicks.text = messageBody.customParameters[@"card_clicks"];
                
                cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 34, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 20, 20, 20);
                cell.cardBottomClicks.text = messageBody.customParameters[@"card_clicks"];
                
                if([messageBody.customParameters[@"is_CustomCard"] isEqualToString:@"true"])
                {
                    cell.cardImageView.image = [UIImage imageNamed:@"custom_card_Bar.png"];
                    cell.cardHeading.frame = CGRectMake(cell.cardImageView.frame.origin.x +  4 ,cell.cardImageView.frame.origin.y + 10 + 6 , 95-6, 125 -36);
                    cell.cardHeading.numberOfLines=4;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1]];
                    cell.cardBottomClicks.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width - 36, cell.cardImageView.frame.origin.y + cell.cardImageView.frame.size.height - 24, 20, 20);
                }
                else
                {
                    cell.cardHeading.numberOfLines=2;
                    cell.cardHeading.textAlignment=NSTextAlignmentCenter;
                    [cell.cardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                    [cell.cardHeading setTextColor:[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1]];
                }
                
                
                cell.cardSender.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y - 8, 120, 40);
                cell.cardSender.text = [cell.LblLeftSideName.text capitalizedString];
                //cell.cardSender.text = @"You";
                
                
                cell.cardPlayed_Countered.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 10, 120, 40);
                cell.cardPlayed_Countered.text = messageBody.customParameters[@"card_Played_Countered"];
                
                
                cell.cardBarView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 40, 90, 2);
                cell.cardBarView.image = [UIImage imageNamed:@"bar.png"];
                
                
                if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 50 - 5, 90, 80);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"accepted.png"];
                    
                }
                else if([messageBody.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
                {
                    cell.cardAccepted.frame=CGRectZero;
                    cell.cardRejected.frame=CGRectZero;
                    cell.cardCountered.frame=CGRectZero;
                    
                    cell.cardAcceptedView.frame = CGRectMake(cell.cardImageView.frame.origin.x + cell.cardImageView.frame.size.width + 15, cell.cardImageView.frame.origin.y + 50 - 5, 90, 75);
                    cell.cardAcceptedView.image = [UIImage imageNamed:@"rejected.png"];
                    
                }
            }
            else
            {
                cell.cardAccepted.frame=CGRectZero;
                cell.cardAcceptedView.frame=CGRectZero;
                cell.cardBarView.frame=CGRectZero;
                cell.cardBottomClicks.frame=CGRectZero;
                cell.cardContent.frame=CGRectZero;
                cell.cardCountered.frame=CGRectZero;
                cell.cardHeading.frame=CGRectZero;
                cell.cardImageView.frame=CGRectZero;
                cell.cardPlayed_Countered.frame=CGRectZero;
                cell.cardRejected.frame=CGRectZero;
                cell.cardSender.frame=CGRectZero;
                cell.cardTopClicks.frame=CGRectZero;
                
            }
            
            cell.topBarImgView.frame = CGRectMake(2, cell.message.frame.origin.y + cell.message.frame.size.height + padding*2, 316, 3);
            cell.topBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
            
            
            
            cell.feedCountImgView.frame = CGRectMake(10, cell.message.frame.origin.y + cell.message.frame.size.height + padding*26, 35/2.0, 30/2);
            cell.feedCountImgView.image = [UIImage imageNamed:@"grey_cloud.png"];
            
            if([selectedNewsfeed.commentCount integerValue]>0)
            {
                for(int k=0;k<selectedNewsfeed.commentsArrayNewsfeedPage.count;k++)
                {
                    NSString *commentText = [NSString stringWithFormat:@"%@  %@",[[[selectedNewsfeed.commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString], [[selectedNewsfeed.commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"comment"]];
                    
                    UIFont *regularFont = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14.0];
                    UIFont *boldFont = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15.0];
                    UIColor *foregroundColor = [UIColor colorWithRed:78/255.0 green:194/255.0 blue:209/255.0 alpha:1];
                    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                           boldFont, NSFontAttributeName,nil];
                    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                              regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
                    const NSRange range = NSMakeRange(0,[[[[selectedNewsfeed.commentsArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString] length]);
                    NSMutableAttributedString *attributedText =
                    [[NSMutableAttributedString alloc] initWithString:commentText
                                                           attributes:attrs];
                    [attributedText setAttributes:subAttrs range:range];
                    
                    if(k==0)
                    {
                        [cell.comment1 setAttributedText:attributedText];
                        cell.comment1.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*24, 275, 20);
                        
                    }
                    else if(k==1)
                    {
                        [cell.comment2 setAttributedText:attributedText];
                        cell.comment2.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*33, 275, 20);
                    }
                    else if(k==2)
                    {
                        [cell.comment3 setAttributedText:attributedText];
                        cell.comment3.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*42, 275, 20);
                    }
                    
                    
                    
                    
                }
                
                if(selectedNewsfeed.commentsArrayNewsfeedPage.count==1)
                {
                    cell.comment2.frame = CGRectZero;
                    cell.comment3.frame = CGRectZero;
                    comments_offsetY = 20;
                    cell.commentCount.frame = CGRectZero;
                    cell.viewAllCommentsBtn.frame = CGRectZero;
                }
                else if(selectedNewsfeed.commentsArrayNewsfeedPage.count==2)
                {
                    cell.comment3.frame = CGRectZero;
                    comments_offsetY = 10;
                    cell.commentCount.frame = CGRectZero;
                    cell.viewAllCommentsBtn.frame = CGRectZero;
                }
                else
                {
                    comments_offsetY = 0;
                    
                    if([selectedNewsfeed.commentCount integerValue]>3)
                    {
                        comments_offsetY = -4;
                        cell.commentCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*22, 275, 20);
                        cell.commentCount.text = [NSString stringWithFormat:@"View all %i comments",[selectedNewsfeed.commentCount integerValue]];
                        cell.comment1.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*24 + 12, 275, 20);
                        cell.comment2.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*33 + 12, 275, 20);
                        cell.comment3.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*42 + 12, 275, 20);
                        
                        cell.viewAllCommentsBtn.frame = CGRectMake(0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*20, 160, 25);
                        [cell.viewAllCommentsBtn addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    else
                    {
                        cell.commentCount.frame = CGRectZero;
                        cell.viewAllCommentsBtn.frame = CGRectZero;
                    }
                }
                
                
            }
            else
            {
                cell.comment1.frame = CGRectZero;
                cell.comment2.frame = CGRectZero;
                cell.comment3.frame = CGRectZero;
                
                comments_offsetY = 24;
                
                cell.commentCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*24, 275, 20);
                cell.commentCount.text = @"No Comments";//[NSString stringWithFormat:@"%@",((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount];
                
                cell.viewAllCommentsBtn.frame = CGRectZero;
            }
            
            //cell.commentCount.frame = CGRectMake(50, cell.message.frame.origin.y + cell.message.frame.size.height + padding*30, 265, 54/2);
            //cell.commentCount.text = [NSString stringWithFormat:@"%@",((Newsfeed*)[newsfeedmanager.array_model_feeds objectAtIndex:indexPath.section]).commentCount];
            
            cell.feedStarImgView.frame = CGRectMake(10, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 37/2.0, 36/2);
            cell.feedStarImgView.image = [UIImage imageNamed:@"grey_star.png"];
            
            if([selectedNewsfeed.starCount integerValue]>5 || [selectedNewsfeed.starCount integerValue] == 0)
            {
                cell.starCount.numberOfLines=1;
                [cell.starCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:15]];
                [cell.starCount setTextColor:[UIColor colorWithRed:115/255.0 green:119/255.0 blue:118/255.0 alpha:1]];
                cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 275, 20);
                if([selectedNewsfeed.starCount integerValue] == 0)
                    cell.starCount.text = [NSString stringWithFormat:@"No Stars"];
                else
                    cell.starCount.text = [NSString stringWithFormat:@"%@ Stars", selectedNewsfeed.starCount];
            }
            else
            {
                NSString *starredList = @"";
                for(int k=0;k<selectedNewsfeed.starredArrayNewsfeedPage.count;k++)
                {
                    starredList = [starredList stringByAppendingString:[[[selectedNewsfeed.starredArrayNewsfeedPage objectAtIndex:k] objectForKey:@"user_name"] capitalizedString]];
                    
                    if(k!=selectedNewsfeed.starredArrayNewsfeedPage.count-1)
                        starredList = [starredList stringByAppendingString:@","];
                    
                }
                
                CGSize listSize = [starredList sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                if(listSize.width>265)
                {
                    cell.starCount.numberOfLines=2;
                    cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*4, 275, 40);
                }
                else
                {
                    cell.starCount.numberOfLines=1;
                    cell.starCount.frame = CGRectMake(40, cell.message.frame.origin.y + cell.message.frame.size.height + padding*5, 275, 20);
                }
                
                [cell.starCount setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
                [cell.starCount setTextColor:[UIColor colorWithRed:78/255.0 green:194/255.0 blue:209/255.0 alpha:1]];
                
                cell.starCount.text = starredList;
            }
            
            cell.starButton.frame = CGRectMake(5, cell.message.frame.origin.y + cell.message.frame.size.height + padding*4, 125, 42);
            [cell.starButton addTarget:self action:@selector(starBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.bottomBarImgView.frame = CGRectMake(2, cell.message.frame.origin.y + cell.message.frame.size.height + padding*58 - comments_offsetY, 316, 3);
            cell.bottomBarImgView.image = [UIImage imageNamed:@"newsfeed_bar.png"];
            
            cell.commentButton.frame = CGRectMake(96, cell.message.frame.origin.y + cell.message.frame.size.height + padding*62 - comments_offsetY, 209/2.0, 69/2.0);
            [cell.commentButton setImage:[UIImage imageNamed:@"comment_grey_btn.png"] forState:UIControlStateNormal];
            [cell.commentButton addTarget:self action:@selector(commentBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            if([selectedNewsfeed.userCommented boolValue])
            {
                [cell.commentButton setImage:[UIImage imageNamed:@"comment_pink_btn.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.commentButton setImage:[UIImage imageNamed:@"comment_grey_btn.png"] forState:UIControlStateNormal];
            }
            
            
            
            
            cell.markStarredButton.frame = CGRectMake(8, cell.message.frame.origin.y + cell.message.frame.size.height + padding*62 - comments_offsetY, 148/2.0, 69/2.0);
            [cell.markStarredButton setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
            [cell.markStarredButton addTarget:self action:@selector(markStarredBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if([selectedNewsfeed.userStarred boolValue])
            {
                //cell.markStarredButton.enabled =false;
                [cell.markStarredButton setImage:[UIImage imageNamed:@"star_pink_btn.png"] forState:UIControlStateNormal];
            }
            else
            {
                //cell.markStarredButton.enabled =true;
                [cell.markStarredButton setImage:[UIImage imageNamed:@"star_grey_btn.png"] forState:UIControlStateNormal];
            }
            
            cell.removeNewsfeedBtn.frame = CGRectMake(315-432/2.0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*63 - 96 - comments_offsetY, 432/2.0, 87/2.0);
            [cell.removeNewsfeedBtn setImage:[UIImage imageNamed:@"removeNewsfeed.png"] forState:UIControlStateNormal];
            [cell.removeNewsfeedBtn addTarget:self action:@selector(removeNewsfeedBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.reportInapproriateBtn.frame = CGRectMake(315-432/2.0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*63 - 53 - comments_offsetY, 432/2.0, 87/2.0);
            [cell.reportInapproriateBtn setImage:[UIImage imageNamed:@"reportInappropriate.png"] forState:UIControlStateNormal];
            [cell.reportInapproriateBtn addTarget:self action:@selector(reportInappBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            if (!selectedNewsfeed.showReportBtns)
            {
                cell.removeNewsfeedBtn.hidden = YES;
                cell.reportInapproriateBtn.hidden = YES;
                cell.reportImgView.contentMode=UIViewContentModeScaleAspectFit;
            }
            else
            {
                if([[selectedNewsfeed.senderName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]] || [[selectedNewsfeed.receiverName uppercaseString] isEqualToString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString]])
                {
                    cell.removeNewsfeedBtn.hidden = YES;
                    cell.reportInapproriateBtn.hidden = NO;
                }
                else
                {
                    cell.removeNewsfeedBtn.hidden = YES;
                    cell.reportInapproriateBtn.hidden = NO;
                }
                cell.reportImgView.contentMode=UIViewContentModeScaleAspectFill;
            }
            
            cell.reportImgView.frame = CGRectMake(275+41/4.0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*69 - comments_offsetY, 41/2.0f, 11/2.0f);
            if(!selectedNewsfeed.showReportBtns)
                cell.reportImgView.image = [UIImage imageNamed:@"3_dot.png"];
            else
                cell.reportImgView.image = [UIImage imageNamed:@"cross.png"];
            
            cell.reportButton.frame = CGRectMake(270, cell.message.frame.origin.y + cell.message.frame.size.height + padding*63 - comments_offsetY, 50, 30);
            [cell.reportButton addTarget:self action:@selector(reportBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            
            cell.footerImgView.frame = CGRectZero;
            //cell.footerImgView.frame = CGRectMake(0, cell.message.frame.origin.y + cell.message.frame.size.height + padding*80, 320, 15);
            //cell.footerImgView.image = [UIImage imageNamed:@"userlistBtm.png"];
            return cell;
        }
        
        else
        {
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifiersection0];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifiersection0];
            }
            
            return cell;
        }
    
    return nil;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}



- (IBAction)backButtonPressed:(id)sender
{
    if([isViewPushed isEqualToString:@"true"])
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
