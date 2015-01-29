//
//  LeftViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 22/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "LeftViewController.h"
#import "profile_owner.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "CenterViewController.h"
#import "NewsfeedViewController.h"
//#import "InviteContactsViewController.h"
#import "SearchContactsViewController.h"
#import "SendInvite.h"
#import "CurrentClickersViewController.h"
#import "AppDelegate.h"
#import "EditProfileViewController.h"
#import "SettingsViewController.h"
#import "InvitationViewController.h"


@interface LeftViewController ()

@end

@implementation LeftViewController
@synthesize PartnerQBId,relationArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
}
-(void)viewWillAppear:(BOOL)animated
{
//    SDImageCache *imageCache = [SDImageCache sharedImageCache];
//    [imageCache clearMemory];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"LeftMenuOpened" properties:nil];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
     //[self getuserrelations];
    [profilemanager getRelations:YES];
    
    PartnerQBId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"];
    
    if(table)
        [table reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [SearchtxtView resignFirstResponder];
    SearchtxtView.text = @"";
    table.hidden = NO;
    StrTable.hidden = YES;
    backButton.hidden = YES;
    crossButton.hidden = YES;
    SearchBGimgView.image = [UIImage imageNamed:@"search_left_menuNew.png"];
    SearchtxtView.frame = CGRectMake(25, 11, 200, 25);
}


//- (void) receiveResignKeyboardNotification:(NSNotification *) notification
//{
//   // [SearchtxtView resignFirstResponder];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveResignKeyboardNotification:)
//                                                 name:@"resignKeyboardLeftMenu"
//                                               object:nil];
    // Do any additional setup after loading the view from its nib.
    
    //set chat delegate
    [ModelManager modelManager].chatManager.LeftMessageReceiveDelegate=self;
    
    
    arrUsers = [[NSMutableArray alloc] init];
    
    SelectedRow = -1;
        
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(RelationsNotificationReceived:)
     name:Notification_RelationsUpdated
     object:nil];
    
//    // Set chat notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
      //                                           name:NotificationDidReceiveNewMessage object:nil];
    
    // Models
    modelmanager=[ModelManager modelManager];
    profilemanager=modelmanager.profileManager;

    
     PartnerQBId= @"";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.isAppLaunching == true)
        appDelegate.isAppLaunching = false;
    else
        [[NSUserDefaults standardUserDefaults] setObject:self.PartnerQBId forKey:@"LeftMenuPartnerQBId"];
    
    appDelegate = nil;
    
    UIImageView *bg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_bg.png"]];
 
    bg.center=CGPointMake(160, 240);
    if(IS_IPHONE_5)
    {
        bg.frame=CGRectMake(0, 0, 320, 569);
        bg.center=CGPointMake(160, 283);
    }
    [self.view addSubview:bg];
    
    SearchBGimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 540/2.0, 89/2.0)];
//  SearchBGimgView.image = [UIImage imageNamed:@"searchBGImg_new.png"];//search_left_menuNew.png
    SearchBGimgView.image = [UIImage imageNamed:@"search_left_menuNew.png"];

    [self.view addSubview:SearchBGimgView];
    
    SearchtxtView = [[UITextField alloc] initWithFrame:CGRectMake(25, 11, 200, 25)];
    SearchtxtView.placeholder = @"SEARCH CLICKIN'";
    SearchtxtView.tintColor = [UIColor whiteColor];
    SearchtxtView.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
    SearchtxtView.textColor = [UIColor colorWithRed:(64.0/255.0) green:(74.0/255.0) blue:(106.0/255.0) alpha:1.0];
    SearchtxtView.backgroundColor = [UIColor clearColor];
    [SearchtxtView setKeyboardAppearance:UIKeyboardAppearanceDark];
    SearchtxtView.delegate = self;
    [SearchtxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self.view addSubview:SearchtxtView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(235, 13,20,20);
    activityIndicator.autoresizingMask = UIViewAutoresizingNone;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    
    crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossButton addTarget:self
                   action:@selector(crossButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [crossButton setImage:[UIImage imageNamed:@"searchCross.png"] forState:UIControlStateNormal];
    crossButton.backgroundColor = [UIColor clearColor];
    crossButton.frame = CGRectMake(230, 5,35,35);
    [self.view addSubview:crossButton];
    crossButton.hidden = YES;
    
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton addTarget:self
               action:@selector(backButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrowNew.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(7.0, 10.0, 50/2, 47/2);
    [self.view addSubview:backButton];
    backButton.hidden = YES;
    
    table=[[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 480-45) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        table.frame=CGRectMake(0,45, 320, 568-45);
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
    
    StrTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 45, 250, 480-45) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        StrTable.frame=CGRectMake(10,45, 250, 568-45);
    StrTable.backgroundColor = [UIColor clearColor];
    StrTable.delegate=self;
    StrTable.dataSource=self;
    StrTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:StrTable];
  
    StrTable.hidden =  YES;
    
    relationArray=[[NSMutableArray alloc] init];
    
    //[self getuserrelations];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
//    [self.view addGestureRecognizer:tap];
    
     [self.view bringSubviewToFront:self.tintView];
}


- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [SearchtxtView resignFirstResponder];
}
-(void)crossButtonAction:(id)sender
{
    SearchtxtView.text = @"";
    crossButton.hidden = YES;
}

-(void)inviteButtonAction:(id)sender
{
    SearchContactsViewController *sendinvite = [[SearchContactsViewController alloc] initWithNibName:nil bundle:nil];
    sendinvite.isFromMenu = @"true";
    //SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
    while (controllers.count>1) {
        [controllers removeLastObject];
    }
    [controllers addObject:sendinvite];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

-(void)backButtonAction:(id)sender
{
    [SearchtxtView resignFirstResponder];
    SearchtxtView.text = @"";
    table.hidden = NO;
    StrTable.hidden = YES;
    backButton.hidden = YES;
    crossButton.hidden = YES;
    SearchBGimgView.image = [UIImage imageNamed:@"search_left_menuNew.png"];
    SearchtxtView.frame = CGRectMake(25, 11, 200, 25);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if(newLength != 0)
    {
        crossButton.hidden = NO;
    }
    
    
    if(newLength == 0)
    {
        SearchBGimgView.image = [UIImage imageNamed:@"search_left_menuNew.png"];
        SearchtxtView.frame = CGRectMake(25, 11, 200, 25);
        backButton.hidden = YES;
        StrTable.hidden = YES;
        table.hidden = NO;
    }
    if(newLength < 3)
    {
        [timerCallService invalidate];
        timerCallService=nil;
    }
	else
    {
        if (timerCallService != nil)
        {
            
            for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
            {
                [req cancel];
                [req setDelegate:nil];
            }
            
            [timerCallService invalidate];
            timerCallService=nil;
        }
        
        timerCallService = [NSTimer scheduledTimerWithTimeInterval: 0.6 target:self selector: @selector(searchOnServer) userInfo: nil repeats: NO];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)searchOnServer
{
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"UserSearched" properties:nil];
    
    [timerCallService invalidate];
    timerCallService=nil;
    crossButton.hidden = YES;
    [activityIndicator startAnimating];
    [self performSelector:@selector(searchServerRequest) withObject:nil afterDelay:0.0f];
}


-(void)searchServerRequest
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/fetchusersbyname"];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",SearchtxtView.text,@"name",user_token,@"user_token",nil];
    
    NSLog(@"%@",str);
    NSLog(@"%@",Dictionary);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request appendPostData:jsonData];
    [request setDidFinishSelector:@selector(requestFinished_info:)];

    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}

- (void)requestFinished_info:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    NSError *errorl = nil;
    NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
    
    if([request responseStatusCode] == 200)
    {
        //BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Search result have found users with same name."])
        {
           arrUsers = [[NSArray arrayWithArray:[jsonResponse objectForKey:@"users"]] mutableCopy];
           SearchBGimgView.image = [UIImage imageNamed:@"searchBGImg_new.png"];//search_left_menuNew.png
           SearchtxtView.frame = CGRectMake(55, 11, 200-25, 25);
           backButton.hidden = NO;
           StrTable.hidden =  NO;
           table.hidden = YES;
           [SearchtxtView resignFirstResponder];
           [StrTable reloadData];
        }
    }
    if([request responseStatusCode] == 500)
    {
    //    BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Search result have no user(s) with same name."])
        {
            [arrUsers removeAllObjects];
            SearchBGimgView.image = [UIImage imageNamed:@"searchBGImg_new.png"];//search_left_menuNew.png
            SearchtxtView.frame = CGRectMake(55, 11, 200-25, 25);
            backButton.hidden = NO;
            StrTable.hidden =  NO;
            [SearchtxtView resignFirstResponder];
            table.hidden = YES;
            [StrTable reloadData];
        }
    }
    crossButton.hidden = NO;
    [activityIndicator stopAnimating];
}

- (void)RelationsNotificationReceived:(NSNotification *)notification //use notification method and logic
{
    if(notification != nil)
    {
        NSDictionary *dict = [notification userInfo];
        
        if([[dict valueForKey:@"deleteuser"] isEqualToString:@"yes"])
        {
            [relationArray removeObjectAtIndex:[[dict valueForKey:@"index"] intValue]];
        }
    }
    
    // reload table data
    for(int i=0;i<relationArray.count;i++)
    {
        for(int j=0;j<profilemanager.relationshipArray.count;j++)
        {
            if([((RelationInfo*)[relationArray objectAtIndex:i]).relationship_ID isEqualToString:((RelationInfo*)[profilemanager.relationshipArray objectAtIndex:j]).relationship_ID])
            {
                ((RelationInfo*)[profilemanager.relationshipArray objectAtIndex:j]).unreadMessagesCount = ((RelationInfo*)[relationArray objectAtIndex:i]).unreadMessagesCount;
            }
        }
    }
    
    [relationArray removeAllObjects];
    [relationArray addObjectsFromArray:profilemanager.relationshipArray];
    [table reloadData];
    [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:3];
}

-(void)reloadTableView
{
    [table reloadData];
}

-(void)LeftchatDidReceiveMessageNotification:(NSDictionary *)dictMessage
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"leftchatDidReceiveMess" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    alert = nil;
    
    QBChatMessage *message = [dictMessage objectForKey:kMessage];
    NSLog(@"msg rec : %@",message.text);
   // notification.userInfo[kMessage];
    
    NSString *senderID = [NSString stringWithFormat:@"%ld",(long)message.senderID];
    
    PartnerQBId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"];
    
    for(int i=0;i<relationArray.count;i++)
    {
        if(![PartnerQBId isEqualToString:[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:i]).partnerQB_ID]])
        {
            if([senderID isEqualToString:[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:i]).partnerQB_ID]] && [message.customParameters[@"isDelivered"] length]==0 && [message.customParameters[@"isComposing"] length]==0)
            {
                ((RelationInfo*)[relationArray objectAtIndex:i]).unreadMessagesCount++;
                
                NSLog(@"%@",((RelationInfo*)[relationArray objectAtIndex:i]).relationship_ID);
                
                
                //update clicks score if message contains clicks
                NSString *StrClicks = message.customParameters[@"clicks"];
                if(StrClicks.length>0 && [StrClicks intValue])
                {
                    if([message.customParameters[@"shareStatus"] length]>0 && [message.customParameters[@"shareStatus"] isEqualToString:@"shared"])
                    {
                        
                    }
                    else
                    {
                        int ownersClicks = [((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks integerValue];
                        ((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks =[NSString stringWithFormat:@"%i",ownersClicks+[StrClicks intValue]];
                        NSLog(@"Clicks value change.....%@",[NSString stringWithFormat:@"%i",ownersClicks+[StrClicks intValue]]);
                    }
                }

                //update clicks score when card is accpeted
                if([message.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"] && [message.customParameters[@"shareStatus"] length]==0)
                {
                    
                    if([message.customParameters[@"card_owner"] isEqualToString:[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]])
                    {
                        int addMyClicks = [((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks integerValue];
                        addMyClicks += [message.customParameters[@"card_clicks"] intValue];
                        ((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks = [NSString stringWithFormat:@"%d",addMyClicks];
                        
                        int addMyFriendClicks = [((RelationInfo*)[relationArray objectAtIndex:i]).partnerClicks integerValue];
                        addMyFriendClicks -= [message.customParameters[@"card_clicks"] intValue];
                        ((RelationInfo*)[relationArray objectAtIndex:i]).partnerClicks = [NSString stringWithFormat:@"%d",addMyFriendClicks];
                        
                    }
                    else
                    {
                        int addMyClicks = [((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks integerValue];
                        addMyClicks -= [message.customParameters[@"card_clicks"] intValue];
                        ((RelationInfo*)[relationArray objectAtIndex:i]).ownerClicks = [NSString stringWithFormat:@"%d",addMyClicks];
                        
                        int addMyFriendClicks = [((RelationInfo*)[relationArray objectAtIndex:i]).partnerClicks integerValue];
                        addMyFriendClicks += [message.customParameters[@"card_clicks"] intValue];
                        ((RelationInfo*)[relationArray objectAtIndex:i]).partnerClicks = [NSString stringWithFormat:@"%d",addMyFriendClicks];
                    }
                }

                
                
                //////////////////////////////////////////// add unread messages in local storage/////////////////////////////////////////////////////////////////////
                
                NSLog(@"relationshpID%@",((RelationInfo*)[relationArray objectAtIndex:i]).relationship_ID);
                
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:((RelationInfo*)[relationArray objectAtIndex:i]).relationship_ID]];
                NSMutableArray *ArrayMessages = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayMessages"])
                {
                    NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
                    ArrayMessages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
                    [ArrayMessages addObject:message];
                    if(ArrayMessages.count >= 20)
                    {
                        NSRange RangeMessages;
                        RangeMessages.location = [ArrayMessages count] - 20;
                        RangeMessages.length = 20;
                        ArrayMessages = [[ArrayMessages subarrayWithRange:RangeMessages] mutableCopy];
                    }
                }
                else
                {
                    [ArrayMessages addObject:message];
                }
                
                
                NSMutableArray *arrTempImages = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayImagedata"])
                {
                    arrTempImages = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayImagedata"]];
                     [arrTempImages addObject:[[NSData alloc] init]];
                    if(arrTempImages.count >= 20)
                    {
                        NSRange RangeMessages;
                        RangeMessages.location = [arrTempImages count] - 20;
                        RangeMessages.length = 20;
                        arrTempImages = [[arrTempImages subarrayWithRange:RangeMessages] mutableCopy];
                       
                    }
                   
                }
                else
                {
                    [arrTempImages addObject:[[NSData alloc] init]];
                }
              
                NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayAudioData"])
                {
                    arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
                     [arrTempAudio addObject:[[NSData alloc] init]];
                    if(arrTempAudio.count >= 20)
                    {
                        NSRange RangeMessages;
                        RangeMessages.location = [arrTempAudio count] - 20;
                        RangeMessages.length = 20;
                        arrTempAudio = [[arrTempAudio subarrayWithRange:RangeMessages] mutableCopy];
                       
                    }
                }
                else
                {
                    [arrTempAudio addObject:[[NSData alloc] init]];
                }
                
                /////////testing code
                NSMutableArray *arrCardStatus = [[NSMutableArray alloc] init];
                if([dict objectForKey:@"ArrayCardStatus"])
                {
                    arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
                    
                    // decrease indexes by 1 when messages are above 20
                    if(ArrayMessages.count>20)
                    {
                        for (int i = 0; i < [arrCardStatus count]; i++)
                        {
                            NSDictionary *oldDict = (NSDictionary *)[arrCardStatus objectAtIndex:i];
                            NSDictionary *newDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",[[oldDict valueForKey:@"index"] integerValue]-1],@"index",[oldDict valueForKey:@"status"],@"status", nil];
                            
                            [arrCardStatus replaceObjectAtIndex:i withObject:newDict];
                            oldDict = nil;
                            newDict = nil;
                        }
                    }
                    // check if message contains card
                    if([message.customParameters[@"card_heading"] length]>0)
                    {
                        
                        NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ArrayMessages.count-1],@"index",@"0",@"status", nil];
                        [arrCardStatus addObject:cardDict];
                    }
                    
                    if(arrCardStatus.count >= 20)
                    {
                        NSRange RangeMessages;
                        RangeMessages.location = [arrCardStatus count] - 20;
                        RangeMessages.length = 20;
                        arrCardStatus = [[arrCardStatus subarrayWithRange:RangeMessages] mutableCopy];
                    }
                    
                }
                else
                {
                    if([message.customParameters[@"card_heading"] length]>0)
                    {
                        NSDictionary *cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",ArrayMessages.count-1],@"index",@"0",@"status", nil];
                        [arrCardStatus addObject:cardDict];
                    }
                }

                
                NSDictionary *tempDict;
                if(arrCardStatus.count>0)
                {
                    tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
                }
                else
                    tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData", nil];
                
                
                
                /////////////end testing
                
//                NSMutableArray *arrCardStatus;
//                NSDictionary *tempDict;
//                if([dict objectForKey:@"ArrayCardStatus"])
//                {
//                    arrCardStatus = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayCardStatus"]];
//                    tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
//                }
//                else
//                    tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData", nil];
                
                
                [prefs setObject:tempDict forKey:((RelationInfo*)[relationArray objectAtIndex:i]).relationship_ID];
                
                [prefs synchronize];
                
                ArrayMessages = nil;
                arrTempImages = nil;
                arrTempAudio = nil;
                
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                
                [table reloadData];
            }
        }
    }
    
    senderID = nil;
}


-(void)getuserrelations
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/getrelationships"];

    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    
    NSLog(@"%@",str);
    NSLog(@"%@",Dictionary);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request appendPostData:jsonData];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"] || success)
        {
            NSLog(@"relationship description : %@",jsonResponse.description);
            if([jsonResponse objectForKey:@"user_pic"]!= [NSNull null])
            [[NSUserDefaults standardUserDefaults] setObject:[jsonResponse objectForKey:@"user_pic"] forKey:@"user_pic"];
            
            NSArray *tempArr = [NSArray arrayWithArray:[jsonResponse objectForKey:@"relationships"]];
            [relationArray removeAllObjects];
            for(int i = 0 ;i< [tempArr count] ; i++)
            {
                if([[NSString stringWithFormat:@"%@",[[tempArr objectAtIndex:i] objectForKey:@"accepted"]] isEqualToString:@"1"])
                {
                    [relationArray addObject:[tempArr objectAtIndex:i]];
                }
            }
            tempArr = nil;
            [table reloadData];
        }
        else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
        {
            
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
    else
    {
        //NSError *errorl = nil;
        //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
        //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == StrTable)
    {
        return 1;
    }
    else
    {
        return 3;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == StrTable)
    {
        return Nil;
    }
    else
    {
        if(section==1) // only for section 2
        {
            if (relationArray.count!=0)
            {
                UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 27)];
                UIImageView *headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"do-55.png"]]; //set your image
                
                headerImage.frame = CGRectMake(0, 0, tableView.bounds.size.width, 27);
                
                [headerView addSubview:headerImage];
                return headerView;
            }
            else
                return Nil;
        }
    }

    return Nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == StrTable)
    {
        return 0;
    }
    else
    {
        if(section==1) // only for section 2
        {
            if (relationArray.count!=0)
            {
                return 27;
            }
            else
                return 0;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == StrTable)
    {
        if(arrUsers.count == 0)
        {
            return 1;
        }
        else
        {
            return [arrUsers count]+1;
        }
    }
    else
    {
        if(section==0)
        return 1;
        if(section==1)
        {
            if(relationArray.count==0)
                return 1;
            else
                return relationArray.count;
        }
        if (section==2) {
            return 4;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifiersection1 = @"Cellforsection1";
    static NSString *CellIdentifiersection2 = @"Cellforsection2";
    static NSString *CellIdentifiersection3 = @"Cellforsection3";
    UITableViewCell *cell;
    if(tableView == StrTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60,5, 150, 20))];
            name.textColor = [UIColor whiteColor];
            name.textAlignment = NSTextAlignmentLeft;
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 1;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            
            UILabel *lblCityCountry = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60, 20, 150, 20))];
            lblCityCountry.textColor = [UIColor whiteColor];
            lblCityCountry.textAlignment = NSTextAlignmentLeft;
            lblCityCountry.tag = 6;
            lblCityCountry.backgroundColor = [UIColor clearColor];
            lblCityCountry.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            lblCityCountry.lineBreakMode = YES;
            lblCityCountry.numberOfLines = 1;
            lblCityCountry.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblCityCountry];
            
            UILabel *lblNoRecordFound = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20, 5, 150, 30))];
            lblNoRecordFound.textColor = [UIColor whiteColor];
            lblNoRecordFound.textAlignment = NSTextAlignmentLeft;
            lblNoRecordFound.tag = 9;
            lblNoRecordFound.backgroundColor = [UIColor clearColor];
            lblNoRecordFound.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:20.0];
            lblNoRecordFound.lineBreakMode = YES;
            lblNoRecordFound.numberOfLines = 1;
            lblNoRecordFound.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblNoRecordFound];
            lblNoRecordFound.hidden = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 11;
            [button setBackgroundImage:[UIImage imageNamed:@"invt_btn.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(inviteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0.0, 40.0, 141.0, 35.0);
            [cell.contentView addSubview:button];
            button.hidden =  YES;
            
            UILabel *lblInviteTest = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 0, 250, 40))];
            lblInviteTest.textColor = [UIColor whiteColor];
            lblInviteTest.textAlignment = NSTextAlignmentLeft;
            lblInviteTest.tag = 12;
            lblInviteTest.backgroundColor = [UIColor clearColor];
            lblInviteTest.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14.0];
            lblInviteTest.lineBreakMode = YES;
            lblInviteTest.numberOfLines = 2;
            lblInviteTest.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblInviteTest];
            lblInviteTest.hidden = YES;
        }
        if(indexPath.row ==  arrUsers.count)
        {
            cell.backgroundView = nil;
            UILabel *inviteText=(UILabel*)[cell.contentView viewWithTag:12];
            inviteText.hidden=NO;
            
            inviteText.text = @"Could not find the one you are looking for? \n invite them to join Clickin'.";
            UIButton *InviteBtn=(UIButton*)[cell.contentView viewWithTag:11];
            InviteBtn.hidden=NO;
            
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
            UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
            cityCountry.hidden =  YES;

            lblNoRecordFound.hidden = YES;
            profile_pic.hidden =  YES;
            name.hidden = YES;
        }
        else
        {
            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];

            UILabel *inviteText=(UILabel*)[cell.contentView viewWithTag:12];
            UIButton *InviteBtn=(UIButton*)[cell.contentView viewWithTag:11];
            inviteText.hidden=YES;
            InviteBtn.hidden = YES;
            if(arrUsers.count!=0)
            {
                UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
                profile_pic.hidden=NO;
                UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
                name.hidden=NO;
                
                UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
                lblNoRecordFound.hidden=YES;

                UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
                cityCountry.hidden=NO;
                if([[arrUsers objectAtIndex:indexPath.row] valueForKey:@"user_pic"] != Nil)
                {
                    [profile_pic sd_setImageWithURL:[NSURL URLWithString:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"user_pic"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
                }
                else
                {
                    profile_pic.image = [UIImage imageNamed:@"contact_icon.png"];
                }
                if([[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"] != Nil)
                {
                    name.text=[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
                }
                else
                {
                    name.text=[@"No name" uppercaseString];
                }
                
                if([[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"city"] length] != 0 && [[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"country"] length] != 0)
                {
                    cityCountry.text = [NSString stringWithFormat:@"%@,%@",[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"city"],[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"country"]];
                }
                else if ([[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"city"] length] == 0)
                {
                    cityCountry.text = [NSString stringWithFormat:@"%@",[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"country"]];
                }
                else if ([[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"country"] length] == 0)
                {
                    cityCountry.text = [NSString stringWithFormat:@"%@",[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"city"]];
                }
                else
                {
                    cityCountry.text = @"";
                }
            }
            else
            {
                UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
                profile_pic.hidden=YES;

                UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
                name.hidden = YES;

                UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
                cityCountry.hidden=YES;
                
                UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
                lblNoRecordFound.hidden=NO;
                
                lblNoRecordFound.text = @"No record found.";
            }
        }
    }
    else
    {
    if(indexPath.section==0) //section 1
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bgggg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];//bg.png
            //cell.userInteractionEnabled=NO;
            
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30-20, 60, 60)];
            profilepic.tag=1;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(85, 37-20, 155, 40))];
            name.textColor = [UIColor colorWithRed:(123.0/255.0) green:(193.0/255.0) blue:(208.0/255.0) alpha:1.0];
            name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            name.tag = 2;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:22.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 0;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            //name.alpha=0.4;
            
            UIImageView *settingsicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingicon_light.png"]];
            settingsicon.center=CGPointMake(250, 60-20);
            settingsicon.tag=3;
            [cell.contentView addSubview:settingsicon];
            settingsicon.hidden = YES;
            
        }
        
        NSLog(@"userPIC: %@",[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]);
        UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:1];
        
        //[profile_pic setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"]]];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"] != [NSNull null] || profilemanager.ownerDetails.profilePicUrl != nil)
            [profile_pic sd_setImageWithURL:[NSURL URLWithString:profilemanager.ownerDetails.profilePicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
        
        UILabel *name=(UILabel*)[cell.contentView viewWithTag:2];
        //name.text=[(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] uppercaseString];
        name.text = [profilemanager.ownerDetails.name uppercaseString];
        [[NSUserDefaults standardUserDefaults] setObject:profilemanager.ownerDetails.name forKey:@"user_name"];
        
        
    }
    if(indexPath.section==1)  //section 2
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection2];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            //cell.userInteractionEnabled=NO;
            
            //cell bg
            UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            av.backgroundColor = [UIColor clearColor];
            av.opaque = NO;
            av.image = [UIImage imageNamed:@"clickin_relation_bg.png"];
            cell.backgroundView = av;
            
            
            // if no relations
            UIImageView *clickinadd=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 554/2, 166/2)];
            clickinadd.tag=1;
            clickinadd.image=[UIImage imageNamed:@"clickinadd.png"];
            [cell.contentView addSubview:clickinadd];
            
            UIImageView *clickinadd_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
            clickinadd_icon.tag=2;
            [cell.contentView addSubview:clickinadd_icon];
            clickinadd_icon.image=[UIImage imageNamed:@"clickinadd_icon.png"];
            
            UILabel *clickinadd_text = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 120, 50)];
            clickinadd_text.textColor = [UIColor whiteColor];
            clickinadd_text.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            clickinadd_text.tag = 3;
            clickinadd_text.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            clickinadd_text.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            clickinadd_text.lineBreakMode = YES;
            clickinadd_text.numberOfLines = 0;
            clickinadd_text.lineBreakMode = NSLineBreakByTruncatingTail;
            clickinadd_text.text=@"ADD SOMEONE TO CLICK WITH";
            [cell.contentView addSubview:clickinadd_text];
//          clickinadd_text.alpha=0.4;
            //
            
            //if any relations
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60, 5, 160, 40))];
            name.textColor = [UIColor whiteColor];
            name.textAlignment = NSTextAlignmentLeft;  //(for iOS 6.0)
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 1;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
           // name.alpha=0.4;
            
            UIImageView *unreadImgView=[[UIImageView alloc] initWithFrame:CGRectMake(230, 14, 24, 24)];
            unreadImgView.image = [UIImage imageNamed:@"blue_circle.png"];
            unreadImgView.tag=8;
            [cell.contentView addSubview:unreadImgView];
            
            //unread count label
            UILabel *unreadCount = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(230-3, 14, 30, 24))];
            unreadCount.textColor = [UIColor blueColor];
            unreadCount.textAlignment = NSTextAlignmentCenter;  //(for iOS 6.0)
            unreadCount.tag = 6;
            unreadCount.backgroundColor = [UIColor clearColor];
            // celeb_text.font = [UIFont fontWithName:@"Halvetica" size:10];
            unreadCount.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.5f];
            unreadCount.lineBreakMode = YES;
            unreadCount.lineBreakMode = NSLineBreakByTruncatingTail;
            unreadCount.numberOfLines=1;
            unreadCount.adjustsFontSizeToFitWidth=YES;
            unreadCount.minimumScaleFactor=0.25f;
            [cell.contentView addSubview:unreadCount];
            
            
            UIImageView *loadingImgView=[[UIImageView alloc] initWithFrame:CGRectMake(240, 14, 39/2.0, 38/2.0)];
            
            loadingImgView.tag = 47;
            loadingImgView.image = [UIImage imageNamed:@"settingImg.png"];
            loadingImgView.hidden = YES;
            [cell.contentView addSubview:loadingImgView];
            
//            UIImageView *settingsicon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingicon_dark.png"]];
//            settingsicon.center=CGPointMake(250, 35);
//            settingsicon.tag=6;
//            [cell.contentView addSubview:settingsicon];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48, 320-70, 2)];
            line.image=[UIImage imageNamed:@"clickin_line.png"];
            line.alpha=0.5;
            line.tag=7;
            [cell.contentView addSubview:line];
        }
        
        if(relationArray.count!=0)
        {
            UIImageView *clickinadd=(UIImageView*)[cell.contentView viewWithTag:1];
            clickinadd.hidden=YES;
            UIImageView *clickinadd_icon=(UIImageView*)[cell.contentView viewWithTag:2];
            clickinadd_icon.hidden=YES;
            UILabel *clickinadd_text=(UILabel*)[cell.contentView viewWithTag:3];
            clickinadd_text.hidden=YES;
            
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            profile_pic.hidden=NO;
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            name.hidden=NO;
//            UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
//            settingsicon.hidden=NO;
            UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
            line.hidden=NO;
            
            //profile pic
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl.length>0)
            {
                [profile_pic sd_setImageWithURL:[NSURL URLWithString:((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
            }
            else
            {
                profile_pic.image = [UIImage imageNamed:@"contact_icon.png"];
            }
            //name text
            if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length>0)
            {
                name.text=[((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName uppercaseString];
            }
            else
            {
                name.text= ((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
            }
            
            // name highlight
            if([PartnerQBId isEqualToString:[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerQB_ID]])
            {
                name.alpha=1;
                name.textColor = [UIColor whiteColor];
                //[UIColor colorWithRed:(54.0/255.0) green:(69.0/255.0) blue:(102.0/255.0) alpha:1.0];
            }
            else
            {
                name.alpha=1.0;
                name.textColor = [UIColor whiteColor];
            }
            
            UILabel *unreadCount=(UILabel*)[cell.contentView viewWithTag:6];
            unreadCount.text =[NSString stringWithFormat:@"%i",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).unreadMessagesCount];
            
//            CGSize textSize = CGSizeMake(130, 6500);
//            CGSize size;
//            size = [name.text sizeWithFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:18.0]
//                    constrainedToSize:textSize
//                        lineBreakMode:NSLineBreakByWordWrapping];
            
            UIImageView *unread_ImgView=(UIImageView*)[cell.contentView viewWithTag:8];
            
//            unread_ImgView.frame = CGRectMake(60 + size.width + 15, 13, 24, 24);
//            
//            unreadCount.frame = CGRectMake(60 + size.width + 15 - 3, 13, 30, 24);
            
            if([unreadCount.text integerValue]==0)
            {
                unread_ImgView.hidden = YES;
                unreadCount.hidden = YES;
            }
            else
            {
                unread_ImgView.hidden = NO;
                unreadCount.hidden = NO;
            }
            
            if([PartnerQBId isEqualToString:[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerQB_ID]])
            {
                unread_ImgView.hidden = YES;
                unreadCount.hidden = YES;
                [((RelationInfo*)[relationArray objectAtIndex:indexPath.row]) setUnreadMessagesCount:0];
            }
            
            if([unreadCount.text integerValue]>10)
                unreadCount.text = @"10+";
            
            
            UIImageView *loading_ImgView=(UIImageView*)[cell.contentView viewWithTag:47];
            loading_ImgView.hidden = YES;
            
            //show line border for cell
            if(indexPath.row==relationArray.count-1)
                line.hidden=YES;
            else
                line.hidden=NO;
            
        }
        else
        {
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            profile_pic.hidden=YES;
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            name.hidden=YES;
//            UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:6];
//            settingsicon.hidden=YES;
            UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:7];
            line.hidden=YES;
            
            UIImageView *clickinadd=(UIImageView*)[cell.contentView viewWithTag:1];
            clickinadd.hidden=NO;
            UIImageView *clickinadd_icon=(UIImageView*)[cell.contentView viewWithTag:2];
            clickinadd_icon.hidden=NO;
            UILabel *clickinadd_text=(UILabel*)[cell.contentView viewWithTag:3];
            clickinadd_text.hidden=NO;
            
            UILabel *unreadCount=(UILabel*)[cell.contentView viewWithTag:6];
            UIImageView *unread_ImgView=(UIImageView*)[cell.contentView viewWithTag:8];
            unread_ImgView.hidden = YES;
            unreadCount.hidden = YES;
            
            UIImageView *loading_ImgView=(UIImageView*)[cell.contentView viewWithTag:47];
            loading_ImgView.hidden = YES;
            
        }
        
    }
    if(indexPath.section==2)
    {
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection3];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection3];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor=[UIColor clearColor];
     
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        //cell.userInteractionEnabled=NO;
        //-------------------------------------------------------------------------
        //background selected view
        UIView *viewSelectedBackgroundView=[[UIView alloc]init];
        viewSelectedBackgroundView.backgroundColor=[UIColor colorWithRed:117/255.0 green:213/255.0 blue:217/255.0 alpha:1.0];
        cell.selectedBackgroundView=viewSelectedBackgroundView;
        //-------------------------------------------------------------------------
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 48, 320-70, 2)];
        line.backgroundColor = [UIColor colorWithRed:(100.0/255.0) green:(113.0/255.0) blue:(143.0/255.0) alpha:1.0];
        //line.alpha=0.3;
        line.tag=4;
        [cell.contentView addSubview:line];
        
    }
        
        if (indexPath.row == SelectedRow)
        {
           // cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"blue_box.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];//bg.png
        }
        else
        {
        }
    
        cell.textLabel.font=[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:24.0];
        cell.textLabel.textColor=[UIColor colorWithRed:(100.0/255.0) green:(113.0/255.0) blue:(143.0/255.0) alpha:1.0];
        //cell.textLabel.alpha=0.3;
        
        switch (indexPath.row+1)
        {
        case 1:
            {
//                UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:3];
//                settingsicon.hidden=NO;
                UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:4];
                line.hidden=NO;
            cell.textLabel.text = [NSString stringWithFormat:@"THE FEED"];
            cell.imageView.image=[UIImage imageNamed:@"lefticon1.png"];
            }
            break;
        case 2:
            {
//                UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:3];
//                settingsicon.hidden=YES;
                UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:4];
                line.hidden=NO;
            cell.textLabel.text = [NSString stringWithFormat:@"FIND FRIENDS"];
            cell.imageView.image=[UIImage imageNamed:@"lefticon5.png"];
            }
            break;
//        case 3:
//            {
//                UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:3];
//                settingsicon.hidden=YES;
//                UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:4];
//                line.hidden=NO;
//            cell.textLabel.text = [NSString stringWithFormat:@"GIFTS"];
//            cell.imageView.image=[UIImage imageNamed:@"lefticon3.png"];
//            }
//            break;
        case 3:
            {
//                UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:3];
//                settingsicon.hidden=YES;
                UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:4];
                line.hidden=NO;
            cell.textLabel.text = [NSString stringWithFormat:@"INVITE"];
            cell.imageView.image=[UIImage imageNamed:@"lefticon4.png"];
            }
            break;
        case 4:
            {
//                UIImageView *settingsicon=(UIImageView*)[cell.contentView viewWithTag:3];
//                settingsicon.hidden=YES;
                UIImageView *line=(UIImageView*)[cell.contentView viewWithTag:4];
                line.hidden=YES;
            cell.textLabel.text = [NSString stringWithFormat:@"SETTINGS"];
            cell.imageView.image=[UIImage imageNamed:@"setting 2.png"];
            }
            break;
        
            
        default:
            break;
    }
    
    }
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == StrTable)
    {
        if(indexPath.row ==  arrUsers.count)
        {
            return 90;
        }
        return 45;
    }
    else
    {
    if(indexPath.section==0)
        return 80;
    if(indexPath.section==1)
    {
        if(relationArray.count==0)
            return 90;
        else
            return 50;
    }
    if (indexPath.section==2) {
        return 50;
    }
    return 50;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect");
    [SearchtxtView resignFirstResponder];
    Mixpanel *mixpanel=[Mixpanel sharedInstance];
    
    if(StrTable == tableView)
    {
        if(arrUsers.count == indexPath.row)
        {
            return;
        }
        
        // CHANGE 20 Nov
        if (PartnerQBId)
        {
            PartnerQBId= @"";
            [[NSUserDefaults standardUserDefaults] setObject:PartnerQBId forKey:@"LeftMenuPartnerQBId"];
        }
        
        
        profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
        profile_other.isFromSearchByName = true;
        /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
         profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
         profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
        profile_other.relationObject = [[RelationInfo alloc] init];
        
        profile_other.relationObject.partnerPhoneNumber = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"phone_no"];
        profile_other.relationObject.partnerName = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1)
        {
            [controllers removeLastObject];
        }
        [controllers addObject:profile_other];
        navigationController.viewControllers = controllers;
        //[navigationController pushViewController:profile_other animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    else
    {
    
    if(indexPath.section==0)
    {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"OwnProfileOpened" properties:nil];
        
        PartnerQBId = @"";
        [[NSUserDefaults standardUserDefaults] setObject:self.PartnerQBId forKey:@"LeftMenuPartnerQBId"];
           // profile_owner *profile = [[profile_owner alloc] initWithNibName:nil bundle:nil];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;

//        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//        while (controllers.count>1) {
//            [controllers removeLastObject];
//        }
//
//       //[controllers addObject:profile];
//        navigationController.viewControllers = controllers;
        
        [navigationController popToRootViewControllerAnimated:NO];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        
    }
    if(indexPath.section==1)
    {
        //        NSLog(@"%@",PartnerQBId);
        //        NSLog(@"%@",[[relationArray objectAtIndex:indexPath.row] objectForKey:@"partner_QB_id"]);
        
        
        if(relationArray.count == 0)
        {
            SearchContactsViewController *sendinvite = [[SearchContactsViewController alloc] initWithNibName:nil bundle:nil];
            sendinvite.isFromMenu = @"true";
            //SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:sendinvite];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            return;
        }
        
        if((((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl.length==0) && (((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length==0))
        {
            
        }
        else
        {
            NSLog(@"%@",PartnerQBId);
            if(![PartnerQBId isEqualToString:[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerQB_ID]] )
            {
                [mixpanel track:@"LeftMenuPartnerButtonClicked"];
                
                CenterViewController *center = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
                center.partner_QB_id=[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerQB_ID];
                center.partner_pic=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPicUrl;
                center.strRelationShipId=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
//              center.PartnerPhoneNumber = ((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
                center.int_leftmenuIndex = indexPath.row;
                center.relationObject = ((RelationInfo*)[relationArray objectAtIndex:indexPath.row]);

                PartnerQBId = [NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerQB_ID];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.PartnerQBId forKey:@"LeftMenuPartnerQBId"];
                
                NSLog(@"ID: %@",((RelationInfo*)[relationArray objectAtIndex:0]).relationship_ID);
                
                if(((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName.length==0)
                {
                    center.partner_name=@"";
                }
                else
                {
                    center.partner_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;
                }
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
                NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
                while (controllers.count>1) {
                    [controllers removeLastObject];
                }
                [controllers addObject:center];
                navigationController.viewControllers = controllers;
                
                NSLog(@"%@",[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).ownerClicks]);
                NSLog(@"%@",[NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerClicks]);

                if([NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).ownerClicks].length==0)
                {
                    center.MyTotalClicks = @"0";
                }
                else
                {
                    center.MyTotalClicks = [NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).ownerClicks];
                }
                
                if([NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerClicks].length==0)
                {
                    center.FriendTotalClicks = @"0";
                }
                else
                {
                    center.FriendTotalClicks = [NSString stringWithFormat:@"%@",((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerClicks];
                }
                
                [((RelationInfo*)[relationArray objectAtIndex:indexPath.row]) setUnreadMessagesCount:0];
                
            }
            
            [table reloadData];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
    
    if(indexPath.section == 2)
    {
        SelectedRow = indexPath.row;

        [table reloadData];
        
        PartnerQBId = @"";
        [[NSUserDefaults standardUserDefaults] setObject:self.PartnerQBId forKey:@"LeftMenuPartnerQBId"];
        
        
        if (indexPath.row==0) //newsfeed
        {
            [mixpanel track:@"LeftMenuTheFeedButtonClicked"];
            NewsfeedViewController *ObjNewsfeed = [[NewsfeedViewController alloc] initWithNibName:@"NewsfeedViewController" bundle:nil];
            ObjNewsfeed.firstTimeLoad = @"yes";
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:ObjNewsfeed];
            navigationController.viewControllers = controllers;
            //[navigationController pushViewController:ObjNewsfeed animated:YES];
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        if (indexPath.row==1) //Find friends
        {
           // [mixpanel track:@"LeftMenuFindFriendsButtonClicked"];
            CurrentClickersViewController *CurrentClickers = [[CurrentClickersViewController alloc] initWithNibName:nil bundle:nil];
            CurrentClickers.isFromMenu = @"true";
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:CurrentClickers];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

        }
        if (indexPath.row==2) //Invite
        {
            //InviteContactsViewController *sendinvite = [[InviteContactsViewController alloc] initWithNibName:Nil bundle:nil];
            //SearchContactsViewController *sendinvite = [[SearchContactsViewController alloc] initWithNibName:nil bundle:nil];
            [mixpanel track:@"LeftMenuInviteButtonClicked"];
            InvitationViewController *sendinvite = [[InvitationViewController alloc] initWithNibName:nil bundle:nil];
            
            sendinvite.isFromMenu = @"true";
            //SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:sendinvite];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

//            SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
//            
//            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//            
//            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
//            while (controllers.count>1) {
//                [controllers removeLastObject];
//            }
//            [controllers addObject:sendinvite];
//            navigationController.viewControllers = controllers;
//            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        if (indexPath.row==3) //settings
        {
            [mixpanel track:@"LeftMenuSettingsButtonClicked"];
            //EditProfileViewController *editProfile = [[EditProfileViewController alloc] initWithNibName:nil bundle:nil];
            SettingsViewController *editProfile = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
            while (controllers.count>1) {
                [controllers removeLastObject];
            }
            [controllers addObject:editProfile];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            
            editProfile = nil;
        }
    }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
