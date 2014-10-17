//
//  ChatManager.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 03/05/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol leftchatReceiveProtocol <NSObject>

@optional
- (void)LeftchatDidReceiveMessageNotification:(NSDictionary *)DictMessage;

@end


@protocol CenterchatReceiveProtocol <NSObject>

@optional
- (void)CenterchatDidReceiveMessageNotification:(NSDictionary *)DictMessage;

@end


@protocol CenterCustomObjectProtocol <NSObject>

@optional
- (void)completedWithResultNotification:(Result *)result;

@end



@interface ChatManager : NSObject<QBChatDelegate,QBActionStatusDelegate>

- (void)loginWithUser:(QBUUser *)user;

- (void)sendMessage:(QBChatMessage *)message dict:(NSDictionary *)data;

-(void)getChatHistory:(NSString *)relationShipId lastChatID:(NSString*)lastchatID;

@property (copy) QBUUser *currentUser;
@property (retain) NSTimer *presenceTimer;

@property(nonatomic,retain) AVAudioPlayer *inComingMsgSound;
@property(nonatomic,retain) AVAudioPlayer *inComingClicksSound;
@property(nonatomic,retain) AVAudioPlayer *cardAcceptedSound;
@property(nonatomic,retain) AVAudioPlayer *cardRejectedSound;

@property (nonatomic, retain) NSMutableArray *messages;
@property (nonatomic, retain) NSMutableArray *TempArrayChatHistory;
@property (nonatomic, retain) NSMutableArray *TempImageDataHistory;
@property (nonatomic, retain) NSMutableArray *TempCardStatusHistory;
@property(unsafe_unretained) NSObject<leftchatReceiveProtocol> *LeftMessageReceiveDelegate;
@property(unsafe_unretained) NSObject<CenterchatReceiveProtocol> *CenterMessageReceiveDelegate;

@property(unsafe_unretained) NSObject<CenterCustomObjectProtocol> *CenterCustomObjDelegate;

@end
