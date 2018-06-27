#import "ViewController.h"
#import "AFPhotoBrowser.h"
#import "Data.h"
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

@interface ViewController () <AFPhotoBrowserDelegate> {
    NSArray *_photos;
    NSUInteger _section;
    AFPhotoBrowser *_browser;
}

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _section = 0;
    
    _photos = @[
                @[[AFPhoto photoWithURL:[NSURL URLWithString:@"https://www.hd-wallpapersdownload.com/script/bulk-upload/lion-big-wallpapers.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/1200px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191365120&di=b9ac64e0454c76ba6023a9d4ed8cc714&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f452e2346a064034f79f01944.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191361964&di=0d04c4951ee10e76a0fc4a314f2fa440&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fdbb44aed2e738bd498355caaaa8b87d6277ff911.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191358041&di=d022c835401518b9128037180ce2b6f8&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F0ff41bd5ad6eddc4a587596032dbb6fd536633cd.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191356647&di=33cfc30ae69d807390f99e8002d17c61&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F50da81cb39dbb6fda4dc0abd0224ab18962b37a2.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191354804&di=4a267e1721de7ea79377089553650525&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fe1fe9925bc315c608356877486b1cb134854776e.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191352122&di=a39de6755e10b8b8a4b0fb6d0b1266a9&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F728da9773912b31b94a822b28d18367adbb4e161.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191350389&di=56008f76669826f87450b9f2e79a83f7&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fcb8065380cd7912312b87befa6345982b3b780d5.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191348039&di=636401fab9035e719f8b7df2dee7074c&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Ffd039245d688d43f6d207e69761ed21b0ff43ba4.jpg"]]],
                @[[AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191346193&di=a80c908781213f3fe1cb83b6e56f9df4&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f6a2d3feaa764034f78f01919.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191369683&di=bb92c3c94417e273cdbd7f17183f098b&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fd043ad4bd11373f088d38304af0f4bfbfaed04b8.jpg"]]],
                @[[AFPhoto photoWithURL:[NSURL URLWithString:@"https://www.hd-wallpapersdownload.com/script/bulk-upload/lion-big-wallpapers.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191354804&di=4a267e1721de7ea79377089553650525&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fe1fe9925bc315c608356877486b1cb134854776e.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/1200px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg"]]],
                @[[AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191350389&di=56008f76669826f87450b9f2e79a83f7&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fcb8065380cd7912312b87befa6345982b3b780d5.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191346193&di=a80c908781213f3fe1cb83b6e56f9df4&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f6a2d3feaa764034f78f01919.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/1200px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191361964&di=0d04c4951ee10e76a0fc4a314f2fa440&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fdbb44aed2e738bd498355caaaa8b87d6277ff911.jpg"]]],
                @[[AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191346193&di=a80c908781213f3fe1cb83b6e56f9df4&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f6a2d3feaa764034f78f01919.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191354804&di=4a267e1721de7ea79377089553650525&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fe1fe9925bc315c608356877486b1cb134854776e.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191346193&di=a80c908781213f3fe1cb83b6e56f9df4&imgtype=0&src=http%3A%2F%2Fb.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f6a2d3feaa764034f78f01919.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191369683&di=bb92c3c94417e273cdbd7f17183f098b&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fd043ad4bd11373f088d38304af0f4bfbfaed04b8.jpg"]],
                  [AFPhoto photoWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/1200px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg"]],]
                ];
    
    self.navigationItem.title = @"";
    
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_browser = [[AFPhotoBrowser alloc] initWithDelegate:self];

        [self.navigationController pushViewController:self->_browser animated:YES];
    });
    
    [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {

        NSLog(@"....🚚................................🚚....");
        
        if (self->_section < self->_photos.count) {
            [self->_browser setCurrentPhotoIndex:1 section:self->_section++];
        } else {
            self->_section = 0;
        }
        
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
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

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser didDisplaySectionAtIndex:(NSUInteger)index {
    NSLog(@"🔴 %zd", index);
}

- (void)photoBrowser:(AFPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index section:(NSUInteger)section {
    NSLog(@"🔵 %zd %zd", section, index);
}

@end
