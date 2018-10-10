

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"

@protocol LoomyBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface LoomyBase : NSObject
<
CLImageToolProtocol,
LoomyBaseProtocol
>

@end
