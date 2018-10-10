//
//  IAPController.m
//  SnappStory
//
//  Created by MacBook FV iMAGINATION on 22/07/14.
//  Copyright (c) 2014 FV iMAGINATION. All rights reserved.
//

#import "IAPController.h"
#import "ASBanker.h"

#import "CLImageToolBase.h"
#import "Aura-Swift.h"

@interface IAPController ()
<
ASBankerDelegate
>
@property (strong, nonatomic) ASBanker *banker;
//@property (strong, nonatomic) NSArray *iapProductsList;
@property (strong, nonatomic) SKProduct *selectedProduct;

@end


@implementation IAPController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.banker) {
        self.banker.delegate = self;
    }
    
    NSLog(@"unlockALL:%d", unlockAll);
    NSLog(@"unlockBorders:%d", unlockBorders);
    NSLog(@"unlockLightFX:%d", unlockLightFX);
    NSLog(@"unlockAmber:%d", unlockAmber);
    
    NSLog(@"PROD.INT:%d", productInt);
    
    if (appDelegate.iapProductsList) {
        // Show iAP data
        [self setProductsInfo];
    } else {
        _actView.hidden = false;
        [self.banker fetchProducts:@[
                                     // IAP Products List
                                     @"aura.subscription", //index 0
                                     @"aura.b.unlockBorders2", // index 1
                                     @"aura.c.unlockLightFX2", //index 2
                                     @"aura.e.unlockAmber2" // index 3

                                     
                                     ]];
    }
    
    
    // Get the main screen iPhone size
    self.view.frame = [UIScreen mainScreen].bounds;
    NSLog(@"SCREEN SIZE: %.0f - %.0f", self.view.frame.size.width, self.view.frame.size.height);
    
    // IPHONE 4 & 5 ======================
    if (self.view.frame.size.width == 320) {
        _allFeaturesImg.frame = CGRectMake(0, 0, 320, 210);
        _bordersFeatureImg.frame = CGRectMake(self.view.frame.size.width, 0, 320, 210);
        _lightFXimg.frame = CGRectMake(self.view.frame.size.width   *2,   0, 320, 210);
        _amberImg.frame = CGRectMake(self.view.frame.size.width     *3,   0, 320, 210);
        
        _allFeaturesDesc.frame = CGRectMake(0, 210, 320, 88);
        _bordersDesc.frame = CGRectMake(self.view.frame.size.width,      210, 320, 88);
        _lightFXdesc.frame = CGRectMake(self.view.frame.size.width   *2, 210, 320, 88);
        _amberDesc.frame = CGRectMake(self.view.frame.size.width     *3, 210, 320, 88);
        
        _buyBordersOut.frame = CGRectMake(_bordersFeatureImg.frame.size.width*2 - 80,
                                          _bordersFeatureImg.frame.size.height - 36, 80, 36);
        _buyLightFXOut.frame = CGRectMake(_lightFXimg.frame.size.width*3 - 80,
                                          _lightFXimg.frame.size.height - 36, 80, 36);
        _buyAmberOut.frame = CGRectMake(_amberImg.frame.size.width*4 - 80,
                                        _amberImg.frame.size.height - 36, 80, 36);
   
        
    
    // IPHONE 6 =================================
    } else if (self.view.frame.size.width == 375) {
        _allFeaturesImg.frame = CGRectMake(0, 0, 375, 246);
        _bordersFeatureImg.frame = CGRectMake(self.view.frame.size.width, 0, 375, 246);
        _lightFXimg.frame = CGRectMake(self.view.frame.size.width   *2,   0, 375, 246);
        _amberImg.frame = CGRectMake(self.view.frame.size.width     *3,   0, 375, 246);

        _allFeaturesDesc.frame = CGRectMake(0, 246, 375, 103);
        _bordersDesc.frame = CGRectMake(self.view.frame.size.width,      246, 375, 103);
        _lightFXdesc.frame = CGRectMake(self.view.frame.size.width   *2, 246, 375, 103);
        _amberDesc.frame = CGRectMake(self.view.frame.size.width     *3, 246, 375, 103);

        _buyBordersOut.frame = CGRectMake(_bordersFeatureImg.frame.size.width*2 - 80,
                                          _bordersFeatureImg.frame.size.height - 36, 80, 36);
        _buyLightFXOut.frame = CGRectMake(_lightFXimg.frame.size.width*3 - 80,
                                          _lightFXimg.frame.size.height - 36, 80, 36);
        _buyAmberOut.frame = CGRectMake(_amberImg.frame.size.width*4 - 80,
                                          _amberImg.frame.size.height - 36, 80, 36);


    // IPHONE 6+ ================================
    } else if (self.view.frame.size.width == 414) {
        _allFeaturesImg.frame = CGRectMake(0, 0, 414, 272);
        _bordersFeatureImg.frame = CGRectMake(self.view.frame.size.width, 0, 414, 272);
        _lightFXimg.frame = CGRectMake(self.view.frame.size.width   *2,   0, 414, 272);
        _amberImg.frame = CGRectMake(self.view.frame.size.width     *3,   0, 414, 272);

        _allFeaturesDesc.frame = CGRectMake(0, 272, 441, 114);
        _bordersDesc.frame = CGRectMake(self.view.frame.size.width,      272, 414, 114);
        _lightFXdesc.frame = CGRectMake(self.view.frame.size.width   *2, 272, 441, 114);
        _amberDesc.frame = CGRectMake(self.view.frame.size.width     *3, 272, 441, 114);

        _buyBordersOut.frame = CGRectMake(_bordersFeatureImg.frame.size.width*2 - 100,
                                          _bordersFeatureImg.frame.size.height - 40, 100, 40);
        _buyLightFXOut.frame = CGRectMake(_lightFXimg.frame.size.width*3 - 100,
                                          _lightFXimg.frame.size.height - 40, 100, 40);
        _buyAmberOut.frame = CGRectMake(_amberImg.frame.size.width*4 - 100,
                                        _amberImg.frame.size.height - 40, 100, 40);

    }
    
    
    // Init scrollView and pageControl (place the number of IAP Products you have
    _scrollViewIAP.contentSize = CGSizeMake(_scrollViewIAP.frame.size.width * 4, 480);
    _pageControl.numberOfPages = 4;
    
    // Move the ScrollView to the Page of the selected IAP product
    [_scrollViewIAP setContentOffset: CGPointMake(self.view.frame.size.width *productInt, 44) animated: true];
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _banker = [ASBanker sharedInstance];
    
    // Set Labels and Buttons texts ===========
    [_restorePurchaseOutlet setTitle:NSLocalizedString(@"Restore Purchase", @"") forState:UIControlStateNormal];

    // ActIndicator start animating
    [_actIndicator startAnimating];
    _actView.hidden = true;
}



// ScrollView pagination
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollViewIAP.frame.size.width;
    int page = floor((_scrollViewIAP.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    
}


#pragma mark - BUTTONS =========================
- (IBAction)dismissButt:(id)sender {
    
    // Reset the productInt ======
    productInt = 0;
    
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)restorePurchaseButt:(id)sender {
   // [_IAPHelper restorePurchases];
    [self.banker restorePurchases];
    _actView.hidden = false;
}



/* IMPORTANT: BUTTONS ARE SORT IN ORDER OF APPEARANCE IN THE IAP SECTION IN iTUNES CONNECT */
- (IBAction)buyAllButt:(id)sender {
    productInt = 0;
    _actView.hidden = false;
    self.selectedProduct = [appDelegate.iapProductsList objectAtIndex:productInt];
    [self.banker purchaseItem:self.selectedProduct];
//    __weak typeof(self) weakSelf = self;
//    [[SubscriptionManager instance] subscribe:^(BOOL success) {
//        weakSelf.actView.hidden = true;
////        if (success) {
////            [weakSelf saveProductsBOOL];
////            [weakSelf bankerProvideContent:nil];
////        } else {
////            [weakSelf bankerPurchaseFailed:nil withError:nil];
////        }
//    }];
}
- (IBAction)buyBordersButt:(id)sender {
    productInt = 1;
    _actView.hidden = false;
    self.selectedProduct = [appDelegate.iapProductsList objectAtIndex:productInt];
    [self.banker purchaseItem:self.selectedProduct];
}
- (IBAction)buyLightFXButt:(id)sender {
    productInt = 2;
    _actView.hidden = false;
    self.selectedProduct = [appDelegate.iapProductsList objectAtIndex:productInt];
    [self.banker purchaseItem:self.selectedProduct];
}
- (IBAction)buyAmberButt:(id)sender {
    productInt = 3;
    _actView.hidden = false;
    self.selectedProduct = [appDelegate.iapProductsList objectAtIndex:productInt];
    [self.banker purchaseItem:self.selectedProduct];
}



-(void)setProductsInfo {

    // Set SKProducts based on their position in iTunes Connect
    SKProduct *AllFeaturesPr = [appDelegate.iapProductsList objectAtIndex:0];
    SKProduct *bordersPr = [appDelegate.iapProductsList objectAtIndex:1];
    SKProduct *lightFXPr = [appDelegate.iapProductsList objectAtIndex:2];
    SKProduct *amberPr = [appDelegate.iapProductsList objectAtIndex:3];
    
    
    // Set IAP Descriptions
    _allFeaturesDesc.text = AllFeaturesPr.localizedDescription;
    _bordersDesc.text = bordersPr.localizedDescription;
    _lightFXdesc.text = lightFXPr.localizedDescription;
    _amberDesc.text = amberPr.localizedDescription;

    
    _allFeaturesDesc.font =
    _bordersDesc.font =
    _lightFXdesc.font =
    _amberDesc.font = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:15];
    
    
    
    // IAP to unlock ALL FEATURES =======
    if (!unlockAll) {
        _unlockAllOut.enabled = true;
        NSString *unlocAllStr = [NSString stringWithFormat:@"UNLOCK ALL FOR %@!", AllFeaturesPr.localizedPrice];
        [_unlockAllOut setTitle:unlocAllStr forState:UIControlStateNormal];
    } else {
        _unlockAllOut.enabled = false;
        [_unlockAllOut setTitle:@"ALL FEATURES ARE UNLOCKED!" forState:UIControlStateNormal];
        _buyBordersOut.enabled = false;
        [_buyBordersOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
        _buyLightFXOut.enabled = false;
        [_buyLightFXOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
        _buyAmberOut.enabled = false;
        [_buyAmberOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
    }
    
    // IAP to unlock BORDERS =======
    if (!unlockBorders) {
        _buyBordersOut.enabled = true;
        [_buyBordersOut setTitle: bordersPr.localizedPrice forState:UIControlStateNormal];
    } else {
        _buyBordersOut.enabled = false;
        [_buyBordersOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
    }
    
    // IAP to unlock LIGHT FX =======
    if (!unlockLightFX) {
        _buyLightFXOut.enabled = true;
        [_buyLightFXOut setTitle:lightFXPr.localizedPrice forState:UIControlStateNormal];
    } else {
        _buyLightFXOut.enabled = false;
        [_buyLightFXOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
    }
    
    // IAP to unlock AMBER FILTERS =======
    if (!unlockAmber) {
        _buyAmberOut.enabled = true;
        [_buyAmberOut setTitle:amberPr.localizedPrice forState:UIControlStateNormal];
    } else {
        _buyAmberOut.enabled = false;
        [_buyAmberOut setTitle:@"PURCHASED" forState:UIControlStateNormal];
    }

}




#pragma mark - IAP DELEGATE METHODS ==============================

// iTunes Store connection failed...
- (void)bankerFailedToConnect {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchase", @"") message:NSLocalizedString(@"iTunes Store connection failed, try again!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
	_actView.hidden = true;
}

// NO IAP Products for this app...
- (void)bankerNoProductsFound {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchase", @"") message:NSLocalizedString(@"iTunes Store connection failed, try again!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
    _actView.hidden = true;
}

// IAP Product found
- (void)bankerFoundProducts:(NSArray *)products {
    
    if (appDelegate.iapProductsList) {
        appDelegate.iapProductsList = nil;
    }
    
    NSMutableArray *sortedProducts = [NSMutableArray arrayWithCapacity: 4];
    [sortedProducts addObjectsFromArray:products];
    
    for (SKProduct *product in products) {
        if ([product.productIdentifier isEqualToString:@"aura.subscription"]) {
            [sortedProducts replaceObjectAtIndex:0 withObject:product];
        } else if ([product.productIdentifier isEqualToString:@"aura.b.unlockBorders2"]) {
            [sortedProducts replaceObjectAtIndex:1 withObject:product];
        } else if ([product.productIdentifier isEqualToString:@"aura.c.unlockLightFX2"]) {
            [sortedProducts replaceObjectAtIndex:2 withObject:product];
        } else if ([product.productIdentifier isEqualToString:@"aura.e.unlockAmber2"]) {
            [sortedProducts replaceObjectAtIndex:3 withObject:product];
        }
    }
    
    appDelegate.iapProductsList = sortedProducts;
    NSLog(@"productsArr:%@", sortedProducts);
    
    [self setProductsInfo];
    
    _actView.hidden = true;
    
}

// Invalid IAP Products found...
- (void)bankerFoundInvalidProducts:(NSArray *)products {
    _actView.hidden = true;
}


// IAP payment successfully done!
- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:YES forKey:@"InAppPurchase"];
	[defaults synchronize];
	
    // Messages to be shown after successfull payment
    NSString *messageStr;
    switch (productInt) {
        case 0:
            messageStr = NSLocalizedString(@"You've unlocked ALL Features!", @"");
            break;
        case 1:
            messageStr = NSLocalizedString(@"You've unlocked Extra Borders!", @"");
            break;
        case 2:
            messageStr = NSLocalizedString(@"You've unlocked Extra LightFX's!", @"");
            break;
        case 3:
            messageStr = NSLocalizedString(@"You've unlocked Amber Filters!", @"");
            break;
        case 4:
            messageStr = NSLocalizedString(@"You've removed Watermark!", @"");
            break;
            
        default: break;
    }
    
    
	UIAlertView *av = [[UIAlertView alloc]
    initWithTitle:NSLocalizedString(@"Purchase successful!", @"")
    message:messageStr delegate:self
    cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
	[av show];
    
    _actView.hidden = true;
    
}

// IAP PAYMENT COMPLETE! ================
- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
    
    // Save IAP that has been made:
    [self saveProductsBOOL];
    _actView.hidden = true;
}


// IAP PURCHASE RESTORED! =============
- (void)bankerDidRestorePurchases {
    
    // Save IAP that has been made:
    [self saveProductsBOOL];
    _actView.hidden = true;
    
}

#pragma mark - SAVE PRODUCTS BOOL AFTER PURCHASE =============================
-(void)saveProductsBOOL {

    switch (productInt) {
        case 0:
            unlockAll = true;
            _unlockAllOut.enabled = false;
            [[NSUserDefaults standardUserDefaults] setBool:unlockAll forKey:@"unlockAll"];
            
            unlockBorders = true;
            _buyBordersOut.enabled = false;
            [[NSUserDefaults standardUserDefaults] setBool:unlockBorders forKey:@"unlockBorders"];
            
            unlockLightFX = true;
            _buyLightFXOut.enabled = false;
            [[NSUserDefaults standardUserDefaults] setBool:unlockLightFX forKey:@"unlockLightFX"];
            
            unlockAmber = true;
            _buyAmberOut.enabled = false;
            [[NSUserDefaults standardUserDefaults] setBool:unlockAmber forKey:@"unlockAmber"];

            unlockWatermarks = true;
            _buyWatermarksOut.enabled = false;
            [[NSUserDefaults standardUserDefaults] setBool:unlockWatermarks forKey:@"unlockWatermarks"];
            break;
            
        case 1:
            unlockBorders = true;
            [[NSUserDefaults standardUserDefaults] setBool:unlockBorders forKey:@"unlockBorders"];
            _buyBordersOut.enabled = false;
            break;
        case 2:
            unlockLightFX = true;
            [[NSUserDefaults standardUserDefaults] setBool:unlockLightFX forKey:@"unlockLightFX"];
            _buyLightFXOut.enabled = false;
            
        case 3:
            unlockAmber = true;
            [[NSUserDefaults standardUserDefaults] setBool:unlockAmber forKey:@"unlockAmber"];
            _buyAmberOut.enabled = false;
            break;
            
        case 4:
            unlockWatermarks = true;
            [[NSUserDefaults standardUserDefaults] setBool:unlockWatermarks forKey:@"unlockWatermarks"];
            _buyWatermarksOut.enabled = false;
            break;
            
            // Additional IAP Products here....
            //*************************************
            
            
            
        default: break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Recall method that will reset the Overlays List
    [self setProductsInfo];

}



// IAP Payment failed...
- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchase", @"") message:NSLocalizedString(@"Purchase has failed, sorry. Try again later!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
	[av show];
	
    _actView.hidden = true;
}

// IAP Purchase cancelled by the user...
- (void)bankerPurchaseCancelledByUser:(NSString *)productIdentifier {
    _actView.hidden = true;
}

// Restore Purchases failed...
- (void)bankerFailedRestorePurchases {
    _actView.hidden = true;
}


/*================== END IAP METHODS ==============================*/







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
