


#import "ExposureTool.h"

@implementation ExposureTool
{
    UIImage *_originalImage;
    UIImage *_thumnailImage;
    
    UIView *sliderContainer;
    UISlider *_exposureSlider;
    
    UIActivityIndicatorView *_indicatorView;
}

+ (NSString*)defaultTitle
{

    return NSLocalizedStringWithDefaultValue(@"ExposureTool_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Exposure", @"");
}

+ (BOOL)isAvailable
{
   // return ([UIDevice iosVersion] >= 5.0);
    return NO;
}

- (void)setup
{
   
    _originalImage = self.editor.imageView.image;
 //   _thumnailImage = [_originalImage resize:self.editor.imageView.frame.size];
    _thumnailImage = _originalImage;
  //  [self.editor fixZoomScaleWithAnimated:YES];
    
    [self setupSlider];
}

- (void)cleanup
{
    [_indicatorView removeFromSuperview];
    [_exposureSlider.superview removeFromSuperview];
    
   // [self.editor resetZoomScaleWithAnimated:YES];
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _indicatorView = [CLImageEditorTheme indicatorView];
        _indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:_indicatorView];
        [_indicatorView startAnimating];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}




#pragma mark- SLIDER CONTAINER AND SLIDER SETTINGS ===========
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
    
    
    // Label that show the name of the current tool
    UILabel *toolLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, self.editor.view.frame.size.width, 30)];
    toolLabel.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:15];
    toolLabel.textColor = [UIColor whiteColor];
    toolLabel.textAlignment = NSTextAlignmentCenter;
    toolLabel.text = @"Exposure"; // Set here the tool's name
    [sliderContainer addSubview:toolLabel];
    
    
    [sliderContainer addSubview:slider];
    [self.editor.view addSubview:sliderContainer];
    
    
    return slider;
}

- (void)setupSlider
{
    // Set here max and min slider value
    _exposureSlider = [self sliderWithValue:0 minimumValue:-5 maximumValue:5 action:@selector(sliderDidChange:)];
    _exposureSlider.superview.center = CGPointMake(self.editor.view.width/2, self.editor.menuView.top-30);
    
    [_exposureSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [_exposureSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    
    [_exposureSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_exposureSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
    
    

}

- (void)sliderDidChange:(UISlider*)sender
{
    static BOOL inProgress = NO;
    
    if(inProgress){ return; }
    inProgress = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_thumnailImage];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        inProgress = NO;
    });
}

- (UIImage*)filteredImage:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    NSLog(@"%@", filter.attributes);
    
    CGFloat exposure = _exposureSlider.value;
    [filter setValue:[NSNumber numberWithFloat:exposure] forKey:@"inputEV"];

    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


@end
