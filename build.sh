
po4a po4a.conf
mkdir -p build
cd build
rm -rf zsh_html
cp ../zsh.zh.texi zsh.texi
sed  -i '' -e "s/@c %\*\*end of header/@c %\*\*end of header\n\n@ifhtml\n@set dsq ''\n@set dsbq \`\`\n@end ifhtml/"  zsh.texi
# makeinfo --force --error-limit=999999 --split=chapter --html zsh.texi
makeinfo --force --error-limit=999999 --no-split --no-headers --html zsh.texi
