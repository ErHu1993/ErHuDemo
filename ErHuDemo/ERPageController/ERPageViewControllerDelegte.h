//
//  ERPageViewControllerDelegte.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/27.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ERPageViewController,ERSegmentController,ERSegmentCollectionViewCell;

@protocol ERPageViewControllerDelegte <NSObject>

@optional

//- (void)segmentController:(ERSegmentController *)segmentController displayCell:(ERSegmentCollectionViewCell *)displayCell title:(NSString *)title indexPath:(NSIndexPath *)indexPath;

- (void)pageControllerScrolling:(ERPageViewController *)pageController FromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end
