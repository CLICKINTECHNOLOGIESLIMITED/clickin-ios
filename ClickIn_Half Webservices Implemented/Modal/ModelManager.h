//
//  ModalManager.h
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileManager.h"
#import "NewsfeedManager.h"
#import "ChatManager.h"
#import "LabeledActivityIndicatorView.h"

@interface ModelManager : NSObject
{
    
}
@property(strong,nonatomic)ProfileManager *profileManager;
@property(strong,nonatomic)NewsfeedManager *newsfeedManager;
@property(strong,nonatomic)ChatManager *chatManager;


+ (ModelManager *)modelManager;
-(ProfileManager*)getProfileManager;
-(NewsfeedManager*)getNewsfeedManager;
-(ChatManager*)getChatManager;
@end
