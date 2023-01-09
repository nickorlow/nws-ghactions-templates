if [ -f ".github/workflows/nws-deploy.yaml" ]
then

# if file exist the it will be printed 
echo "NWS Deployment scripts already exist in this repo!"
echo "Continuing with this script will overwrite those scripts\n---\n\n"
else

read -p "Enter the name of your main branch [main]: " branchname
branchname=${branchname:-main}

git checkout $branchname
mkdir .github
mkdir workflows
wget -o .github/workflows/nws-deploy.yaml https://raw.githubusercontent.com/nickorlow/nws-ghactions-templates/main/rawhtml.yaml
sed -i 's/{{_main_branchname_}}/$branchname/' .github/workflows/nws-deploy.yaml
git add .github/workflows/nws-deploy.yaml
git commit -am "Added NWS deployment script"
git push

echo "\n\nWelcome to NWS!\n"
