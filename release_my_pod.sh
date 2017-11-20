git add -A && git commit -m "Release 0.0.3"
git tag -d 0.0.2
git push origin master
git tag '0.0.3'
git push -f --tags