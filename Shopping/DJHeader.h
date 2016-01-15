
/**
 *  屏幕宽
 */
#define BoundsWidth    [[UIScreen mainScreen] bounds].size.width

/**
 *  屏幕高
 */
#define BoundsHeight   [[UIScreen mainScreen] bounds].size.height

/**
 *  判断iOS8
 */
#define  iOS8_or_later   ([UIDevice currentDevice].systemVersion.floatValue>=8.0)

/**
 *  RGB颜色
 */
#define  UIColorRGB(_r,_g,_b)    [UIColor colorWithRed:_r/255.f green:_g/255.f blue:_b/255.f alpha:1]

/**
 *  创建单例.h文件
 */
#define singleton_h(name) + (instancetype)shared##name;

/**
 *  创建单例.m文件
 */
#define singleton_m(name) \
static id _instance = nil; \
+(id)allocWithZone:(struct _NSZone *)zone \
{ \
    if (_instance == nil) { \
        static dispatch_once_t onceToken; \
        dispatch_once(&onceToken, ^{ \
            _instance = [super allocWithZone:zone]; \
        }); \
    } \
    return _instance; \
} \
-(id)init \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super init]; \
    }); \
    return _instance; \
} \
+(instancetype)share##name \
{ \
    return [[self alloc]init]; \
}

/**
 *  颜色
 */
#define DJColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DJColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue(b)/255.0 alpha:a]

/**
 *  随机色
 */
#define DJRandomColor DJcolor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

/**
 *  生成一个字符串
 */
#define NSString(...) [NSString stringWithFormat:__VA_ARGS__]

/**
 *  字典转模型
 */
#define NJInitH(name) \
- (instancetype)initWithDict:(NSDictionary *)dict; \
+ (instancetype)name##WithDict:(NSDictionary *)dict;

#define NJInitM(name)\
- (instancetype)initWithDict:(NSDictionary *)dict \
{ \
if (self = [super init]) { \
[self setValuesForKeysWithDictionary:dict]; \
} \
return self; \
} \
+ (instancetype)name##WithDict:(NSDictionary *)dict \
{ \
return [[self alloc] initWithDict:dict]; \
}

/**
 *  自定义Log
 */
#ifdef DEBUG
#define  DJLog(...) NSLog(__VA_ARGS__)
#else
#define DJLog(...)
#endif
