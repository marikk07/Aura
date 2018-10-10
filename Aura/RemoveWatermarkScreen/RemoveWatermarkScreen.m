


#import "RemoveWatermarkScreen.h"
#import "IAPController.h"
#import "ASBanker.h"


@interface RemoveWatermarkScreen ()
<
ASBankerDelegate
>
{
}
@property (strong, nonatomic) ASBanker *banker;
//@property (strong, nonatomic) NSArray *iapProductsList;

-(void)populateIAP;
-(NSString*)iAPMessage;
-(NSString*)iAPCaption;
-(NSString*)buttonCaption;

@end

@implementation RemoveWatermarkScreen
@synthesize imagePassed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.removeWatermarkButton.clipsToBounds = YES;
    self.removeWatermarkButton.layer.cornerRadius = 27.0;

    self.unlockAllFeaturesButton.clipsToBounds = YES;
    self.unlockAllFeaturesButton.layer.cornerRadius = 27.0;

    self.backView.layer.masksToBounds = NO;
//    self.backView.layer.shadowOffset = CGSizeMake(-15, 20);
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowRadius = 20;
    self.backView.layer.shadowOpacity = 1.0;
    self.backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.backView.bounds].CGPath;
    
    //configure blur view
    self.backView.dynamic = NO;
    self.backView.tintColor = [UIColor blackColor];
//    self.backView.tintColor = [UIColor colorWithRed:0 green:0.5 blue:0.5 alpha:1];
    self.backView.contentMode = UIViewContentModeBottom;

    _previewImage.image = imagePassed;
    
    _banker = [ASBanker sharedInstance];
    
    self.screenCaptionLabel.text = [self iAPCaption];
    self.screenMessageLabel.text = [self iAPMessage];
    
    _actView.hidden = true;
}

-(void)viewDidLayoutSubviews {
    //take snapshot, then move off screen once complete
    [self.backView updateAsynchronously:YES completion:^{
        //        self.blurView.frame = CGRectMake(0, 568, 320, 0);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.banker) {
        self.banker.delegate = self;
    }
    if (appDelegate.iapProductsList) {
        // Show iAP data
        [self populateIAP];
    } else {
        // Load iAP data
        _actView.hidden = false;
        [self.banker fetchProducts:@[
                                     // IAP Products List
                                     @"aura.a.unlockAll2", //index 0
                                     @"aura.b.unlockBorders2", // index 1
                                     @"aura.c.unlockLightFX2", //index 2
                                     @"aura.e.unlockAmber2", // index 3
                                     @"aura.e.unlockWatermarks2", // index 4
                                     
                                     ]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)populateIAP {
    if (appDelegate.iapProductsList != nil) {
        @try {
            SKProduct *AllFeaturesPr = [appDelegate.iapProductsList objectAtIndex:0];
            SKProduct *pr = [appDelegate.iapProductsList objectAtIndex:self.iAPIndex];
            
            NSString *allTitle = [@"Unlock all features for " stringByAppendingString:AllFeaturesPr.localizedPrice];
            [self.unlockAllFeaturesButton setTitle:allTitle forState:UIControlStateNormal];
            
            NSString *prTitle = [[self buttonCaption] stringByAppendingString:pr.localizedPrice];
            [self.removeWatermarkButton setTitle:prTitle forState:UIControlStateNormal];
            
        }
        @catch (NSException *exception) { }
    }
}

-(NSString*)iAPMessage {
    // Set random messages for users to drive them to make IAP
    switch (self.iAPIndex) {
        case 1:
            return @"Unlock new Borders and share amazing pictures on Instagram!";
            break;
        case 2:
            return @"Unlock LightFX and feel like a professional photograper!";
            break;
        case 3:
            return @"Unlock Amber and Loomy filters and enhance your photos like you've never done before!";
            break;
        case 4:
            return @"Remove \"AURA\" Watermark\r\n and feel free to share your photos!";
            break;
            
        default:
            return @"";
            break;
    }
}

-(NSString*)iAPCaption {
    // Set random messages for users to drive them to make IAP
    switch (self.iAPIndex) {
        case 1:
            return @"Unlock new Borders";
            break;
        case 2:
            return @"Unlock LightFX";
            break;
        case 3:
            return @"Unlock Amber and Loomy filters";
            break;
        case 4:
            return @"Remove Watermark";
            break;
            
        default:
            return @"";
            break;
    }
}

-(NSString*)buttonCaption {
    // Set random messages for users to drive them to make IAP
    switch (self.iAPIndex) {
        case 1:
            return @"Unlock new Borders for ";
            break;
        case 2:
            return @"Unlock LightFX for ";
            break;
        case 3:
            return @"Unlock Amber and Loomy filters for ";
            break;
        case 4:
            return @"Remove Watermark for ";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - CANCEL BUTTON ============================
- (IBAction)cancelButt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action buttons
- (IBAction)removeWatermarkButt:(id)sender {
    productInt = self.iAPIndex;
    IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
    [self presentViewController: iapVC animated:true completion:nil];

}

- (IBAction)enableAllFeaturesButt:(id)sender {
    productInt = 0;
    IAPController *iapVC = [[IAPController alloc]initWithNibName:@"IAPController" bundle:nil];
    [self presentViewController: iapVC animated:true completion:nil];

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
    
    appDelegate.iapProductsList = [NSArray arrayWithArray:products];
    NSLog(@"productsArr:%@", products);
    
    [self populateIAP];

    _actView.hidden = true;
}

// Invalid IAP Products found...
- (void)bankerFoundInvalidProducts:(NSArray *)products {
    _actView.hidden = true;
}


// IAP payment successfully done!
- (void)bankerProvideContent:(SKPaymentTransaction *)paymentTransaction {
}

// IAP PAYMENT COMPLETE! ================
- (void)bankerPurchaseComplete:(SKPaymentTransaction *)paymentTransaction {
}


// IAP PURCHASE RESTORED! =============
- (void)bankerDidRestorePurchases {
}

#pragma mark - SAVE PRODUCTS BOOL AFTER PURCHASE =============================

// IAP Payment failed...
- (void)bankerPurchaseFailed:(NSString *)productIdentifier withError:(NSString *)errorDescription {
}

// IAP Purchase cancelled by the user...
- (void)bankerPurchaseCancelledByUser:(NSString *)productIdentifier {
}

// Restore Purchases failed...
- (void)bankerFailedRestorePurchases {
}


/*================== END IAP METHODS ==============================*/

@end
