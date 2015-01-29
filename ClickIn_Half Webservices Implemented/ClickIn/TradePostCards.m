//
//  TradePostCards.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 23/12/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "TradePostCards.h"
#import "PlayCardView.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIButton+WebCache.h"

@interface TradePostCards ()

@end

@implementation TradePostCards

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
        NSString *card_selected = [[NSUserDefaults standardUserDefaults] objectForKey:@"card_heading"];
        if(card_selected.length>0)
            [self dismissViewControllerAnimated:YES completion:nil];
    
        card_selected = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    //self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    
    ItemsContentHeading = [[NSMutableArray alloc] init];
    ItemsContent = [[NSMutableArray alloc] init];
    ImagesContent = [[NSMutableArray alloc] init];
    CardIDs = [[NSMutableArray alloc] init];
    
    /*itemsContentHeading = [[NSMutableArray alloc] init];
    itemsContent = [[NSMutableArray alloc] init];
    imagesContent = [[NSMutableArray alloc] init];
    
    cards = [[NSMutableArray alloc] init];
    categories = [[NSMutableArray alloc] init];
    
    for(int i=0;i<25;i++)
    {
        [itemsContentHeading addObject:@"One Steamy Shower"];
        [itemsContent addObject:@"Save Water Shower Together"];
        [imagesContent addObject:@"http://demourl.com"];
    }*/
    
    topBar = [[UIImageView alloc] init];
    topBar.frame=CGRectMake(0, 0, 320, 52);
    //topBar.backgroundColor=[UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1];
    topBar.image = [UIImage imageNamed:@"cx.png"];
    [self.view addSubview:topBar];
    
    topHeading=[[UILabel alloc]initWithFrame:CGRectMake(0, 4, 320, 42)];
    topHeading.numberOfLines=1;
    topHeading.textAlignment=NSTextAlignmentCenter;
    topHeading.backgroundColor=[UIColor clearColor];
    topHeading.textColor = [UIColor whiteColor];  //[UIColor colorWithRed:54/255.0 green:69/255.0 blue:102/255.0 alpha:1];
    [topHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20]];
    topHeading.text=@"TRADE";
    [self.view addSubview:topHeading];

    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 50);
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setImage:[UIImage imageNamed:@"backicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backLabel=[[UILabel alloc]initWithFrame:CGRectMake(26 , 10 , 100, 30)];
    backLabel.numberOfLines=1;
    backLabel.textAlignment=NSTextAlignmentLeft;
    backLabel.backgroundColor=[UIColor clearColor];
    backLabel.textColor=[UIColor colorWithRed:78/255.0f green:92/255.0f blue:121/255.0f alpha:1];
    [backLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]];
    backLabel.text=@"BACK";
   // [self.view addSubview:backLabel];
    
    
    topClicks = [[UILabel alloc] initWithFrame:CGRectMake(212, 0,80,50)];
    topClicks.font = [UIFont fontWithName:@"Helvetica Bold" size:20];
    topClicks.backgroundColor = [UIColor clearColor];
    topClicks.textAlignment = NSTextAlignmentRight;
    topClicks.textColor=[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0];
    topClicks.numberOfLines=1;
    topClicks.adjustsFontSizeToFitWidth=YES;
    topClicks.minimumScaleFactor=0.25f;
    topClicks.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserClicks"] ;
    [self.view addSubview:topClicks];
    
    ClicksImgView = [[UIImageView alloc] init];
    ClicksImgView.frame=CGRectMake(295, 16, 17 , 19);
    ClicksImgView.backgroundColor=[UIColor clearColor];
    ClicksImgView.contentMode = UIViewContentModeScaleAspectFit;
    ClicksImgView.image = [UIImage imageNamed:@"img_tradeClicks.png"];
    [self.view addSubview:ClicksImgView];
    
    
    btnBackgroundView = [[UIImageView alloc] init];
    btnBackgroundView.frame=CGRectMake(0,56,320,54);
    btnBackgroundView.backgroundColor = [UIColor colorWithRed:(244/255.0) green:(244/255.0) blue:(244/255.0) alpha:1.0];
    [self.view addSubview:btnBackgroundView];
    
    activity=[[LabeledActivityIndicatorView alloc]initWithController:self andText:@"Loading..."];
    [activity show];
    
    [self performSelector:@selector(customViewDidLoad) withObject:nil afterDelay:0.1];
    
    /*
    
    //categories btns
    categoryBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn1.frame = CGRectMake(0, 56, 80, 54);
    categoryBtn1.backgroundColor = [UIColor clearColor];
    categoryBtn1.tag=11;
    [categoryBtn1 setTitle:@"PARTY" forState:UIControlStateNormal];
    [categoryBtn1 setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
    categoryBtn1.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
    [categoryBtn1 addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:categoryBtn1];
    
    categoryBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn2.frame = CGRectMake(80, 56, 80, 54);
    categoryBtn2.backgroundColor = [UIColor clearColor];
    categoryBtn2.tag=22;
    [categoryBtn2 setTitle:@"SPECIAL" forState:UIControlStateNormal];
    [categoryBtn2 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    categoryBtn2.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
    [categoryBtn2 addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:categoryBtn2];
    
    categoryBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn3.frame = CGRectMake(160, 56, 80, 54);
    categoryBtn3.backgroundColor = [UIColor clearColor];
    categoryBtn3.tag=33;
    [categoryBtn3 setTitle:@"NAUGHTY" forState:UIControlStateNormal];
    [categoryBtn3 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    categoryBtn3.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
    [categoryBtn3 addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:categoryBtn3];
    
    categoryBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn4.frame = CGRectMake(240, 56, 80, 54);
    categoryBtn4.backgroundColor = [UIColor clearColor];
    categoryBtn4.tag=44;
    [categoryBtn4 setTitle:@"HOME" forState:UIControlStateNormal];
    [categoryBtn4 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
    categoryBtn4.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
    [categoryBtn4 addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:categoryBtn4];

    
    //bottom blue strip of category buttons
    blueBottomStripView = [[UIImageView alloc] init];
    blueBottomStripView.frame=CGRectMake(0,56+54-4.5,80,4.5);
    blueBottomStripView.backgroundColor = [UIColor clearColor];
    blueBottomStripView.image = [UIImage imageNamed:@"trade-bottomborder.png"];
    [self.view addSubview:blueBottomStripView];
    
    //vertical bars to seperate category btns
    for(int i=0;i<3;i++)
    {
        UIImageView *VerticalStripView = [[UIImageView alloc] init];
        VerticalStripView.frame=CGRectMake(80 + i*80 -0.75,56+11.5,1.5,31);
        VerticalStripView.backgroundColor = [UIColor clearColor];
        VerticalStripView.image = [UIImage imageNamed:@"trade-leftborder.png"];
        [self.view addSubview:VerticalStripView];
    }
    
    
    
    //----Scroll View Implementation------
    itemsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120)];
    itemsScrollView.backgroundColor = [UIColor clearColor];
    if(IS_IPHONE_5)
        itemsScrollView.contentSize = CGSizeMake(320, (self.view.frame.size.height-120) * itemsContent.count/10);
    else
        itemsScrollView.contentSize = CGSizeMake(320, (self.view.frame.size.height-120) * itemsContent.count/8);
    itemsScrollView.showsHorizontalScrollIndicator = NO;
    itemsScrollView.showsVerticalScrollIndicator = YES;
    [itemsScrollView setScrollEnabled:YES];
    itemsScrollView.scrollsToTop = YES;
    itemsScrollView.delegate = self;
    [self.view addSubview:itemsScrollView];
    
    
    for(int i=0;i<itemsContent.count/3;i++)
    {
        for(int j=0;j<3;j++)
        {
            //------card selection button-----
            UIButton *cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cardBtn.frame = CGRectMake(95*j + 8.5f*j + 8.5f , 125*i + 10*i +10, 95, 125);
            cardBtn.backgroundColor = [UIColor clearColor];
            cardBtn.tag=(3*i)+j;
            if(cardBtn.tag==0)
                [cardBtn setImage:[UIImage imageNamed:@"make_custom_card.png"] forState:UIControlStateNormal];
            else
                [cardBtn setImage:[UIImage imageNamed:@"steamy-shower.png"] forState:UIControlStateNormal];
            [cardBtn addTarget:self action:@selector(cardBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [itemsScrollView addSubview:cardBtn];
            
            //--- content heading Label------
            UILabel * lbl_Heading=[[UILabel alloc]initWithFrame:CGRectMake(cardBtn.frame.origin.x + 10, cardBtn.frame.origin.y + 25, 75, 42)];
            lbl_Heading.numberOfLines=2;
            lbl_Heading.textAlignment=NSTextAlignmentCenter;
            lbl_Heading.backgroundColor=[UIColor clearColor];
            lbl_Heading.textColor=[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1];
            [lbl_Heading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
            if(cardBtn.tag==0)
                lbl_Heading.text = @"";
            else
                lbl_Heading.text=[[itemsContentHeading objectAtIndex:(3*i)+j] uppercaseString];
            [itemsScrollView addSubview:lbl_Heading];
            
            //--- content Label------
            UILabel * lbl_Info=[[UILabel alloc]initWithFrame:CGRectMake(cardBtn.frame.origin.x + 10, cardBtn.frame.origin.y + 68, 75, 42)];
            lbl_Info.numberOfLines=2;
            lbl_Info.textAlignment=NSTextAlignmentCenter;
            lbl_Info.backgroundColor=[UIColor clearColor];
            lbl_Info.textColor=[UIColor whiteColor];
            [lbl_Info setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12]];
            if(cardBtn.tag==0)
                lbl_Info.text = @"";
            else
                lbl_Info.text=[itemsContent objectAtIndex:(3*i)+j];
            [itemsScrollView addSubview:lbl_Info];

        }
    }
    */

    
    
}

-(void)customViewDidLoad
{
    [self getcardslist];
    
    categoryScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,56,320,54)];
    categoryScroll.backgroundColor = [UIColor clearColor];
    categoryScroll.contentSize = CGSizeMake(categories.count*80, 54);
    categoryScroll.showsHorizontalScrollIndicator = YES;
    categoryScroll.showsVerticalScrollIndicator = NO;
    categoryScroll.scrollsToTop = NO;
    categoryScroll.scrollEnabled =YES;
    categoryScroll.delegate = self;
    categoryScroll.tag = 555;
    categoryScroll.alpha=1;
    [self.view addSubview:categoryScroll];
    
    //bottom blue strip of category buttons
    blueBottomStripView = [[UIImageView alloc] init];
    blueBottomStripView.frame=CGRectMake(0,54-4.5,80,4.5);
    blueBottomStripView.backgroundColor = [UIColor clearColor];
    blueBottomStripView.image = [UIImage imageNamed:@"trade-bottomborder.png"];
    [categoryScroll addSubview:blueBottomStripView];
    
    for(int i=0 ; i<categories.count ; i++)
    {
        UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame = CGRectMake(i*80, 0, 80, 54);
        categoryBtn.backgroundColor = [UIColor clearColor];
        categoryBtn.tag=i+1;
        [categoryBtn setTitle:[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] forState:UIControlStateNormal];
        if(categoryBtn.tag==1)
        {
            [categoryBtn setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
        }
        else
        {
            [categoryBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            categoryBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        }
        [categoryBtn addTarget:self action:@selector(categoryBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [categoryScroll addSubview:categoryBtn];
        categoryBtn = nil;
        
        if(i<categories.count-1)
        {
            UIImageView *VerticalStripView = [[UIImageView alloc] init];
            VerticalStripView.frame=CGRectMake(80 + i*80 -0.75,11.5,1.5,31);
            VerticalStripView.backgroundColor = [UIColor clearColor];
            VerticalStripView.image = [UIImage imageNamed:@"trade-leftborder.png"];
            [categoryScroll addSubview:VerticalStripView];
            VerticalStripView = nil;
        }
        
        
        //----Scroll View Implementation------
        NSMutableArray *itemsContentHeading=[[NSMutableArray alloc] init]; // for storing the text items of each card
        NSMutableArray *itemsContent=[[NSMutableArray alloc] init];
        NSMutableArray *imagesContent=[[NSMutableArray alloc] init]; // for storing the images for each card
        NSMutableArray *cardIDs = [[NSMutableArray alloc] init];
        
        //add one custom card for make your own
        if([[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"CUSTOM"] || [[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"ALL"])
        {
            [itemsContentHeading addObject:@""];
            [itemsContent addObject:@""];
            [imagesContent addObject:@""];
            [cardIDs addObject:@""];
        }
        
        for(int j=0;j<cards.count;j++)
        {
            for(int k=0;k<[[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"category"] count];k++)
            {
                if([[[[[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"category"] objectAtIndex:k] objectForKey:@"name"] uppercaseString] isEqualToString:[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString]])
                {
                    [itemsContentHeading addObject:[[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"title"] uppercaseString]];
                    [itemsContent addObject:[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"description"] ];
                    [imagesContent addObject:[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"image"] ];
                    [cardIDs addObject:[[[[cards objectAtIndex:j] objectForKey:@"Card"] objectForKey:@"_id"] uppercaseString]];
                }
            }
        }
        
        [ItemsContentHeading addObject:itemsContentHeading];
        [ItemsContent addObject:itemsContent];
        [ImagesContent addObject:imagesContent];
        [CardIDs addObject:cardIDs];
        
        
        UIScrollView *itemsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120)];
        itemsScrollView.backgroundColor = [UIColor clearColor];
        if(IS_IPHONE_5)
            itemsScrollView.contentSize = CGSizeMake(320, (self.view.frame.size.height-120) * ceilf([[ItemsContent objectAtIndex:i] count]/9.8) - 30);
        else
            itemsScrollView.contentSize = CGSizeMake(320, (self.view.frame.size.height-120) * ceilf([[ItemsContent objectAtIndex:i] count]/6.8) - 60);
        itemsScrollView.showsHorizontalScrollIndicator = NO;
        itemsScrollView.showsVerticalScrollIndicator = YES;
        [itemsScrollView setScrollEnabled:YES];
        itemsScrollView.scrollsToTop = YES;
        itemsScrollView.delegate = self;
        itemsScrollView.tag = i+1+10000;
        itemsScrollView.alpha = 0;
        [self.view addSubview:itemsScrollView];
        
        
        for(int l=0;l< ceilf([[ItemsContentHeading objectAtIndex:i] count]/3.0);l++)
        {
            int column_count=0;
            if(l+1>=ceilf([[ItemsContentHeading objectAtIndex:i] count]/3.0))
                column_count = [[ItemsContentHeading objectAtIndex:i] count]%3;
            if(column_count==0)
                column_count=3;
            
            for(int m=0;m<column_count;m++)
            {
                //------card Imageview--------
                UIImageView *cardImgView = [[UIImageView alloc] init];
                cardImgView.frame=CGRectMake(95*m + 8.5f*m + 8.5f , 125*l + 10*l +10, 95, 125);
                if((3*l)+m == 0 && [[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"CUSTOM"])
                    [cardImgView setImage:[UIImage imageNamed:@"make_custom_card.png"]];
                else if((3*l)+m == 0 && [[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"ALL"])
                    [cardImgView setImage:[UIImage imageNamed:@"make_custom_card.png"]];
                else
                    [cardImgView setImage:[UIImage imageNamed:@"steamy-shower.png"]];
                    //[cardImgView setImageWithURL:[NSURL URLWithString:[[ImagesContent objectAtIndex:i] objectAtIndex:(3*l)+m]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [itemsScrollView addSubview:cardImgView];
                
                
                //------card selection button-----
                UIButton *cardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cardBtn.frame = CGRectMake(95*m + 8.5f*m + 8.5f , 125*l + 10*l +10, 95, 125);
                cardBtn.backgroundColor = [UIColor clearColor];
                cardBtn.tag=(3*l)+m;
                /*if(cardBtn.tag==0 && [[[[[categories objectAtIndex:i] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"CUSTOM"])
                    [cardBtn setImage:[UIImage imageNamed:@"make_custom_card.png"] forState:UIControlStateNormal];
                else
                    [cardBtn setImage:[UIImage imageNamed:@"steamy-shower.png"] forState:UIControlStateNormal];*/
                [cardBtn addTarget:self action:@selector(cardBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                [itemsScrollView addSubview:cardBtn];
                
                //--- content heading Label------
                UILabel * lbl_Heading=[[UILabel alloc]initWithFrame:CGRectMake(cardBtn.frame.origin.x + 5, cardBtn.frame.origin.y + 25, 85, 42)];
                lbl_Heading.numberOfLines=2;
                lbl_Heading.textAlignment=NSTextAlignmentCenter;
                lbl_Heading.backgroundColor=[UIColor clearColor];
                lbl_Heading.textColor=[UIColor colorWithRed:57/255.0 green:202/255.0 blue:212/255.0 alpha:1];
                [lbl_Heading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:12.2f]];
                
                lbl_Heading.text=[[[ItemsContentHeading objectAtIndex:i] objectAtIndex:(3*l)+m] uppercaseString];
                [itemsScrollView addSubview:lbl_Heading];
                
                //--- content Label------
                UILabel * lbl_Info=[[UILabel alloc]initWithFrame:CGRectMake(cardBtn.frame.origin.x + 5, cardBtn.frame.origin.y + 68, 85, 42)];
                lbl_Info.numberOfLines=2;
                lbl_Info.textAlignment=NSTextAlignmentCenter;
                lbl_Info.backgroundColor=[UIColor clearColor];
                lbl_Info.textColor=[UIColor whiteColor];
                [lbl_Info setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:12.5f]];
                lbl_Info.text=[[ItemsContent objectAtIndex:i] objectAtIndex:(3*l)+m];
                [itemsScrollView addSubview:lbl_Info];
                
            }
        }
        
        itemsScrollView = nil;
        itemsContentHeading = nil;
        itemsContent =nil;
        imagesContent = nil;
        
    }
    
    UIScrollView *firstScrollView = (UIScrollView*)[self.view viewWithTag:1+10000];
    firstScrollView.alpha=1;
    
    [activity hide];
}


-(void)getcardslist
{
    NSString *str = [NSString stringWithFormat:DomainNameUrl@"chats/fetchcards"];
    
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    //    NSError *error;
    //
    //    NSDictionary *Dictionary;
    
    NSString *phoneno=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
    NSString *user_token=(NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"user_token"];
    
    //    Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:phoneno,@"phone_no",user_token,@"user_token",nil];
    //
    //    NSLog(@"%@",str);
    //    NSLog(@"%@",Dictionary);
    
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Dictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Phone-No" value:phoneno];
    [request addRequestHeader:@"User-Token" value:user_token];
    
    //    [request appendPostData:jsonData];
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setTimeOutSeconds:200];
    [request startSynchronous];
    
    if([request responseStatusCode] == 200)
    {
        NSError *errorl = nil;
        NSData *Data = [[request responseString] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:Data options:kNilOptions error:&errorl];
        
        BOOL success=[[jsonResponse objectForKey:@"success"] boolValue];
        if(success)
        {
            cards = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"cards"]];
            categories = [[NSMutableArray alloc] initWithArray:[jsonResponse objectForKey:@"categories"]];
            //[[[categories objectAtIndex:0] objectForKey:@"Category"] objectForKey:@"name"]
        }
        else
        {
            MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                            description:errorl.description
                                                                          okButtonTitle:@"OK"];
            alertView.delegate = nil;
            [alertView showForPresentView];
            alertView = nil;
        }
        
    }
    else
    {
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        alert = nil;
        
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:[NSString stringWithFormat:@"Error : %d",[request responseStatusCode]]
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        
        
    }
}

-(void)categoryBtnPressed:(UIButton *)sender
{
    NSLog(@"ItemsContentHeading%@",categories);
    NSDictionary *dict=[categories objectAtIndex:sender.tag-1];
    NSString *strCat = [[dict objectForKey:@"Category"] objectForKey:@"name"];

    if (strCat.length>0)
    {
        [[Mixpanel sharedInstance] track:@"RPageTradeButtonClicked" properties:@{
                                                                                 @"CategorySelected": strCat
                                                                                }];
    }
    
    
    for(UIView *v in [self.view subviews])
    {
        if([v isKindOfClass:[UIScrollView class]])
        {
            
            if(((UIScrollView*)v).tag==555)
            {
                for(UIView *btn in [(UIScrollView*)v subviews])
                {
                    if([btn isKindOfClass:[UIButton class]])
                    {
                        if(((UIButton*)btn).tag==sender.tag)
                        {
                            [(UIButton*)btn setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
                            ((UIButton*)btn).titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
                        }
                        else
                        {
                            [(UIButton*)btn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
                            ((UIButton*)btn).titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
                        }
                    }
                }
            }
            if(((UIScrollView*)v).tag!=555)
            {
                [UIView animateWithDuration:0.25 animations:^() {
                    ((UIScrollView*)v).alpha = 0;
                }];

                //((UIScrollView*)v).hidden = YES;
            }
            
            if(((UIScrollView*)v).tag == sender.tag + 10000)
            {
                selected_tabCount = sender.tag - 1;
                blueBottomStripView.frame=CGRectMake(80*selected_tabCount,54-4.5,80,4.5);
                [UIView animateWithDuration:1 animations:^() {
                    ((UIScrollView*)v).alpha = 1;
                }];
            }
        }
    }
    /*if(sender.tag==11)
    {
        [categoryBtn1 setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn1.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
        [categoryBtn2 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn2.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn3 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn3.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn4 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn4.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        
        blueBottomStripView.frame=CGRectMake(0,56+54-4.5,80,4.5);
    }
    else if(sender.tag==22)
    {
        [categoryBtn1 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn1.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn2 setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn2.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
        [categoryBtn3 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn3.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn4 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn4.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        
        blueBottomStripView.frame=CGRectMake(80,56+54-4.5,80,4.5);
    }
    else if(sender.tag==33)
    {
        [categoryBtn1 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn1.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn2 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn2.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn3 setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn3.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
        [categoryBtn4 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn4.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        
        blueBottomStripView.frame=CGRectMake(160,56+54-4.5,80,4.5);
    }
    else if(sender.tag==44)
    {
        [categoryBtn1 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn1.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn2 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn2.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn3 setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn3.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14];
        [categoryBtn4 setTitleColor:[UIColor colorWithRed:72/255.0 green:177/255.0 blue:199/255.0 alpha:1] forState:UIControlStateNormal];
        categoryBtn4.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14];
        
        blueBottomStripView.frame=CGRectMake(240,56+54-4.5,80,4.5);
    }
     */

}


-(void) cardBtnPressed:(UIButton *)sender
{
    PlayCardView *obj=[[PlayCardView alloc] init];
    obj.contentHeading = [[ItemsContentHeading objectAtIndex:selected_tabCount] objectAtIndex:sender.tag];
    
    NSString *str=[[ItemsContentHeading objectAtIndex:selected_tabCount] objectAtIndex:sender.tag];
    NSLog(@"str is %@",str);
    if (str.length>0)
    {
        Mixpanel *mixpanel=[Mixpanel sharedInstance];
        [mixpanel track:@"RPageTradeButtonClicked" properties:@{
                                                                @"Card Visited": str
                                                                }];

    }
    
    //[mixpanel.people increment:str by:[NSNumber numberWithInt:1]];
    
    obj.content = [[ItemsContent objectAtIndex:selected_tabCount] objectAtIndex:sender.tag];
    obj.imageUrl = [[ImagesContent objectAtIndex:selected_tabCount] objectAtIndex:sender.tag];
    obj.ID = [[CardIDs objectAtIndex:selected_tabCount] objectAtIndex:sender.tag];
    obj.card_id=@"";
    obj.clicks = @"0";
    if([[[[[categories objectAtIndex:selected_tabCount] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"CUSTOM"])
    {
        obj.is_CustomCard = @"true";
    }
    else if([[[[[categories objectAtIndex:selected_tabCount] objectForKey:@"Category"] objectForKey:@"name"] uppercaseString] isEqualToString:@"ALL"] && sender.tag==0)
    {
        obj.is_CustomCard = @"true";
    }
    else
        obj.is_CustomCard = @"false";
    //[self.navigationController pushViewController:obj animated:YES];
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;
   /* PlayCardView *obj=[[PlayCardView alloc] init];
    obj.contentHeading = [itemsContentHeading objectAtIndex:sender.tag];
    obj.content = [itemsContent objectAtIndex:sender.tag];
    obj.imageUrl = [imagesContent objectAtIndex:sender.tag];
    obj.card_id=@"";
    obj.clicks = @"0";
    if(sender.tag==0)
    {
        obj.is_CustomCard = @"true";
        obj.contentHeading = @"";
        obj.content = @"";
        obj.imageUrl = @"";
    }
    else
        obj.is_CustomCard = @"false";
    //[self.navigationController pushViewController:obj animated:YES];
    [self presentViewController:obj animated:YES completion:nil];
    obj=nil;*/
}


-(void)backBtnPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
