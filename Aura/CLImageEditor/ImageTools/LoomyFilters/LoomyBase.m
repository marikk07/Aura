
#import "LoomyBase.h"

#import "IntroScreen.h"

@implementation LoomyBase


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
    return @"LoomyBase";
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

@interface LoomyEmptyFilter : LoomyBase
@end

@implementation LoomyEmptyFilter

+ (NSDictionary*)defaultFilterInfo  {

    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        defaultFilterInfo =
        @{
            @"LoomyEmptyFilter" : @{@"name":@"LoomyEmptyFilter",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyEmptyFilter_DefaultTitle",    nil, [CLImageEditorTheme bundle], @"None", @""),  @"version":@(0.0), @"dockedNum":@(0.0)},
            
            
            
            @"LoomyStartdust" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyStartdust_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Stardust", @""), @"version":@(7.0), @"dockedNum":@(1.0)},
            
            @"LoomyTitan" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyTitan_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Titan", @""),  @"version":@(7.0), @"dockedNum":@(2.0)},
            
            @"LoomyDean" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyDean_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Dean", @""),  @"version":@(7.0), @"dockedNum":@(3.0)},
            
            @"LoomyDuro" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyDuro_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Duro", @""),  @"version":@(7.0), @"dockedNum":@(4.0)},
            
            @"LoomyLumo" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyLumo_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Lumo", @""),  @"version":@(7.0), @"dockedNum":@(5.0)},
            
            @"LoomySincere" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomySincere_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Sincere", @""),  @"version":@(7.0), @"dockedNum":@(6.0)},
            
            @"LoomyFare" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyFare_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Fare", @""),  @"version":@(7.0), @"dockedNum":@(7.0)},

            @"LoomyVince" : @{@"name":@"CIColorMonochrome",
            @"title":NSLocalizedStringWithDefaultValue(@"LoomyVince_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Vince", @""),  @"version":@(7.0), @"dockedNum":@(8.0)},
            
            
            
            
            
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
    if([title isEqualToString:@"None"]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    
    /*========= FILTERS ATTRIBUTES TO EDIT AS YOU WANT =============*/
    
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat intensity;
    
    
    // Stardust ==============================
    if([title isEqualToString:@"Stardust"]){
        // parameters
        r = 255;
        g = 200;
        b = 191;
        intensity = 0.8;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }

    // Titan ==============================
    if([title isEqualToString:@"Titan"]){
        // parameters
        r = 141;
        g = 151;
        b = 215;
        intensity = 0.3;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }

    // Dean ==============================
    if([title isEqualToString:@"Dean"]){
        // parameters
        r = 255;
        g = 239;
        b = 191;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Duro ==============================
    if([title isEqualToString:@"Duro"]){
        // parameters
        r = 135;
        g = 139;
        b = 130;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Lumo ==============================
    if([title isEqualToString:@"Lumo"]){
        // parameters
        r = 219;
        g = 216;
        b = 208;
        intensity = 0.3;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Sincere ==============================
    if([title isEqualToString:@"Sincere"]){
        // parameters
        r = 209;
        g = 171;
        b = 165;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Fare ==============================
    if([title isEqualToString:@"Fare"]){
        // parameters
        r = 252;
        g = 232;
        b = 227;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    // Vince ==============================
    if([title isEqualToString:@"Vince"]){
        // parameters
        r = 255;
        g = 204;
        b = 153;
        intensity = 0.6;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0] forKey:@"inputColor"];
        [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    }
    
    
    /*==============================================================*/
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

@end


#pragma mark - FILTER BUTTONS IMPLENTATIONS =============
@interface LoomyStartdust : LoomyEmptyFilter
@end
@implementation LoomyStartdust
@end

@interface LoomyTitan : LoomyEmptyFilter
@end
@implementation LoomyTitan
@end

@interface LoomyDean : LoomyEmptyFilter
@end
@implementation LoomyDean
@end

@interface LoomyDuro : LoomyEmptyFilter
@end
@implementation LoomyDuro
@end

@interface LoomyLumo : LoomyEmptyFilter
@end
@implementation LoomyLumo
@end

@interface LoomySincere : LoomyEmptyFilter
@end
@implementation LoomySincere
@end

@interface LoomyFare : LoomyEmptyFilter
@end
@implementation LoomyFare
@end

@interface LoomyVince : LoomyEmptyFilter
@end
@implementation LoomyVince
@end



