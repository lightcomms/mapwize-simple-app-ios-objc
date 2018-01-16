#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWZGeojsonDataFactory.h"
#import "MWZMapwizePluginDelegate.h"
#import "MWZFloorControllerDelegate.h"
#import "MWZMapwizeAnnotation.h"
#import "MWZDirection.h"
#import "MWZLocationEngine.h"
#import "MWZLocationLayer.h"
#import "MWZConnectorAnnotationDelegate.h"
#import "MWZFollowUserButton.h"
#import "MWZPlaceList.h"
#import <IndoorLocation/IndoorLocation.h>

@import Mapbox;

@interface MapwizePlugin : NSObject <MGLMapViewDelegate, UIGestureRecognizerDelegate, MWZFloorControllerDelegate, CLLocationManagerDelegate, MWZFollowUserModeDelegate, UIGestureRecognizerDelegate, MWZLocationEngineDelegate, MWZConnectorAnnotationDelegate>

@property (nonatomic, strong) id<MGLMapViewDelegate> mapboxDelegate;

@property (nonatomic, strong) id<MWZMapwizePluginDelegate> delegate;
@property (nonatomic, strong) MWZFollowUserButton* followButton;

@property (nonatomic, strong) UIView* controllerView;

@property (nonatomic, strong) UIView* bottomLayoutView;
@property (nonatomic, strong) UIView* topLayoutView;

@property (nonatomic, strong) UIImageView* compassView;

@property (nonatomic, strong) ILIndoorLocation* userLocation;
@property (nonatomic, strong) NSNumber* userHeading;

- (instancetype) initWith:(MGLMapView*) mglMapView;

- (void) refreshWithCompletionHandler:(void (^)(void)) handler;

- (MWZVenue*) getVenue;
- (MWZUniverse*) getUniverse;
- (NSNumber*) getFloor;
- (void) setFloor:(NSNumber*) floor;
- (NSArray<NSNumber*>*) getFloors;

- (void) centerOnVenue:(MWZVenue*) venue;
- (void) centerOnPlace:(MWZPlace*) place;

- (void) setPreferredLanguage:(NSString*) language;
- (NSString*) getPreferredLanguage;

- (void) setLanguage:(NSString*) language forVenue:(MWZVenue*) venue;
- (NSString*) getLanguageForVenue:(MWZVenue*) venue;

- (void) setUniverse:(MWZUniverse*) universe forVenue:(MWZVenue*) venue;
- (MWZUniverse*) getUniverseForVenue:(MWZVenue*) venue;

- (void) addPromotedPlace:(MWZPlace*) place;
- (void) addPromotedPlaces:(NSArray<MWZPlace*>*) places;

- (void) removePromotedPlace:(MWZPlace*) place;
- (void) removePromotedPlaces:(NSArray<MWZPlace*>*) places;

- (void) setStyle:(MWZStyle*) style forPlace:(MWZPlace*) place;

- (void) setDirection:(MWZDirection*) direction;

- (void) setFollowUserMode:(FollowUserMode) followUserMode;

- (void) setIndoorLocationProvider:(ILIndoorLocationProvider*) locationProvider;

- (MWZMapwizeAnnotation*) addMarker:(MWZLatLngFloor*) latLngFloor;
- (MWZMapwizeAnnotation*) addMarker:(MWZLatLngFloor*) latLngFloor image:(UIImage*) image;
- (MWZMapwizeAnnotation*) addMarkerOnPlace:(MWZPlace*) place;
- (MWZMapwizeAnnotation*) addMarkerOnPlace:(MWZPlace*) place image:(UIImage*) image;
- (NSArray<MWZMapwizeAnnotation*>*) addMarkersOnPlaceList:(MWZPlaceList*) placeList;
- (void) removeMarker:(MWZMapwizeAnnotation*) marker;
- (void) removeMarkers;

- (void) setBottomPadding:(CGFloat) bottomPadding;
- (void) setTopPadding:(CGFloat) topPadding;

- (void) setBottomPadding:(CGFloat) bottomPadding animationDuration:(CGFloat) duration;
- (void) setTopPadding:(CGFloat) topPadding animationDuration:(CGFloat) duration;

@end
