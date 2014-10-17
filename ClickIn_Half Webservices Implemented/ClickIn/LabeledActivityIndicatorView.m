#import "LabeledActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

#define Size	80

@implementation LabeledActivityIndicatorView

@synthesize controller;

-(LabeledActivityIndicatorView *) initWithController:(UIViewController *)ctrl andText:(NSString *)text;
{
    
  self = [super initWithFrame:CGRectMake(0, 0, Size, Size)];
	
	if (self) {
		self.controller = ctrl;
		shown = NO;
		
		self.center = CGPointMake(self.controller.view.bounds.size.width / 2, self.controller.view.bounds.size.height / 2);
		self.clipsToBounds = YES;
//		self.backgroundColor = [UIColor colorWithWhite: 0.3 alpha: 1.0];

        self.backgroundColor = [UIColor clearColor];
		if ([self.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) self.layer setCornerRadius: 10];
		self.alpha = 1.0;
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Size, Size/2)];
    label.text = text;
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize: [UIFont smallSystemFontSize]];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
		activity.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2 + Size/5);
		
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    
    //[self addSubview: label];
    //[self addSubview: activity];
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 0; i < 24; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Click_share 2_000%i.png",i]]];
        }
        
        // Normal Animation
        UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Size, Size)];
        animationImageView.animationImages = images;
        animationImageView.animationDuration = 1;
        animationImageView.animationRepeatCount = 0;
        [animationImageView startAnimating];
        [self addSubview:animationImageView];
        
        
    
		[label release];
		[activity release];
        [animationImageView release];
	}
	
	return self;
}

-(void) show
{
	if (!shown) {
		shown = YES;
		[self.controller.view addSubview:self];
	}
}

-(void) hide
{
	if (shown) {
		shown = NO;
		[self removeFromSuperview];
	}
}

/*
 -(void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event
 {
 [self hide];
 }
 */

- (void)dealloc
{
  [controller release];
  [super dealloc];
}

@end
