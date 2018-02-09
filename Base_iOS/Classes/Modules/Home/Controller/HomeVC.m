//
//  HomeVC.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2018/2/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeVC.h"

//Manager
#import "AppConfig.h"
//Macro
//Framework
//Category
//Extension
#import "MJRefresh.h"
//M
#import "BannerModel.h"
#import "NoticeModel.h"
#import "BrandModel.h"
//V
#import "TLBannerView.h"
#import "LoopScrollView.h"
#import "CategoryItem.h"
#import "HomeCollectionView.h"
//C
#import "WebVC.h"
#import "SystemNoticeVC.h"

@interface HomeVC ()<UIScrollViewDelegate>
//
@property (nonatomic, strong) HomeCollectionView *collectionView;
//品牌列表
@property (nonatomic,strong) NSMutableArray <BrandModel *>*brands;
//
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;
//系统消息
@property (nonatomic,strong) NSMutableArray <NoticeModel *>*notices;
//图片
@property (nonatomic,strong) NSMutableArray *bannerPics;

@end

@implementation HomeVC

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //系统消息
//    [self requestNoticeList];
//    //获取商品列表
//    [self requestBrandList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"首页";
    
    //添加下拉刷新
    [self addDownRefresh];
    //品牌列表
    [self initCollectionView];
}

#pragma mark - 断网操作
- (void)placeholderOperation {
    
    //系统消息
    [self requestNoticeList];
    //获取商品列表
    [self requestBrandList];
}

#pragma mark - Init
- (void)addDownRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(clickRefresh)];
    
    self.collectionView.mj_header = header;
}

- (void)initCollectionView {
    
    BaseWeakSelf;
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //
    CGFloat itemWidth = (kScreenWidth - 10)/2.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 98);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[HomeCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) collectionViewLayout:flowLayout];
    
    self.collectionView.homeBlock = ^(NSIndexPath *indexPath) {
        
        BrandModel *good = weakSelf.brands[indexPath.row];
        
//        GoodDetailVC *detailVC = [[GoodDetailVC alloc] init];
//
//        detailVC.code = good.code;
//
//        detailVC.userId = weakSelf.userId;
//
//        [weakSelf.navigationController pushViewController:detailVC animated:YES];
    };
    
    if (self.collectionView.headerView) {
        
        self.collectionView.headerView.headerBlock = ^(HomeEventsType type, NSInteger index) {
            
            [weakSelf headerViewEventsWithType:type index:index];
        };
    }
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];

}

#pragma mark - Data
- (void)requestNoticeList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"804040";
    if ([TLUser user].token) {
        
        helper.parameters[@"token"] = [TLUser user].token;
    }
    helper.parameters[@"channelType"] = @"4";
    
    helper.parameters[@"pushType"] = @"41";
    helper.parameters[@"toKind"] = @"C";    //C端
    //    1 立即发 2 定时发
    //    pageDataHelper.parameters[@"smsType"] = @"1";
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"20";
    helper.parameters[@"status"] = @"1";
    helper.parameters[@"fromSystemCode"] = [AppConfig config].systemCode;
    
    [helper modelClass:[NoticeModel class]];
    
    //消息数据
    [helper refresh:^(NSMutableArray <NoticeModel *>*objs, BOOL stillHave) {
        
        [weakSelf removePlaceholderView];
        
        weakSelf.collectionView.headerView.notices = objs;
        
    } failure:^(NSError *error) {
        
        [weakSelf addPlaceholderView];

    }];
    
}

- (void)requestBrandList {
    
    BaseWeakSelf;
    //location： 0 普通列表 1 推荐列表
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"808021";
    
    //    helper.parameters[@"statusList"] = @[@"3"];
    
    //    helper.parameters[@"statusList"] = @[@"4", @"5", @"6"];
    
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    helper.parameters[@"orderColumn"] = @"update_datetime";
    helper.parameters[@"orderDir"] = @"desc";
    
    [helper modelClass:[BrandModel class]];
    
    //店铺数据
    [helper refresh:^(NSMutableArray <BrandModel *>*objs, BOOL stillHave) {
        
        weakSelf.brands = objs;
        
        weakSelf.collectionView.brands = objs;
        
        [weakSelf.collectionView reloadData];
        
        //加载headerView
//        weakSelf.collectionView.headerView.headerBlock = ^(HomePageType type) {
//
//            [weakSelf headerViewEventsWithType:type];
//        };
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

#pragma mark - HeaderEvents
- (void)headerViewEventsWithType:(HomeEventsType)type index:(NSInteger)index {
    
    switch (type) {
        case HomeEventsTypeBanner:
        {
            if (!(self.bannerRoom[index].url && self.bannerRoom[index].url.length > 0)) {
                return ;
            }
            
            WebVC *webVC = [WebVC new];
            webVC.url = self.bannerRoom[index].url;
            [self.navigationController pushViewController:webVC animated:YES];
            
        }break;
            
        case HomeEventsTypeNotice:
        {
            SystemNoticeVC *noticeVC = [SystemNoticeVC new];
            
            [self.navigationController pushViewController:noticeVC animated:YES];
            
        }break;
            
        case HomeEventsTypeCategory:
        {
            
        }break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end