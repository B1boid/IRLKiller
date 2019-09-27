#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class MBBannerInstruction;
@class MBFixLocation;
@class MBNavigationStatus;
@class MBNavigatorConfig;
@class MBRouterResult;
@class MBVoiceInstruction;

@interface MBNavigator : NSObject

- (nonnull instancetype)init;
- (nonnull MBNavigationStatus *)setRouteForRouteResponse:(nonnull NSString *)routeResponse
                                                   route:(uint32_t)route
                                                     leg:(uint32_t)leg;
- (BOOL)updateAnnotationsForRouteResponse:(nonnull NSString *)routeResponse
                                    route:(uint32_t)route
                                      leg:(uint32_t)leg;
- (BOOL)updateLocationForFixLocation:(nonnull MBFixLocation *)fixLocation;
- (nonnull MBNavigationStatus *)getStatusForTimestamp:(nonnull NSDate *)timestamp;
- (nullable NSNumber *)getBearing;
- (nullable MBBannerInstruction *)getBannerInstruction;
- (nullable MBVoiceInstruction *)getVoiceInstruction;
- (nullable MBBannerInstruction *)getBannerInstructionForIndexInRoute:(uint32_t)indexInRoute;
- (nullable MBVoiceInstruction *)getVoiceInstructionForIndexInRoute:(uint32_t)indexInRoute;
- (nullable NSArray<CLLocation *> *)getRouteGeometry;
- (nullable NSArray<CLLocation *> *)getRouteBoundingBox;
- (nullable NSString *)getRouteBufferGeoJsonForGrid_size:(float)grid_size
                                                dilation:(uint16_t)dilation;
- (nonnull NSString *)getHistory;
- (void)toggleHistoryForOnOff:(BOOL)onOff;
- (void)pushHistoryForEventType:(nonnull NSString *)eventType
            eventPropertiesJson:(nonnull NSString *)eventPropertiesJson;
- (nonnull MBNavigationStatus *)changeRouteLegForRoute:(uint32_t)route
                                                   leg:(uint32_t)leg;
- (nonnull MBNavigatorConfig *)getConfig;
- (void)setConfigForConfig:(nullable MBNavigatorConfig *)config;
/** Offline only functions */
- (uint64_t)configureRouterForTilesPath:(nonnull NSString *)tilesPath;
- (nonnull MBRouterResult *)getRouteForDirectionsUri:(nonnull NSString *)directionsUri;
- (uint64_t)unpackTilesForPacked_tiles_path:(nonnull NSString *)packed_tiles_path
                           output_directory:(nonnull NSString *)output_directory;
- (uint64_t)removeTilesForTiles_path:(nonnull NSString *)tiles_path
                          lower_left:(CLLocationCoordinate2D)lower_left
                         upper_right:(CLLocationCoordinate2D)upper_right;
- (nonnull MBRouterResult *)getTraceAttributesForTraceAttributesUri:(nonnull NSString *)traceAttributesUri;

@end
