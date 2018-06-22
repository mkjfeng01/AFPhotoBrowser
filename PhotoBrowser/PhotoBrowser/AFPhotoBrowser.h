#import <UIKit/UIKit.h>

@protocol AFPhotoBrowserDelegate;

@interface AFPhotoBrowser : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet id<AFPhotoBrowserDelegate> delegate;

@property (nonatomic, assign) BOOL displayNavigationBar;
@property (nonatomic, assign) BOOL displayStatusBar;


// Initial
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id<AFPhotoBrowserDelegate>)delegate;


@end


@protocol AFPhotoBrowserDelegate <NSObject>

@end

