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
UICollectionViewDelegateFlowLayout
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
    
    return (self.selectedChannelList.count && self.unSelectChannelList.count) ? 2 : (self.selectedChannelList.count || self.unSelectChannelList.count);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0){
        return self.selectedChannelList.count;
    }else{
        return self.unSelectChannelList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0 ) {
        //选中的列表
        [cell.channelButton setTitle:[NSString stringWithFormat:@"%@ %@",[self.selectedChannelList[indexPath.row] objectForKey:@"name"],[self.selectedChannelList[indexPath.row] objectForKey:@"tag"]] forState:UIControlStateNormal];
    }else{
        //未选中的列表
         [cell.channelButton setTitle:[NSString stringWithFormat:@"%@ %@",[self.unSelectChannelList[indexPath.row] objectForKey:@"name"],[self.unSelectChannelList[indexPath.row] objectForKey:@"tag"]] forState:UIControlStateNormal];
    }
    
    NSLog(@"%@",[self.selectedChannelList[indexPath.row] objectForKey:@"tag"]);

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
        
    }else{

        if (self.selectedChannelList.count > 1) {
            
            NSDictionary *dic = self.selectedChannelList[indexPath.row];
            
            [self.selectedChannelList removeObjectAtIndex:indexPath.row];
            
            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]];
            
            [self.unSelectChannelList addObject:dic];
            
            if (self.unSelectChannelList.count == 1) {
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:1]];
            }else{
                [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.unSelectChannelList.count - 1 inSection:1]]];
            }
        }
    }
    
    [self.delegate displayChannelListDidChange];
}

#pragma mark LXReorderableCollectionViewDataSource

/**
 已经移动到toIndexPath

 @param collectionView collectionView
 @param fromIndexPath fromIndexPath
 @param toIndexPath toIndexPath
 */
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
    NSDictionary *dic = self.selectedChannelList[fromIndexPath.item];
    [self.selectedChannelList removeObjectAtIndex:fromIndexPath.row];
    [self.selectedChannelList insertObject:dic atIndex:toIndexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    
    [self.delegate displayChannelListDidChange];
}

/**
 是否可以移动

 @param collectionView collectionView
 @param indexPath indexPath
 @return bool
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section || self.selectedChannelList.count == 1) return false;
    return YES;
}


/**
 是否可以移动到某toIndexPath

 @param collectionView collectionView
 @param fromIndexPath fromIndexPath
 @param toIndexPath toIndexPath
 @return bool
 */
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if (toIndexPath.section) return false;
    return YES;
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

#pragma mark - viewWillLayoutSubviews

- (void)viewWillLayoutSubviews{
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
