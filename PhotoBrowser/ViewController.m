#import "ViewController.h"
#import "AFPhotoBrowser.h"
/*
 [
 	{
 		id: 124,
 		items: [
 			{ label: "label1", images: ["uri0", "uri1", "url2"] },
 			{ label: "label2", images: ["uri1", "url2"] }
 		]
 	},
 	{
 		id: 124,
 		items: [
 			{ label: "label1", images: ["uri0", "uri1", "url2"] },
 			{ label: "label2", images: ["uri3", "url4"] },
 			{ label: "label3", images: ["uri5", "url6"] }
 		]
 	}
 ]
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AFPhotoBrowser *browser = [[AFPhotoBrowser alloc] init];
        
        
        
        
        [self.navigationController pushViewController:browser animated:YES];
		// [self presentViewController:browser animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
