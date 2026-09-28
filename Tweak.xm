#import <UIKit/UIKit.h>
#import <notify.h>

static void FBEmitBackNotification(void) {
    notify_post("com.example.floatback.perform-back");
}

%ctor {
    NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    BOOL isSpringBoard = [bundleIdentifier isEqualToString:@"com.apple.springboard"];

    if (isSpringBoard) {
        // The AssistiveTouch private selector is intentionally isolated here.
        // Confirm the selector on the target iOS build before adding the hook.
        NSLog(@"[FloatBack] SpringBoard bridge loaded");

        // Call FBEmitBackNotification() from the confirmed AssistiveTouch
        // single-tap hook once the target selector has been identified.
        return;
    }
}
