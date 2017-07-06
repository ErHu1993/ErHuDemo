//
//  ERSegmentMenuController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/29.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "ERSegmentMenuController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "EditMenuCollectionViewCell.h"
#import "SectionHeader.h"


static NSString * const CollectionViewCellIdentifier = @"EditMenuCollectionViewCell";

@interface ERSegmentMenuController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
EditMenuCollectionViewCellDelegate
>
/** 选中标签组头 */
@property (nonatomic, strong) UILabel *selectHeaderLabel;
/** 未中标签组头 */
@property (nonatomic, strong) UILabel *unselectHeaderLabel;
/** 选中的标签列表 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *selectedChannelList;
/** 未选中的标签列表 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *unSelectChannelList;
/** 布局视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 正在排序 */
@property (nonatomic, assign) BOOL isSorting;
@end

@implementation ERSegmentMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshContentData];
}

- (void)refreshContentData{
    self.selectedChannelList = [self.dataSource selectedChannelLisInSegmentMenuController:self];
    self.unSelectChannelList = [self.dataSource unSelectChannelListInSegmentMenuController:self];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.isSorting) {
        return 1;
    }else{
        return (self.selectedChannelList.count && self.unSelectChannelList.count) ? 2 : (self.selectedChannelList.count || self.unSelectChannelList.count);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isSorting) {
        return self.selectedChannelList.count;
    }else if (section == 0){
        return self.selectedChannelList.count;
    }else{
        return self.unSelectChannelList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    
    if (!cell.delegate) cell.delegate = self;
    
    if (indexPath.section == 0 ) {
        //选中的列表
        [cell.channelButton setTitle:[NSString stringWithFormat:@"%@ %@",[self.selectedChannelList[indexPath.row] objectForKey:@"name"],[self.selectedChannelList[indexPath.row] objectForKey:@"tag"]] forState:UIControlStateNormal];
    }else{
        //未选中的列表
         [cell.channelButton setTitle:[NSString stringWithFormat:@"%@ %@",[self.unSelectChannelList[indexPath.row] objectForKey:@"name"],[self.unSelectChannelList[indexPath.row] objectForKey:@"tag"]] forState:UIControlStateNormal];
    }
    
    cell.canEdit = self.isSorting;
    
    // 在每个cell下面生成一个虚线的框框
    //        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
    //        [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
    //        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
    //        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
    //        [collectionView insertSubview:placeholderBtn atIndex:0];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    if (!indexPath.section) {
        header.titleLabel.text = @"长按排序";
    }else{
        header.titleLabel.text = @"点击添加标签";
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section) {
        //未选中组
        return CGSizeMake(CGRectGetWidth(self.view.frame), 15);
    }
    //选中组
    return CGSizeMake(CGRectGetWidth(self.view.frame), 15 + 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        NSDictionary *dic = self.unSelectChannelList[indexPath.row];
        
        [self.unSelectChannelList removeObjectAtIndex:indexPath.row];
        if (!self.unSelectChannelList.count) {
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:1]];
        }else{
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]]];
        }
        
        [self.selectedChannelList addObject:dic];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.selectedChannelList.count - 1 inSection:0]]];
        
        [self.delegate displayChannelListDidChange];
    }
}

#pragma mark - EditMenuCollectionViewCellDelegate

/**
 删除对应Iem

 @param indexPath indexPath
 */
- (void)didSelectDeleteItem:(NSIndexPath *)indexPath{
    [self.selectedChannelList removeObjectAtIndex:indexPath.row];
    if (self.selectedChannelList.count < 2) {
        self.isSorting = false;
        [self.collectionView reloadData];
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self.delegate displayChannelListDidChange];
}

#pragma mark LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath{
    NSLog(@"willMoveToIndexPath : %ld",toIndexPath.item);
    NSDictionary *dic = self.selectedChannelList[fromIndexPath.item];
    [self.selectedChannelList removeObjectAtIndex:fromIndexPath.row];
    [self.selectedChannelList insertObject:dic atIndex:toIndexPath.row];
    [self.delegate displayChannelListDidChange];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
    NSLog(@"didMoveToIndexPath: %ld",toIndexPath.item);
    [collectionView reloadItemsAtIndexPaths:@[toIndexPath]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isSorting && self.selectedChannelList.count > 1) {
        self.isSorting = true;
        [self.collectionView reloadData];
        return false;
    }
    if (indexPath.section) return false;
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if (!self.isSorting) return false;
    if (toIndexPath.section) return false;
    return YES;
}



- (void)viewWillLayoutSubviews{
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - getter/setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        LXReorderableCollectionViewFlowLayout *flowLayout = [[LXReorderableCollectionViewFlowLayout alloc] init];
        // 设置cell的大小和细节,每排4个
        CGFloat margin = 20.0;
        CGFloat width  = (CGRectGetWidth(self.view.frame) - margin * 5) / 4.f;
        CGFloat height = width * 3.f / 7.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = 20;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"EditMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        [_collectionView registerClass:[SectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - getter/setter

- (UILabel *)selectHeaderLabel{
    if (!_selectHeaderLabel) {
        _selectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.frame), 15)];
        _selectHeaderLabel.font = [UIFont systemFontOfSize:12];
        _selectHeaderLabel.textColor = [UIColor blackColor];
    }
    return _selectHeaderLabel;
}

- (UILabel *)unselectHeaderLabel{
    if (!_unselectHeaderLabel) {
        _unselectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame), 15)];
        _unselectHeaderLabel.font = [UIFont systemFontOfSize:12];
        _unselectHeaderLabel.textColor = [UIColor blackColor];
    }
    return _unselectHeaderLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
