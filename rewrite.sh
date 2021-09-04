#/bin/bash
last_frontend_version=`cat last_frontend.txt`
last_backend_version=`cat last_backend.txt`
echo "Frontend $last_frontend_version"
echo "Backend $last_backend_version"
frontend_version=$last_frontend_version
backend_version=$last_backend_version
echo $1
echo $frontend_version
echo $backend_version
if [ "x$1" == "x" ];
then
        echo "type is empty. Needs to be backend or frontend"
        exit -1
fi
if [ "x$1" != "xfrontend" ] && [ "x$1" != "xbackend" ];
then
        echo "type has invalid value. Needs to be backend or frontend"
        exit -1
fi
if [ "x$TAG" == "x" ];
then
        echo "TAG is empty. Needs to be non-empty"
        exit -1
fi
if [ "x$1" == "xfrontend"  ];
then
        frontend_version=$TAG
        echo "new frontend version $frontend_version"
fi
if [ "x$1" == "xbackend"  ];
then
        backend_version=$TAG
        echo "new backend version $backend_version"
fi
BACKENDTAG=$backend_version FRONTENDTAG=$frontend_version eval "echo \"$(cat docker-compose.template.yml)\"" > docker-compose.yml
cat docker-compose.lower_template.yml >> docker-compose.yml
echo $frontend_version > last_frontend.txt
echo $backend_version > last_backend.txt
