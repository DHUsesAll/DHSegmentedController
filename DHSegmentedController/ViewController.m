//
//  ViewController.m
//  DHSegmentedController
//
//  Created by DreamHack on 16-3-24.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"1.jpg"].CGImage;
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.text = self.title;
    label.font = [UIFont systemFontOfSize:24];
    label.center = self.view.center ;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
