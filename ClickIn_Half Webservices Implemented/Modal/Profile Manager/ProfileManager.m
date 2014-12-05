//
//  ProfileManager.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 26/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "ProfileManager.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"

@interface NSDictionary (JRAdditions)
- (NSDictionary *) dictionaryByReplacingNullsWithStrings;
@end

@implementation NSDictionary (JRAdditions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings
{
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

@implementation ProfileManager

@synthesize relationshipArray,nonAcceptedRelationArray,othersRelationshipArray, ownerDetails,unreadMessageCountArray;

#pragma mark

- (id)init
{
    self = [super init];
    if (self) {
        relationshipArray = [[NSMutableArray alloc] init];
        nonAcceptedRelationArray = [[NSMutableArray alloc] init];
        othersRelationshipArray = [[NSMutableArray alloc] init];
        unreadMessageCountArray = [[NSMutableArray alloc] init];
        ownerDetails = [[UserInfo alloc] init];
        ownerDetails.is_Owner = true;
    }
    return self;
}


#pragma mark Service Calls
-(NSArray*)getRelations:(BOOL)shouldRefresh
{
    if(shouldRefresh)
    {
        NSString *str;
        NSURL *url;
        
        str = [NSString stringWithFormat:DomainNameUrl@"relationships/getrelationships"];
        url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSDictionary *Dictionary;
        
        NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        [request appendPostData:jsonData];
        request.tag = 15;
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
//        if(relationshipArray.count==0)
//        {
//            [request startSynchronous];
//            //[self getUnreadMessageCount];
//        }
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
        if(appDelegate.isRelationsFetchedFirstTime==true)
        {
            appDelegate.isRelationsFetchedFirstTime = false;
            [request startSynchronous];
        }
        else
            [request startAsynchronous];
        
        appDelegate = nil;

    }
    
    return relationshipArray;
}

-(NSArray*)getOtherUserRelations:(BOOL)shouldRefresh otherUserNo:(NSString*)otherUserPhoneNo
{
    if(shouldRefresh && ![otherUserPhoneNo isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"]])
    {
        NSString *str;
        NSURL *url;
        
        str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilerelationships/profile_phone_no:%s",[otherUserPhoneNo UTF8String]];
        str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            
        url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Phone-No" value:phoneno];
        [request addRequestHeader:@"User-Token" value:user_token];
        
        request.tag = 16;
        
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
    }
    
    return othersRelationshipArray;
}


-(void)getUnreadMessageCount
{
    NSString *str;
    NSURL *url;
    
    str = [NSString stringWithFormat:DomainNameUrl@"chats/getunreadmessagecount"];
    url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request appendPostData:jsonData];
    request.tag = 44;
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    
    [request startAsynchronous];
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if(request.tag==15)
    {
        if([request responseStatusCode] == 200)
        {
            [relationshipArray removeAllObjects];
            [nonAcceptedRelationArray removeAllObjects];
            
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"] || success)
            {
                NSLog(@"relationship description : %@",jsonResponse.description);
                
                
                if([jsonResponse objectForKey:@"relationships"] != [NSNull null])
                {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *tempRelationArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"relationships"]];
                    
                    for(int i=0;i<tempRelationArray.count;i++)
                    {
                        [tempArray addObject:[[tempRelationArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    }

                    tempRelationArray = nil;
                
                for (int i = 0; i<[tempArray count]; i++)
                {
                    RelationInfo *relationObj = [[RelationInfo alloc] init];
                    relationObj.relationship_ID = [[[tempArray objectAtIndex:i] objectForKey:@"id"] objectForKey:@"$id"];
                    relationObj.partnerName = [[tempArray objectAtIndex:i] objectForKey:@"partner_name"];
                    relationObj.partnerPhoneNumber = [[tempArray objectAtIndex:i] objectForKey:@"phone_no"];
                    relationObj.partnerPicUrl = [[tempArray objectAtIndex:i] objectForKey:@"partner_pic"];
                    relationObj.partnerQB_ID = [[tempArray objectAtIndex:i] objectForKey:@"partner_QB_id"];
                    relationObj.ownerClicks = [[tempArray objectAtIndex:i] objectForKey:@"user_clicks"];
                    relationObj.partnerClicks = [[tempArray objectAtIndex:i] objectForKey:@"clicks"];
                    relationObj.isRelationPublic = [[[tempArray objectAtIndex:i] objectForKey:@"public"] boolValue];
                    
                    if([[tempArray objectAtIndex:i] objectForKey:@"accepted"] == [NSNull null] ||
                       [[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"accepted"]] isEqualToString:@"<null>"])
                        relationObj.isAccepted = false;
                    else
                        relationObj.isAccepted = [[[tempArray objectAtIndex:i] objectForKey:@"accepted"] boolValue];
                    relationObj.isRequestInitiator = [[[tempArray objectAtIndex:i] objectForKey:@"request_initiator"] boolValue];
                    
                    
                    if([[NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] objectForKey:@"accepted"]] isEqualToString:@"1"])
                    {
                        [relationshipArray addObject:relationObj];
                    }
                    else
                    {
                        [nonAcceptedRelationArray addObject:relationObj];
                    }
                }
                
                tempArray = nil;
                }
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
            {
                
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
            
            //post notification
            [self postRelationsUpdated];
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
    else if(request.tag==16)
    {
        if([request responseStatusCode] == 200)
        {
            [othersRelationshipArray removeAllObjects];
            
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationships data found"] || success)
            {
                if([jsonResponse objectForKey:@"relationships"] != [NSNull null])
                {
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *tempRelationArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"relationships"]];
                    
                    for(int i=0;i<tempRelationArray.count;i++)
                    {
                        [tempArray addObject:[[tempRelationArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    }
                    
                    tempRelationArray = nil;
                    
                    
                for (int i = 0; i<[tempArray count]; i++)
                {
                    RelationInfo *relationObj = [[RelationInfo alloc] init];
                    relationObj.relationship_ID = [[[tempArray objectAtIndex:i] objectForKey:@"id"] objectForKey:@"$id"];
                    relationObj.partnerName = [[tempArray objectAtIndex:i] objectForKey:@"partner_name"];
                    relationObj.partnerPhoneNumber = [[tempArray objectAtIndex:i] objectForKey:@"phone_no"];
                    relationObj.partnerPicUrl = [[tempArray objectAtIndex:i] objectForKey:@"partner_pic"];
                    relationObj.partnerQB_ID = [[tempArray objectAtIndex:i] objectForKey:@"partner_QB_id"];
                    
                    [othersRelationshipArray addObject:relationObj];
                }
                
                tempArray = nil;
                }
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No relationships found"] || !success)
            {
                
            }
            else
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:errorl.description
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
            
            //post notification
            [self postRelationsUpdated];
        }
    }
    else if(request.tag==44){
        if([request responseStatusCode] == 200)
        {
            [unreadMessageCountArray removeAllObjects];
            
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Chat message(s) found."] || success)
            {
                
                if([jsonResponse objectForKey:@"chatCountArray"] != [NSNull null])
                {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *tempRelationArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"chatCountArray"]];
                    
                    for(int i=0;i<tempRelationArray.count;i++)
                    {
                        [tempArray addObject:[[tempRelationArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    }
                    
                    tempRelationArray = nil;
                    
                    
                    
                    for (int i = 0; i<[tempArray count]; i++)
                    {
                        
                        for(int j=0 ; j<relationshipArray.count;j++)
                        {
                            if([((RelationInfo*)[relationshipArray objectAtIndex:j]).relationship_ID isEqualToString:[[tempArray objectAtIndex:i] objectForKey:@"relationshipId"]])
                            {
                                [unreadMessageCountArray addObject:[[tempArray objectAtIndex:i] objectForKey:@"unreadChatCount"]];
                                
                                ((RelationInfo*)[relationshipArray objectAtIndex:j]).unreadMessagesCount = [[[tempArray objectAtIndex:i] objectForKey:@"unreadChatCount"] integerValue];
                                break;
                            }
                        }
                    }
                    
                    tempArray = nil;
                }
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"No messages found"] || !success)
            {
                
            }
            else
            {
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:errorl.description
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
            
            //post notification
            [self postRelationsUpdated];
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
    else
    {
        //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        //        alert = nil;
        //
    }
}


-(void) deleteRelation:(RelationInfo*)relationObject atIndex:(int)index
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/deleterelationship"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",relationObject.relationship_ID,@"relationship_id",nil];
    
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
        [relationshipArray removeObjectAtIndex:index];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"yes",@"deleteuser",[NSString stringWithFormat:@"%d",index],@"index",nil];
        
        [self postRelationsUpdatedWhenDeleted:dict];
        
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationship successfully accepted"] || success)
        {
            [self getRelations:YES];
            NSLog(@"relationship description : %@",jsonResponse.description);
        }
        else
        {
            
        }
    }
    
}



-(void) acceptRelation:(RelationInfo*)relationObject atIndex:(int)index
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/updatestatus"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    //NSString *RelationShip_ID = [[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"id"] objectForKey:@"$id"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",relationObject.relationship_ID,@"relationship_id",@"true",@"accepted",nil];
    
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
        [nonAcceptedRelationArray removeObjectAtIndex:index];
        //[table reloadData];
        [self postRelationsUpdated];

        
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationship successfully accepted"] || success)
        {
            [self getRelations:YES];
            NSLog(@"relationship description : %@",jsonResponse.description);
        }
        else
        {
            
        }
    }
    
}

-(void) rejectRelation:(RelationInfo*)relationObject atIndex:(int)index
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/updatestatus"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    //NSString *RelationShip_ID = [[[nonAcceptedUsersArray objectAtIndex:indexPath.row] objectForKey:@"id"] objectForKey:@"$id"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",relationObject.relationship_ID,@"relationship_id",@"false",@"accepted",nil];
    
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
        [nonAcceptedRelationArray removeObjectAtIndex:index];
        //[table reloadData];
        [self postRelationsUpdated];

        
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Relationship successfully accepted"] || success)
        {
            NSLog(@"relationship description : %@",jsonResponse.description);
        }
        else
        {
            
        }
    }

}

-(void)sendClickInRequest:(NSString*)requestNumber
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/newrequest"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",requestNumber,@"partner_phone_no",nil];
        
        NSLog(@"%@",Dictionary);
        
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
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request sent to partner"])
            {
                [self postClickInRequestSent];
            }
            else if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Request has already been made to the user"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Request has already been made to the user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"Request has already been made to the user."
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
                
                [self performSelector:@selector(tempAction) withObject:self afterDelay:0.1];
            }
        }
        else if([request responseStatusCode] == 401)
        {
            NSError *error = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&error];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"User Token is not valid"])
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Token is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:@"User Token is not valid"
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
            }
        }
        if([request responseStatusCode] == 500)
        {
            
        }
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
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark post notifications

-(void)postRelationsUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RelationsUpdated object:nil userInfo:Nil];
}

-(void)postRelationsUpdatedWhenDeleted:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RelationsUpdated object:nil userInfo:dict];
}

-(void)postClickInRequestSent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RelationRequestSent object:nil userInfo:Nil];
}


@end
