//
//  RelationInfo.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 28/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface RelationInfo : NSObject
{
    
}
@property (nonatomic, retain) NSString *relationship_ID;
@property (nonatomic, retain) NSString *partnerName;
@property (nonatomic, retain) NSString *partnerPhoneNumber;
@property (nonatomic, retain) NSString *partnerQB_ID;
@property (nonatomic, retain) NSString *partnerPicUrl;
@property (nonatomic, retain) NSString *partnerClicks;
@property (nonatomic, retain) NSString *ownerClicks;

@property (nonatomic) int unreadMessagesCount;


@property (nonatomic) bool isRelationPublic;
@property (nonatomic) bool isAccepted;
@property (nonatomic) bool isPending;
@property (nonatomic) bool isRequestInitiator;

@property(strong,nonatomic) UserInfo *userDetails;

-(void) setRelationVisibility:(BOOL)isPublic;

-(void) resetUnreadMessageCount:(NSString*)chatID;

@end
