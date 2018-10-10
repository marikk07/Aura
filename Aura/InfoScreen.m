

#import "InfoScreen.h"
#import "IntroScreen.h"
#import "Aura-Swift.h"
#import "InfoScreenCollectionCell.h"

@interface InfoScreen ()

@property (nonatomic, strong) IBOutlet UIButton *restoreBtn;
@property (strong, nonatomic) NSArray *collectionImages;
@property (strong, nonatomic) NSArray *collectionTitles;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation InfoScreen

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
    
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    
    
    self.view.frame = [UIScreen mainScreen].bounds;
    NSLog(@"screeSize: %f - %f", self.view.frame.size.width, self.view.frame.size.height);
    
    // ScrollView & Images initialization
    
    _restoreBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _restoreBtn.titleLabel.numberOfLines = 2;
    _restoreBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([InfoScreenCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([InfoScreenCollectionCell class])];
    self.collectionImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"image1"], [UIImage imageNamed:@"image2"], [UIImage imageNamed:@"image3"], [UIImage imageNamed:@"image4"], nil];
    self.collectionTitles = [NSArray arrayWithObjects:@"Photographic Filters", @"Patterns as Backgrounds", @"Premium Stickers", @"Remarkable Fonts", nil];
    
    self.startButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.startButton.titleLabel.numberOfLines = 2;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.startButton.bounds;
    gradient.startPoint = CGPointMake(0.0, 0.5);
    gradient.endPoint = CGPointMake(1.0, 0.5);
    gradient.colors = @[(id)[UIColor colorWithRed:65.0 / 255 green:171.0 / 255 blue:241.0 / 255 alpha:1.0].CGColor, (id)[UIColor colorWithRed:241.0 / 255 green:65.0 / 255 blue:153.0 / 255 alpha:1.0].CGColor];
    [self.startButton.layer insertSublayer:gradient atIndex:0];
    
}
- (IBAction)startButt:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[SubscriptionManager instance] subscribe:^(BOOL success) {
        if (success) {
            [weakSelf goToIntroScreen];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"In-App Purchase", @"") message:NSLocalizedString(@"Purchase has failed, sorry. Try again later!", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button title") otherButtonTitles:nil];
            [av show];
        }
    }];
}

- (IBAction)restoreAction:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[SubscriptionManager instance] restorePurchases:^(BOOL success) {
        if (success) {
            [weakSelf goToIntroScreen];
        }
    }];
}


- (IBAction)privacyAction:(id)sender {
    NSString*myurl= @"http://codex.mobi/privacy-policy";
    NSURL *url = [NSURL URLWithString:myurl];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)termsAction:(id)sender {
    NSString*myurl= @"http://codex.mobi/terms-of-use";
    NSURL *url = [NSURL URLWithString:myurl];
    [[UIApplication sharedApplication] openURL:url];
}



- (IBAction)subscriptionTermsBtnAction:(id)sender {
    UIViewController *vc = [[SubscriptionTermsViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)goToIntroScreen {
    IntroScreen *introVC = [[IntroScreen alloc]initWithNibName:@"IntroScreen" bundle:nil];
    if (self.isFirstTimeStart != YES) {
        introVC.dontShowRatePopup = YES;
    }
    introVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:introVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollView.frame.size.width;
    
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InfoScreenCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([InfoScreenCollectionCell class]) forIndexPath:indexPath];
    [cell configWithImage:[self.collectionImages objectAtIndex:indexPath.row] andTitle:[self.collectionTitles objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake(collectionView.frame.size.width / 2.3, collectionView.frame.size.height);
    return cellSize;
}

@end
