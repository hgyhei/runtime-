//
//  ViewController.m
//  runtime
//
//  Created by hgy on 16/3/8.
//  Copyright © 2016年 hgy. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController
/* OBJC_EXPORT BOOL class_addMethod(Class cls, SEL name, IMP imp,  const char *types)
 cls 在这个类中添加方法，也就是方法所添加的类
 name 方法名，这个可以随便起的
 imp 实现这个方法的函数
 types定义该数返回值类型和参数类型的字符串，这里比如"v@:"，其中v就是void，代表返回类型就是空，@代表参数，这里指的是id(self)，这里:指的是方法SEL(_cmd)，
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐式调用方法
    [self performSelector:@selector(doSomething)];
 // 3.+ (BOOL)resolveInstanceMethod:(SEL)sel中没有找到或者添加方法 该方法在一个与本类无继承关系的类中
      [self performSelector:@selector(secondVCMethod)];
    
    
}
//1.没有找到SEL的IMP(指向实现方法的函数)时就会执行。这个函数是给类利用class_addMethod添加函数的机会。根据文档，如果实现了添加函数代码则返回YES，未实现返回NO。
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(doSomething)) {
        NSLog(@"在类的缓存方法列表中，父类的方法中都没有找到该方法，来带这里");
        class_addMethod([self class], sel, (IMP)methodIMP, "v@:");
        return YES;
    }
       return [super resolveInstanceMethod:sel];
}
//2.实现SEL的方法函数 从而给类添加方法
void methodIMP(id self, SEL _cmd)
{
NSLog(@"添加了函数");

}

//4.消息继续传递，直到- (id)forwardingTargetForSelector:(SEL)aSelector
- (id)forwardingTargetForSelector:(SEL)aSelector{
    //这个函数就是消息的转发，在这儿我们成功的把消息传给了SecondViewController，然后让它来执行，所以就执行了那个方法
    Class class = NSClassFromString(@"SecondViewController");
      UIViewController *vc = class.new;
    if (aSelector == NSSelectorFromString(@"secondVCMethod")) {
        NSLog(@"SecondViewController do this");
        return vc;
    }
    return nil;
}

@end
