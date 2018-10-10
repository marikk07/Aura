

#import "CLHueEffect.h"

#import "UIView+Frame.h"

@implementation CLHueEffect
{
    UIView *_containerView;
    
    UIView *sliderContainer;
    UISlider *_hueSlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLHueEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Hue", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
        _containerView.clipsToBounds = YES;
        [superview addSubview:_containerView];
        
        [self setUserInterface];
    }
    return self;
}

- (void)cleanup
{
    [_containerView removeFromSuperview];
}

- (UIImage*)applyEffect:(UIImage*)image
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:_hueSlider.value] forKey:@"inputAngle"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

#pragma mark-

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, _containerView.frame.size.width-80, 35)];
    
    sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _containerView.frame.size.width, slider.height)];
    sliderContainer.backgroundColor = [UIColor clearColor];
    //[[UIColor blackColor] colorWithAlphaComponent:0.8];

    
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderDidChange:) forControlEvents:UIControlEventValueChanged];
    
    slider.maximumValue = max;
    slider.minimumValue = min;
    slider.value = value;
    
    [sliderContainer addSubview:slider];
    [_containerView addSubview:sliderContainer];
    
    return slider;
}

- (void)setUserInterface
{
    _hueSlider = [self sliderWithValue:0 minimumValue:-M_PI maximumValue:M_PI];
    _hueSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    [_hueSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [_hueSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    
    [_hueSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_hueSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
}

- (void)sliderDidChange:(UISlider*)sender
{
    [self.delegate effectParameterDidChange:self];
}

@end
