#!/bin/bash
line_count=$(oc get namespace -o custom-columns=":metadata.name" | egrep -c "showroom-user")

for ((i=1; i<=line_count; i++)); do
    NS="showroom-user"$i
    oc scale -n $NS deploy/showroom --replicas=0
    sleep 1
    oc patch -n $NS deploy/showroom --patch='{"spec":{"template":{"spec":{"containers": [{"name": "content","env": [{"name": "GIT_REPO_URL", "value": "https://github.com/nanodayo/openshift-virt-roadshow-cnv-multi-user"}, {"name": "GIT_REPO_REF", "value": "not_mtv_udn_route"}]}]}}}}'
    oc scale -n $NS deploy/showroom --replicas=1
done