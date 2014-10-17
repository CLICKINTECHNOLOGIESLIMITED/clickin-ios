//
//  ModalManager.m
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager
@synthesize profileManager, newsfeedManager,chatManager;
static ModelManager *modelManager = nil;

+ (ModelManager *)modelManager {
    if (nil != modelManager) {
        return modelManager;
    }
    
    static dispatch_once_t pred; // Lock
    dispatch_once(&pred, ^{ // This code is called at most once per app
        modelManager = [[ModelManager alloc] init];
    });
    
    return modelManager;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        profileManager = [[ProfileManager alloc] init];
        newsfeedManager = [[NewsfeedManager alloc] init];
        chatManager = [[ChatManager alloc] init];
    }
    
    return self;
}

#pragma mark ProfileManager Methods
-(ProfileManager*)getProfileManager
{
    return self.profileManager;
}

#pragma mark NewsfeedManager Methods
-(NewsfeedManager*)getNewsfeedManager
{
    return self.newsfeedManager;
}

#pragma mark ChatManager Methods
-(ChatManager*)getChatManager
{
    return self.chatManager;
}

@end
