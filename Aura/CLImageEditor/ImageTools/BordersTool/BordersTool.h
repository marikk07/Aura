

#import "CLImageToolBase.h"

NSArray *list;
NSString *bordersPath;

UIView *_workingView;
UIImage *_originalImage;

UIView *imageContainerView;

CGFloat width, height;

UIPinchGestureRecognizer *pinchGest;
UIPanGestureRecognizer *panGest;
UILabel *titleLabel;



@interface BordersTool : CLImageToolBase

@end
