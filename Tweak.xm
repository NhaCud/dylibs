#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

%hook AVCaptureSession

- (void)startRunning {

    NSLog(@"[FakeCamera] Session started");

    %orig;

}

%end


%hook AVCaptureVideoDataOutput

- (void)setSampleBufferDelegate:(id)delegate queue:(dispatch_queue_t)queue {

    NSLog(@"[FakeCamera] VideoDataOutput hooked");

    %orig(delegate, queue);

}

%end


%ctor {

    NSLog(@"[FakeCamera] Loaded");

}