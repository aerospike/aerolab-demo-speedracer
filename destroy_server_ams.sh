. configure.sh
aerolab client destroy -f -n ${AMS_NAME}
aerolab cluster destroy -f -n ${NAME}
echo "Don't forget to destroy clients"
