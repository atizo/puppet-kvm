define kvm::bridge(
  $from_device = 'eth0'
) {
  exec{"convert_${from_device}_to_bridge_$name":
    command => "convert_to_bridge.sh $name $from_device",
    creates => "/etc/sysconfig/network-scripts/ifcfg-$name",
    require => File['/usr/local/sbin/convert_to_bridge.sh'],
    notify => Exec["restart_network_$name"],
  }
  exec{"restart_network_$name":
    command => '/etc/init.d/network restart',
    refreshonly => true,
  }
}
