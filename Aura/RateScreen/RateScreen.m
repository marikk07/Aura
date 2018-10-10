


#import "RateScreen.h"

@interface RateScreen ()
{
    BOOL _isBlurGenerated;
}

@end

@implementation RateScreen

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

    self.rateButton.clipsToBounds = YES;
    self.rateButton.layer.cornerRadius = 27.0;

    self.remindButton.clipsToBounds = YES;
    self.remindButton.layer.cornerRadius = 27.0;
    
    self.noButton.clipsToBounds = YES;
    self.noButton.layer.cornerRadius = 27.0;
    
    //configure blur view
    self.backView.dynamic = NO;
    self.backView.tintColor = [UIColor blackColor];
//    self.backView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
    self.backView.contentMode = UIViewContentModeBottom;

    self.backgroundImageView.image = self.backImage;
}

-(void)viewDidLayoutSubviews {
    if (!_isBlurGenerated) {
        //take snapshot, then move off screen once complete
        [self.backView updateAsynchronously:YES completion:^{
            _isBlurGenerated = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CANCEL BUTTON ============================
- (IBAction)cancelButt:(id)sender {

    dontShowRate = NO; // Show rate popup even if user tapped on "No, thanks" button (implemented due to Customer letter)
    [[NSUserDefaults standardUserDefaults] setBool:dontShowRate forKey:@"dontShowRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action buttons
- (IBAction)rateButt:(id)sender {

    // if the user agrees to rate…
    if (!reviewHasBeenMade) {
        reviewHasBeenMade = YES;
        [[NSUserDefaults standardUserDefaults] setBool:reviewHasBeenMade forKey:@"reviewHasBeenMade"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Creates the URL for reviewing the App, replace "####" with your app ID on iTunes Store.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/aura-camera-photo-editor-filters/id881057428?ls=1&mt=8"]];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)remindButt:(id)sender {

    dontShowRate = NO;
    [[NSUserDefaults standardUserDefaults] setBool:dontShowRate forKey:@"dontShowRate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Business Methods
@end
