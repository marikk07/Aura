

#import <Foundation/Foundation.h>
//#import <CoreImage/CoreImage.h>

#import "CLImageToolSettings.h"

@protocol CLFilterBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface CLFilterBase : NSObject<CLImageToolProtocol, CLFilterBaseProtocol>

@end
