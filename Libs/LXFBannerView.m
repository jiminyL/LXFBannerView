//
//  LXFBannerView.m
//  TestBannerView
//
//  Created by 梁啸峰 on 2019/3/1.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXFBannerView.h"

#import "LXFStyledPageControl.h"
//#import <SDWebImage/UIImageView+WebCache.h>

@interface LXFBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) LXFStyledPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *preIV;
@property (nonatomic, strong) UIImageView *midIV;
@property (nonatomic, strong) UIImageView *nextIV;

@property (nonatomic) dispatch_source_t timer;

@property (nonatomic) BOOL userAutoScroll;
@property (nonatomic) BOOL canAutoScroll;
@property (nonatomic) BOOL frozenTime;

@end

@implementation LXFBannerView

- (instancetype)init {
    return [self initWithAutoPlay:YES];
}

- (instancetype)initWithAutoPlay:(BOOL)autoPlay {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        self.userAutoScroll = autoPlay;
        self.canAutoScroll = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidTouchEvent)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)didChangeConfigInfo {
    [self stopTimer];
    [self startTimer];
}

- (void)refreshViews {
    [self.scrollView setFrame:self.bounds];
    
    self.pageControl.numberOfPages = (int)self.bannerModelArr.count;
    CGFloat pageWidth = self.bannerModelArr.count * 12.f;
    [self.pageControl setFrame:CGRectMake((self.frame.size.width - pageWidth)/2, self.frame.size.height - 18.f, pageWidth, 12.f)];
    
    CGFloat offsetX = 0.f;
    [self.preIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    [self.midIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    [self.nextIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    [self.scrollView setContentSize:CGSizeMake(offsetX, self.bounds.size.height)];
}

- (void)startTimer {
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    NSInteger interval_time = 5;
    interval_time = interval_time <= 0 ? 5 : interval_time;
    dispatch_source_set_timer(self.timer, interval_time * NSEC_PER_SEC, interval_time * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) mself = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.canAutoScroll && !self.frozenTime) {
            [mself.scrollView setContentOffset:CGPointMake(mself.scrollView.contentOffset.x + mself.scrollView.bounds.size.width, 0.f) animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [mself scrollToNext];
            });
        }
    });
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)setBannerModelArr:(NSArray<LXFBannerModel *> *)bannerModelArr {
    _bannerModelArr = bannerModelArr;
    
    [self refreshViews];
    
    self.currentIndex = 0;
    
    if (bannerModelArr.count > 0 && self.userAutoScroll) {
        [self startTimer];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    LXFBannerModel *currentBanner = self.bannerModelArr[currentIndex];
    if (currentBanner.image) {
        self.midIV.image = currentBanner.image;
    }else {
//        [self.midIV sd_setImageWithURL:[NSURL URLWithString:strOrEmpty(currentBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];
    }
    
    NSInteger preIndex;
    if (currentIndex == 0) {
        preIndex = self.bannerModelArr.count - 1;
    }else {
        preIndex = currentIndex - 1;
    }
    LXFBannerModel *preBanner = self.bannerModelArr[preIndex];
    if (preBanner.image) {
        self.preIV.image = preBanner.image;
    }else {
//        [self.preIV sd_setImageWithURL:[NSURL URLWithString:strOrEmpty(preBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];
    }
    
    NSInteger nextIndex;
    if (currentIndex == (self.bannerModelArr.count - 1)) {
        nextIndex = 0;
    }else {
        nextIndex = currentIndex + 1;
    }
    LXFBannerModel *nextBanner = self.bannerModelArr[nextIndex];
    if (nextBanner.image) {
        self.nextIV.image = nextBanner.image;
    }else {
//        [self.nextIV sd_setImageWithURL:[NSURL URLWithString:strOrEmpty(nextBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];
    }

    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.f)];
    
    self.pageControl.currentPage = (int)self.currentIndex;
}

#pragma mark - Event
- (void)scrollToPre {
    if (self.currentIndex == 0) {
        self.currentIndex = (self.bannerModelArr.count - 1);
    }else {
        self.currentIndex -= 1;
    }
}

- (void)scrollToNext {
    if (self.currentIndex >= (self.bannerModelArr.count - 1)) {
        self.currentIndex = 0;
    }else {
        self.currentIndex += 1;
    }
}

- (void)selfDidTouchEvent {
    LXFBannerModel *currentBanner = self.bannerModelArr[self.currentIndex];
    if (self.didTouchEvent) {
        self.didTouchEvent(currentBanner, self.currentIndex);
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.canAutoScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.canAutoScroll = YES;
    self.frozenTime = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.frozenTime = NO;
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((scrollView.contentOffset.x > - 50.f) && (scrollView.contentOffset.x < 50.f)) {
        [self scrollToPre];
    }else if ((scrollView.contentOffset.x > (self.scrollView.bounds.size.width - 50.f)) && (scrollView.contentOffset.x < (self.scrollView.bounds.size.width + 50.f))) {
        
    }else if ((scrollView.contentOffset.x > (self.scrollView.bounds.size.width*2 - 50.f)) && (scrollView.contentOffset.x < (self.scrollView.bounds.size.width*2 + 50.f))) {
        [self scrollToNext];
    }
}

#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (LXFStyledPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[LXFStyledPageControl alloc]initWithFrame:CGRectZero];
        _pageControl.coreNormalColor = [UIColor whiteColor];
        _pageControl.coreSelectedColor= UIColor.blackColor;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        _pageControl.strokeWidth = 0;
        _pageControl.diameter = 7;
        _pageControl.gapWidth = 20;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (UIImageView *)preIV {
    if (!_preIV) {
        _preIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_preIV];
    }
    return _preIV;
}

- (UIImageView *)midIV {
    if (!_midIV) {
        _midIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_midIV];
    }
    return _midIV;
}

- (UIImageView *)nextIV {
    if (!_nextIV) {
        _nextIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_nextIV];
    }
    return _nextIV;
}

@end











//Model -----------------------------------------------
@implementation LXFBannerModel



@end
