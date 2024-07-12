css: mystyle.css

# 函数

## 自动加载 [function-autoload-undefined]

autoload 标记的函数在第一次运行前是未定义的，autoload 告诉 zsh，存在这样一个函数，可以在定义的位置找到。

```
~ % cat testfunc/myfunc1
echo "This is function 1."

~ % FPATH=$FPATH:~/testfunc       # 把函数搜索路径加入 fpath 数组
~ % echo "$FPATH"                 # 检查路径
/usr/local/share/zsh/site-functions: ...省略... :/home/xxx/testfunc
~ % autoload myfunc1              # 把 myfunc1 标记为“未定义的”
~ % functions myfunc1             # functions 内置命令查看函数定义，此时还没有运行过函数，是未定义的
myfunc1 () {
        # undefined
        builtin autoload -X
}
~ % myfunc1                       # 第一次运行函数
This is function 1.
~ % functions myfunc1             # 再次查看函数定义，此时函数已经真正定义
myfunc1 () {
        echo "This is function 1."
}
```

## 抑制别名扩展 [function-autoload-alias]

`autoload -U` 抑制别名扩展，指的是函数定义中的别名。

```
bsd% cat ~/testfunc/func1                      # 示例函数func1
echo "func1 begin"
justanalias                                              # 这是一个别名
echo "func1 end"
```

使用 `-U` 时

```
bsd% FPATH=FPATH:~/testfunc                                       # 在fpath中添加路径
bsd% alias justanalias="echo 'this is an alias'"                 # 定义别名
bsd% autoload -U func1                                                   # 使用 -U ，在函数定义读入时，不进行别名扩展
bsd% func1          
func1 begin
func1:2: command not found: justanalias                         # 没有别名扩展，此时找不到对应命令（函数）
func1 end
```

不使用 `-U` 时

``` 
bsd% FPATH=FPATH:~/testfunc
bsd% alias justanalias="echo 'this is an alias'"
bsd% autoload func1                                                        # 没有使用 -U,在函数定义读入时，进行别名扩展
bsd% func1
func1 begin
this is an alias                                                                                                                 
func1 end
bsd% functions func1                                                       # 检查函数定义，相应别名已经被替换为别名的实际内容
func1 () {
	echo "func1 begin"
	echo 'this is an alias'
	echo "func1 end"
}

```

在函数定义中不建议用别名，以免别名发生变化时产生不可预料的问题

## KSH_AUTOLOAD 的影响 [function-autoload-kshautoload]

例1:

```
~ % zsh -f    # 使用zsh -f启动Zsh时，不会加载任何额外的配置，以“干净”的状态下启动
bsd% cat testfunc/myfunc1
echo "my func1"
bsd% FPATH=$FPATH:~/testfunc
bsd% autoload -U myfunc1
bsd% myfunc1
my func1
```

例2:

```
~ % zsh -f
bsd% cat testfunc/myfunc1
echo "my func1"
bsd% FPATH=$FPATH:~/testfunc
bsd% setopt kshautoload    # 开启 KSH_AUTOLOAD
bsd% autoload -U myfunc1
bsd% myfunc1
my func1              # 文件中的语句得到执行
zsh: myfunc1: function not defined by file   # 但并没有定义函数
```

例3:

```
~ % zsh -f
bsd% cat testfunc/myfunc2             # 用 function 语句定义 myfunc2
function myfunc2 {
        echo "my func2"
}
bsd% FPATH=$FPATH:~/testfunc
bsd% setopt kshautoload
bsd% autoload -U myfunc2
bsd% myfunc2                        # 定义成功
my func2
```

在没有设置 `KSH_AUTOLOAD` 时，定义文件的内容，就是函数的函数体。设置 `KSH_AUTOLOAD` 后，通过执行文件内容定义函数（相当于脚本），要使用函数定义语法。

