//
//  SearchBarViewController.m
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/11.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import "SearchBarViewController.h"
#import "ImageTableViewCell.h"

@interface SearchBarViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate
>

/** 搜索框 */
@property (nonatomic, strong) UISearchController *searchController;
/** 列表 */
@property (nonatomic, strong) UITableView *tableView;
/** 列表头视图 */
@property (nonatomic, strong) UIView *tableHeadView;
/** 搜索框背景颜色 */
@property (nonatomic, strong) UIImage *searchGrayImage;
/** 搜索框背景颜色 */
@property (nonatomic, strong) UIImage *searchWhiteImage;

@property (nonatomic, strong) ImageTableViewCell *currentCell;

@property (nonatomic, assign) CGFloat radios;

@end

@implementation SearchBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSArray *cells =  [self.tableView visibleCells];
    
    self.currentCell = cells[cells.count - 1];
    
    [self.currentCell.contentView addSubview:self.currentCell.coverImageView];
    
    [self.currentCell setRadius:0];
}

- (void)setupSubviews{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [backBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat progress = scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.height);
    
    if (progress > 1) {
        progress = 1;
    }
    
    if (progress < 0) {
        progress = 0;
    }
    
    self.radios = progress * ScreenHeight;
    
    [self.currentCell setRadius:self.radios];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchController.searchBar.backgroundImage = self.searchWhiteImage;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //改变SearchBar 背景颜色
    self.searchController.searchBar.backgroundImage = self.searchGrayImage;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //改变SearchBar 背景颜色
    self.searchController.searchBar.backgroundImage = self.searchGrayImage;
}

#pragma mark 初始化

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        
        UIView *grayBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        [_tableHeadView addSubview:grayBgView];
        //输入框
        [grayBgView addSubview:self.searchController.searchBar];
    }
    return _tableHeadView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHexString:@"f8f8f8"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.tableHeadView;
        [_tableView registerClass:[ImageTableViewCell class] forCellReuseIdentifier:@"ImageTableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        [_searchController.searchBar sizeToFit];
        _searchController.searchBar.placeholder =  @"搜索";
        [_searchController.searchBar sizeToFit];
        UIOffset offset = {10.0,0};
        _searchController.searchBar.searchTextPositionAdjustment = offset;
        _searchController.searchBar.backgroundImage = self.searchGrayImage;
        [_searchController.searchBar setSearchFieldBackgroundImage:self.searchWhiteImage forState:UIControlStateNormal];
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;//关闭提示
        _searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭自动首字母大写
    }
    return _searchController;
}

- (UIImage *)searchGrayImage{
    if (!_searchGrayImage) {
        _searchGrayImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"] size:CGSizeMake(ScreenWidth - 14, 26)];
    }
    return _searchGrayImage;
}

- (UIImage *)searchWhiteImage{
    if (!_searchWhiteImage) {
        _searchWhiteImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(ScreenWidth - 14, 26)];
    }
    return _searchWhiteImage;
}

- (void)viewDidLayoutSubviews{
    if (self.searchController.active) {
        [self.tableView setFrame:CGRectMake(0, 20, ScreenWidth, self.view.height - 20)];
    }else{
        self.tableView.frame = self.view.bounds;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
