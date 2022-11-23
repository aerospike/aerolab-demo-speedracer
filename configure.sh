# basics
NAME="demo-oscar"         # cluster name
AMS_NAME="demo-mon-oscar"      # ams client name
CLIENT_NAME="speedracer" # name of client machine group
PRETTY_NAME="speedrace-mon"   # name of the asbench grafana machine
AWS_REGION=""          # don't touch this one
AWS_REGION="us-east-1" # comment out to use docker
AWS_INSTANCE="t3a.medium"
AWS_CLIENT_INSTANCE="t3a.medium"
VER="6.1.0.4"
FEATURES="/Users/oscar/aerospike/features.conf"
NAMESPACE="bar"
CLIENTS=2

# security groups
demo_servers=sg-0f14e291e1979bc74
demo_client=sg-01ce39e1dd537fe31

# demos_ams=sg-08aa879a7eae7a4df

# subnets
us_east_1a=subnet-092635f4fb61aa51c
us_east_1d=subnet-061f603eba7aae6c0
us_east_1c=subnet-0c2adcd83741ff64b

# aerolab config file
export AEROLAB_CONFIG_FILE="aerolab.conf"
rm -f ${AEROLAB_CONFIG_FILE}

# setup backend
[ "${AWS_REGION}" = "" ] && aerolab config backend -t docker || aerolab config backend -t aws -r ${AWS_REGION}
aerolab config defaults -k '*FeaturesFilePath' -v ${FEATURES} || exit 1
