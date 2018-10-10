

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FXBlurView.h"

#import "ViewController.h"

UIDocumentInteractionController *docInteraction;
SLComposeViewController *Socialcontroller;

BOOL imageShared;
BOOL reviewHasBeenMade;
BOOL dontShowRate;
NSInteger sharingViewsCounter;

@interface SharingScreen : UIViewController <
UIDocumentInteractionControllerDelegate,
MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet FXBlurView *backView;

// Hidden Preview Image
@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (strong, nonatomic) UIImage *imagePassed;
@property (weak, nonatomic) IBOutlet UIButton *unlockAllButton;

// Buttons
- (IBAction)cancelButt:(id)sender;

- (IBAction)instagramButt:(id)sender;
- (IBAction)cameraRollButt:(id)sender;
- (IBAction)facebookButt:(id)sender;
- (IBAction)twitterButt:(id)sender;
- (IBAction)mailButt:(id)sender;
- (IBAction)otherAppsButt:(id)sender;
- (IBAction)smsButt:(id)sender;
- (IBAction)reviewButt:(id)sender;
- (IBAction)unlockAllFunctionsButt:(id)sender;



@end
