//
//  EventManager.h
//  Eventuosity
//
//  Created by Leo Macbook on 13/02/14.
//  Copyright (c) 2014 Eventuosity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Newsfeed.h"
@interface NewsfeedManager : NSObject
{
    
}

-(NSArray*)getFeeds:(BOOL)shouldRefresh isFetchingEarlier:(BOOL)fetchEarlier;

@property(strong,nonatomic)NSMutableArray *array_model_feeds;

@property(nonatomic) bool isFetchingEarlier; // to fetch earlier notifications
@property(nonatomic) bool isHistoryAvailable ; // to check whether earlier notifications available or not


@end
