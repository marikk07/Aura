//
//  AdColonyHelper.m
//  Aura
//
//  Created by Yaroslav Kupyak on 2/1/16.
//  Copyright © 2016 Hubwester. All rights reserved.
//

#import "AdColonyHelper.h"
#import "UIAlertView+Blocks/UIAlertView+Blocks.h"
#import "IntroScreen.h"

static AdColonyHelper *sharedManager= nil;

@implementation AdColonyHelper

+ (id)sharedManager {
    @synchronized(self) {
        if(sharedManager == nil)
            sharedManager = [[super allocWithZone:NULL] init];
        
        
    }
    return sharedManager;
}


/*- (void)configureAdColony{
    [AdColony configureWithAppID:kAdColonyAppID zoneIDs:@[kAdColonyZoneID] delegate:self logging:YES];

    // Observe unlocking by AdColony
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObservers) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addObservers) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self addObservers];
    
    [self checkAllFeatures];

}*/



- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneReady) name:kZoneReady object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneOff) name:kZoneOff object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneLoading) name:kZoneLoading object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneOff object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneLoading object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneReady object:nil];
}

- (void)zoneOff{
    // handle unavailable zone
    [self showErrorAlert];
}

- (void)zoneReady{
    // finishing loading video
}

- (void)zoneLoading{
    // start loading video
}


- (void) showErrorAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Video Ad is not available. Please try again later."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)isUnlocked{
    NSNumber* wrappedBalance = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrencyBalance];
    int currentCount = 0;
    if (wrappedBalance){
        currentCount = wrappedBalance.intValue;
    }
    
    return (currentCount >= kAdColonyMaxCurency);
}

- (void)showDialogWithIAPBlockBlock:(AdColonyEmptyBlock)IAPBlock{
    // get count of videos that was already viewed
    NSNumber* wrappedBalance = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrencyBalance];
    int currentCount = 0;
    if (wrappedBalance){
        currentCount = wrappedBalance.intValue;
    }
    
         
    NSString *freeButtonTitle = [NSString stringWithFormat:@"Watch videos (%d/%d) to get for free", currentCount, kAdColonyMaxCurency ];
    NSString *IAPButtonTitle = @"In-App Purchase";
    [UIAlertView showWithTitle:nil
                       message:@"Do you want to get all features for free?"
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@[freeButtonTitle, IAPButtonTitle]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:freeButtonTitle]) {
                              NSLog(@"AdColony");
                              // hot-fix: avoid issue with dialog window and AdColony pop-over
                              [self performSelector:@selector(playVideo) withObject:nil afterDelay:1.0];
                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:IAPButtonTitle]) {
                              NSLog(@"IAP");
                              
                              if (IAPBlock){
                                  IAPBlock();
                              }
                          }
                      }];
}

/*- (void)playVideo{
    if (![AdColony isVirtualCurrencyRewardAvailableForZone:kAdColonyZoneID]){
        // handle all cases: internet issue, daily limit, delay by AdColony Init
        [self showErrorAlert];
        return;
    }
    if ([AdColony videoAdCurrentlyRunning]){
        // ignore running twice
        [self showErrorAlert];
        return;
    }
    
    // play video Ad in full screen
    [AdColony playVideoAdForZone:kAdColonyZoneID withDelegate:[AdColonyHelper sharedManager] withV4VCPrePopup:NO andV4VCPostPopup:NO];
    
}


#pragma mark - AdColony

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID {
    if (!shown && [AdColony zoneStatusForZone:kAdColonyZoneID] != ADCOLONY_ZONE_STATUS_ACTIVE) {
        [self zoneLoading];
    } else if (!shown) {
        [self zoneReady];
    }
}

#pragma mark - AdColony ad fill
    
//Callback triggered when the state of ad readiness changes
//When the AdColony SDK tells us our zone either has, or doesn't have, ads, we
// need to tell our view controller to update its UI elements appropriately
- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString*) zoneID {
    if (available) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZoneReady object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kZoneLoading object:nil];
    }
}
    

#pragma mark - AdColony V4VC

//Callback activated when a V4VC currency reward succeeds or fails
//This implementation is designed for client-side virtual currency without a server
//It uses NSUserDefaults for persistent client-side storage of the currency balance
//For applications with a server, contact the server to retrieve an updated currency balance
//On success, posts an NSNotification so the rest of the app can update the UI
//On failure, posts an NSNotification so the rest of the app can disable V4VC UI elements
- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString*)currencyName currencyAmount:(int)amount inZone:(NSString*)zoneID {
    NSLog(@"AdColony zone %@ reward %@ %i %@", zoneID, success ? @"YES" : @"NO", amount, currencyName);
    
    if (success) {
        NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
        
        //Get currency balance from persistent storage and update it
        NSNumber* wrappedBalance = [storage objectForKey:kCurrencyBalance];
        NSUInteger balance = wrappedBalance && [wrappedBalance isKindOfClass:[NSNumber class]] ? [wrappedBalance unsignedIntValue] : 0;
        balance += amount;
        
        //Persist the currency balance
        [storage setValue:[NSNumber numberWithUnsignedLong:balance] forKey:kCurrencyBalance];
        [storage synchronize];
        
        //Post a notification so the rest of the app knows the balance changed
        [[NSNotificationCenter defaultCenter] postNotificationName:kCurrencyBalanceChange object:nil];
        
        [self checkAllFeatures];
    }
}*/

- (void)checkAllFeatures{
    // unlock all features
    if ([[AdColonyHelper sharedManager] isUnlocked]){
        unlockAmber = YES;
        unlockAll = YES;
        unlockBorders = YES;
        unlockLightFX = YES;
        unlockWatermarks = YES;
        
        [[NSUserDefaults standardUserDefaults] setBool:unlockAll forKey:@"unlockAll"];
        
        [[NSUserDefaults standardUserDefaults] setBool:unlockBorders forKey:@"unlockBorders"];
        
        [[NSUserDefaults standardUserDefaults] setBool:unlockLightFX forKey:@"unlockLightFX"];
        
        [[NSUserDefaults standardUserDefaults] setBool:unlockAmber forKey:@"unlockAmber"];
        
        [[NSUserDefaults standardUserDefaults] setBool:unlockWatermarks forKey:@"unlockWatermarks"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


@end
