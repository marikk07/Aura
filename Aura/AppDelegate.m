

#import "AppDelegate.h"
#import "IntroScreen.h"
#import "InfoScreen.h"

#import "CLImageEditor/CLImageToolInfo.h"
#import "Parse/Parse.h"
#import "AdColonyHelper.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Aura-Swift.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    // Load BOOL for IAP =============
//    unlockAmber = YES;
//    unlockAll = YES;
//    unlockBorders = YES;
//    unlockLightFX = YES;
//    unlockWatermarks = YES;
//    
//    [[NSUserDefaults standardUserDefaults] setBool:unlockAll forKey:@"unlockAll"];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:unlockBorders forKey:@"unlockBorders"];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:unlockLightFX forKey:@"unlockLightFX"];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:unlockAmber forKey:@"unlockAmber"];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:unlockWatermarks forKey:@"unlockWatermarks"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    /*unlockAmber = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlockAmber"];
//    unlockAll = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlockAll"];
//    unlockBorders = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlockBorders"];
//    unlockLightFX = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlockLightFX"];
//    unlockWatermarks = [[NSUserDefaults standardUserDefaults] boolForKey:@"unlockWatermarks"];*/
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    // Checks if infoScreen has been viewed for the 1st time
    infoViewed = [[NSUserDefaults standardUserDefaults] boolForKey:@"infoViewed"];
    NSLog(@"INFOSCREEN: %d", infoViewed);
    
    SubscriptionManager *manager = [SubscriptionManager instance];

    if (manager.status == StatusInactive) {
        // Opens the Info Screen when the App first starts =======
        _infoScreen = [[InfoScreen alloc]initWithNibName:@"InfoScreen" bundle:nil];
        _infoScreen.isFirstTimeStart = YES;
        self.window.rootViewController = _infoScreen;
        [self.window makeKeyAndVisible];
        
        infoViewed = YES;
        // Saves the infoViewed as YES
        [[NSUserDefaults standardUserDefaults] setBool:infoViewed forKey:@"infoViewed"];
        
    } else {
        
        // Opens the Intro Screen when the App first starts =======
        _introScreen = [[IntroScreen alloc] initWithNibName:@"IntroScreen" bundle:nil];
        self.window.rootViewController = _introScreen;
        [self.window makeKeyAndVisible];
        
    }
    
    [Parse setApplicationId:@"6Hjj7UVkL8k7nfXqsZBA2EzUI1YVNmooxP3wjlTy"
                  clientKey:@"UISVYfyQnGH3iTFXWg32FPigUuhxxHtLO5H42FU3"];
    
    // Fabric
    [Fabric with:@[[Crashlytics class]]];
        
    // configure AdColony Keys, 
    //[[AdColonyHelper sharedManager] configureAdColony];
        
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}






@end
