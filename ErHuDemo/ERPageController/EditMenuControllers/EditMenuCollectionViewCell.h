//
//  EditMenuCollectionViewCell.h
//  ErHuDemo
//
//  Created by 胡广宇 on 2017/7/4.
//  Copyright © 2017年 胡广宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditMenuCollectionViewCellDelegate <NSObject>

@optional;


/**
 删除按钮点击

 @param indexPath 当前indexPath
 */
- (void)didSelectDeleteItem:(NSIndexPath *)indexPath;

@end

@interface EditMenuCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *channelButton;

@property (nonatomic, weak) id<EditMenuCollectionViewCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL canEdit;

@end
