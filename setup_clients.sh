. configure.sh

# create clients
echo "Creating clients"
aerolab client create tools -n ${CLIENT_NAME} -v ${VER} -c ${CLIENTS} --instance-type ${AWS_CLIENT_INSTANCE} --ebs=40 --secgroup-id=${demo_client} --subnet-id=${us_east_1d} || exit 1

# copy astools
echo "Copy astools"
aerolab files upload -c -n ${CLIENT_NAME} astools.conf /etc/aerospike/astools.conf || exit 1
