# find all the tags
wget -q https://registry.hub.docker.com/v1/repositories/python/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'  | column -c 150 

echo -n "what python: "
read python_version

cp Dockerfile_template Dockerfile_$python_version

sed -i '' "s/image_and_tag/${python_version}/" Dockerfile_$python_version

docker build -f "Dockerfile_$python_version" . -t "python-libs-builder-$python_version" 


docker run \
  --rm \
   --volume "$PWD/out:/out"\
   "python-libs-builder-$python_version:latest" \
  "mv /installed_libs.txt /out/installed_libs.txt"

docker run \
  --rm \
   --volume "$PWD/out:/out"\
   "python-libs-builder-$python_version:latest" \
   "mv /libs.tar /out/libs.tar"