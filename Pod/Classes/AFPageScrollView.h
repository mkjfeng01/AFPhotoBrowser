#import <UIKit/UIKit.h>
#import "AFPhoto.h"
#import "AFZoomingScrollView.h"

@class AFPhotoBrowser;

@protocol AFPageScrollViewDelegate;

// 
// https://stackoverflow.com/questions/15437515/uiscrollview-inside-uiscrollview
//
@interface AFPageScrollView : UIView <UIScrollViewDelegate>


@property (nonatomic, weak) IBOutlet id<AFPageScrollViewDelegate> pageDelegate;
@property (nonatomic, weak) AFPhotoBrowser *photoBrowser;

@property (nonatomic, assign) BOOL disableIndicator;



@property () NSInteger section;
//@property (nonatomic) NSArray <AFPhoto> *photos;


- (id)initWithDelegate:(id<AFPageScrollViewDelegate>)delegate;
- (id)initWithPhotos:(NSArray *)photos;
- (id)initWithPhotoBrowser:(AFPhotoBrowser *)photoBrowser;


- (void)reloadData;

- (void)setup;
- (void)prepareForReuse;


@end


@protocol AFPageScrollViewDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPageScrollView:(AFPageScrollView *)scrollView;
- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView photoAtIndex:(NSInteger)index;

@optional

- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView thumbPhotoAtIndex:(NSInteger)index;
- (NSString *)scrollView:(AFPageScrollView *)scrollView titleForPhotoAtIndex:(NSInteger)index;
- (void)scrollView:(AFPageScrollView *)scrollView didDisplayPhotoAtIndex:(NSInteger)index;

@end
