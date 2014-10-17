//
//  ChatManager.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 03/05/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "ChatManager.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "CenterViewController.h"

@implementation ChatManager

@synthesize messages,TempArrayChatHistory,TempImageDataHistory,TempCardStatusHistory,inComingMsgSound,inComingClicksSound,cardAcceptedSound,cardRejectedSound;
@synthesize LeftMessageReceiveDelegate,CenterMessageReceiveDelegate,CenterCustomObjDelegate;

- (id)init{
    self = [super init];
    if(self){
        [QBChat instance].delegate = self;
        messages = [[NSMutableArray alloc] init];
        TempArrayChatHistory = [[NSMutableArray alloc] init];
        TempImageDataHistory = [[NSMutableArray alloc] init];
        TempCardStatusHistory = [[NSMutableArray alloc] init];
        
        
        inComingMsgSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"Message_Rcvd"                                                                                           ofType:@"mp3"]] error:nil];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
        {
            inComingMsgSound.volume = 0;
        }
        else
        {
            inComingMsgSound.volume = 1;
        }
        [inComingMsgSound prepareToPlay];
        
        
        inComingClicksSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"ClickReceived"                                                                                           ofType:@"mp3"]] error:nil];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
        {
            inComingClicksSound.volume = 0;
        }
        else
        {
            inComingClicksSound.volume = 1;
        }
        [inComingClicksSound prepareToPlay];
        
        
        cardAcceptedSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"TradeCard_Accepted"                                                                                           ofType:@"mp3"]] error:nil];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
        {
            cardAcceptedSound.volume = 0;
        }
        else
        {
            cardAcceptedSound.volume = 1;
        }
        [cardAcceptedSound prepareToPlay];
        
        
        cardRejectedSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"TradeCard_Rejected"                                                                                           ofType:@"mp3"]] error:nil];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
        {
            cardRejectedSound.volume = 0;
        }
        else
        {
            cardRejectedSound.volume = 1;
        }
        [cardRejectedSound prepareToPlay];
        
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(SetVolumeNotificationReceived1:)
         name:Notification_InAppSoundsFlag
         object:nil];

        
        // Set chat notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createChatSession:)
                                                     name:Notification_CreateChatSession object:nil];
        
        // Set sound notification observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playChatSound:) name:Notification_PlaySound object:nil];
    }
    return self;
}

-(void)SetVolumeNotificationReceived1:(NSNotification *)notification
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
    {
        inComingMsgSound.volume = 0;
        inComingClicksSound.volume = 0;
        cardAcceptedSound.volume = 0;
        cardRejectedSound.volume = 0;
    }
    else
    {
        inComingMsgSound.volume = 1;
        inComingClicksSound.volume = 1;
        cardAcceptedSound.volume = 1;
        cardRejectedSound.volume = 1;
    }
}


- (void)playChatSound:(NSNotification *)notification {
    // play sound notification
    [self playMsgReceivedSound];
    //update profile info
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UpdateProfile object:nil userInfo:Nil];
}

- (void)createChatSession:(NSNotification *)notification {
    // relogin here
    QBUUser *currentUser = [QBUUser user];
    currentUser.ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]; // your current user's ID
    currentUser.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"]; // your current user's password
    [[QBChat instance] loginWithUser:currentUser];
    
}

- (void)loginWithUser:(QBUUser *)user {
    
    self.currentUser = user;
    
    [[QBChat instance] loginWithUser:user];
}

- (void)sendMessage:(QBChatMessage *)message dict:(NSDictionary *)dictData
{
    [[QBChat instance] sendMessage:message];

    if([message.customParameters[@"isDelivered"] length]==0 && [message.customParameters[@"isComposing"] length]==0 && dictData != nil)
    {
    ////////////////////////////////////////////// local storage -  adding message sending time///////////////////////////////////////////////////////////////////////////
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[prefs objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"]]];
        
        NSMutableArray *ArrayMessages = [[NSMutableArray alloc] init];
        NSMutableArray *arrCardStatus;
        
        if([message.text isEqualToString:@" "])
        {
            message.text = @"";
        }
        
        if([dict objectForKey:@"ArrayMessages"])
        {
            NSData *data = (NSData *)[dict objectForKey:@"ArrayMessages"];
            ArrayMessages = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
            
            [ArrayMessages addObject:message];
            
            
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
            }
            
            
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
            [arrTempImages addObject:[dictData objectForKey:@"imagesData"]];
            
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
            [arrTempImages addObject:[dictData objectForKey:@"imagesData"]];
        }
        
        NSMutableArray *arrTempAudio = [[NSMutableArray alloc] init];
        if([dict objectForKey:@"ArrayAudioData"])
        {
            arrTempAudio = [NSMutableArray arrayWithArray:(NSMutableArray *)[dict objectForKey:@"ArrayAudioData"]];
            [arrTempAudio addObject:[dictData objectForKey:@"audioData"]];

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
            [arrTempAudio addObject:[dictData objectForKey:@"audioData"]];
        }
        
       
        NSDictionary *tempDict;
        if([dict objectForKey:@"ArrayCardStatus"])
        {
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData",arrCardStatus,@"ArrayCardStatus", nil];
        }
        else
            tempDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:ArrayMessages],@"ArrayMessages",arrTempImages,@"ArrayImagedata",arrTempAudio,@"ArrayAudioData", nil];
        
        [prefs setObject:tempDict forKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"]];
        
        [prefs synchronize];
        
        ArrayMessages = nil;
        arrTempImages = nil;
        arrTempAudio = nil;
        
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
}


-(void) getChatHistory:(NSString *)relationShipId lastChatID:(NSString*)lastchatID
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/chats/fetchchatrecords"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        NSLog(@"%@",relationShipId);
        NSLog(@"%@",[prefs stringForKey:@"phoneNumber"]);
        if(lastchatID.length == 0)
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationShipId,@"relationship_id",nil];
            [self.messages removeAllObjects];
        }
        else
        {
            Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationShipId,@"relationship_id",lastchatID,@"last_chat_id",nil];
        }
        
        NSLog(@"%@",Dictionary);
        
        [prefs setObject:relationShipId forKey:@"relationShipId"];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        if([request responseStatusCode] == 200)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Chat history fetched"])
            {
//                if(appDelegate.isFlowFromNotification == true)
//                {
//                    [self.messages removeAllObjects];
//                }
                
                [TempArrayChatHistory removeAllObjects];
                [TempImageDataHistory removeAllObjects];
                [TempCardStatusHistory removeAllObjects];
                //NSMutableArray *TempVideoDataHistory = [[NSMutableArray alloc] init];
                for (int i = 0; i < [[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] count]; i++)
                {
                    QBChatMessage *message = [[QBChatMessage alloc] init];
                    
                    NSString *MessageText = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"message"];
                    
                    if(MessageText == (NSString*)[NSNull null])
                    {
                        MessageText = @"";
                    }
                    
                    NSString *MessageClicks = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"clicks"];
                    
                    NSString *SentOn = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"sentOn"];
                    
                    NSString *SenderId = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"QB_id"];
                    
                    NSString *ReceiverId = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"receiverQB_id"];
                    
                    NSString *chatId = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"chatId"];
                    
                    NSLog(@"iiiffff %@",MessageText);
                    
                    
                    message.ID = chatId;
                    
                    if(![MessageClicks isEqual:[NSNull null]])
                    {
                        if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
                        {
                            message.text = MessageText;
                            
                            message.senderID = [SenderId longLongValue];
                            NSLog(@"senderID: %lld",[SenderId longLongValue]);
                            [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                        }
                        else
                        {
                            message.senderID = [SenderId longLongValue];
                            NSLog(@"senderID: %lld",[SenderId longLongValue]);
                            
                            [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
                            message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
                            
                        }
                    }
                    else
                    {
                        message.senderID = [SenderId longLongValue];
                        NSLog(@"senderID: %lld",[SenderId longLongValue]);
                        
                        message.text = MessageText;
                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                    }
                    
                    message.recipientID = [ReceiverId longLongValue];
                    
                    
                    //check for image data
                    NSString *contentURL = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"content"];
                    
                    NSNumber *type = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"type"];
                    
                    NSString *imageRatio = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"imageRatio"];
                    
                    if([type intValue]==2 && contentURL.length>0)
                    {
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }
                    
                    //location data
                    if([type intValue]==6 && contentURL.length>0)
                    {
                        NSString *locationCoordinates = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"location_coordinates"];
                        if([locationCoordinates isEqual:[NSNull null]])
                            locationCoordinates = @"";
                        
                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
                        
                        
                        [message setCustomParameters:custom_Data];
                        custom_Data = nil;
                        
                    }
                    
                    
                    [TempImageDataHistory addObject:[[NSData alloc] init]];
                    //end of image data check
                    
                    
                    NSTimeInterval seconds = [SentOn doubleValue];
                    
                    NSDate* ts_utc = [NSDate  dateWithTimeIntervalSince1970:seconds];
                    
                    
                    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
                    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
                    [df_local setDateFormat:@"hh:mm a"];
                    
                    
                    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
                    
                    message.datetime = [df_local dateFromString:ts_local_string];
                    
                    df_local = nil;
                    
                    
                    
                    //fetching video data
                    if([type intValue]==4 && contentURL.length>0)
                    {
                        NSString * video_thumbnail = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"video_thumb"];
                        
                        if(video_thumbnail == (NSString*)[NSNull null])
                            video_thumbnail = @"";
                        
                        
                        NSMutableDictionary *video_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"videoID", video_thumbnail ,@"videoThumbnail",
                                                           nil];
                        
                        
                        [message setCustomParameters:video_Data];
                        
                        video_Data = nil;
                        video_thumbnail = nil;
                    }
                    
                    
                    if([type intValue]==3 && contentURL.length>0)
                    {
                        
                        NSMutableDictionary *audio_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"audioID",
                                                           nil];
                        
                        [message setCustomParameters:audio_Data];
                        audio_Data = nil;
                        
                        
                    }
                    
                                        
                    //fetching cards data
                    if([type intValue]==5 && [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"cards"] != [NSNull null] )
                    {
                        message.text=@"";
                        
                        NSArray *cards_array = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"cards"];
                        
                        NSString *card_actionText;
                        
                        NSLog(@"%@",[cards_array objectAtIndex:5]);
                        
                        
                        if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
                        {
                            card_actionText = @"ACCEPTED!";
                        }
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
                        {
                            card_actionText = @"REJECTED!";
                        }
                        else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
                            card_actionText = @"COUNTERED CARD";
                        else
                            card_actionText = @"PLAYED A CARD";
                        
                        NSString *card_owner;
                        if([[cards_array objectAtIndex:6] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]]])
                        {
                            card_owner =[NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]];
                        }
                        else{
                            card_owner = @"";
                        }
                        
                        NSString *card_clicks;
                        if([[cards_array objectAtIndex:4] length]==1)
                            card_clicks = [NSString stringWithFormat:@"0%@",[cards_array objectAtIndex:4]];
                        else
                            card_clicks = [cards_array objectAtIndex:4];
                        
                        if(cards_array.count>5)
                        {
                            
                            NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:card_clicks,@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", [cards_array objectAtIndex:7] , @"is_CustomCard",
                                                               [cards_array objectAtIndex:6],@"card_originator",
                                                               [cards_array objectAtIndex:8],@"card_DB_ID",card_owner,@"card_owner",nil];
                            
                            [message setCustomParameters:cards_data];
                        }
                        
                        NSDictionary *cardDict;
                        if(cards_array.count>9)
                        {
                            if([[cards_array objectAtIndex:9] isEqualToString:@"playing"])
                                cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"0",@"status", nil];
                            else
                                cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"1",@"status", nil];
                        }
                        else
                        {
                            cardDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%i",TempArrayChatHistory.count],@"index",@"1",@"status", nil];
                        }
                        
                        [TempCardStatusHistory addObject:cardDict];
                        
                        cardDict = nil;
                        cards_array=nil;
                        card_actionText=nil;
                        card_owner = nil;
                        card_clicks = nil;
                    }
                    
                    
                    //check for shared message
                    //if([type intValue]==7)
                    {

                        
                        NSArray *shared_array = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"sharedMessage"];
                        
                        if([[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"sharedMessage"] != [NSNull null] )
                        {
                        if(shared_array.count>7)
                        {
                            NSMutableDictionary *setCustom_Data = [[NSMutableDictionary alloc] init] ;
                            [setCustom_Data addEntriesFromDictionary:message.customParameters];
                            [setCustom_Data setObject:[shared_array objectAtIndex:0] forKey:@"originalMessageID"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:1] forKey:@"shareStatus"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:2] forKey:@"messageSenderID"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:3] forKey:@"isAccepted"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:4] forKey:@"isMessageSender"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:5] forKey:@"comment"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:6] forKey:@"sharingMedia"];
                            [setCustom_Data setObject:[shared_array objectAtIndex:7] forKey:@"facebookToken"];

                            
                            [message setCustomParameters:setCustom_Data];
                            
                            setCustom_Data = nil;
                        }
                        }
                        
                    }
                    
                    if([[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"isDelivered"] != [NSNull null] && [[[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"isDelivered"] length]>0)
                    {
                        NSMutableDictionary *setCustom_Data = [[NSMutableDictionary alloc] init] ;
                        [setCustom_Data addEntriesFromDictionary:message.customParameters];
                        [setCustom_Data setObject:[[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"isDelivered"] forKey:@"isDelivered"];
                        
                        [message setCustomParameters:setCustom_Data];
                        
                        setCustom_Data = nil;
                        
                        
                        //send delivered message if not delivered
                        if([[[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"isDelivered"] isEqualToString:@"no"])
                        {
                        
                            if(![[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]]isEqualToString:[NSString stringWithFormat:@"%d",message.senderID]] )
                            {
                                QBChatMessage * new_message = [[QBChatMessage alloc] init];
                                new_message.text = @"Delivered.";
                                
                                NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
                                
                                [custom_Data setObject:@"yes" forKey:@"isDelivered"];
                                [custom_Data setObject:message.ID forKey:@"messageID"];
                                [new_message setCustomParameters:custom_Data];
                                custom_Data = nil;
                                
                                new_message.senderID = message.recipientID;
                                
                                new_message.recipientID = message.senderID;
                                
                                //set custom object for message
                                NSDate *currDate = [NSDate date];
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                                [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
                                NSString *dateString = [dateFormatter stringFromDate:currDate];
                                NSLog(@"dateString: %@",dateString);
                                
                                NSString *uniqueString = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%ld",(long)new_message.senderID],[NSString stringWithFormat:@"%ld",(long)new_message.recipientID],dateString];
                                
                                new_message.ID = uniqueString;
                                
                                [self sendMessage:new_message dict:nil];
                                
                                //crating custom object
                                QBCOCustomObject *object = [QBCOCustomObject customObject];
                                object.className = QBchatTable; // your Class name
                                
                                //NSString *StrClicks = message.customParameters[@"clicks"];
                                
                                [object.fields setObject:new_message.ID forKey:@"chatId"];
                                
                                NSString *StrClicks = new_message.customParameters[@"clicks"];
                                
                                
                                [object.fields setObject:@"7" forKey:@"type"];
                                
                                if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
                                {
                                    [object.fields setObject:@"" forKey:@"clicks"];
                                    [object.fields setObject:new_message.text forKey:@"message"];
                                }
                                else
                                {
                                    NSString *Str = [new_message.text substringWithRange:NSMakeRange(3, [new_message.text length]-3)];
                                    NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                                    Str = [Str stringByReplacingCharactersInRange:range withString:@""];
                                    
                                    [object.fields setObject:Str forKey:@"message"];
                                    [object.fields setObject:StrClicks forKey:@"clicks"];
                                }
                                
                                
                                [object.fields setObject:@"" forKey:@"content"];
                                
                                [object.fields setObject:new_message.customParameters[@"messageID"] forKey:@"deliveredChatID"];
                                
                                
                                [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];// crash
                                [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
                                [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
                                
                                [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
                                
                                [QBCustomObjects createObject:object delegate:self];
                                
                                new_message=nil;
                            }
                        }

                    }
                    
                    
                    
                    [TempArrayChatHistory addObject:message];
                    
                    
                    /*if([TempArrayChatHistory count] == 1)
                        {
                            self.strChatIdOfFirstRecord = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"chats"]] objectAtIndex:i] objectForKey:@"Chat"] objectForKey:@"chatId"];
                        }*/
                    message = nil;
                }
                
                
                NSArray *ArrTemp = [NSArray arrayWithArray:self.messages];
                NSLog(@"%d",[self.messages count]);
                [self.messages removeAllObjects];
                [self.messages addObjectsFromArray:TempArrayChatHistory];
                [self.messages addObjectsFromArray:ArrTemp];
                
                
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No chat history found"])
            {
                // no records found
//                if(appDelegate.isFlowFromNotification == true)
//                {
//                    [self.messages removeAllObjects];
//                }
                
                [TempArrayChatHistory removeAllObjects];
                [TempImageDataHistory removeAllObjects];
                [TempCardStatusHistory removeAllObjects];
            }
        }
        else if([request responseStatusCode] == 401)
        {
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:@"Some error occured."
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self postChatHistoryFetched];
    }
    else
    {
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    appDelegate.isFlowFromNotification = false;
}


#pragma mark
#pragma mark QBChatDelegate

- (void)chatDidLogin{
    // Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:20
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatDidLogin object:nil userInfo:Nil];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isChatLoggedIn = true;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatLoginStatusChanged object:nil userInfo:Nil];
}

- (void)chatDidFailWithError:(int)code{
    // relogin here
    QBUUser *currentUser = [QBUUser user];
    currentUser.ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]; // your current user's ID
    currentUser.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"]; // your current user's password
    [[QBChat instance] loginWithUser:currentUser];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isChatLoggedIn = false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatLoginStatusChanged object:nil userInfo:Nil];
}

- (void)chatDidNotLogin
{
    [QBAuth createSessionWithDelegate:(AppDelegate *)[[UIApplication sharedApplication]delegate]];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isChatLoggedIn = false;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatLoginStatusChanged object:nil userInfo:Nil];
}


- (void)chatDidNotSendMessage:(QBChatMessage *)message
{
    /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Failed to send message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    alert = nil;*/
    [[QBChat instance] sendMessage:message];
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    
    if([message.text isEqualToString:@" "])
        message.text = @"";
    
    // play sound notification
    if([message.customParameters[@"isDelivered"] length]==0 && [message.customParameters[@"isComposing"] length] == 0)
    {
        if([message.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"accepted"])
        {
            [self performSelector:@selector(playTradeCardAcceptedSound) withObject:nil afterDelay:0.2];
        }
        else if([message.customParameters[@"card_Accepted_Rejected"] isEqualToString:@"rejected"])
        {
            [self performSelector:@selector(playTradeCardRejectedSound) withObject:nil afterDelay:0.2];
            
        }
        else if([message.customParameters[@"clicks"] length] == 0 || [message.customParameters[@"clicks"] isEqualToString:@"no"] || [message.customParameters[@"shareStatus"] length]>0 )
            [self performSelector:@selector(playMsgReceivedSound) withObject:nil afterDelay:0.2];
        else
            [self performSelector:@selector(playClickReceivedSound) withObject:nil afterDelay:0.2];
        
        NSString *senderID = [NSString stringWithFormat:@"%ld",(long)message.senderID];
        
        NSString *partnerQBId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LeftMenuPartnerQBId"];
        if([senderID isEqualToString:partnerQBId])
        {
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.play_chatAnimation = true;
            appDelegate = nil;
        }
        senderID = nil;
        partnerQBId = nil;
    }

    if([message.customParameters[@"isDelivered"] length]==0 && [message.customParameters[@"isComposing"] length] == 0 && [[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"]!=nil)
    {
        QBChatMessage * new_message = [[QBChatMessage alloc] init];
        new_message.text = @"Delivered.";
        
        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] init] ;
        
        [custom_Data setObject:@"yes" forKey:@"isDelivered"];
        [custom_Data setObject:message.ID forKey:@"messageID"];
        [new_message setCustomParameters:custom_Data];
        custom_Data = nil;
        
        new_message.senderID = message.recipientID;
        
        new_message.recipientID = message.senderID;
        
        //set custom object for message
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"ddMMYYHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSLog(@"dateString: %@",dateString);
        
        NSString *uniqueString = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%ld",(long)new_message.senderID],[NSString stringWithFormat:@"%ld",(long)new_message.recipientID],dateString];
        
        new_message.ID = uniqueString;
        
        [self sendMessage:new_message dict:nil];
        //crating custom object
        QBCOCustomObject *object = [QBCOCustomObject customObject];
        object.className = QBchatTable; // your Class name
        
        //NSString *StrClicks = message.customParameters[@"clicks"];
        
        [object.fields setObject:new_message.ID forKey:@"chatId"];
        
        NSString *StrClicks = new_message.customParameters[@"clicks"];
        
        
        [object.fields setObject:@"7" forKey:@"type"];
        
        if([StrClicks isEqualToString:@"no"] || StrClicks.length == 0)
        {
            [object.fields setObject:@"" forKey:@"clicks"];
            [object.fields setObject:new_message.text forKey:@"message"];
        }
        else
        {
            NSString *Str = [new_message.text substringWithRange:NSMakeRange(3, [new_message.text length]-3)];
            NSRange range = [Str rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
            Str = [Str stringByReplacingCharactersInRange:range withString:@""];
            
            [object.fields setObject:Str forKey:@"message"];
            [object.fields setObject:StrClicks forKey:@"clicks"];
        }
        
        
        [object.fields setObject:@"" forKey:@"content"];
        
        [object.fields setObject:new_message.customParameters[@"messageID"] forKey:@"deliveredChatID"];
        
        
        [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"relationShipId"] forKey:@"relationshipId"];
        [object.fields setObject:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"]] forKey:@"userId"];
        [object.fields setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] forKey:@"senderUserToken"];
        
        [object.fields setObject:[NSString stringWithFormat:@"%ld",(long)[[self getUTCFormateDate:[NSDate date]] timeIntervalSince1970]] forKey:@"sentOn"];
        
        [QBCustomObjects createObject:object delegate:self];

        
        new_message=nil;
    }
    
    
//    // notify observers
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationDidReceiveNewMessage
//                                                        object:nil userInfo:@{kMessage: message}];
    
    [LeftMessageReceiveDelegate LeftchatDidReceiveMessageNotification:@{kMessage: message}];
    
    
    if(CenterMessageReceiveDelegate==Nil)
    {
        UINavigationController *navigationController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).slideContainer.centerViewController;
        NSArray *viewControlles = [navigationController viewControllers];
        CenterViewController *obj ;
        
        for (int i = 0 ; i <viewControlles.count; i++){
            if ([[viewControlles objectAtIndex:i] isKindOfClass:[CenterViewController class]]) {
                //Execute your code
                obj = (CenterViewController*)[viewControlles objectAtIndex:i];
                CenterMessageReceiveDelegate=obj;
                break;
                
            }
        }
    }
    [CenterMessageReceiveDelegate CenterchatDidReceiveMessageNotification:@{kMessage: message}];
    
   // [self performSelector:@selector(tempAction:) withObject:message afterDelay:0.2];
}

//-(void)tempAction:(QBChatMessage *)message
//{
//    [LeftMessageReceiveDelegate LeftchatDidReceiveMessageNotification:@{kMessage: message}];
//    [CenterMessageReceiveDelegate CenterchatDidReceiveMessageNotification:@{kMessage: message}];
//}


#pragma mark -
#pragma mark QBActionStatusDelegate

// QuickBlox API queries delegate
- (void)completedWithResult:(Result *)result
{
    //call centerViews completedWithResult method
   // [LeftMessageReceiveDelegate LeftchatDidReceiveMessageNotification:@{kMessage: message}];
    
    [CenterCustomObjDelegate completedWithResultNotification:result];
}



-(NSDate *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    NSDate *newDate = [dateFormatter dateFromString:dateString];
    dateFormatter=nil;
    dateString = nil;
    return newDate;
}

#pragma mark post notifications
-(void) postChatHistoryFetched
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChatHistoryFetched object:nil userInfo:Nil];
}


#pragma mark
#pragma mark Additional

//static SystemSoundID soundID;
- (void)playMsgReceivedSound
{
    /*if(soundID == 0){
        NSString *path = [NSString stringWithFormat: @"%@/Message_Rcvd.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *filePath = [NSURL fileURLWithPath: path isDirectory: NO];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    }
    
    AudioServicesPlaySystemSound(soundID);*/
    
    [inComingMsgSound play];
}

-(void)playClickReceivedSound
{
    [inComingClicksSound play];
}

-(void)playTradeCardAcceptedSound
{
    [cardAcceptedSound play];
}

-(void)playTradeCardRejectedSound
{
    [cardRejectedSound play];
}


@end
