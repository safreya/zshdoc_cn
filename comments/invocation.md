css: mystyle.css

# zsh 调用

## zsh 调用 [invocation-overview]

zsh 调用会创建子 shell。注意引号的不同，双引号会在子 shell 执行前先执行变量替换。变量 SHLVL 表示 shell 嵌套层级。

```
% zsh -c 'print $SHLVL'   # 此处为子 shell 中的$SHLVL
2
% zsh -c "print $SHLVL"   # 此处为当前 shell 中的$SHLVL
1
```


##  `-c` 选项 [invocation-flag-c]

`-c` 选项中 `$0`,`$1` 等，参考如下,区别于脚本或函数的位置参数：


```
# 简单的
% zsh -c 'echo "some string"'
some string
% zsh -c 'echo "My name is $0"' aaa bbb
My name is aaa
% zsh -c 'echo "My name is $1"' aaa bbb
My name is bbb
```

第一句，够简单。第二三句，父 shell 构造参数，子 shell 使用，可以成为一个技巧，不然还是简单点。

```
# 复杂的
% cat ./test.sh 
echo "inner arg0: $0"
echo "innet arg1: $1"
echo "inner arg2: $2"
echo "inner arg3: $3"

% zsh -c 'echo "outer arg0: $0";echo "outer arg1: $1";./test.sh aaa "$0" "$1"' bbb ccc
outer arg0: bbb
outer arg1: ccc
inner arg0: ./test.sh
innet arg1: aaa
inner arg2: bbb
inner arg3: ccc
```

如果用得着这么复杂，一定可以简化下吧。
