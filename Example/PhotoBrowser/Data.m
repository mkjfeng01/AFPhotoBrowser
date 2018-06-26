#import "Data.h"

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
        _items = [[Product alloc] initWithDictionary:json[@"items"]];
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

@end
