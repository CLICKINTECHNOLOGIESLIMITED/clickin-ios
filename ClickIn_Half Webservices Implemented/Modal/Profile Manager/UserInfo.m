  //
//  UserInfo.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 26/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "UserInfo.h"
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


@implementation UserInfo

@synthesize name,phoneNumber,profilePicUrl,age,gender,followerCount,followingCount,followerRequestedArray,followerArray,followingArray,notificationCount,is_Owner,isFollowed,isInRelation,followID,isFollowingRequested,city,country,email,inAppNotificationSound;

#pragma mark

- (id)init
{
    self = [super init];
    if (self) {
        is_Owner = true;
        followerRequestedArray = [[NSMutableArray alloc] init];
        followerArray = [[NSMutableArray alloc] init];
        followingArray = [[NSMutableArray alloc] init];
        
        inAppNotificationSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]                                                                                          pathForResource:@"Notification_InApp"                                                                                           ofType:@"mp3"]] error:nil];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
        {
            inAppNotificationSound.volume = 0;
        }
        else
        {
            inAppNotificationSound.volume = 1;
        }

        [inAppNotificationSound prepareToPlay];
        
//        [[NSNotificationCenter defaultCenter]
//         addObserver:self
//         selector:@selector(SetVolumeNotificationReceived2:)
//         name:Notification_InAppSoundsFlag
//         object:nil];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(SetVolumeNotificationReceived2:)
         name:Notification_InAppSoundsFlag
         object:nil];

        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notification_InAppSoundsFlag object:nil];
}

-(void)SetVolumeNotificationReceived2:(NSNotification *)notification
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"inAppSounds"] isEqualToString:@"no"])
    {
        inAppNotificationSound.volume = 0;
    }
    else
    {
        inAppNotificationSound.volume = 1;
    }
}


-(void) followUserAction
{
    if(!isFollowed) // is not following
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",phoneNumber,@"followee_phone_no",nil];
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request setTag:4747];
        [request startAsynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
//        if([request responseStatusCode] == 200)
//        {
//            NSError *errorl = nil;
//            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
//            
//            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
//            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following"] || success)
//            {
//                [self getProfileInfo:NO];
////                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully following" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                [alert show];
////                alert = nil;
//            }
//            else if(!success)
//            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[jsonResponse objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
//            }
//            else
//            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:errorl.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
//            }
//        }
//        else if([request responseStatusCode] == 500)
//        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Already requested to follow." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
//            
//        }
//        else
//        {
//            //        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            //        [alert show];
//            //        alert = nil;
//            
//        }
//        
//        [self getProfileInfo:NO];
    }
}

-(void) unfollowUserAction
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/unfollowuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",followID,@"follow_id", @"true", @"following", nil];
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request setTag:7474];
        [request startAsynchronous];
        NSLog(@"responseStatusCode %i",[request responseStatusCode]);
        NSLog(@"responseString %@",[request responseString]);
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        //[self getProfileInfo:NO];
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
    
}



-(void) followUserAction:(int)atIndex
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[followerArray objectAtIndex:atIndex];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSNumber numberWithBool:true] forKey:@"is_following"];
        [newDict setObject:@"false" forKey:@"following_accepted"];
        [followerArray replaceObjectAtIndex:atIndex withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
        
        
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/followuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[followerArray objectAtIndex:atIndex] objectForKey:@"phone_no"],@"followee_phone_no",nil];
        NSLog(@"%@",Dictionary);
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self postFollowersFollowingUpdated];
        
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
}

-(void) unfollowUserAction:(int)atIndex
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[followerArray objectAtIndex:atIndex];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"is_following"];
        [newDict setObject:@"false" forKey:@"following_accepted"];
        [followerArray replaceObjectAtIndex:atIndex withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/unfollowuser"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
//        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerArray objectAtIndex:atIndex] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id",[NSString stringWithFormat:@"%@",@"true"],@"following", nil];
        
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[followerArray objectAtIndex:atIndex] objectForKey:@"following_id"],@"follow_id",[NSString stringWithFormat:@"%@",@"true"],@"following", nil];

        
        
        
        NSLog(@"%@",Dictionary);
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self postFollowersFollowingUpdated];
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

}

-(void) acceptFollower:(int)atIndex
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/followupdatestatus"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerRequestedArray objectAtIndex:atIndex] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"true", @"accepted", nil];
        
        NSLog(@"%@",Dictionary);
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[followerRequestedArray objectAtIndex:atIndex];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"is_following"];
        [newDict setObject:@"false" forKey:@"following_accepted"];
        [newDict setObject:@"true" forKey:@"accepted"];
        [followerRequestedArray replaceObjectAtIndex:atIndex withObject:newDict];
        newDict = nil;
        oldDict = nil;
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [followerArray addObject:[followerRequestedArray objectAtIndex:atIndex]];
        
        for(int i=atIndex;i<followerRequestedArray.count-1;i++)
        {
            [followerRequestedArray replaceObjectAtIndex:i withObject:[followerRequestedArray objectAtIndex:i+1]];
        }
        [followerRequestedArray removeLastObject];
        
        [self postFollowersFollowingUpdated];
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

}

-(void) rejectFollower:(int)atIndex
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str = [NSString stringWithFormat:DomainNameUrl@"users/followupdatestatus"];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSError *error;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *Dictionary;
        Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[prefs stringForKey:@"phoneNumber"],@"phone_no",[prefs stringForKey:@"user_token"],@"user_token",[[[followerRequestedArray objectAtIndex:atIndex] objectForKey:@"_id"] objectForKey:@"$id"],@"follow_id", @"false", @"accepted", nil];
        
        NSLog(@"%@",Dictionary);
        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request appendPostData:jsonData];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        for(int i=atIndex;i<followerRequestedArray.count-1;i++)
        {
            [followerRequestedArray replaceObjectAtIndex:i withObject:[followerRequestedArray objectAtIndex:i+1]];
        }
        [followerRequestedArray removeLastObject];
        
        [self postFollowersFollowingUpdated];
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

}

-(void) getProfileInfo:(BOOL)isOwner
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate performSelector:@selector(CheckInternetConnection)];
    if(appDelegate.internetWorking == 0)//0: internet working
    {
        NSString *str;
        NSURL *url;
        
        self.is_Owner = isOwner;
        
        if(isOwner)
        {
            str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo"];
            url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofileinfo/profile_phone_no:%s",[phoneNumber UTF8String]];
            str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            
            url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        
        NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
        NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
        
        
        [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request addRequestHeader:@"Phone-No" value:phoneno];
        [request addRequestHeader:@"User-Token" value:user_token];
        
        //[request appendPostData:jsonData];
        [request setDidFinishSelector:@selector(requestFinished_info:)];
        [request setRequestMethod:@"GET"];
        [request setDelegate:self];
        [request setTimeOutSeconds:200];
        [request startAsynchronous];
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

}

- (void)requestFinished_info:(ASIHTTPRequest *)request
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
            // NSArray *userinfoarray=[jsonResponse objectForKey:@"user"];
            NSDictionary *userinfo=[jsonResponse objectForKey:@"user"];
            NSString *genderInfo=[userinfo objectForKey:@"gender"];
            
            name = [userinfo objectForKey:@"name"];
            
            email = [userinfo objectForKey:@"email"];
            
            if([userinfo objectForKey:@"user_pic"]!= [NSNull null])
            {
                if(is_Owner)
                    [[NSUserDefaults standardUserDefaults] setObject:[userinfo objectForKey:@"user_pic"] forKey:@"user_pic"];
                
                profilePicUrl = [userinfo objectForKey:@"user_pic"];
            }
            
            if([genderInfo isEqualToString:@"guy"])
            {
                gender=@"Male";
            }
            else if([genderInfo isEqualToString:@"girl"])
            {
                gender=@"Female";
            }
            else
            {
                gender=@"";
            }
            
            
            NSString *datetext=[userinfo objectForKey:@"dob"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"dd MMM yyyy"];
            NSDate *dobDate = [df dateFromString: datetext];
            NSTimeInterval secondsBetween = [dobDate timeIntervalSinceNow];
            
            int minutes = floor(secondsBetween/60) * -1;
            int hours=floor(minutes/60);
            int days=floor(hours/24);
            int years=floor(days/365);
            
            age=[NSString stringWithFormat:@"%d years old",years];
            
            //set age and gender
            //userinfo1.text=[NSString stringWithFormat:@"%@, %@",gender,datetext];
            
            //notification count set
            if([notificationCount integerValue]!=[[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]] integerValue] && is_Owner)
            {
                AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                if(appDelegate.isAppLaunchedFirstTime==true)
                    appDelegate.isAppLaunchedFirstTime=false;
                else if([[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]] integerValue]>0)
                {
                    [inAppNotificationSound play];
                }
                
                appDelegate = nil;
            }
            
            notificationCount=[NSString stringWithFormat:@"%@",[jsonResponse objectForKey:@"unread_notifications_count"]];
            
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.unreadNotificationsCount = [notificationCount integerValue];
            appDelegate = nil;
            
            //followers count
            followerCount=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"follower"]];
            //following count
            followingCount=[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"following"]];
            
            isFollowed = [[userinfo objectForKey:@"is_following"] boolValue];
            
            if([userinfo objectForKey:@"follow_id"] == [NSNull null] || [userinfo objectForKey:@"follow_id"] == nil)
                followID = @"";
            else
                followID = [NSString stringWithFormat:@"%@",[userinfo objectForKey:@"follow_id"]];
            
            if([userinfo objectForKey:@"is_following_requested"] == [NSNull null] || [userinfo objectForKey:@"is_following_requested"] == nil)
                isFollowingRequested = false;
            else
                isFollowingRequested = [[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"is_following_requested"]] boolValue];
            
            
            city = [userinfo objectForKey:@"city"];
            country = [userinfo objectForKey:@"country"];
            
            //post notification
            [self postProfileInfoUpdated];
            
            
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
    }
    else
    {
        
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


-(void)getFollowerFollowingList:(BOOL)isOwner
{
    is_Owner = isOwner;
    NSString *str ;
    if(isOwner)
        str= [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow"];
    else
    {
        str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow/profile_phone_no:%s",[phoneNumber UTF8String]];
        str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //  [request appendPostData:jsonData];
    request.tag = 12;
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];

}

-(void)getFollowerFollowingListSynchronous:(BOOL)isOwner
{
    is_Owner = isOwner;
    NSString *str ;
    if(isOwner)
        str= [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow"];
    else
    {
        str = [NSString stringWithFormat:DomainNameUrl@"users/fetchprofilefollow/profile_phone_no:%s",[phoneNumber UTF8String]];
        str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //  [request appendPostData:jsonData];
    request.tag = 12;
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startSynchronous];
    
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    if(request.tag == 12)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if(success)
            {
                [followerRequestedArray removeAllObjects];
                [followerArray removeAllObjects];
                [followingArray removeAllObjects];
                
                // get followers
                NSMutableArray *tempFollowerArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"follower"]];
                
                for(int i=0;i<tempFollowerArray.count;i++)
                {
                    if([[tempFollowerArray objectAtIndex:i] objectForKey:@"accepted"]==[NSNull null] || [[tempFollowerArray objectAtIndex:i] objectForKey:@"accepted"]==nil)
                    {
                        //if(is_Owner)
                            [followerRequestedArray addObject:[tempFollowerArray objectAtIndex:i]];
                    }
                    else if([[[tempFollowerArray objectAtIndex:i] objectForKey:@"accepted"] boolValue] == true)
                        [followerArray addObject:[[tempFollowerArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                }
                
                
                tempFollowerArray = nil;
                
                
                //get followings
                NSMutableArray *tempfollowingArray = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"following"]];
                
                for(int i=0;i<tempfollowingArray.count;i++)
                {
                    //[followingArray addObject:[[tempfollowingArray objectAtIndex:i] dictionaryByReplacingNullsWithStrings]];
                    [followingArray addObject:[tempfollowingArray objectAtIndex:i]];
                }
                
                tempfollowingArray = nil;
                
                [self postFollowersFollowingUpdated];
                
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
    else if(request.tag == 4747)
    {
        if([request responseStatusCode] == 200)
        {
            NSError *errorl = nil;
            NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
            
            BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
            if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Successfully following"] || success)
            {
                //[self getProfileInfo:NO];
            }
            else if(!success)
            {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[jsonResponse objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                alert = nil;
                
                MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                                description:[jsonResponse objectForKey:@"message"]
                                                                              okButtonTitle:@"OK"];
                alertView.delegate = nil;
                [alertView show];
                alertView = nil;
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
        }
        else if([request responseStatusCode] == 500)
        {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Already requested to follow." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//            alert = nil;
            
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
        
        [self getProfileInfo:NO];
    }
    
    else if(request.tag == 7474)
    {
        [self getProfileInfo:NO];
    }
    
}

#pragma mark post notifications
-(void)postProfileInfoUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ProfileInfoUpdated object:nil userInfo:Nil];
}

-(void)postFollowersFollowingUpdated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_FollowersFollowingUpdated object:nil userInfo:Nil];
}

//reset user info
-(void) resetUserInfo
{
    name = @"";
    phoneNumber = @"";
    profilePicUrl = @"";
    age = @"";
    gender = @"";
    email = @"";
    followerCount = @"";
    followingCount = @"";
    notificationCount = @"";
    city = @"";
    country = @"";
    [followerRequestedArray removeAllObjects];
    [followerArray removeAllObjects];
    [followingArray removeAllObjects];
}

@end
