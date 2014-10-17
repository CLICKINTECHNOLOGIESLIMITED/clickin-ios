//
//  PhotoController.h
//
// This class shows picture from user's gallery in full screen
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface PhotoViewController : UIViewController<UIScrollViewDelegate,FBLoginViewDelegate,FBViewControllerDelegate,MODropAlertViewDelegate>
{
    UIImageView *HoverImgView;
    UIButton *SaveToLibraryBtn;
    UIButton *SetAsDisplayPictureBtn;
    LabeledActivityIndicatorView *activity;
    NSString *StrEncoded;
    UIImage *TempDisplayPicture;
    UIScrollView *shareScrollView;
}

-(id)initWithImage:(UIImage*)imageToDisplay;
@property(nonatomic,retain) NSString *messageID;

@end
