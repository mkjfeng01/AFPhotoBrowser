#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDWebImageOperation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AFPhoto.h"
#import "AFPageScrollView.h"

@interface AFPhoto () {
    
    BOOL _loadingInProgress;
    id <SDWebImageOperation> _webImageOperation;
    PHImageRequestID _assetRequestID;
    PHImageRequestID _assetVideoRequestID;
    
}

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic) CGSize assetTargetSize;

- (void)imageLoadingComplete;

@end

@implementation AFPhoto

@synthesize underlyingImage = _underlyingImage; // synth property from protocol


#pragma mark - Class Methods

+ (AFPhoto *)photoWithImage:(UIImage *)image {
    return [[AFPhoto alloc] initWithImage:image];
}

+ (AFPhoto *)photoWithURL:(NSURL *)url {
    return [[AFPhoto alloc] initWithURL:url];
}

+ (AFPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize {
    return [[AFPhoto alloc] initWithAsset:asset targetSize:targetSize];
}

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        self.emptyImage = YES;
        [self setup];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        self.image = image;
        [self setup];
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        self.photoURL = url;
        [self setup];
    }
    return self;
}

- (id)initWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize {
    if ((self = [super init])) {
        self.asset = asset;
        self.assetTargetSize = targetSize;
        self.isVideo = asset.mediaType == PHAssetMediaTypeVideo;
        [self setup];
    }
    return self;
}

- (void)setup {
    _assetRequestID = PHInvalidImageRequestID;
    _assetVideoRequestID = PHInvalidImageRequestID;
}

- (void)dealloc {
    [self cancelAnyLoading];
}

#pragma mark - AFPhoto Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    if (_loadingInProgress) return;
    _loadingInProgress = YES;
    @try {
        if (self.underlyingImage) {
            [self imageLoadingComplete];
        } else {
            [self performLoadUnderlyingImageAndNotify];
        }
    }
    @catch (NSException *exception) {
        self.underlyingImage = nil;
        _loadingInProgress = NO;
        [self imageLoadingComplete];
    }
    @finally {
    }
}

// Set the underlyingImage
- (void)performLoadUnderlyingImageAndNotify {
    
    // Get underlying image
    if (_image) {
        self.underlyingImage = _image;
        [self imageLoadingComplete];
        
    } else if (_photoURL) {
        if ([[[_photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
            [self _performLoadUnderlyingImageAndNotifyWithAssetsLibraryURL: _photoURL];
        } else if ([_photoURL isFileReferenceURL]) {
            [self _performLoadUnderlyingImageAndNotifyWithLocalFileURL: _photoURL];
        } else {
            [self _performLoadUnderlyingImageAndNotifyWithWebURL: _photoURL];
        }
        
    } else if (_asset) {
        [self _performLoadUnderlyingImageAndNotifyWithAsset: _asset targetSize:_assetTargetSize];
    } else {
        [self imageLoadingComplete];
    }
}

// Load from local file
- (void)_performLoadUnderlyingImageAndNotifyWithWebURL:(NSURL *)url {
    @try {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            if (expectedSize > 0) {
                float progress = receivedSize / (float)expectedSize;
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat:progress], @"progress", self, @"photo", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:AFPHOTO_PROGRESS_NOTIFICATION object:dict];
            }
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
    
            if (error) {
                NSLog(@"SDWebImage failed to download image: %@", error);
            }
            self->_webImageOperation = nil;
            self.underlyingImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self imageLoadingComplete];
            });
            
        }];
    } @catch (NSException *e) {
        NSLog(@"Photo from web: %@", e);
        _webImageOperation = nil;
        [self imageLoadingComplete];
    }
}

// Load from local file
- (void)_performLoadUnderlyingImageAndNotifyWithLocalFileURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            @try {
                self.underlyingImage = [UIImage imageWithContentsOfFile:url.path];
                if (!self->_underlyingImage) {
                    NSLog(@"Error loading photo from path: %@", url.path);
                }
            } @finally {
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            }
        }
    });
}

// Load from asset library async
- (void)_performLoadUnderlyingImageAndNotifyWithAssetsLibraryURL:(NSURL *)url {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            @try {
                ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:url resultBlock:^(ALAsset *asset){
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    if (iref) {
                        self.underlyingImage = [UIImage imageWithCGImage:iref];
                    }
                    [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                } failureBlock:^(NSError *error) {
                    self.underlyingImage = nil;
                    NSLog(@"Photo from asset library error: %@",error);
                    [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                }];
            } @catch (NSException *e) {
                NSLog(@"Photo from asset library error: %@", e);
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            }
        }
    });
}

// Load from photos library
- (void)_performLoadUnderlyingImageAndNotifyWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize {
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = false;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithDouble: progress], @"progress",
                              self, @"photo", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:AFPHOTO_PROGRESS_NOTIFICATION object:dict];
    };
    
    _assetRequestID = [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.underlyingImage = result;
            [self imageLoadingComplete];
        });
    }];
    
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
    self.underlyingImage = nil;
}

- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    // Notify on next run loop
    [self performSelector:@selector(postCompleteNotification) withObject:nil afterDelay:0];
}

- (void)postCompleteNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:AFPHOTO_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

- (void)cancelAnyLoading {
    if (_webImageOperation != nil) {
        [_webImageOperation cancel];
        _loadingInProgress = NO;
    }
    [self cancelImageRequest];
}

- (void)cancelImageRequest {
    if (_assetRequestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_assetRequestID];
        _assetRequestID = PHInvalidImageRequestID;
    }
}

@end
