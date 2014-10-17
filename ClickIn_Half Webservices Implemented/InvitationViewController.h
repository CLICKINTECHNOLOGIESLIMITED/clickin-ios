//
//  InvitationViewController.h
//  ClickIn
//
//  Created by Dinesh Gulati on 07/11/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressBook/AddressBook.h"
#import "profile_owner.h"

@interface InvitationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
{
//    NSArray *arrContacts; // contains all the contacts from the phone addressbook
//    NSMutableArray *existingContacts; // for storing contacts registered on ClickIn
//    NSMutableArray *existingNames;
//    NSMutableArray *existingPhotos;
//    NSMutableArray *existingPhotosUrl;
//    NSMutableArray *existingFollowing;
//    NSMutableArray *nonExisitingContacts; // for storing contacts not registered on ClickIn
//    NSMutableArray *nonExisitingNames;
//    NSMutableArray *nonExisitingPhotos;
    NSMutableArray *selectedContacts; // for storing the contacts selected through checkboxes for invitation
    NSMutableArray *invitedContacts; // for storing the contacts to whom invitaion has been sent
    
    UITableView *tblView; // for rest of the contacts not on ClickIn
    
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
}
//@property(strong)NSArray *arrContacts;
@property (nonatomic, retain) NSString *isFromMenu;

@property (nonatomic, retain) NSArray *arrContacts; // contains all the contacts from the phone addressbook
@property (nonatomic, retain) NSMutableArray *existingContacts; // for storing contacts registered on ClickIn
@property (nonatomic, retain) NSMutableArray *existingNames;
@property (nonatomic, retain) NSMutableArray *existingPhotos;
@property (nonatomic, retain) NSMutableArray *existingPhotosUrl;
@property (nonatomic, retain) NSMutableArray *existingFollowing;
@property (nonatomic, retain) NSMutableArray *nonExisitingContacts; // for storing contacts not registered on ClickIn
@property (nonatomic, retain) NSMutableArray *nonExisitingNames;
@property (nonatomic, retain) NSMutableArray *nonExisitingPhotos;

@end
