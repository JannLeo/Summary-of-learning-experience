@echo off
echo "DOCS PUSH BAT"

echo "wait 5s"
choice /t 5 /d y /n >nul

echo "load to the file"
d:
cd homeworkandppt\

echo "git add"
git add .

echo "git commit"
git commit -m "autopush"

echo "git push"
git push
pause