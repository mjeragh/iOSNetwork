//
//  Packet.m
//  MasterMindPrototype6
//
//  Created by Mohammad Jeragh on 3/1/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

#import "Packet.h"
#import "PacketSelectingPegs.h"
#import "PacketSignInResponse.h"
#import "NSData+MMAdditions.h"

const size_t PACKET_HEADER_SIZE = 10;

@implementation Packet
+ (id)packetWithType:(PacketType)packetType
{
	return [[[self class] alloc] initWithType:packetType];
}

- (id)initWithType:(PacketType)packetType
{
	if ((self = [super init]))
	{
		self.packetType = packetType;
	}
	return self;
}

- (NSData *)data
{
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:100];
    
	[data rw_appendInt32:'NWTT'];   // 0x4D4D3031
	[data rw_appendInt32:0];
	[data rw_appendInt16:self.packetType];
    
    [self addPayloadToData:data];
    
	return data;
}


/*Every time you add support for a new packet type, you also have to add a case-statement to this method. Don’t forget to import the class in Packet.m as well:*/

+ (id)packetWithData:(NSData *)data
{
	if ([data length] < PACKET_HEADER_SIZE)
	{
		NSLog(@"Error: Packet too small");
		return nil;
	}
    
	if ([data rw_int32AtOffset:0] != 'NWTT')
	{
		NSLog(@"Error: Packet has invalid header");
		return nil;
	}
    
    Packet *packet;
	//int packetNumber = [data rw_int32AtOffset:4];
	PacketType packetType = [data rw_int16AtOffset:8];
    
    switch (packetType)
	{
		case PacketTypeSignInRequest:
			packet = [Packet packetWithType:packetType];
			break;
            
		case PacketTypeSelectingPegs:
			packet = [PacketSelectingPegs packetWithData:data];
			break;
            
        case PacketTypeSignInResponse:
            packet = [PacketSignInResponse packetWithData:data];
			break;
            
		default:
			NSLog(@"Error: Packet has invalid type");
			return nil;
	}
    
    
	return packet;//[Packet packetWithType:packetType];
}


- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, type=%d", [super description], self.packetType];
}

- (void)addPayloadToData:(NSMutableData *)data
{
	// base class does nothing
}

@end
