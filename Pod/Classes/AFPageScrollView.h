#import <UIKit/UIKit.h>
#import "AFPhoto.h"
#import "AFZoomingScrollView.h"

@class AFPhotoBrowser;

@protocol AFPageScrollViewDelegate;

// 
// https://stackoverflow.com/questions/15437515/uiscrollview-inside-uiscrollview
//
@interface AFPageScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet id<AFPageScrollViewDelegate> delegate;
@property (nonatomic, weak) AFPhotoBrowser *photoBrowser;
@property (nonatomic) BOOL disableIndicator;
@property (nonatomic) BOOL zoomPhotosToFill;
@property () NSUInteger section;

- (id)initWithDelegate:(id<AFPageScrollViewDelegate>)delegate;
- (id)initWithPhotos:(NSArray *)photos;
- (id)initWithPhotoBrowser:(AFPhotoBrowser *)photoBrowser;

- (void)reloadData;

- (void)setup;
- (void)prepareForReuse;

@end

@protocol AFPageScrollViewDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPageScrollView:(AFPageScrollView *)scrollView;
- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView photoAtIndex:(NSUInteger)index;

@optional

- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView thumbPhotoAtIndex:(NSUInteger)index;
- (NSString *)scrollView:(AFPageScrollView *)scrollView titleForPhotoAtIndex:(NSUInteger)index;
- (void)scrollView:(AFPageScrollView *)scrollView didDisplayPhotoAtIndex:(NSUInteger)index;

@end
