

#import <UIKit/UIKit.h>
//#import <AdColony/AdColony.h>

@class IntroScreen, InfoScreen;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *iapProductsList;

@property (strong, nonatomic) IntroScreen *introScreen;
@property (strong, nonatomic) InfoScreen *infoScreen;

@end
