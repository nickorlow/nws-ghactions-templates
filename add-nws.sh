if [ -f ".github/workflows/nws-deploy.yaml" ]
then
echo "NWS Deployment scripts already exist in this repo!"
echo "Continuing with this script will overwrite those scripts"
echo "---"
fi

read -p "Enter the name of your main branch [main]: " branchname  <&1
if [ -z "$branchname"]
then
$branchname=main
fi
git checkout $branchname

mkdir .github
mkdir .github/workflows
touch .github/workflows/nws-deploy.yaml

wget -O .github/workflows/nws-deploy.yaml https://raw.githubusercontent.com/nickorlow/nws-ghactions-templates/main/rawhtml.yaml
sed -i 's/{{_main_branchname_}}/$branchname/' .github/workflows/nws-deploy.yaml
git add .github/workflows/nws-deploy.yaml
git commit -am "Added NWS deployment script"
git push

echo "Welcome to NWS!"
