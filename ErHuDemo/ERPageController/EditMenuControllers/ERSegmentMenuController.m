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
/** 所有的标签列表 */
@property (nonatomic, strong) NSArray *channelList;
/** 布局视图 */
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ERSegmentMenuController

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        self.view.frame = frame;
        self.collectionView.frame = self.view.bounds;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channelList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EditMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    
    [cell.channelButton setTitle:self.channelList[indexPath.row] forState:UIControlStateNormal];
    
    // 在每个cell下面生成一个虚线的框框
    //        UIButton *placeholderBtn = [[UIButton alloc] initWithFrame:cell.frame];
    //        [placeholderBtn setBackgroundImage:[UIImage imageNamed:@"channel_sort_placeholder"] forState:UIControlStateNormal];
    //        placeholderBtn.width  -= 1;		placeholderBtn.centerX = cell.centerX;
    //        placeholderBtn.height -= 1;		placeholderBtn.centerY = cell.centerY;
    //        [collectionView insertSubview:placeholderBtn atIndex:0];
    return cell;
}

#pragma mark LXReorderableCollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"willMoveToIndexPath : %ld",toIndexPath.item);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"didMoveToIndexPath: %ld",toIndexPath.item);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return YES;
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
        flowLayout.sectionInset = UIEdgeInsetsMake(5, margin, 10, margin);
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

- (NSArray *)channelList{
    if (!_channelList) {
        _channelList = @[@"One",@"Two",@"Four",@"Three",@"One",@"One",@"Two",@"Four",@"Three",@"One",@"Three"];
    }
    return _channelList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
