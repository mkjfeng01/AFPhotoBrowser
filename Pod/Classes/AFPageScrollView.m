#import "AFPageScrollView.h"
#import "AFPageScrollViewPrivate.h"
#import "AFPhotoBrowser.h"

@implementation AFPageScrollView

- (id)initWithDelegate:(id<AFPageScrollViewDelegate>)delegate {
    if (self == [self initWithFrame:CGRectZero]) {
        _pageDelegate = delegate;
    }
    return self;
}

- (id)initWithPhotos:(NSArray *)photos {
    if (self == [self initWithFrame:CGRectZero]) {
        _fixedPhotosArray = photos;
    }
    return self;
}

- (id)initWithPhotoBrowser:(AFPhotoBrowser *)photoBrowser {
    if (self == [self initWithFrame:CGRectZero]) {
        _photoBrowser = photoBrowser;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [self setup];
    [super awakeFromNib];
}

- (void)initialProperties {
    
    _currentPageIndex = 0;
    _previousPageIndex = NSUIntegerMax;
    
    _rotating = NO;
    _disableIndicator = YES;
    _performingLayout = NO;
    _viewIsActive = NO;
    
    
    _photoCount = NSNotFound;
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTransitionToTraitCollection) name:AFPHOTO_BROWSER_WILL_TRANSITION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidTransitionToSize) name:AFPHOTO_BROWSER_DID_END_TRANSITION object:nil];
    
}

- (void)setup {
    
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _pagingScrollView.delegate = self;
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    if (!_disableIndicator) {
        CGPoint pagingIndicatorCenter = [self centerForPagingIndicator];
        _pagingIndicator = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pagingIndicator.center = pagingIndicatorCenter;
        _pagingIndicator.pageIndicatorTintColor = [UIColor lightTextColor];
        _pagingIndicator.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pagingIndicator.numberOfPages = [self numberOfPhotos];
        [self addSubview:_pagingIndicator];
    }
    
}

- (void)didMoveToSuperview {
    _viewIsActive = YES;
}

- (void)removeFromSuperview {
    _viewIsActive = NO;
}

#pragma mark - Notifications

- (void)willTransitionToTraitCollection:(NSNotification *)notify {
    
}

- (void)viewDidTransitionToSize:(NSNotification *)notify {
    
}



#pragma mark - Layout

- (void)performLayout {
    _performingLayout = YES;
    
    
    
    
    
    _performingLayout = NO;
}


- (void)layoutVisibleSections {
    _performingLayout = YES;
    
    
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    if (!_disableIndicator) {
        _pagingIndicator.center = [self centerForPagingIndicator];
    }
    
    
    
    _performingLayout = NO;
}


#pragma mark - Rotation


#pragma mark - Data

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_pageDelegate respondsToSelector:@selector(numberOfPhotosInPageScrollView:)]) {
            _photoCount = [_pageDelegate numberOfPhotosInPageScrollView:self];
        } else if (_fixedPhotosArray) {
            _photoCount = _fixedPhotosArray.count;
        }
    }
    if (_photoCount == NSNotFound) _photoCount = 0;
    return _photoCount;
}

#pragma mark - Paging

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    
    
}

#pragma mark - Frame Calculations

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = self.bounds;
    return CGSizeMake(bounds.size.width, bounds.size.height  * [self numberOfPhotos]);
}

- (CGPoint)centerForPagingIndicator {
    CGFloat offset = 22;
    
    CGRect bounds = _pagingScrollView.bounds;
    CGFloat centerX;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 11000
    centerX = bounds.size.width - [UIApplication sharedApplication].keyWindow.safeAreaInsets.right - offset;
#else
    centerX = bounds.size.width - offset;
#endif
    
    return CGPointMake(centerX, _pagingScrollView.center.y);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_viewIsActive || _performingLayout || _rotating) return;
    
    // Calculate current page
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
    NSUInteger previousCurrentPage = _currentPageIndex;
    _currentPageIndex = index;
    if (_currentPageIndex != previousCurrentPage) {
        [self didStartViewingPageAtIndex:index];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}






@end































