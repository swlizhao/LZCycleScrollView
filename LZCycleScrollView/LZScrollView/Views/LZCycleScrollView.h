//
//  LZCycleScrollView.h
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZCollectionViewCell.h"
#import "LZPageControl.h"

typedef void(^LZCycleViewItemClick)(NSInteger index);

@protocol LZCycleScrollViewDelegate <NSObject>

- (void)lzCycleViewDidSelectItem:(NSInteger)index;

@end

@interface LZCycleScrollView : UIView

/**
 *  titlesGroup：每张图片对应的标题数组
 */
@property(nonatomic,strong)NSArray <NSString *> *titlesGroup;

/**
 *  imgURLStringGroup：网络图片数组
 */
@property(nonatomic,strong)NSArray <NSString *> * imgURLStringGroup;

/**
 *  localImageGroup： 本地图片数组,UIImage类型
 */
@property(nonatomic,strong)NSArray <UIImage *> * localImageGroup;

/**
 *  localImageUrlGroup  本地图片，NSString类型
 */
@property(nonatomic,strong)NSArray <NSString *> *localImageUrlGroup;

/**
 *  placeholderImage  图片占位符
 */
@property (nonatomic, strong) UIImage *placeholderImage;

@property(nonatomic,assign)id <LZCycleScrollViewDelegate> delegate;

/**
 * cycleViewItemClickBlock 点击item位置
 */
@property(nonatomic,copy)LZCycleViewItemClick cycleViewItemClickBlock;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 * 移除定时器
 */
- (void)removeTimer;


@end
