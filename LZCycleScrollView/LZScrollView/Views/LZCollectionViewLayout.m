//
//  LZCollectionViewLayout.m
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//

#import "LZCollectionViewLayout.h"

@interface LZCollectionViewLayout ()

@property (strong, nonatomic) NSMutableDictionary *cellLayoutInfo; /**保存cell的布局*/
@property (strong, nonatomic) NSMutableDictionary *headLayoutInfo;/**保存头视图的布局*/
@property (strong, nonatomic) NSMutableDictionary *footLayoutInfo;/**保存尾视图的布局*/
@property (strong, nonatomic) NSMutableArray *shouldanimationArr;//记录需要添加动画的NSIndexPath
@end

@implementation LZCollectionViewLayout


- (instancetype)init  {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {

}
/*

//预布局方法，所有布局应该写在这里面
- (void)prepareLayout {
    [super prepareLayout];
    //需要重新布局
    CGFloat viewWidth = self.collectionView.frame.size.width;
    
    //有多少个section
    NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section ++) {
     
       //每个分区item的个数
     NSInteger itemCount = [self.collectionView  numberOfItemsInSection:section];
        
       //分别设置每个item的布局对象
        for (NSInteger item = 0; item < itemCount; item ++) {
            NSIndexPath * itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        }
    }
    
    
}

 //此方法返回当前屏幕正在显示的视图（cell的头尾视图）的布局属性集合
 - (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
     NSMutableArray * allAttributes = [NSMutableArray array];
     [self.cellLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL * _Nonnull stop) {
         if (CGRectIntersectsRect(rect, attribute.frame)) {
              [allAttributes addObject:attribute];
         }
       }];
      //添加当前屏幕可见的头视图的布局
      [self.headLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
             if (CGRectIntersectsRect(rect, attribute.frame)) {
                 [allAttributes addObject:attribute];
             }
      }];
         
      //添加当前屏幕可见的尾部的布局
      [self.footLayoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attribute, BOOL *stop) {
             if (CGRectIntersectsRect(rect, attribute.frame)) {
                 [allAttributes addObject:attribute];
             }
       }];
     
     return allAttributes;
 }
 
 //插入cell的时候系统会调用改方法
 - (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewLayoutAttributes * attribute = self.cellLayoutInfo[indexPath];
     return attribute;
 }
 
 - (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewLayoutAttributes * attribute = nil;
     if ([elementKind isEqualToString:AC_UICollectionElementKindSectionHeader]) {
         attribute = self.headLayoutInfo[indexPath];
     }else if ([elementKind isEqualToString:AC_UICollectionElementKindSectionFooter]){
         attribute = self.footLayoutInfo[indexPath];
     }
     return attribute;
 }
 
 //返回当前的ContentSize
 - (CGSize)collectionViewContentSize {
     return CGSizeMake(self.collectionView.frame.size.width, MAX(self.startY, self.collectionView.frame.size.height));
 }

- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray * indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem * updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                //[indexPaths addObject:updateItem.indexPathBeforeUpdate];
                //[indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                  NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
     self.shouldanimationArr = indexPaths;
}

//对应UICollectionViewUpdateItem 的indexPathBeforeUpdate 设置调用
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if ([self.shouldanimationArr containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes * attributes = self.cellLayoutInfo[itemIndexPath];
        attributes.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
        attributes.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attributes.alpha = 1;
          [self.shouldanimationArr removeObject:itemIndexPath];
        return attributes;
    }
    return nil;
}

//对应UICollectionViewUpdateItem 的indexPathAfterUpdate 设置调用
- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    if ([self.shouldanimationArr containsObject:itemIndexPath]) {
        UICollectionViewLayoutAttributes *attr = self.cellLayoutInfo[itemIndexPath];
        
        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(2, 2), 0);
        //        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
        attr.alpha = 0;
        [self.shouldanimationArr removeObject:itemIndexPath];
        return attr;
    }
    return nil;
}


- (void)finalizeCollectionViewUpdates {
    self.shouldanimationArr = nil;
}

//是否重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

- (void)prepareForAnimatedBoundsChange:(CGRect)oldBounds {
    
}

- (void)finalizeAnimatedBoundsChange {
    
}

/*
//移动相关
- (UICollectionViewLayoutInvalidationContext *)invalidationContextForInteractivelyMovingItems:(NSArray<NSIndexPath *> *)targetIndexPaths withTargetPosition:(CGPoint)targetPosition previousIndexPaths:(NSArray<nsindexpath *> *)previousIndexPaths previousPosition:(CGPoint)previousPosition  {
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForInteractivelyMovingItems:targetIndexPaths withTargetPosition:targetPosition previousIndexPaths:previousIndexPaths previousPosition:previousPosition];
   
    return context;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:(NSArray<NSIndexPath *> *)indexPaths previousIndexPaths:(NSArray<NSIndexPath *> *)previousIndexPaths movementCancelled:(BOOL)movementCancelled {
    UICollectionViewLayoutInvalidationContext *context = [super invalidationContextForEndingInteractiveMovementOfItemsToFinalIndexPaths:indexPaths previousIndexPaths:previousIndexPaths movementCancelled:movementCancelled];
    
    if(!movementCancelled){
        
    }
    return context;
}

*/
 


@end
