//
//  PacketSignInResponse.m
//  Snap
//
//  Created by Ray Wenderlich on 5/25/12.
//  Copyright (c) 2012 Hollance. All rights reserved.
//

#import "PacketSignInResponse.h"
#import "NSData+MMAdditions.h"

@implementation PacketSignInResponse

@synthesize playerName = _playerName;

+ (id)packetWithData:(NSData *)data
{
	size_t count;
	NSString *playerName = [data rw_stringAtOffset:PACKET_HEADER_SIZE bytesRead:&count];
	return [[self class] packetWithPlayerName:playerName];
}

+ (id)packetWithPlayerName:(NSString *)playerName
{
    NSLog(@"packetWithPlayerName class: %@", NSStringFromClass([self class]));
	return [[[self class] alloc] initWithPlayerName:playerName];
}

- (id)initWithPlayerName:(NSString *)playerName
{
	if ((self = [super initWithType:PacketTypeSignInResponse]))
	{
		self.playerName = playerName;
	}
    NSLog(@"initWithPlayerName class: %@", NSStringFromClass([self class]));
	return self;
}

- (void)addPayloadToData:(NSMutableData *)data
{
	[data rw_appendString:self.playerName];
}

-(NSString *)description{
    NSLog(@"decription class: %@", NSStringFromClass([self class]));
    return [NSString stringWithFormat:@"in PacketSignInResponse: %@, type=%d", [super description], self.packetType];
    
}

@end
