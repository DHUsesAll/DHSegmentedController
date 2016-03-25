//
//  DHSegmentedController.h
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHSegmentedController : UIViewController

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, strong) UIColor * tintColor;
@property (nonatomic, strong) UIColor * selectedTitleColor;
@property (nonatomic, strong) UIColor * indicatorColor;

- (void)setCurrentPage:(NSUInteger)currentPage animated:(BOOL)flag;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers contentFrame:(CGRect)frame;



@end
