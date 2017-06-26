//
//  mediaSelectViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/16.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "mediaSelectViewController.h"
#import "PhotoPickerCell.h"

@interface mediaSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *photosCollectionViewLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topChooseHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomChooseViewHeigh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maskGrayViewBottomLeading;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *assets;
/** 选中的相片 */
@property (nonatomic, strong) PHAsset *selectAsset;

@property (nonatomic, strong) UIView *maskView;

@end

@implementation mediaSelectViewController

- (void)dealloc{
    NSLog(@"%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews{
    
    __weak typeof(self)weakSelf = self;
    [self.maskGrayView addTapGestureBlock:^{
        [weakSelf dismissWithAnimations:nil completion:nil];
    }];
    
    [self.buttonsView addTapGestureBlock:^{
       [weakSelf dismissWithAnimations:nil completion:nil];
    }];

    CGFloat margin = 5.f;
    self.photosCollectionViewLayout.itemSize = CGSizeMake(90, 90);
    self.photosCollectionViewLayout.minimumLineSpacing = margin;
    self.photosCollectionViewLayout.minimumInteritemSpacing = margin;
    self.photosCollectionViewLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    self.photosCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.photosCollectionView.backgroundColor = [UIColor whiteColor];
    self.photosCollectionView.showsHorizontalScrollIndicator = false;
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    //注册cell
    [self.photosCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PhotoPickerCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([PhotoPickerCell class])];
    
    //加载相册
    [self setupPhotosData];
}

- (void)show{
    
    [self openMask:0.25];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.buttonsViewHeight.constant = 80;
        self.topChooseHeight.constant = 100;
        self.bottomChooseViewHeigh.constant = 40;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissWithAnimations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:0.25 animations:^{
        if (animations) {
            animations();
        }
        self.buttonsViewHeight.constant = 0;
        self.topChooseHeight.constant = 0;
        self.bottomChooseViewHeigh.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    [self closeMask:0.25];
}

- (void)showWithInputBar:(InputBarViewController *)inputBar{
    
}

- (void)openMask:(NSTimeInterval)duration{
    if (duration) {
        self.maskView.alpha = 0;
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.maskView];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.maskView];
    self.maskView.sd_layout.leftEqualToView([[UIApplication sharedApplication] keyWindow]).rightEqualToView([[UIApplication sharedApplication] keyWindow]).topEqualToView([[UIApplication sharedApplication] keyWindow]).bottomEqualToView([[UIApplication sharedApplication] keyWindow]);
    
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 1;
        }];
    }
}

- (void)closeMask:(NSTimeInterval)duration{
    if (duration) {
        [UIView animateWithDuration:duration animations:^{
            self.maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
        }];
    }else{
        [self.maskView removeFromSuperview];
    }
}

#pragma mark - 图片选择区相关方法

- (void)setupPhotosData {
    [self.assets addObjectsFromArray:PhotoLibraryService.defaultService.pool];
    [self.photosCollectionView reloadData];
    //先展示10张 再异步取所有的图片(随机视频或者全类或者图片)
    switch (arc4random() % 4) {
        case 0:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [PhotoLibraryService.defaultService getVideos:^(NSArray<PHAsset *> * _Nonnull assets) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadDataWithAssets:assets];
                    });
                }];
            });
        }
            break;
        case 2:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [PhotoLibraryService.defaultService getPhotos:^(NSArray<PHAsset *> * _Nonnull assets) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadDataWithAssets:assets];
                    });
                }];
            });
        }
            break;
            
        default:
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [PhotoLibraryService.defaultService getAll:^(NSArray<PHAsset *> * _Nonnull assets) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadDataWithAssets:assets];
                    });
                }];
            });
        }
            break;
    }
}

- (void)reloadDataWithAssets:(NSArray<PHAsset *> *)assets {
    [self.assets removeAllObjects];
    [self.assets addObjectsFromArray:assets];
    [self.photosCollectionView reloadData];
}

- (IBAction)onlyShowPhoto:(id)sender {
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoPickerCell class]) forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assets[indexPath.row];
    if (self.selectAsset) {
        if ([self.selectAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
            self.selectAsset.z_selected = !self.selectAsset.z_selected;
            asset.z_selected = self.selectAsset.z_selected;
        }else {
            self.selectAsset.z_selected = false;
            asset.z_selected = true;
        }
    }else {
        asset.z_selected = true;
    }
    self.selectAsset = asset;
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
}


#pragma mark - getter/setter

- (void)setSelectAsset:(PHAsset *)selectAsset {
    if (_selectAsset != selectAsset) {
        _selectAsset = selectAsset;
    }
    [self.photosCollectionView reloadData];
}

- (UIView *)maskView{
    if (!_maskView) {
         _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
         _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _maskView;
}

- (NSMutableArray <PHAsset *>*)assets{
    if (!_assets) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
