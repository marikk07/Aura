//
//  TextView.h
//  Blink
//
//  Created by MacBook FV iMAGINATION on 17/09/14.
//  Copyright (c) 2014 Hubwester. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewEdit : UITextField
<
UITextFieldDelegate,
UITextViewDelegate
>


@property (nonatomic, strong) UIColor *outlineColor;
@property (nonatomic, assign) CGFloat outlineWidth;

@end
