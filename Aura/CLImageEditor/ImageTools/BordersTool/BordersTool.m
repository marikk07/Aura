
#import "BordersTool.h"
#import <QuartzCore/QuartzCore.h>

#import "SharingScreen.h"
#import "IntroScreen.h"
#import "IAPController.h"

#import "CLCircleView.h"
#import "AdColonyHelper.h"


static NSString* const kBordersToolBordersPathKey = @"bordersPath";

@interface _BordersView : UIView
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation BordersTool
{
    UIScrollView *_menuScroll;
    UIImage *_thumnailImage;
    
    UIButton *iapButt;
    UIImageView *iapIcon;
    int tagINT;
    NSTimer *timerForIcons;
}

+ (NSArray*)subtools {
    return nil;
}

+ (NSString*)defaultTitle {
   // return NSLocalizedStringWithDefaultValue(@"BordersTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Borders", @"");
    return false;
}

+ (BOOL)isAvailable {
    return ([UIDevice iosVersion] >= 5.0);
}




#pragma mark- BORDERS PATH ==================
+ (NSString*)defaultBordersPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/borders", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kBordersToolBordersPathKey:[self defaultBordersPath]};
}

/*
+(UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
*/


#pragma mark- INITIALIZATION ====================

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
    _thumnailImage = _originalImage;
    
  //  [self.editor fixZoomScaleWithAnimated:YES];
    
    // Timer that checks if IAP has been made
    timerForIcons = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self
                     selector:@selector(removeIcons:) userInfo:nil repeats:YES];

    
    imageContainerView = [[UIView alloc] initWithFrame: CGRectMake(0, 44, self.editor.view.frame.size.width, self.editor.view.frame.size.width)];
    imageContainerView.backgroundColor = [UIColor clearColor];
    imageContainerView.clipsToBounds = true;
    imageContainerView.backgroundColor = [UIColor whiteColor];
    [self.editor.view addSubview:imageContainerView];
    NSLog(@"imgContainer: %f - %f", imageContainerView.frame.size.width,
                                    imageContainerView.frame.size.height);

    
    self.editor.imageView.center = CGPointMake(imageContainerView.frame.size.width/2,
                                               imageContainerView.frame.size.height/2);
    self.editor.imageView.transform = CGAffineTransformScale(self.editor.imageView.transform, 0.8, 0.8);
    [imageContainerView addSubview:self.editor.imageView];
    
    self.editor.imageView.userInteractionEnabled = true;
    
    
    // Add PAN & PINCH Gesture Recogn. to the Image
    pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidPinch:)];
    panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imageDidPan:)];
    [self.editor.imageView addGestureRecognizer:pinchGest];
    [self.editor.imageView addGestureRecognizer:panGest];
    
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = true;
    [self.editor.view addSubview:_menuScroll];
  
    /*
    // WorkingView init
    _workingView.userInteractionEnabled = true;
    _workingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 320)];
    _workingView.backgroundColor = [UIColor whiteColor];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    [self.editor.view sendSubviewToBack:_workingView];
    */
    
    
    [self.editor.view bringSubviewToFront:self.editor.imageView];
    
    
    // Title Label =============
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.editor.view.frame.size.height-120, 320, 25)];
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:15];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Move & Scale";
    [self.editor.view addSubview:titleLabel];
    
    
    // Call the setup of the Borders Toolbar menu
    [self setBordersMenu];
    
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
    animations:^{
    _menuScroll.transform = CGAffineTransformIdentity;
    }];
}

- (void)cleanup
{
    [self.editor.scrollView addSubview: self.editor.imageView];
    
    [self.editor resetZoomScaleWithAnimated: true];
    
    // Remove all the Views and Gestures =======
    [_workingView removeFromSuperview];
    [imageContainerView removeFromSuperview];
    [titleLabel removeFromSuperview];
    [self.editor.imageView removeGestureRecognizer:pinchGest];
    [self.editor.imageView removeGestureRecognizer:panGest];
    
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
    animations:^{
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    } completion:^(BOOL finished) {
    [_menuScroll removeFromSuperview];
    }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage: _originalImage];
        dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(image, nil, nil);
        });
    });
}

// Gesture Recognizers =============
-(void)imageDidPinch: (UIPinchGestureRecognizer *) sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
}
- (void)imageDidPan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:self.editor.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.editor.view];

}

-(void)removeIcons: (NSTimer *)timer  {
    if (unlockBorders) {
        for (int i=105; i <= iapIcon.tag; i++) {
        [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [timerForIcons invalidate];
    }
}





#pragma mark - SET BORDERS TOOLBAR MENU =====================
- (void)setBordersMenu {
    CGFloat W = 50;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    bordersPath = self.toolInfo.optionalInfo[kBordersToolBordersPathKey];
    if(bordersPath == nil){
        bordersPath = [[self class] defaultBordersPath];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    list = [fileManager contentsOfDirectoryAtPath:bordersPath error:&error];
        
    for (NSString *pathStr in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", bordersPath, pathStr];
        
        tagINT++;
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedBordersPanel:) toolInfo:nil];
        
        // resize image in background to avoid delay
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image){
                UIImage *resizedImage = [image aspectFit:CGSizeMake(W, H)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    view.iconImage = resizedImage;
                });
            }
        });

    
        view.userInfo = @{@"filePath" : filePath};
        view.tag = tagINT;
        
        // Add a little circle on the top of the PAID items that need to be unlocked with IAP
        if (!unlockBorders && view.tag >=13) {
            iapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
            iapIcon.backgroundColor = [UIColor purpleColor];
            iapIcon.layer.cornerRadius = iapIcon.bounds.size.width /2;
            iapIcon.tag = tagINT +100;
            [view addSubview:iapIcon];
            NSLog(@"iapIcon TAG: %ld", (long)iapIcon.tag);
        }
        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}


- (void)tappedBordersPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"TAG:%ld", (long)view.tag);

    NSString *filePath = view.userInfo[@"filePath"];
    
 
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    
    if (!unlockBorders && view.tag >= 13) {
        
        // open IAP view controller without dialog
        // Set productInt for IAP product's recognition;
        productInt = 1;
        
        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
        iapVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.editor presentViewController: iapVC animated:YES completion:nil];
        
        /*
        [[AdColonyHelper sharedManager] showDialogWithIAPBlockBlock:^{
            // Set productInt for IAP product's recognition;
            productInt = 1;
            
            IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
            iapVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.editor presentViewController: iapVC animated:YES completion:nil];
        }];
         */
    }

    
    
    /*========================================================================================
     IAP MADE!
     =========================================================================================*/
    else {
    // if (filePath) {
        
        
        _BordersView *bordersView = [[_BordersView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
        
        // Puts the frame in the center of the image
        bordersView.center = CGPointMake(imageContainerView.width/2, imageContainerView.height/2);
        bordersView.frame = CGRectMake(0, 0, imageContainerView.width, imageContainerView.height);
        [imageContainerView addSubview:bordersView];
        [imageContainerView bringSubviewToFront:self.editor.imageView];
        

        /*
         [_workingView removeFromSuperview];
        
         // WorkingView containing Textures =========
         _workingView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 320)];
         _workingView.clipsToBounds = true;
         [self.editor.view addSubview:_workingView];
         
         [self.editor.view sendSubviewToBack:_workingView];
         [self.editor.view bringSubviewToFront:self.editor.imageView];

        _BordersView *bordersView = [[_BordersView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
         // Put the frame in the center of the image
        bordersView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
        bordersView.frame = CGRectMake(0,0, _workingView.width, _workingView.height);
        
        [_workingView addSubview:bordersView];
        */
    }
}


- (UIImage*)buildImage:(UIImage*)image
{
    CGRect rect = imageContainerView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    [imageContainerView drawViewHierarchyInRect:imageContainerView.bounds afterScreenUpdates: false];

  //  [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //[imageContainerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return croppedImage;
}


@end








#pragma mark - Borders VIEW IMPLEMENTATION ======================
@implementation _BordersView
{
    
    UIImageView *_borderImage;
    UIButton *_deleteButton;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}



- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, _borderImage.frame.size.width,
                                                 _borderImage.frame.size.height)];
    
    if(self){
        _borderImage = [[UIImageView alloc] initWithImage:image];
        _borderImage.center = self.center;
        
        width = imageContainerView.width;
        height = imageContainerView.height;
        
        _borderImage.frame = CGRectMake(0,0, width, height);
        _borderImage.contentMode = UIViewContentModeScaleAspectFill;
        _borderImage.clipsToBounds = true;
        
        NSLog(@"IMAGE SIZE: %f - %f", _borderImage.image.size.width,
                                      _borderImage.image.size.height);
        
        [self addSubview: _borderImage];
        
        _scale = 2;
        _arg = 0;
        
    }
    return self;
}




- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view= [super hitTest:point withEvent:event];
    if(view==self){
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _borderImage;
}


- (void)setActive:(BOOL)active
{
    _borderImage.layer.borderWidth = (active) ? 1/_scale : 0;
    _borderImage.layer.borderColor = [[UIColor clearColor] CGColor];

}


- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _borderImage.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_borderImage.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_borderImage.height + 32)) / 2;
    rct.size.width  = _borderImage.width + 32;
    rct.size.height = _borderImage.height + 32;
    self.frame = rct;
    
    _borderImage.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _borderImage.layer.borderWidth = 1/_scale;
    _borderImage.layer.cornerRadius = 3/_scale;
}



@end
