//
//  DHSegmentedControlView.h
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  显示的最大数量，超过这个数量后最后一个按钮会下拉出剩余所有的item
 */
static const NSUInteger maxItemCount_ = 4;

@class DHSegmentedControlView;

@protocol DHSegmentedControlViewDelegate <NSObject>

@optional

- (void)segmentedControlView:(DHSegmentedControlView *)segmentedControlView didMoveToIndex:(NSUInteger)index;
- (void)segmentedControlViewDidPullDownMoreItems:(DHSegmentedControlView *)segmentedControlView;
- (void)segmentedControlViewDidRetractMoreItems:(DHSegmentedControlView *)segmentedControlView;

@end

@interface DHSegmentedControlView : UIView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, strong) UIColor * selectedTitleColor;
@property (nonatomic, strong) UIColor * indicatorColor;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) UIFont * titleFont;


@property (nonatomic, weak) id <DHSegmentedControlViewDelegate> delegate;

@end








