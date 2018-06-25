#import "AFPageScrollView.h"
#import "AFPageScrollViewPrivate.h"
#import "AFPhotoBrowser.h"

@implementation AFPageScrollView

- (id)initWithDelegate:(id<AFPageScrollViewDelegate>)delegate {
    if (self == [self initWithFrame:CGRectZero]) {
        _pageDelegate = delegate;
         [self initialProperties];
    }
    return self;
}

- (id)initWithPhotos:(NSArray *)photos {
    if (self == [self initWithFrame:CGRectZero]) {
        _fixedPhotosArray = photos;
         [self initialProperties];
    }
    return self;
}

- (id)initWithPhotoBrowser:(AFPhotoBrowser *)photoBrowser {
    if (self == [self initWithFrame:CGRectZero]) {
        _photoBrowser = photoBrowser;
        [self initialProperties];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
		[self initialProperties];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self initialProperties];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [self initialProperties];
    [super awakeFromNib];
}

- (void)initialProperties {
    
    _currentPageIndex = 0;
    _previousPageIndex = NSIntegerMax;
    
    _rotating = NO;
    _performingLayout = NO;
    _viewIsActive = NO;
    
    
    _photoCount = NSNotFound;
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willTransitionToTraitCollection:) name:AFPHOTOBROWSER_WILL_TRANSITION_TO_TRAINT_COLLECTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTransitionToTraitCollection:) name:AFPHOTOBROWSER_DID_TRANSITION_TO_TRAINT_COLLECTION object:nil];
    
}

- (void)setup {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _pagingScrollView.backgroundColor = [UIColor purpleColor];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.delegate = self;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self addSubview:_pagingScrollView];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 11000
    _pagingScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // Or vertical content error
#endif
    
    if (!_disableIndicator) {
        CGPoint pagingIndicatorCenter = [self centerForPagingIndicator];
        _pagingIndicator = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pagingIndicator.transform = CGAffineTransformMakeRotation(M_PI/2);
        _pagingIndicator.backgroundColor = [UIColor orangeColor];
        _pagingIndicator.center = pagingIndicatorCenter;
        _pagingIndicator.pageIndicatorTintColor = [UIColor lightTextColor];
        _pagingIndicator.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pagingIndicator.numberOfPages = [self numberOfPhotos];
        [self addSubview:_pagingIndicator];
        [self bringSubviewToFront:_pagingIndicator];
    }
    
    // Update
    [self reloadData];
}

- (void)prepareForReuse {
    _currentPageIndex = 0;
    _previousPageIndex = NSIntegerMax;
    
    _rotating = NO;
    _performingLayout = NO;
    _viewIsActive = NO;
    
    
    _photoCount = NSNotFound;
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
}

- (void)didMoveToSuperview {
    _viewIsActive = YES;
    
    [super didMoveToSuperview];
}

- (void)removeFromSuperview {
    _viewIsActive = NO;
    
    [super removeFromSuperview];
}

#pragma mark - Notifications

- (void)willTransitionToTraitCollection:(NSNotification *)notify {
    _rotating = YES;
    
    [self layoutVisiblePages];
    
}

- (void)didTransitionToTraitCollection:(NSNotification *)notify {
    
    _rotating = NO;
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    [self layoutVisiblePages];
    
    [super layoutSubviews];
}

- (void)performLayout {
    _performingLayout = YES;
    
    // Content offset
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    [self tilePages];
    _performingLayout = NO;
}


- (void)layoutVisiblePages {
    _performingLayout = YES;
    
    // Remember index
    NSUInteger indexPriorToLayout = _currentPageIndex;
    
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    if (!_disableIndicator) {
        _pagingIndicator.center = [self centerForPagingIndicator];
    }
    
    
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
    
    
    _currentPageIndex = indexPriorToLayout;
    _performingLayout = NO;
}


#pragma mark - Rotation


#pragma mark - Data

- (void)reloadData {
    
    _photoCount = NSNotFound;
    
    NSInteger numberOfPhotos = [self numberOfPhotos];
    
    [_photos removeAllObjects];
    [_thumbPhotos removeAllObjects];
    for (int i = 0; i < numberOfPhotos; i++) {
        [_photos addObject:[NSNull null]];
        [_thumbPhotos addObject:[NSNull null]];
    }
    
    if (numberOfPhotos > 0) {
        _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
    } else {
        _currentPageIndex = 0;
    }
    
    if (_viewIsActive) {
        while (_pagingScrollView.subviews.count) {
            [_pagingScrollView.subviews.lastObject removeFromSuperview];
        }
        [self performLayout];
        [self setNeedsLayout];
    }
}

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

- (id<AFPhoto>)photoAtIndex:(NSInteger)index {
    id<AFPhoto> photo = nil;
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_pageDelegate respondsToSelector:@selector(scrollView:photoAtIndex:)]) {
                photo = [_pageDelegate scrollView:self photoAtIndex:index];
            } else if (_fixedPhotosArray && index < _fixedPhotosArray.count) {
                photo = [_fixedPhotosArray objectAtIndex:index];
            }
            if (photo)  [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    return photo;
}


- (id<AFPhoto>)thumbPhotoAtIndex:(NSInteger)index {
    id<AFPhoto> photo = nil;
    if (index < _thumbPhotos.count) {
        if ([_thumbPhotos objectAtIndex:index] == [NSNull null]) {
            if ([_pageDelegate respondsToSelector:@selector(scrollView:thumbPhotoAtIndex:)]) {
                [_pageDelegate scrollView:self thumbPhotoAtIndex:index];
            }
            if (photo) [_thumbPhotos replaceObjectAtIndex:index withObject:photo];
        }
    } else {
        photo = [_thumbPhotos objectAtIndex:index];
    }
    return photo;
}

//- (UIImage *)imageForPhoto:(id<AFPhoto>)photo {
//
//
//}

#pragma mark - Paging

- (void)tilePages {
    
    
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    
    if (![self numberOfPhotos]) {
        return;
    }
    
    if (!_disableIndicator) {
        _pagingIndicator.currentPage = index;
    }
    
    if (index != _previousPageIndex) {
        if ([_pageDelegate respondsToSelector:@selector(scrollView:didDisplayPhotoAtIndex:)]) {
            [_pageDelegate scrollView:self didDisplayPhotoAtIndex:index];
        }
        _previousPageIndex = index;
    }
    
    
    
    
    
}

#pragma mark - Frame Calculations

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = _pagingScrollView.bounds;
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

- (CGPoint)contentOffsetForPageAtIndex:(NSInteger)index {
    CGFloat pageHeight = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index * pageHeight;
    return CGPointMake(0, newOffset);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Checks
    if (!_viewIsActive || _performingLayout || _rotating) return;
    
    // Tile pages
    [self tilePages];
    
    // Calculate current page
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidY(visibleBounds) / CGRectGetHeight(visibleBounds)));
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































