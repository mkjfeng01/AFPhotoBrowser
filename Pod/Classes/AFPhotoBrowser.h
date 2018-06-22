#import <UIKit/UIKit.h>
#import "AFPhoto.h"
#import "AFPageScrollView.h"

@protocol AFPhotoBrowserDelegate;

@interface AFPhotoBrowser : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<AFPhotoBrowserDelegate> delegate;

@property (nonatomic, assign) BOOL displayNavigationBar;
@property (nonatomic, assign) BOOL disableIndicator; // Determine if show pageControl, default is `NO`
@property (nonatomic, assign) BOOL alwaysShowControls;
@property (nonatomic, assign) NSUInteger delayToHideElements;


// Initial
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id<AFPhotoBrowserDelegate>)delegate;



- (void)setCurrentPhotoIndex:(NSInteger)index inSection:(NSInteger)section;


@end




@protocol AFPhotoBrowserDelegate <NSObject>

- (NSInteger)numberOfSectionsInPhotoBrowser:(AFPhotoBrowser *)photoBrowser;
- (NSInteger)photoBrowser:(AFPhotoBrowser *)photoBrowser numberOfPagesInSection:(NSInteger)section;
- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser photoAtIndex:(NSInteger)index inSection:(NSInteger)section;


@optional

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSInteger)index inSection:(NSInteger)section;
- (NSString *)photoBrowser:(AFPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index inSection:(NSInteger)section;

@end

