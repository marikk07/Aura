

#import "LoomyFilters.h"

#import "LoomyBase.h"


@implementation LoomyFilters
{
    UIImage *_originalImage;
    
    UIScrollView *_menuScroll;
}

+ (NSArray*)subtools
{
    return [CLImageToolInfo toolsWithToolClass:[LoomyBase class]];
}

+ (NSString*)defaultTitle
{
   // return NSLocalizedStringWithDefaultValue(@"LoomyFilters_DefaultTitle", nil, [CLImageEditorTheme bundle], @"Loomy", @"");
    return false;
}


+ (BOOL)isAvailable
{
    return ([UIDevice iosVersion] >= 5.0);
   // return NO;
}


- (void)setup  {
    
    _originalImage = self.editor.imageView.image;
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    
    [self setFilterMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height - _menuScroll.top);
   
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cleanup  {
    
    [UIView animateWithDuration:kCLImageToolAnimationDuration
        animations:^{
        _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
        } completion:^(BOOL finished) {
        [_menuScroll removeFromSuperview];
        }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    completionBlock(self.editor.imageView.image, nil, nil);
}





#pragma mark - SET FILTERS MENU =====================

- (void)setFilterMenu
{
    CGFloat x = 0;
    CGFloat W = 50;
    
    UIImage *iconThumnail = [_originalImage aspectFill:CGSizeMake(50, 50)];
    
    for(CLImageToolInfo *info in self.toolInfo.sortedSubtools){
        if(!info.available) {
            continue;
        }
        
        CLToolbarMenuItem *view = [CLImageEditorTheme menuItemWithFrame:CGRectMake(x, 0, W, _menuScroll.height) target:self action:@selector(tappedFilterPanel:) toolInfo:info];
        [_menuScroll addSubview:view];
        x += W;
        
        if(view.iconImage==nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *iconImage = [self filteredImage:iconThumnail withToolInfo:info];
                [view performSelectorOnMainThread:@selector(setIconImage:) withObject:iconImage waitUntilDone:NO];
            });
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedFilterPanel:(UITapGestureRecognizer*)sender
{
    UIView *view = sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kCLImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self filteredImage:_originalImage withToolInfo:view.toolInfo];
        [self.editor.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    });
}

- (UIImage*)filteredImage:(UIImage*)image withToolInfo:(CLImageToolInfo*)info
{
    @autoreleasepool {
        Class filterClass = NSClassFromString(info.toolName);
        if([(Class)filterClass conformsToProtocol:@protocol(LoomyBaseProtocol)]){
            return [filterClass applyFilter:image];
        }
        return nil;
    }
}

@end
