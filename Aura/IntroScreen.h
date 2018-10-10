

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;

BOOL infoViewed;
int randomBKGimage;


// BOOLs for IAP =========
BOOL unlockAmber;
BOOL unlockAll;
BOOL unlockBorders;
BOOL unlockLightFX;
BOOL unlockWatermarks;

NSInteger introViewsCounter;


@interface IntroScreen : UIViewController <
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
YCameraViewControllerDelegate
>
{
    ViewController *mainScreen;

}
// BKG imageView (randomly changing)
@property (weak, nonatomic) IBOutlet UIImageView *introBKG;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

@property (assign, nonatomic) BOOL dontShowRatePopup;

// BUTTONS ========
- (IBAction)photoLibraryButt:(id)sender;
- (IBAction)cameraButt:(id)sender;
- (IBAction)infoButt:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *cameraOutlet;
@property (weak, nonatomic) IBOutlet UIButton *libraryOutlet;
@property (weak, nonatomic) IBOutlet UIButton *storeBUtton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeApicLabel;
@property (weak, nonatomic) IBOutlet UILabel *pickFromLibLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (assign, nonatomic) BOOL infoScreenWasShown;

@end
