#/bin/bash
last_frontend_version=`cat last_frontend.txt`
last_backend_version=`cat last_backend.txt`

frontend_container_registry_name=asia.gcr.io/${projectId}/${projectName}-frontend
backend_container_registry_name=asia.gcr.io/${projectId}/${projectName}-backend

if [ "x$1" == "x" ];
then
        echo "type is empty. Needs to be backend or frontend"
        exit -1
fi
if [ "x$1" != "xfrontend" ] && [ "x$1" != "xbackend" ] && [ "x$1" != "xall" ];
then
        echo "type has invalid value. Needs to be backend, frontend or all"
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
        docker pull $frontend_container_registry_name:$frontend_version
        TAG=$frontend_version bash rewritescript.sh frontend
        echo "Done processing frontend"
fi
if [ "x$1" == "xbackend"  ];
then
        backend_version=$TAG
        echo "new backend version $backend_version"
        docker pull $backend_container_registry_name:$backend_version
        TAG=$backend_version bash rewritescript.sh backend
        echo "Done processing backend"
fi

docker-compose down
COMPOSE_HTTP_TIMEOUT=3000 docker-compose up -d

if [ "x$1" == "xfrontend"  ];
then
        docker image rm $frontend_container_registry_name:$last_frontend_version
        echo "Deleted frontend"
fi
if [ "x$1" == "xbackend"  ];
then
        docker image rm $backend_container_registry_name:$last_backend_version
        echo "Deleted backend"
fi
