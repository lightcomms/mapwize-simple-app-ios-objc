#import <UIKit/UIKit.h>
#import <Mapbox/Mapbox.h>
#import <MapwizeForMapbox/MapwizeForMapbox.h>

@interface ViewController : UIViewController <MWZMapwizePluginDelegate, MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet MGLMapView *mglMapView;

@end

