//
//  ERSegmentMenuController.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/6/29.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ERSegmentMenuController;

@protocol ERSegmentMenuControllerDataSource <NSObject>

@required;

/**
 已经选择的频道列表信息

 @param segmentMenuController self
 @return 必须为字典型数组(必须包含一个KEY为@"name"的字符串)
 */
- (NSMutableArray<NSDictionary *> *)selectedChannelLisInSegmentMenuController:(ERSegmentMenuController *)segmentMenuController;


/**
 未选择的频道列表信息
 
 @param segmentMenuController self
 @return 可以为nil ,若不为nil则必须为字典型数组(必须包含一个KEY为@"name"的字符串)
 */
- (NSMutableArray<NSDictionary *> *)unSelectChannelListInSegmentMenuController:(ERSegmentMenuController *)segmentMenuController;

@end

@protocol ERSegmentMenuControllerDelegate <NSObject>

@optional;

- (void)displayChannelListDidChange;

@end

@interface ERSegmentMenuController : UIViewController

@property (nonatomic, weak) id<ERSegmentMenuControllerDataSource> dataSource;

@property (nonatomic, weak) id<ERSegmentMenuControllerDelegate> delegate;

- (void)reloadData;

@end
