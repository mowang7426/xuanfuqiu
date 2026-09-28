#import <UIKit/UIKit.h>

%ctor {
    // The plist limits this dylib to SpringBoard. Keep initialization minimal
    // because SpringBoard loads tweak constructors very early.
    NSLog(@"[FloatBack] SpringBoard bridge loaded");
}
