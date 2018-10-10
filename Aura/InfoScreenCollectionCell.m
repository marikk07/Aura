//
//  InfoScreenCollectionCell.m
//  Aura
//
//  Created by Maryan Pasichniak on 10/10/18.
//  Copyright © 2018 Codex. All rights reserved.
//

#import "InfoScreenCollectionCell.h"

@implementation InfoScreenCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configWithImage:(UIImage *)image andTitle:(NSString *)title {
    self.imageView.image = image;
    self.titleLabel.text = title;
}


@end
