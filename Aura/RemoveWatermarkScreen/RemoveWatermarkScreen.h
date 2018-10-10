

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

#import "ViewController.h"

@interface RemoveWatermarkScreen : UIViewController <
    UINavigationControllerDelegate
>

@property (nonatomic, assign) int iAPIndex;
@property (weak, nonatomic) IBOutlet UIView *actView;
@property (weak, nonatomic) IBOutlet FXBlurView *backView;
@property (weak, nonatomic) IBOutlet UILabel *screenCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenMessageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) UIImage *imagePassed;
@property (weak, nonatomic) IBOutlet UIButton *removeWatermarkButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockAllFeaturesButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockBordersButton;

// Buttons
- (IBAction)cancelButt:(id)sender;

- (IBAction)removeWatermarkButt:(id)sender;
- (IBAction)enableAllFeaturesButt:(id)sender;

@end
