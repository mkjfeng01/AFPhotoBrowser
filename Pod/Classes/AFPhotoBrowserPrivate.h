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
    
    
    // Index
    NSInteger _sectionCount;
    NSInteger _currentSectionIndex;
    NSInteger _currentPhotoIndex;
    
    // Navigation & controls
    NSTimer *_controlVisibilityTimer;
    
    
    
    BOOL _isVCBasedStatusBarAppearance;
    BOOL _statusBarShouldBeHidden;
    BOOL _performingLayout;
    BOOL _rotating;
    BOOL _viewIsActive; // active as in it's in the view heirarchy
    
    
    
}

@end


