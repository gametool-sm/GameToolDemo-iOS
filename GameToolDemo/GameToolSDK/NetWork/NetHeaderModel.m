//
//  NetHeaderModel.m
//  GTSDK
//
//  Created by shangmi on 2023/7/25.
//

#import "NetHeaderModel.h"
#import "NSString+Custom.h"

@implementation NetHeaderModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSDictionary *)propertyValueDict {
    NSMutableDictionary *props = [NSMutableDictionary new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSString *)gtClientInfo {
    if (self.deviceId && ![self.deviceId isEqualToString:@""]) {
        NSString * sign = [NSString MD5:[NSString stringWithFormat:@"deviceId=%@&userId=%@%@", self.deviceId, self.userId, PROD ? @"97701568d069a91171ca890133737d02" : @"cff39ef21be3f0595a651edcec2b0d25"]];
        sign = [sign lowercaseString];
        NSString * queryString = [NSString stringWithFormat:@"deviceId=%@&userId=%@", self.deviceId, self.userId];
        return [NSString stringWithFormat:@"%@&sign=%@",queryString,sign];
    } else {
        return @"";
    }
}

@end
