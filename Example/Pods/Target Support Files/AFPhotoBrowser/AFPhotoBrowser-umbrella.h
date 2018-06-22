#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AFPageScrollView.h"
#import "AFPageScrollViewPrivate.h"
#import "AFPhoto.h"
#import "AFPhotoBrowser.h"
#import "AFPhotoBrowserPrivate.h"
#import "AFPhotoProtocol.h"

FOUNDATION_EXPORT double AFPhotoBrowserVersionNumber;
FOUNDATION_EXPORT const unsigned char AFPhotoBrowserVersionString[];

