//
//  LZCollectionViewCell.h
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//
#import <UIKit/UIKit.h>

static NSString * lzCollectionViewCell = @"LZCollectionViewCell";

@interface LZCollectionViewCell : UICollectionViewCell

/**展示图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**title的背景*/
@property (weak, nonatomic) IBOutlet UIView *textBgView;
/**展示标题*/
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
