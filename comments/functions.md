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