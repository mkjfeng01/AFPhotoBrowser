#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "AFPhotoProtocol.h"

@interface AFPhoto : NSObject <AFPhoto>

@property (nonatomic) BOOL emptyImage;

+ (AFPhoto *)photoWithImage:(UIImage *)image;
+ (AFPhoto *)photoWithURL:(NSURL *)url;
+ (AFPhoto *)photoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;

- (id)init;
- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;
- (id)initWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize;

@end
