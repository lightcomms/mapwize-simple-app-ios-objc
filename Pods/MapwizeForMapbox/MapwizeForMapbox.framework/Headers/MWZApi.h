#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MWZApiResponseParser.h"
#import "MWZIconImage.h"
#import "MWZSearchParams.h"
#import "MWZApiFilter.h"
#import "MWZConnectorPlace.h"
#import "MWZParsedUrlObject.h"
#import "MWZStyleSheet.h"

@interface MWZApi : NSObject

/*
 Access request
 */
+ (NSURLSessionDataTask*)getAccess:(NSString*) accessKey success:(void (^)(void)) success failure:(void (^)(NSError* error)) failure;

/*
 Places requests
 */
+ (NSURLSessionDataTask*)getPlaceWithId:(NSString*) identifier success:(void (^)(MWZPlace* place)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getPlacesWithVenue:(MWZVenue*) venue universe:(MWZUniverse*) universe success:(void (^)(NSArray<MWZPlace*>* places)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getPlacesWithFilter:(MWZApiFilter*) filter success:(void (^)(NSArray<MWZPlace*>* places)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getConnectorPlacesWithFilter:(MWZApiFilter*) filter success:(void (^)(NSArray<MWZConnectorPlace*>* connectors)) success failure:(void (^)(NSError* error)) failure;
/*
 Venues requests
 */
+ (NSURLSessionDataTask*)getVenueWithId:(NSString*) identifier success:(void (^)(MWZVenue* venue)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getVenuesWithSuccess:(void (^)(NSArray<MWZVenue*>* venues))success failure:(void (^)(NSError* error))failure;

/*
 Layers requests
 */
+ (NSURLSessionDataTask*)getLayerWithId:(NSString*) identifier success:(void (^)(MWZLayer* layer)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getLayersWithVenue:(MWZVenue*) venue universe:(MWZUniverse*) universe success:(void (^)(NSArray<MWZLayer*>* layers)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getStyleSheet:(NSString*) identifier success:(void (^)(MWZStyleSheet* styleSheet)) success failure:(void (^)(NSError* error)) failure;

/*
 Directions requests
 */
+ (NSURLSessionDataTask*)getDirectionWithFrom:(id<MWZDirectionPoint>) from to:(id<MWZDirectionPoint>) to isAccessible:(BOOL) isAccessible success:(void (^)(MWZDirection* direction))success failure:(void (^)(NSError* error)) failure;

/*
 Search requests
 */
+ (NSURLSessionDataTask*)searchWithParams:(MWZSearchParams*) searchParams success:(void (^)(NSArray<id<MWZObject>>* searchResponse)) success failure:(void (^)(NSError* error)) failure;

/*
 LoadUrl request
 */
+ (NSURLSessionDataTask*)getParsedUrlObject:(NSString*) url success:(void (^)(MWZParsedUrlObject* parsedObject)) success failure:(void (^)(NSError* error)) failure;

/*
 Main searches and main froms
 */
+ (NSURLSessionDataTask*)getMainFromsWithVenue:(MWZVenue*) venue success:(void (^)(NSArray<MWZPlace*>* places)) success failure:(void (^)(NSError* error)) failure;
+ (NSURLSessionDataTask*)getMainSearchesWithVenue:(MWZVenue*) venue success:(void (^)(NSArray<id<MWZObject>>* mainSearches)) success failure:(void (^)(NSError* error)) failure;

+ (NSURLSessionDataTask*)getAccessibleUniversesWithVenue:(MWZVenue*) venue success:(void (^)(NSArray<MWZUniverse*>* universes)) success failure:(void (^)(NSError* error)) failure;

/*
 IconImages requests
 */
+ (NSURLSessionDataTask*)getImageWithUrl:(NSString*) url success:(void (^)(MWZIconImage *iconImage)) success failure:(void (^)(NSError *error)) failure;
@end
