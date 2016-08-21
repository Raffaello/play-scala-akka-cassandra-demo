#
# == Class: linux::base::ntpdate
#
# This class schedulle a ntpdate execution on crontab.
#
class linux::base::ntpdate (
  $ntpserver = $linux::params::gb_ntpserver
) {
  cron { 'CronTimeDateNTPdate':
      ensure  => 'present',
      user    => 'root',
      minute  => '*/5',
      command => "/usr/sbin/ntpdate ${ntpserver}",
  }
}
