#import "RCTPhotoBrowserManager.h"

@implementation RCTPhotoBrowserManager

// Amost the most important properties

RCT_CUSTOM_VIEW_PROPERTY(photos, NSMutableArray, RCTPhotoBrowser) {
    [view setPhotos:json];
}
RCT_CUSTOM_VIEW_PROPERTY(thumbs, NSMutableArray, RCTPhotoBrowser) {
    [view setThumbs:json];
}

// Init Properties
RCT_EXPORT_VIEW_PROPERTY(zoomPhotosToFill, BOOL)
RCT_EXPORT_VIEW_PROPERTY(displayNavigationBar, BOOL)
RCT_EXPORT_VIEW_PROPERTY(disableIndicator, BOOL)
RCT_EXPORT_VIEW_PROPERTY(alwaysShowControls, BOOL)
RCT_EXPORT_VIEW_PROPERTY(currentPosition, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(delayToHideElements, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(animationType, NSString)
RCT_EXPORT_VIEW_PROPERTY(presentationStyle, UIModalPresentationStyle)

// Handler Event
RCT_EXPORT_VIEW_PROPERTY(onShow, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDidChangePosition, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onDidSingleTapAtPosition, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onDidDoubleTapAtPosition, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(identifier, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(supportedOrientations, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onOrientationChange, RCTDirectEventBlock)

RCT_EXPORT_MODULE();

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (UIView *)view {
  RCTPhotoBrowser *view = [[RCTPhotoBrowser alloc] initWithBridge:self.bridge];
  view.delegate = self;
  return view;
}

#pragma mark -
#pragma mark - RCTPhotoBrowserInteractor

- (void)presentPhotoBrowser:(RCTPhotoBrowser *)photoBrowser withViewController:(UIViewController *)viewController animated:(BOOL)animated {
  	dispatch_block_t completionBlock = ^{
    	if (photoBrowser.onShow) photoBrowser.onShow(nil);
  	};
  	if (_presentationBlock) {
    	_presentationBlock([photoBrowser reactViewController], viewController, animated, completionBlock);
  	} else {
      	UIViewController *reactViewController = [photoBrowser reactViewController];
      	[reactViewController presentViewController:viewController animated:animated completion:completionBlock];
  	}
}

- (void)dismissPhotoBrowser:(RCTPhotoBrowser *)photoBrowser withViewController:(UIViewController *)viewController animated:(BOOL)animated {
  dispatch_block_t completionBlock = ^{
    if (photoBrowser.identifier) {
//      [[self.bridge moduleForClass:NSClassFromString(@"RCTModalManager")] modalDismissed:photoBrowser.identifier];
    }
  };
  if (_dismissalBlock) {
    _dismissalBlock([photoBrowser reactViewController], viewController, animated, completionBlock);
  } else {
    [viewController dismissViewControllerAnimated:animated completion:completionBlock];
  }
}

@end
