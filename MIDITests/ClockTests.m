#import "ClockTests.h"

@implementation ClockTests

- (void)setUp
{
    [super setUp];
    
    ClockBlock startBlock = ^(){ _started = YES; };
    ClockBlock stopBlock = ^(){ _stopped = YES; };
    ClockBlock clockBlock = ^(){ _ticks++; };
    
    Clock *c = [[Clock alloc] initWithStartBlock:startBlock clock:clockBlock stop:stopBlock];
    
    [self setStarted:NO];
    [self setStopped:NO];
    [self setTicks:(NSUInteger)0];
    
    [self setClock: c];
}

- (void)tearDown
{
    [_clock stop];
    [super tearDown];
}

- (void)test_initial_conditions
{
    STAssertFalse([self started], @"initial condition");
    STAssertFalse([self stopped], @"initial condition");
    STAssertEquals([self ticks], (NSUInteger)0, @"initial condition");
}

- (void)runloop_forInterval:(NSTimeInterval)interval
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:interval];
    
    while ( [loopUntil timeIntervalSinceNow] > 0)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
}

- (void)test_start
{
    [_clock startAtInterval:0.1];
    [self runloop_forInterval:1];
    
    STAssertTrue( [self started], nil );
    STAssertFalse( [self stopped], nil );
    STAssertEquals([self ticks], (NSUInteger)10, nil );
}

- (void)test_stop
{
    [_clock startAtInterval:0.1];
    [self runloop_forInterval:1];
    [_clock stop];
    
    STAssertTrue( [self started], nil );
    STAssertTrue( [self stopped], nil );
    STAssertEquals([self ticks], (NSUInteger)10, nil );
}

- (void)test_adjust
{
    ClockBlock clockBlock = ^(){
        if( ++_ticks == 5) {
            [_clock adjustToInterval:0.05];
        }};
    
    [_clock setClockBlock:clockBlock];
    [_clock startAtInterval:0.1];
    [self runloop_forInterval:1];
    [_clock stop];
    
    STAssertTrue( [self started], nil );
    STAssertTrue( [self stopped], nil );
    STAssertEquals([self ticks], (NSUInteger)15, nil );
}

@end
