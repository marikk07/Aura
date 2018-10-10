

#import "ClassicBase.h"

@implementation ClassicBase

+ (NSString*)defaultIconImagePath
{
    return nil;
}

+ (NSArray*)subtools
{
    return nil;
}


+ (CGFloat)defaultDockedNumber
{
    return 0;
}


+ (NSString*)defaultTitle
{
    return @"ClassicBase";
}

+ (BOOL)isAvailable
{
    return NO;
}

+ (NSDictionary*)optionalInfo
{
    return nil;
}

#pragma mark-

+ (UIImage*)applyFilter:(UIImage*)image
{
    return image;
}

@end




 
#pragma mark- Default Filters ============

@interface ClassicEmptyFilter : ClassicBase
@end

@implementation ClassicEmptyFilter

+ (NSDictionary*)defaultFilterInfo  {

    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        defaultFilterInfo =
        @{
            @"ClassicEmptyFilter"     : @{@"name":@"ClassicEmptyFilter",     @"title":NSLocalizedStringWithDefaultValue(@"ClassicEmptyFilter_DefaultTitle",    nil, [CLImageEditorTheme bundle], @"None", @""),       @"version":@(0.0), @"dockedNum":@(0.0)},

            @"CLDefaultInstantFilter"   : @{@"name":@"CIPhotoEffectInstant",     @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultInstantFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Instant", @""),    @"version":@(7.0), @"dockedNum":@(1.0)},
            
            @"CLDefaultProcessFilter"   : @{@"name":@"CIPhotoEffectProcess",     @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultProcessFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Process", @""),    @"version":@(7.0), @"dockedNum":@(2.0)},
            
            @"CLDefaultTransferFilter"  : @{@"name":@"CIPhotoEffectTransfer",    @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTransferFilter_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Transfer", @""),   @"version":@(7.0), @"dockedNum":@(3.0)},
            
            @"CLDefaultSepiaFilter"     : @{@"name":@"CISepiaTone",              @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultSepiaFilter_DefaultTitle",    nil, [CLImageEditorTheme bundle], @"Sepia", @""),      @"version":@(5.0), @"dockedNum":@(4.0)},
            
            @"CLDefaultChromeFilter"    : @{@"name":@"CIPhotoEffectChrome",      @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultChromeFilter_DefaultTitle",   nil, [CLImageEditorTheme bundle], @"Chrome", @""),     @"version":@(7.0), @"dockedNum":@(5.0)},
            
            @"CLDefaultFadeFilter"      : @{@"name":@"CIPhotoEffectFade",        @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultFadeFilter_DefaultTitle",     nil, [CLImageEditorTheme bundle], @"Fade", @""),       @"version":@(7.0), @"dockedNum":@(6.0)},
            
            @"CLDefaultCurveFilter"     : @{@"name":@"CILinearToSRGBToneCurve",  @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultCurveFilter_DefaultTitle",    nil, [CLImageEditorTheme bundle], @"Curve", @""),      @"version":@(7.0), @"dockedNum":@(7.0)},
            
            @"CLDefaultTonalFilter"     : @{@"name":@"CIPhotoEffectTonal",       @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultTonalFilter_DefaultTitle",    nil,[CLImageEditorTheme bundle], @"Tonal", @""),      @"version":@(7.0), @"dockedNum":@(8.0)},
            
            @"CLDefaultMonoFilter"      : @{@"name":@"CIPhotoEffectMono",        @"title":NSLocalizedStringWithDefaultValue(@"CLDefaultMonoFilter_DefaultTitle",     nil, [CLImageEditorTheme bundle], @"Mono", @""),       @"version":@(7.0), @"dockedNum":@(9.0)},
            
            @"FreyaFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"FreyaFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Freya", @""),  @"version":@(7.0), @"dockedNum":@(11.0)},
            
            @"VialettoFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"VialettoFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Vialetto", @""),  @"version":@(7.0), @"dockedNum":@(12.0)},
            
            @"PeerFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"PeerFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Peer", @""),  @"version":@(7.0), @"dockedNum":@(13.0)},
            
            @"FioreFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"FioreFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Fiore", @""),  @"version":@(7.0), @"dockedNum":@(14.0)},
        
            @"MistFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"FioreFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Mist", @""),  @"version":@(7.0), @"dockedNum":@(15.0)},
            
            @"NovellaFilter" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"FioreFilter_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Novella", @""),  @"version":@(7.0), @"dockedNum":@(16.0)},
            
            
            
        };
    }
    return defaultFilterInfo;
}

+ (id)defaultInfoForKey:(NSString*)key
{
    return self.defaultFilterInfo[NSStringFromClass(self)][key];
}

+ (NSString*)filterName
{
    return [self defaultInfoForKey:@"name"];
}

#pragma mark- 

+ (NSString*)defaultTitle
{
    return [self defaultInfoForKey:@"title"];
}

+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= [[self defaultInfoForKey:@"version"] floatValue]);
}

+ (CGFloat)defaultDockedNumber
{
    return [[self defaultInfoForKey:@"dockedNum"] floatValue];
}

#pragma mark- 

+ (UIImage*)applyFilter:(UIImage *)image
{
    return [self filteredImage:image withFilterName:self.filterName andTitle:self.defaultTitle];
}



+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName andTitle: (NSString *)title
{
    // Empty Filter =======================
    if([title isEqualToString:@"None"]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
  //  NSLog(@"%@", [filter attributes]);
    
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat intensity;
    [filter setDefaults];
    
    // CIDotScreen Filter =======================
    if([filterName isEqualToString:@"CIDotScreen"]){
        // parameters
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
        [filter setValue:vct forKey:@"inputCenter"];
        
        [filter setValue:[NSNumber numberWithFloat:5.00] forKey:@"inputWidth"];
        [filter setValue:[NSNumber numberWithFloat:5.00] forKey:@"inputAngle"];
        [filter setValue:[NSNumber numberWithFloat:0.70] forKey:@"inputSharpness"];
    }
    
    // Freya Filter ==============================
    if([title isEqualToString:@"Freya"]){
        // parameters
        r = 15;
        g = 238;
        b = 148;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Vialetto Filter ==============================
    if([title isEqualToString:@"Vialetto"]){
        // parameters
        r = 70;
        g = 55;
        b = 199;
        intensity = 0.2;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Peer Filter ==============================
    if([title isEqualToString:@"Peer"]){
        // parameters
        r = 76;
        g = 199;
        b = 72;
        intensity = 0.2;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Fiore Filter ==============================
    if([title isEqualToString:@"Fiore"]){
        // parameters
        r = 180;
        g = 125;
        b = 75;
        intensity = 0.2;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Mist Filter ==============================
    if([title isEqualToString:@"Mist"]){
        // parameters
        r = 218;
        g = 179;
        b = 207;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Novella Filter ==============================
    if([title isEqualToString:@"Novella"]){
        // parameters
        r = 181;
        g = 205;
        b = 175;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end






@interface CLDefaultInstantFilter : ClassicEmptyFilter
@end
@implementation CLDefaultInstantFilter
@end

@interface CLDefaultProcessFilter : ClassicEmptyFilter
@end
@implementation CLDefaultProcessFilter
@end

@interface CLDefaultTransferFilter : ClassicEmptyFilter
@end
@implementation CLDefaultTransferFilter
@end

@interface CLDefaultSepiaFilter : ClassicEmptyFilter
@end
@implementation CLDefaultSepiaFilter
@end

@interface CLDefaultChromeFilter : ClassicEmptyFilter
@end
@implementation CLDefaultChromeFilter
@end

@interface CLDefaultFadeFilter : ClassicEmptyFilter
@end
@implementation CLDefaultFadeFilter
@end

@interface CLDefaultCurveFilter : ClassicEmptyFilter
@end
@implementation CLDefaultCurveFilter
@end

@interface CLDefaultTonalFilter : ClassicEmptyFilter
@end
@implementation CLDefaultTonalFilter
@end

@interface CLDefaultMonoFilter : ClassicEmptyFilter
@end
@implementation CLDefaultMonoFilter
@end

@interface FreyaFilter : ClassicEmptyFilter
@end
@implementation FreyaFilter
@end

@interface VialettoFilter : ClassicEmptyFilter
@end
@implementation VialettoFilter
@end

@interface FioreFilter : ClassicEmptyFilter
@end
@implementation FioreFilter
@end

@interface PeerFilter : ClassicEmptyFilter
@end
@implementation PeerFilter
@end

@interface MistFilter : ClassicEmptyFilter
@end
@implementation MistFilter
@end

@interface NovellaFilter : ClassicEmptyFilter
@end
@implementation NovellaFilter
@end