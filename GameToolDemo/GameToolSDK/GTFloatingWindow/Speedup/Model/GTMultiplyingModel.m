//
//  GTMultiplyingModel.m
//  GTSDK
//
//  Created by shangmi on 2023/7/8.
//

#import "GTMultiplyingModel.h"

@implementation GTMultiplyingModel

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeFloat:self.number forKey:@"number"];
    [encoder encodeBool:self.isSelected forKey:@"isSelected"];
    [encoder encodeBool:self.isUp forKey:@"isUp"];
}

-(id)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if ( self != nil ) {
        self.number = [decoder decodeFloatForKey:@"number"];
        self.isSelected = [decoder decodeBoolForKey:@"isSelected"];
        self.isUp = [decoder decodeBoolForKey:@"isUp"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    id objCopy = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
            id valueCopy  = [[NSArray alloc]initWithArray:value copyItems:YES];
            [objCopy setValue:valueCopy forKey:propertyName];
        }else if (value) {
            [objCopy setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return objCopy;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    id objCopy = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:propertyName];
        if (value&&([value isKindOfClass:[NSMutableArray class]]||[value isKindOfClass:[NSArray class]])) {
            id valueCopy  = [[NSMutableArray alloc]initWithArray:value copyItems:YES];
            [objCopy setValue:valueCopy forKey:propertyName];
        }else if(value){
            [objCopy setValue:[value copy] forKey:propertyName];
        }
    }
    free(properties);
    return objCopy;
}


@end
