css: mystyle.css

# 语法

## for

### 示例1 [syntax-for-ex1]

省略 'in word'，则使用位置参数

```
bsd % function ex1
function> for value;do
function for> print "$value"
function for> done                      
bsd % ex1 "aaa" "bbb" "ccc"
aaa
bbb
ccc
bsd % cat example_for.sh 
for value;do
    print "$value"
done
bsd % zsh example_for.sh "aaa" "bbb" "ccc"
aaa
bbb
ccc
```

### 示例2 [syntax-for-ex2]

word 按组分配，不足时，视为空

```
bsd % for key value desc in k1 v1 d1 k2 v2 d2 k3;do
for> print "key:$key, value:$value, desc:$desc"
for> done                      
key:k1, value:v1, desc:d1
key:k2, value:v2, desc:d2
key:k3, value:, desc:
```

### 示例3 [syntax-for-ex3]

应避免用 "in" 作为 "name"

```
bsd % for in out in inv1 outv2 inv2 outv2;do       
for> print "in:$in, out:$out"
for> done                      
in:inv1, out:outv2
in:inv2, out:outv2
bsd % in=
bsd % out=
bsd % for out in in outv1 inv1 outv2 inv2 ;do # 注意，第一个 in 是分隔符，第二个 in 是值
print "out:$out, in:$in"
done
out:in, in:
out:outv1, in:
out:inv1, in:
out:outv2, in:
out:inv2, in:
```

## select [syntax-select-name]

name 输入时，首个非空白字符应该为数字字符，与该字符相连的所有数字组合成一个数值，如果数值大小在选择范围内，name 就是这个数值，否则为空。

```
bsd % select name in a b c d e f g h i j k l m n o p q r s t u v w x y z
select> do                        
select> print "name:'$name'"
select> print "$REPLY"
select> done                      
1) a   4) d   7) g   10) j  13) m  16) p  19) s  22) v  25) y  
2) b   5) e   8) h   11) k  14) n  17) q  20) t  23) w  26) z  
3) c   6) f   9) i   12) l  15) o  18) r  21) u  24) x  
?# c1d3                      
name:''
c1d3
?# 4a
name:'d'
4a
?#      3y
name:'c'
	3y
?#  3x
name:'c'
 3x
?# 4xx5yy
name:'d'
4xx5yy
``` 

## always [syntax-always]

`错误` 是指会导致中止执行的情况(try-list 中止执行)。语句产生错误（返回非0值），这时 try-list 不中止执行,在这里不算错误。

```
bsd % cat test.sh        
#! /usr/local/bin/zsh
echo "1. TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
{
	if [[]];then
		echo "never run"
	fi	
	echo "2.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
} always
{
	echo "3.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
	echo "always run"
}
echo "4.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
bsd % zsh test.sh        
1. TRY_BLOCK_ERROR: -1
test.sh:5: no matches found: [[]]
3.TRY_BLOCK_ERROR: 1
always run
```

try-list 中，if 语句错误，try-list 中止执行，执行完 always-list 后，中止脚本。

```
bsd % cat test2.sh
#! /usr/local/bin/zsh
echo "1. TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
{
	if [[]];then
		echo "never run"
	fi	
	echo "2.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
} always
{
	echo "3.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
	echo "always run"
	TRY_BLOCK_ERROR=0
}
echo "4.TRY_BLOCK_ERROR: $TRY_BLOCK_ERROR"
bsd % zsh test2.sh
1. TRY_BLOCK_ERROR: -1
test2.sh:5: no matches found: [[]]
3.TRY_BLOCK_ERROR: 1
always run
4.TRY_BLOCK_ERROR: -1
```

always-list 中设置 `TRY_BLOCK_ERROR=0` 后，always 语句执行完，脚本仍然继续执行。always-list 外， `TRY_BLOCK_ERROR` 的值无关紧要，被设置为 `-1`。

## function [syntax-function]

一个函数可以有同时定义多个函数名

```
bsd % function func1 func2     
function> echo "function with 2 names"
bsd % func1               
function with 2 names
bsd % func2
function with 2 names
bsd % 
```

可以用`()`，但`()`必须放名称列表的最后，函数体可以是 `{ list }` 或 `command`(只有一条指令时）,函数体不能是 `do ... done` 块。

```
bsd % function func3 func4 ()
function> do                        
zsh: parse error near `do'             # 注: 不能使用 do ... done 块
bsd % function func3 func4 ()
function> {
function> echo "this is an other function with 2 name."
function> echo "() must put on end of name list."
function> }
bsd % func3                  
this is an other function with 2 name.
() must put on end of name list.
bsd % func4
this is an other function with 2 name.
() must put on end of name list.
bsd % function func5 () notafuncname;{echo "this is not a function body"} # 第15行:详见下面说明
this is not a function body
bsd % func5
func5: command not found: notafuncname
bsd % notafuncname   
zsh: command not found: notafuncname
```

第15行：func5 后面的 `()` 终止函数名列表，notafuncname 被解释为 command (即函数体),而不是函数名。`;` 结束了前面一条语句，后面的 `{}` 表示一条新的语句（list）,这语句会立即执行，即输出第16行。

第17行：原因如上，实际 func5 的函数体是命令notafuncname，实际不存在这个命令，所以 shell 报找不到命令的错误。

另外：如果使用了 `()`，term 在语法上可以不再需要（如15行所示，不再举例）。
