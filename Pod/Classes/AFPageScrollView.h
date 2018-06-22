#import <UIKit/UIKit.h>
#import "AFPhoto.h"

@class AFPhotoBrowser;

@protocol AFPageScrollViewDelegate;

@interface AFPageScrollView : UIView <UIScrollViewDelegate>


@property (nonatomic, weak) IBOutlet id<AFPageScrollViewDelegate> pageDelegate;



@property (nonatomic, weak) AFPhotoBrowser *photoBrowser;


- (id)initWithDelegate:(id<AFPageScrollViewDelegate>)delegate;
- (id)initWithPhotos:(NSArray *)photos;
- (id)initWithPhotoBrowser:(AFPhotoBrowser *)photoBrowser;



@end


@protocol AFPageScrollViewDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPageScrollView:(AFPageScrollView *)scrollView;
- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView photoAtIndex:(NSInteger)index;

@optional

- (id <AFPhoto>)scrollView:(AFPageScrollView *)scrollView thumbPhotoAtIndex:(NSInteger)index;
- (NSString *)scrollView:(AFPageScrollView *)scrollView titleForPhotoAtIndex:(NSInteger)index;
- (void)scrollView:(AFPageScrollView *)scrollView didDisplayPhotoAtIndex:(NSInteger)index;

@end
