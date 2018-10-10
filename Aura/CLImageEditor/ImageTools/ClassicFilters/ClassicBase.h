

#import <Foundation/Foundation.h>

#import "CLImageToolSettings.h"

@protocol ClassicBaseProtocol <NSObject>

@required
+ (UIImage*)applyFilter:(UIImage*)image;

@end


@interface ClassicBase : NSObject
<
CLImageToolProtocol,
ClassicBaseProtocol
>

@end
