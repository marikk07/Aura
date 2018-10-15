


#import "IntroScreen.h"
#import "ViewController.h"
#import "InfoScreen.h"
#import "RateScreen.h"

#import "IAPController.h"
#import "AdColonyHelper.h"
#import <Crashlytics/Crashlytics.h>
#import "CLImageEditor.h"

#import "Aura-Swift.h"


@interface IntroScreen ()<CLImageEditorDelegate>{
    BOOL _isOnLoadInitialized;
}

@end

@implementation IntroScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    // Set here the inspiration Images quantity
    randomBKGimage = arc4random()% 13+1;
    
    NSString *imageStr = [NSString stringWithFormat:@"bkg%d.jpg", randomBKGimage];
    _introBKG.image = [UIImage imageNamed:imageStr];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    if (_isOnLoadInitialized == NO) {
        
        _isOnLoadInitialized = YES;
        
        if (self.dontShowRatePopup != YES) {
            // Add 1 to the introViewsCounter and save it
            introViewsCounter++;
            [[NSUserDefaults standardUserDefaults] setInteger:introViewsCounter forKey:@"introViewsCounter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"introViewsCounter Count: %ld", (long)introViewsCounter);
            
            // Call the reviewButt accordingly to the times that IntroScreen has been opened
            BOOL shouldShowRateScreen = NO;
            if (introViewsCounter == 2 && !reviewHasBeenMade && !dontShowRate) {
                shouldShowRateScreen = YES;
            } else if (introViewsCounter == 3 && !reviewHasBeenMade && !dontShowRate) {
                shouldShowRateScreen = YES;
            } else if (introViewsCounter == 6 && !reviewHasBeenMade && !dontShowRate) {
                shouldShowRateScreen = YES;
            }
            
            if (shouldShowRateScreen) {
                // Show rate screen
                RateScreen *rateVC = [[RateScreen alloc]initWithNibName:@"RateScreen" bundle:nil];
                
                // Take a screenshot
                UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
                [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
                rateVC.backImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                rateVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:rateVC animated:YES completion:nil];
            }
        }
    }
    // show or not show Store
    [self updateCurrencyBalance];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoImg.clipsToBounds = YES;
    self.logoImg.layer.cornerRadius = 19.0;
    _isOnLoadInitialized = NO;
    
    // Loads the times that the SharingScreen has been opened
    introViewsCounter = [[NSUserDefaults standardUserDefaults] integerForKey:@"introViewsCounter"];
    
    /*
    // Sets FONTS ========================
    //_titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:50];
    _takeApicLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:17];
    _pickFromLibLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:17];
    _copyrightLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:15];
    */
    
    
    // Rounds the button's ===============
    _libraryOutlet.layer.cornerRadius = _libraryOutlet.bounds.size.width /2;
    _cameraOutlet.layer.cornerRadius = _cameraOutlet.bounds.size.width /2;

    // Show leadbolt interstitial
    //[self initializeEventListeners];
    //[AppTracker startSession:@"SA5Uo8nsoSPGzhfQhgMDRub4wklChERq"];
    //[AppTracker loadModuleToCache:@"inapp"];
    
    // Observe unlocking by AdColony
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObservers) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObservers) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self addObservers];
    
    // show or not show Store
    [self updateCurrencyBalance];

}


- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrencyBalance) name:kCurrencyBalanceChange object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrencyBalanceChange object:nil];
}

- (void)updateCurrencyBalance{
    if (unlockAll || (unlockAmber && unlockBorders && unlockLightFX)){
        self.storeBUtton.enabled = NO;
        self.storeLabel.text = @"Pro Activated";
    }
}

#pragma mark - BUTTONS ============



- (IBAction)storeButt:(id)sender {
    
    // test crash
    // [[Crashlytics sharedInstance] crash];
    
    // open IAP view controller without dialog
    [self showStoreViewController];
    
    /*
    [[AdColonyHelper sharedManager] showDialogWithIAPBlockBlock:^{
        [self showStoreViewController];
    }];
     */
}


- (void)showStoreViewController{
    productInt = 0;
    
    IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
    iapVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController: iapVC animated:YES completion:nil];

}

- (IBAction)instagramButt:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=auracamera"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }

}


- (IBAction)photoLibraryButt:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)presentCameraView{
    YCameraViewController *cameraController = [[YCameraViewController alloc] initWithNibName:@"YCameraViewController" bundle:nil];
    cameraController.delegate=self;
    [self presentViewController:cameraController animated:YES completion:nil];
    
}

- (IBAction)cameraButt:(id)sender {
    
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // Will get here on both iOS 7 & 8 even though camera permissions weren't required
            // until iOS 8. So for iOS 7 permission will always be granted.
            if (granted) {
                // Permission has been granted. Use dispatch_async for any UI updating
                // code because this block may be executed in a thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentCameraView];
                });
            } else {
                // Permission has been denied.
                // show message
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera" message:@"Please allow using camera for taking a picture: Open Settings -> Aura and turn on Camera" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                });
            }
        }];
    } else {
        // We are on iOS <= 6. Just do what we need to do.
        [self presentCameraView];
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:true];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion:nil];

    if(image) {
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image delegate:self];
        [self presentViewController:editor animated:YES completion:nil];
        
    }

    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
    // Go to the Main Screen
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    mainScreen = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MainScreen"];
    
   // Passing Image to Main Screen
    mainScreen.passedImage = image;

    mainScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:mainScreen animated:YES completion:nil];
    });
 */
}


- (IBAction)infoButt:(id)sender {
    UIViewController *vc = [[SubscriptionTermsViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - YCameraViewController Delegate ==========
- (void)didFinishPickingImage:(UIImage *)image{

    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if(image) {
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image delegate:self];
        [self presentViewController:editor animated:YES completion:nil];
        
    }
 

}

- (void)yCameraControllerDidCancel{
    [self dismissViewControllerAnimated:YES completion:nil];

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- CLIMAGE EDITOR DELEGATE =================

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    //_imageView.image = image;
    //[self refreshImageView];
    
    //[editor dismissViewControllerAnimated:YES completion:nil];
    [self shareImage:image editor: editor];
    
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [self presentIntro];
}


#pragma mark - ACTIONS CALLED BY THE BUTTONS  ========================

// Sets a new Image/Picture up
- (void)presentIntro{
    
    IntroScreen *introVC = [[IntroScreen alloc]initWithNibName:@"IntroScreen" bundle:nil];
    introVC.dontShowRatePopup = YES;
    introVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:introVC animated:YES completion:nil];
}


// Opens the Image Editor to edit your Picture
- (void)presentEditor: (UIImage *)image {
    if(image) {
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image delegate:self];
        [self presentViewController:editor animated:YES completion:nil];
        
    } else {
        [self presentIntro];
    }
}

// Saves the edited image (with sharing options)
- (void)shareImage:(UIImage *)image editor:(CLImageEditor *)editor{
    if(image){
        
        // Add 1 to the sharingViewCounter and save it
        sharingViewsCounter++;
        [[NSUserDefaults standardUserDefaults] setInteger:sharingViewsCounter forKey:@"sharingViewsCounter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        SharingScreen *sharingScreen = [[SharingScreen alloc]initWithNibName:@"SharingScreen" bundle:nil];
        
        // Passes the Edited Image to the SharingScreen
        sharingScreen.imagePassed = image;
        
        sharingScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [editor presentViewController:sharingScreen animated:YES completion:nil];
        
        /*
         // Calls the sharing method showing the Image Preview
         [self sharingImage];
         */
        
    } else {
        
        // Lets you choose where to pick your image/picture from
        [self presentIntro];
    }
    
    
}


@end
