# basics
NAME="demo-reinv"         # cluster name
AMS_NAME="demo-mon-reinvent"      # ams client name
CLIENT_NAME="speedracer-reinv" # name of client machine group
PRETTY_NAME="speedrace-reinv-mon"   # name of the asbench grafana machine
AWS_REGION=""          # don't touch this one
AWS_REGION="us-east-1" # comment out to use docker
AWS_INSTANCE="c5ad.4xlarge" # e.g. c5ad.4xlarge
AWS_CLIENT_INSTANCE="t3a.medium"
VER="6.1.0.4"
FEATURES="/Users/oscarherrera/aerolab/templates/features.conf"
NAMESPACE="bar"
CLIENTS=2
PROVISION="" # don't touch this

# nvme - if set, will provision the disks to create 4x 20% sized partitions
# ONLY USE THIS WHEN USING NVME INSTANCES - ADJUST TO YOUR INSTANCE TYPE DISK NAMES
# IF THIS IS SET, template_nvme.conf WILL BE SHIPPED INSTEAD, ADJUST THAT TO YOUR NEEDS TOO
# below example works with c5ad.4xlarge
PROVISION="/dev/nvme1n1 /dev/nvme2n1" # list disks to provision, space separated

# security groups
demo_servers=sg-0f14e291e1979bc74
demo_client=sg-01ce39e1dd537fe31

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
