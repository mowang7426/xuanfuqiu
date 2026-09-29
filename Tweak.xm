#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static void FBWriteRuntimeProbe(const char *line) {
    int fd = open("/var/mobile/Library/Logs/FloatBack-runtime.log",
                  O_WRONLY | O_CREAT | O_APPEND,
                  0644);
    if (fd < 0) {
        return;
    }
    dprintf(fd, "%s\n", line);
    close(fd);
}

static void FBProbeAssistiveTouchRuntime(void) {
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    const char *keywords[] = {"Assistive", "Touch", "Accessibility", "AX"};

    FBWriteRuntimeProbe("FloatBack runtime probe started");
    for (unsigned int i = 0; i < classCount; i++) {
        const char *name = class_getName(classes[i]);
        BOOL matches = NO;
        for (NSUInteger keywordIndex = 0;
             keywordIndex < sizeof(keywords) / sizeof(keywords[0]);
             keywordIndex++) {
            if (strstr(name, keywords[keywordIndex])) {
                matches = YES;
                break;
            }
        }
        if (matches) {
            char line[512];
            snprintf(line, sizeof(line), "class=%s", name);
            FBWriteRuntimeProbe(line);
        }
    }
    free(classes);
    FBWriteRuntimeProbe("FloatBack runtime probe finished");
}

%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
        FBProbeAssistiveTouchRuntime();
    });
}
