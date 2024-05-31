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
