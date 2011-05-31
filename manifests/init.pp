# Class: centos
#
# CentOS specific - included as $operatingsystem in generic module
#
# Requires:
#   class ntp
#   class pam
#   class rpm
#   class sysctl
#   class yum
#
class centos {
    include ntp
    include rpm
    include sysctl

    file {
        # adjust the default PATH
        "/etc/profile.d/sbin.sh":
            source => "puppet:///modules/centos/sbin.sh",
            mode   => "755";
        # change prompt to reflect which $pop you are in
        "/usr/local/bin/popps1.sh":
            source => "puppet:///modules/centos/popps1.sh",
            mode   => "755";
        # back off selinux config
        "/etc/selinux/config":
            source => "puppet:///modules/centos/selinux/config",
            mode   => "0644";
    } # file

    exec { "/usr/sbin/setenforce 0":
        before => File["/etc/selinux/config"],
        onlyif => "/bin/sh -c if [ `/usr/bin/getenforce` != 'Disabled' ]; then exit 0; else exit 1; fi"
    }

    package { 'setools': 
        ensure => installed,
        before => Exec ["/usr/sbin/setenforce 0"]
    }

} # class centos
