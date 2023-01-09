orig_dir=`pwd`
cur_dir=`mktemp -d`

cd $cur_dir

git clone --quiet $2 . 2>&1 /dev/null

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
branchname="main"
fi

if git checkout $branchname 2>&1 /dev/null; then

mkdir .github 2>&1 /dev/null
mkdir .github/workflows 2>&1 /dev/null
touch .github/workflows/nws-deploy.yaml 2>&1 /dev/null

wget -O .github/workflows/nws-deploy.yaml https://raw.githubusercontent.com/nickorlow/nws-ghactions-templates/main/$1.yaml 2>&1  /dev/null
sed -i "s/{{_main_branchname_}}/$branchname/" .github/workflows/nws-deploy.yaml
git add .github/workflows/nws-deploy.yaml 2>&1  /dev/null
git commit -am "Added NWS deployment script" 2>&1  /dev/null

if git push 2>&1 /dev/null; then
echo "Welcome to NWS!"
else
echo "Pushing git repo failed! (Is there a merge conflict?)"
fi

else
echo "Branch $branchname doesn't exist!"
fi

cd $orig_dir
rm -rf $cur_dir

exit
while [ curl https://ghcr.io/token\?scope\="repository:$3/$4:pull" | grep -q 'token' ] 
do
  echo "matched"
  sleep 1
done

