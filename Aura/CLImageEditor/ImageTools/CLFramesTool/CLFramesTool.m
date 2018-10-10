

#import "SharingScreen.h"

#import "CLFramesTool.h"

#import "CLCircleView.h"

static NSString* const kCLFramesToolFramesPathKey = @"framesPath";

@interface _CLFramesView : UIView
+ (void)setActiveFramesView:(_CLFramesView *)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
@end



@implementation CLFramesTool
{
    // Slider
    UIView *sliderContainer;
    UISlider *opacitySlider;
    UISlider *scaleSlider;
    
    UIScrollView *_menuScroll;
    
    // Color Picker View
    NSArray *colorsArray;
    UIScrollView *colorScrollView;
    UIView *colorPickerView;
    UIButton *colorButt;
    int colorTag;
    UIButton *okButton;

    _CLFramesView *_framesView;
}

+ (NSArray*)subtools
{
    
    return nil;
}

+ (NSString*)defaultTitle
{
   // return NSLocalizedStringWithDefaultValue(@"CLFramesTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Frames", @"");
    return false;
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}


#pragma mark- FRAMES PATH ============

+ (NSString*)defaultFramesPath
{
    return [[[CLImageEditorTheme bundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/frames", NSStringFromClass(self)]];
}

+ (NSDictionary*)optionalInfo
{
    return @{kCLFramesToolFramesPathKey:[self defaultFramesPath]};
}



#pragma mark- INITIALIZATION ==========

- (void)setup {
    
    _originalImage = self.editor.imageView.image;
   
    //[self.editor fixZoomScaleWithAnimated:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = YES;
    [self.editor.view addSubview:_menuScroll];
    
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = true;
    [self.editor.view addSubview:_workingView];
    
    
    [self setupSliders];
    
    [self setFramesMenu];
    
    /* COLOR PICKER VIEW ==============================*/
    colorPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.editor.view.frame.size.height, self.editor.view.frame.size.width, 30)];
    colorPickerView.clipsToBounds = YES;
    colorPickerView.backgroundColor = [UIColor lightGrayColor];
    
    
    // ScrollView for Color Buttons =============
    colorScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, colorPickerView.frame.size.width, colorPickerView.frame.size.height)];
    [colorScrollView setBackgroundColor: [UIColor clearColor]];
    colorScrollView.scrollEnabled = true;
    colorScrollView.userInteractionEnabled = true;
    colorScrollView.showsHorizontalScrollIndicator = true;
    colorScrollView.showsVerticalScrollIndicator = false;
    [colorPickerView addSubview:colorScrollView];
    
    [self setColorToolbar];
    
    selectedFrameColor = [UIColor whiteColor];
    /* END COLOR PICKER VIEW ================*/
    

    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
    [UIView animateWithDuration:kCLImageToolAnimationDuration
    animations:^{
        
    _menuScroll.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.editor.view addSubview:colorPickerView];
    }];
}

- (void)cleanup
{
  //  [self.editor resetZoomScaleWithAnimated:YES];
    
    [sliderContainer removeFromSuperview];
    [opacitySlider removeFromSuperview];
    [_workingView removeFromSuperview];
    [colorPickerView removeFromSuperview];
    
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
    [_CLFramesView setActiveFramesView:nil];
    
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
    sliderContainer.backgroundColor = [UIColor clearColor];
    //[[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    
    slider.continuous = YES;
    [slider addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [sliderContainer addSubview:slider];
    [self.editor.view addSubview:sliderContainer];
    
    return slider;
}

-(void)setupSliders {
    
    
    opacitySlider = [self sliderWithValue:0.5 minimumValue:0.0 maximumValue:1.0 action:@selector(sliderDidChange:)];
    opacitySlider.superview.center = CGPointMake(25, 250);
    opacitySlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);

    [opacitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [opacitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    [opacitySlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [opacitySlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    
}

#pragma mark - OPACITY SLIDER ===================
- (void)sliderDidChange:(UISlider*)sender {    
    _workingView.alpha = sender.value;
}


#pragma mark - SET COLORS TOOLBAR ====================
-(void)setColorToolbar {
    
    // Color Buttons & Colors ===================
    colorsArray = [NSArray arrayWithObjects:
                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],
                   
                   [UIColor colorWithRed:252.0/255.0 green:197.0/255.0 blue:132.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:142.0/255.0 green:82.0/255.0 blue:93.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:199.0/255.0 green:68.0/255.0 blue:204.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:141.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:103.0/255.0 green:141.0/255.0 blue:239.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:103.0/255.0 green:212.0/255.0 blue:239.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:103.0/255.0 green:239.0/255.0 blue:196.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:238.0/255.0 green:243.0/255.0 blue:90.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:218.0/255.0 green:228.0/255.0 blue:50.0/255.0 alpha:1.0],
                   [UIColor colorWithRed:190.0/255.0 green:200.0/255.0 blue:30.0/255.0 alpha:1.0],
                   nil];
    
    
    int xCoord = 0;
    int yCoord = 0;
    int buttonWidth = 50;
    int buttonHeight= colorPickerView.frame.size.height;
    int gapBetweenButtons = 0;
    
    // Loop for creating buttons
    for (int i = 0; i < colorsArray.count; i++) {
        colorButt = [UIButton buttonWithType:UIButtonTypeCustom];
        colorButt.frame = CGRectMake(xCoord, yCoord, buttonWidth,buttonHeight);
        colorButt.tag = i;
        [colorButt setBackgroundColor: [colorsArray objectAtIndex:i]];
        [colorButt addTarget:self action:@selector(colorButtTapped:) forControlEvents:UIControlEventTouchUpInside];
        [colorScrollView addSubview:colorButt];
        
        xCoord += buttonWidth + gapBetweenButtons;
    }
    
    colorScrollView.contentSize = CGSizeMake(buttonWidth * colorsArray.count +1, yCoord);
    
    [self showColorPickerView];
}

#pragma mark - COLOR BUTTONS METHOD ====================
-(void)colorButtTapped: (UIButton *)sender {
    NSLog(@"colorTag: %li", (long)sender.tag);
    selectedFrameColor = [colorsArray objectAtIndex:sender.tag];
    [_framesView.imageView setTintColor:selectedFrameColor];
    
}

#pragma mark - SHOW / HIDE COLOR PICKER VIEW ======================
-(void)showColorPickerView {
    [UIView animateWithDuration:0.01 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^ {
        CGRect ftbFrame = colorPickerView.frame;
        ftbFrame.origin.y = _menuScroll.top - colorPickerView.frame.size.height;
        colorPickerView.frame = ftbFrame;
    } completion:^(BOOL finished) {
        /*
         okButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [okButton setImage:[CLImageEditorTheme imageNamed:@"PhrasesTool/btn_ok.png"] forState:UIControlStateNormal];
         okButton.frame = CGRectMake(colorPickerView.frame.size.width -32, colorPickerView.frame.origin.y, 32, 32);
         [okButton addTarget:self action:@selector(hideColorPickerView) forControlEvents:UIControlEventTouchUpInside];
         [self.editor.view addSubview:okButton];
         */
    }];
    
}



#pragma mark - SET FRAMES MENU =================

- (void)setFramesMenu {
    CGFloat W = 50;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;

    
    framesPath = self.toolInfo.optionalInfo[kCLFramesToolFramesPathKey];
    if(framesPath == nil){
        framesPath = [[self class] defaultFramesPath];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
        list = [fileManager contentsOfDirectoryAtPath:framesPath error:&error];
        
    for (NSString *pathStr in list){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", framesPath, pathStr];
        
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedFramesPanel:) toolInfo:nil];
        
        
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
        
        [_menuScroll addSubview:view];
        x += W;
    }
    
    
    NSLog(@"%@", list);
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
    
    
}


- (void)tappedFramesPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    NSString *filePath = view.userInfo[@"filePath"];
    
    // Shows the frame tapped and its name into LOG
    NSLog(@"filepath= %@", filePath);
    
     if (filePath) {
         [_workingView removeFromSuperview];
         
         // WorkingView containing Textures =========
         _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
         _workingView.clipsToBounds = YES;
         [self.editor.view addSubview:_workingView];
         
         
         //_CLFramesView *view
         _framesView = [[_CLFramesView alloc] initWithImage:[UIImage imageWithContentsOfFile:filePath]];
         // Puts the frame in the center of the image
         _framesView.center = CGPointMake(_workingView.width/2, _workingView.height/2);
         
         width = _workingView.width;
         height = _workingView.height;
         
         _framesView.frame = CGRectMake(0,0, width, height);
         
         [_workingView addSubview:_framesView];
         [_workingView.superview bringSubviewToFront:sliderContainer];
         [_workingView.superview bringSubviewToFront:colorPickerView];
         [_framesView.imageView setTintColor:selectedFrameColor];
     }
    
    _workingView.alpha = opacitySlider.value;
    
}


- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 1.0f);
    
    [image drawAtPoint:CGPointZero];
    
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}


@end





#pragma mark - FRAMES VIEW IMPLEMENTATION ======================
@implementation _CLFramesView
{
    
    UIImageView *_imageView;
    UIButton *_deleteButton;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
}

+ (void)setActiveFramesView:(_CLFramesView*)view {
    
    static _CLFramesView *activeView = nil;
    if(view != activeView){
        [activeView setActive:NO];
        activeView = view;
        [activeView setActive:YES];
        
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height)];
    
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.center = self.center;
        _imageView.frame = CGRectMake(0,0, _workingView.width, _workingView.height);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
        _imageView.image = [_imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self addSubview:_imageView];
        
        _scale = 2;
        _arg = 0;
        
        [self initPinchGesture];
    }
    return self;
}

-(void)initPinchGesture  {
    
    _imageView.userInteractionEnabled = YES;
    
    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)]];
    
}

/*
- (void)initGestures  {
    
    _imageView.userInteractionEnabled = YES;
    
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_imageView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)]];

    
    // DOUBLE TAP on a Frame to delete it
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteFrame)];
    doubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer: doubleTap];
    
}
*/

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

/*
-(void)deleteFrame {
    _CLFramesView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[_CLFramesView class]]){
            nextTarget = (_CLFramesView*)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[_CLFramesView class]]){
                nextTarget = (_CLFramesView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveFramesView:nextTarget];
    [self removeFromSuperview];
}
*/

- (void)setActive:(BOOL)active
{
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
    _imageView.layer.borderColor = [[UIColor clearColor] CGColor];
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
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

/*
- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [[self class] setActiveFramesView:self];
}


- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveFramesView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}
*/

-(void)viewDidPinch: (UIPinchGestureRecognizer *) sender {
    
    if (sender.state == UIGestureRecognizerStateEnded
        || sender.state == UIGestureRecognizerStateChanged) {
        
        NSLog(@"SCALE: = %f", sender.scale);
        
        CGFloat currentScale = self.frame.size.width / self.bounds.size.width;
        CGFloat newScale = currentScale * sender.scale;
        
        if (newScale < 1.0) {
            newScale = 1.0;
        }
        if (newScale > 2.0) {
            newScale = 2.0;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        self.transform = transform;
        sender.scale = 1;
    }
    
}





@end
