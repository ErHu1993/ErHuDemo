//
//  ERSegmentController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERSegmentController.h"
#import "ERSegmentCollectionViewCell.h"

static NSString *segmentCellIdentifier = @"ERSegmentCollectionViewCell";

@interface ERSegmentController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,ERSegmentMenuControllerDelegate>

/** "导航"条 */
@property (nonatomic, strong) UICollectionView *segCollectionView;
/** 底部红线 */
@property (nonatomic, strong) UIView *underLineView;
/** 记录点击时间,用于判断双击事件 */
@property (nonatomic, strong) NSDate *lastTime;
/** 开始滚动时坐标 */
@property (nonatomic, assign) CGFloat beginOffsetX;
/** 选中状态下字体放大倍数 */
@property (nonatomic, assign) CGFloat selectFontScale;
/** 是否是点击item触发的滚动 */
@property (nonatomic, assign) BOOL isTapItemToScroll;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editMenuButton;
/** 菜单控制器 */
@property (nonatomic, strong) ERSegmentMenuController *menuController;
/** 是否展示编辑菜单按钮 */
@property (nonatomic, assign) BOOL showEditMenuButton;
@end

@implementation ERSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configirePropertys];
}

#pragma mark - 初始化属性配置
- (void)configirePropertys{
    
    self.showEditMenuButton = false;
    
    self.progressWidth = 20;
    self.progressHeight = 2;
    self.itemMinimumSpace = 5;
    
    self.normalTextFont = [UIFont systemFontOfSize:15];
    self.selectedTextFont = [UIFont systemFontOfSize:18];
    
    self.contentScrollerView.delegate = self;
    
    self.normalTextColor = [UIColor blackColor];
    self.selectedTextColor = [UIColor redColor];
}


/**
 刷新数据
 */
- (void)reloadData{
    [self.segCollectionView reloadData];
    [self reloadPageData];
    [self changeSegmentImmediately];
}

#pragma mark - 编辑菜单点击事件

- (void)editMenuButtonClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    if ([self.delegate respondsToSelector:@selector(segmentController:didSelectEditMenuButton:)]) {
        [self.delegate segmentController:self didSelectEditMenuButton:btn];
    }
    
    if (btn.selected) {
        [self showMenuViewController];
    }else{
        [self hideMenuViewController];
    }
}

- (void)showMenuViewController{
    
    self.segCollectionView.userInteractionEnabled = false;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.menuController.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.segCollectionView.frame), self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.segCollectionView.frame));
        [self.menuController.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = YES;
    }];
}

- (void)hideMenuViewController{
    
    self.segCollectionView.userInteractionEnabled = true;;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.menuController.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMaxY(self.segCollectionView.frame), self.view.frame.size.width, 0);
        [self.menuController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.tabBarController.tabBar.hidden = false;
    }];
}

#pragma mark - UICollectionView 相关

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataSource numberOfControllersInPageViewController:self];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ERSegmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:segmentCellIdentifier forIndexPath:indexPath];
    
    NSString *title = [self.dataSource pageViewController:self titleForChildControllerAtIndex:indexPath.item];
    
    cell.titleLabel.text = title;
    
    cell.titleLabel.font = self.normalTextFont;
    
    [self changeCellTextColorImmediatelyFromCell:(indexPath.item == self.currentIndex ? nil : cell) toCell:(indexPath.item == self.currentIndex ? cell : nil)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *title = [self.dataSource pageViewController:self titleForChildControllerAtIndex:indexPath.item];
    
    CGFloat width = [self boundingSizeWithString:title font:self.selectedTextFont constrainedToSize:CGSizeMake(MAXFLOAT, self.segmentHeight)].width;
    
    return CGSizeMake(width, self.segmentHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *nowTime = [NSDate date];
    if (self.currentIndex != indexPath.item) {
        self.isTapItemToScroll = true;
        [self movePageControllerToIndex:indexPath.item];
        [self changeSegmentImmediately];
        if ([self.delegate respondsToSelector:@selector(segmentController:didSelectItemAtIndexPath:)]) {
            [self.delegate segmentController:self didSelectItemAtIndexPath:indexPath];
        }
    }else{
        if ([nowTime timeIntervalSinceDate:self.lastTime] < 0.3) {
            //判定为双击事件
            if ([self.delegate respondsToSelector:@selector(segmentController:itemDoubleClickAtIndexPath:)]) {
                [self.delegate segmentController:self itemDoubleClickAtIndexPath:indexPath];
            }
        }
    }
    self.lastTime = nowTime;
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

#pragma mark - ERSegmentMenuControllerDelegate

- (void)displayChannelListDidChange{
    [self reloadData];
}

#pragma mark - Item 渐变滚动动画

/**
 带渐变效果的改变
 */
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


/**
 无渐变效果的改变
 */
- (void)changeSegmentImmediately{

    CGRect toCellFrame = [self cellFrameWithIndex:self.currentIndex];
    CGFloat progressEdging = (toCellFrame.size.width - self.progressWidth) / 2;
    CGFloat progressX = toCellFrame.origin.x + progressEdging;
    CGFloat progressY = (toCellFrame.size.height - self.progressHeight);
    CGFloat width = toCellFrame.size.width - 2 * progressEdging;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.underLineView.frame = CGRectMake(progressX, progressY, width, self.progressHeight);
    } completion:^(BOOL finished) {
        self.isTapItemToScroll = false;
    }];
}

/**
 判断当前页面的index
 */
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

        if ([self.delegate respondsToSelector:@selector(pageControllerDidScroll:fromIndex:toIndex:)]) {
            [self.delegate pageControllerDidScroll:self fromIndex:fromIndex toIndex:self.currentIndex];
        }
    }
}


/**
 逐渐改变cell选中和未选中的状态

 @param fromIndex fromIndex
 @param toIndex toIndex
 @param progress progress
 @param isTapToScroller 是否是点击item触发的
 */
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
 立即改变cell选中和未选中的状态,无渐变效果
 
 @param fromCell fromCell
 @param toCell toCell
 */
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
    
    CGFloat progressY = (toCellFrame.size.height - self.progressHeight);
    
    CGFloat progressX, width;
    
    if (fromCellFrame.origin.x < toCellFrame.origin.x) {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width - 2 * progressFromEdging) * progress;
            width = (toCellFrame.size.width - progressToEdging + progressFromEdging) * 2 * progress - (toCellFrame.size.width - 2 *progressToEdging) * progress + fromCellFrame.size.width - 2 * progressFromEdging - (fromCellFrame.size.width - 2 * progressFromEdging) * progress;
        }else {
            progressX = fromCellFrame.origin.x + progressFromEdging + (fromCellFrame.size.width - 2 * progressFromEdging) * 0.5 + (fromCellFrame.size.width - progressFromEdging - (fromCellFrame.size.width - 2 * progressFromEdging) * 0.5 + progressToEdging + self.itemMinimumSpace)*(progress - 0.5) *    2;
            width = CGRectGetMaxX(toCellFrame) - progressToEdging - progressX - (toCellFrame.size.width - 2 * progressToEdging) * ( 1 - progress);
        }
    }else {
        if (progress <= 0.5) {
            progressX = fromCellFrame.origin.x + progressFromEdging - (toCellFrame.size.width - (toCellFrame.size.width - 2 * progressToEdging) / 2 - progressToEdging + progressFromEdging) * 2 * progress;
            width = CGRectGetMaxX(fromCellFrame) - (fromCellFrame.size.width - 2 * progressFromEdging) * progress - progressFromEdging - progressX;
        }else {
            progressX = toCellFrame.origin.x + progressToEdging+(toCellFrame.size.width - 2 * progressToEdging) * (1 - progress);
            width = (fromCellFrame.size.width - progressFromEdging + progressToEdging - (fromCellFrame.size.width - 2 * progressFromEdging) / 2 ) * (1 - progress) * 2 + toCellFrame.size.width - 2 * progressToEdging - (toCellFrame.size.width - 2 * progressToEdging) * (1 - progress);
        }
    }
    
    self.underLineView.frame = CGRectMake(progressX,progressY, width, self.progressHeight);
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
    
    if (CGRectEqualToRect(self.segCollectionView.frame, CGRectZero)) {
        
        self.editMenuButton.frame = CGRectMake(self.showEditMenuButton ? CGRectGetMaxX(self.view.frame) - self.segmentHeight : CGRectGetMaxX(self.view.frame), 0, self.showEditMenuButton ? self.segmentHeight : 0, self.segmentHeight);
        
        self.segCollectionView.frame = CGRectMake(0, 0,CGRectGetMinX(self.editMenuButton.frame), self.segmentHeight);
        
        [self scrollViewDidScroll:self.contentScrollerView];
        
        if (self.showEditMenuButton) {
            self.editMenuIconIgV.frame = CGRectMake(self.segmentHeight / 4, self.segmentHeight / 4, self.segmentHeight / 2, self.segmentHeight/ 2);
        }
    }
}

#pragma mark - getter/setter

- (void)setMenuDataSource:(id<ERSegmentMenuControllerDataSource>)menuDataSource{
    if (self.menuController.dataSource != menuDataSource) {
        self.menuController.dataSource = menuDataSource;
        if (self.menuController.dataSource) {
            self.showEditMenuButton = true;
        }
    }
}

- (ERSegmentMenuController *)menuController{
    if (!_menuController) {
        _menuController = [[ERSegmentMenuController alloc] init];
        _menuController.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), self.segmentHeight, CGRectGetWidth(self.view.frame), 0);
        _menuController.dataSource = self.menuDataSource;
        _menuController.delegate = self;
        [_menuController.view layoutIfNeeded];
        [self addChildViewController:_menuController];
        [self.view addSubview:_menuController.view];
    }
    return _menuController;
}

- (void)setNormalTextFont:(UIFont *)normalTextFont{
    if (_normalTextFont.pointSize != normalTextFont.pointSize) {
        _normalTextFont = normalTextFont;
        self.selectFontScale = _normalTextFont.pointSize / self.selectedTextFont.pointSize;
    }
}

- (void)setSelectedTextFont:(UIFont *)selectedTextFont{
    if (_selectedTextFont.pointSize != selectedTextFont.pointSize) {
        _selectedTextFont = selectedTextFont;
        self.selectFontScale = self.normalTextFont.pointSize / _selectedTextFont.pointSize;
    }
}

- (UIButton *)editMenuButton{
    if (!_editMenuButton) {
        _editMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editMenuButton addTarget:self action:@selector(editMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _editMenuButton.backgroundColor = [UIColor whiteColor];
        _editMenuButton.layer.shadowColor = [UIColor whiteColor].CGColor;
        _editMenuButton.layer.shadowRadius = self.segmentHeight / 10;
        _editMenuButton.layer.shadowOffset = CGSizeMake(- self.segmentHeight / 5, - 2);
        _editMenuButton.layer.shadowOpacity = 1;
        [_editMenuButton addSubview:self.editMenuIconIgV];
        [self.view addSubview:_editMenuButton];
    }
    return _editMenuButton;
}

- (UIImageView *)editMenuIconIgV{
    if (!_editMenuIconIgV) {
        _editMenuIconIgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _editMenuIconIgV.image = [UIImage imageNamed:@"editButtonImage"];
    }
    return _editMenuIconIgV;
}

- (UICollectionView *)segCollectionView{
    if (!_segCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, self.segmentHeight / 5);
        layout.minimumInteritemSpacing = self.itemMinimumSpace;
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
