#import <Foundation/Foundation.h>

@class MBBannerSection;

@interface MBBannerInstruction : NSObject

- (nonnull instancetype)initWithPrimary:(nonnull MBBannerSection *)primary
                              secondary:(nullable MBBannerSection *)secondary
                                    sub:(nullable MBBannerSection *)sub
                  remainingStepDistance:(float)remainingStepDistance
                                  index:(uint32_t)index;

@property (nonatomic, readonly, nonnull) MBBannerSection *primary;
@property (nonatomic, readonly, nullable) MBBannerSection *secondary;
@property (nonatomic, readonly, nullable) MBBannerSection *sub;
@property (nonatomic, readonly) float remainingStepDistance;
@property (nonatomic, readonly) uint32_t index;

@end
