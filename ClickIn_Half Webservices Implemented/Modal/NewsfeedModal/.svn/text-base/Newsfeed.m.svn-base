//
//  Event.m
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import "Newsfeed.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface NSDictionary (JRAdditions)
- (NSDictionary *) dictionaryByReplacingNullsWithStrings;
@end

@implementation NSDictionary (JRAdditions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}
@end



@implementation Newsfeed
@synthesize newsfeedID,message,senderID, senderName,senderPhoneNo,senderImageUrl, receiverID, receiverName,receiverPhoneNo,receiverImageUrl,senderTime,receiverTime,commentCount,starCount,userStarred,userCommented, isSenderFollower,isReceiverFollower,commentsArray,starredArray,commentsArrayNewsfeedPage,starredArrayNewsfeedPage,showReportBtns;


#pragma mark

- (id)init
{
    self = [super init];
    if (self) {
        self.newsfeedID=@"";
        self.commentsArray = [[NSMutableArray alloc] init];
        self.starredArray = [[NSMutableArray alloc] init];
        self.commentsArrayNewsfeedPage = [[NSMutableArray alloc] init];
        self.starredArrayNewsfeedPage = [[NSMutableArray alloc] init];
    }
    return self;
}


#pragma mark Event Custom Methods
-(NSMutableArray*)getNewsfeedComments:(BOOL)shouldRefresh
{
    if(shouldRefresh)
        [self fetchCommentsWebService];
    
    return commentsArray;
}

-(void)fetchCommentsWebService
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/fetchcommentstars"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", @"comment", @"type", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 14;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    
}

-(void)addComment:(NSString*)comment
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/savecommentstar"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID ,@"newsfeed_id", comment, @"comment" , @"comment", @"type", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 44;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        Dictionary = nil;
        
        NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
        [df_local setTimeZone:[NSTimeZone systemTimeZone]];
        [df_local setDateFormat:@"hh:mm a"];
        
        
        NSString* localTime_string = [df_local stringFromDate:[NSDate date]];
        
        NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_pic"], @"user_pic", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"] , @"user_name", comment, @"comment" , localTime_string , @"time", nil];
        
        
        [commentsArray addObject:personDict];
        personDict = nil;
        df_local = nil;
        localTime_string = nil;
        
        commentCount = [NSString stringWithFormat:@"%i",[commentCount integerValue]+1 ];
        
        [self postCommentsUpdated];
        
        
    }

}

-(NSMutableArray*)getStarredUsers:(BOOL)shouldRefresh
{
    if(shouldRefresh)
        [self getStarredUsers];
    return starredArray;
}

-(void)getStarredUsers
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/fetchcommentstars"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", @"star", @"type", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 15;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }

}

-(void)addStarredUser
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/savecommentstar"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", @"star", @"type", nil];
        
        NSLog(@"%@",Dictionary);
        
        request.tag = 77;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        userStarred = @"1";
        starCount = [NSString stringWithFormat:@"%i",[starCount integerValue]+1 ];
        
        [self postUserStarred];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }

}

//remove starred user
-(void)removeStarredUser
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/unstarrednewsfeed"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", nil];
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
//        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
//        NSLog(@"responseString %@",[request responseString]);

        userStarred = @"0";
        starCount = [NSString stringWithFormat:@"%i",[starCount integerValue]-1];
        
        [self postUserStarred];
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    
}



-(void)getNewsfeedByID:(BOOL)isSynchronous
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"/newsfeed/view"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        NSError *error;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *Dictionary;
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token", newsfeedID, @"newsfeed_id", nil];
        
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTag:786];
        [request setTimeOutSeconds:200];
        if(isSynchronous)
            [request startSynchronous];
        else
            [request startAsynchronous];
            
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
//        NSError *errorr = nil;
//        
//        
//        NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
//        
//        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorr];
        
        
//        if([request responseStatusCode] == 200)
//        {
//            
//            for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] count]; i++)
//            {
//                if([[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != (NSDictionary*)[NSNull null] && [[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != nil && [[[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] count] != 0)
//                {
//                    message = [[QBChatMessage alloc] init];
//                    
//                    NSString *MessageText = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"message"] == nil)
//                    {
//                        MessageText = @"";
//                    }
//                    
//                    NSString *MessageClicks = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"clicks"] == nil)
//                    {
//                        MessageClicks = @"";
//                    }
//                    
//                    
//                    NSString *chatId = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"chatId"] == nil)
//                    {
//                        chatId = @"";
//                    }
//                    
//                    
//                    NSString *star_Count = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"];
//                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"stars_count"] == nil)
//                    {
//                        star_Count = @"0";
//                    }
//                    starCount = star_Count;
//                    
//                    NSString *comment_Count = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"];
//                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] == nil)
//                    {
//                        comment_Count = @"0";
//                    }
//                    commentCount = comment_Count;
//                    
//                    NSString *isUserStarred = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"];
//                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] == nil)
//                    {
//                        isUserStarred = @"0";
//                    }
//                    userStarred = isUserStarred;
//                    
//                    NSString *isUserCommented = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"];
//                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] == nil)
//                    {
//                        isUserCommented = @"0";
//                    }
//                    userCommented = isUserCommented;
//                    
//                    
//                    NSString *sender_Name = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] == nil)
//                    {
//                        sender_Name = @"";
//                    }
//                    
//                    
//                    NSString *sender_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] == nil)
//                    {
//                        sender_ID = @"";
//                    }
//                    senderID = sender_ID;
//                    
//                    
//                    NSString *senderUrl = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"user_pic"] == nil)
//                    {
//                        senderUrl = @"";
//                    }
//                    
//                    
//                    NSString *receiver_Name = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"name"] == nil)
//                    {
//                        receiver_Name = @"";
//                    }
//                    
//                    NSString *receiver_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] == nil)
//                    {
//                        receiver_ID = @"";
//                    }
//                    receiverID = receiver_ID;
//                    
//                    
//                    NSString *receiverUrl = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"];
//                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] == nil)
//                    {
//                        receiverUrl = @"";
//                    }
//                    
//                    
//                    NSString *Time = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] substringWithRange:NSMakeRange(11, 5)] ;
//                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"created"] == nil)
//                    {
//                        Time = @"";
//                    }
//                    else
//                    {
//                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//                        [formatter setDateFormat:@"HH:mm"];
//                        NSDate *sourceDate = [formatter dateFromString:Time];
//                        
//                        
//                        
//                        NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
//                        [df_local setTimeZone:[NSTimeZone systemTimeZone]];
//                        [df_local setDateFormat:@"HH:mm"];
//                        NSString *date = [df_local stringFromDate:sourceDate];
//                        
//                        
//                        NSArray *time_components = [date componentsSeparatedByString:@":"];
//                        
//                        if([[time_components objectAtIndex:0] integerValue]>=12)
//                            Time = [NSString stringWithFormat:@"%@:%@ PM",[time_components objectAtIndex:0],[time_components objectAtIndex:1]];
//                        else
//                            Time = [NSString stringWithFormat:@"%@:%@ AM",[time_components objectAtIndex:0],[time_components objectAtIndex:1]];
//                        
//                        time_components = nil;
//                        formatter = nil;
//                        df_local = nil;
//                    }
//                    
//                    
//                    commentsArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"commentArray"] mutableCopy];
//                    
//                    starredArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"starredArray"] mutableCopy];
//                    
//                    senderTime = Time;
//                    
//                    receiverTime = Time;
//                    
//                    senderImageUrl = senderUrl;
//                    receiverImageUrl = receiverUrl;
//                    senderName = sender_Name;
//                    receiverName = receiver_Name;
//                    
//                    isSenderFollower = @"false";
//                    isReceiverFollower = @"false";
//                    /*for(int j = 0; j < self.followingIDS.count; j++)
//                     {
//                     if([[NSString stringWithFormat:@"%@",[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[self.followingIDS objectAtIndex:j]]])
//                     {
//                     self.isSenderFollower = @"true";
//                     break;
//                     }
//                     }*/
//                    
//                    
//                    
//                    message.ID = chatId;
//                    if(![MessageClicks isEqual:[NSNull null]])
//                    {
//                        if([[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"00"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"0"] || [[MessageClicks stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]] isEqualToString:@"-00"])
//                        {
//                            message.text = MessageText;
//                            
//                            [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
//                        }
//                        else
//                        {
//                            [message setCustomParameters:[@{@"clicks" : [NSString stringWithFormat:@"%@",MessageClicks]} mutableCopy]];
//                            message.text = [NSString stringWithFormat:@"%@%@",MessageClicks ,MessageText];
//                            
//                        }
//                    }
//                    else
//                    {
//                        message.text = MessageText;
//                        [message setCustomParameters:[@{@"clicks" : @"no"} mutableCopy]];
//                    }
//                    
//                    
//                    
//                    //check for image data
//                    NSString *contentURL = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"];
//                    if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"content"] == nil)
//                    {
//                        contentURL = @"";
//                    }
//                    
//                    NSNumber *type = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"];
//                    if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"type"] == nil)
//                    {
//                        type= 0;
//                    }
//                    
//                    
//                    
//                    NSString *imageRatio = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"];
//                    if([NSNull null] == [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"] || [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"imageRatio"] == nil)
//                    {
//                        imageRatio = @"1";
//                    }
//                    
//                    
//                    
//                    if([type intValue]==2 && contentURL.length>0)
//                    {
//                        
//                        
//                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"fileID", imageRatio, @"imageRatio", nil];
//                        [message setCustomParameters:custom_Data];
//                        custom_Data = nil;
//                        
//                    }
//                    
//                    //location data
//                    if([type intValue]==6 && contentURL.length>0)
//                    {
//                        NSString *locationCoordinates = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"location_coordinates"];
//                        if([locationCoordinates isEqual:[NSNull null]])
//                            locationCoordinates = @"";
//                        
//                        NSMutableDictionary *custom_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys: message.customParameters[@"clicks"] ,@"clicks", contentURL, @"locationID", imageRatio, @"imageRatio", locationCoordinates, @"location_coordinates", nil];
//                        //[message setCustomParameters:[@{@"fileID": contentURL} mutableCopy]];
//                        
//                        [message setCustomParameters:custom_Data];
//                        custom_Data = nil;
//                        
//                    }
//                    
//                    
//                    
//                    //fetching video data
//                    if([type intValue]==4 && contentURL.length>0)
//                    {
//                        NSString * video_thumbnail = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"video_thumb"];
//                        
//                        if(video_thumbnail == (NSString*)[NSNull null])
//                            video_thumbnail = @"";
//                        
//                        
//                        
//                        NSMutableDictionary *video_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"videoID", video_thumbnail ,@"videoThumbnail",
//                                                           nil];
//                        
//                        
//                        [message setCustomParameters:video_Data];
//                        
//                        video_Data = nil;
//                        video_thumbnail = nil;
//                    }
//                    
//                    
//                    if([type intValue]==3 && contentURL.length>0)
//                    {
//                        
//                        
//                        NSMutableDictionary *audio_Data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                                           message.customParameters[@"clicks"] ,@"clicks", contentURL,@"audioID",
//                                                           nil];
//                        
//                        [message setCustomParameters:audio_Data];
//                        audio_Data = nil;
//                        
//                    }
//                    
//                    //fetching cards data
//                    if([type intValue]==5)
//                    {
//                        message.text=@"";
//                        
//                        NSArray *cards_array = [[[[[NSArray alloc] initWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"chatDetail"] objectForKey:@"cards"];
//                        
//                        NSString *card_actionText;
//                        
//                        if([[cards_array objectAtIndex:5] isEqualToString:@"accepted"])
//                            card_actionText = @"ACCEPTED!";
//                        else if([[cards_array objectAtIndex:5] isEqualToString:@"rejected"])
//                            card_actionText = @"REJECTED!";
//                        else if([[cards_array objectAtIndex:5] isEqualToString:@"countered"])
//                            card_actionText = @"COUNTERED CARD";
//                        else
//                            card_actionText = @"PLAYED A CARD";
//                        
//                        
//                        if(cards_array.count>5)
//                        {
//                            
//                            NSMutableDictionary *cards_data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[cards_array objectAtIndex:4],@"card_clicks",[cards_array objectAtIndex:1],@"card_heading",[cards_array objectAtIndex:2],@"card_content",[cards_array objectAtIndex:3],@"card_url", card_actionText,@"card_Played_Countered", [cards_array objectAtIndex:5],@"card_Accepted_Rejected", [cards_array objectAtIndex:0],@"card_id", [cards_array objectAtIndex:7] , @"is_CustomCard", nil];
//                            
//                            [message setCustomParameters:cards_data];
//                        }
//                        
//                        
//                        
//                        cards_array=nil;
//                        card_actionText=nil;
//                    }
//                
//                }
//            }
//            //NSLog(@"%@",selectedNewsfeed.isSenderFollower);
//            
//            
//        }
//        if([request responseStatusCode] == 500)
//        {
//            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User don't have any newsfeed."])
//            {
//                //                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User don't have any newsfeed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                //                [alert show];
//                //                alert = nil;
//            }
//        }
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }
    
}

-(void)deleteNewsfeed
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/delete"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", nil];
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        
    }
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
        
    }

}

-(void)reportNewsfeedInappropriate
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"newsfeed/reportinappropriate"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",newsfeedID,@"newsfeed_id", nil];
        
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
    else
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertTitleNetRech message:alertNetRechMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:alertTitleNetRech
                                                                        description:alertNetRechMessage
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView show];
        alertView = nil;
    }

}



#pragma mark RequestFinished Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if(request.tag == 14)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                [commentsArray removeAllObjects];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"records"]];
                for (int i = 0; i<[tempArray count]; i++)
                {
                    NSTimeInterval seconds = [[[[tempArray objectAtIndex:i] objectForKey:@"modified"] objectForKey:@"sec"] doubleValue];
                    
                    NSDate* ts_utc = [NSDate  dateWithTimeIntervalSince1970:seconds];
                    
                    
                    NSDateFormatter* df_local = [[NSDateFormatter alloc] init];
                    [df_local setTimeZone:[NSTimeZone systemTimeZone]];
                    [df_local setDateFormat:@"hh:mm a"];
                    
                    
                    NSString* ts_local_string = [df_local stringFromDate:ts_utc];
                    
                    
                    NSDictionary *personDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[tempArray objectAtIndex:i] objectForKey:@"user_pic"], @"user_pic", [[tempArray objectAtIndex:i] objectForKey:@"user_name"], @"user_name", [[tempArray objectAtIndex:i] objectForKey:@"comment"], @"comment" , /*[df_local dateFromString:ts_local_string]*/ ts_local_string ,@"time", nil];
                    [commentsArray addObject:personDict];
                    personDict = nil;
                    
                    ts_utc = nil;
                    ts_local_string=nil;
                    df_local = nil;
                }
                
                //usersArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"records"]];
                
                [self postCommentsUpdated];
                
            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:errorl.description
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        else if([request responseStatusCode] == 500)
        {
            /* UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"No comments posted"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             alert = nil;*/
            
            [self postCommentsUpdated];
        }
        else
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;
        }
    }
    else if(request.tag == 15)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                [starredArray removeAllObjects];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"records"]];
                for (int i = 0; i<[tempArray count]; i++)
                {
                    [starredArray addObject:[[tempArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                }
                
                //usersArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"records"]];
                
                tempArray = nil;
                
                [self postStarredUsersUpdated];
                
            }
            else
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:errorl.description
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        else if([request responseStatusCode] == 500)
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            /*UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"No records found"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             alert = nil;*/
            
            [self postStarredUsersUpdated];
        }
        else
        {
            //NSError *errorl = nil;
            //NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            //NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView show];
            alertView = nil;

            
        }
        
    }
    else if(request.tag==786)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            for (int i = 0; i < [[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] count]; i++)
            {
                if([[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != (NSDictionary*)[NSNull null] && [[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] != nil && [[[[jsonResponse objectForKey:@"newsfeedArray"] objectAtIndex:i] objectForKey:@"chatDetail"] count] != 0)
                {
                    message = [[QBChatMessage alloc] init];
                    
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
                    starCount = star_Count;
                    
                    NSString *comment_Count = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"];
                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"comments_count"] == nil)
                    {
                        comment_Count = @"0";
                    }
                    commentCount = comment_Count;
                    
                    NSString *isUserStarred = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"];
                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_starred"] == nil)
                    {
                        isUserStarred = @"0";
                    }
                    userStarred = isUserStarred;
                    
                    NSString *isUserCommented = [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"];
                    if([NSNull null] == [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] || [[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"user_commented"] == nil)
                    {
                        isUserCommented = @"0";
                    }
                    userCommented = isUserCommented;
                    
                    
                    NSString *sender_Name = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"];
                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"name"] == nil)
                    {
                        sender_Name = @"";
                    }
                    
                    
                    NSString *sender_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"];
                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"] == nil)
                    {
                        sender_ID = @"";
                    }
                    senderID = sender_ID;
                    
                    
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
                    
                    NSString *receiver_ID = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"];
                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"_id"] == nil)
                    {
                        receiver_ID = @"";
                    }
                    receiverID = receiver_ID;
                    
                    
                    NSString *receiverUrl = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"];
                    if([NSNull null] == [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] || [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"receiverDetail"] objectForKey:@"user_pic"] == nil)
                    {
                        receiverUrl = @"";
                    }
                    
                    
                    ///////new update for sender and receiver phone number
                    
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
                    
                    senderPhoneNo = sender_Phone;
                    receiverPhoneNo = receiver_Phone;
                    
                    //////////////////////////////////////////////////////
                    
                    
                    
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
                    
                    
                    commentsArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"commentArray"] mutableCopy];
                    
                    starredArrayNewsfeedPage = [[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"starredArray"] mutableCopy];
                    
                    senderTime = Time;
                    
                    receiverTime = Time;
                    
                    senderImageUrl = senderUrl;
                    receiverImageUrl = receiverUrl;
                    senderName = sender_Name;
                    receiverName = receiver_Name;
                    
                    isSenderFollower = @"false";
                    isReceiverFollower = @"false";
                    /*for(int j = 0; j < self.followingIDS.count; j++)
                     {
                     if([[NSString stringWithFormat:@"%@",[[[[NSArray arrayWithArray:[jsonResponse objectForKey:@"newsfeedArray"]] objectAtIndex:i] objectForKey:@"senderDetail"] objectForKey:@"_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[self.followingIDS objectAtIndex:j]]])
                     {
                     self.isSenderFollower = @"true";
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
                    
                }
            }
            //NSLog(@"%@",selectedNewsfeed.isSenderFollower);
            
            [self postNewsfeedUpdated];
        }
    }
}



#pragma mark post notifications
-(void)postCommentsUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsfeedCommentsUpdated object:nil userInfo:Nil];
}

-(void)postStarredUsersUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsfeedStarredUsersUpdated object:nil userInfo:Nil];
}

-(void)postUserStarred
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsfeedUserStarred object:nil userInfo:Nil];
}

-(void)postNewsfeedUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_NewsfeedByID object:nil userInfo:Nil];
}



@end
