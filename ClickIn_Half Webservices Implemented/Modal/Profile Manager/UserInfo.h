//
//  UserInfo.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 26/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *profilePicUrl;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *followerCount;
@property (nonatomic, retain) NSString *followingCount;
@property (nonatomic, retain) NSString *notificationCount;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSMutableArray *followerRequestedArray;
@property (nonatomic, retain) NSMutableArray *followerArray;
@property (nonatomic, retain) NSMutableArray *followingArray;

@property (nonatomic) bool isInRelation;
@property (nonatomic) bool isFollowed;
@property (nonatomic) bool isFollowingRequested;

@property (nonatomic, retain) NSString *followID;

@property (nonatomic) bool is_Owner;


-(void) followUserAction;
-(void) unfollowUserAction;
-(void) followUserAction:(int)atIndex;
-(void) unfollowUserAction:(int)atIndex;

-(void) acceptFollower:(int)atIndex;
-(void) rejectFollower:(int)atIndex;

-(void) getProfileInfo:(BOOL)isOwner;
-(void)getFollowerFollowingList:(BOOL)isOwner;
-(void)getFollowerFollowingListSynchronous:(BOOL)isOwner;

-(void) resetUserInfo;

@property(nonatomic,retain) AVAudioPlayer *inAppNotificationSound;

@end
