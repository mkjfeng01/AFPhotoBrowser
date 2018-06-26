#import <UIKit/UIKit.h>
#import "AFPageScrollView.h"

@protocol AFPhotoBrowserDelegate;

@interface AFPhotoBrowser : UIViewController <UIScrollViewDelegate, AFPageScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<AFPhotoBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayNavigationBar;
@property (nonatomic) BOOL disableIndicator; // Determine if show pageControl, default is `NO`
@property (nonatomic) BOOL alwaysShowControls;
@property (nonatomic, assign) NSUInteger delayToHideElements;

// Initial
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id<AFPhotoBrowserDelegate>)delegate;

- (void)reloadData;
- (void)setCurrentPhotoIndex:(NSUInteger)index inSection:(NSUInteger)section;

@end

@protocol AFPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfSectionsInPhotoBrowser:(AFPhotoBrowser *)photoBrowser;
- (NSUInteger)photoBrowser:(AFPhotoBrowser *)photoBrowser numberOfPagesInSection:(NSUInteger)section;
- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

@optional

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (NSString *)photoBrowser:(AFPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser didDisplaySectionAtIndex:(NSUInteger)index;

@end
