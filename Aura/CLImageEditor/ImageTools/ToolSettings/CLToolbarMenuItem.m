

#import "CLToolbarMenuItem.h"

#import "CLImageEditorTheme+Private.h"
#import "UIView+Frame.h"

@implementation CLToolbarMenuItem
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = frame.size.width;
        

        
        /*==========================================
         Toolbar Icons Settings
        ===========================================*/
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, W-20, W-20)];
        _iconView.clipsToBounds = YES;
      //  _iconView.layer.cornerRadius = _iconView.bounds.size.width/2;
        _iconView.backgroundColor = [UIColor clearColor];
        //[UIColor colorWithRed:48.0/255.0 green:55.0/255.0 blue:59.0/255.0 alpha:1.0];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];

        
        
        /*==========================================
         Toolbar Text Settings
         ===========================================*/
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _iconView.bottom + 1, W, 16)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action toolInfo:(CLImageToolInfo*)toolInfo
{
    self = [self initWithFrame:frame];
    if(self){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:gesture];
        
        self.toolInfo = toolInfo;
    }
    return self;
}

- (NSString*)title
{
    return _titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (UIImage*)iconImage
{
    return _iconView.image;
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconView.image = iconImage;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.alpha = (userInteractionEnabled) ? 1 : 0.3;
}

- (void)setToolInfo:(CLImageToolInfo *)toolInfo
{
    [super setToolInfo:toolInfo];
    
    self.title = self.toolInfo.title;
    if(self.toolInfo.iconImagePath){
        self.iconImage = self.toolInfo.iconImage;
   
    } else {
        self.iconImage = nil;
    }
}

- (void)setSelected:(BOOL)selected
{
    if(selected != _selected){
        _selected = selected;
        if(selected){
            self.backgroundColor = [CLImageEditorTheme toolbarSelectedButtonColor];
        }
        else{
            self.backgroundColor = [UIColor clearColor];
        }
    }
}

@end

