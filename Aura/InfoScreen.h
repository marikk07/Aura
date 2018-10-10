

#import <UIKit/UIKit.h>

@interface InfoScreen : UIViewController <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (assign, nonatomic) BOOL isFirstTimeStart;

// SCROLL VIEW & PAGE CONTROL =========
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



@end
