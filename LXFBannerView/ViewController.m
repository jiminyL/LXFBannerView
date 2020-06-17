//
//  ViewController.m
//  LXFBannerView
//
//  Created by 梁啸峰 on 2020/6/17.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "ViewController.h"

#import "LXFBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LXFBannerView *bannerView = [[LXFBannerView alloc] initWithAutoPlay:YES];
    NSMutableArray *pics = [[NSMutableArray alloc] init];
    {
        LXFBannerModel *m = [[LXFBannerModel alloc] init];
        m.image = [UIImage imageNamed:@"testImage.png"];
        m.imageUrl = @"";
        [pics addObject:m];
    }
    {
        LXFBannerModel *m = [[LXFBannerModel alloc] init];
        m.image = [UIImage imageNamed:@"testImage.png"];
        m.imageUrl = @"";
        [pics addObject:m];
    }
    {
        LXFBannerModel *m = [[LXFBannerModel alloc] init];
        m.image = [UIImage imageNamed:@"testImage.png"];
        m.imageUrl = @"";
        [pics addObject:m];
    }
    bannerView.bannerModelArr = pics;
    bannerView.frame = CGRectMake(0.f, 60.f, self.view.frame.size.width, 200);
    [self.view addSubview:bannerView];
    
}




@end
