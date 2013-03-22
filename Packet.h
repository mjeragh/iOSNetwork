//
//  Packet.h
//  MasterMindPrototype6
//
//  Created by Mohammad Jeragh on 3/1/13.
//  Copyright (c) 2013 Mohammad Jeragh. All rights reserved.
//

const size_t PACKET_HEADER_SIZE;

typedef enum
{
	PacketTypeSignInRequest = 0x64,    // server to client
	PacketTypeSignInResponse,          // client to server
    
	PacketTypeServerReady,             // server to client
	PacketTypeClientReady,             // client to server
    
	PacketTypeSelectingPegs,            // server to client
    PacketTypeClientWaiting,            //client to server
	PacketTypeSelectedPeg,              // server to client
    
	PacketTypeOtherClientQuit,         // server to client
	PacketTypeServerQuit,              // server to client
	PacketTypeClientQuit,              // client to server
}
PacketType;

@interface Packet : NSObject

@property (nonatomic, assign) PacketType packetType;

+ (id)packetWithType:(PacketType)packetType;
- (id)initWithType:(PacketType)packetType;
+ (id)packetWithData:(NSData *)data;

- (NSData *)data;

@end
