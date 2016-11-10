//
// BeanUtils.h
// GotoBus
//
// Created by haibara on 1/19/15.
//
//

@import Foundation;

@interface BeanUtils : NSObject

+ (NSArray *)getAttributeKeys:(Class)beanClass;
+ (NSArray *)getAccessibleAttributeKeys:(Class)beanClass;
+ (NSArray *)getAccessibleSimpleAttributeKeys:(Class)beanClass;
+ (NSArray *)getAccessibleSimpleAttributeKeys:(Class)beanClass parentsUtil:(Class)superClass;

+ (NSDictionary *)describe:(id)bean;
+ (NSDictionary *)describe:(id)bean attributeKeys:(NSArray *)attributeKeys;
+ (NSDictionary *)describeAccessible:(id)bean;
+ (NSDictionary *)describeAccessibleSimple:(id)bean;
+ (NSDictionary *)describeAccessibleSimple:(id)bean parentsUtil:(Class)superClass;

+ (void)populate:(id)bean properties:(NSDictionary *)properties;
+ (void)copyProperties:(id)dest origin:(id)orig;

@end
