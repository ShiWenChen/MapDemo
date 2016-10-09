//
//  ViewController.m
//  MapDemo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 racer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<MAMapViewDelegate>

@property (nonatomic,strong) MAMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViewAction];
}

-(void)loadViewAction{
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _mapView.delegate = self;
   ///使用定位
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass= YES; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.zoomEnabled = YES; ///缩放手势开启
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
    _mapView.scrollEnabled = YES;    //NO表示禁用滑动手势，YES表示开启
    
    ///把地图添加至view
    [self.view addSubview:_mapView];
     NSArray *items = @[@"标准",@"卫星"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.selected = YES;
    segment.selectedSegmentIndex = 0;
    segment.tintColor = [UIColor orangeColor];
    segment.frame = CGRectMake(0, self.view.bounds.size.height-100, 200, 30);
    [segment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    [_mapView addSubview:segment];
    UIButton *btnLoca = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLoca.frame = CGRectMake(300, self.view.bounds.size.height-100, 30, 30);;
    [btnLoca setBackgroundImage:[UIImage imageNamed:@"PositioningBg.png"] forState:UIControlStateNormal];
    [btnLoca addTarget:self action:@selector(reciveLocal) forControlEvents:UIControlEventTouchUpInside];
    btnLoca.backgroundColor = [UIColor yellowColor];
    [_mapView addSubview:btnLoca];
    
    
    UIButton *btnTraffic = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTraffic.frame = CGRectMake(330, self.view.bounds.size.height-100, 30, 30);
//    [btnTraffic setTitle:@"路况" forState:UIControlStateNormal];
    [btnTraffic setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btnTraffic setBackgroundImage:[UIImage imageNamed:@"unCheckBg.png"] forState:UIControlStateNormal];
    [btnTraffic addTarget:self action:@selector(checkActoin:) forControlEvents:UIControlEventTouchUpInside];
    btnTraffic.backgroundColor = [UIColor yellowColor];
    [_mapView addSubview:btnTraffic];
    ///绘线
    [self drawLineAction];
    
}

///绘制折线
-(void)drawLineAction
{
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    
    //在地图上添加折线对象
    [_mapView addOverlay: commonPolyline];
}
///绘线代理方法
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 10.f;
        ///线颜色
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
//        
        return polylineView;
    }
    return nil;
}
-(void)checkActoin:(UIButton *)btn{

    NSInteger tag = btn.tag;
    if (tag == 0) {
        btn.tag = 1;
        [btn setBackgroundImage:[UIImage imageNamed:@"checkBg.png"] forState:UIControlStateNormal];
        self.mapView.showTraffic = YES;
    }else{
        btn.tag = 0;
        [btn setBackgroundImage:[UIImage imageNamed:@"unCheckBg.png"] forState:UIControlStateNormal];
        self.mapView.showTraffic = NO;
    }
}
-(void)reciveLocal{
    [_mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES]; //地图跟着位置移动
}
-(void)changeType:(UISegmentedControl *)segment{
    NSInteger select = segment.selectedSegmentIndex;
    switch (select) {
        case 0:
            self.mapView.mapType = MAMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MAMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MAMapTypeStandard;
            
            break;
        default:
            break;
    }
    
}

///当位置更新时，会进定位回调，通过回调函数，能获取到定位点的经纬度坐标，示例代码如下：
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
