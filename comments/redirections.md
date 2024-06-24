css: mystyle.css

## 重定向

### 顺序 [redirections-order]

在Shell中，重定向操作符的顺序是非常重要的。

一 、 `... 1>fname 2>&1`

这个命令通常用于将标准输出（文件描述符1）重定向到文件fname，然后将标准错误（文件描述符2）也重定向到与标准输出相同的位置。具体步骤如下：

* 1>fname: 这首先将标准输出重定向到文件fname。
* 2>&1: 然后，这将标准错误重定向到当前标准输出。此时，标准输出已经被重定向到fname，因此标准错误也将被重定向到fname。

结果：标准输出和标准错误都被写入到文件fname。

二、 `... 2>&1 1>fname`

这个命令的重定向顺序不同，效果也不同。具体步骤如下：

* 2>&1: 这首先将标准错误重定向到当前标准输出。假设当前标准输出是终端，那么标准错误也会被重定向到终端。
* 1>fname: 然后，这将标准输出重定向到文件fname。此时，标准输出被重定向到文件，但标准错误仍然指向原来的标准输出（终端）。

结果：标准输出被写入到文件fname，而标准错误被写入到终端。

顺序非常重要，因为它决定了每个文件描述符在重定向后的目标位置。

## 只读参数 [redirections-fd-param-readonly]

使用时有些小坑，注意避让。

```
bsd ~ % readonly param1
bsd ~ % exec {param1}>test1.txt      # 只读参数不可以分配文件描述符
zsh: can't allocate file descriptor to readonly parameter param1
bsd ~ % exec {param2}>test2.txt      # 打开文件描述符后，可以设为只读
bsd ~ % readonly param2
bsd ~ % echo "line1" >&$param2
bsd ~ % cat test2.txt
line1
bsd ~ % echo "line2" >&$param2     # 第二次写入类似追加
bsd ~ % cat test2.txt
line1
line2
bsd ~ % echo "line3" >>&$param2    # >& 打开的文件描述符，不能用 >>& 写入
bsd ~ % cat test2.txt
line1
line2
bsd ~ % echo "line4" &>$param2     # &> 形式无效
bsd ~ % cat test2.txt
line1
line2
bsd ~ % exec {param2}>&-           # 只读参数不能关闭
zsh: can't close file descriptor from readonly parameter param2
bsd ~ % exec {param3}>> text3.txt
bsd ~ % echo "line1" >>&$param3   # 写法无效
bsd ~ % cat text3.txt             
bsd ~ % echo "line1" >&$param3    # 写法有效
bsd ~ % cat text3.txt
line1
bsd ~ % echo "line2" >&$param3
bsd ~ % cat text3.txt
line1
line2
```
