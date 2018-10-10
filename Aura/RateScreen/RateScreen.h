

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

#import "ViewController.h"

@interface RateScreen : UIViewController <
    UINavigationControllerDelegate
>

@property (weak, nonatomic) UIImage *backImage;

@property (weak, nonatomic) IBOutlet FXBlurView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

// Buttons
- (IBAction)cancelButt:(id)sender;

- (IBAction)rateButt:(id)sender;
- (IBAction)remindButt:(id)sender;

@end
