//
//  SearchContactsViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 24/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKTintedKeyboardViewController.h"
#import "ModelManager.h"
#import "Mixpanel.h"

@interface SearchContactsViewController : TKTintedKeyboardViewController<UIScrollViewAccessibilityDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,QBActionStatusDelegate>
{

    // models references
    ModelManager *modelmanager;
    ChatManager *chatmanager;
    //
    
    UITextField *SearchPhoneBookTextfield;
    UITableView *autocompleteTableView;
    NSMutableArray *autocompleteUrls;
    NSArray *arrContacts;
    NSArray *sortedArray;
    int indexValue;
    BOOL isNumber;
    UIScrollView *scroll;
    
    UITableView *StrTable;
    
    UITextField *SearchClickinByNameTextfield;
    UIButton *crossButton;
    UIActivityIndicatorView *activityIndicator;
    NSTimer *timerCallService;
    
    NSMutableArray *arrUsers;
}

@property (nonatomic, retain) NSString *isFromMenu;

@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property (nonatomic, retain) UITableView *autocompleteTableView;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
@end
