#import "AFPhotoBrowser.h"

@interface AFPhotoBrowser () {
    
    // Views
    
    UIScrollView *_pagingScrollView;
    UIPageControl *_pagingIndicator;
    
    // Datas
    NSArray *_fixedPhotosArray; // Provided via init
    NSMutableArray *_sections;
    NSMutableArray *_photos;
    NSMutableArray *_thumbPhotos;
    
    
    // Paging & layout
    NSMutableSet *_visiblePages, *_recycledPages;
    
    // Index
    NSUInteger _sectionCount;
    NSUInteger _currentSectionIndex;
    NSUInteger _currentPhotoIndex;
    NSUInteger _previousSectionIndex;
    
    // Navigation & controls
    NSTimer *_controlVisibilityTimer;
    
    
    
    BOOL _isVCBasedStatusBarAppearance;
    BOOL _statusBarShouldBeHidden;
    BOOL _performingLayout;
    BOOL _rotating;
    BOOL _viewIsActive; // active as in it's in the view heirarchy
    
    
    
}





@end


