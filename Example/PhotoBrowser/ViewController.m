#import "ViewController.h"
#import "AFPhotoBrowser.h"
#import "Data.h"

@interface ViewController () <AFPhotoBrowserDelegate> {
    NSArray *_photos;
    NSUInteger _section;
    AFPhotoBrowser *_browser;
}

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    _section = 0;
    _photos = Data.testData;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_browser = [[AFPhotoBrowser alloc] initWithDelegate:self];
        self->_browser.displayNavigationBar = YES;
        [self->_browser setCurrentPhotoIndex:0 section:0];
//        [self.view addSubview:_browser.view];
        [self.navigationController pushViewController:self->_browser animated:YES];
    });
    
//    NSLog(@"....🚚................................🚚....");
//    if (self->_section < self->_photos.count) {
//        [self->_browser setCurrentPhotoIndex:1 section:self->_section++];
//    } else {
//        self->_section = 0;
//    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_browser startCarousel];
//    });
}

#pragma mark - AFPhotoBrowserDelegate

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    return [_photos[section] objectAtIndex:index];
}

- (NSUInteger)numberOfSectionsInPhotoBrowser:(AFPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (NSUInteger)photoBrowser:(AFPhotoBrowser *)photoBrowser numberOfPagesInSection:(NSUInteger)section {
    return [_photos[section] count];
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSLog(@"👉 %zd %zd", section, index);
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser singleTapAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSLog(@"-------> single tap");
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser doubleTapAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSLog(@"-------> double tap");
}

@end
