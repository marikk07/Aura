

#import "SharingScreen.h"
#import "IntroScreen.h"
#import "IAPController.h"

#import "LightFXTool.h"
#import "CLCircleView.h"

#import "AdColonyHelper.h"

static NSString* const kLightFXPathKey = @"lightFXPath";



@interface _LightFXView : UIView
+ (void)setActiveLightFXView:(_LightFXView *)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
- (void)prepareForRenderHidden: (BOOL)hidden;
@end



@implementation LightFXTool
{
    // For opacity Slider
    UIView *sliderContainer;
    UISlider *opacitySlider;
    
    UIScrollView *_menuScroll;
    
    UIButton *iapButt;
    UIImageView *iapIcon;
    int tagINT;
    NSTimer *timerForIcons;

    _LightFXView *lightFXView;

}


+ (NSArray*)subtools
{
    
    return nil;
}

+ (NSString*)defaultTitle
{
  //  return NSLocalizedStringWithDefaultValue(@"LightFXTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"LightFX", @"");
    return false;
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}


#pragma mark- LIGHT FX PATHS ============
+ (NSString*)LightFXPathDefault
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/lightFX", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{ kLightFXPathKey:[self LightFXPathDefault] };
}




#pragma mark- INITIALIZATION ==========

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
   
    // [self.editor fixZoomScaleWithAnimated:YES];
    
    
    // Timer that checks if IAP has been made and then removes dots
    timerForIcons = [NSTimer scheduledTimerWithTimeInterval:0.2  target:self
    selector:@selector(removeIcons:)  userInfo:nil repeats:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = YES;
    [self.editor.view addSubview:_menuScroll];
    
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    
    // Scale Slider for Textures ================
    opacitySlider = [self sliderWithValue:0.5 minimumValue:0.0 maximumValue:1.0 action:@selector(sliderDidChange:)];
    opacitySlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.menuView.top-30);
   
    [opacitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [opacitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    [opacitySlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [opacitySlider setMaximumTrackTintColor:[UIColor darkGrayColor]];

    
    
    [self setLightFXMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

-(void)removeIcons: (NSTimer *)timer  {
    if (unlockLightFX) {
        for (int i=105; i <= iapIcon.tag; i++) {
            [[self.editor.view viewWithTag:i] removeFromSuperview];
        }
        [timerForIcons invalidate];
    }
    //NSLog(@"timerON!");
}


- (void)cleanup
{
    [timerForIcons invalidate];

 //   [self.editor resetZoomScaleWithAnimated:YES];
    
    [sliderContainer removeFromSuperview];
    [opacitySlider removeFromSuperview];
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
    animations:^{
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
      }
    completion:^(BOOL finished) {
    
        [_menuScroll removeFromSuperview];
    }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [_LightFXView setActiveLightFXView:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max action:(SEL)action
{
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, self.editor.view.frame.size.width-80, 35)];
   
    sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.editor.view.frame.size.width, slider.height)];
    sliderContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
   
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [sliderContainer addSubview:slider];
    [self.editor.view addSubview:sliderContainer];
    
    return slider;
}

#pragma mark - OPACITY SLIDER ===================
- (void)sliderDidChange:(UISlider*)sender {
    if (lightFXView){
        // change only for image
        lightFXView.imageView.alpha = sender.value;
    }
    else{
        // chnage by default for all views
        _workingView.alpha = sender.value;
    }
}








#pragma mark - SET FRAMES MENU =================

- (void)setLightFXMenu {
    CGFloat W = 50;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;

    
    lightFXPath = self.toolInfo.optionalInfo[kLightFXPathKey];
    if(lightFXPath == nil){
        lightFXPath = [[self class] LightFXPathDefault];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
        list = [fileManager contentsOfDirectoryAtPath:lightFXPath error:&error];
        
    for (NSString *pathStr in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", lightFXPath, pathStr];
        
        tagINT++;
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedLightFXPanel:) toolInfo:nil];
        
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
        if (!unlockLightFX && view.tag >=5) {
            iapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 6, 6)];
            iapIcon.backgroundColor = [UIColor blueColor];
            iapIcon.layer.cornerRadius = iapIcon.bounds.size.width /2;
            iapIcon.tag = tagINT +100;
            [view addSubview:iapIcon];
            NSLog(@"iapIcon TAG: %ld", (long)iapIcon.tag);
        }

        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    
   // NSLog(@"%@", list);
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);

}


- (void)tappedLightFXPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    NSLog(@"TAG:%ld", (long)view.tag);

    NSString *filePath = view.userInfo[@"filePath"];

    
    /*====================================================================================
     NO IAP MADE - open the IAP Controller
     =====================================================================================*/
    if (!unlockLightFX && view.tag >=5) {
        
        // open IAP view controller without dialog
        // Set productInt for IAP product's recognition;
        productInt = 2;
        
//        IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
//        iapVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self.editor presentViewController: iapVC animated:YES completion:nil];

        /*
        [[AdColonyHelper sharedManager] showDialogWithIAPBlockBlock:^{
            // Set productInt for IAP product's recognition;
            productInt = 2;
            
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
   //  if (filePath) {
        
         [_workingView removeFromSuperview];
         // WorkingView containing Textures =========
         _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
         _workingView.clipsToBounds = YES;
         [self.editor.view addSubview:_workingView];
         
         
         lightFXView = [[_LightFXView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
        
         // Puts the frame in the center of the image
         lightFXView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
         
         width = _workingView.width;
         height = _workingView.height;
         
         lightFXView.frame = CGRectMake(0,0, width, height);
         
         [_workingView addSubview:lightFXView];
        //[view setScale:0.5];
         [_workingView.superview bringSubviewToFront:sliderContainer];
     }
    
    if (lightFXView){
        lightFXView.imageView.alpha = opacitySlider.value;
    }
    else{
        _workingView.alpha = opacitySlider.value;
    }
    
}


- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContext(image.size);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    // draw only image if possible
    if (lightFXView){
        [lightFXView prepareForRenderHidden:YES];
    }
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmp;
}


@end





#pragma mark - FRAMES VIEW IMPLEMENTATION ======================
@implementation _LightFXView
{
    UIImageView *_imageView;
    UIButton *_deleteButton;
   
    CLCircleView *_circleView;
    
    CGFloat _scale;
    CGFloat _scalePinchBegin;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

- (void)prepareForRenderHidden: (BOOL)hidden {
    _circleView.hidden = hidden;
}

+ (void)setActiveLightFXView:(_LightFXView*)view {
    
    static _LightFXView *activeView = nil;
    if(view != activeView){
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image
{
    
    width = _workingView.width;
    height = _workingView.height;
    
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    
    if(self){
        
        
        _imageView = [[UIImageView alloc] initWithImage:image];
        
        _imageView.frame = CGRectMake(0,0, width, height);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.contentScaleFactor = 15/200.0;
        //_imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _imageView.center = self.center;
        
        _imageView.clipsToBounds = YES;
        
     //   NSLog(@"width: %f - height: %f", width, height);
     //   NSLog(@"imageW:%f - imageH%f", _imageView.frame.size.width, _imageView.frame.size.height);
        
        [self addSubview:_imageView];
        
        // CircleView (Handler) ========
        _circleView = [[CLCircleView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        _circleView.center = CGPointMake(_imageView.width + _imageView.left - _circleView.frame.size.width/2, _imageView.height + _imageView.top - _circleView.frame.size.height/2);
        _circleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _circleView.radius = 0.7;
        _circleView.color = [UIColor whiteColor];
        _circleView.borderColor = [UIColor darkGrayColor];
        _circleView.borderWidth = 2;
        [self addSubview:_circleView];
        
        
        //self.frame = CGRectMake(0,0, width, height);
        _arg = 0;

    
        [self setScale:1];
        
        [self initGestures];
        
        
        
        
        [self initPinchGesture];
    }
    return self;
}

#pragma mark - INIT GESTURE RECOGNIZERS ===================
- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    _circleView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    

    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    
    [_circleView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
    
}


-(void)initPinchGesture  {
    
    _imageView.userInteractionEnabled = YES;
    
    
    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)]];
    
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
    return _imageView;
}

- (void)setActive:(BOOL)active
{
    _circleView.hidden = !active;
    //_imageView.layer.borderWidth = (active) ? 1/_scale : 0;
    //_imageView.layer.borderColor = [[UIColor clearColor] CGColor];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    //_imageView.layer.borderWidth = 1/_scale;
    //_imageView.layer.cornerRadius = 3/_scale;
}


-(void)viewDidPinch: (UIPinchGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateBegan){
        _scalePinchBegin = _scale;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded
        || sender.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"SCALE: = %f", sender.scale);
        
        CGFloat newScale = sender.scale * _scalePinchBegin;
        
        /*
        if (newScale < 1.0) {
            newScale = 1.0;
        }
        if (newScale > 2.0) {
            newScale = 2.0;
        }
         */
        
        [self setScale:newScale];
        
        //CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        //self.transform = transform;
        //sender.scale = 1;
    }
    
}



- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    //[[self class] setActiveTextView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender {
    
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = [self.superview convertPoint:_circleView.center fromView:_circleView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = _initialArg + arg - tmpA;
    [self setScale:MAX(_initialScale * R / tmpR, 15/200.0)];
}

@end
