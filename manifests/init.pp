#
# kvm module
#
# Copyright 2010, Atizo AG
# Simon Josi simon.josi+puppet(at)atizo.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class kvm {
  package{[
      'kvm',
      'kmod-kvm',
      'libvirt',
      'libvirt-python',
      'virt-top',
      'qemu',
      'bridge-utils',
      'tunctl', 
    ]:
    ensure => present,
  }
  service{'libvirtd':
    ensure => running,
    enable => true,
    hasstatus => true,
    require => Package['libvirt'],
  }
  file{[
      '/etc/libvirt/qemu/networks/default.xml',
      '/etc/libvirt/qemu/networks/autostart/default.xml',
    ]:
    ensure => absent,
    notify => [
      Service['libvirtd'],
      Exec['remove_virbr0'],
    ],
  }
  exec{'remove_virbr0':
    command => 'ifconfig virbr0 down; brctl delbr virbr0; exit 0',
    refreshonly => true,
    
  }
  file{'/usr/local/sbin/convert_to_bridge.sh':
    source => "puppet://$server/modules/kvm/convert_to_bridge.sh",
    owner => root, group => root, mode => 0750,
  }
}
