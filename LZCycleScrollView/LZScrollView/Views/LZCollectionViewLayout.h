//
//  LZCollectionViewLayout.h
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const AC_UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const AC_UICollectionElementKindSectionFooter;

@interface LZCollectionViewLayout : UICollectionViewFlowLayout

@property (assign, nonatomic) NSInteger numberOfColumns;//瀑布流有列
@property (assign, nonatomic) CGFloat cellDistance;//cell之间的间距
@property (assign, nonatomic) CGFloat topAndBottomDustance;//cell 到顶部 底部的间距
@property (assign, nonatomic) CGFloat headerViewHeight;//头视图的高度
@property (assign, nonatomic) CGFloat footViewHeight;//尾视图的高度
@property (nonatomic, assign) CGFloat  startY;

@end
