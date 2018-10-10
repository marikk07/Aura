

#import "CLImageToolInfo.h"

@protocol CLImageToolProtocol;

@interface CLImageToolInfo (Private)

@property (nonatomic, strong) NSString *toolName;

+ (CLImageToolInfo*)toolInfoForToolClass:(Class<CLImageToolProtocol>)toolClass;
+ (NSArray*)toolsWithToolClass:(Class<CLImageToolProtocol>)toolClass;

@end
