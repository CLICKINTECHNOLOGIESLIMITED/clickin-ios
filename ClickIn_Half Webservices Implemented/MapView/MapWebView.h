//
//  MapWebView.h
//  ClickIn
//
//  Created by Dinesh Gulati on 05/02/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Mixpanel.h"

@interface MapWebView : UIViewController<UIWebViewDelegate,CLLocationManagerDelegate>
{
     LabeledActivityIndicatorView *activity;
}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *location_coordinates;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end
