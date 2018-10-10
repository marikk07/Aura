



#import "CLImageEditor.h"
#import "CLToolbarMenuItem.h"
//#import <iAd/iAd.h>
#import "RemoveWatermarkScreen.h"


NSString *toolStr;
Class toolClass;
int tagInt;
CLToolbarMenuItem *CLtoolbar;

BOOL adjON;


@interface _CLImageEditorViewController : CLImageEditor
<
UIScrollViewDelegate,
UIBarPositioningDelegate/*,
ADInterstitialAdDelegate*/
>
{
//    // Interstitial iAd
//    ADInterstitialAd *interstitial;
//    UIView *adPlaceholderView;
//    BOOL requestingAd;
    
    IBOutlet __weak UINavigationBar *_navigationBar;    
    UIView *filterCategContainer;
    
}

@property (strong, nonatomic)  RemoveWatermarkScreen *removeWatermarkScreen;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, weak) IBOutlet UIScrollView *menuView;
@property (weak, nonatomic) IBOutlet UIView *watermarkView;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel2;
- (IBAction)watermarkButt:(id)sender;

- (IBAction)pushedCloseBtn:(id)sender;
- (IBAction)pushedFinishBtn:(id)sender;

- (id)initWithImage:(UIImage*)image;

-(void)resetImageAfterBordes:(BOOL)animated;

- (void)resetImageViewFrame;
- (void)fixZoomScaleWithAnimated:(BOOL)animated;
- (void)resetZoomScaleWithAnimated:(BOOL)animated;

@end
