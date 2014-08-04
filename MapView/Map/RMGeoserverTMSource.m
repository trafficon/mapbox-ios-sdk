//
//  RMMapQuestOSMSource.m
//
// Copyright (c) 2008-2013, Route-Me Contributors
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "RMGeoserverTMSource.h"

@implementation RMGeoserverTMSource

@synthesize layerName;

- (id)init
{
    if (!(self = [super init]))
        return nil;
    
    self.minZoom = 0;
    self.maxZoom = 21;
    
	return self;
}

- (id)initWithLayerName:(NSString*)name {
    if (!(self = [super init]))
        return nil;
    
    self.layerName = name;
    return self;
}

- (NSURL *)URLForTile:(RMTile)tile
{
	NSAssert4(((tile.zoom >= self.minZoom) && (tile.zoom <= self.maxZoom)),
			  @"%@ tried to retrieve tile with zoomLevel %d, outside source's defined range %f to %f",
			  self, tile.zoom, self.minZoom, self.maxZoom);
    
    // Umrechnung fuer TMS
    int y = tile.y;
    y = pow(2, tile.zoom) - y - 1;
    
    // TMS Links auf Geoserver (ohne Layername)
    //
    //    NSString *tmsMapquest = [NSString stringWithFormat:@"http://otile1.mqcdn.com/tiles/1.0.0/osm/%d/%d/%d.png", tile.zoom, tile.x, tile.y];
    //	NSString *tmsIvmClip = [NSString stringWithFormat:@"http://geoserver.trafficon.eu/geoserver/gwc/service/tms/1.0.0/divis:ivm_clip@EPSG:900913@png/%d/%d/%d.png", tile.zoom, tile.x, y];
    //	NSString *tmsRealtime = [NSString stringWithFormat:@"http://geoserver.trafficon.eu/geoserver/gwc/service/tms/1.0.0/divis:realtime_fcd@EPSG:900913@png/%d/%d/%d.png", tile.zoom, tile.x, y];
    //    NSString *tmsRadnetz = [NSString stringWithFormat:@"http://geoserver.trafficon.eu/geoserver/gwc/service/tms/1.0.0/divis:radnetz_hessen@EPSG:900913@png/%d/%d/%d.png", tile.zoom, tile.x, y];
    
    
    // WMTS Links auf Geoserver (mit Layername)
    NSString *wmtsLink = [NSString stringWithFormat:@"http://geoserver.trafficon.eu/geoserver/gwc/service/wmts?service=WMTS&version=1.0.0&request=gettile&layer=%@&style=default&tileMatrixSet=EPSG:900913&tileMatrix=EPSG:900913:%d&TileRow=%d&TileCol=%d&format=image/png", self.layerName, tile.zoom, tile.y, tile.x];
    
    NSLog(@"URL: %@", wmtsLink);
    return [NSURL URLWithString:wmtsLink];
}

- (NSString *)uniqueTilecacheKey
{
	return layerName;
}

- (NSString *)shortName
{
	return @"ivm GmbH";
}

- (NSString *)longDescription
{
	return @"ivm GmbH (Integriertes Verkehrs- und Mobilitätsmanagement Region Frankfurt RheinMain)";
}

- (NSString *)shortAttribution
{
	return @"Radnetz von ivm GmbH";
}

- (NSString *)longAttribution
{
	return @"Map data © ivm GmbH";
}

@end
