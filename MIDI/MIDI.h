#import <Foundation/Foundation.h>
#import "CoreMidi/Midiservices.h"
#import "Clock.h"

@protocol RealtimeProtocol <NSObject>

- (void)midiStart;
- (void)midiStop;
- (void)midiContinue;
- (void)midiClock;
- (void)midiTick;

@end

@protocol StatusProtocol <NSObject>

- (void)midiStatus:(Byte)status data1:(Byte)data1 data2:(Byte)data2;

@end

@interface MIDI : NSObject {
@private
    MIDIClientRef client;
    MIDIPortRef input_port;
    MIDIPortRef output_port;
	MIDIEndpointRef out_endpoint;
    Clock *internalClock;
    dispatch_queue_t sync;
}

@property (readonly) NSString *clientName;
@property (strong) NSArray *sources;
@property (strong) NSArray *destinations;
@property (strong) id<RealtimeProtocol> realtimeDelegate;
@property (strong) id<StatusProtocol> voiceDelegate;

- (id)initWithName:(NSString *)clientName withSync:(dispatch_queue_t)queue;

- (void)connectSourceByName:(NSString *)name;
- (void)connectSourceByIndex:(NSInteger)index;

- (void)connectDestinationByName:(NSString *)name;
- (void)connectDestinationByIndex:(NSInteger)index;
- (void)disconnectDestinationByIndex:(NSInteger)index;

- (void)sendOnToChannel:(unsigned int)channel
                 number:(unsigned int)number
               velocity:(unsigned int)velocity;

- (void)sendOffToChannel:(unsigned int)channel
                  number:(unsigned int)number
                velocity:(unsigned int)velocity;

- (void)sendClock;
- (void)sendTick;
- (void)sendStart;
- (void)sendStop;
- (void)sendContinue;

- (void)runInternalClock:(NSTimeInterval)timeInterval;
- (void)adjustInternalClock:(NSTimeInterval)timeInterval;
- (void)stopInternalClock;

@end
