//
//  AppDelegate.m
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "AppDelegate.h"
#import "DHSegmentedController.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 6; i++) {
        ViewController * vc = [[ViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"第%d个",i];
        [viewControllers addObject:vc];
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = 64;
    frame.size.height -= 64;
    
    DHSegmentedController * segmentedController = [[DHSegmentedController alloc] initWithViewControllers:viewControllers contentFrame:frame];
    segmentedController.titleFont = [UIFont systemFontOfSize:16];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    segmentedController.tintColor = [UIColor blackColor];
//    segmentedController.selectedTitleColor = [UIColor greenColor];
//    segmentedController.indicatorColor = [UIColor purpleColor];
    self.window.rootViewController = segmentedController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
