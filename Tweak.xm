#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

static BOOL fakeEnabled = YES;

%hook AVCaptureSession

- (void)startRunning {

    NSLog(@"[FakeCamera] AVCaptureSession started");

    %orig;

}

%end


%hook AVCaptureVideoDataOutput

- (void)setSampleBufferDelegate:(id)delegate queue:(dispatch_queue_t)queue {

    NSLog(@"[FakeCamera] VideoDataOutput delegate hooked");

    %orig(delegate, queue);

}

%end


%hook AVCaptureDevice

+ (NSArray *)devices {

    NSLog(@"[FakeCamera] devices queried");

    return %orig;

}

%end


%ctor {

    NSLog(@"[FakeCamera] dylib loaded");

}