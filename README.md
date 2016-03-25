# DHSegmentedController

##分段控制器
效果见图
![1](https://github.com/DHUsesAll/GitImages/blob/master/DHSegmentedController/1.gif)

##亮点：
1、动态加载页面：页面滑动的一瞬间才加载即将显示的页面，内存最优化（静止状态只有当前页面被加到视图层级上，滑动过程中最多两个页面加载到视图层级上）
2、无论从第几页跳转到第几页，永远只有一页的动画（比如从第1页到第5页只会向左滑动一页的宽度而不会呼啦啦滑动4页的距离）
3、控制器默认最多显示四条数据，如果有超过4条的，则在最后一条的下拉列表中进行选择。可以通过修改头文件中的静态变量maxCount_来进行设置，没有提供接口设置是因为我认为这个东西显示多了用户体验不好。

##Useage
用法和标签控制器类似，只是ViewController的数组需要在初始化方法中直接传入。
contentFrame表示分段控制器自身的frame
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
