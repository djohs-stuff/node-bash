sleep 1

PYTHON_VERSION=$(python --version)
echo $PYTHON_VERSION

cd /home/container

export PORT=$SERVER_PORT

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

${MODIFIED_STARTUP}
