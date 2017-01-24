//
//  JAPageControl.m
//  JAPageControl
//
//  Created by daisuke on 2017/1/23.
//  Copyright © 2017年 dse12345z. All rights reserved.
//

#import "JAPageControl.h"

@interface JAPageControl() <UIScrollViewDelegate>

@property (strong, nonatomic) UIView *animateCircle;
@property (strong, nonatomic) NSMutableArray *circles;
@property (assign, nonatomic) NSInteger startOffset;
@property (assign, nonatomic) NSInteger currentPage;

@property (readonly, nonatomic) CGFloat gap;
@property (readonly, nonatomic) CGFloat circleHeight;
@property (readonly, nonatomic) CGFloat circleWidth;

@end

@implementation JAPageControl
@synthesize scrollView = _scrollView;
@synthesize pageCount = _pageCount;
@synthesize selectedColor = _selectedColor;
@synthesize unSelectedColor = _unSelectedColor;

#pragma mark - properties

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.delegate = self;
}

- (UIScrollView *)scrollView {
    return _scrollView;
}

- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    [self setupCircleView];
}

- (NSInteger)pageCount {
    return _pageCount;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (!self.animateCircle) {
        [self setupCircleView];
    }
    else {
        [self resetCircleColor];
    }
}

- (UIColor *)selectedColor {
    return _selectedColor ? _selectedColor : [UIColor whiteColor];
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    _unSelectedColor = unSelectedColor;
    if (!self.animateCircle) {
        [self setupCircleView];
    }
    else {
        [self resetCircleColor];
    }
}

- (UIColor *)unSelectedColor {
    return _unSelectedColor ? _unSelectedColor : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.2f];
}

#pragma mark * readonly

- (CGFloat)gap {
    return 10.0f;
}

- (CGFloat)circleHeight {
    return 10.0f;
}

- (CGFloat)circleWidth {
    return 10.0f;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // page value
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    CGFloat pageHalfWidth = (pageWidth / 2.0f);
    
    // scroll min/max bound
    CGFloat minBound = 0;
    CGFloat maxBound = pageWidth * (self.pageCount - 1);
    BOOL isScrollBoundRange = (scrollView.contentOffset.x >= minBound && scrollView.contentOffset.x <= maxBound);
    if (isScrollBoundRange) {
        
        // full page index, continuous scroll page, need change page index
        NSInteger pageIndex = (scrollView.contentOffset.x / pageWidth);
        if (self.currentPage != pageIndex) {
            self.currentPage = pageIndex;
            self.startOffset = scrollView.contentOffset.x;
        }
        
        // half page index, turn the page halfway, page index
        int pageHalfIndex = floor((scrollView.contentOffset.x - pageHalfWidth) / pageWidth) + 1;
        
        // modify animateCircle frame
        CGRect animateCircleFrame = self.animateCircle.frame;
        CGFloat pageOffset = scrollView.contentOffset.x - (self.currentPage * pageWidth);
        if (self.currentPage == pageHalfIndex) {
            CGFloat mainValue = MIN(pageHalfWidth, (pageOffset * 2.5));
            CGFloat flexibleWidth = (self.circleWidth * (mainValue / pageHalfWidth));
            
            // circleWidth + flexibleWidth(max) = circleWidth + self.gap
            animateCircleFrame.size.width = self.circleWidth + flexibleWidth;
            
            // modify circle backgroundColor
            UIView *circle = self.circles[pageHalfIndex];
            circle.backgroundColor = self.unSelectedColor;
        }
        else {
            CGFloat mainValue = MIN(pageHalfWidth, ((pageOffset - pageHalfWidth)));
            CGFloat flexibleWidth = (self.circleWidth * (mainValue / pageHalfWidth));
            CGFloat animateCircleMaxWidth = (self.circleWidth + self.gap);
            animateCircleFrame.size.width = animateCircleMaxWidth - flexibleWidth;
            
            // modify circle backgroundColor
            UIView *circle = self.circles[self.currentPage + 1];
            circle.backgroundColor = self.selectedColor;
        }
        
        // modify animateCircle x
        CGFloat nextCircleX = (self.circleWidth + self.gap);
        CGFloat flexibleX = (nextCircleX / pageWidth) * scrollView.contentOffset.x;
        animateCircleFrame.origin.x = flexibleX;
        self.animateCircle.frame = animateCircleFrame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    NSInteger pageIndex = scrollView.contentOffset.x / pageWidth;
    self.currentPage = pageIndex;
}

#pragma mark - private instance method

#pragma mark * init values

- (void)setupInitValues {
    self.circles = [NSMutableArray new];
    self.currentPage = 0;
}

- (void)setupCircleView {
    [self setupFrame];
    
    for (NSInteger index = 0; index < self.pageCount; index++) {
        CGFloat x = (self.circleHeight * index) + (index * self.gap);
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.circleHeight, self.circleHeight)];
        circle.backgroundColor = self.selectedColor;
        circle.layer.cornerRadius = self.circleHeight / 2.0f;
        circle.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        [self addSubview:circle];
        [self.circles addObject:circle];
    }
    self.animateCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.circleHeight, self.circleHeight)];
    self.animateCircle.layer.cornerRadius = self.circleHeight / 2.0f;
    self.animateCircle.backgroundColor = self.selectedColor;
    [self addSubview:self.animateCircle];
}

- (void)setupFrame {
    CGRect newFrame = self.frame;
    newFrame.size.height = self.circleHeight;
    newFrame.size.width = (self.pageCount * self.circleHeight) + ((self.pageCount - 1) * self.gap);
    self.frame = newFrame;
}

#pragma mark * misc

- (void)resetCircleColor {
    self.animateCircle.backgroundColor = self.selectedColor;
    for (NSInteger index = 0; index < self.circles.count; index++) {
        UIView *circle = self.circles[index];
        circle.backgroundColor = (index >= self.currentPage) ? self.selectedColor : self.unSelectedColor;
    }
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInitValues];
    }
    return self;
}

@end
