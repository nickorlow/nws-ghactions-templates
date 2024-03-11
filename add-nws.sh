orig_dir=`pwd`
cur_dir=`mktemp -d`

cd $cur_dir
echo "
NWS Deployment Helper v1.0.0
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
sed -i "s/{{_main_branchname_}}/$branchname/g" .github/workflows/nws-deploy.yaml
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

spin[0]="-"
spin[1]="\\"
spin[2]="|"
spin[3]="/"


echo "!!!! USER ACTION REQUIRED !!!"
echo "After a minute, navigate to the below link and change package visibility to public or else this script will fail!"
echo "https://github.com/$2/$3/pkgs/container/$3"
echo "!!!! USER ACTION REQUIRED !!!"
echo ""
echo ""

echo -n "Waiting for build to finish (this may take a while!)  "
i=0
while [[ `curl -s -N "https://github.com/$2/$3/pkgs/container/$3"` == *"Not Found"* ]]; 
do
        echo -ne "\b${spin[i]}"
        ((i = (i + 1) % 4)) 
done
echo ""
echo "Welcome to NWS!"
echo "Godspeed."
