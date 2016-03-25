//
//  DHSegmentedControlView.m
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHSegmentedControlView.h"

enum {
    ButtonTag = 1000
};

@interface DHSegmentedControlView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) UITableView * moreItemsTableView;
@property (nonatomic, assign, readonly) CGFloat itemWidth;

@property (nonatomic, strong) NSMutableArray * buttons;


@property (nonatomic, assign) BOOL isPullDown;
@property (nonatomic, weak) UIButton * selectedButton;
@property (nonatomic, weak) UIButton * moreButton;

@property (nonatomic, strong) UIView * indicatorView;
@property (nonatomic, strong) UIButton * arrowView;
@property (nonatomic, strong) UIToolbar * backView;

@property (nonatomic, strong) UIVisualEffectView * tableEffectView;

- (void)_pullDown;
- (void)_retract;
- (void)_setDefault;
- (void)_onButton:(UIButton *)button;


@end

@implementation DHSegmentedControlView


- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [items copy];
        self.isPullDown = NO;
        [self addSubview:self.backView];
        [self.items enumerateObjectsUsingBlock:^(NSString * item, NSUInteger idx, BOOL *stop) {
            if (idx == maxItemCount_) {
                self.moreButton = self.buttons.lastObject;
                [self addSubview:self.arrowView];
                *stop = YES;
                return;
            }
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:item forState:UIControlStateNormal];
            button.frame = CGRectMake(idx * self.itemWidth, 0, self.itemWidth, CGRectGetHeight(frame));
            button.titleLabel.font = [UIFont systemFontOfSize:CGRectGetHeight(frame)/4];
            button.tag = idx + ButtonTag;
            [button addTarget:self action:@selector(_onButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self.buttons addObject:button];
            
        }];
        self.selectedButton = self.buttons.firstObject;
        
        _currentIndex = 0;
        [self addSubview:self.indicatorView];
        
        [self _setDefault];
    }
    return self;
}

#pragma mark - interface methods



#pragma mark - private methods
- (void)_setDefault
{
    self.tintColor = [UIColor colorWithRed:4.f/255 green:175.f/255 blue:200.f/255 alpha:1];
    self.selectedTitleColor = [UIColor orangeColor];
//    self.backgroundColor = [UIColor darkGrayColor];
}

- (void)_pullDown
{
    [self.superview addSubview:self.tableEffectView];
    [UIView animateWithDuration:0.38 animations:^{
        CGRect frame = self.tableEffectView.frame;
        frame.size.height = (self.items.count - maxItemCount_ + 1) * 44;
        self.tableEffectView.frame = frame;
        self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, M_PI);
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlViewDidPullDownMoreItems:)]) {
            [self.delegate segmentedControlViewDidPullDownMoreItems:self];
        }
        self.isPullDown = finished;
    }];
}

- (void)_retract
{
    [UIView animateWithDuration:0.38 animations:^{
        CGRect frame = self.tableEffectView.frame;
        frame.size.height = 0;
        self.tableEffectView.frame = frame;
        self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, M_PI);
    } completion:^(BOOL finished) {
        [self.tableEffectView removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlViewDidRetractMoreItems:)]) {
            [self.delegate segmentedControlViewDidRetractMoreItems:self];
        }
        self.isPullDown = !finished;
    }];
}

- (void)_onButton:(UIButton *)button
{
    if (button == self.moreButton) {
        if (self.isPullDown) {
            [self _retract];
        } else {
            [self _pullDown];
        }
        
        return;
    }
    if (self.isPullDown) {
        [self _retract];
    }
    
    self.currentIndex = button.tag - ButtonTag;
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlView:didMoveToIndex:)]) {
        [self.delegate segmentedControlView:self didMoveToIndex:self.currentIndex];
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    if (currentIndex < maxItemCount_ - 1) {
        
        UIButton * button = self.buttons[currentIndex];
        [self.selectedButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        self.selectedButton = button;
        [self.selectedButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        
        [self.selectedButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.38 animations:^{
            CGRect frame = self.indicatorView.frame;
            frame.origin.x = self.currentIndex * self.itemWidth + 10;
            self.indicatorView.frame = frame;
        }];
    } else {
        
        UIButton * button = self.buttons.lastObject;
        NSUInteger index = currentIndex;
        [button setTitle:self.items[index] forState:UIControlStateNormal];
        [self.selectedButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        self.selectedButton = button;
        [self.selectedButton setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
        [UIView animateWithDuration:0.38 animations:^{
            CGRect frame = self.indicatorView.frame;
            frame.origin.x = 3 * self.itemWidth + 10;
            self.indicatorView.frame = frame;
        }];
        if (self.isPullDown) {
            [self _retract];
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count - maxItemCount_ + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (self.titleFont) {
        cell.textLabel.font = self.titleFont;
    }
    cell.textLabel.textColor = self.tintColor;
    cell.textLabel.text = self.items[indexPath.row + maxItemCount_ - 1];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = indexPath.row + maxItemCount_ - 1;
    self.currentIndex = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlView:didMoveToIndex:)]) {
        [self.delegate segmentedControlView:self didMoveToIndex:index];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - setter
- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL *stop) {
        [button setTitleColor:self.tintColor forState:UIControlStateNormal];
        button.layer.borderColor = tintColor.CGColor;
    }];
    self.indicatorView.backgroundColor = tintColor;
    self.arrowView.tintColor = tintColor;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL *stop) {
        button.titleLabel.font = titleFont;
    }];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    [self.selectedButton setTitleColor:selectedTitleColor forState:UIControlStateNormal];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

#pragma mark - getter

- (CGFloat)itemWidth
{
    CGFloat width = CGRectGetWidth(self.frame);
    if (self.items.count > maxItemCount_) {
        return width / maxItemCount_;
    }
    return CGRectGetWidth(self.frame) / self.items.count;
}

- (UITableView *)moreItemsTableView
{
    if (!_moreItemsTableView) {
        
        _moreItemsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.itemWidth, (self.items.count - maxItemCount_ + 1) * 44) style:UITableViewStylePlain];
        [_moreItemsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _moreItemsTableView.dataSource = self;
        _moreItemsTableView.delegate = self;
        _moreItemsTableView.tableFooterView = [[UIView alloc] init];
        _moreItemsTableView.alwaysBounceVertical = NO;
        _moreItemsTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
        _moreItemsTableView.backgroundColor = [UIColor clearColor];
    }
    return _moreItemsTableView;
}

- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:0];
    }
    return _buttons;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame) - 4, self.itemWidth - 20, 2)];
        _indicatorView.layer.cornerRadius = 1;
    }
    return _indicatorView;
}

- (UIButton *)arrowView
{
    if (!_arrowView) {
        _arrowView = [UIButton buttonWithType:UIButtonTypeSystem];
        _arrowView.frame = CGRectMake(CGRectGetWidth(self.frame) - 20, 0, 20, 18);
        [_arrowView setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal];
        CGPoint center = _arrowView.center;
        _arrowView.userInteractionEnabled = NO;
        center.y = CGRectGetHeight(self.frame)/2;
        _arrowView.center = center;
    }
    return _arrowView;
}

- (UIToolbar *)backView
{
    if (!_backView) {
        _backView = [[UIToolbar alloc] initWithFrame:self.bounds];
    }
    return _backView;
}

- (UIVisualEffectView *)tableEffectView
{
    if (!_tableEffectView) {
        
        CGFloat height = CGRectGetMaxY(self.frame);
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = CGRectMake((maxItemCount_ - 1) * self.itemWidth, height, self.itemWidth, 0);
        effectView.layer.masksToBounds = YES;
        
        UIVibrancyEffect * vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
        
        UIVisualEffectView * vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        vibrancyEffectView.frame = self.moreItemsTableView.bounds;
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:vibrancyEffectView.bounds];
        tableView.backgroundColor = [UIColor clearColor];
        
        [vibrancyEffectView.contentView addSubview:self.moreItemsTableView];
        [effectView.contentView addSubview:vibrancyEffectView];
        
        _tableEffectView = effectView;
    }
    return _tableEffectView;
}

@end
