#import "AFPhotoBrowser.h"
#import "AFPhotoBrowserPrivate.h"
#import "AFPageScrollView.h"

@interface AFPhotoBrowser ()

@end

@implementation AFPhotoBrowser

#pragma mark - Initial

- (id)initWithPhotos:(NSArray *)photosArray {
    if (self == [self init]) {
        _fixedPhotosArray = photosArray;
    }
    return self;
}

- (id)initWithDelegate:(id<AFPhotoBrowserDelegate>)delegate {
    if (self == [self init]) {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self initialProperties];
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
        [self initialProperties];
    }
    return self;
}

- (void)initialProperties {
    
    NSNumber *isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (isVCBasedStatusBarAppearanceNum) {
        _isVCBasedStatusBarAppearance = isVCBasedStatusBarAppearanceNum.boolValue;
    } else {
        _isVCBasedStatusBarAppearance = YES; // default
    }
    
    _sectionCount = NSNotFound;
    _currentSectionIndex = 0;
    _currentPhotoIndex = 0;
    _previousSectionIndex = NSIntegerMax;
    
    
    _performingLayout = NO;
    _rotating = NO;
    _viewIsActive = NO;
    
    
    _displayNavigationBar = YES;
    _statusBarShouldBeHidden = NO;
    _disableIndicator = NO;
    _alwaysShowControls = NO;
    _delayToHideElements = 5;
    
    
    _sections = [[NSMutableArray alloc] init];
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
}

#pragma mark - Life

- (void)dealloc {
    _pagingScrollView.delegate = nil;
}

- (void)viewDidLoad {
    
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.delegate = self;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self.view addSubview:_pagingScrollView];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 11000
    _pagingScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // Or vertical content error
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    
    if (!_disableIndicator) {
        CGPoint pagingIndicatorCenter = [self centerForPagingIndicator];
        _pagingIndicator = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pagingIndicator.center = pagingIndicatorCenter;
        _pagingIndicator.pageIndicatorTintColor = [UIColor lightTextColor];
        _pagingIndicator.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pagingIndicator.numberOfPages = [self numberOfSections];
        [self.view addSubview:_pagingIndicator];
    }
    
    [self reloadData];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if (self.navigationController) {
    //        [self.navigationController setNavigationBarHidden:!_displayNavigationBar animated:NO];
    // }
}

- (void)viewDidAppear:(BOOL)animated {
    _viewIsActive = YES;
    
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    _viewIsActive = NO;
    
    // Controls
    [self.navigationController.navigationBar.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self setControlsHidden:NO animated:NO];
    
    [super viewWillDisappear:animated];
}

#pragma mark - Layout

- (void)performLayout {
    
    _performingLayout = YES;
    
    // Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    // Update nav
    [self updateNavigation];
    
    // Content offset
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtSection:_currentSectionIndex];
    [self tilePages];
    _performingLayout = NO;
    
}


- (void)layoutVisibleSections {
    _performingLayout = YES;
    
    NSUInteger indexPriorToLayout = _currentSectionIndex;
    
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    if (!_disableIndicator) {
        _pagingIndicator.center = [self centerForPagingIndicator];
    }
    
    
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtSection:indexPriorToLayout];
    
    
    _currentSectionIndex = indexPriorToLayout;
    _performingLayout = NO;
}


#pragma mark - Transition

// viewWillTransitionToSize: vs willTransitionToTraitCollection:
// https://stackoverflow.com/questions/33377708/viewwilltransitiontosize-vs-willtransitiontotraitcollection
//
- (BOOL)prefersStatusBarHidden {
    return _statusBarShouldBeHidden;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _rotating = YES;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self layoutVisibleSections];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AFPHOTOBROWSER_WILL_TRANSITION_TO_TRAINT_COLLECTION object:coordinator];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self->_rotating = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AFPHOTOBROWSER_DID_TRANSITION_TO_TRAINT_COLLECTION object:coordinator];
    }];
}

#pragma mark - Paging

- (void)tilePages {
    
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger iFirstSection = (NSInteger)floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    NSInteger iLastSection = (NSInteger)floorf(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
    if (iFirstSection < 0) iFirstSection = 0;
    if (iFirstSection > [self numberOfSections] - 1) iFirstSection = [self numberOfSections] - 1;
    if (iLastSection < 0) iLastSection = 0;
    if (iLastSection > [self numberOfSections] - 1) iLastSection = [self numberOfSections] - 1;

    NSInteger pageSection;
    for (AFPageScrollView *page in _visiblePages) {
        pageSection = page.section;
        if (pageSection < iFirstSection || pageSection > iLastSection) {
            [_recycledPages addObject:page];
            [page prepareForReuse];
            [page removeFromSuperview];
            NSLog(@"[Browser] Removed page at section %lu", (unsigned long)pageSection);
        }
    }
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) {
        [_recycledPages removeObject:[_recycledPages anyObject]];
    }

    for (NSInteger index = iFirstSection; index <= iLastSection; index++) {
        if (![self isDisplayingPageForSection:index]) {
            AFPageScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[AFPageScrollView alloc] initWithPhotoBrowser:self];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forSection:index];

            [_pagingScrollView addSubview:page];
            NSLog(@"[Browser] Added page at index %lu", (unsigned long)index);
        }
    }
}

- (BOOL)isDisplayingPageForSection:(NSInteger)section {
    for (AFPageScrollView *page in _visiblePages)
        if (page.section == section) return YES;
    return NO;
}

- (void)configurePage:(AFPageScrollView *)page forSection:(NSInteger)section {
    page.frame = [self frameForPageAtSection:section];
    page.pageDelegate = self;
    page.section = section;
    page.disableIndicator = _disableIndicator;
    
    [page setup];
}

- (AFPageScrollView *)dequeueRecycledPage {
    AFPageScrollView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

- (void)didStartViewingSectionAtIndex:(NSUInteger)index {
    
    if (![self numberOfSections]) {
        [self setControlsHidden:NO animated:YES];
        return;
    }
    
    if (!_disableIndicator) {
        _pagingIndicator.currentPage = index;
    }
    
    if (index != _previousSectionIndex) {
        if ([_delegate respondsToSelector:@selector(photoBrowser:didDisplaySectionAtIndex:)]) {
            [_delegate photoBrowser:self didDisplaySectionAtIndex:index];
        }
        _previousSectionIndex = index;
    }
    
    
    [self updateNavigation];
    
}
    
    
#pragma mark - Data

- (void)reloadData {
    _sectionCount = NSNotFound;
    
    NSInteger numberOfSections = [self numberOfSections];
    
    [_photos removeAllObjects];
    [_thumbPhotos removeAllObjects];
    
    for (int section = 0; section < numberOfSections; section++) {
        
        NSInteger numberOfPhotos = [self numberOfPhotosInSection:section];
        
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:numberOfPhotos];
        NSMutableArray *thumbPhotos = [NSMutableArray arrayWithCapacity:numberOfPhotos];
        
        for (int index = 0; index < numberOfPhotos; index++) {
            [photos addObject:[NSNull null]];
            [thumbPhotos addObject:[NSNull null]];
        }
        
        [_photos addObject:photos];
        [_thumbPhotos addObject:thumbPhotos];
    }
    
    // Update current page index
    if (numberOfSections > 0) {
        _currentSectionIndex = MAX(0, MIN(_currentSectionIndex, numberOfSections - 1));
    } else {
        _currentSectionIndex = 0;
    }
    
    if ([self isViewLoaded]) {
        while (_pagingScrollView.subviews.count) {
            [_pagingScrollView.subviews.lastObject removeFromSuperview];
        }
        [self performLayout];
        [self.view setNeedsLayout];
    }
    
}

- (NSInteger)numberOfSections {
    if (_sectionCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfSectionsInPhotoBrowser:)]) {
            _sectionCount = [_delegate numberOfSectionsInPhotoBrowser:self];
        } else if (_fixedPhotosArray) {
            _sectionCount = _fixedPhotosArray.count;
        }
    }
    if (_sectionCount == NSNotFound) _sectionCount = 0;
    return _sectionCount;
}

- (NSInteger)numberOfPhotosInSection:(NSInteger)section {
    NSInteger _photoCount = 0;
    NSInteger sectionCount = [self numberOfSections];
    if (sectionCount == 0) {
        section = 0;
    } else {
        if (section > sectionCount) section = sectionCount - 1;
    }
    
    if ([_delegate respondsToSelector:@selector(photoBrowser:numberOfPagesInSection:)]) {
        _photoCount = [_delegate photoBrowser:self numberOfPagesInSection:section];
    } else if (_fixedPhotosArray && section < _fixedPhotosArray.count) {
        id photosArray = [_fixedPhotosArray objectAtIndex:section];
        if ([photosArray isKindOfClass:[NSArray class]]) _photoCount = [photosArray count];
    }
    
    return _photoCount;
}

- (id<AFPhoto>)photoAtIndex:(NSUInteger)index inSection:(NSInteger)section {
    id <AFPhoto> photo = nil;
    
    
    
    
    return photo;
}

- (id<AFPhoto>)thumbPhotoAtIndex:(NSUInteger)index inSection:(NSInteger)section {
    id <AFPhoto> photo = nil;
    
    
    
    
    return photo;
}

#pragma mark - Page ScrollView Delegate

- (NSUInteger)numberOfPhotosInPageScrollView:(AFPageScrollView *)scrollView {
    NSLog(@"☞ %zd", scrollView.section);
    return [self numberOfPhotosInSection:scrollView.section];
}

- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView photoAtIndex:(NSInteger)index {
    return [self photoAtIndex:index inSection:scrollView.section];
}

- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView thumbPhotoAtIndex:(NSInteger)index {
    return [self thumbPhotoAtIndex:index inSection:scrollView.section];
}

- (NSString *)scrollView:(AFPageScrollView *)scrollView titleForPhotoAtIndex:(NSInteger)index {
    return nil;
}

- (void)scrollView:(AFPageScrollView *)scrollView didDisplayPhotoAtIndex:(NSInteger)index {
    
}

#pragma mark - Frame Calculations

- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfSections], bounds.size.height);
}

- (CGPoint)centerForPagingIndicator {
    CGFloat offset = 22;
    
    CGRect bounds = _pagingScrollView.bounds;
    CGFloat centerY;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 11000
    centerY = bounds.size.height - [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom - offset;
#else
    centerY = bounds.size.height - offset;
#endif
    
    return CGPointMake(_pagingScrollView.center.x, centerY);
}

- (CGPoint)contentOffsetForPageAtSection:(NSInteger)section {
    CGFloat sectionWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = sectionWidth * section;
    return CGPointMake(newOffset, 0);
}

- (CGRect)frameForPageAtSection:(NSInteger)section {
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * section);
    return pageFrame;
}

#pragma mark - UIScrollView Delegata

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // [self setControlsHidden:YES animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_viewIsActive || _performingLayout || _rotating) return;
    
    // Tile pages
    [self tilePages];
    
    // Calculate current page
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [self numberOfSections] - 1) index = [self numberOfSections] - 1;
    NSUInteger previousCurrentSection = _currentSectionIndex;
    _currentSectionIndex = index;
    if (_currentSectionIndex != previousCurrentSection) {
        [self didStartViewingSectionAtIndex:index];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateNavigation];
}

#pragma mark - Navigation

- (void)updateNavigation {
    
    if ([_delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:inSection:)]) {
        self.title = [_delegate photoBrowser:self titleForPhotoAtIndex:_currentPhotoIndex inSection:_currentSectionIndex];
    } else {
        self.title = [NSString stringWithFormat:@"section:%lu, index:%lu", _currentSectionIndex, _currentPhotoIndex];
    }
    
    
}

- (void)jumpToPageAtIndex:(NSInteger)index inSection:(NSInteger)section animated:(BOOL)animated {
    
    if (section >= [self numberOfSections] || index >= [self numberOfPhotosInSection:section]) return;
    
    _pagingIndicator.currentPage = section;
    
    CGRect pageFrame = _pagingScrollView.frame;
    [_pagingScrollView setContentOffset:CGPointMake(pageFrame.origin.x, 0) animated:animated];
    
    [self updateNavigation];
    
    [self hideControlsAfterDelay];
}



#pragma mark - Control Hiding / Showing

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated {
    
    if (![self numberOfSections] || _alwaysShowControls) {
        hidden = NO;
    }
    
    [self cancelControlHiding];
    
    if (hidden && !_displayNavigationBar) {
        return;
    }
    
    CGFloat animationDuration = (animated ? 0.35 : 0);
    
    if (!_isVCBasedStatusBarAppearance) {
        _statusBarShouldBeHidden = hidden;
        [UIView animateWithDuration:animationDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGFloat alpha = hidden ? 0 : 1;
        [self.navigationController.navigationBar setAlpha:alpha];
    }];
    
    
}

- (void)cancelControlHiding {
    if (_controlVisibilityTimer) {
        [_controlVisibilityTimer invalidate];
        _controlVisibilityTimer = nil;
    }
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
    _controlVisibilityTimer = [NSTimer timerWithTimeInterval:self.delayToHideElements target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
}

- (void)hideControls { [self setControlsHidden:YES animated:YES]; }
- (void)showControls { [self setControlsHidden:NO animated:YES]; }

#pragma mark - Properties

- (void)setCurrentPhotoIndex:(NSInteger)index inSection:(NSInteger)section {
    
    NSInteger sectionCount = [self numberOfSections];
    if (sectionCount == 0) {
        section = 0;
    } else {
        if (section > sectionCount) section = sectionCount - 1;
    }
    _currentSectionIndex = section;
    
    NSInteger photoCountInCurrentSection = [self numberOfPhotosInSection:section];
    if (photoCountInCurrentSection == 0) {
        _currentPhotoIndex = 0;
    } else {
        if (index > photoCountInCurrentSection) index = photoCountInCurrentSection - 1;
    }
    _currentPhotoIndex = photoCountInCurrentSection;
    
    if ([self isViewLoaded]) {
        [self jumpToPageAtIndex:_currentPhotoIndex inSection:_currentSectionIndex animated:NO];
        if (!_viewIsActive) {
            [self tilePages]; // Force tiling if view is not visible
        }
    }
}


@end

































