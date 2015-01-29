//
//  ViewController.h
//  ClickIn
//
//  Created by Kabir Chandhoke on 14/10/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelManager.h"
#import "Mixpanel.h"

@interface ViewController : UIViewController<QBActionStatusDelegate,UIScrollViewDelegate,MODropAlertViewDelegate>
{
    // models references
    ModelManager *modelmanager;
    ChatManager *chatmanager;
    //
    
    UIButton *btn_SignIn;
    UIButton *btn_SignUp;
    
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSMutableArray *viewControllers;
    UIImageView *imgView;
    
    NSArray *contentList;
    
    NSTimer *scrollTimer;
}
@end
