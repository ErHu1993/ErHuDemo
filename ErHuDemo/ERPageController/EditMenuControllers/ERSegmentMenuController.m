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

static NSString * const CollectionViewCellIdentifier = @"EditMenuCollectionViewCell";

@interface ERSegmentMenuController ()<UICollectionViewDelegate,UICollectionViewDataSource>
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
    [self reloadData];
}

- (void)reloadData{
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
    
    if (indexPath.section == 0 ) {
        //选中的列表
        [cell.channelButton setTitle:[self.selectedChannelList[indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
    }else{
        //未选中的列表
        [cell.channelButton setTitle:[self.unSelectChannelList[indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
    }
    
    // 在每个cell下面生成一个虚线的框框
    //        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
    //        [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
    //        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
    //        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
    //        [collectionView insertSubview:placeholderBtn atIndex:0];
    return cell;
}

#pragma mark LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath{
    NSLog(@"willMoveToIndexPath : %ld",toIndexPath.item);
    NSDictionary *dic = self.selectedChannelList[fromIndexPath.item];
    [self.selectedChannelList removeObjectAtIndex:fromIndexPath.row];
    [self.selectedChannelList insertObject:dic atIndex:toIndexPath.row];
    if (self.delegate) {
        [self.delegate displayChannelListDidChange];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
    NSLog(@"didMoveToIndexPath: %ld",toIndexPath.item);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) return false;
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if (toIndexPath.section) return false;
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath{
    self.isSorting = true;
}

- (void)viewWillLayoutSubviews{
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - getter/setter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        LXReorderableCollectionViewFlowLayout *flowLayout = [LXReorderableCollectionViewFlowLayout new];
        // 设置cell的大小和细节,每排4个
        CGFloat margin = 20.0;
        CGFloat width  = ([UIScreen mainScreen].bounds.size.width - margin * 5) / 4.f;
        CGFloat height = width * 3.f / 7.f;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = 20;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"EditMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
