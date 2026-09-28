#import <UIKit/UIKit.h>

%ctor {
    NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    BOOL isSpringBoard = [bundleIdentifier isEqualToString:@"com.apple.springboard"];

    if (isSpringBoard) {
        // The AssistiveTouch private selector is intentionally isolated here.
        // Confirm the selector on the target iOS build before adding the hook.
        NSLog(@"[FloatBack] SpringBoard bridge loaded");

        return;
    }
}
