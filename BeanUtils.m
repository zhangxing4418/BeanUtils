//
// BeanUtils.m
// GotoBus
//
// Created by haibara on 1/19/15.
//
//

#import "BeanUtils.h"
#import <BlocksKit.h>
#import <MAObjCRuntime/MARTNSObject.h>
#import <MAObjCRuntime/RTProperty.h>

@implementation BeanUtils

#pragma mark - Private

+ (NSArray *)getPropertyList:(Class)beanClass accessible:(BOOL)accessible simple:(BOOL)simple parentsUtil:(Class)superClass {
	NSMutableArray *properties = [NSMutableArray array];
	Class thisClass = beanClass;
	while (thisClass != [NSObject class] && (!superClass || superClass == [NSObject class] || [thisClass isSubclassOfClass:superClass])) {
		[properties addObjectsFromArray:[thisClass rt_properties]];
		thisClass = [thisClass superclass];
	}
	properties = [properties bk_select:^BOOL (RTProperty *property) {
		return property.ivarName;
	}];
	if (accessible) {
		properties = [properties bk_select:^BOOL (RTProperty *property) {
			return !property.isReadOnly;
		}];
	}
	if (simple) {
		properties = [properties bk_select:^BOOL (RTProperty *property) {
			return ![property.typeEncoding hasPrefix:@"@"] || [property.typeEncoding isEqualToString:@"@\"NSString\""] || [property.typeEncoding isEqualToString:@"@\"NSNumber\""] || [property.typeEncoding isEqualToString:@"@\"NSValue\""];
		}];
	}
	return properties;
}

+ (NSArray *)getAttributeKeys:(Class)beanClass accessible:(BOOL)accessible simple:(BOOL)simple parentsUtil:(Class)superClass {
	return [[self getPropertyList:beanClass accessible:accessible simple:simple parentsUtil:superClass] valueForKeyPath:@"name"];
}

#pragma mark - Public

+ (NSArray *)getAttributeKeys:(Class)beanClass {
	return [self getAttributeKeys:beanClass accessible:NO simple:NO parentsUtil:nil];
}

+ (NSArray *)getAccessibleAttributeKeys:(Class)beanClass {
	return [self getAttributeKeys:beanClass accessible:YES simple:NO parentsUtil:nil];
}

+ (NSArray *)getAccessibleSimpleAttributeKeys:(Class)beanClass {
	return [self getAttributeKeys:beanClass accessible:YES simple:YES parentsUtil:nil];
}

+ (NSArray *)getAccessibleSimpleAttributeKeys:(Class)beanClass parentsUtil:(Class)superClass {
	return [self getAttributeKeys:beanClass accessible:YES simple:YES parentsUtil:superClass];
}

+ (NSDictionary *)describe:(id)bean {
	return [self describe:bean attributeKeys:[self getAttributeKeys:[bean class]]];
}

+ (NSDictionary *)describe:(id)bean attributeKeys:(NSArray *)attributeKeys {
	return [bean dictionaryWithValuesForKeys:attributeKeys];
}

+ (NSDictionary *)describeAccessible:(id)bean {
	return [self describe:bean attributeKeys:[self getAccessibleAttributeKeys:[bean class]]];
}

+ (NSDictionary *)describeAccessibleSimple:(id)bean {
	return [self describe:bean attributeKeys:[self getAccessibleSimpleAttributeKeys:[bean class]]];
}

+ (NSDictionary *)describeAccessibleSimple:(id)bean parentsUtil:(Class)superClass {
	return [self describe:bean attributeKeys:[self getAccessibleSimpleAttributeKeys:[bean class] parentsUtil:superClass]];
}

+ (void)populate:(id)bean properties:(NSDictionary *)properties {
	[bean setValuesForKeysWithDictionary:properties];
}

+ (void)copyProperties:(id)dest origin:(id)orig {
	[self populate:dest properties:[self describeAccessible:orig]];
}

@end
