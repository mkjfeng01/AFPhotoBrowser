#import "RCTPhotoBrowser.h"
#if __has_include(<React/RCTUtils.h>)
#import <React/RCTUtils.h>
#import <React/RCTBridge.h>
#import <React/UIView+React.h>
#else
#import "RCTUtils.h"
#import "RCTBridge.h"
#import "UIView+React.h"
#endif
#import "AFPhotoBrowser+RCT.h"
#import "PhotoTransfer.h"

@implementation RCTPhotoBrowser {
  __weak RCTBridge *_bridge;
  BOOL _isPresented;
  AFPhotoBrowser *_photoBrowser;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:coder)

- (instancetype)initWithBridge:(RCTBridge *)bridge {
  	if (self == [super initWithFrame:CGRectZero]) {
    	_bridge = bridge;
    	_photoBrowser = [[AFPhotoBrowser alloc] initWithDelegate:self];
        
    	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:_photoBrowser];
    	nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
      
    	UIView *containerView = [UIView new];
    	containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    	nc.view = containerView;
    	_isPresented = NO;
    	_photos = [[NSMutableArray alloc] init];
    	_thumbs = [[NSMutableArray alloc] init];
  	}
  	return self;
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index {
    [super insertSubview:view atIndex:index];
}

- (void)removeReactSubview:(UIView *)subview {
  	[super removeReactSubview:subview];
}

- (void)didMoveToSuperview {
  	[super didMoveToSuperview];
  	if (_isPresented && !self.superview) {
    	[self dismissModalViewController];
  	}
}

- (void)didMoveToWindow {
  [super didMoveToWindow];
  
  if (!self.userInteractionEnabled && ![self.superview.reactSubviews containsObject:self]) {
    return;
  }
  
  if (!_isPresented && self.window) {
    RCTAssert(self.reactViewController, @"Can't present modal view controller without a presenting view controller");
    
#if !TARGET_OS_TV
    // _photoBrowser.supportedInterfaceOrientations = [self supportedOrientationsMask];
#endif
    if ([self.animationType isEqualToString:@"fade"]) {
      _photoBrowser.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    } else if ([self.animationType isEqualToString:@"slide"]) {
      _photoBrowser.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    if (self.presentationStyle != UIModalPresentationNone) {
      _photoBrowser.modalPresentationStyle = self.presentationStyle;
    }
    [_delegate presentPhotoBrowser:self withViewController:_photoBrowser animated:[self hasAnimationType]];
    _isPresented = YES;
  }
}

- (void)dismissModalViewController {
  	if (_isPresented) {
    	[_delegate dismissPhotoBrowser:self withViewController:_photoBrowser animated:[self hasAnimationType]];
    	_isPresented = NO;
  	}
}
     
- (BOOL)hasAnimationType {
	return ![self.animationType isEqualToString:@"none"];
}

#if !TARGET_OS_TV
- (UIInterfaceOrientationMask)supportedOrientationsMask {
  if (_supportedOrientations.count == 0) {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      return UIInterfaceOrientationMaskAll;
    } else {
      return UIInterfaceOrientationMaskPortrait;
    }
  }
  
  UIInterfaceOrientationMask supportedOrientations = 0;
  for (NSString *orientation in _supportedOrientations) {
    if ([orientation isEqualToString:@"portrait"]) {
      supportedOrientations |= UIInterfaceOrientationMaskPortrait;
    } else if ([orientation isEqualToString:@"portrait-upside-down"]) {
      supportedOrientations |= UIInterfaceOrientationMaskPortraitUpsideDown;
    } else if ([orientation isEqualToString:@"landscape"]) {
      supportedOrientations |= UIInterfaceOrientationMaskLandscape;
    } else if ([orientation isEqualToString:@"landscape-left"]) {
      supportedOrientations |= UIInterfaceOrientationMaskLandscapeLeft;
    } else if ([orientation isEqualToString:@"landscape-right"]) {
      supportedOrientations |= UIInterfaceOrientationMaskLandscapeRight;
    }
  }
  return supportedOrientations;
}
#endif

#pragma mark -
#pragma mark - Setter, Getter

- (void)setPhotos:(NSMutableArray *)photos {
    NSAssert([photos count], @"Browser photos maybe nil, initial with at least one image.");
    
    if ([_photos count]) { [_photos removeAllObjects]; }
    
//    NSMutableArray *datas = [NSMutableArray arrayWithArray:[PhotoTransfer convertOriginJsonToPhotos:photos]];
//
//    _photos = datas;
    
    for (NSArray *arr in photos) {
        NSMutableArray * insertion = [NSMutableArray arrayWithCapacity:arr.count];
        for (id photo in arr) {
            if ([photo hasPrefix:@"http"] || [photo hasPrefix:@"https"]) {
                [insertion addObject:[AFPhoto photoWithURL:[NSURL URLWithString:photo]]];
            } else {
                [insertion addObject:[AFPhoto photoWithImage:[UIImage imageNamed:photo]]];
            }
        }
        [_photos addObject:insertion];
    }
}

- (void)setThumbs:(NSMutableArray *)thumbs {
    NSAssert([thumbs count], @"Browser thumbs maybe nil, initial with at least one image.");
    
    if ([_thumbs count]) { [_thumbs removeAllObjects]; }
    
    for (NSArray *arr in thumbs) {
        NSMutableArray * insertion = [NSMutableArray arrayWithCapacity:arr.count];
        for (id photo in arr) {
            if ([photo hasPrefix:@"http"] || [photo hasPrefix:@"https"]) {
                [insertion addObject:[AFPhoto photoWithURL:[NSURL URLWithString:photo]]];
            } else {
                [insertion addObject:[AFPhoto photoWithImage:[UIImage imageNamed:photo]]];
            }
        }
        [_thumbs addObject:insertion];
    }
}

- (void)setCurrentPosition:(NSDictionary *)json {
    _currentPosition = json;
    
    if (_photoBrowser) {
        NSUInteger section = [json[@"section"] unsignedIntegerValue];
        NSUInteger index = [json[@"index"] unsignedIntegerValue];
        [_photoBrowser setCurrentPhotoIndex:index section:section];
    }
}

#pragma mark -
#pragma mark - RCTInvalidating

- (void)invalidate {
  	dispatch_async(dispatch_get_main_queue(), ^{
    	[self dismissModalViewController];
  	});
}

#pragma mark -
#pragma mark - AFPhotoBrowserDelegate

- (NSUInteger)numberOfSectionsInPhotoBrowser:(AFPhotoBrowser *)photoBrowser {
    if ([_photos count]) return [_photos count];
    return 0;
}

- (NSUInteger)photoBrowser:(AFPhotoBrowser *)photoBrowser numberOfPagesInSection:(NSUInteger)section {
    if (section < [_photos count]) {
        NSMutableArray *arr = [_photos objectAtIndex:section];
        if ([arr count]) return [arr count];
        return 0;
    }
    return 0;
}

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    if ([_photos count] && [[_photos objectAtIndex:section] count])
    	return [_photos[section] objectAtIndex:index];
    return nil;
}

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    if ([_thumbs count] && [[_thumbs objectAtIndex:section] count])
    	return [_thumbs[section] objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSLog(@"Did start viewing photo at index %lu %lu", (unsigned long)section, (unsigned long)index);
    
    NSDictionary *body = @{
                           @"section" : @(section),
                           @"index" : @(index)
                           };
    !self.onDidChangePosition ?: self.onDidChangePosition(body);
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser singleTapAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSDictionary *body = @{
                           @"section" : @(section),
                           @"index" : @(index),
                           @"image" : @""
                           };
    !self.onDidSingleTapAtPosition ?: self.onDidSingleTapAtPosition(body);
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser doubleTapAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSDictionary *body = @{
                           @"section" : @(section),
                           @"index" : @(index),
                           @"image" : @""
                           };
    !self.onDidDoubleTapAtPosition ?: self.onDidDoubleTapAtPosition(body);
}

@end
