# temporarily store uncommited changes
git stash

# verify correct branch
git checkout develop

# build new files
stack exec pages clean
stack exec pages build

# get previous files
git fetch -all
git checkout -b master --track origin/master

# overwrite existing files with new files
rsync -a --filter='P _site/' --filter='P _cache/' --filter='P .git/' --filter='P .gitignore' --delete-excluded _site/ .

# commit
git add -A
git commit -m "publish"

# push
git push origin master:master

# restoration
git checkout develop
git branch -D master
git stash pop
