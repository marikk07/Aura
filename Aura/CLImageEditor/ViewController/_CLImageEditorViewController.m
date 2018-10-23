

#import "_CLImageEditorViewController.h"
#import "CLImageToolBase.h"

#import "SharingScreen.h"
#import "IntroScreen.h"
#import "IAPController.h"
#import "Parse/Parse.h"
#import "AdColonyHelper.h"

#pragma mark- _CLImageEditorViewController

@interface _CLImageEditorViewController()
<
CLImageToolProtocol
>
@property (nonatomic, strong) CLImageToolBase *currentTool;
@property (nonatomic, strong, readwrite) CLImageToolInfo *toolInfo;
@property (nonatomic, strong) UIImageView *targetImageView;

-(void)addWatermark;

@end


@implementation _CLImageEditorViewController
{
    UIImage *_originalImage;
    UIView *_bgView;
}
@synthesize toolInfo = _toolInfo;
@synthesize removeWatermarkScreen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [self initWithNibName:@"_CLImageEditorViewController" bundle:nil];
    if (self){
        _toolInfo = [CLImageToolInfo toolInfoForToolClass:[self class]];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    return [self initWithImage:image delegate:nil];
}

- (id)initWithImage:(UIImage*)image delegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        _originalImage = [image deepCopy];
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithDelegate:(id<CLImageEditorDelegate>)delegate
{
    self = [self init];
    if (self){
        self.delegate = delegate;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.toolInfo.title;
     [self resetImageViewFrame];
    NSLog(@"1st resetImgFrame");
    
    self.view.frame = [UIScreen mainScreen].bounds;
    NSLog(@"screeSize: %f - %f", self.view.frame.size.width, self.view.frame.size.height);

    
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = true;
    }
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    }
    
    if(self.navigationController!=nil){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pushedFinishBtn:)];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        _navigationBar.hidden = YES;
        [_navigationBar popNavigationItemAnimated:NO];
        
    } else {
        _navigationBar.topItem.title = self.title;
    }
    
    [self setMenuView];
    
   
    if(_imageView == nil){
        _imageView = [UIImageView new];
    [_scrollView addSubview:_imageView];
    }
    
    
    [self resetZoomScaleWithAnimated:true];
    [self resetImageViewFrame];
    
    if(self.targetImageView){
        [self expropriateImageView];
        NSLog(@"targetImGView");
        
    } else {
        // [self resetImageViewFrame];
        [self refreshImageView];
        NSLog(@"imageExists");
    }
    
    
    // Sets the Title's font and color
    _navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          [UIFont fontWithName:@"AvenirNext" size:30], NSFontAttributeName,nil];
    [self addWatermark];
    
    
//    // Init iAd Interstitial
//    requestingAd = false;
//    [self showFullScreenAd];
    
}



#pragma mark- VIEW TRANSITION =========================

- (void)copyImageViewInfo:(UIImageView*)fromView toView:(UIImageView*)toView
{
    CGAffineTransform transform = fromView.transform;
    fromView.transform = CGAffineTransformIdentity;
    
    toView.transform = CGAffineTransformIdentity;
    toView.frame = [toView.superview convertRect:fromView.frame fromView:fromView.superview];
    toView.transform = transform;
    toView.image = fromView.image;
    toView.contentMode = fromView.contentMode;
    toView.clipsToBounds = fromView.clipsToBounds;
    
    fromView.transform = transform;
}


- (void)expropriateImageView
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:self.targetImageView toView:animateView];
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_bgView atIndex:0];
    
    _bgView.backgroundColor = self.view.backgroundColor;
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0];
    
    self.targetImageView.hidden = YES;
    _imageView.hidden = YES;
    _bgView.alpha = 0;
    _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
    animateView.transform = CGAffineTransformIdentity;
                         
    CGFloat dy = ([UIDevice iosVersion]<7) ? [UIApplication sharedApplication].statusBarFrame.size.height : 0;
                         
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
            if(size.width>0 && size.height>0){
            CGFloat ratio = MIN(_scrollView.width / size.width, _scrollView.height / size.height);
                             
            CGFloat W = ratio * size.width;
            CGFloat H = ratio * size.height;
            animateView.frame = CGRectMake((_scrollView.width-W)/2 + _scrollView.left, (_scrollView.height-H)/2 + _scrollView.top + dy, W, H);
            }
                         
                _bgView.alpha = 1;
                _navigationBar.transform = CGAffineTransformIdentity;
                _menuView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
            self.targetImageView.hidden = NO;
            _imageView.hidden = NO;
            [animateView removeFromSuperview];

    }];
    
}

- (void)restoreImageView:(BOOL)canceled
{
    if(!canceled){
        self.targetImageView.image = _imageView.image;
    }
    self.targetImageView.hidden = YES;
    
    id<CLImageEditorTransitionDelegate> delegate = [self transitionDelegate];
    if([delegate respondsToSelector:@selector(imageEditor:willDismissWithImageView:canceled:)]){
        [delegate imageEditor:self willDismissWithImageView:self.targetImageView canceled:canceled];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIImageView *animateView = [UIImageView new];
    [window addSubview:animateView];
    [self copyImageViewInfo:_imageView toView:animateView];
    
    _menuView.frame = [window convertRect:_menuView.frame fromView:_menuView.superview];
    _navigationBar.frame = [window convertRect:_navigationBar.frame fromView:_navigationBar.superview];
    
    [window addSubview:_menuView];
    [window addSubview:_navigationBar];
    
    self.view.userInteractionEnabled = NO;
    _menuView.userInteractionEnabled = NO;
    _navigationBar.userInteractionEnabled = NO;
    _imageView.hidden = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _bgView.alpha = 0;
                         _menuView.alpha = 0;
                         _navigationBar.alpha = 0;
                         
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         
                         [self copyImageViewInfo:self.targetImageView toView:animateView];
                     }
                     completion:^(BOOL finished) {
                         [animateView removeFromSuperview];
                         [_menuView removeFromSuperview];
                         [_navigationBar removeFromSuperview];
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         
                         _imageView.hidden = NO;
                         self.targetImageView.hidden = NO;
                         
                         if([delegate respondsToSelector:@selector(imageEditor:didDismissWithImageView:canceled:)]){
                             [delegate imageEditor:self didDismissWithImageView:self.targetImageView canceled:canceled];


                         }
                     }
     ];
}


#pragma mark - PROPERTIES ===============================

- (id<CLImageEditorTransitionDelegate>)transitionDelegate
{
    if([self.delegate conformsToProtocol:@protocol(CLImageEditorTransitionDelegate)]){
        return (id<CLImageEditorTransitionDelegate>)self.delegate;
    }
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.toolInfo.title = title;
}

#pragma mark- ImageTool setting ==================

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (CGFloat)defaultDockedNumber
{
    return 0;
}

+ (NSString*)defaultTitle
{
    return @"";
    /*
    return NSLocalizedStringWithDefaultValue(@"CLImageEditor_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Edit", @"");
*/
}

    
+ (BOOL)isAvailable
{
    return YES;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[CLImageToolBase class]];
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark - SET MENU VIEW ====================================

- (void)setMenuView
{
    CGFloat x = 0;
    CGFloat W = 50;
    CGFloat H = _menuView.height;
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available){
            continue;
        }
        
    //CLToolbarMenuItem *view
    CLtoolbar = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedMenuView:) toolInfo:info];
        
        /*===========*/
        tagInt++;
        CLtoolbar.tag = tagInt;
        /*==============*/

        [_menuView addSubview:CLtoolbar];
        x += W;
    }
    _menuView.contentSize = CGSizeMake(MAX(x, _menuView.frame.size.width+1), 0);
    
}

- (void)resetImageViewFrame  {
    NSLog(@"RESET IMAGEVIEW FRAME");
    
    
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    NSLog(@"size: %f - %f", size.width, size.height);
    
    if(size.width > 0 && size.height > 0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width,
                            _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width  * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake((_scrollView.width-W)/2, (_scrollView.height-H)/2, W, H);
        _watermarkView.frame = CGRectMake(_imageView.frame.origin.x + _imageView.frame.size.width - _watermarkView.frame.size.width - 3,
                                          _imageView.frame.origin.y + _imageView.frame.size.height - _watermarkView.frame.size.height - 6,
                                          _watermarkView.frame.size.width,
                                          _watermarkView.frame.size.height);
        [self.scrollView bringSubviewToFront:_watermarkView];
     }
    
    _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin );
    
    NSLog(@"ImageVIEW: %f -- %f", _imageView.frame.size.width, _imageView.frame.size.height);
    NSLog(@"UIImage: %f -- %f", _imageView.image.size.width, _imageView.image.size.height);
    NSLog(@"scrollView: %f - %f", _scrollView.frame.size.width, _scrollView.frame.size.height);
}


-(void)resetImageAfterBordes:(BOOL)animated {
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.95 * minZoomScale;
    _scrollView.minimumZoomScale = 0.95 * minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)fixZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.95 * minZoomScale;
    _scrollView.minimumZoomScale = 0.95 * minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}


- (void)resetZoomScaleWithAnimated:(BOOL)animated {
    NSLog(@"resetZoomScaleWithAnimated");
    _scrollView.zoomScale = 1;
   // [self resetImageViewFrame];
    
    /*
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
    */
}



- (void)refreshImageView {
    _imageView.image = _originalImage;
    
      [self resetImageViewFrame];
  //  [self resetZoomScaleWithAnimated:YES];

}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark- Tool actions =============

- (void)setCurrentTool:(CLImageToolBase *)currentTool
{
    if(currentTool != _currentTool){
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
        [self swapToolBarWithEditting:(_currentTool!=nil)];
    }
}


#pragma mark- Menu actions =====================

- (void)swapMenuViewWithEditting:(BOOL)editting
{
    [UIView animateWithDuration:kCLImageToolAnimationDuration animations:^{
    if(editting){
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height - _menuView.top);
    
    }else{
    _menuView.transform = CGAffineTransformIdentity;
    }
    }];
}

- (void)swapNavigationBarWithEditting:(BOOL)editting
{
    if(self.navigationController==nil){
        return;
    }
    
    [self.navigationController setNavigationBarHidden:editting animated:YES];
    
    if(editting){

        _navigationBar.hidden = NO;
        _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
        _navigationBar.transform = CGAffineTransformIdentity;
        }];
        
    } else {
        
        [UIView animateWithDuration:kCLImageToolAnimationDuration
                         animations:^{
                             _navigationBar.transform = CGAffineTransformMakeTranslation(0, -_navigationBar.height);
                         }
                         completion:^(BOOL finished) {
                             _navigationBar.hidden = YES;
                             _navigationBar.transform = CGAffineTransformIdentity;
                         }
         ];
    }
}

- (void)swapToolBarWithEditting:(BOOL)editting
{
    [self swapMenuViewWithEditting:editting];
    [self swapNavigationBarWithEditting:editting];
    
    if(self.currentTool){
        
        UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@""];
        
        // Sets the Title's font and color
        _navigationBar.titleTextAttributes =
        [NSDictionary dictionaryWithObjectsAndKeys:
        [UIColor whiteColor], NSForegroundColorAttributeName,
        [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:30], NSFontAttributeName,nil];
        
        
        //UINavigationItem *item  = [[UINavigationItem alloc] initWithTitle:self.currentTool.toolInfo.title];
        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_OKBtnTitle", nil, [CLImageEditorTheme bundle], @"OK", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedDoneBtn:)];
        
        item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringWithDefaultValue(@"CLImageEditor_BackBtnTitle", nil, [CLImageEditorTheme bundle], @"Back", @"") style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
        
        // Sets the button bar item's Images and Tint Color
        item.rightBarButtonItem.image = [UIImage imageNamed:@"doneButt"];
        item.leftBarButtonItem.image = [UIImage imageNamed:@"cancelButt"];
        item.leftBarButtonItem.tintColor = [UIColor whiteColor];
        item.rightBarButtonItem.tintColor = [UIColor whiteColor];;

        [_navigationBar pushNavigationItem:item animated:(self.navigationController==nil)];
    } else {
        [_navigationBar popNavigationItemAnimated:(self.navigationController==nil)];
    }
}



- (void)tappedMenuView:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }];
    
    [self setupToolWithToolInfo: view.toolInfo];
    
}



- (void)setupToolWithToolInfo:(CLImageToolInfo *)info  {
    
    if(_currentTool)
    {
        return;
    }
    
     toolClass = NSClassFromString(info.toolName);
    
    
    
#pragma mark - ADJUSTMENT TOOL ====================================

      if ( [info.toolName isEqualToString:@"Adjustment"] ) {
          adjON = !adjON;
          NSLog(@"adjON: %d", adjON);
          
          if (adjON) {
        // View that contains the Filter Category Buttons ===========
        filterCategContainer = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 44)];
      //  filterCategContainer.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height -110);
        filterCategContainer.backgroundColor = [UIColor blackColor];
      //  filterCategContainer.layer.cornerRadius = 15;
        [self.view addSubview:filterCategContainer];
        
        } else {
        [filterCategContainer removeFromSuperview];
        }
          
    /*============= BUTTONS FOR ADJUSTMENT TOOL ===================*/
    
          // "Brightness" Button
        UIButton *brightnessButt = [UIButton buttonWithType:UIButtonTypeCustom];
        brightnessButt.frame = CGRectMake(4, 0, 44, 44);
        [brightnessButt addTarget:self action:@selector(adjustmentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [brightnessButt setImage:[UIImage imageNamed:@"brightnessButt"] forState:UIControlStateNormal];
        brightnessButt.adjustsImageWhenHighlighted = YES;
        brightnessButt.tag = 1;
        [filterCategContainer addSubview:brightnessButt];
        
        
        // "Saturation" Button
        UIButton *saturationButt = [UIButton buttonWithType:UIButtonTypeCustom];
        saturationButt.frame = CGRectMake(68, 0, 44, 44);
        [saturationButt addTarget:self action:@selector(adjustmentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [saturationButt setImage:[UIImage imageNamed:@"saturationButt"] forState:UIControlStateNormal];
        saturationButt.layer.cornerRadius = brightnessButt.bounds.size.width/2;
        saturationButt.tag = 2;
        [filterCategContainer addSubview:saturationButt];
        

          // "Contrast" Button
          UIButton *contrastButt = [UIButton buttonWithType:UIButtonTypeCustom];
          contrastButt.frame = CGRectMake(132, 0, 44, 44);
          [contrastButt addTarget:self action:@selector(adjustmentPressed:) forControlEvents:UIControlEventTouchUpInside];
          [contrastButt setImage:[UIImage imageNamed:@"contrastButt"] forState:UIControlStateNormal];
          contrastButt.adjustsImageWhenHighlighted = YES;
          contrastButt.tag = 3;
          [filterCategContainer addSubview:contrastButt];
          
          
          // "Exposure" Button
          UIButton *exposureButt = [UIButton buttonWithType:UIButtonTypeCustom];
          exposureButt.frame = CGRectMake(196, 0, 44, 44);
          [exposureButt addTarget:self action:@selector(adjustmentPressed:) forControlEvents:UIControlEventTouchUpInside];
          [exposureButt setImage:[UIImage imageNamed:@"exposureButt"] forState:UIControlStateNormal];
          exposureButt.adjustsImageWhenHighlighted = YES;
          exposureButt.tag = 4;
          [filterCategContainer addSubview:exposureButt];
          
          
          // "Sharpness" Button
          UIButton *sharpnessButt = [UIButton buttonWithType:UIButtonTypeCustom];
          sharpnessButt.frame = CGRectMake(260, 0, 44, 44);
          [sharpnessButt addTarget:self action:@selector(adjustmentPressed:) forControlEvents:UIControlEventTouchUpInside];
          [sharpnessButt setImage:[UIImage imageNamed:@"sharpnessButt"] forState:UIControlStateNormal];
          sharpnessButt.adjustsImageWhenHighlighted = YES;
          sharpnessButt.tag = 5;
          [filterCategContainer addSubview:sharpnessButt];

    }
    

#pragma mark - LOOMY FILTERS ===============
    
    // NO: IAP not made yet =======
      else if ( ![info.toolName isEqualToString:@"Adjustment"] &&
                 [info.toolName isEqualToString:@"LoomyFilters"]) {
          NSLog(@"toolName2: %@", info.toolName);
          [filterCategContainer removeFromSuperview];
          adjON = false;
          
          id instance = [toolClass alloc];
          if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]]) {
              instance = [instance initWithImageEditor:self withToolInfo:info];
              self.currentTool = instance;
          }
      }
//==========================================================*/

    
    
    
#pragma mark - AMBER FILTERS ===============
    
    // NO: IAP not made yet =======
      else if (![info.toolName isEqualToString:@"Adjustment"] &&
               [info.toolName isEqualToString:@"VintyFilters"]) {
          NSLog(@"toolName2: %@", info.toolName);

          NSLog(@"toolName2: %@", info.toolName);
          [filterCategContainer removeFromSuperview];
          adjON = false;
          
          id instance = [toolClass alloc];
          if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]]) {
              instance = [instance initWithImageEditor:self withToolInfo:info];
              self.currentTool = instance;
          }
      }
    /*==========================================================*/
    
    // Hide Adjustment tool and show the selected one ===========
    else if ( ![info.toolName isEqualToString:@"Adjustment"] ) {
        adjON = false;
        
         NSLog(@"toolName2: %@", info.toolName);
        
         [filterCategContainer removeFromSuperview];
        
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
        {
            instance = [instance initWithImageEditor:self withToolInfo:info];
            self.currentTool = instance;
        }
     }

    
}

// AlertView method to Rate Blink on the AppStore and unlock Loomy filters ==========
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"No, thanks"]){
        
        // Open IAPController
        productInt = 3;
        
//        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
//        iapVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController: iapVC animated:YES completion:nil];
    }
    if([title isEqualToString:@"Download"]){
        PFQuery *query = [PFQuery queryWithClassName:@"application"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if(!error){
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"unlockAmber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                unlockAmber = true;
                NSArray *sorted = [objects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO]]];
                for(id object in sorted){
                    NSLog(@"link: %@", object[@"URLString"]);
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sorted firstObject][@"URLString"]]];
            }
        }];
    }else{
        if (buttonIndex==1)
        {
            // if the user agrees to rate…
            if (!reviewHasBeenMade) {
                reviewHasBeenMade = true;
                [[NSUserDefaults standardUserDefaults] setBool:reviewHasBeenMade forKey:@"reviewHasBeenMade"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                // Creates the URL for reviewing the App, replace "####" with your app ID on iTunes Store.
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=933002558"]];
            }
        
        }
    }
}





#pragma mark - ADJUSTMENT BUTTONS PRESSED =====================

-(void)adjustmentPressed: (UIButton *)button {
    adjON = false;
    
    switch (button.tag) {
            
        case 1: {
            [filterCategContainer removeFromSuperview];
          
            CLImageToolInfo *info;
            toolClass = NSClassFromString(@"CLBrightnessTool");
            
            id instance = [toolClass alloc];
            if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
            {
                instance = [instance initWithImageEditor:self withToolInfo:info];
                self.currentTool = instance;
            }
            NSLog(@"toolClass3: %@", info.toolName);
            
            break; }
    
            
        case 2: {
            [filterCategContainer removeFromSuperview];
            
            CLImageToolInfo *info;
            toolClass = NSClassFromString(@"CLSaturationTool");
            
            id instance = [toolClass alloc];
            if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
            {
                instance = [instance initWithImageEditor:self withToolInfo:info];
                self.currentTool = instance;
            }
            break; }
            
            
        case 3: {
            [filterCategContainer removeFromSuperview];
            
            CLImageToolInfo *info;
            toolClass = NSClassFromString(@"CLContrastTool");
            
            id instance = [toolClass alloc];
            if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
            {
                instance = [instance initWithImageEditor:self withToolInfo:info];
                self.currentTool = instance;
            }
            break; }
            
            
        case 4: {
            [filterCategContainer removeFromSuperview];
            
            CLImageToolInfo *info;
            toolClass = NSClassFromString(@"ExposureTool");
            
            id instance = [toolClass alloc];
            if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
            {
                instance = [instance initWithImageEditor:self withToolInfo:info];
                self.currentTool = instance;
            }
            break; }
          
            
        case 5: {
            [filterCategContainer removeFromSuperview];
            
            CLImageToolInfo *info;
            toolClass = NSClassFromString(@"SharpnessTool");
            
            id instance = [toolClass alloc];
            if(instance!=nil && [instance isKindOfClass:[CLImageToolBase class]])
            {
                instance = [instance initWithImageEditor:self withToolInfo:info];
                self.currentTool = instance;
            }
            break; }
            
            
            
        default: break;
  }
    
}






#pragma mark - BUTTONS METHODS ===========================

- (IBAction)pushedCancelBtn:(id)sender
{
    NSLog(@"CANCEL pressed");

    _imageView.image = _originalImage;
     [self resetImageViewFrame];
    
    self.currentTool = nil;

}

- (IBAction)pushedDoneBtn:(id)sender {
    NSLog(@"DONE pressed");

    self.view.userInteractionEnabled = NO;
    
    [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        
        } else if(image){
            _originalImage = image;
            _imageView.image = image;
            
            [self resetImageViewFrame];
            self.currentTool = nil;
        }
        self.view.userInteractionEnabled = YES;
    }];
}



- (void)pushedCloseBtn:(id)sender  {
    NSLog(@"CLOSE pressed");
    
    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]){
            [self.delegate imageEditorDidCancel:self];
      
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } else {
        _imageView.image = self.targetImageView.image;
        [self restoreImageView:YES];
    }
}

- (void)pushedFinishBtn:(id)sender  {
    NSLog(@"FINISH pressed");

    if(self.targetImageView==nil){
        if([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)]){
            [self.delegate imageEditor:self didFinishEdittingWithImage:_originalImage];
        
        }else{
        
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else{
        
        _imageView.image = _originalImage;
        [self restoreImageView:NO];
    }
}



#pragma mark- ScrollView delegate ============================
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}



//#pragma mark - iAD INTERSTITIAL METHODS =================
////Interstitial iAd
//-(void)showFullScreenAd {
//    //Check if already requesting ad
//    if (requestingAd == NO) {
//        interstitial = [[ADInterstitialAd alloc] init];
//        interstitial.delegate = self;
//        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
//        [self requestInterstitialAdPresentation];
//        NSLog(@"interstitialAdREQUEST");
//        requestingAd = YES;
//    }//end if
//}
//
//-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
//    interstitial = nil;
//    requestingAd = false;
//    NSLog(@"interstitialAd didFailWithERROR");
//    NSLog(@"%@", error);
//}
//
//-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
//    NSLog(@"interstitialAd DidLOAD");
//    if (interstitialAd != nil && interstitial != nil && requestingAd == true) {
//        adPlaceholderView = [[UIView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview: adPlaceholderView];
//        [interstitial presentInView: adPlaceholderView];
//        NSLog(@"interstitialAd DidPRESENT!");
//    }//end if
//}
//
//-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
//    interstitial = nil;
//    requestingAd = false;
//    NSLog(@"interstitialAdDidUNLOAD");
//}
//
//-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
//    interstitial = nil;
//    requestingAd = false;
//    [adPlaceholderView removeFromSuperview];
//    NSLog(@"interstitialAdDidFINISH");
//}


/*=====================================================================*/





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Watermark

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

- (IBAction)watermarkButt:(id)sender {
    removeWatermarkScreen = [[RemoveWatermarkScreen alloc]initWithNibName:@"RemoveWatermarkScreen" bundle:nil];
    
    // Passes the Edited Image to the SharingScreen
    removeWatermarkScreen.imagePassed = _imageView.image;
    removeWatermarkScreen.iAPIndex = 4; // Watermark
    
    removeWatermarkScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:removeWatermarkScreen animated:YES completion:nil];
    
    
}

@end
