


#import "CLImageToolBase.h"

@implementation CLImageToolBase

- (id)initWithImageEditor:(_CLImageEditorViewController*)editor withToolInfo:(CLImageToolInfo*)info
{
    self = [super init];
    if(self){
        self.editor   = editor;
        self.toolInfo = info;
    }
    return self;
}

+ (NSString*)defaultIconImagePath
{
    return [NSString stringWithFormat:@"%@.bundle/%@/icon.png", [CLImageEditorTheme bundleName], NSStringFromClass([self class])];
}

+ (CGFloat)defaultDockedNumber
{
    // Image tools are sorted according to the array below
    NSArray *tools = @[
                       
                /*===July 8th 2014: Added following tools ===*/
                       @"Adjustment",
                       @"LightFXTool",
                       @"ClassicFilters",
                       @"LoomyFilters",
                       @"VintyFilters",
                     //  @"CLBrightnessTool",
                     //  @"CLSaturationTool",
                     //  @"CLContrastTool",
                     //  @"ExposureTool",
                     //  @"SharpnessTool",
                       
                     //  @"CLFilterTool",
                       @"CLEffectTool",
                       @"CLBlurTool",
                       @"CLRotateTool",
                       @"CLResizeTool",
                       @"CLClippingTool",
                       @"CLToneCurveTool",
                       @"CLStickerTool",
                       
                       @"DesignsTool",
                       
                       
                       @"CLFramesTool",
                       @"BordersTool",
                       @"CLTextTool",

                       ];
    return [tools indexOfObject:NSStringFromClass(self)];
}

+ (NSArray*)subtools
{
    return nil;
}

+ (NSString*)defaultTitle
{
    return @"DefaultTitle";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark - SETUP ====================

- (void)setup
{


}

- (void)cleanup
{
    
}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}



@end
