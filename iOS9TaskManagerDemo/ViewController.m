//
//  ViewController.m
//  iOS9TaskManagerDemo
//
//  Created by lizhao on 16/1/31.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"
#import "Dimension.h"
@interface ViewController () <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) iCarousel *taskManagerView;
@property (nonatomic, assign) CGSize taskSize;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat taskSize = [UIScreen mainScreen].bounds.size.width * 5.0f / 7.0f;
    self.taskSize = CGSizeMake(taskSize, taskSize * 16 / 9.0) ;
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.taskManagerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (iCarousel *)taskManagerView {
    if (!_taskManagerView) {
        _taskManagerView = [[iCarousel alloc] initWithFrame:self.view.bounds];
        _taskManagerView.delegate = self;
        _taskManagerView.dataSource = self;
        [_taskManagerView setType:iCarouselTypeCustom];
        _taskManagerView.bounceDistance = 0.1;
    }
    
    return _taskManagerView;
}

#pragma mark - DataSource Delegate

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return 7;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *taskView = view;
    if (!taskView) {
        taskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.taskSize.width, self.taskSize.height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:taskView.bounds];
        [taskView addSubview:imageView];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setBackgroundColor:[UIColor whiteColor]];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd.png", index]];
        imageView.image = image;
        taskView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        taskView.layer.shadowRadius = 3.0f;
        taskView.layer.shadowColor = [UIColor blackColor].CGColor;
        taskView.layer.shadowOffset = CGSizeZero;
        
        CAShapeLayer *layer =[CAShapeLayer layer];
        layer.frame = imageView.bounds;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:5.0f].CGPath;
        imageView.layer.mask = layer;
        
    }
    return taskView;
}

//计算缩放
- (CGFloat) calcScaleWithOffset:(CGFloat)offset {
    return offset * 0.02f + 1.0f;
}

//计算位移
- (CGFloat)calcTranslationWithOffset:(CGFloat)offset {
    CGFloat z = 5.0f/4.0f;
    CGFloat a = 5.0f/8.0f;
    
    //移出屏幕
    if (offset >= z/a) {
        return 2.0f;
    }
    return 1/(z-a*offset) - 1/z;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    NSLog(@"%f",offset);
    
    CGFloat scale = [self calcScaleWithOffset:offset];
    CGFloat translation = [self calcTranslationWithOffset:offset];
    return CATransform3DScale(CATransform3DTranslate(transform, translation * self.taskSize.width, 0, offset), scale, scale, 0);
}
@end
