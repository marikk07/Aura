//
//  IAPController.h
//  SnappStory
//
//  Created by MacBook FV iMAGINATION on 22/07/14.
//  Copyright (c) 2014 FV iMAGINATION. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroScreen.h"

int productInt;



@interface IAPController : UIViewController
<
UIScrollViewDelegate
>
// View and ActivityIndicator
@property (weak, nonatomic) IBOutlet UIView *actView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;

// ScrollView and PageControl ======
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewIAP;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


// Buttons Outlet ============
@property (weak, nonatomic) IBOutlet UIButton *buyBordersOut;
@property (weak, nonatomic) IBOutlet UIButton *buyLightFXOut;
@property (weak, nonatomic) IBOutlet UIButton *buyAmberOut;
@property (weak, nonatomic) IBOutlet UIButton *buyWatermarksOut;

@property (weak, nonatomic) IBOutlet UIButton *unlockAllOut;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchaseOutlet;

// TextViews for IAP Products descriptions =======
@property (weak, nonatomic) IBOutlet UITextView *allFeaturesDesc;
@property (weak, nonatomic) IBOutlet UITextView *bordersDesc;
@property (weak, nonatomic) IBOutlet UITextView *lightFXdesc;
@property (weak, nonatomic) IBOutlet UITextView *amberDesc;
@property (weak, nonatomic) IBOutlet UITextView *watermarksDesc;

// Images for IAP Products
@property (weak, nonatomic) IBOutlet UIImageView *allFeaturesImg;
@property (weak, nonatomic) IBOutlet UIImageView *bordersFeatureImg;
@property (weak, nonatomic) IBOutlet UIImageView *lightFXimg;
@property (weak, nonatomic) IBOutlet UIImageView *amberImg;
@property (weak, nonatomic) IBOutlet UIImageView *watermarksImg;


// Labels
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end
