

#import "CLGloomEffect.h"

#import "UIImage+Utility.h"
#import "UIView+Frame.h"

@implementation CLGloomEffect
{
    UIView *_containerView;
    
    UIView *sliderContainer;
    UISlider *_radiusSlider;
    UISlider *_intensitySlider;
}

#pragma mark-

+ (NSString*)defaultTitle
{
    return NSLocalizedStringWithDefaultValue(@"CLGloomEffect_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Gloom", @"");
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 6.0);
}

- (id)initWithSuperView:(UIView*)superview imageViewFrame:(CGRect)frame toolInfo:(CLImageToolInfo *)info
{
    self = [super initWithSuperView:superview imageViewFrame:frame toolInfo:info];
    if(self){
        _containerView = [[UIView alloc] initWithFrame:superview.bounds];
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
    CIFilter *filter = [CIFilter filterWithName:@"CIGloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = _radiusSlider.value * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:_intensitySlider.value] forKey:@"inputIntensity"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    CGFloat dW = (result.size.width - image.size.width)/2;
    CGFloat dH = (result.size.height - image.size.height)/2;
    
    CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    
    return [result crop:rct];
}

#pragma mark - SLIDER SETUP ==============

- (UISlider*)sliderWithValue:(CGFloat)value minimumValue:(CGFloat)min maximumValue:(CGFloat)max
{
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, _containerView.frame.size.width-80, 35)];
    
    sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _containerView.frame.size.width, slider.height)];
    sliderContainer.backgroundColor = [UIColor clearColor];
    //[[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    slider.continuous = NO;
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
    _radiusSlider = [self sliderWithValue:0.5 minimumValue:0 maximumValue:1.0];
    _radiusSlider.superview.center = CGPointMake(_containerView.width/2, _containerView.height-30);
    
    [_radiusSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [_radiusSlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    
    [_radiusSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_radiusSlider setMaximumTrackTintColor:[UIColor darkGrayColor]];

    
    
    _intensitySlider = [self sliderWithValue:1 minimumValue:0 maximumValue:1.0];
    _intensitySlider.superview.center = CGPointMake(25, _radiusSlider.superview.top - 150);
    _intensitySlider.superview.transform = CGAffineTransformMakeRotation(-M_PI * 90 / 180.0f);
    
    [_intensitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateNormal];
    [_intensitySlider setThumbImage:[CLImageEditorTheme imageNamed:[NSString stringWithFormat:@"%@/thumb", [self class]]] forState:UIControlStateHighlighted];
    
    [_intensitySlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_intensitySlider setMaximumTrackTintColor:[UIColor darkGrayColor]];
}

- (void)sliderDidChange:(UISlider*)sender
{
    [self.delegate effectParameterDidChange:self];
}

@end
