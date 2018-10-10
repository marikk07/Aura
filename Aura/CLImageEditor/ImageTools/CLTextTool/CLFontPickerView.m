

#import "CLFontPickerView.h"

#import "UIView+Frame.h"
#import "CLPickerView.h"
#import "TextViewEdit.h"

#import "SharingScreen.h"

const CGFloat kCLFontPickerViewConstantFontSize = 14;
const CGFloat kFontConstantFontSize = 14;

@interface CLFontPickerView()
<
CLPickerViewDelegate,
CLPickerViewDataSource
>
@end

@implementation CLFontPickerView
{
    CLPickerView *_pickerView;
    
    UITableView *fontTableView;
    NSArray *fontList2;
    TextViewEdit *textView;

}

/*
+ (NSArray*)allFontList  {
    
    NSMutableArray *mutableFontList = [NSMutableArray array];
    
    
    //===  July 8th 2014: UNLOCKED ALL FONTS! ==== /
    /===============================================

        _fontList = [NSArray arrayWithObjects:
    
                     @"Always Together",
                     @"UpperEastSide",
                     @"Snickles",
                     @"Sigmar",
                     @"QuigleyWiggly",
                     @"Pacifico",
                     @"Grand Hotel",
                     @"Boston Traffic",
                     @"BlackJackRegular",
                     @"Bebas Neue",
                     @"ALusine",
                     @"Alpha Echo",
                     @"FortySecondStreetHB",
                     @"Geotica 2012",
                     @"Lobster 1.4",
                     @"Metropolis 1920",
                     @"5th Grade Cursive",
                     @"Alpha54",
                     @"Arenq",
                     @"Blackout",
                     @"Boutiques of Merauke",
                     @"Candy Stripe (BRK)",
                     @"SeasideResortNF",
                     @"Arabella",
                     @"Blenda Script",
                     @"BurnstownDam-Regular",
                     @"CarbonBl-Regular",
                     @"Euphoria Script",
                     @"GoodTimesRg-Regular",
                     @"Lily Script One",
                     
                     
                     nil];
    
    
    for (int i = 0; i < [_fontList count]; i++) {
        NSString *fontNameStr = [_fontList objectAtIndex:i];
        [mutableFontList addObject:[UIFont fontWithName:fontNameStr size:14]];
    }
    
    
    return [mutableFontList sortedArrayUsingDescriptors:
    @[[NSSortDescriptor sortDescriptorWithKey:@"fontName" ascending:YES]]];
}

*/


+ (NSArray*)defaultSizes
{
    return @[@8, @10, @12, @14, @16, @18, @20, @24, @28, @32, @38, @44, @50];
}


+ (UIFont*)defaultFont
{
    // Default Initial Font
    return [UIFont fontWithName:@"Always Together"size:kCLFontPickerViewConstantFontSize];
}

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;

        
        fontList2 = @[
                     @"Always Together",
                     @"UpperEastSide",
                     @"Snickles",
                     @"Sigmar",
                     @"QuigleyWiggly",
                     @"Pacifico",
                     @"Grand Hotel",
                     @"Boston Traffic",
                     @"BlackJackRegular",
                     @"Bebas Neue",
                     @"ALusine",
                     @"Alpha Echo",
                     @"FortySecondStreetHB",
                     @"Geotica 2012",
                     @"Lobster 1.4",
                     @"Metropolis 1920",
                     @"5th Grade Cursive",
                     @"Alpha54",
                     @"Arenq",
                     @"Blackout",
                     @"Boutiques of Merauke",
                     @"Candy Stripe (BRK)",
                     @"SeasideResortNF",
                     @"Arabella",
                     @"Blenda Script",
                     @"BurnstownDam-Regular",
                     @"CarbonBl-Regular",
                     @"Euphoria Script",
                     @"GoodTimesRg-Regular",
                     @"Lily Script One",
                     
                     ];

        
        fontTableView = [[UITableView alloc]initWithFrame: self.bounds style:UITableViewStylePlain];
        
        fontTableView.rowHeight = 44;
        
        fontTableView.scrollEnabled = YES;
        fontTableView.showsVerticalScrollIndicator = YES;
        fontTableView.userInteractionEnabled = YES;
        fontTableView.bounces = YES;
        
        fontTableView.delegate = self;
        fontTableView.dataSource = self;

        /*
        _fontList = [self.class allFontList];
       // NSLog(@"FONTS LIST:  %@",_fontList);
        
        _fontSizes = [self.class defaultSizes];
        self.font = [self.class defaultFont];
        */
        
        
        [self addSubview:fontTableView];
        
        /*
        _pickerView = [[CLPickerView alloc] initWithFrame:self.bounds];
        _pickerView.center = CGPointMake(self.width/2, self.height/2);
        _pickerView.backgroundColor = [UIColor clearColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
         [self addSubview:_pickerView];

        _fontList = [self.class allFontList];
        NSLog(@"FONTS LIST:  %@",_fontList);
        
        _fontSizes = [self.class defaultSizes];
        self.font = [self.class defaultFont];
         */
        }
    
    return self;
}


#pragma mark - FONT TABLEVIEW DELEGATES ============
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return [fontList2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *fontStr = [fontList2 objectAtIndex:indexPath.row];
    cell.textLabel.text = [fontList2 objectAtIndex:indexPath.row];

    cell.textLabel.font = [UIFont fontWithName:fontStr size:kFontConstantFontSize];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fontStr = [fontList2 objectAtIndex: indexPath.row];
    
    textView.font = [UIFont fontWithName:fontStr size:17];
    //[tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"font: %@", fontStr);
    
}




- (void)setForegroundColor:(UIColor *)foregroundColor
{
    _pickerView.foregroundColor = foregroundColor;
}

- (UIColor*)foregroundColor
{
    return _pickerView.foregroundColor;
}


- (void)setFontList:(NSArray *)fontList
{
    if(fontList != _fontList){
        _fontList = fontList;
        [_pickerView reloadComponent:0];
    }
}

- (void)setFontSizes:(NSArray *)fontSizes
{
    if(fontSizes != _fontSizes){
        _fontSizes = fontSizes;
        [_pickerView reloadComponent:1];
    }
}

- (void)setFont:(UIFont *)font
{
    UIFont *tmp = [font fontWithSize:kCLFontPickerViewConstantFontSize];
    
    NSInteger fontIndex = [_fontList indexOfObject: tmp];
    if(fontIndex==NSNotFound)
    {
        fontIndex = 0;
    }
    
    NSInteger sizeIndex = 0;
    for(sizeIndex=0; sizeIndex < _fontSizes.count; sizeIndex++){
        if(font.pointSize <= [_fontSizes[sizeIndex] floatValue]){
            break;
        }
    }
    
    [_pickerView selectRow:fontIndex inComponent:0 animated:NO];
    [_pickerView selectRow:sizeIndex inComponent:1 animated:NO];
}

- (UIFont*)font {
    
    UIFont *font = _fontList[[_pickerView selectedRowInComponent:0]];
    CGFloat size = [_fontSizes[[_pickerView selectedRowInComponent:1]] floatValue];
    return [font fontWithSize:size];
}

- (void)setSizeComponentHidden:(BOOL)sizeComponentHidden
{
    _sizeComponentHidden = sizeComponentHidden;
    
    [_pickerView setNeedsLayout];
}

#pragma mark- UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(CLPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(CLPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _fontList.count;
        case 1:
            return _fontSizes.count;
    }
    return 0;
}

#pragma mark- UIPickerViewDelegate

- (CGFloat)pickerView:(CLPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.height/3;
}

- (CGFloat)pickerView:(CLPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat ratio = self.sizeComponentHidden ? 1 : 0.8;
    switch (component) {
        case 0:
            return self.width*ratio;
        case 1:
            return self.width*(1-ratio);
    }
    return 0;
}

- (UIView*)pickerView:(CLPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = nil;
    
    if([view isKindOfClass:[UILabel class]]){
        lbl = (UILabel *)view;
    
    } else {
        CGFloat W = [self pickerView:pickerView widthForComponent:component];
        CGFloat H = [self pickerView:pickerView rowHeightForComponent:component];
        CGFloat dx = 10;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(dx, 0, W-2*dx, H)];
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        lbl.minimumScaleFactor = 0.5;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [UIColor colorWithRed:41.0/255.0 green:41.0/255.0 blue:41.0/255.0 alpha:1];
    }
    
    switch (component) {
        case 0:
            lbl.font = _fontList[row];
            if(self.text.length > 0){
                lbl.text = self.text;
            } else {
                lbl.text = [NSString stringWithFormat:@"%@", lbl.font.fontName];
            }
            break;
        
        case 1:
            lbl.font = [UIFont systemFontOfSize:kCLFontPickerViewConstantFontSize];
            lbl.text = [NSString stringWithFormat:@"%@", self.fontSizes[row]];
            break;
        
            
        default: break;
    }
    
    return lbl;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(fontPickerView:didSelectFont:)]){
        [self.delegate fontPickerView:self didSelectFont:self.font];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRow:(NSIndexPath *)indexPath inComponent:(NSInteger)component {
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.delegate fontPickerView:self didSelectFont:self.font];
    }
}

@end
