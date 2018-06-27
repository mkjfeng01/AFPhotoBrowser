#if __has_include(<AFPhotoBrowser/AFPhotoBrowser.h>)
#import <AFPhotoBrowser/AFPhotoBrowser.h>
#else
#import "AFPhotoBrowser.h"
#endif
#if __has_include(<React/RCTView.h>)
	#import <React/RCTView.h>
	#import <React/RCTInvalidating.h>
#else
	#import "RCTView.h"
	#import "RCTInvalidating.h"
#endif

@class RCTBridge;
@class AFPhotoBrowser;

@protocol RCTPhotoBrowserInteractor;

@interface RCTPhotoBrowser : UIView <RCTInvalidating, AFPhotoBrowserDelegate>

// Parent Control
@property (nonatomic, copy) NSString *animationType;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

// Flag
@property (nonatomic, copy) NSNumber *identifier;

// Data Source
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

// Photo Browser Initial Properties
@property (nonatomic, assign) BOOL zoomPhotosToFill;
@property (nonatomic, assign) BOOL displayNavigationBar;
@property (nonatomic, assign) BOOL disableIndicator;
@property (nonatomic, assign) BOOL alwaysShowControls;
@property (nonatomic, assign) NSDictionary *currentPosition;
@property (nonatomic, assign) NSUInteger delayToHideElements;

// Handler 
@property (nonatomic, copy) RCTDirectEventBlock onShow;
@property (nonatomic, copy) RCTBubblingEventBlock onDidChangePosition;
@property (nonatomic, copy) RCTBubblingEventBlock onDidSingleTapAtPosition;
@property (nonatomic, copy) RCTBubblingEventBlock onDidDoubleTapAtPosition;

@property (nonatomic, weak) id<RCTPhotoBrowserInteractor> delegate;

// Device
@property (nonatomic, copy) NSArray<NSString *> *supportedOrientations;
@property (nonatomic, copy) RCTDirectEventBlock onOrientationChange;

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;

@end

@protocol RCTPhotoBrowserInteractor <NSObject>

- (void)presentPhotoBrowser:(RCTPhotoBrowser *)photoBrowser
         withViewController:(UIViewController *)viewController
                   animated:(BOOL)animated;
- (void)dismissPhotoBrowser:(RCTPhotoBrowser *)photoBrowser
         withViewController:(UIViewController *)viewController
                   animated:(BOOL)animated;

@end