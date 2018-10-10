

#import "VintyBase.h"

@implementation VintyBase

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
    return @"VintyBase";
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

@interface VintyEmptyFilter : VintyBase
@end

@implementation VintyEmptyFilter

+ (NSDictionary*)defaultFilterInfo  {

    NSDictionary *defaultFilterInfo = nil;
    if(defaultFilterInfo==nil){
        defaultFilterInfo =
        @{
            @"VintyEmptyFilter" : @{@"name":@"VintyEmptyFilter",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyEmptyFilter_DefaultTitle",    nil, [CLImageEditorTheme bundle], @"None", @""),  @"version":@(0.0), @"dockedNum":@(0.0)},
            
            
            
            @"VintyLotus" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyLotus_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Lotus", @""), @"version":@(7.0), @"dockedNum":@(1.0)},
            
            @"VintyHaze" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyHaze_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Haze", @""),  @"version":@(7.0), @"dockedNum":@(2.0)},
            
            @"VintyCoast" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyCoast_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Coast", @""),  @"version":@(7.0), @"dockedNum":@(3.0)},
            
            @"VintyKaley" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyKaley_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Kaley", @""),  @"version":@(7.0), @"dockedNum":@(4.0)},
            
            @"VintyTwist" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyTwist_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Twist", @""),  @"version":@(7.0), @"dockedNum":@(5.0)},
            
            @"VintyFay" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyFay_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Fay", @""),  @"version":@(7.0), @"dockedNum":@(6.0)},
            
            @"VintyVolpe" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyVolpe_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Volpe", @""),  @"version":@(7.0), @"dockedNum":@(7.0)},

            @"VintyServo" : @{@"name":@"CIFalseColor",
            @"title":NSLocalizedStringWithDefaultValue(@"VintyServo_DefaultTitle",  nil, [CLImageEditorTheme bundle], @"Servo", @""),  @"version":@(7.0), @"dockedNum":@(8.0)},
            
            
            
            
            
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
    CGFloat r2;
    CGFloat g2;
    CGFloat b2;
    

    
    // Lotus ==============================
    if([title isEqualToString:@"Lotus"]){
        // parameters
        r = 23; r2 = 255;
        g = 33; g2 = 250;
        b = 40; b2 = 249;
    
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
    }

    
    // Haze ==============================
    if([title isEqualToString:@"Haze"]){
        // parameters
        r = 15;    r2 = 255;
        g = 81;   b2 = 250;
        b = 77;   g2 = 249;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }

  
    // Coast ==============================
    if([title isEqualToString:@"Coast"]){
        // parameters
        r = 14;  r2 = 255;
        g = 41;   b2 = 250;
        b = 77;   g2 = 249;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }
    
    // Kaley ==============================
    if([title isEqualToString:@"Kaley"]){
        // parameters
        r = 60;  r2 = 255;
        g = 45;   b2 = 250;
        b = 45;   g2 = 249;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }
    

    // Twist ==============================
    if([title isEqualToString:@"Twist"]){
        // parameters
        r = 68;  r2 = 255;
        g = 68;   b2 = 204;
        b = 73;   g2 = 229;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }
    
    // Fay ==============================
    if([title isEqualToString:@"Fay"]){
        // parameters
        r = 31;  r2 = 255;
        g = 85;   b2 = 250;
        b = 76;   g2 = 249;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }
    
    // Volpe ==============================
    if([title isEqualToString:@"Volpe"]){
        // parameters
        r = 82; r2 = 255;
        g = 42; g2 = 255;
        b = 34;  b2 = 255;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
    }
    
    // Servo ==============================
    if([title isEqualToString:@"Servo"]){
        // parameters
        r = 1;  r2 = 255;
        g = 1;   b2 = 250;
        b = 10;   g2 = 249;
        
        [filter setValue:[CIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:0.3] forKey:@"inputColor0"];
        [filter setValue:[CIColor colorWithRed:r2/255.0 green:g2/255.0 blue:b2/255.0 alpha:0.8] forKey:@"inputColor1"];
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
@interface VintyLotus : VintyEmptyFilter
@end
@implementation VintyLotus
@end

@interface VintyHaze : VintyEmptyFilter
@end
@implementation VintyHaze
@end

@interface VintyCoast : VintyEmptyFilter
@end
@implementation VintyCoast
@end

@interface VintyKaley : VintyEmptyFilter
@end
@implementation VintyKaley
@end

@interface VintyTwist : VintyEmptyFilter
@end
@implementation VintyTwist
@end

@interface VintyFay : VintyEmptyFilter
@end
@implementation VintyFay
@end

@interface VintyVolpe : VintyEmptyFilter
@end
@implementation VintyVolpe
@end

@interface VintyServo : VintyEmptyFilter
@end
@implementation VintyServo
@end



