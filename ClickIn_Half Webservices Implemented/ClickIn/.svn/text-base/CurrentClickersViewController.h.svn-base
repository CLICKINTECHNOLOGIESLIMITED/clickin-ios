//
//  CurrentClickersViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 24/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook/AddressBook.h"
#import "profile_owner.h"


@interface CurrentClickersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MODropAlertViewDelegate>
{
    NSArray *arrContacts; // contains all the contacts from the phone addressbook
    NSMutableArray *existingContacts; // for storing contacts registered on ClickIn
    NSMutableArray *existingNames;
    NSMutableArray *existingPhotos;
    NSMutableArray *existingPhotosUrl;
    NSMutableArray *existingFollowing;
    NSMutableArray *nonExisitingContacts; // for storing contacts not registered on ClickIn
    NSMutableArray *nonExisitingNames;
    NSMutableArray *nonExisitingPhotos;
    NSMutableArray *selectedContacts; // for storing the contacts selected through checkboxes for invitation
    NSMutableArray *invitedContacts; // for storing the contacts to whom invitaion has been sent
    
    NSMutableArray *FBusersOnCLickin;
    
    UITableView *tblView; // for rest of the contacts not on ClickIn
    UITableView *tblViewFBUsers; // for rest of the FBcontacts on ClickIn
    
    LabeledActivityIndicatorView *activity;
    
    UIImageView *backgroundView;
    
    UIButton *backBtn;
    UIButton *inviteBtn;
    UIButton *skipBtn;
    
    UIButton *phonebookBtn;
    UIButton *facebookBtn;
    UIButton *twitterBtn;
    UIButton *googleplusBtn;
    
    UIButton *scrollToTopBtn;
    int intValue; // For check which button clicked Fb or Primary Contacts
    
    BOOL is_FbUsersOnClickin;
}
@property(strong)NSArray *arrContacts;
@property (nonatomic, retain) NSString *isFromMenu;
@end
