cd ~/environment/goldstone-mgmt/
$K exec ds/gs-mgmt-cli -- gscli -c "sonic; port; show" | grep Ethernet1

sed -i '16s/mgmt/mgmt-np2/' k8s/mgmt.yaml
$K apply -f k8s/

# A partir de aquí, ejecuto de las líneas 45 a 85 del https://github.com/microsonic/goldstone-mgmt/blob/master/.github/workflows/ci.yaml
export NP2_POD=$($K get pod -l app=gs-mgmt-np2 -o=jsonpath='{.items[0].metadata.name}{"\n"}')
export NP2_ADDR=$($K get svc netopeer2 -o=jsonpath='{.spec.clusterIP}{"\n"}')

ssh-keygen -f id_rsa -N ""
$K exec $NP2_POD -c netopeer2 -- mkdir -p /root/.ssh
$K cp id_rsa.pub $NP2_POD:/root/.ssh/authorized_keys -c netopeer2
cat <<EOF > config.xml
<modules xmlns="http://goldstone.net/yang/tai">
<module>
  <name>0</name>
  <config>
    <name>0</name>
    <admin-status>down</admin-status>
  </config>
</module>
</modules>
EOF
cat <<EOF > check_np2.sh
#!/bin/sh
netopeer2-cli <<EOF2
auth pref publickey 4
auth keys add /data/id_rsa.pub /data/id_rsa
auth hostkey-check disable
connect --host $NP2_ADDR
status
get-config --source running --filter-xpath "/goldstone-tai:modules"
edit-config --target candidate --config=/data/config.xml
get-config --source candidate --filter-xpath "/goldstone-tai:modules"
commit
EOF2
EOF
chmod +x check_np2.sh
docker run -e NP2_ADDR=$NP2_ADDR --net=host -v $(pwd):/data -w /data docker.io/microsonic/gs-mgmt-netopeer2:latest ./check_np2.sh
