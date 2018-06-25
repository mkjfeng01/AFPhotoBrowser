#import "ViewController.h"
#import "AFPhotoBrowser.h"
/*
 [
 	{
 		id: 124,
 		items: [
 			{id: "626", label: "label1", images: ["uri0", "uri1", "url2"] },
 			{id: "626", label: "label2", images: ["uri1", "url2"] }
 		]
 	},
 	{
 		id: 124,
 		items: [
 			{id: "626", label: "label1", images: ["uri0", "uri1", "url2"] },
 			{id: "626", label: "label2", images: ["uri3", "url4"] },
 			{id: "626", label: "label3", images: ["uri5", "url6"] }
 		]
 	}
 ]
 */

@interface ViewController () <AFPhotoBrowserDelegate>

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationItem.title = @"";
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AFPhotoBrowser *browser = [[AFPhotoBrowser alloc] initWithDelegate:self];

        [self.navigationController pushViewController:browser animated:YES];
		// [self presentViewController:browser animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - AFPhotoBrowserDelegate

- (id<AFPhoto>)photoBrowser:(AFPhotoBrowser *)photoBrowser photoAtIndex:(NSInteger)index inSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInPhotoBrowser:(AFPhotoBrowser *)photoBrowser {
    return 5;
}

- (NSInteger)photoBrowser:(AFPhotoBrowser *)photoBrowser numberOfPagesInSection:(NSInteger)section {
    if (section == 0) return 10;
    if (section == 1) return 2;
    if (section == 2) return 3;
    if (section == 3) return 4;
    return 5;
}

@end
