//
//  InfoScreenCollectionCell.h
//  Aura
//
//  Created by Maryan Pasichniak on 10/10/18.
//  Copyright © 2018 Codex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfoScreenCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)configWithImage:(UIImage *)image andTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
