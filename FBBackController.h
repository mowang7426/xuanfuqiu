#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const FBBackNotification;

@interface FBBackController : NSObject

+ (instancetype)sharedController;
- (void)performBack;

@end

NS_ASSUME_NONNULL_END
