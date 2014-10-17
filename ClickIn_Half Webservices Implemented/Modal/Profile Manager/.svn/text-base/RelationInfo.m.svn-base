//
//  RelationInfo.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 28/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "RelationInfo.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@implementation RelationInfo
@synthesize relationship_ID,partnerName,partnerPhoneNumber,partnerPicUrl,partnerQB_ID,partnerClicks,ownerClicks,isAccepted,isPending,isRelationPublic,isRequestInitiator,userDetails,unreadMessagesCount;

#pragma mark

- (id)init
{
    self = [super init];
    if (self) {
        userDetails = [[UserInfo alloc] init];
        unreadMessagesCount = 0;
        
    }
    return self;
}


#pragma mark Service Calls
-(void) setRelationVisibility:(BOOL)isPublic
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/changevisibility"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        
        
        isRelationPublic = isPublic;
        
        
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationship_ID,@"relationship_id", [NSNumber numberWithBool:isPublic], @"public", nil];
        
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
        
        [self postRelationVisibilityUpdated];
        
    }
}

-(void) resetUnreadMessageCount:(NSString*)chatID
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"chats/resetunreadmessagecount"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",relationship_ID,@"relationship_id", chatID, @"last_chat_id", nil];
        
        NSLog(@"%@",Dictionary);
        
        
        request.tag = 77;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        
        NSLog(@"responseString %@",[request responseString]);
    }

}


#pragma mark post notifications
-(void)postRelationVisibilityUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RelationVisibilityUpdated object:nil userInfo:Nil];
}

@end
