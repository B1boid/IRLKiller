#import <Foundation/Foundation.h>

@interface MBNavigatorConfig : NSObject

- (nonnull instancetype)initWithTemporalCoherenceCutoff:(float)temporalCoherenceCutoff
                                 spatialCoherenceCutoff:(float)spatialCoherenceCutoff
                                     minTrustedDuration:(float)minTrustedDuration
                               minTrustedObserverations:(uint32_t)minTrustedObserverations
                                      offRouteThreshold:(float)offRouteThreshold
                  offRouteThresholdWhenNearIntersection:(float)offRouteThresholdWhenNearIntersection
                 intersectionRadiusForOffRouteDetection:(float)intersectionRadiusForOffRouteDetection
                         gpsAccuracyOffRouteScaleFactor:(float)gpsAccuracyOffRouteScaleFactor
               proximityToRouteStayInitializedThreshold:(float)proximityToRouteStayInitializedThreshold
                                           corralBuffer:(float)corralBuffer
                                             maxHistory:(uint32_t)maxHistory
                                         lookAheadScale:(float)lookAheadScale
                                        defaultAccuracy:(float)defaultAccuracy
                   maxUpdatesAwayFromRouteBeforeReroute:(uint8_t)maxUpdatesAwayFromRouteBeforeReroute
                      bearingDifferenceRerouteThreshold:(uint16_t)bearingDifferenceRerouteThreshold
                                      nextStepTolerance:(float)nextStepTolerance
                                      maxRetroGradeTime:(uint8_t)maxRetroGradeTime
                                    maxRetroGradeJitter:(float)maxRetroGradeJitter
                                          maxPrediction:(float)maxPrediction
              maneuverApproachPredictionScalingDuration:(float)maneuverApproachPredictionScalingDuration
                                         speedMaxDeltaT:(float)speedMaxDeltaT
                                     minPredictionSpeed:(float)minPredictionSpeed
                                          minNearTunnel:(float)minNearTunnel
                                minSpeedMetersPerSecond:(float)minSpeedMetersPerSecond
                                  minAnnotationDistance:(float)minAnnotationDistance
                               arrivalThresholdDuration:(nullable NSNumber *)arrivalThresholdDuration
                               arrivalThresholdDistance:(nullable NSNumber *)arrivalThresholdDistance
                              voiceInstructionThreshold:(float)voiceInstructionThreshold
                                 defaultArrivalDistance:(float)defaultArrivalDistance;

/** How much time (seconds) can elapse between two fix locations before they will not be considered part of the same cluster of fix locations */
@property (nonatomic, readwrite) float temporalCoherenceCutoff;

/** How much arc (straight line) distance (meters) between two fix locations before they will not be considered part of the same cluster of fix locations */
@property (nonatomic, readwrite) float spatialCoherenceCutoff;

/** How much time (seconds) should have passed over a cluster of fix locations before we trust that they are usable */
@property (nonatomic, readwrite) float minTrustedDuration;

/** The minimum number of fixes in a cluster before we can trust it */
@property (nonatomic, readwrite) uint32_t minTrustedObserverations;

/** Off route threshold in meters */
@property (nonatomic, readwrite) float offRouteThreshold;

/** Off route threshold in meters when near an intersection which is more prone to inaccurate gps fixes */
@property (nonatomic, readwrite) float offRouteThresholdWhenNearIntersection;

/** Radius in meters for off route detection near intersection */
@property (nonatomic, readwrite) float intersectionRadiusForOffRouteDetection;

/** GPS accuracy off-route scale factor */
@property (nonatomic, readwrite) float gpsAccuracyOffRouteScaleFactor;

/** Maximum distance away from the route you can be and still be allowed to use the route */
@property (nonatomic, readwrite) float proximityToRouteStayInitializedThreshold;

/** A buffer for the corral that is created when you start out not exactly on the route but with in the proximity_to_route_stay_initialized_threshold_ */
@property (nonatomic, readwrite) float corralBuffer;

/** Maximum number of previous fixes/statuses to keep around */
@property (nonatomic, readwrite) uint32_t maxHistory;

/** Step scale to allow for some people to drive faster than expected or to cover more linear distance than expected */
@property (nonatomic, readwrite) float lookAheadScale;

/** Default accuracy when one isn't provided used in route shape snapping limits */
@property (nonatomic, readwrite) float defaultAccuracy;

/** Max number of locations updates moving in an unexpected direction before a reroute */
@property (nonatomic, readwrite) uint8_t maxUpdatesAwayFromRouteBeforeReroute;

/** Number of degrees bearing difference between user and route before it is considered too far off course */
@property (nonatomic, readwrite) uint16_t bearingDifferenceRerouteThreshold;

/** How close to the next step do you have to be to be allowed to jump to it */
@property (nonatomic, readwrite) float nextStepTolerance;

/** How many seconds do you have to be making progress away from the route before getting an off route status */
@property (nonatomic, readwrite) uint8_t maxRetroGradeTime;

/** If you meet the max_retrograde_time_ for moving in the wrong direction we are ok with it if its less than this jitter amount */
@property (nonatomic, readwrite) float maxRetroGradeJitter;

/** The maximum amount of time (seconds) into future we can predict locations in the absence of a tunnel (or other gps obstructions) */
@property (nonatomic, readwrite) float maxPrediction;

/** If the number of seconds left on your maneuver is less than this when we predict you then we will scale back that predition linearly as you approach the maneuver log would be a better scale, but we'll deal with it later */
@property (nonatomic, readwrite) float maneuverApproachPredictionScalingDuration;

/** The max distance in time between two statuses that we can still use for speed computation */
@property (nonatomic, readwrite) float speedMaxDeltaT;

/** The minimum speed (meters/second) you have to be traveling before we will allow you to do prediction even if you aren't in/near a tunnel */
@property (nonatomic, readwrite) float minPredictionSpeed;

/** The minimum distance (meters) you need to be from a tunnel to be considered near a gps obstruction */
@property (nonatomic, readwrite) float minNearTunnel;

/** The minimum speed you have to be going for your heading to be used on the first location for the route so that the route goes in the direction you are already traveling mainly useful in a reroute scenario */
@property (nonatomic, readwrite) float minSpeedMetersPerSecond;

/** The minimum distance to require between two shape points when using annotation data to compute the speed at that point in the route */
@property (nonatomic, readwrite) float minAnnotationDistance;

/** The duration it takes until the navigator should should mark the current route as complete. */
@property (nonatomic, readwrite, nullable) NSNumber *arrivalThresholdDuration;

/** The remaining distance to the last coordinate before the navigator should mark the current route as complete. */
@property (nonatomic, readwrite, nullable) NSNumber *arrivalThresholdDistance;

/** The threshold at which we will return a voice instruction after current progress has passed it. */
@property (nonatomic, readwrite) float voiceInstructionThreshold;

/** If no arrivalThresholdDuration/Distance are specified and there are no voice or banner instructions included in the route the distance used to mark completion of the leg */
@property (nonatomic, readwrite) float defaultArrivalDistance;


@end
