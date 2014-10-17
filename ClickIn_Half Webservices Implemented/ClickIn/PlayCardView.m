//
//  PlayCardView.m
//  ClickIn
//
//  Created by Kabir Chandhoke on 24/12/13.
//  Copyright (c) 2013 Kabir Chandhoke. All rights reserved.
//

#import "PlayCardView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface PlayCardView ()

@end

@implementation PlayCardView

const float MAX_HEIGHT_MESSAGE_TEXTBOX = 135;
const float MIN_HEIGHT_MESSAGE_TEXTBOX = 30;

@synthesize content,contentHeading,imageUrl,card_id,clicks,card_owner,card_originator,is_CustomCard,ID;

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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5f];
    
    
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
    
    //if(card_id.length==0)
    //{
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 50);
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setImage:[UIImage imageNamed:@"backicon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    backLabel=[[UILabel alloc]initWithFrame:CGRectMake(32 , 8 , 100, 30)];
    backLabel.numberOfLines=1;
    backLabel.textAlignment=NSTextAlignmentLeft;
    backLabel.backgroundColor=[UIColor clearColor];
    backLabel.textColor=[UIColor colorWithRed:78/255.0f green:92/255.0f blue:121/255.0f alpha:1];
    [backLabel setFont:[UIFont fontWithName:@"AvenirNextLTPro-MediumCn" size:14]];
    backLabel.text=@"BACK";
    [self.view addSubview:backLabel];
    //}
    
    top_Clicks = [[UILabel alloc] initWithFrame:CGRectMake(212, 0,80,50)];
    top_Clicks.font = [UIFont fontWithName:@"Helvetica Bold" size:20];
    top_Clicks.backgroundColor = [UIColor clearColor];
    top_Clicks.textAlignment = NSTextAlignmentRight;
    top_Clicks.textColor=[UIColor colorWithRed:(242.0/255.0) green:(150.0/255.0) blue:(145.0/255.0) alpha:1.0];
    top_Clicks.numberOfLines=1;
    top_Clicks.adjustsFontSizeToFitWidth=YES;
    top_Clicks.minimumScaleFactor=0.25f;
    top_Clicks.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserClicks"] ;
    [self.view addSubview:top_Clicks];
    
    ClicksImgView = [[UIImageView alloc] init];
    ClicksImgView.frame=CGRectMake(295, 16, 17 , 19);
    ClicksImgView.backgroundColor=[UIColor clearColor];
    ClicksImgView.contentMode = UIViewContentModeScaleAspectFit;
    ClicksImgView.image = [UIImage imageNamed:@"img_tradeClicks.png"];
    [self.view addSubview:ClicksImgView];
    
    cardImgView = [[UIImageView alloc] init];
    cardImgView.frame=CGRectMake(self.view.frame.size.width/2 - 269/2, self.view.frame.size.height/2 - 354/2 - 45, 269, 354);
    if([is_CustomCard isEqualToString:@"true"])
        cardImgView.image=[UIImage imageNamed:@"custom_card.png"];
    else
        [cardImgView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRefreshCached | SDWebImageRetryFailed usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //[cardImgView setImageWithURL:[NSURL URLWithString:imageUrl]  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //cardImgView.image=[UIImage imageNamed:@"savewater.png"];
    
    [self.view addSubview:cardImgView];
    
    topClicks=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 269/2 + 10 , self.view.frame.size.height/2 - 354/2 - 45 + 5, 50, 50)];
    topClicks.numberOfLines=1;
    topClicks.textAlignment=NSTextAlignmentCenter;
    topClicks.backgroundColor=[UIColor clearColor];
    topClicks.textColor=[UIColor whiteColor];
    [topClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:40]];
    topClicks.text=clicks;
    [self.view addSubview:topClicks];
    
    bottomClicks=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 + 269/2 - 92 , self.view.frame.size.height/2 + 354/2 - 45 - 55, 50, 50)];
    if([is_CustomCard isEqualToString:@"true"])
        bottomClicks.frame = CGRectMake(self.view.frame.size.width/2 + 269/2 - 92 , self.view.frame.size.height/2 + 354/2 - 110, 50, 50);
    bottomClicks.numberOfLines=1;
    bottomClicks.textAlignment=NSTextAlignmentCenter;
    bottomClicks.backgroundColor=[UIColor clearColor];
    bottomClicks.textColor=[UIColor whiteColor];
    [bottomClicks setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:40]];
    bottomClicks.text=clicks;
    [self.view addSubview:bottomClicks];
    
    
    whiteBgView = [[UIImageView alloc] init];
    whiteBgView.image = [UIImage imageNamed:@"white_bg.png"];
    [self.view addSubview:whiteBgView];
    if([is_CustomCard isEqualToString:@"true"])
        whiteBgView.frame = CGRectMake(self.view.frame.size.width/2 - 269/2 +30, self.view.frame.size.height/2 - 354/4 - 45, 269 - 60, 354/2);
    else
        whiteBgView.frame = CGRectZero;
    
    
    whiteBgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    whiteBgBtn.frame = whiteBgView.frame;
    whiteBgBtn.backgroundColor = [UIColor clearColor];
    whiteBgBtn.titleLabel.numberOfLines = 2;
    whiteBgBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [whiteBgBtn setTitleColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] forState:UIControlStateNormal];
    whiteBgBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:24];
    [whiteBgBtn setTitle:@"ENTER YOUR TEXT HERE" forState:UIControlStateNormal];
    [whiteBgBtn addTarget:self action:@selector(whiteBgBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whiteBgBtn];
    
    
    
    CardHeading=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 269/2 +30, self.view.frame.size.height/2 - 354/4 - 48, 269 - 60, 354/2)];
    CardHeading.numberOfLines=4;
    CardHeading.textAlignment=NSTextAlignmentCenter;
    CardHeading.backgroundColor=[UIColor clearColor];
    CardHeading.textColor=[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1];
    [CardHeading setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:20]];
    CardHeading.text=@"";
    [self.view addSubview:CardHeading];

    
    
    customTextView=[[UITextView alloc] init];
    [customTextView setBackgroundColor:[UIColor clearColor]];
    customTextView.font = [UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:26.0];
    customTextView.textColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [customTextView setEditable:YES];
    [customTextView setScrollEnabled:NO];
    customTextView.layer.cornerRadius=8;
    customTextView.textAlignment = NSTextAlignmentCenter;
    [customTextView sizeToFit];
    [customTextView setAutocorrectionType:UITextAutocorrectionTypeYes];
    [customTextView setKeyboardAppearance:UIKeyboardAppearanceDark];
    [customTextView setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    customTextView.delegate = self;
    customTextView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    [customTextView setContentInset:UIEdgeInsetsMake(0,0,-10,0)];
    [self.view addSubview:customTextView];
    
    if([is_CustomCard isEqualToString:@"true"])
    {
        customTextView.frame = CGRectMake(self.view.frame.size.width/2 - 269/2 +35, self.view.frame.size.height/2 - 354/8 - 40, 269 - 70, 354/4);
        if(contentHeading.length>0)
        {
            cardImgView.image=[UIImage imageNamed:@"custom_card_Bar.png"];
            
            customTextView.frame = CGRectMake(self.view.frame.size.width/2 - 269/2 +35, self.view.frame.size.height/2 - 354/4 - 40, 269 - 70, 354/2);
            
            customTextView.text = [contentHeading uppercaseString];
            customTextView.hidden=YES;
            whiteBgView.hidden = YES;
            whiteBgBtn.hidden = YES;
            [customTextView setEditable:NO];
            [whiteBgBtn setTitle:@"" forState:UIControlStateNormal];
            CardHeading.text = [contentHeading uppercaseString];
        }
    }
    else
        customTextView.frame = CGRectZero;
    
    
    if(!IS_IPHONE_5)
    {
        cardImgView.frame=CGRectMake(self.view.frame.size.width/2 - 228/2, self.view.frame.size.height/2 - 300/2 - 30, 228, 300);
        topClicks.frame=CGRectMake(self.view.frame.size.width/2 - 228/2 + 2 , self.view.frame.size.height/2 - 300/2 - 30, 50, 50);
        bottomClicks.frame=CGRectMake(self.view.frame.size.width/2 + 228/2 - 85 , self.view.frame.size.height/2 + 300/2 - 81, 50, 50);
        if([is_CustomCard isEqualToString:@"true"])
        {
            bottomClicks.frame=CGRectMake(self.view.frame.size.width/2 + 228/2 - 85 , self.view.frame.size.height/2 + 300/2 - 81 - 10, 50, 50);
            customTextView.frame = CGRectMake(self.view.frame.size.width/2 - 228/2 + 35, self.view.frame.size.height/2 - 300/4 - 35 , 228 - 70, 300/2);
            whiteBgView.frame = CGRectMake(self.view.frame.size.width/2 - 228/2 + 27, self.view.frame.size.height/2 - 300/4 - 40, 228 - 50, 300/2);
            CardHeading.frame=CGRectMake(self.view.frame.size.width/2 - 228/2 +30, self.view.frame.size.height/2 - 300/4 -35 , 228 - 60, 300/2);
        }
    }
    
    
    // ----how many clicks text------
    bottomText=[[UILabel alloc]initWithFrame:CGRectMake(14 , self.view.frame.size.height - 105, 300, 50)];
    bottomText.numberOfLines=1;
    bottomText.textAlignment=NSTextAlignmentLeft;
    bottomText.backgroundColor=[UIColor clearColor];
    bottomText.textColor=[UIColor blackColor];
    [bottomText setFont:[UIFont fontWithName:@"AvenirNextLTPro-BoldCn" size:14]];
    if(card_id.length==0)
    {
        bottomText.text=@"HOW MANY CLICKS ARE YOU WILLING TO OFFER?";
    }
    else
    {
        if ([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"SenderId"]] isEqualToString:card_owner])
        {
            bottomText.text=@"HOW MANY CLICKS ARE YOU WILLING TO OFFER?";
        }
        else
        {
            bottomText.text=@"HOW MANY CLICKS DO YOU WANT FOR IT?";
        }
    }
    
    
    
    
    [self.view addSubview:bottomText];
    
    
    btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(7, self.view.frame.size.height-60, 44, 44);
    btn5.backgroundColor = [UIColor clearColor];
    btn5.tag=5;
    [btn5 setImage:[UIImage imageNamed:@"iconfive.png"] forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(clicksBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
    btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn10.frame = CGRectMake(57, self.view.frame.size.height-60, 44, 44);
    btn10.backgroundColor = [UIColor clearColor];
    btn10.tag=10;
    [btn10 setImage:[UIImage imageNamed:@"iconten.png"] forState:UIControlStateNormal];
    [btn10 addTarget:self action:@selector(clicksBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn10];
    
    btn15 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn15.frame = CGRectMake(107, self.view.frame.size.height-60, 44, 44);
    btn15.backgroundColor = [UIColor clearColor];
    btn15.tag=15;
    [btn15 setImage:[UIImage imageNamed:@"iconfifteen.png"] forState:UIControlStateNormal];
    [btn15 addTarget:self action:@selector(clicksBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn15];
    
    btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn20.frame = CGRectMake(157, self.view.frame.size.height-60, 44, 44);
    btn20.backgroundColor = [UIColor clearColor];
    btn20.tag=20;
    [btn20 setImage:[UIImage imageNamed:@"icontwenty.png"] forState:UIControlStateNormal];
    [btn20 addTarget:self action:@selector(clicksBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn20];
    
    btn25 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn25.frame = CGRectMake(207, self.view.frame.size.height-60, 44, 44);
    btn25.backgroundColor = [UIColor clearColor];
    btn25.tag=25;
    [btn25 setImage:[UIImage imageNamed:@"icontwentyfive.png"] forState:UIControlStateNormal];
    [btn25 addTarget:self action:@selector(clicksBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn25];
    
    if([clicks isEqualToString:@"5"])
        [btn5 setImage:[UIImage imageNamed:@"iconfiveW.png"] forState:UIControlStateNormal];
    else if([clicks isEqualToString:@"10"])
        [btn10 setImage:[UIImage imageNamed:@"icontenW.png"] forState:UIControlStateNormal];
    else if([clicks isEqualToString:@"15"])
        [btn15 setImage:[UIImage imageNamed:@"iconfifteenW.png"] forState:UIControlStateNormal];
    else if([clicks isEqualToString:@"20"])
        [btn20 setImage:[UIImage imageNamed:@"icontwentyW.png"] forState:UIControlStateNormal];
    else if([clicks isEqualToString:@"25"])
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfiveW.png"] forState:UIControlStateNormal];
    
    
    playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(self.view.frame.size.width-138/2 + 8, self.view.frame.size.height-55, 138/2, 66/2);
    playBtn.backgroundColor = [UIColor clearColor];
    if([clicks isEqualToString:@"-"] || [clicks isEqualToString:@""] || [clicks isEqualToString:@"0"])
        [playBtn setImage:[UIImage imageNamed:@"playbutton_disabled.png"] forState:UIControlStateNormal];
    else
        [playBtn setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];

    
    //tap gesture to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:tap];

     [self.view bringSubviewToFront:self.tintView];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if(customTextView.text.length==0)
        [whiteBgBtn setTitle:@"ENTER YOUR TEXT HERE" forState:UIControlStateNormal];
    [customTextView resignFirstResponder];
}


-(void)whiteBgBtnPressed
{
    [whiteBgBtn setTitle:@"" forState:UIControlStateNormal];
    [customTextView becomeFirstResponder];
}

- (void)setFrameToTextSize:(CGRect)txtFrame textView:(UITextView *)textView
{
    
    if(txtFrame.size.height > MAX_HEIGHT_MESSAGE_TEXTBOX)
    {
        //OK, the new frame is to large. Let's use scroll
        txtFrame.size.height = MAX_HEIGHT_MESSAGE_TEXTBOX;
        [textView scrollRangeToVisible:NSMakeRange([textView.text length], 0)];
        textView.scrollEnabled = NO;
    }
    else
    {
        if (textView.frame.size.height < MIN_HEIGHT_MESSAGE_TEXTBOX) {
            //OK, the new frame is to small. Let's set minimum size
            txtFrame.size.height = MIN_HEIGHT_MESSAGE_TEXTBOX;
        }
        //no need for scroll
        textView.scrollEnabled = NO;
    }
    //set the frame
    textView.frame = txtFrame;
}

- (void)setframeToTextSize:(UITextView *)textView animated:(BOOL)animated
{
    //get current height
    CGRect txtFrame = textView.frame;
    
    //calculate height needed with selected font. Note the options.
    //append a new line to make space for the cursor after user hit the return key
    txtFrame.size.height =[[NSString stringWithFormat:@"%@\n ",textView.text]
                           boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height + 7;
    txtFrame.origin.y = whiteBgView.frame.origin.y + whiteBgView.frame.size.height/2 - txtFrame.size.height/2 + 11;
    
    if (animated) {
        //set the new frame, animated for a more nice transition
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self setFrameToTextSize:txtFrame textView:textView];
        } completion:nil];
    }
    else
    {
        [self setFrameToTextSize:txtFrame textView:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setframeToTextSize:textView animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [whiteBgBtn setTitle:@"" forState:UIControlStateNormal];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    // limit the number of lines in textview
    NSString* newText = [customTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    // pretend there's more vertical space to get that extra line to check on
    CGSize tallerSize = CGSizeMake(customTextView.frame.size.width-15, customTextView.frame.size.height*2);
    
    CGSize newSize = [newText sizeWithFont:customTextView.font constrainedToSize:tallerSize lineBreakMode: NSLineBreakByCharWrapping];
    
    if (newSize.height > MAX_HEIGHT_MESSAGE_TEXTBOX)
    {
        NSLog(@"lines are full");
        if(customTextView.text.length==0)
            [whiteBgBtn setTitle:@"ENTER YOUR TEXT HERE" forState:UIControlStateNormal];
        [customTextView resignFirstResponder];
        return NO;
    }
    
    
    // dismiss keyboard and send comment
    if([text isEqualToString:@"\n"]) {
        if(customTextView.text.length==0)
            [whiteBgBtn setTitle:@"ENTER YOUR TEXT HERE" forState:UIControlStateNormal];
        [customTextView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

-(void)clicksBtnPressed:(UIButton *)sender
{
    [playBtn setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    
    if(sender.tag==5)
    {
        [btn5 setImage:[UIImage imageNamed:@"iconfiveW.png"] forState:UIControlStateNormal];
        [btn10 setImage:[UIImage imageNamed:@"iconten.png"] forState:UIControlStateNormal];
        [btn15 setImage:[UIImage imageNamed:@"iconfifteen.png"] forState:UIControlStateNormal];
        [btn20 setImage:[UIImage imageNamed:@"icontwenty.png"] forState:UIControlStateNormal];
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfive.png"] forState:UIControlStateNormal];
    }
    
    if(sender.tag==10)
    {
        [btn5 setImage:[UIImage imageNamed:@"iconfive.png"] forState:UIControlStateNormal];
        [btn10 setImage:[UIImage imageNamed:@"icontenW.png"] forState:UIControlStateNormal];
        [btn15 setImage:[UIImage imageNamed:@"iconfifteen.png"] forState:UIControlStateNormal];
        [btn20 setImage:[UIImage imageNamed:@"icontwenty.png"] forState:UIControlStateNormal];
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfive.png"] forState:UIControlStateNormal];
    }
    
    if(sender.tag==15)
    {
        [btn5 setImage:[UIImage imageNamed:@"iconfive.png"] forState:UIControlStateNormal];
        [btn10 setImage:[UIImage imageNamed:@"iconten.png"] forState:UIControlStateNormal];
        [btn15 setImage:[UIImage imageNamed:@"iconfifteenW.png"] forState:UIControlStateNormal];
        [btn20 setImage:[UIImage imageNamed:@"icontwenty.png"] forState:UIControlStateNormal];
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfive.png"] forState:UIControlStateNormal];
    }
    
    if(sender.tag==20)
    {
        [btn5 setImage:[UIImage imageNamed:@"iconfive.png"] forState:UIControlStateNormal];
        [btn10 setImage:[UIImage imageNamed:@"iconten.png"] forState:UIControlStateNormal];
        [btn15 setImage:[UIImage imageNamed:@"iconfifteen.png"] forState:UIControlStateNormal];
        [btn20 setImage:[UIImage imageNamed:@"icontwentyW.png"] forState:UIControlStateNormal];
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfive.png"] forState:UIControlStateNormal];
    }
    
    if(sender.tag==25)
    {
        [btn5 setImage:[UIImage imageNamed:@"iconfive.png"] forState:UIControlStateNormal];
        [btn10 setImage:[UIImage imageNamed:@"iconten.png"] forState:UIControlStateNormal];
        [btn15 setImage:[UIImage imageNamed:@"iconfifteen.png"] forState:UIControlStateNormal];
        [btn20 setImage:[UIImage imageNamed:@"icontwenty.png"] forState:UIControlStateNormal];
        [btn25 setImage:[UIImage imageNamed:@"icontwentyfiveW.png"] forState:UIControlStateNormal];
    }
    
    if(sender.tag==5)
    {
        topClicks.text=[NSString stringWithFormat:@"0%i",sender.tag];
        bottomClicks.text=[NSString stringWithFormat:@"0%i",sender.tag];
    
        clicks = [NSString stringWithFormat:@"0%i",sender.tag];
    }
    else
    {
        topClicks.text=[NSString stringWithFormat:@"%i",sender.tag];
        bottomClicks.text=[NSString stringWithFormat:@"%i",sender.tag];
        
        clicks = [NSString stringWithFormat:@"%i",sender.tag];
    }
    
}

-(void)playBtnPressed
{
    NSLog(@">>> %d",[topClicks.text intValue]);
    NSLog(@">>> %d",[[[NSUserDefaults standardUserDefaults] stringForKey:@"UserClicks"] intValue]);
    
    
    if([clicks isEqualToString:@"-"] || [clicks isEqualToString:@""] || [clicks isEqualToString:@"0"])
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please select the clicks first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:@"Please select the clicks first."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;

    }
    else if([is_CustomCard isEqualToString:@"true"] && customTextView.text.length==0)
    {
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter the text for custom card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:@"Please enter the text for custom card."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        
    }
    else
    {
    
    if(card_id.length>0)
    {
        if([is_CustomCard isEqualToString:@"true"])
        {
            contentHeading = customTextView.text;
            content = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:ID  forKey:@"card_DB_ID"];
        [[NSUserDefaults standardUserDefaults] setObject:contentHeading  forKey:@"card_heading"];
        [[NSUserDefaults standardUserDefaults] setObject:content  forKey:@"card_content"];
        [[NSUserDefaults standardUserDefaults] setObject:imageUrl  forKey:@"card_url"];
        [[NSUserDefaults standardUserDefaults] setObject:topClicks.text  forKey:@"card_clicks"];
        [[NSUserDefaults standardUserDefaults] setObject:card_id  forKey:@"card_id"];
        [[NSUserDefaults standardUserDefaults] setObject:card_owner  forKey:@"card_owner"];
        [[NSUserDefaults standardUserDefaults] setObject:card_originator  forKey:@"card_originator"];
        [[NSUserDefaults standardUserDefaults] setObject:is_CustomCard  forKey:@"is_CustomCard"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
    
    //if([topClicks.text intValue]<= [[[NSUserDefaults standardUserDefaults] stringForKey:@"UserClicks"] intValue])
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"UserClicks"] intValue]>=5)
    {
        if([is_CustomCard isEqualToString:@"true"])
        {
            contentHeading = customTextView.text;
            content = @"";
        }
        [[NSUserDefaults standardUserDefaults] setObject:ID  forKey:@"card_DB_ID"];
        [[NSUserDefaults standardUserDefaults] setObject:contentHeading  forKey:@"card_heading"];
        [[NSUserDefaults standardUserDefaults] setObject:content  forKey:@"card_content"];
        [[NSUserDefaults standardUserDefaults] setObject:imageUrl  forKey:@"card_url"];
        [[NSUserDefaults standardUserDefaults] setObject:topClicks.text  forKey:@"card_clicks"];
        [[NSUserDefaults standardUserDefaults] setObject:card_id  forKey:@"card_id"];
        [[NSUserDefaults standardUserDefaults] setObject:card_owner  forKey:@"card_owner"];
        [[NSUserDefaults standardUserDefaults] setObject:card_originator  forKey:@"card_originator"];
        [[NSUserDefaults standardUserDefaults] setObject:is_CustomCard  forKey:@"is_CustomCard"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Your don't have enough clicks to play this card." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
//        [alert show];
//        alert = nil;
        
        MODropAlertView *alertView = [[MODropAlertView alloc]initDropAlertWithTitle:nil
                                                                        description:@"Your don't have enough clicks to play this card."
                                                                      okButtonTitle:@"OK"];
        alertView.delegate = nil;
        [alertView showForPresentView];
        alertView = nil;
        
    }
        
    }
        
    }
   
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
