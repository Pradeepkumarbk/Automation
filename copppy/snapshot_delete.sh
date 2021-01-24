#!/bin/bash
az login --service-principal --username 775e9a55-314b-4b1a-8443-c8c9dee5bc28 --password I+RFzwpXm13Jn==@k2B0R*@7Xw8e5@.a --tenant bfef2b06-d256-4f8e-bd03-8d3687987063
az account set --subscription 1a4ca968-738b-44dd-aba7-b7d4d8276037
export AZURE_STORAGE_ACCOUNT=jllambackupprod
export AZURE_STORAGE_KEY=fpHE72YjD36Q8FVdjoBMCB9ft0DFXDrxzzjh9e6YogFFXxroCcWR6RST51tyhgVa62IMgtK+DDyECull0K9KoA==
az snapshot delete --name kafka-0 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus && az snapshot delete --name kafka-1 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus && az snapshot delete --name kafka-2 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus && az snapshot delete --name zk-0 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus && az snapshot delete --name zk-1 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus && az snapshot delete --name zk-2 --resource-group MC_jll-am-rg-red2-dp-prod_jll-am-kube-prod_centralus
az storage blob delete -c kafka-0 -n kafka-0 && az storage blob delete -c kafka-1 -n kafka-1 && az storage blob delete -c kafka-2 -n kafka-2 && az storage blob delete -c zk-0 -n zk-0 && az storage blob delete -c zk-1 -n zk-1 && az storage blob delete -c zk-2 -n zk-2
