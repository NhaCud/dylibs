#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

static AVAssetReader *reader;
static AVAssetReaderTrackOutput *videoOutput;
static NSString *videoPath = @"/var/mobile/Documents/fakevideo.mp4";

static CMSampleBufferRef getNextFrame() {

    if (!reader) {

        NSURL *url = [NSURL fileURLWithPath:videoPath];

        AVAsset *asset = [AVAsset assetWithURL:url];

        reader = [[AVAssetReader alloc] initWithAsset:asset error:nil];

        AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];

        NSDictionary *settings = @{
            (id)kCVPixelBufferPixelFormatTypeKey :
            @(kCVPixelFormatType_32BGRA)
        };

        videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track
                                                       outputSettings:settings];

        [reader addOutput:videoOutput];

        [reader startReading];
    }

    CMSampleBufferRef sample = [videoOutput copyNextSampleBuffer];

    if (!sample) {

        [reader cancelReading];
        reader = nil;

        return getNextFrame();
    }

    return sample;
}

%hook AVCaptureSession

- (void)startRunning {

    NSLog(@"[FakeCamera] Session started");

    %orig;
}

%end


%hook AVCaptureVideoDataOutput

- (void)setSampleBufferDelegate:(id)delegate queue:(dispatch_queue_t)queue {

    NSLog(@"[FakeCamera] Delegate hooked");

    %orig(delegate, queue);

    dispatch_async(queue, ^{

        while (true) {

            CMSampleBufferRef buffer = getNextFrame();

            if (!buffer) continue;

            if ([delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {

                [delegate captureOutput:self
                   didOutputSampleBuffer:buffer
                         fromConnection:nil];
            }

            usleep(33000);
        }
    });
}

%end


%hook AVCaptureDevice

+ (NSArray *)devices {

    NSLog(@"[FakeCamera] Device query");

    return %orig;
}

%end


%hook AVCaptureConnection

- (BOOL)isEnabled {

    return YES;
}

%end


%ctor {

    NSLog(@"[FakeCamera] dylib loaded");

}