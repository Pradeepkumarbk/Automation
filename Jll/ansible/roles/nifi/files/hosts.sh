#!/bin/bash

sed '/^::1         localhost localhost.localdomain localhost6 localhost6.localdomain6$/r'<(
    echo "10.42.121.20 kafka-1.kf-hs.default.svc.cluster.local"
    echo "10.42.121.21 kafka-0.kf-hs.default.svc.cluster.local"
    echo "10.42.121.22 kafka-2.kf-hs.default.svc.cluster.local"
    echo "10.42.121.23 schemaregistry-0.sr.default.svc.cluster.local"
) -i -- /etc/hosts

