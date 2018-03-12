//
//  LZCycleScrollView.m
//  LZCycleScrollView
//
//  Created by apple on 2015/3/12.
//  Copyright © 2015年 LIZHAO. All rights reserved.
//

#import "LZCycleScrollView.h"
#import "LZCollectionViewLayout.h"
#define kPageControl_H      40

@interface LZCycleScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    
    BOOL _isScrol;
    NSInteger _index;
    NSInteger from; // 0：网络图片 1.本地图片（NSString）2.本地图片（UIImage）
}

@property(nonatomic,strong)LZPageControl * pageControl;
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,assign)NSInteger totalItemsCount;
@property(nonatomic,strong)NSArray * imagePathGroup;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation LZCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
        [self initConfig];
    }
    return self;
}

- (void)_setup {
    [self addSubview:self.collectionView];
}

- (void)initConfig {
    [_collectionView registerNib:[UINib nibWithNibName:@"LZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:lzCollectionViewCell];
}

- (void)setImgURLStringGroup:(NSArray *)imgURLStringGroup {
    _imgURLStringGroup = imgURLStringGroup;
    _imagePathGroup = [_imgURLStringGroup copy];
    from = 0;
    self.totalItemsCount = _imgURLStringGroup.count;
}

- (void)setLocalImageUrlGroup:(NSArray<NSString *> *)localImageUrlGroup {
    _localImageUrlGroup = localImageUrlGroup;
    _imagePathGroup = [_localImageUrlGroup copy];
    from = 1;
    self.totalItemsCount = _localImageUrlGroup.count;
}

- (void)setLocalImageGroup:(NSArray<UIImage *> *)localImageGroup {
    _localImageGroup = localImageGroup;
    _imagePathGroup = [_localImageGroup copy];
    from = 2;
    self.totalItemsCount = _localImageGroup.count;
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
}

- (void)setTotalItemsCount:(NSInteger)totalItemsCount {
    _totalItemsCount = totalItemsCount;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [_collectionView reloadData];
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = _totalItemsCount;
    [self addTimer];
}

- (void)addTimer {
     _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:NULL repeats:YES];
   [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage {
    if (_index == self.imagePathGroup.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.pageControl.currentPage = 0;
        _index = 1;
        _isScrol = YES;
        
    }else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_index inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        self.pageControl.currentPage = _index;
        _index ++;
        NSLog(@"_index:%ld",_index);
    }
}

#pragma mark - 初始化视图
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LZCollectionViewLayout * layout = [[LZCollectionViewLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (LZPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[LZPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - kPageControl_H, self.bounds.size.width, kPageControl_H)];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.enabled = NO;
    }
    return _pageControl;
}

#pragma mark - UICollectionViewDataSource、 UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:lzCollectionViewCell forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"section:%ld item:%ld",indexPath.section,indexPath.item];
    if (from == 0) {
       
    }else if (from == 1) {
         cell.imageView.image = [UIImage imageNamed:self.imagePathGroup[indexPath.item]];
    }else if (from == 2) {
        
    }else{}
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cycleViewItemClickBlock) {
        self.cycleViewItemClickBlock(indexPath.item);
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(lzCycleViewDidSelectItem:)]) {
        [self.delegate lzCycleViewDidSelectItem:indexPath.item];
    }
}


/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return express;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return <#express#>;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return <#express#>;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return <#express#>;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return <#express#>;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return <#express#>;
}
*/

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"02--track:%d  ----drag:%d --- decelerating:%d", self.collectionView.tracking,self.collectionView.dragging,self.collectionView.decelerating);
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width + 0.5) % _totalItemsCount;
//    NSLog(@"当前页数：%d",page);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self addTimer];
}

/**
 * scrollViewDidEndDecelerating 与 scrollViewDidEndScrollingAnimation互斥
 * scrollViewDidEndDecelerating 结束拖拽触发
 * scrollViewDidEndScrollingAnimation 定时器触发
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    currentPage = currentPage % _totalItemsCount;
    _index = currentPage;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentPage inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    self.pageControl.currentPage = _index;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_isScrol) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _isScrol = NO;
    }
}


@end
