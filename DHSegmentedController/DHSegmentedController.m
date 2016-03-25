//
//  DHSegmentedController.m
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHSegmentedController.h"
#import "DHSegmentedControlView.h"


@interface DHSegmentedController () <UIScrollViewDelegate, DHSegmentedControlViewDelegate>


@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray * viewControllers;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) DHSegmentedControlView * segmentedView;

@property (nonatomic, weak) UIViewController * selectedViewController;

@property (nonatomic, assign, readonly) CGRect leftFrame;
@property (nonatomic, assign, readonly) CGRect midFrame;
@property (nonatomic, assign, readonly) CGRect rightFrame;

@property (nonatomic, assign) CGFloat currentOffset;

@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * midView;
@property (nonatomic, strong) UIView * rightView;

@end

@implementation DHSegmentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * viewController, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftView];
    if (self.viewControllers.count >= 2) {
        [self.scrollView addSubview:self.midView];
    }
    
    if (self.viewControllers.count >= 3) {
        [self.scrollView addSubview:self.rightView];
    }
    self.currentPage = 0;
    self.currentOffset = 0;
    [self.view addSubview:self.segmentedView];
    
    self.selectedViewController = self.viewControllers.firstObject;
    [self.scrollView addSubview:_selectedViewController.view];
}

- (instancetype)initWithViewControllers:(NSArray *)viewControllers contentFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.viewControllers = [viewControllers copy];
        self.frame = frame;
    }
    return self;
}

#pragma mark - private methods

- (void)_scrollViewDidEndScroll:(UIScrollView *)scrollView
{
    
    CGFloat width = CGRectGetWidth(scrollView.frame);
    
    NSInteger count = self.viewControllers.count;
    if (count == 2) {
        if (self.currentPage == 0) {
            [self.midView removeFromSuperview];
        } else {
            [self.leftView removeFromSuperview];
        }
        return;
    }
    UIViewController * currentVC = self.viewControllers[self.currentPage];
    if (self.currentPage == 0 ) {
        [self.leftView removeFromSuperview];
        [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [currentVC.view removeFromSuperview];
        [self.leftView addSubview:currentVC.view];
        [self.midView removeFromSuperview];
        [self.scrollView addSubview:self.leftView];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    
    if (self.currentPage == count - 1) {
        [self.rightView removeFromSuperview];
        [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [currentVC.view removeFromSuperview];
        [self.rightView addSubview:currentVC.view];
        [self.scrollView addSubview:self.rightView];
        [self.midView removeFromSuperview];
        self.scrollView.contentOffset = CGPointMake(width * 2, 0);
        return;
    }
    
    
    [currentVC.view removeFromSuperview];
    [self.midView addSubview:currentVC.view];
    
    UIViewController * leftVC = self.viewControllers[self.currentPage-1];
    [self.leftView removeFromSuperview];
    [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [leftVC.view removeFromSuperview];
    [self.leftView addSubview:leftVC.view];
    
    UIViewController * rightVC = self.viewControllers[self.currentPage+1];
    [self.rightView removeFromSuperview];
    [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [rightVC.view removeFromSuperview];
    [self.rightView addSubview:rightVC.view];
    
    scrollView.contentOffset = CGPointMake(width, 0);
    self.currentOffset = scrollView.contentOffset.x;
    
    
}

- (void)_scrollViewWillScrollToLeftWithIndex:(NSInteger)index
{
    
    NSInteger count = self.viewControllers.count;
    if (self.currentPage == count - 1) {
        return;
    }
    UIViewController * rightViewController = self.viewControllers[index];
    if (count == 2) {
        if (self.currentPage < self.viewControllers.count - 1) {
            [self.midView addSubview:rightViewController.view];
            [self.scrollView addSubview:self.midView];
        }
        return;
    }
    
    // 向左
    if (self.currentPage == self.viewControllers.count - 1) {
        return;
    }
    
    
    if (self.currentPage == 0) {
        [self.midView addSubview:rightViewController.view];
        [self.scrollView addSubview:self.midView];
    } else {
        [self.rightView addSubview:rightViewController.view];
        [self.scrollView addSubview:self.rightView];
    }
}

- (void)_scrollViewWillScrollToRightWithIndex:(NSInteger)index
{
    NSInteger count = self.viewControllers.count;
    if (self.currentPage == 0) {
        return;
    }
    
    if (count == 2) {
        if (self.currentPage > 0) {
            [self.scrollView addSubview:self.leftView];
        }
        return;
    }
    
    
    
    UIViewController * leftViewController = self.viewControllers[index];
    if (self.currentPage == self.viewControllers.count - 1) {
        [self.midView addSubview:leftViewController.view];
        [self.scrollView addSubview:self.midView];
    } else {
        [self.leftView addSubview:leftViewController.view];
        [self.scrollView addSubview:self.leftView];
    }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat offset = scrollView.contentOffset.x - self.currentOffset;
    _currentPage += offset/width;
    [self _scrollViewDidEndScroll:scrollView];
    self.segmentedView.currentIndex = self.currentPage;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self _scrollViewDidEndScroll:scrollView];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    // 控制每次拖动不会超过一页
    CGFloat width = CGRectGetWidth(scrollView.frame);
    CGFloat offset = targetContentOffset->x - self.currentOffset;
    if (offset > 0) {
        targetContentOffset->x = self.currentOffset + width;
    } else if (offset < 0){
        targetContentOffset->x = self.currentOffset - width;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.currentOffset = scrollView.contentOffset.x;
    
    CGRect frame = scrollView.frame;
    frame.origin = CGPointZero;
    
    UIPanGestureRecognizer * pan = scrollView.panGestureRecognizer;
    CGPoint velocity = [pan velocityInView:scrollView];
    if (velocity.x < 0) {
        [self _scrollViewWillScrollToLeftWithIndex:self.currentPage + 1];
    } else {
        [self _scrollViewWillScrollToRightWithIndex:self.currentPage - 1];
    }
}



#pragma mark - segmented control view delegate
- (void)segmentedControlView:(DHSegmentedControlView *)segmentedControlView didMoveToIndex:(NSUInteger)index
{
    [self setCurrentPage:index animated:YES];
}

#pragma mark - setter


- (void)setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)flag
{
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    if (currentPage > _currentPage) {
        [self _scrollViewWillScrollToLeftWithIndex:currentPage];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + width, 0) animated:flag];
    } else if (currentPage < _currentPage) {
        [self _scrollViewWillScrollToRightWithIndex:currentPage];
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - width, 0) animated:flag];
    }
    _currentPage = currentPage;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.segmentedView.titleFont = titleFont;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.segmentedView.tintColor = tintColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    self.segmentedView.selectedTitleColor = selectedTitleColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.segmentedView.indicatorColor = indicatorColor;
}

#pragma mark - getter

- (CGRect)leftFrame
{
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = 0;
    return frame;
}

- (CGRect)midFrame
{
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = CGRectGetWidth(frame);
    return frame;
}

- (CGRect)rightFrame
{
    CGRect frame = self.scrollView.bounds;
    frame.origin.x = CGRectGetWidth(frame) * 2;
    return frame;
}

- (UIView *)leftView
{
    if (!_leftView) {
        _leftView = [[UIView alloc] initWithFrame:self.leftFrame];
    }
    return _leftView;
}

- (UIView *)midView
{
    if (!_midView) {
        _midView = [[UIView alloc] initWithFrame:self.midFrame];
    }
    return _midView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:self.rightFrame];
    }
    return _rightView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        CGRect frame = self.frame;
        frame.origin.y += 44;
        frame.size.height = self.frame.size.height - 44;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        
        NSInteger count = self.viewControllers.count;
        if (count > 3) {
            count = 3;
        }
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * count, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (DHSegmentedControlView *)segmentedView
{
    if (!_segmentedView) {
        CGRect frame = self.frame;
        frame.size.height = 44;
        
        NSMutableArray * items = [NSMutableArray arrayWithCapacity:0];
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * vc, NSUInteger idx, BOOL *stop) {
            [items addObject:[NSString stringWithFormat:@"%@",vc.title]];
        }];
        
        _segmentedView = [[DHSegmentedControlView alloc] initWithFrame:frame items:items];
        _segmentedView.delegate = self;
        
    }
    return _segmentedView;
}


@end
