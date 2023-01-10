orig_dir=`pwd`
cur_dir=`mktemp -d`

cd $cur_dir
echo "
NWS Deployment Helper
---
"

echo "cloning github.com:$2/$3..."
git clone --quiet git@github.com:$2/$3.git . > /dev/null 2>&1

if [ -f ".github/workflows/nws-deploy.yaml" ]
then
echo "NWS Deployment scripts already exist in this repo!"
echo "Continuing with this script will overwrite those scripts"
echo "---"
echo
fi

echo "Using deployment stragegy $1"
read -p "Enter the name of your main branch [main]: " branchname  <&1
echo
if [ -z "$branchname" ]
then
branchname="main"
fi

if git checkout $branchname > /dev/null 2>&1; then

mkdir .github > /dev/null 2>&1
mkdir .github/workflows > /dev/null 2>&1
touch .github/workflows/nws-deploy.yaml > /dev/null 2>&1

wget -O .github/workflows/nws-deploy.yaml https://raw.githubusercontent.com/nickorlow/nws-ghactions-templates/main/$1.yaml > /dev/null 2>&1
sed -i .bak  "s/{{_main_branchname_}}/$branchname/g" .github/workflows/nws-deploy.yaml
git add .github/workflows/nws-deploy.yaml > /dev/null 2>&1
git commit -am "Added NWS deployment script" > /dev/null 2>&1

if git push > /dev/null 2>&1; then
echo "Pushed deployment script to git repo"
else
echo "Pushing git repo failed! (Do you have access to it?/Is there a merge conflict?)"
fi

else
echo "Branch $branchname doesn't exist!"
fi

cd $orig_dir
rm -rf $cur_dir

i=0
x=0
echo -n "Waiting for build to finish (this may take a while!)"
while [[ `curl -s -N https://ghcr.io/token\?scope\="repository:$2/$3:pull"` == *"error"* ]]; 
do
  if [[ "$i" -eq 3 ]]
  then
    printf "\r\r\r"
    printf "   "
    printf "\r\r\r"
    i=0
  else
    printf "."
    i=$((i+1))
  fi
  if [[ "$x" -eq 1000 ]]
  then
    echo "Build timed out!"
    exit
  fi
  sleep 1
  x=$((x+1))
done

echo "Welcome to NWS!"

