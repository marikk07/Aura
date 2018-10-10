


#import "UIImage+Utility.h"


#import "ViewController.h"
#import "CLImageEditor.h"
#import "SharingScreen.h"
#import "RemoveWatermarkScreen.h"

#import <Social/Social.h>


@interface ViewController ()
<CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>
{}

-(void)addWatermark;

@end

@implementation ViewController
@synthesize _imageView, passedImage;
@synthesize introVC, sharingScreen, removeWatermarkScreen;



- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Loads the times that the SharingScreen has been opened
    sharingViewsCounter = [[NSUserDefaults standardUserDefaults] integerForKey:@"sharingViewsCounter"];
    NSLog(@"sharingViews Count: %ld", (long)sharingViewsCounter);
    
    
    
    // Sets the FONT
    _titleLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:30];
    
    
    // RESIZES AND SETS THE IMAGE PASSED FROM INTRO SCREEN ========
    // ============================================================
    
    _imageView.image = passedImage;
    
    /*
     float actualHeight = _imageView.image.size.height;
     float actualWidth = _imageView.image.size.width;
     float imgRatio = actualWidth/actualHeight;
     float maxRatio = 640.0/1136.0;
     
     if(imgRatio!=maxRatio){
     if(imgRatio < maxRatio){
     imgRatio = 1136.0 / actualHeight;
     actualWidth = imgRatio * actualWidth;
     actualHeight = 1136.0;
     
     } else {
     
     imgRatio = 640.0 / actualWidth;
     actualHeight = imgRatio * actualHeight;
     actualWidth = 640.0;
     }
     }
     CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
     UIGraphicsBeginImageContext(rect.size);
     [_imageView.image drawInRect:rect];
     UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     _imageView.image = img;
     */
    
    
    NSLog(@"ImageSize: %f - %f", _imageView.image.size.width, _imageView.image.size.height);
    
    
    
    
    // DATA LOADS ======================
    // =================================
    
    // Loads the imageShared BOOL
    imageShared = [[NSUserDefaults standardUserDefaults] boolForKey:@"imageShared"];
    NSLog(@"imageShared: %d", imageShared);
    
    // Loads the reviewHasBeenMade BOOL
    reviewHasBeenMade = [[NSUserDefaults standardUserDefaults] boolForKey:@"reviewHasBeenMade"];
    NSLog(@"reviewHasBeenMade: %d", reviewHasBeenMade);
    // =================================
    
    
    [self refreshImageView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addWatermark];
}


#pragma mark - BUTTONS ================================
- (IBAction)savePicButt:(id)sender {
    [self savePic];
}
- (IBAction)newPicButt:(id)sender {
    [self newPic];
}
- (IBAction)editPicButt:(id)sender {
    [self editPic];
}

#pragma mark - ACTIONS CALLED BY THE BUTTONS  ========================

// Sets a new Image/Picture up
- (void)newPic {
    
    introVC = [[IntroScreen alloc]initWithNibName:@"IntroScreen" bundle:nil];
    introVC.dontShowRatePopup = YES;
    introVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:introVC animated:YES completion:nil];
}


// Opens the Image Editor to edit your Picture
- (void)editPic {
    if(_imageView.image) {
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:_imageView.image delegate:self];
        [self presentViewController:editor animated:YES completion:nil];
        
    } else {
        [self newPic];
    }
}

// Saves the edited image (with sharing options)
- (void)savePic {
    if(_imageView.image){
        
        // Add 1 to the sharingViewCounter and save it
        sharingViewsCounter++;
        [[NSUserDefaults standardUserDefaults] setInteger:sharingViewsCounter forKey:@"sharingViewsCounter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        sharingScreen = [[SharingScreen alloc]initWithNibName:@"SharingScreen" bundle:nil];
        
        // Passes the Edited Image to the SharingScreen
        sharingScreen.imagePassed = _imageView.image;
        
        sharingScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:sharingScreen animated:YES completion:nil];
        
        /*
         // Calls the sharing method showing the Image Preview
         [self sharingImage];
         */
        
    } else {
        
        // Lets you choose where to pick your image/picture from
        [self newPic];
    }
    
    
}


/*
 // =================
 // NOTE: The following methods work only on real device, not iOS Simulator, and you should have apps like Instagram, iPhoto, etc. already installed into your device!
 // =================
 -(void)sharingImage {
 
 NSLog(@"This code works only on device. Please test it on iPhone/iPad!");
 
 // makes an NSURL file to the processed Image that needs to be saved
 NSURL *fileURL;
 docInteraction.delegate = self;
 
 //Saves the Image to default device directory
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *documentsDirectory = [paths objectAtIndex:0];
 NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
 UIImage *image = _imageView.image;
 
 NSData *imageData = UIImagePNGRepresentation(image);
 [imageData writeToFile:savedImagePath atomically:NO];
 
 //Loads the Image
 NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
 
 // Creates the URL path to the Image
 fileURL = [[NSURL alloc] initFileURLWithPath:getImagePath];
 docInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
 
 // Opens the Document Interaction controller for Other Apps Sharing
 CGRect rect = CGRectZero;
 [docInteraction presentOpenInMenuFromRect:rect inView:self.view animated:YES];
 
 
 
 // Opens the Document Interaction controller for Sharing options =====================
 if (fileURL) {
 // Initializes Document Interaction Controller
 docInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
 // Configures Document Interaction Controller
 [docInteraction setDelegate:self];
 // Shows a Full Screen Preview of the edited Image
 [docInteraction presentPreviewAnimated:YES];
 }
 
 }
 
 // DocumentInteractionController delegates ==========================
 - (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
 return self;
 }
 
 - (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
 // Opens an AlertView as sharing result when the Document Interaction Controller gets dismissed
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Have fun with Aura!" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [alert show];
 
 }
 */



#pragma mark- CLIMAGE EDITOR DELEGATE =================

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    _imageView.image = image;
    [self refreshImageView];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    [self refreshImageView];
}



#pragma mark - YCameraViewController Delegate ==========
- (void)didFinishPickingImage:(UIImage *)image{
    
    _imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)yCameraControllerDidCancel{
    [_imageView setImage:[UIImage imageNamed:@"default.jpg"]];
}




#pragma mark- ScrollView settings ==============

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView.superview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.superview.frame.size.width;
    CGFloat H = _imageView.superview.frame.size.height;
    
    CGRect rct = _imageView.superview.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.superview.frame = rct;
}



// Refreshes the ImageView ===========================
- (void)refreshImageView  {
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimate:NO];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self addWatermark];
    //    });
}

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
    CGFloat W = ratio * size.width;
    CGFloat H = ratio * size.height;
    _imageView.frame = CGRectMake(0, 0, W, H);
    _imageView.superview.bounds = _imageView.bounds;
    
}

- (void)resetZoomScaleWithAnimate:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
    [self scrollViewDidZoom:_scrollView];
}

-(void)addWatermark {
    // Remove watermarks button
    self.watermarkView.hidden = YES;

    if (unlockWatermarks) {
        
    } else { // Add Watermarks button if not purchased
        // Set first label visible and second rotated
        self.watermarkLabel.transform = CGAffineTransformIdentity;
        self.watermarkLabel.hidden = NO;
        self.watermarkLabel2.hidden = YES;
        self.watermarkLabel2.transform = CGAffineTransformMakeScale(0.0001f, 1.0f);
        [UIView animateWithDuration:0.5 delay:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
            // Animate first label hiding
            self.watermarkLabel.transform = CGAffineTransformMakeScale(0.0001f, 1.0f);
        } completion:^(BOOL finished){
            if (finished) {
                self.watermarkLabel.hidden = YES;
                self.watermarkLabel2.hidden = NO;
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    // Animate second label appearing
                    self.watermarkLabel2.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.5 delay:3.0 options:UIViewAnimationOptionCurveLinear animations:^{
                            // Animate second label hiding
                            self.watermarkLabel2.transform = CGAffineTransformMakeScale(0.0001f, 1.0f);
                        } completion:^(BOOL finished){
                            if (finished) {
                                self.watermarkLabel.hidden = NO;
                                self.watermarkLabel2.hidden = YES;
                                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                    // Animate first label appearing
                                    self.watermarkLabel.transform = CGAffineTransformIdentity;
                                } completion:^(BOOL finished){
                                    if (finished) {
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            [self addWatermark];
                                        });
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }
        }];
    }
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)watermarkButt:(id)sender {
    removeWatermarkScreen = [[RemoveWatermarkScreen alloc]initWithNibName:@"RemoveWatermarkScreen" bundle:nil];
    
    // Passes the Edited Image to the SharingScreen
    removeWatermarkScreen.imagePassed = _imageView.image;
    removeWatermarkScreen.iAPIndex = 4; // Watermark
    
    removeWatermarkScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:removeWatermarkScreen animated:YES completion:nil];
    
    
}
@end
