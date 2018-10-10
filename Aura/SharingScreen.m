


#import "SharingScreen.h"
#import <Social/Social.h>
//#import "IAPController.h"
#import "RateScreen.h"
#import "RemoveWatermarkScreen.h"
#import "IAPController.h"
#import "AdColonyHelper.h"

@interface SharingScreen ()
{
    BOOL _isBlurAdded;
    BOOL _isOnLoadInitialized;
}

-(void)addWatermartToPassedImage;
-(void)showRatePopup:(void (^)(UIViewController *rateVC))completion;

@end

@implementation SharingScreen
@synthesize imagePassed;


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
    
    _isBlurAdded = NO;
    _isOnLoadInitialized = NO;
    
    self.unlockAllButton.clipsToBounds = YES;
    self.unlockAllButton.layer.cornerRadius = 22.0;
    if (unlockAll || (unlockAmber && unlockBorders && unlockLightFX)){
        self.unlockAllButton.hidden = YES;
    }
    
    
    self.backView.layer.masksToBounds = NO;
//    self.backView.layer.shadowOffset = CGSizeMake(-15, 20);
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowRadius = 20;
    self.backView.layer.shadowOpacity = 1.0;
    self.backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.backView.bounds].CGPath;
    
    //configure blur view
    self.backView.dynamic = NO;
    self.backView.tintColor = [UIColor blackColor];
//    self.backView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
    self.backView.contentMode = UIViewContentModeBottom;
    
    // Gets the edited image from previous ViewController
    //[self addWatermartToPassedImage];
    _previewImage.image = imagePassed;
    
    // Loads the imageShared BOOL
    imageShared = [[NSUserDefaults standardUserDefaults] boolForKey:@"imageShared"];
    NSLog(@"imageShared: %d", imageShared);
    
    // Loads the reviewHasBeenMade BOOL
    reviewHasBeenMade = [[NSUserDefaults standardUserDefaults] boolForKey:@"reviewHasBeenMade"];
    NSLog(@"reviewHasBeenMade: %d", reviewHasBeenMade);
    
    // Loads the dontShowRate BOOL
    dontShowRate = [[NSUserDefaults standardUserDefaults] boolForKey:@"dontShowRate"];
    NSLog(@"dontShowRate: %d", dontShowRate);
    
    // Observe unlocking by AdColony
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObservers) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObservers) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self addObservers];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrencyBalance) name:kCurrencyBalanceChange object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrencyBalanceChange object:nil];
}

- (void)updateCurrencyBalance{
    /*
    if ([[AdColonyHelper sharedManager] isUnlocked]){
        self.unlockAllButton.hidden = YES;
    }
    else{
        self.unlockAllButton.hidden = NO;
    }
     */
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    if (_isOnLoadInitialized == NO) {
        
        _isOnLoadInitialized = YES;
        
        // Call the reviewButt accordingly to the times that SharingScreen has been opened
        BOOL shouldShowRateScreen = NO;
        if (sharingViewsCounter == 1 && !reviewHasBeenMade && !dontShowRate) {
            shouldShowRateScreen = YES;
        } else if (sharingViewsCounter == 2 && !reviewHasBeenMade && !dontShowRate) {
            shouldShowRateScreen = YES;
        } else if (sharingViewsCounter == 5 && !reviewHasBeenMade && !dontShowRate) {
            shouldShowRateScreen = YES;
        }

        if (shouldShowRateScreen) {
            // Show rate screen
            [self showRatePopup:^(UIViewController *rateVC) {
                // don't show Remove WaterMark View
                /*
                // Show iAP ad screen
                RemoveWatermarkScreen *vc = [[RemoveWatermarkScreen alloc]initWithNibName:@"RemoveWatermarkScreen" bundle:nil];
                
                vc.imagePassed = self.imagePassed;
                
                // Generate a random alert and set its image and message ===================
                //    randomAlertInt = arc4random()% 3+1;
                vc.iAPIndex = arc4random()% 4+1;
                NSLog(@"rndmAlert: %i", vc.iAPIndex);
                
                vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [rateVC presentViewController:vc animated:YES completion:nil];
                 */
            }];
        } else {
            // don't show Remove WaterMark View
            /*
            // Show iAP ad screen
            RemoveWatermarkScreen *vc = [[RemoveWatermarkScreen alloc]initWithNibName:@"RemoveWatermarkScreen" bundle:nil];
            
            vc.imagePassed = self.imagePassed;
            
            // Generate a random alert and set its image and message ===================
            //    randomAlertInt = arc4random()% 3+1;
            vc.iAPIndex = arc4random()% 4+1;
            NSLog(@"rndmAlert: %i", vc.iAPIndex);
            
            vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:vc animated:YES completion:nil];
             */
        }
    }
    if (unlockAll || (unlockAmber && unlockBorders && unlockLightFX)){
        self.unlockAllButton.hidden = YES;
    }
}

-(void)viewDidLayoutSubviews {
    if (!_isBlurAdded) {
        _isBlurAdded = YES;
        
        //take snapshot, then move off screen once complete
        [self.backView updateAsynchronously:YES completion:^{
            //        self.blurView.frame = CGRectMake(0, 568, 320, 0);
        }];
    }
}

-(void)addWatermartToPassedImage {
    
    if (!unlockWatermarks) { // Add Watermarks button if not purchased

        // Add Watermark
        UIImage *watermarkImage = [UIImage imageNamed:@"Watermark.png"];
        
        CGFloat maxWidth = imagePassed.size.width * 0.3;
        CGFloat maxHeight = imagePassed.size.height * 0.3;
        CGFloat xScale = maxWidth / watermarkImage.size.width;
        CGFloat yScale = maxHeight / watermarkImage.size.height;
        CGFloat scale = MIN(xScale, yScale);
        CGFloat wmWidth = roundf(watermarkImage.size.width * scale);
        CGFloat wmHeight = roundf(watermarkImage.size.height * scale);
        
        UIGraphicsBeginImageContext(imagePassed.size);
        [imagePassed drawInRect:CGRectMake(0, 0, imagePassed.size.width, imagePassed.size.height)];
        [watermarkImage drawInRect:CGRectMake(imagePassed.size.width - wmWidth, imagePassed.size.height - wmHeight, wmWidth, wmHeight)];
        imagePassed = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

//#pragma mark - DISMISS ALERTS VIEW BUTTON ============================
//- (IBAction)dismissAlertsViewButt:(id)sender {
//    [self hideAlerts];
//}
//
//-(void)showAlerts {
//    self.alertsViewTopConstraint.constant = 0;
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
////        CGRect frame = _alertsView.frame;
////        frame.origin.y = 0;
////        _alertsView.frame = frame;
//        [self.alertsView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
//}
//
//-(void)hideAlerts {
//    self.alertsViewTopConstraint.constant = self.view.bounds.size.height;
//    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
////        CGRect frame = _alertsView.frame;
////        frame.origin.y = 800;
////        _alertsView.frame = frame;
//        [self.alertsView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//    }];
//}
//

#pragma mark - CANCEL BUTTON ============================
- (IBAction)cancelButt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - CAMERA ROLL SHARING ========================
- (IBAction)cameraRollButt:(id)sender {
    UIImageWriteToSavedPhotosAlbum(imagePassed, nil, nil, nil);
    
    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Image Saved!"
    message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [myAlert show];
}



#pragma mark - FACEBOOK SHARING ========================
- (IBAction)facebookButt:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        Socialcontroller = [SLComposeViewController
                            composeViewControllerForServiceType:SLServiceTypeFacebook];
        [Socialcontroller setInitialText:@"Picture edited with Blink #auraapp"];
        [Socialcontroller addImage: imagePassed];
        [self presentViewController:Socialcontroller animated:YES completion:nil];
        
    } else {
        
        NSString *message = @"Please go to Settings and add your Facebook account to this device!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
                
            case SLComposeViewControllerResultCancelled:
                output = @"Sharing Cancelled!";
                break;
                
            case SLComposeViewControllerResultDone:
                output = @"You Image is on Facebook!";
                
                // Saves the imageShared BOOL and implements a new feature ===========
                if (imageShared == NO) {
                    imageShared = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:imageShared forKey:@"imageShared"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self implementNewFeature];
                }
                break;
                
            default: break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
        /*
        // ONLY FOR TEST ON SIMULATOR, do not uncomment this code! ===========================
        if (imageShared == NO) {
            imageShared = YES;
            [[NSUserDefaults standardUserDefaults] setBool:imageShared forKey:@"imageShared"];
            [self implementNewFeature];
        }
        //=====================================
        */
        
    }];
}



#pragma mark - TWITTER SHARING ========================
- (IBAction)twitterButt:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        Socialcontroller = [SLComposeViewController
                            composeViewControllerForServiceType:SLServiceTypeTwitter];
        [Socialcontroller setInitialText:@"My great edited pic!"];
        [Socialcontroller addImage: imagePassed];
        [self presentViewController:Socialcontroller animated:YES completion:nil];
        
    } else {
        
        NSString *message = @"Please go to Settings and add your Twitter account to this device!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    [Socialcontroller setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
                
            case SLComposeViewControllerResultCancelled:
                output = @"Sharing Cancelled!";
                break;
                
            case SLComposeViewControllerResultDone:
                output = @"You Image is on Twitter!";
                break;
                
            default: break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }];
}



#pragma mark - EMAIL SHARING ==============================
- (IBAction)mailButt:(id)sender {
    NSString *emailTitle = @"My great edited Picture!";
    NSString *messageBody = @"Hey, look what I've done with Blink!";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail]) {
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    
    NSData *imageData = UIImagePNGRepresentation(imagePassed);
    [mc addAttachmentData:imageData  mimeType:@"image/png" fileName:@"myImage.png"];
    
    // Presents Email View Controller
    [self presentViewController:mc animated:YES completion:NULL];
  
    } else {
        NSLog(@"Device not configured to send mail.");
    }

}

// Email results ================
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)results error:(NSError *)error
{
    switch (results) {
        case MFMailComposeResultCancelled: {
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Cancelled!"
            message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSaved:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Saved!"
            message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultSent:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email Sent!"
            message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
        case MFMailComposeResultFailed:{
            UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Email error, try again!"
                message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
            break;
            
            
        default: break;
    }
    // Dismiss the Email View Controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}




#pragma mark - INSTAGRAM SHARING =====================
- (IBAction)instagramButt:(id)sender {
    /* =================
     NOTE: The following methods work only on real device, not iOS Simulator, and you should have Instagram already installed into your device!
     ================= */
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        docInteraction.delegate = self;
        
        //Saves the edited Image to directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
        UIImage *image = imagePassed;
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        //Loads the edited Image
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
        UIImage *tempImage = [UIImage imageWithContentsOfFile:getImagePath];
        
        //Hooks the edited Image with Instagram
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Image.igo"];
        [UIImageJPEGRepresentation(tempImage, 1.0) writeToFile:jpgPath atomically:YES];
        
        // Prepares the DocumentInteraction with the .igo image for Instagram
        NSURL *instagramImageURL = [[NSURL alloc] initFileURLWithPath:jpgPath];
        docInteraction = [UIDocumentInteractionController interactionControllerWithURL:instagramImageURL];
        [docInteraction setUTI:@"com.instagram.exclusivegram"];
      
        // Opens the DocumentInteraction Menu
        [docInteraction presentOpenInMenuFromRect:rect inView:self.view animated:YES];
        
    } else {
    // Opens an AlertView as sharing result when the Document Interaction Controller gets dismissed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Instagram not found" message:@"Please install Instagram on your device!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"No Instagram Found");
    }
}



#pragma mark - MMS SHARING =====================
- (IBAction)smsButt:(id)sender {
    MFMessageComposeViewController* composer = [[MFMessageComposeViewController alloc] init];
    composer.messageComposeDelegate = self;
    [composer setSubject:@"My great edited picture!"];
    
    // These checks basically make sure it's an MMS capable device with iOS7
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments])
    {
        NSData* attachment = UIImageJPEGRepresentation(imagePassed, 1.0);
        
        NSString* uti = (NSString*)kUTTypeMessage;
        [composer addAttachmentData:attachment typeIdentifier:uti filename:@"savedImage.jpg"];
    } else {
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Message"
        message:@"Your device doesn't support MMS Message" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [myAlert show];
    }
    
    [self presentViewController:composer animated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - REVIEW APP =====================
- (IBAction)reviewButt:(id)sender {
//    if (!reviewHasBeenMade) {
//
//    // Ask the Users if they would like to rate the app Yes or No.
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Review App"
//    message:@"If you enjoy Blink, please take a moment to rate it. \n Your 5★ Review will unlock Loomy Filters!"
//    delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Sure!", nil];
//    [alert show];
//    
//    } else {
//        // Ask the Users if they would like to rate the app Yes or No.
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Review App"
//        message:@"You've already reviewed Blink on the App Store!"
//        delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
    
    [self showRatePopup:nil];
}

-(void)showRatePopup:(void (^)(UIViewController *rateVC))completion {
    RateScreen *rateVC = [[RateScreen alloc]initWithNibName:@"RateScreen" bundle:nil];
    
    // Take a screenshot
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    rateVC.backImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    rateVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:rateVC animated:YES completion:^{
        if (completion) {
            completion(rateVC);
        }
    }];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex==1)
//    {
//        // if the user agrees to rate…
//        if (!reviewHasBeenMade) {
//            reviewHasBeenMade = YES;
//            [[NSUserDefaults standardUserDefaults] setBool:reviewHasBeenMade forKey:@"reviewHasBeenMade"];
//            
//        // Creates the URL for reviewing the App, replace "####" with your app ID on iTunes Store.
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=933002558"]];
//        }
//        
//    }
//}






#pragma mark - OTHER APPS SHARING =====================
- (IBAction)otherAppsButt:(id)sender {
/* =================
 NOTE: The following methods work only on real device, not iOS Simulator, and you should have apps like iPhoto, Photoshop, Adobe Reader, etc. already installed into your device!
 ================= */
    
        NSLog(@"This code works only on device. Please test it on iPhone/iPad!");
    
        CGRect rect = CGRectMake(0 ,0 , 0, 0);

        docInteraction.delegate = self;
    
        //Saves the Image to default device directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
        UIImage *image = imagePassed;
        
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        //Loads the Image
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
        
        // Creates the URL path to the Image
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:getImagePath];
        docInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];

      // Opens the Document Interaction controller for Sharing options =====================
       [docInteraction presentOpenInMenuFromRect:rect inView: self.view animated: YES ];

}

-(void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
// Opens an AlertView as sharing result when the Document Interaction Controller gets dismissed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have fun with Blink!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}




#pragma mark - IMPLEMENT A NEW FEATURE AFTER SHARING AN IMAGE ON FACEBOOK ===================
-(void)implementNewFeature {
    if (imageShared) {
        
        NSLog(@"imageShared: %d", imageShared);
    }
}

#pragma mark - ADD NEW FONTS AFTER REVIEWING THE APP ON iTUNES STORE ===================
-(void)addNewFonts {
    if (reviewHasBeenMade) {
        
        NSLog(@"reviewHasBeenMade: %d", reviewHasBeenMade);
    }
}

#pragma mark - Unlock all functions
- (IBAction)unlockAllFunctionsButt:(id)sender{
    // open IAP view controller without dialog
    productInt = 0;
    IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
    [self presentViewController: iapVC animated:true completion:nil];
    
    /*
    [[AdColonyHelper sharedManager] showDialogWithIAPBlockBlock:^{
        productInt = 0;
        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
        [self presentViewController: iapVC animated:true completion:nil];
    }];
    */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
