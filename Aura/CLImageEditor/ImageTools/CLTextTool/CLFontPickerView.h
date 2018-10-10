


#import <UIKit/UIKit.h>

NSArray *_fontList;


@protocol CLFontPickerViewDelegate;

@interface CLFontPickerView : UIView
<
UITableViewDataSource, UITableViewDelegate
>


@property (nonatomic, weak) id<CLFontPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *fontSizes;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL sizeComponentHidden;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIColor *textColor;

@end


@protocol CLFontPickerViewDelegate <NSObject>
@optional
- (void)fontPickerView:(CLFontPickerView *)pickerView didSelectFont:(UIFont*)font;
- (void)tableView:(UITableView *)tableView didSelectRow:(NSIndexPath *)indexPath inComponent:(NSInteger)component;
@end