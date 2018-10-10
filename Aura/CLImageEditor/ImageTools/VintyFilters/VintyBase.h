

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"

@protocol VintyBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface VintyBase : NSObject
<
CLImageToolProtocol,
VintyBaseProtocol
>

@end
