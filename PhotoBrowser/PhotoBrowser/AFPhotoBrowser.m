#import "AFPhotoBrowser.h"
#import "AFPhotoBrowserPrivate.h"
#import "AFPagingTableCell.h"

static NSString * const AFPagingCellIdentifierFactory(NSIndexPath *indexPath) {
    NSString *model = @"MW_PHOTO_CELL_IDENTIFIER_%zd";
    if (indexPath != nil) {
        return [NSString stringWithFormat:model, indexPath.row];
    }
    return [NSString stringWithFormat:model, NSIntegerMax];
}

@interface AFPhotoBrowser ()

@end

@implementation AFPhotoBrowser

#pragma mark - Initial

- (id)initWithPhotos:(NSArray *)photosArray {
    if (self == [super init]) {
        _photosArray = photosArray;
    }
    return self;
}

- (id)initWithDelegate:(id<AFPhotoBrowserDelegate>)delegate {
    if (self == [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]) {
        [self initialProperties];
    }
    return self;
}

- (instancetype)init {
    if (self == [super init]) {
        [self initialProperties];
    }
    return self;
}

- (void)initialProperties {
    
    
    _displayNavigationBar = NO;
    _displayStatusBar = NO;
    
}

#pragma mark - Life

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (self.navigationController) {
//        [self.navigationController setNavigationBarHidden:!_displayNavigationBar animated:NO];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    CGRect pagingTableViewFrame = [self frameForPagingTableView];
    _pagingTableView = [[UITableView alloc] initWithFrame:pagingTableViewFrame style:UITableViewStylePlain];
    _pagingTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
    _pagingTableView.estimatedRowHeight = CGRectGetHeight(pagingTableViewFrame);
    _pagingTableView.dataSource = self;
    _pagingTableView.delegate = self;
    _pagingTableView.pagingEnabled = YES;
    _pagingTableView.sectionHeaderHeight = 0;
    _pagingTableView.sectionFooterHeight = 0;
    _pagingTableView.tableHeaderView = [UIView new];
    _pagingTableView.tableFooterView = [UIView new];
    _pagingTableView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_pagingTableView];
}


#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return _displayStatusBar;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {

    }];
}

#pragma mark - Frame

- (CGRect)frameForPagingTableView {
    CGSize browserSize = self.view.bounds.size;
    
    CGFloat xOrigin = (browserSize.width - browserSize.height) / 2.0;
    CGFloat yOrigin = (browserSize.height - browserSize.width) / 2.0;
    
    CGRect pagingTableViewFrame = CGRectMake(xOrigin, yOrigin, browserSize.height, browserSize.width);
    
    return pagingTableViewFrame;
}

- (CGRect)frameForPagingTableViewCell:(UITableViewCell *)cell {
    CGSize cellSize = cell.bounds.size;
    
    CGFloat xOrigin = (cellSize.width - cellSize.height) / 2.0;
    CGFloat yOrigin = (cellSize.height - cellSize.width) / 2.0;
    
    CGRect pagingTableViewCellFrame = CGRectMake(xOrigin, yOrigin, cellSize.height, cellSize.width);

    return pagingTableViewCellFrame;
}

#pragma mark - UITableView DataSource & Delegata

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AFPagingCellIdentifierFactory(indexPath)];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableviewCell"];
    }
    
    if (CGAffineTransformEqualToTransform(cell.contentView.transform, CGAffineTransformIdentity)) {
        CGRect pagingTableViewFrame = [self frameForPagingTableViewCell:cell];
        cell.contentView.frame = pagingTableViewFrame;
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    }
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor purpleColor];
    }
    
    NSLog(@"%.2f %.2f", cell.contentView.frame.size.width, cell.contentView.frame.size.height);
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect pagingTableViewFrame = [self frameForPagingTableView];
    
    return CGRectGetHeight(pagingTableViewFrame);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}



@end

































