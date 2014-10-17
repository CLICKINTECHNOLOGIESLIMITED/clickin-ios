//
//  EventManager.m
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import "NewsfeedManager.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@implementation NewsfeedManager
@synthesize array_model_feeds,isFetchingEarlier,isHistoryAvailable;


#pragma mark

- (id)init
{
    self = [super init];
    if (self) {
        array_model_feeds = [[NSMutableArray alloc] init];
        isFetchingEarlier = false;
        isHistoryAvailable = true;
    }
    return self;
}

#pragma mark Service Calls


-(NSArray*)getFeeds:(BOOL)shouldRefresh isFetchingEarlier:(BOOL)fetchEarlier
{
    if(shouldRefresh)
    {
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appDelegate performSelector:@selector(CheckInternetConnection)];
            if(appDelegate.internetWorking == 0)//0: internet working
            {
                NSString *str = [NSString stringWithFormat:DomainNameUrl@"/newsfeed/fetchnewsfeeds"];
                NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
                NSError *error;
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                
                NSDictionary *Dictionary;
                
                if(fetchEarlier)
                    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", ((Newsfeed*)[array_model_feeds lastObject]).newsfeedID, @"last_newsfeed_id", nil];
                else
                    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",nil];
                
                isFetchingEarlier = fetchEarlier;
                
                NSLog(@"%@",Dictionary);
                
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
                
                [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                
                [request appendPostData:jsonData];
                
                [request setRequestMethod:@"POST"];
                [request setDelegate:self];
                [request setTimeOutSeconds:200];
                
                if(array_model_feeds.count==0)
                    [request startSynchronous];
                else
                    [request startAsynchronous];
                NSLog(@"responseStatusCode %i",[request responseStatusCode]);
                NSLog(@"responseString %@",[request responseString]);
                
                
            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                                description:alertNetRechMessage
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;

            }
        
        
    }
    
    return array_model_feeds;
}

#pragma mark RequestFinished Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//    NSLog(@"responseString %@",[request responseString]);
    
    NSError *errorr = nil;
    
    NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
    
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorr];
    if([request responseStatusCode] == 200)
    {
        if(!isFetchingEarlier)
            [array_model_feeds removeAllObjects];
        
        for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] count]; i++)
        {
            if([[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != (NSDictionary*)[NSNull null] && [[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != nil && [[[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] count] != 0)
            {
                Newsfeed *newsfeed = [[Newsfeed alloc] init];
                
                QBChatMessage *message = [[QBChatMessage alloc] init];
                
                newsfeed.newsfeedID = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"_id"] ;
                
                NSString *MessageText = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"] == nil)
                {
                    MessageText = @"";
                }
                
                NSString *MessageClicks = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"] == nil)
                {
                    MessageClicks = @"";
                }
                
                
                NSString *chatId = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"] == nil)
                {
                    chatId = @"";
                }
                
                
                NSString *star_Count = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"];
                if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"] == nil)
                {
                    star_Count = @"0";
                }
                newsfeed.starCount = star_Count;
                
                NSString *comment_Count = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"];
                if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] == nil)
                {
                    comment_Count = @"0";
                }
                newsfeed.commentCount = comment_Count;
                
                NSString *isUserStarred = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"];
                if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] == nil)
                {
                    isUserStarred = @"0";
                }
                newsfeed.userStarred = isUserStarred;
                
                NSString *isUserCommented = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"];
                if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] == nil)
                {
                    isUserCommented = @"0";
                }
                newsfeed.userCommented = isUserCommented;
                
                NSString *sender_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] == nil)
                {
                    sender_ID = @"";
                }
                
                newsfeed.senderID = sender_ID;
                
                NSString *receiver_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] == nil)
                {
                    receiver_ID = @"";
                }
                
                newsfeed.receiverID = receiver_ID;
                
                
                NSString *sender_Name = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] == nil)
                {
                    sender_Name = @"";
                }
                
                
                NSString *senderUrl = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"] == nil)
                {
                    senderUrl = @"";
                }
                
                
                NSString *receiver_Name = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"] == nil)
                {
                    receiver_Name = @"";
                }
                
                
                NSString *receiverUrl = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] == nil)
                {
                    receiverUrl = @"";
                }
                
                
                NSString *Time = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] substringWithRange:NSMakeRange(11, 5)] ;
                if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] == nil)
                {
                    Time = @"";
                }
                else
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                    [formatter setDateFormat:@"HH:mm"];
                    NSDate *sourceDate = [formatter dateFromString:Time];
                    
                    
                    
                    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
                    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
                    [df_local setDateFormat:@"HH:mm"];
                    NSString *date = [df_local stringFromDate:sourceDate];
                    
                    
                    NSArray *time_components = [date componentsSeparatedByString:@":"];
                    
                    if([[time_components objectAtIndex:0] integerValue]>=12)
                        Time = [NSString stringWithFormat:@"%@:%@ PM",[time_components objectAtIndex:0],[time_components objectAtIndex:1]];
                    else
                        Time = [NSString stringWithFormat:@"%@:%@ AM",[time_components objectAtIndex:0],[time_components objectAtIndex:1]];
                    
                    time_components = nil;
                    formatter = nil;
                    df_local = nil;
                }
                
                newsfeed.commentsArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"commentArray"] mutableCopy];
                
                newsfeed.starredArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"starredArray"] mutableCopy];
                
                newsfeed.senderTime = Time;
                
                newsfeed.receiverTime = Time;
                
                newsfeed.senderImageUrl = senderUrl;
                newsfeed.receiverImageUrl = receiverUrl;
                newsfeed.senderName = sender_Name;
                newsfeed.receiverName = receiver_Name;
                
                NSString *sender_Phone = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"phone_no"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"phone_no"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"phone_no"] == nil)
                {
                    sender_Phone = @"";
                }
                
                NSString *receiver_Phone = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"phone_no"];
                if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"phone_no"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"phone_no"] == nil)
                {
                    receiver_Phone = @"";
                }

                newsfeed.senderPhoneNo = sender_Phone;
                newsfeed.receiverPhoneNo = receiver_Phone;
                
                newsfeed.isSenderFollower = @"false";
                newsfeed.isReceiverFollower = @"false";
                /*for(int j = 0; j < newsfeed.followingIDS.count; j++)
                 {
                 if([[NSString stringWithFormat:@"%@",[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[newsfeed.followingIDS objectAtIndex:j]]])
                 {
                 newsfeed.isSenderFollower = @"true";
                 break;
                 }
                 }*/
                
                
                
                message.ID = chatId;
                if(![MessageClicks isEqual:[NSNull null]])
                {
                    if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
                    {
                        message.text = MessageText;
                        
                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                    }
                    else
                    {
                        [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
                        message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
                        
                    }
                }
                else
                {
                    message.text = MessageText;
                    [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
                }
                
                
                
                //check for image data
                NSString *contentURL = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"];
                if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"] == nil)
                {
                    contentURL = @"";
                }
                
                NSNumber *type = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"];
                if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"] == nil)
                {
                    type= 0;
                }
                
                
                
                NSString *imageRatio = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"];
                if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"] == nil)
                {
                    imageRatio = @"1";
                }
                
                
                
                if([type intValue]==2 && contentURL.length>0)
                {
                    
                    
                    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
                    [message setCustomParameters:custom_Data];
                    custom_Data = nil;
                    
                }
                
                //location data
                if([type intValue]==6 && contentURL.length>0)
                {
                    NSString *locationCoordinates = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"location_coordinates"];
                    if([locationCoordinates isEqual:[NSNull null]])
                        locationCoordinates = @"";
                    
                    NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
                    //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
                    
                    [message setCustomParameters:custom_Data];
                    custom_Data = nil;
                    
                }
                
                
                
                //fetching video data
                if([type intValue]==4 && contentURL.length>0)
                {
                    NSString * video_thumbnail = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"video_thumb"];
                    
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
                if([type intValue]==5)
                {
                    message.text=@"";
                    
                    NSArray *cards_array = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"cards"];
                    
                    NSString *card_actionText;
                    
                    if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
                        card_actionText = @"ACCEPTED!";
                    else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
                        card_actionText = @"REJECTED!";
                    else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
                        card_actionText = @"COUNTERED CARD";
                    else
                        card_actionText = @"PLAYED A CARD";
                    
                    
                    if(cards_array.count>5)
                    {
                        
                        NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[cards_array objectAtIndex:4],@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", [cards_array objectAtIndex:7] , @"is_CustomCard", nil];
                        
                        [message setCustomParameters:cards_data];
                    }
                    
                    
                    
                    cards_array=nil;
                    card_actionText=nil;
                }
                
                newsfeed.message = message;
                
                [array_model_feeds addObject:newsfeed];
                message = nil;
                newsfeed = nil;
            }
        }
        
        [self postNewsfeedsUpdated];
        isFetchingEarlier = false;
        isHistoryAvailable = true;
        
    }
    
    else if([request responseStatusCode] == 401)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %@. Try again",[request responseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
//        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:[NSString stringWithFormat:@"Error : %@. Try again",[request responseString]]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;

        
    }
    else if([request responseStatusCode] == 400)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %@. Try again",[request responseString]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:[NSString stringWithFormat:@"Error : %@. Try again",[request responseString]]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;

        
    }
    else if([request responseStatusCode] == 500)
    {
        if(array_model_feeds.count==0)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"No newsfeed available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
        }
        [self postNewsfeedsUpdated];
        isFetchingEarlier = false;
        isHistoryAvailable = false;
        
    }
}

#pragma mark post notifications
-(void)postNewsfeedsUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsfeedsUpdated object:nil userInfo:Nil];
}


@end
