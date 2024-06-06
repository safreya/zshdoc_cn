mkdir -p build/comments
echo "process po4a ..."
po4a po4a.conf
cd build
#rm -rf zsh_html
cp ../zsh.zh.texi zsh.texi
sed  -i '' -e "s/@c %\*\*end of header/@c %\*\*end of header\n\n@ifhtml\n@set dsq ''\n@set dsbq \`\`\n@end ifhtml/"  zsh.texi
# makeinfo --force --error-limit=999999 --split=chapter --html zsh.texi
echo "build zsh.html ..."
makeinfo --force --error-limit=999999 --no-split --no-headers --html --css-include=../zshhtml.css zsh.texi
echo "build comments html ..."
for file in ../comments/*.md; do
	if [ -f "$file" ]; then
		filename=$(basename -- "$file" .md)
		echo "build $filename.html ..."
		multimarkdown -f "$file" > "comments/$filename.html"
	fi
done
cp ../comments/mystyle.css comments/mystyle.css
echo "done."
