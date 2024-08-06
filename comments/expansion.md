css: mystyle.css

# 扩展

## 选项 CSH_JUNKIE_HISTORY 对扩展引用的影响 [expansion-cshjunkiehistory]

未设置 cshjunkiehistory (默认)

```
bsd% PS1="%\!%)%m%# "         # 设置提示符以方便观察事件号
2)bsd% echo p1 p2             # 准备两个事件
p1 p2
3)bsd% echo p3 p4
p3 p4
4)bsd% echo !2:1 !:2          # !2:1 引用2号事件的第一个词， !:2 引用同一事件（即2号事件）的第二个词
echo p1 p2
p1 p2
5)bsd% echo !3:1 !:2          # !3:1 引用3号事件的第一个词， !:2 引用同一事件（即3号事件）的第二个词
echo p3 p4
p3 p4
```

设置 cshjunkiehistory 后

```
bsd% setopt cshjunkiehistory     
bsd% PS1="%\!%)%m%# "
3)bsd% echo p1 p2
p1 p2
4)bsd% echo p3 p4
p3 p4
5)bsd% echo !3:1 !:2          # !3:1 引用3号事件的第一个词， !:2 引用上一个事件（即4号事件）的第二个词
echo p1 p4
p1 p4
```