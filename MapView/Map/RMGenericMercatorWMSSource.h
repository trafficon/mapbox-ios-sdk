
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "RMAbstractWebMapSource.h"

typedef struct { 
	CGPoint ul; 
	CGPoint lr; 
} CGXYRect; 

@interface RMGenericMercatorWMSSource : RMAbstractWebMapSource {
	NSMutableDictionary *wmsParameters;
	NSString *urlTemplate;
	CGFloat initialResolution, originShift;
}

- (RMGenericMercatorWMSSource *)initWithBaseUrl:(NSString *)baseUrl parameters:(NSDictionary *)params;

- (CGPoint)LatLonToMeters:(CLLocationCoordinate2D)latlon;
- (float)ResolutionAtZoom:(int)zoom;
- (CGPoint)PixelsToMeters:(int)px PixelY:(int)py atZoom:(int)zoom;
- (CLLocationCoordinate2D)MetersToLatLon:(CGPoint)meters;
- (CGXYRect)TileBounds:(RMTile)tile;
- (NSString*) tileURL: (RMTile) tile;

//- (RMLatLongBounds)TileLatLonBounds:(RMTile)tile;

@end
