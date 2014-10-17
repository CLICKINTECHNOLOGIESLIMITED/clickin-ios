//
//  ProfileManager.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 26/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "RelationInfo.h"

@interface ProfileManager : NSObject
{
    
}

@property(strong,nonatomic) NSMutableArray *relationshipArray;
@property(strong,nonatomic) NSMutableArray *nonAcceptedRelationArray;
@property(strong,nonatomic) NSMutableArray *othersRelationshipArray;

@property(strong,nonatomic) NSMutableArray *unreadMessageCountArray;

@property(strong,nonatomic) UserInfo *ownerDetails;

-(NSArray*)getRelations:(BOOL)shouldRefresh;
-(void) acceptRelation:(RelationInfo*)relationObject atIndex:(int)index;
-(void) rejectRelation:(RelationInfo*)relationObject atIndex:(int)index;
-(void) deleteRelation:(RelationInfo*)relationObject atIndex:(int)index;
-(void)sendClickInRequest:(NSString*)requestNumber;

-(void)getUnreadMessageCount;

-(NSArray*)getOtherUserRelations:(BOOL)shouldRefresh otherUserNo:(NSString*)otherUserPhoneNo;

@end
