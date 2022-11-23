set -x
. configure.sh
set -x
# prepare config files
sed 's/_RACKID_/1/g' template.conf |sed "s/_NAMESPACE_/${NAMESPACE}/g" > rack1.conf
sed 's/_RACKID_/2/g' template.conf |sed "s/_NAMESPACE_/${NAMESPACE}/g" > rack2.conf
# sed 's/_RACKID_/3/g' template.conf |sed "s/_NAMESPACE_/${NAMESPACE}/g" > rack3.conf

# create cluster
echo "Creating cluster"
aerolab cluster create -n ${NAME} -c 2 -v ${VER} -o rack1.conf --instance-type ${AWS_INSTANCE} --ebs=40 --secgroup-id=${demo_servers} --subnet-id=${us_east_1a} || exit 1
aerolab cluster grow -n ${NAME} -c 2 -v ${VER} -o rack2.conf --instance-type ${AWS_INSTANCE} --ebs=40 --secgroup-id=${demo_servers} --subnet-id=${us_east_1d} || exit 1
# aerolab cluster grow -n ${NAME} -c 2 -v ${VER} -o rack3.conf --instance-type ${AWS_INSTANCE} --ebs=40 --secgroup-id=${demo_servers} --subnet-id=${us_east_1c} || exit 1

# remove config files
rm -f rack1.conf rack2.conf rack3.conf

# let the cluster do it's thang
echo "Wait"
sleep 15

# setup security
echo "Security"
aerolab attach asadm -n ${NAME} -- -U admin -P admin -e "enable; manage acl create role superuser priv read-write-udf; manage acl grant role superuser priv sys-admin; manage acl grant role superuser priv user-admin; manage acl create user superman password krypton roles superuser" || exit 1

# copy astools
echo "Copy astools"
aerolab files upload -n ${NAME} astools.conf /etc/aerospike/astools.conf || exit 1

# apply roster
echo "SC-Roster"
RET=1
while [ ${RET} -ne 0 ]
do
  aerolab roster apply -m ${NAMESPACE} -n ${NAME}
  RET=$?
  [ ${RET} -ne 0 ] && sleep 10
done

# exporter
echo "Adding exporter"
aerolab cluster add exporter -n ${NAME} -o ape.toml || exit 1

# deploy ams
echo "AMS"
aerolab client create ams -n ${AMS_NAME} -s ${NAME} --instance-type ${AWS_INSTANCE} --ebs=40 --secgroup-id=${demo_client} --subnet-id=${us_east_1d} || exit 1
echo
aerolab client list |grep ${AMS_NAME}
