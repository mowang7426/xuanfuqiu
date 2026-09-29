#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBBottomXBridge : NSObject

+ (instancetype)sharedBridge;
- (BOOL)isBottomXAvailable;
- (BOOL)requestBackWithCompletion:(void (^ _Nullable)(BOOL handled))completion;

@end

NS_ASSUME_NONNULL_END
