$orig_dir=pwd
$cur_dir=mktemp
cd $cur_dir

git clone $2 .

if [ -f ".github/workflows/nws-deploy.yaml" ]
then
echo "NWS Deployment scripts already exist in this repo!"
echo "Continuing with this script will overwrite those scripts"
echo "---"
fi
echo "Using deployment stragegy $1"
read -p "Enter the name of your main branch [main]: " branchname  <&1
if [ -z "$branchname" ]
then
$branchname="main"
fi

if git checkout $branchname 2>&1; then

mkdir .github 2>&1
mkdir .github/workflows 2>&1
touch .github/workflows/nws-deploy.yaml 2>&1

wget -O .github/workflows/nws-deploy.yaml https://raw.githubusercontent.com/nickorlow/nws-ghactions-templates/main/$1.yaml 2>&1
sed -i "s/{{_main_branchname_}}/$branchname/" .github/workflows/nws-deploy.yaml
git add .github/workflows/nws-deploy.yaml 2>&1
git commit -am "Added NWS deployment script" 2>&1

if git push 2>&1; then
echo "Welcome to NWS!"
else
echo "Pushing git repo failed! (Is there a merge conflict?)"
fi

else
echo "Branch $branchname doesn't exist!"
fi

cd $orig_dir
rm -rf $cur_dir
