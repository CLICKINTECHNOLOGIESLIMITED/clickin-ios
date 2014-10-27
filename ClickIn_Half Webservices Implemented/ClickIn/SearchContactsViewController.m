//
//  SearchContactsViewController.m
//  ClickIn
//
//  Created by Dinesh Gulati on 24/03/14.
//  Copyright (c) 2014 Kabir Chandhoke. All rights reserved.
//

#import "SearchContactsViewController.h"
#import <AddressBook/AddressBook.h>
#import "UIImageView+WebCache.h"
#import "SendInvite.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "CurrentClickersViewController.h"

@interface SearchContactsViewController ()

@end

@implementation SearchContactsViewController

@synthesize autocompleteTableView;
@synthesize autocompleteUrls;
@synthesize isFromMenu;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //1s.png
    //2s.png
    
    // Models
    modelmanager=[ModelManager modelManager];
    chatmanager=modelmanager.chatManager;
    
    if(![isFromMenu isEqualToString:@"true"])
        [QBUsers logInWithUserLogin:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"] password:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] delegate:self];
    
    
    float ScreenHeight;
    if (IS_IPHONE_5)
        ScreenHeight=568;
    else
        ScreenHeight=480;
    
    //----Scroll View Implementation
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight)];
    
    NSLog(@"view size.....%f",self.view.frame.size.height);
    scroll.contentSize = CGSizeMake(320, 460);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.scrollsToTop = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    if([isFromMenu isEqualToString:@"true"])
    {
        UIButton *BackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        BackBtn.backgroundColor = [UIColor clearColor];
        [BackBtn setBackgroundImage:[UIImage imageNamed:@"Back_blue.png"] forState:UIControlStateNormal];
        [BackBtn addTarget:self
                      action:@selector(BackBtnAction)
            forControlEvents:UIControlEventTouchUpInside];
        if (IS_IPHONE_5)
            BackBtn.frame = CGRectMake(160 - 271/2.0, 568-56, 271, 56.0);
        else
            BackBtn.frame = CGRectMake(160 - 271/2.0, 480-56, 271, 56.0);
        [self.view addSubview:BackBtn];
    }
    
    //---UIimage View
    UIImageView *compScreen=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight)];
    
    if([isFromMenu isEqualToString:@"true"])
        compScreen.image=[UIImage imageNamed:@"2s_menu.png"];
    else
        compScreen.image=[UIImage imageNamed:@"2s.png"];
    
    if (!IS_IPHONE_5)
    {
        if([isFromMenu isEqualToString:@"true"])
            compScreen.image=[UIImage imageNamed:@"1s_menu.png"];
        else
            compScreen.image=[UIImage imageNamed:@"1s.png"];
    }
    
    [scroll addSubview:compScreen];
    
    //---Text Field SEARCH PHONEBOOK AND CLICKIN NAME----
    SearchPhoneBookTextfield =[[UITextField alloc]initWithFrame:CGRectMake(36+5,135+18,203-5,30)];
    if([isFromMenu isEqualToString:@"true"])
        SearchPhoneBookTextfield.frame = CGRectMake(36+5,135+17,203-5,30);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
            if([isFromMenu isEqualToString:@"true"])
            {
                SearchPhoneBookTextfield.frame = CGRectMake(36+5,151, 203-5, 35);
            }
            else
            {
                SearchPhoneBookTextfield.frame=CGRectMake(36+5,167-5-4, 203-5, 35) ;
            }
        }
    }
    else
    {
        if (IS_IPHONE_5)
            SearchPhoneBookTextfield.frame=CGRectMake(36+5,150, 203-5, 35) ;
        
        else
            SearchPhoneBookTextfield.frame=CGRectMake(36+5,167-7-10, 203-5, 35) ;
    }
    SearchPhoneBookTextfield.placeholder=@"SEARCH PHONEBOOK";
    SearchPhoneBookTextfield.backgroundColor = [UIColor clearColor];
//    SearchPhoneBookTextfield.alpha=0.5;
    SearchPhoneBookTextfield.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    SearchPhoneBookTextfield.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    [SearchPhoneBookTextfield setDelegate:self];
    SearchPhoneBookTextfield.secureTextEntry = NO;
    SearchPhoneBookTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    SearchPhoneBookTextfield.autocorrectionType=UITextAutocorrectionTypeNo;
    SearchPhoneBookTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    [SearchPhoneBookTextfield setKeyboardAppearance:UIKeyboardAppearanceDark];
    SearchPhoneBookTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//  SearchPhoneBookTextfield.userInteractionEnabled = NO;
    [scroll addSubview:SearchPhoneBookTextfield];
    [SearchPhoneBookTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    SearchClickinByNameTextfield =[[UITextField alloc]initWithFrame:CGRectMake(41,219,247-5,30)];
    if([isFromMenu isEqualToString:@"true"])
        SearchClickinByNameTextfield.frame = CGRectMake(41,224,247-5,30);
    if (IS_IOS_7)
    {
        if (IS_IPHONE_5)
        {
             if([isFromMenu isEqualToString:@"true"])
             {
                 SearchClickinByNameTextfield.frame=CGRectMake(41,217, 247-5, 35) ;
             }
            else
            {
                SearchClickinByNameTextfield.frame=CGRectMake(41,240-12-3, 247-5, 35) ;
            }
        }
    }
    else
    {
        if (IS_IPHONE_5)
            SearchClickinByNameTextfield.frame=CGRectMake(41,240-12, 247-5, 35) ;
        
        else
            SearchClickinByNameTextfield.frame=CGRectMake(41,240-12, 247-5, 35) ;
    }
    SearchClickinByNameTextfield.placeholder=@"SEARCH CLICKIN BY NAME";
    SearchClickinByNameTextfield.backgroundColor = [UIColor clearColor];
    SearchClickinByNameTextfield.textColor=[UIColor colorWithRed:(61.0/255.0) green:(71.0/255.0) blue:(101.0/255.0) alpha:1.0];
    SearchClickinByNameTextfield.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16];
    [SearchClickinByNameTextfield setDelegate:self];
    SearchClickinByNameTextfield.secureTextEntry = NO;
    SearchClickinByNameTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    SearchClickinByNameTextfield.autocorrectionType=UITextAutocorrectionTypeNo;
    SearchClickinByNameTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    [SearchClickinByNameTextfield setKeyboardAppearance:UIKeyboardAppearanceDark];
    SearchClickinByNameTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
 //   [scroll addSubview:SearchClickinByNameTextfield];
    
    
    UIButton *InviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  InviteBtn.backgroundColor = [UIColor redColor];
    [InviteBtn addTarget:self
               action:@selector(InviteBtnAction:)
     forControlEvents:UIControlEventTouchUpInside];
    if (IS_IPHONE_5)
    InviteBtn.frame = CGRectMake(250.0, 165.0, 50.0, 50.0);
    else
    InviteBtn.frame = CGRectMake(250.0, 165-30, 50.0, 50.0);
    [scroll addSubview:InviteBtn];
    
    
    UIButton *AddSomeOneLaterButtonPink = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddSomeOneLaterButtonPink setImage:[UIImage imageNamed:@"pinkbtn.png"] forState:UIControlStateNormal];
    
    [AddSomeOneLaterButtonPink addTarget:self
                  action:@selector(AddSomeOneLaterButtonAction:)
        forControlEvents:UIControlEventTouchUpInside];
    if (IS_IPHONE_5)
        AddSomeOneLaterButtonPink.frame = CGRectMake(22.0, 290.0, 282.5-6, 82);
    else
        AddSomeOneLaterButtonPink.frame = CGRectMake(22.0, 269, 282.5-6, 82);
    [scroll addSubview:AddSomeOneLaterButtonPink];
    
     if([isFromMenu isEqualToString:@"true"])
     {
         AddSomeOneLaterButtonPink.hidden = YES;
     }
    
    
    UIButton *AddSomeOneLaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [AddSomeOneLaterButton setImage:[UIImage imageNamed:@"bluebtn.png"] forState:UIControlStateNormal];
    
    [AddSomeOneLaterButton addTarget:self
                              action:@selector(AddSomeOneLaterButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    if (IS_IPHONE_5)
        AddSomeOneLaterButton.frame = CGRectMake(22.0, 290.0+82+20, 282.5-6, 82);
    else
        AddSomeOneLaterButton.frame = CGRectMake(22.0, 269+82+10, 282.5-6, 82);
    [scroll addSubview:AddSomeOneLaterButton];
    
    if([isFromMenu isEqualToString:@"true"])
    {
        AddSomeOneLaterButton.hidden = YES;
    }

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [scroll addGestureRecognizer:tap];

    
    arrContacts = [[NSArray alloc] initWithArray:[self collectAddressBookContacts]];
    
    autocompleteUrls = [[NSMutableArray alloc] init];
    
    if (IS_IPHONE_5)
        autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(37, 167+35+10, 249, 120+40) style:UITableViewStylePlain];
    else
        autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(37, 167+5+25, 249, 90+40) style:UITableViewStylePlain];
    
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
//  [scroll bringSubviewToFront:autocompleteTableView];
    
     [self.view bringSubviewToFront:self.tintView];
    
    
    StrTable=[[UITableView alloc] initWithFrame:CGRectMake(37, 167+5+25+70, 249, 90+40) style:UITableViewStylePlain];
    if(IS_IPHONE_5)
        StrTable.frame=CGRectMake(37, 170+90, 249, 120+40);
    StrTable.backgroundColor = [UIColor clearColor];
    StrTable.delegate=self;
    StrTable.dataSource=self;
    StrTable.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  [self.view addSubview:StrTable];
	
	StrTable.hidden =  YES;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (IS_IPHONE_5)
        activityIndicator.frame = CGRectMake(257, 240-17,20,20);
    else
        activityIndicator.frame = CGRectMake(257, 240-12,20,20);
    activityIndicator.autoresizingMask = UIViewAutoresizingNone;
    activityIndicator.hidesWhenStopped = YES;
 //   [self.view addSubview:activityIndicator];
    
    crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossButton addTarget:self
                    action:@selector(crossButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [crossButton setImage:[UIImage imageNamed:@"searchCross.png"] forState:UIControlStateNormal];
    crossButton.backgroundColor = [UIColor clearColor];

    if (IS_IPHONE_5)
         crossButton.frame = CGRectMake(250, 240-23,35,35);
    else
            crossButton.frame = CGRectMake(250, 240-17,35,35);
    
 //   [self.view addSubview:crossButton];
    crossButton.hidden = YES;
}

-(void)crossButtonAction:(id)sender
{
    SearchClickinByNameTextfield.text = @"";
    crossButton.hidden = YES;
    StrTable.hidden = YES;
}


-(void)BackBtnAction
{
//    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
//        
//    }];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    autocompleteTableView.hidden = YES;
    [scroll setContentOffset:CGPointMake(0,0) animated:YES];
    if (IS_IPHONE_5)
    {
        autocompleteTableView.frame= CGRectMake(36, 167+35+10, 247, 120+40);
        StrTable.frame=CGRectMake(37, 170+90, 249, 120+40);
    }
    else
    {
        autocompleteTableView.frame =CGRectMake(36, 167+5+10, 247, 90+40);
        StrTable.frame=CGRectMake(37,204+60, 249, 120+40);
    }
    [SearchPhoneBookTextfield resignFirstResponder];
    [SearchClickinByNameTextfield resignFirstResponder];
}


- (NSArray *)collectAddressBookContacts {
    
    @try {
        
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    __block BOOL accessGranted = NO;
    
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    NSArray *arrayOfAllPeople;
    NSMutableArray *mutableData = [NSMutableArray new];
    
    if (accessGranted) {
        
        arrayOfAllPeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        // Do whatever you need with thePeople...
        NSUInteger peopleCounter = 0;
        for (peopleCounter = 0;peopleCounter < [arrayOfAllPeople count]; peopleCounter++){
            ABRecordRef thisPerson = (__bridge ABRecordRef) [arrayOfAllPeople objectAtIndex:peopleCounter];
            NSString *name = (__bridge_transfer NSString *) ABRecordCopyCompositeName(thisPerson);
            NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(thisPerson);
            if(imgData==nil)
                imgData=  UIImagePNGRepresentation([UIImage imageNamed:@"contact_icon.png"]);
            
            
            ABMultiValueRef PhoneNumber = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
            
            NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
            NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
            
            
            for (NSUInteger PNoCounter = 0; PNoCounter < ABMultiValueGetCount(PhoneNumber); PNoCounter++)
            {
                NSString *number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(PhoneNumber, PNoCounter);
                
                /*number = [number stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                 number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                 number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                 number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                 number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];*/
                
                number = [[number componentsSeparatedByCharactersInSet:
                           [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"]
                            invertedSet]]
                          componentsJoinedByString:@""];
                
                if([name length] != 0 && [number length] != 0)
                {
                    // NSLog(@"Number......%@",number);
                    
//                    if(number.length==10)
//                    {
//                        if ([countryCode.lowercaseString isEqualToString:@"in"])
//                        {
//                            number = [NSString stringWithFormat:@"+91%@",number];
//                        }
//                        
//                        else if ([countryCode.lowercaseString isEqualToString:@"us"])
//                        {
//                            number = [NSString stringWithFormat:@"+1%@",number];
//                        }
//                    }
//                    else
//                    {
//                        if(number.length==11)
//                        {
//                            if([[number substringToIndex:1] integerValue]==0)
//                            {
//                                number = [number substringFromIndex: [number length] - 10];
//                                if ([countryCode.lowercaseString isEqualToString:@"in"])
//                                {
//                                    number = [NSString stringWithFormat:@"+91%@",number];
//                                }
//                                
//                                else if ([countryCode.lowercaseString isEqualToString:@"us"])
//                                {
//                                    number = [NSString stringWithFormat:@"+1%@",number];
//                                }
//                            }
//                        }
//                        else if([[number substringToIndex:1] isEqualToString:@"+"])
//                        {
//                            //number already contains country code
//                        }
//                        else if(number.length<14)
//                        {
//                            number = [number substringFromIndex: [number length] - 10];
//                            if ([countryCode.lowercaseString isEqualToString:@"in"])
//                            {
//                                number = [NSString stringWithFormat:@"+91%@",number];
//                            }
//                            
//                            else if ([countryCode.lowercaseString isEqualToString:@"us"])
//                            {
//                                number = [NSString stringWithFormat:@"+1%@",number];
//                            }
//                        }
//                    }
                    
                    NSMutableDictionary *personDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"Name",number,@"phoneNumber",imgData,@"photo", nil];
                 //   NSMutableDictionary *personDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:name,@"Name",number,@"phoneNumber", nil];
                    [mutableData addObject:personDict];
                }
            }
            currentLocale=nil;
            countryCode=nil;
        }
    }
    if(addressBook)
    CFRelease(addressBook);
    return [NSArray arrayWithArray:mutableData];
   
    }
    @catch (NSException *exception)
    {
            return [NSMutableArray array];
    }
    @finally {
        
    }
}


-(void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteUrls removeAllObjects];
    substring = [substring stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([substring length] != 0)
    {
        for(NSMutableDictionary *tempDict in arrContacts)
        {
            NSRange substringRange = [[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"name"]] rangeOfString:substring];
            if (substringRange.location != NSNotFound)
            {
                [autocompleteUrls addObject:[NSString stringWithFormat:@"%@",[tempDict objectForKey:@"name"]]];
            }
        }
    }
    
    
    [autocompleteTableView reloadData];
}

-(MFSideMenuContainerViewController *)menuContainerViewController {
    if([isFromMenu isEqualToString:@"true"])
    {
        return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
    }
    else
    {
        return (MFSideMenuContainerViewController *)self.navigationController;
    }
}

-(void)InviteBtnAction:(id)sender
{
    if([isFromMenu isEqualToString:@"true"])
    {
        SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
        sendinvite.isFromMenu = @"true";
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        [navigationController pushViewController:sendinvite animated:YES];
        sendinvite = nil;
    }
    else
    {
     
        SendInvite *first = [story instantiateViewControllerWithIdentifier:@"SendInvite"];
        [self.navigationController pushViewController:first animated:YES];
    }
}

-(void)AddSomeOneLaterButtonAction:(id)sender
{
    if([isFromMenu isEqualToString:@"true"])
    {
        /*CurrentClickersViewController *currentClickers = [[CurrentClickersViewController alloc] initWithNibName:Nil bundle:nil];
        currentClickers.isFromMenu = @"true";
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        [navigationController pushViewController:currentClickers animated:YES];
        currentClickers = nil;*/
    }
    else
    {
        UIViewController *first = [story instantiateViewControllerWithIdentifier:@"CurrentClickersViewController"];
       [self.navigationController pushViewController:first animated:YES];
    }
}

#pragma mark -
#pragma mark QBChatDelegate

- (void)completedWithResult:(Result *)result
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(result.success && [result isKindOfClass:QBUUserLogInResult.class])
    {
        QBUUserLogInResult *userResult = (QBUUserLogInResult *)result;
        NSLog(@"Logged In user=%d", (int)(unsigned long)userResult.user.ID);
        [prefs setInteger:(int)(unsigned long)userResult.user.ID forKey:@"SenderId"];
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = userResult.user.ID; // your current user's ID
        currentUser.password = [prefs stringForKey:@"QBPassword"]; // your current user's password
        //[QBChat instance].delegate = self;
        //[[QBChat instance] loginWithUser:currentUser];
        
        [chatmanager loginWithUser:currentUser];
        
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
//                                                        message:[result.errors description]
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles: nil];
//        [alert show];
        
        [QBUsers logInWithUserLogin:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBUserName"] password:[[NSUserDefaults standardUserDefaults] stringForKey:@"QBPassword"] delegate:self];
    }
}


#pragma mark UITextFieldDelegate methods

-(void)textFieldDidChange:(UITextField *)txtFld {
    NSString * match = txtFld.text;
    if([match isEqualToString:@""])
    {
        autocompleteTableView.hidden = TRUE;
    }
    else
    {
        char CheckStr = [match characterAtIndex:0];
        if (CheckStr >= '0' && CheckStr <= '9')
        {
            isNumber = TRUE;
            NSMutableArray *listFiles = [[NSMutableArray alloc]  init];
            NSPredicate *predicate =[NSPredicate predicateWithFormat:
                                     @"phoneNumber CONTAINS[cd] %@", match];
            //or use Name like %@  //”Name” is the Key we are searching
            listFiles = [NSMutableArray arrayWithArray:[arrContacts
                                                        filteredArrayUsingPredicate:predicate]];
            // Now if you want to sort search results Array
            //Sorting NSArray having NSDictionary as objects
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"phoneNumber"  ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [NSArray arrayWithArray:[listFiles sortedArrayUsingDescriptors:sortDescriptors]];
            
            //Use sortedArray as your Table’s data source
            autocompleteTableView.hidden = FALSE;
            [autocompleteTableView reloadData];
        }
        else
        {
           isNumber = FALSE;
            NSMutableArray *listFiles = [[NSMutableArray alloc]  init];
            NSPredicate *predicate =[NSPredicate predicateWithFormat:
                                     @"Name CONTAINS[cd] %@", match];
            //or use Name like %@  //”Name” is the Key we are searching
            listFiles = [NSMutableArray arrayWithArray:[arrContacts
                                                 filteredArrayUsingPredicate:predicate]];
            // Now if you want to sort search results Array
            //Sorting NSArray having NSDictionary as objects
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:@"Name"  ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            sortedArray = [NSArray arrayWithArray:[listFiles sortedArrayUsingDescriptors:sortDescriptors]];
            
            //Use sortedArray as your Table’s data source
             autocompleteTableView.hidden = FALSE;
             [autocompleteTableView reloadData];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   /* if(textField == SearchClickinByNameTextfield)
    {
        autocompleteTableView.hidden = YES;
        SearchPhoneBookTextfield.text = @"";
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        if (IS_IPHONE_5)
        {
            //[scroll setContentOffset:CGPointMake(0,80) animated:YES];
            StrTable.frame = CGRectMake(35, 170+90, 250, 120+30);
        }
        else
        {
            StrTable.frame =CGRectMake(35, 204+60, 250, 90+40);
            //[scroll setContentOffset:CGPointMake(0,110) animated:YES];
        }
    }
    else 
    */
    {
        StrTable.hidden = YES;
        SearchClickinByNameTextfield.text = @"";
        crossButton.hidden = YES;
        
        if (IS_IPHONE_5)
        {
            [scroll setContentOffset:CGPointMake(0,30) animated:YES];
            autocompleteTableView.frame = CGRectMake(35, 170, 250, 120+30);
        }
        else
        {
            autocompleteTableView.frame =CGRectMake(35, 134, 250, 90+40);
            [scroll setContentOffset:CGPointMake(0,60) animated:YES];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 /*   if(textField ==  SearchClickinByNameTextfield)
    {
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        if (IS_IPHONE_5)
            StrTable.frame= CGRectMake(36, 170+90, 247, 120+40);
        else
            StrTable.frame =CGRectMake(36, 204+60, 247, 90+40);
        [SearchClickinByNameTextfield resignFirstResponder];
        
        [textField resignFirstResponder];
        StrTable.hidden = YES;
        return NO;
    }
    else
  */
    {
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        if (IS_IPHONE_5)
            autocompleteTableView.frame= CGRectMake(36, 167+35+10, 247, 120+40);
        else
            autocompleteTableView.frame =CGRectMake(36, 167+5+10, 247, 90+40);
        [SearchPhoneBookTextfield resignFirstResponder];

        [textField resignFirstResponder];
        autocompleteTableView.hidden = YES;
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   /* if(textField == SearchClickinByNameTextfield)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if(newLength != 0)
        {
            crossButton.hidden = NO;
        }
        
        
        if(newLength == 0)
        {
            StrTable.hidden = YES;
        }
        if(newLength < 3)
        {
            [timerCallService invalidate];
            timerCallService=nil;
        }
        else
        {
            if (timerCallService != nil)
            {
                
                for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
                {
                    [req cancel];
                    [req setDelegate:nil];
                }
                
                [timerCallService invalidate];
                timerCallService=nil;
            }
            
            timerCallService = [NSTimer scheduledTimerWithTimeInterval: 0.6 target:self selector: @selector(searchOnServer) userInfo: nil repeats: NO];
        }
    }
    else
    */
    {
        
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if(newLength == 0)
    {
        autocompleteTableView.hidden = YES;
    }
    else
    {
        autocompleteTableView.hidden = NO;
    }

//    NSString *substring = [NSString stringWithString:textField.text];
//    substring = [substring stringByReplacingCharactersInRange:range withString:string];
//    [self searchAutocompleteEntriesWithSubstring:substring];
    }
    return YES;
}


-(void)searchOnServer
{
    [timerCallService invalidate];
    timerCallService=nil;
    crossButton.hidden = YES;
    [activityIndicator startAnimating];
    [self performSelector:@selector(searchServerRequest) withObject:nil afterDelay:0.0f];
}


-(void)searchServerRequest
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"relationships/fetchusersbyname"];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSError *error;
    
    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",SearchClickinByNameTextfield.text,@"name",user_token,@"user_token",nil];
    
    NSLog(@"%@",str);
    NSLog(@"%@",Dictionary);
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [request appendPostData:jsonData];
    [request setDidFinishSelector:@selector(requestFinished_info:)];
    
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
}

- (void)requestFinished_info:(ASIHTTPRequest *)request
{
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseString %@",[request responseString]);
    
    NSError *errorl = nil;
    NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
    
    if([request responseStatusCode] == 200)
    {
        //BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Search result have found users with same name."])
        {
            arrUsers = [[NSArray arrayWithArray:[jsonResponse objectForKey:@"users"]] mutableCopy];
            StrTable.hidden =  NO;
            [SearchClickinByNameTextfield resignFirstResponder];
            [StrTable reloadData];
        }
    }
    if([request responseStatusCode] == 500)
    {
        //    BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if([[jsonResponse objectForKey:@"message"] isEqualToString:@"Search result have no user(s) with same name."])
        {
            [arrUsers removeAllObjects];
            StrTable.hidden =  NO;
            [SearchClickinByNameTextfield resignFirstResponder];
            [StrTable reloadData];
        }
    }
    crossButton.hidden = NO;
    [activityIndicator stopAnimating];
}


#pragma mark UITableViewDataSource methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
   /* if(tableView == StrTable)
    {
        if(arrUsers.count == 0)
        {
            return 1;
        }
        else
        {
            return [arrUsers count];
        }
    }
    else
    */
    return sortedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    // use a single Cell Identifier for re-use!
    CellIdentifier  = @"myCell";
    static NSString *CellIdentifiersection1 = @"Cellforsection1";

    UITableViewCell *cell;
    if(tableView == StrTable)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifiersection1];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifiersection1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor whiteColor];
//            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            UIImageView *profilepic=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
            profilepic.tag=4;
            [cell.contentView addSubview:profilepic];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60,5, 150, 20))];
            name.textColor = [UIColor darkGrayColor];
            name.textAlignment = NSTextAlignmentLeft;
            name.tag = 5;
            name.backgroundColor = [UIColor clearColor];
            name.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            name.lineBreakMode = YES;
            name.numberOfLines = 1;
            name.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:name];
            
            UILabel *lblCityCountry = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(60, 20, 150, 20))];
            lblCityCountry.textColor = [UIColor darkGrayColor];
            lblCityCountry.textAlignment = NSTextAlignmentLeft;
            lblCityCountry.tag = 6;
            lblCityCountry.backgroundColor = [UIColor clearColor];
            lblCityCountry.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16.0];
            lblCityCountry.lineBreakMode = YES;
            lblCityCountry.numberOfLines = 1;
            lblCityCountry.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblCityCountry];
            
            UILabel *lblNoRecordFound = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(20, 5, 150, 30))];
            lblNoRecordFound.textColor = [UIColor darkGrayColor];
            lblNoRecordFound.textAlignment = NSTextAlignmentLeft;
            lblNoRecordFound.tag = 9;
            lblNoRecordFound.backgroundColor = [UIColor clearColor];
            lblNoRecordFound.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:20.0];
            lblNoRecordFound.lineBreakMode = YES;
            lblNoRecordFound.numberOfLines = 1;
            lblNoRecordFound.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblNoRecordFound];
            lblNoRecordFound.hidden = YES;
            
            
            UILabel *lblInviteTest = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 0, 250, 40))];
            lblInviteTest.textColor = [UIColor darkGrayColor];
            lblInviteTest.textAlignment = NSTextAlignmentLeft;
            lblInviteTest.tag = 12;
            lblInviteTest.backgroundColor = [UIColor clearColor];
            lblInviteTest.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:16.0];
            lblInviteTest.lineBreakMode = YES;
            lblInviteTest.numberOfLines = 2;
            lblInviteTest.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.contentView addSubview:lblInviteTest];
            lblInviteTest.hidden = YES;
        }
        if(indexPath.row ==  arrUsers.count)
        {
            cell.backgroundView = nil;
            UILabel *inviteText=(UILabel*)[cell.contentView viewWithTag:12];
            inviteText.hidden=NO;
            
            inviteText.text = @"No result found.";
            
            UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
            UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
            UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
            UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
            cityCountry.hidden =  YES;
            
            lblNoRecordFound.hidden = YES;
            profile_pic.hidden =  YES;
            name.hidden = YES;
        }
        else
        {
            cell.backgroundColor=[UIColor whiteColor];

//            cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bn.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
            
            UILabel *inviteText=(UILabel*)[cell.contentView viewWithTag:12];
            UIButton *InviteBtn=(UIButton*)[cell.contentView viewWithTag:11];
            inviteText.hidden=YES;
            InviteBtn.hidden = YES;
            if(arrUsers.count!=0)
            {
                UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
                profile_pic.hidden=NO;
                UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
                name.hidden=NO;
                
                UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
                lblNoRecordFound.hidden=YES;
                
                UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
                cityCountry.hidden=NO;
                if([[arrUsers objectAtIndex:indexPath.row] valueForKey:@"user_pic"] != Nil)
                {
                    [profile_pic setImageWithURL:[NSURL URLWithString:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"user_pic"]] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed];
                }
                else
                {
                    profile_pic.image = [UIImage imageNamed:@"contact_icon.png"];
                }
                if([[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"] != Nil)
                {
                    name.text=[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
                }
                else
                {
                    name.text=[@"No name" uppercaseString];
                }
                
                cityCountry.text = [NSString stringWithFormat:@"%@,%@",[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"city"],[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"country"]];
            }
            else
            {
                UIImageView *profile_pic=(UIImageView*)[cell.contentView viewWithTag:4];
                profile_pic.hidden=YES;
                
                UILabel *name=(UILabel*)[cell.contentView viewWithTag:5];
                name.hidden = YES;
                
                UILabel *cityCountry=(UILabel*)[cell.contentView viewWithTag:6];
                cityCountry.hidden=YES;
                
                UILabel *lblNoRecordFound=(UILabel*)[cell.contentView viewWithTag:9];
                lblNoRecordFound.hidden=NO;
                
                lblNoRecordFound.text = @"No record found.";
            }
        }
    }
    else
    {
        // make lblNombre a local variable!
        UILabel *lblName;
        UILabel *lblPhoneNumber;
        UIImageView *imgView;
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            // No re-usable cell, create one here...
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            lblName = [[UILabel alloc] init];
            lblName.textColor = [UIColor lightGrayColor];
            lblName.tag = 1;
            [lblName setFrame:CGRectMake(60, 10, 200, 15)];
            lblName.backgroundColor=[UIColor clearColor];
            lblName.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
            [cell.contentView addSubview:lblName];
            
            lblPhoneNumber = [[UILabel alloc] init];
            lblPhoneNumber.tag = 2;
            lblPhoneNumber.textColor = [UIColor lightGrayColor];
            [lblPhoneNumber setFrame:CGRectMake(60, 30, 200, 15)];
            lblPhoneNumber.backgroundColor=[UIColor clearColor];
            lblPhoneNumber.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:16];
            [cell.contentView addSubview:lblPhoneNumber];
            
            imgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
            imgView.tag = 3;
            [cell.contentView addSubview:imgView];
        }
        else
        {
            // use viewWithTag to find lblNombre in the re-usable cell.contentView
            lblName = (UILabel *)[cell.contentView viewWithTag:1];
            lblPhoneNumber = (UILabel *)[cell.contentView viewWithTag:2];
            imgView = (UIImageView *)[cell.contentView viewWithTag:3];
        }
        
        // finally, always set the label text from your data model
        
        if(isNumber == FALSE)
        {
            lblName.text=[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            lblPhoneNumber.text=[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
        }
        else
        {
            lblName.text=@"";
            lblPhoneNumber.text=[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
        }
        
        imgView.image = [UIImage imageWithData:[[sortedArray objectAtIndex:indexPath.row] objectForKey:@"photo"]];
    }

    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SearchClickinByNameTextfield resignFirstResponder];
    if(StrTable == tableView)
    {
        [SearchClickinByNameTextfield resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        
        if (IS_IPHONE_5)
            StrTable.frame= CGRectMake(36, 170+90, 247, 120+40);
        else
            StrTable.frame =CGRectMake(36, 204+60, 247, 90+40);
        StrTable.hidden = TRUE;
        if(arrUsers.count == indexPath.row)
        {
            return;
        }
        
        profile_otheruser *profile_other = [[profile_otheruser alloc] initWithNibName:nil bundle:nil];
        /* profile_other.otheruser_phone_no=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerPhoneNumber;
         profile_other.relationship_id=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).relationship_ID;
         profile_other.otheruser_name=((RelationInfo*)[relationArray objectAtIndex:indexPath.row]).partnerName;*/
        profile_other.relationObject = [[RelationInfo alloc] init];
        
        profile_other.relationObject.partnerPhoneNumber = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"phone_no"];
        profile_other.relationObject.partnerName = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        
        NSMutableArray *controllers =[navigationController.viewControllers mutableCopy];
        while (controllers.count>1) {
            [controllers removeLastObject];
        }
        //[controllers addObject:profile_other];
        navigationController.viewControllers = controllers;
        [navigationController pushViewController:profile_other animated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    else
    {
        [SearchPhoneBookTextfield resignFirstResponder];
        [scroll setContentOffset:CGPointMake(0,0) animated:YES];
        if (IS_IPHONE_5)
            autocompleteTableView.frame= CGRectMake(36, 167+35+10, 247, 120+40);
        else
            autocompleteTableView.frame =CGRectMake(36, 167+5+10, 247, 90+40);
        indexValue = indexPath.row;
        autocompleteTableView.hidden = TRUE;
        
        
        if([isFromMenu isEqualToString:@"true"])
        {
            SendInvite *sendinvite = [[SendInvite alloc] initWithNibName:Nil bundle:nil];
            sendinvite.isFromMenu = @"true";
            sendinvite.dict = [sortedArray objectAtIndex:indexPath.row];
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            
            [navigationController pushViewController:sendinvite animated:YES];
            sendinvite = nil;
        }
        
        else
        {
            SendInvite *ObjSendinvite = [story instantiateViewControllerWithIdentifier:@"SendInvite"];
            ObjSendinvite.dict = [sortedArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:ObjSendinvite animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
