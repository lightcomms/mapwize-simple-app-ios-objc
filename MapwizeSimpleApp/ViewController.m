#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

MapwizePlugin* mapwizePlugin;

- (void)viewDidLoad {
    [super viewDidLoad];
    mapwizePlugin = [[MapwizePlugin alloc] initWith:_mglMapView];
    mapwizePlugin.delegate = self;
    mapwizePlugin.mapboxDelegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) plugin:(MapwizePlugin *)plugin didTapOnVenue:(MWZVenue *)venue {
    [plugin centerOnVenue:venue];
}

- (void) mapViewRegionIsChanging:(MGLMapView *)mapView {
    NSLog(@"Mapbox delegate : region did change");
}

@end
