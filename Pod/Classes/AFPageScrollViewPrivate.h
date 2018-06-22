#import "AFPageScrollView.h"

@interface AFPageScrollView () {
    
    // Data
    
    NSUInteger _photoCount;
    NSMutableArray *_photos;
    NSMutableArray *_thumbPhotos;
    NSArray *_fixedPhotosArray; // Provided via init
    
    
    // View
    UIScrollView *_pagingScrollView;
    UIPageControl *_pagingIndicator;
    
    
    
    BOOL _disableIndicator;
    
    
}

@end
