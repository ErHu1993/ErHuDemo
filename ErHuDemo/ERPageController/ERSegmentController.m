//
//  ERSegmentController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERSegmentController.h"
#import "ERSegmentCollectionViewCell.h"

static NSInteger underLineViewHeight = 2;

static NSString *segmentCellIdentifier = @"ERSegmentCollectionViewCell";

@interface ERSegmentController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>


@property (nonatomic, strong) UICollectionView *segCollectionView;

@property (nonatomic, strong) UIView *underLineView;

@property (nonatomic, strong) UIButton *editMenuButton;

@property (nonatomic, assign) CGFloat beginOffsetX;

@property (nonatomic, assign) CGFloat selectFontScale;

@property (nonatomic, assign) BOOL isTapItemToScroll;

@end

@implementation ERSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configirePropertys];
}

- (void)configirePropertys
{
    self.normalTextFont = [UIFont systemFontOfSize:15];
    self.selectedTextFont = [UIFont systemFontOfSize:18];
    
    self.selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    
    self.contentScrollerView.delegate = self;
    
    self.itemMinimumSpacing = 8;
    self.progressWidth = 30;
    
    self.normalTextColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor redColor];
}

#pragma mark - UICollectionView 相关

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource numberOfControllersInPageViewController:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ERSegmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:segmentCellIdentifier forIndexPath:indexPath];
    
    NSString *title = [self.dataSource pageViewController:self titleForChildControllerAtIndex:indexPath.item];
    
    cell.titleLabel.text = title;
    
    [self changeCellTextColorImmediatelyFromCell:(indexPath.item == self.currentIndex ? nil : cell) toCell:(indexPath.item == self.currentIndex ? cell : nil)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = [self.dataSource pageViewController:self titleForChildControllerAtIndex:indexPath.item];
    CGFloat width = [self boundingSizeWithString:title font:self.selectedTextFont constrainedToSize:CGSizeMake(MAXFLOAT, SegmentViewHeight)].width;
    return CGSizeMake(width, SegmentViewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentIndex != indexPath.item) {
        self.isTapItemToScroll = true;
        [self movePageControllerToIndex:indexPath.item];
        [self changeSegmentImmediately];
    }
}

- (ERSegmentCollectionViewCell *)cellForIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return nil;
    }
    return (ERSegmentCollectionViewCell *)[self.segCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (CGRect)cellFrameWithIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return CGRectZero;
    }
    UICollectionViewLayoutAttributes * cellAttrs = [self.segCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    return cellAttrs.frame;
}


#pragma mark - 编辑菜单点击事件

- (void)editMenuButtonClick:(UIButton *)btn{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.contentScrollerView) {
        if (!self.isTapItemToScroll) {
            [self shangeSegmentProgress];
        }
        [self changeCurrentPageIndex];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.contentScrollerView) {
        self.beginOffsetX = scrollView.contentOffset.x;
    }
}

- (void)shangeSegmentProgress{
    
    CGFloat offsetX = self.contentScrollerView.contentOffset.x;
    CGFloat width = CGRectGetWidth(self.contentScrollerView.frame);
    CGFloat floorIndex = floor(offsetX / width);
    CGFloat progress = offsetX / width - floorIndex;
    
    if (floorIndex < 0 || floorIndex >= self.countOfControllers) {
        return;
    }
    
    NSInteger fromIndex = 0, toIndex = 0;
    
    if (offsetX >= self.beginOffsetX) {
        //左滑
        if (floorIndex >= self.countOfControllers - 1) {
            return;
        }
        fromIndex = floorIndex;
        toIndex = MIN(self.countOfControllers - 1, fromIndex + 1);
    }else {
        //右滑
        if (floorIndex < 0 ) {
            return;
        }
        toIndex = floorIndex;
        fromIndex = MIN(self.countOfControllers - 1, toIndex + 1);
        progress = 1.0 - progress;
    }
    
    [self transitionFromIndex:fromIndex toIndex:toIndex progress:progress isTapToScroller:self.isTapItemToScroll];
}

- (void)changeCurrentPageIndex{
    
    CGFloat offsetX = self.contentScrollerView.contentOffset.x;
    CGFloat width = CGRectGetWidth(self.contentScrollerView.frame);
    
    NSInteger index = 0;
    
    if (offsetX >= self.beginOffsetX) {
        index = offsetX / width;
    }else {
        index = ceil(offsetX / width);
    }
    
    if (index < 0) {
        index = 0;
    }else if (index >= self.countOfControllers) {
        index = self.countOfControllers - 1;
    }
    
    if (index != self.currentIndex) {
        NSInteger fromIndex = self.currentIndex;
        self.currentIndex = index;
        if (self.currentIndex < self.countOfControllers) {
            [self.segCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }
        if (self.isTapItemToScroll) {
            [self transitionFromIndex:fromIndex toIndex:self.currentIndex progress:1 isTapToScroller:self.isTapItemToScroll];
        }
    }

}

- (void)changeSegmentImmediately{

    CGRect toCellFrame = [self cellFrameWithIndex:self.currentIndex];
    CGFloat progressEdging = (toCellFrame.size.width - self.progressWidth) / 2;
    CGFloat progressX = toCellFrame.origin.x + progressEdging;
    CGFloat progressY = (toCellFrame.size.height - underLineViewHeight);
    CGFloat width = toCellFrame.size.width - 2 * progressEdging;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.underLineView.frame = CGRectMake(progressX, progressY, width, underLineViewHeight);
    } completion:^(BOOL finished) {
        self.isTapItemToScroll = false;
    }];
}

- (void)changeCellTextColorImmediatelyFromCell:(ERSegmentCollectionViewCell *)fromCell toCell:(ERSegmentCollectionViewCell *)toCell{
    
    if (fromCell) {
        fromCell.titleLabel.textColor = self.normalTextColor;
        fromCell.transform = CGAffineTransformMakeScale(self.selectFontScale, self.selectFontScale);
    }
    
    if (toCell) {
        toCell.titleLabel.textColor = self.selectedTextColor;
        toCell.transform = CGAffineTransformIdentity;
    }
}

- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress isTapToScroller:(BOOL)isTapToScroller{
    
    ERSegmentCollectionViewCell *fromCell = [self cellForIndex:fromIndex];
    ERSegmentCollectionViewCell *toCell = [self cellForIndex:toIndex];
    
    if (isTapToScroller) {
        [self changeCellTextColorImmediatelyFromCell:fromCell toCell:toCell];
    }else{
        [self transitionCellTextColorFromCell:fromCell toCell:toCell progress:progress];
        [self transitionUnderLineFrameWithfromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}


/**
  根据progress来控制Cell标题颜色的转变和Cell放大效果

 @param fromCell fromCell
 @param toCell toCell
 @param progress progress
 */
- (void)transitionCellTextColorFromCell:(ERSegmentCollectionViewCell *)fromCell toCell:(ERSegmentCollectionViewCell *)toCell progress:(CGFloat)progress{

    CGFloat currentTransform = (1.0 - self.selectFontScale) * progress;
    fromCell.transform = CGAffineTransformMakeScale(1.0 - currentTransform, 1.0 - currentTransform);
    toCell.transform = CGAffineTransformMakeScale(self.selectFontScale + currentTransform, self.selectFontScale + currentTransform);
    
    CGFloat narR,narG,narB,narA;
    [self.normalTextColor getRed:&narR green:&narG blue:&narB alpha:&narA];
    CGFloat selR,selG,selB,selA;
    [self.selectedTextColor getRed:&selR green:&selG blue:&selB alpha:&selA];
    CGFloat detalR = narR - selR ,detalG = narG - selG,detalB = narB - selB,detalA = narA - selA;
    
    fromCell.titleLabel.textColor = [UIColor colorWithRed:selR + detalR * progress green:selG + detalG * progress blue:selB + detalB * progress alpha:selA + detalA * progress];
    toCell.titleLabel.textColor = [UIColor colorWithRed:narR - detalR * progress green:narG - detalG * progress blue:narB - detalB * progress alpha:narA - detalA * progress];
}


/**
 根据progress来控制底部横线便宜

 @param fromIndex fromIndex
 @param toIndex toIndex
 @param progress progress
 */
- (void)transitionUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    if (self.countOfControllers == 0) {
        return;
    }
    
    CGRect fromCellFrame = [self cellFrameWithIndex:fromIndex];
    CGRect toCellFrame = [self cellFrameWithIndex:toIndex];
    
    CGFloat progressFromEdging = ABS((fromCellFrame.size.width - self.progressWidth)) / 2;
    CGFloat progressToEdging = ABS((toCellFrame.size.width - self.progressWidth)) / 2;
    
    CGFloat progressY = (toCellFrame.size.height - underLineViewHeight);
    
    CGFloat progressX, width;
    
    if (fromCellFrame.origin.x < toCellFrame.origin.x) {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width - 2 * progressFromEdging) * progress;
            width = (toCellFrame.size.width - progressToEdging + progressFromEdging + self.itemMinimumSpacing) * 2 * progress - (toCellFrame.size.width - 2 *progressToEdging) * progress + fromCellFrame.size.width - 2 * progressFromEdging - (fromCellFrame.size.width - 2 * progressFromEdging) *progress;
        }else {
            progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width - 2 * progressFromEdging) * 0.5 + (fromCellFrame.size.width- progressFromEdging - (fromCellFrame.size.width - 2 * progressFromEdging) * 0.5 + progressToEdging + self.itemMinimumSpacing) * (progress - 0.5) * 2;
            width = CGRectGetMaxX(toCellFrame) - progressToEdging - progressX - (toCellFrame.size.width - 2 * progressToEdging) * ( 1 - progress);
        }
    }else {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging - (toCellFrame.size.width - (toCellFrame.size.width - 2 * progressToEdging) / 2 - progressToEdging + progressFromEdging + self.itemMinimumSpacing) * 2 * progress;
            width = CGRectGetMaxX(fromCellFrame) - (fromCellFrame.size.width - 2 * progressFromEdging) * progress - progressFromEdging - progressX;
        }else {
            progressX = toCellFrame.origin.x + progressToEdging+(toCellFrame.size.width - 2 * progressToEdging) * (1 - progress);
            width = (fromCellFrame.size.width - progressFromEdging + progressToEdging - (fromCellFrame.size.width - 2 * progressFromEdging) / 2 + self.itemMinimumSpacing) * (1 - progress) * 2 + toCellFrame.size.width - 2 * progressToEdging - (toCellFrame.size.width - 2 * progressToEdging) * (1 - progress);
        }
    }
    
    self.underLineView.frame = CGRectMake(progressX,progressY, width, underLineViewHeight);
}

#pragma mark - Tool 支持工具

/**
 获取内容大小(Item大小适配)
 
 @param string 内容
 @param font 字号
 @param size 最大size
 @return contentSize
 */
- (CGSize)boundingSizeWithString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize textSize = CGSizeZero;
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED && __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
    if (![string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        textSize = [string sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
#endif
    {
        CGRect frame = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font} context:nil];
        textSize = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    
    return textSize;
}

#pragma mark - LayoutSubviews

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (!CGRectEqualToRect(self.segCollectionView.bounds, self.view.bounds)) {
        self.segCollectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - SegmentViewHeight, SegmentViewHeight);
        self.editMenuButton.frame = CGRectMake(CGRectGetMaxX(self.segCollectionView.frame), 0, SegmentViewHeight, SegmentViewHeight);
    }
    [self scrollViewDidScroll:self.contentScrollerView];
}

#pragma mark - getter/setter

- (void)setProgressWidth:(CGFloat)progressWidth
{
    _progressWidth = progressWidth;
}

- (UIButton *)editMenuButton{
    if (!_editMenuButton) {
        _editMenuButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [_editMenuButton addTarget:self action:@selector(editMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editMenuButton.backgroundColor = [UIColor whiteColor];
        _editMenuButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        _editMenuButton.layer.shadowRadius = 4;
        _editMenuButton.layer.shadowOffset = CGSizeMake(- 8, -5);
        _editMenuButton.layer.shadowOpacity = 1 ;
        [self.view addSubview:_editMenuButton];
    }
    return _editMenuButton;
}

- (UICollectionView *)segCollectionView{
    if (!_segCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _segCollectionView.showsHorizontalScrollIndicator = NO;
        _segCollectionView.showsVerticalScrollIndicator = NO;
        if ([_segCollectionView respondsToSelector:@selector(setPrefetchingEnabled:)]) _segCollectionView.prefetchingEnabled = NO;
        _segCollectionView.backgroundColor = [UIColor whiteColor];
        _segCollectionView.delegate = self;
        _segCollectionView.dataSource = self;
        [_segCollectionView registerNib:[UINib nibWithNibName:segmentCellIdentifier bundle:nil] forCellWithReuseIdentifier:segmentCellIdentifier];
        [self.view addSubview:_segCollectionView];
        
        self.underLineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.underLineView.layer.zPosition = -1;
        self.underLineView.backgroundColor = self.selectedTextColor;
        [_segCollectionView insertSubview:self.underLineView atIndex:0];
    }
    return _segCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
