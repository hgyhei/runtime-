# runtime-
delegate性能优化：<br> 
在让委托对象调用可选的协议方法时，必须提前使用类型信息查询方法判断这个委托对象能否响应相关选择子。<br> 
if ([_delegate respondsToSelector:@selector(doSomeThing)])<br> 
{<br> 
[_delegate doSomeThing];<br> 
}<br> 
当频繁调用这个方法时，除了第一次检测有用，后面的检测都是多余的。这时候可以把委托对象能否响应某个协议方法的信息缓存起来，优化程序效率。<br> 
可以用结构体保存一个flag：<br> 
struct{<br> 
unsigned int didReceiverData ; 1<br> 
unsigned int ..... ; 1<br> 
}_delegateFlags;<br> 
在设置委托对象时：<br> 
- （void）setDelegate:(id<...>)delegate{<br> 
_delegate = delegate;<br> 
_delegateFlags.didReceiverData = [_delegate respondsToSelector:@selector(doSomeThing)];<br> 

}<br> 
这样的话每次调用delegate的相关方法时：<br> 
if(_delegateFlags.didReceiverData)<br> 
{<br> 

[_delegate doSomeThing];<br> 
}<br> 
这样就可以避免多次检查 提高程序效率；<br> 
