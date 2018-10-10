

/*
// Ad banners imports
#import "GADBannerView.h"
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>
*/


#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "YCameraViewController.h"
#import "IntroScreen.h"
#import "SharingScreen.h"
#import "RemoveWatermarkScreen.h"

@class IntroScreen, SharingScreen, RemoveWatermarkScreen;

UIDocumentInteractionController *docInteraction;
SLComposeViewController *Socialcontroller;

UIImage *croppedImageWithoutOrientation;


@interface ViewController : UIViewController
<YCameraViewControllerDelegate,
UIPopoverControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITabBarDelegate,
//UIActionSheetDelegate,
UIScrollViewDelegate,
UIDocumentInteractionControllerDelegate >
{

}
/*
//Ad banners properties
@property (strong, nonatomic) ADBannerView *iAdBannerView;
@property (strong, nonatomic) GADBannerView *gAdBannerView;
*/

@property (strong, nonatomic)  IntroScreen *introVC;
@property (strong, nonatomic)  SharingScreen *sharingScreen;
@property (strong, nonatomic)  RemoveWatermarkScreen *removeWatermarkScreen;


// Views ==============
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *_imageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) UIImage *passedImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *watermarkView;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel2;
- (IBAction)watermarkButt:(id)sender;

// Buttons ===============
- (IBAction)savePicButt:(id)sender;
- (IBAction)newPicButt:(id)sender;
- (IBAction)editPicButt:(id)sender;



@end
