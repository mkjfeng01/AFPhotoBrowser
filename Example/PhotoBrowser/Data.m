#import "Data.h"
#import <AFPhotoBrowser/AFPhotoBrowser.h>

@interface Product : NSObject

@property (copy) NSString *ID;
@property (copy) NSString *label;
@property () NSArray *images;

@end

@implementation Product

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self == [super init]) {
        _ID = json[@"id"];
        _label = json[@"label"];
        _images = json[@"images"];
    }
    return self;
}

@end

NSString * url0 = @"https://www.hd-wallpapersdownload.com/script/bulk-upload/lion-big-wallpapers.jpg";
NSString * url1 = @"https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg/1200px-Clock_Tower_-_Palace_of_Westminster%2C_London_-_May_2007.jpg";
NSString * url2 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191365120&di=b9ac64e0454c76ba6023a9d4ed8cc714&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F72f082025aafa40f452e2346a064034f79f01944.jpg";
NSString * url3 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191361964&di=0d04c4951ee10e76a0fc4a314f2fa440&imgtype=0&src=http%3A%2F%2Fd.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2Fdbb44aed2e738bd498355caaaa8b87d6277ff911.jpg";
NSString * url4 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191358041&di=d022c835401518b9128037180ce2b6f8&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F0ff41bd5ad6eddc4a587596032dbb6fd536633cd.jpg";
NSString * url5 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528191356647&di=33cfc30ae69d807390f99e8002d17c61&imgtype=0&src=http%3A%2F%2Fg.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F50da81cb39dbb6fda4dc0abd0224ab18962b37a2.jpg";


@interface Items : NSObject

@property (copy) NSString *ID;
@property () NSArray<Product *> *items;

@end

@implementation Items

- (instancetype)initWithDictionary:(NSDictionary *)json {
    if (self == [super init]) {
        _ID = json[@"id"];
//        _items = [[Product alloc] initWithDictionary:json[@"items"]];
    }
    return self;
}

@end


@implementation Data

+ (NSArray *)datasource {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *json in Data.jsons) {
        
        
        Items * its = [[Items alloc] initWithDictionary:json];
        
        [array addObject:its];
        
    }
    
    return array.copy;
}

+ (NSArray *)jsons {
    return @[
            @{
                @"id": @"0001",
            	@"items": @[
  					@{@"id": @"0", @"label": @"label1", @"images": @[url0, url0, url0] }
                    ]
            	},
            @{
                @"id": @"0002",
                @"items": @[
                    @{@"id": @"0", @"label": @"label1", @"images": @[url0, url0, url0] },
                    @{@"id": @"1", @"label": @"label2", @"images": @[url0, url0] }
                    ]
            	},
            @{
                @"id": @"0003",
                @"items": @[
                        @{@"id": @"0", @"label": @"label1", @"images": @[url0, url0, url0] },
                        @{@"id": @"1", @"label": @"label2", @"images": @[url0, url0] },
                        @{@"id": @"2", @"label": @"label2", @"images": @[url0, url0] }
                        ]
                },
            @{
                @"id": @"0004",
                @"items": @[
                        @{@"id": @"0", @"label": @"label1", @"images": @[url0, url0, url0] },
                        @{@"id": @"1", @"label": @"label2", @"images": @[url0, url0] },
                        @{@"id": @"2", @"label": @"label3", @"images": @[url0, url0] },
                        @{@"id": @"3", @"label": @"label4", @"images": @[url0, url0] }
                        ]
                },
            @{
                @"id": @"0005",
                @"items": @[
                        @{@"id": @"0", @"label": @"label1", @"images": @[url0, url0, url0] },
                        @{@"id": @"1", @"label": @"label2", @"images": @[url0, url0] },
                        @{@"id": @"2", @"label": @"label3", @"images": @[url0, url0] },
                        @{@"id": @"3", @"label": @"label4", @"images": @[url0, url0] },
                        @{@"id": @"4", @"label": @"label5", @"images": @[url0, url0] }
                        ]
                }
            ];
}

+ (NSArray *)testData {
    return @[
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
}

@end
