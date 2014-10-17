//
//  Event.h
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Newsfeed : NSObject
{
    
}


@property (nonatomic, retain) NSString *newsfeedID;
@property (nonatomic, retain) QBChatMessage *message;
@property (nonatomic, retain) NSString *senderID;
@property (nonatomic, retain) NSString *senderName;
@property (nonatomic, retain) NSString *senderPhoneNo;
@property (nonatomic, retain) NSString *senderImageUrl;
@property (nonatomic, retain) NSString *receiverID;
@property (nonatomic, retain) NSString *receiverName;
@property (nonatomic, retain) NSString *receiverPhoneNo;
@property (nonatomic, retain) NSString *receiverImageUrl;
@property (nonatomic, retain) NSString *receiverTime;
@property (nonatomic, retain) NSString *senderTime;
@property (nonatomic, retain) NSString *commentCount;
@property (nonatomic, retain) NSString *starCount;
@property (nonatomic, retain) NSString *userStarred;
@property (nonatomic, retain) NSString *userCommented;

@property (nonatomic) BOOL  showReportBtns;

//@property (nonatomic, retain) NSMutableArray *followingIDS;
@property (nonatomic,retain) NSString *isSenderFollower;
@property (nonatomic,retain) NSString *isReceiverFollower;

@property (nonatomic,retain) NSMutableArray *commentsArrayNewsfeedPage;
@property (nonatomic,retain) NSMutableArray *starredArrayNewsfeedPage;

@property (nonatomic,retain) NSMutableArray *commentsArray; // contains the required info for the comments for particular feed
@property (nonatomic,retain) NSMutableArray *starredArray; // contains the required info for the users who starred the particular newsfeed

-(NSMutableArray*)getNewsfeedComments:(BOOL)shouldRefresh;
-(void)addComment:(NSString*)comment;

-(NSMutableArray*)getStarredUsers:(BOOL)shouldRefresh;
-(void)addStarredUser;
-(void)removeStarredUser;

-(void)getNewsfeedByID:(BOOL)isSynchronous;

-(void)deleteNewsfeed;

-(void)reportNewsfeedInappropriate;

@end
