#!/usr/bin/env bash

set -eu -o pipefail

NGINXLOGDIR=$1

cat <<HERE


# AWSTATS CONFIGURE FILE 7.3
#-----------------------------------------------------------------------------
# Copy this file into awstats.www.mydomain.conf and edit this new config file
# to setup AWStats (See documentation in docs/ directory).
# The config file must be in /etc/awstats, /usr/local/etc/awstats or /etc (for
# Unix/Linux) or same directory than awstats.pl (Windows, Mac, Unix/Linux...)
# To include an environment variable in any parameter (AWStats will replace
# it with its value when reading it), follow the example:
# Parameter="__ENVNAME__"
# Note that environment variable AWSTATS_CURRENT_CONFIG is always defined with
# the config value in an AWStats running session and can be used like others.
#-----------------------------------------------------------------------------



#-----------------------------------------------------------------------------
# MAIN SETUP SECTION (Required to make AWStats work)
#-----------------------------------------------------------------------------

# "LogFile" contains the web, ftp or mail server log file to analyze.
# Possible values: A full path, or a relative path from awstats.pl directory.
# Example: "/var/log/apache/access.log"
# Example: "../logs/mycombinedlog.log"
# You can also use tags in this filename if you need a dynamic file name
# depending on date or time (Replacement is made by AWStats at the beginning
# of its execution). This is available tags :
#   %YYYY-n  is replaced with 4 digits year we were n hours ago
#   %YY-n    is replaced with 2 digits year we were n hours ago
#   %MM-n    is replaced with 2 digits month we were n hours ago
#   %MO-n    is replaced with 3 letters month we were n hours ago
#   %DD-n    is replaced with day we were n hours ago
#   %HH-n    is replaced with hour we were n hours ago
#   %NS-n    is replaced with number of seconds at 00:00 since 1970
#   %WM-n    is replaced with the week number in month (1-5)
#   %Wm-n    is replaced with the week number in month (0-4)
#   %WY-n    is replaced with the week number in year (01-52)
#   %Wy-n    is replaced with the week number in year (00-51)
#   %DW-n    is replaced with the day number in week (1-7, 1=sunday)
#                              use n=24 if you need (1-7, 1=monday)
#   %Dw-n    is replaced with the day number in week (0-6, 0=sunday)
#                              use n=24 if you need (0-6, 0=monday)
#   Use 0 for n if you need current year, month, day, hour...
# Example: "/var/log/access_log.%YYYY-0%MM-0%DD-0.log"
# Example: "C:/WINNT/system32/LogFiles/W3SVC1/ex%YY-24%MM-24%DD-24.log"
# You can also use a pipe if log file come from a pipe :
# Example: "gzip -cd /var/log/apache/access.log.gz |"
# If there are several log files from load balancing servers :
# Example: "/pathtotools/logresolvemerge.pl *.log |"
#
LogFile="${NGINXLOGDIR}access.log"


# Enter the log file type you want to analyze.
# Possible values:
#  W - For a web log file
#  S - For a streaming log file
#  M - For a mail log file
#  F - For a ftp log file
# Example: W
# Default: W
#
LogType=W


# Enter here your log format (Must match your web server config. See setup
# instructions in documentation to know how to configure your web server to
# have the required log format).
# Possible values: 1,2,3,4 or "your_own_personalized_log_format"
# 1 - Apache or Lotus Notes/Domino native combined log format (NCSA combined/XLF/ELF log format)
# 2 - IIS or ISA format (IIS W3C log format). See FAQ-COM115 For ISA.
# 3 - Webstar native log format.
# 4 - Apache or Squid native common log format (NCSA common/CLF log format)
#     With LogFormat=4, some features (browsers, os, keywords...) can't work.
# "your_own_personalized_log_format" = If your log is ftp, mail or other format,
#     you must use following keys to define the log format string (See FAQ for
#     ftp, mail or exotic web log format examples):
#   %host             Client hostname or IP address (or Sender host for mail log)
#   %host_r           Receiver hostname or IP address (for mail log)
#   %lognamequot      Authenticated login/user with format: "john"
#   %logname          Authenticated login/user with format: john
#   %time1            Date and time with format: [dd/mon/yyyy:hh:mm:ss +0000] or [dd/mon/yyyy:hh:mm:ss]
#   %time2            Date and time with format: yyyy-mm-dd hh:mm:ss
#   %time3            Date and time with format: Mon dd hh:mm:ss or Mon dd hh:mm:ss yyyy
#   %time4            Date and time with unix timestamp format: dddddddddd
#   %time5            Date and time with format iso: yyyy-mm-ddThh:mm:ss, with optional timezone specification (ignored)
#   %methodurl        Method and URL with format: "GET /index.html HTTP/x.x"
#   %methodurlnoprot  Method and URL with format: "GET /index.html"
#   %method           Method with format: GET
#   %url              URL only with format: /index.html
#   %query            Query string (used by URLWithQuery option)
#   %code             Return code status (with format for web log: 999)
#   %bytesd           Size of document in bytes
#   %refererquot      Referer page with format: "http://from.com/from.htm"
#   %referer          Referer page with format: http://from.com/from.htm
#   %uabracket        User agent with format: [Mozilla/4.0 (compatible, ...)]
#   %uaquot           User agent with format: "Mozilla/4.0 (compatible, ...)"
#   %ua               User agent with format: Mozilla/4.0_(compatible...)
#   %gzipin           mod_gzip compression input bytes: In:XXX
#   %gzipout          mod_gzip compression output bytes & ratio: Out:YYY:ZZpct.
#   %gzipratio        mod_gzip compression ratio: ZZpct.
#   %deflateratio     mod_deflate compression ratio with format: (ZZ)
#   %email            EMail sender (for mail log)
#   %email_r          EMail receiver (for mail log)
#   %virtualname      Web sever virtual hostname. Use this tag when same log
#                     contains data of several virtual web servers. AWStats
#                     will discard records not in SiteDomain nor HostAliases
#   %cluster          If log file is provided from several computers (merged by
#                     logresolvemerge.pl), use this to define cluster id field.
#   %extraX           Another field that you plan to use for building a
#                     personalized report with ExtraSection feature (See later).
#   If your log format has some fields not included in this list, use:
#   %other            Means another not used field
#   %otherquot        Means another not used double quoted field
#   If your log format has some literal strings, which precede data fields, use
#   status=%code      Means your log files have HTTP status logged as "status=200"
#   Literal strings that follow data field must be separated from said data fields by space.
#
# Examples for Apache combined logs (following two examples are equivalent):
# LogFormat = 1
# LogFormat = "%host %other %logname %time1 %methodurl %code %bytesd %refererquot %uaquot"
#
# Example for IIS:
# LogFormat = 2
#
LogFormat=1


# If your log field's separator is not a space, you can change this parameter.
# This parameter is not used if LogFormat is a predefined value (1,2,3,4)
# Backslash can be used as escape character.
# Example: " "
# Example: "\t"
# Example: "\|"
# Example: ","
# Default: " "
#
LogSeparator=" "


# "SiteDomain" must contain the main domain name, or the main intranet web
# server name, used to reach the web site.
# If you share the same log file for several virtual web servers, this
# parameter is used to tell AWStats to filter record that contains records for
# this virtual host name only (So check that this virtual hostname can be
# found in your log file and use a personalized log format that include the
# %virtualname tag).
# But for multi hosting a better solution is to have one log file for each
# virtual web server. In this case, this parameter is only used to generate
# full URL's links when ShowLinksOnUrl option is set to 1.
# If analyzing mail log, enter here the domain name of mail server.
# Example: "myintranetserver"
# Example: "www.domain.com"
# Example: "ftp.domain.com"
# Example: "domain.com"
#
SiteDomain="{{ cookiecutter.site_domain }}"


# Enter here all other possible domain names, addresses or virtual host
# aliases someone can use to access your site. Try to keep only the minimum
# number of possible names/addresses to have the best performances.
# You can repeat the "SiteDomain" value in this list.
# This parameter is used to analyze referer field in log file and to help
# AWStats to know if a referer URL is a local URL of same site or an URL of
# another site.
# Note: Use space between each value.
# Note: You can use regular expression values writing value with REGEX[value].
# Note: You can also use @/mypath/myfile if list of aliases are in a file.
# Example: "www.myserver.com localhost 127.0.0.1 REGEX[mydomain\.(net|org)$]"
#
HostAliases="localhost localhost:8080 web 127.0.0.1 {{ cookiecutter.site_domain }}"


# If you want to have hosts reported by name instead of ip address, AWStats
# need to make reverse DNS lookups (if not already done in your log file).
# With DNSLookup to 0, all hosts will be reported by their IP addresses and
# not by the full hostname of visitors (except if names are already available
# in log file).
# If you want/need to set DNSLookup to 1, don't forget that this will reduce
# dramatically AWStats update process speed. Do not use on large web sites.
# Note: Reverse DNS lookup is done on IPv4 only (Enable ipv6 plugin for IPv6).
# Note: Result of DNS Lookup can be used to build the Country report. However
# it is highly recommanded to enable the plugin 'geoip' or 'geoipfree' to
# have an accurate Country report with no need of DNS Lookup.
# Possible values:
# 0 - No DNS Lookup
# 1 - DNS Lookup is fully enabled
# 2 - DNS Lookup is made only from static DNS cache file (if it exists)
# Default: 2
#
DNSLookup=0


# For very large sites, setting DNSLookup to 0 (or 2) might be the only
# reasonable choice. DynamicDNSLookup allows to resolve host names for
# items shown in html tables only, when data is output on reports instead
# of resolving once during log analysis step.
# Possible values:
# 0 - No dynamic DNS lookup
# 1 - Dynamic DNS lookup enabled
# 2 - Dynamic DNS lookup enabled (including static DNS cache file as a second
#     source)
# Default: 0
#
DynamicDNSLookup=0


# When AWStats updates its statistics, it stores results of its analysis in
# files (AWStats database). All those files are written in the directory
# defined by the "DirData" parameter. Set this value to the directory where
# you want AWStats to save its database and working files into.
# Warning: If you want to be able to use the "AllowToUpdateStatsFromBrowser"
# feature (see later), you need "Write" permissions by web server user on this
# directory (and "Modify" for Windows NTFS file systems).
# Example: "/var/lib/awstats"
# Example: "../data"
# Example: "C:/awstats_data_dir"
# Default: "."          (means same directory as awstats.pl)
#
DirData="/var/lib/awstats"


# Relative or absolute web URL of your awstats cgi-bin directory.
# This parameter is used only when AWStats is run from command line
# with -output option (to generate links in HTML reported page).
# Example: "/awstats"
# Default: "/cgi-bin"   (means awstats.pl is in "/yourwwwroot/cgi-bin")
#
DirCgi="/cgi-bin"


# Relative or absolute web URL of your awstats icon directory.
# If you build static reports ("... -output > outputpath/output.html"), enter
# path of icon directory relative to the output directory 'outputpath'.
# Example: "/awstatsicons"
# Example: "../icon"
# Default: "/icon" (means you must copy icon directories in "/mywwwroot/icon")
#
DirIcons="/icon"


# When this parameter is set to 1, AWStats adds a button on report page to
# allow to "update" statistics from a web browser. Warning, when "update" is
# made from a browser, AWStats is run as a CGI by the web server user defined
# in your web server (user "nobody" by default with Apache, "IUSR_XXX" with
# IIS), so the "DirData" directory and all already existing history files
# awstatsMMYYYY[.xxx].txt must be writable by this user. Change permissions if
# necessary to "Read/Write" (and "Modify" for Windows NTFS file systems).
# Warning: Update process can be long so you might experience "time out"
# browser errors if you don't launch AWStats frequently enough.
# When set to 0, update is only made when AWStats is run from the command
# line interface (or a task scheduler).
# Possible values: 0 or 1
# Default: 0
#
AllowToUpdateStatsFromBrowser=0


# AWStats saves and sorts its database on a month basis (except if using
# databasebreak option from command line).
# However, if you choose the -month=all from command line or
# value '-Year-' from CGI combo form to have a report for all year, AWStats
# needs to reload all data for full year (each month), and sort them,
# requiring a large amount of time, memory and CPU. This might be a problem
# for web hosting providers that offer AWStats for large sites, on shared
# servers, to non CPU cautious customers.
# For this reason, the 'full year' is only enabled on Command Line by default.
# You can change this by setting this parameter to 0, 1, 2 or 3.
# Possible values:
#  0 - Never allowed
#  1 - Allowed on CLI only, -Year- value in combo is not visible
#  2 - Allowed on CLI only, -Year- value in combo is visible but not allowed
#  3 - Possible on CLI and CGI
# Default: 2
#
AllowFullYearView=2



#-----------------------------------------------------------------------------
# OPTIONAL SETUP SECTION (Not required but enhances AWStats's functionality)
#-----------------------------------------------------------------------------

# When the update process runs, AWStats can set a lock file in TEMP or TMP
# directory. This lock is to avoid to have 2 update processes running at the
# same time to prevent unknown conflicts problems and avoid DoS attacks when
# AllowToUpdateStatsFromBrowser is set to 1.
# Because, when you use lock file, you can experience sometimes problems in
# lock file not correctly removed (killed process for example requires that
# you remove the file manualy), this option is not enabled by default (Do
# not enable this option with no console server access).
# Change : Effective immediately
# Possible values: 0 or 1
# Default: 0
#
EnableLockForUpdate=0


# AWStats can do reverse DNS lookups through a static DNS cache file that was
# previously created manually. If no path is given in static DNS cache file
# name, AWStats will search DirData directory. This file is never changed.
# This option is not used if DNSLookup=0.
# Note: DNS cache file format is 'minsince1970 ipaddress resolved_hostname'
# or just 'ipaddress resolved_hostname'
# Change : Effective for new updates only
# Example: "/mydnscachedir/dnscache"
# Default: "dnscache.txt"
#
DNSStaticCacheFile="dnscache.txt"


# AWStats can do reverse DNS lookups through a DNS cache file that was created
# by a previous run of AWStats. This file is erased and recreated after each
# statistics update process. You don't need to create and/or edit it.
# AWStats will read and save this file in DirData directory.
# This option is used only if DNSLookup=1.
# Note: If a DNSStaticCacheFile is available, AWStats will check for DNS
# lookup in DNSLastUpdateCacheFile after checking into DNSStaticCacheFile.
# Change : Effective for new updates only
# Example: "/mydnscachedir/dnscachelastupdate"
# Default: "dnscachelastupdate.txt"
#
DNSLastUpdateCacheFile="dnscachelastupdate.txt"


# You can specify specific IP addresses that should NOT be looked up in DNS.
# This option is used only if DNSLookup=1.
# Note: Use space between each value.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "123.123.123.123 REGEX[^192\.168\.]"
# Default: ""
#
SkipDNSLookupFor=""


# The following two parameters allow you to protect a config file from being
# read by AWStats when called from a browser if the web user has not been
# authenticated. Your AWStats program must be in a web protected "realm" (With
# Apache, you can use .htaccess files to do so. With other web servers, see
# your server setup manual).
# Change : Effective immediately
# Possible values: 0 or 1
# Default: 0
#
AllowAccessFromWebToAuthenticatedUsersOnly=0


# This parameter gives the list of all authorized authenticated users to view
# statistics for this domain/config file. This parameter is used only if
# AllowAccessFromWebToAuthenticatedUsersOnly is set to 1.
# Change : Effective immediately
# Example: "user1 user2"
# Example: "__REMOTE_USER__"
# Default: ""
#
AllowAccessFromWebToFollowingAuthenticatedUsers=""


# When this parameter is defined to something, the IP address of the user that
# reads its statistics from a browser (when AWStats is used as a CGI) is
# checked and must match one of the IP address values or ranges.
# Change : Effective immediately
# Example: "127.0.0.1 123.123.123.1-123.123.123.255"
# Default: ""
#
AllowAccessFromWebToFollowingIPAddresses=""


# If the "DirData" directory (see above) does not exist, AWStats return an
# error. However, you can ask AWStats to create it.
# This option can be used by some Web Hosting Providers that has defined a
# dynamic value for DirData (for example DirData="/home/__REMOTE_USER__") and
# don't want to have to create a new directory each time they add a new user.
# Change : Effective immediately
# Possible values: 0 or 1
# Default: 0
#
CreateDirDataIfNotExists=0


# You can choose in which format the Awstats history database is saved.
# Note: Using "xml" format make AWStats building database files three times
# larger than using "text" format.
# Change : Database format is switched after next update
# Possible values: text or xml
# Default: text
#
BuildHistoryFormat=text


# If you prefer having the report output pages be built as XML compliant pages
# instead of simple HTML pages, you can set this to 'xhtml' (May not work
# properly with old browsers).
# Change : Effective immediately
# Possible values: html or xhtml
# Default: html
#
BuildReportFormat=html


# AWStats databases can be updated from command line of from a browser (when
# used as a cgi program). So AWStats database files need write permission
# for both command line user and default web server user (nobody for Unix,
# IUSR_xxx for IIS/Windows,...).
# To avoid permission problems between update process (run by an admin user)
# and CGI process (ran by a low level user), AWStats can save its database
# files with read and write permissions for everyone.
# By default, AWStats keeps default user permissions on updated files. If you
# set AllowToUpdateStatsFromBrowser to 1, you can change this parameter to 1.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
SaveDatabaseFilesWithPermissionsForEveryone=0


# AWStats can purge log file, after analyzing it. Note that AWStats is able
# to detect new lines in a log file, to process only them, so you can launch
# AWStats as often as you want, even with this parameter to 0.
# With 0, no purge is made, so you must use a scheduled task or a web server
# that make this purge frequently.
# With 1, the purge of the log file is made each time AWStats update is run.
# This parameter doesn't work with IIS (This web server doesn't let its log
# file to be purged).
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
PurgeLogFile=0


# When PurgeLogFile is setup to 1, AWStats will clean your log file after
# processing it. You can however keep an archive file of all processed log
# records by setting this parameter (For example if you want to use another
# log analyzer). The archived log file is saved in "DirData" with name
# awstats_archive.configname[.suffix].log
# This parameter is not used if PurgeLogFile=0
# Change : Effective for new updates only
# Possible values: 0, 1, or tags (See LogFile parameter) for suffix
# Example: 1
# Example: %YYYY%MM%DD
# Default: 0
#
ArchiveLogRecords=0


# Each time you run the update process, AWStats overwrites the 'historic file'
# for the month (awstatsMMYYYY[.*].txt) with the updated one.
# When write errors occurs (IO, disk full,...), this historic file can be
# corrupted and must be deleted. Because this file contains information of all
# past processed log files, you will loose old stats if removed. So you can
# ask AWStats to save last non corrupted file in a .bak file. This file is
# stored in "DirData" directory with other 'historic files'.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
KeepBackupOfHistoricFiles=0


# Default index page name for your web server.
# Change : Effective for new updates only
# Example: "index.php index.html default.html"
# Default: "index.php index.html"
#
DefaultFile="index.html"


# Do not include access from clients that match following criteria.
# If your log file contains IP addresses in host field, you must enter here
# matching IP addresses criteria.
# If DNS lookup is already done in your log file, you must enter here hostname
# criteria, else enter ip address criteria.
# The opposite parameter of "SkipHosts" is "OnlyHosts".
# Note: Use space between each value. This parameter is not case sensitive.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "127.0.0.1 REGEX[^192\.168\.] REGEX[^10\.]"
# Example: "localhost REGEX[^.*\.localdomain$]"
# Default: ""
#
SkipHosts=""


# Do not include access from clients with a user agent that match following
# criteria. If you want to exclude a robot, you should update the robots.pm
# file instead of this parameter.
# The opposite parameter of "SkipUserAgents" is "OnlyUserAgents".
# Note: Use space between each value. This parameter is not case sensitive.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "konqueror REGEX[ua_test_v\d\.\d]"
# Default: ""
#
SkipUserAgents=""


# Use SkipFiles to ignore access to URLs that match one of following entries.
# You can enter a list of not important URLs (like framed menus, hidden pages,
# etc...) to exclude them from statistics. You must enter here exact relative
# URL as found in log file, or a matching REGEX value. Check apply on URL with
# all its query paramaters.
# For example, to ignore /badpage.php, just add "/badpage.php". To ignore all
# pages in a particular directory, add "REGEX[^\/directorytoexclude]".
# The opposite parameter of "SkipFiles" is "OnlyFiles".
# Note: Use space between each value. This parameter is or not case sensitive
# depending on URLNotCaseSensitive parameter.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "/badpage.php /page.php?param=x REGEX[^\/excludedirectory]"
# Default: ""
#
SkipFiles=""


# Use SkipReferrersBlackList if you want to exclude records coming from a SPAM
# referrer. Parameter must receive a local file name containing rules applied
# on referrer field. If parameter is empty, no filter is applied.
# An example of such a file is available in lib/blacklist.txt
# Change : Effective for new updates only
# Example: "/mylibpath/blacklist.txt"
# Default: ""
#
# WARNING!! Using this feature make AWStats running very slower (5 times slower
# with black list file provided with AWStats !
#
SkipReferrersBlackList=""


# Include in stats, only accesses from hosts that match one of following
# entries. For example, if you want AWStats to filter access to keep only
# stats for visits from particular hosts, you can add those host names in
# this parameter.
# If DNS lookup is already done in your log file, you must enter here hostname
# criteria, else enter ip address criteria.
# The opposite parameter of "OnlyHosts" is "SkipHosts".
# Note: Use space between each value. This parameter is not case sensitive.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "127.0.0.1 REGEX[^192\.168\.] REGEX[^10\.]"
# Default: ""
#
OnlyHosts=""


# Include in stats, only accesses from user agent that match one of following
# entries. For example, if you want AWStats to filter access to keep only
# stats for visits from particular browsers, you can add their user agents
# string in this parameter.
# The opposite parameter of "OnlyUserAgents" is "SkipUserAgents".
# Note: Use space between each value. This parameter is not case sensitive.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "msie"
# Default: ""
#
OnlyUserAgents=""


# Include in stats, only accesses from authenticated users that match one of
# following entries. For example, if you want AWStats to filter access to keep
# only stats for authenticated users, you can add those users names in
# this parameter. Useful for statistics for per user ftp logs.
# Note: Use space between each value. This parameter is not case sensitive.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "john bob REGEX[^testusers]"
# Default: ""
#
OnlyUsers=""


# Include in stats, only accesses to URLs that match one of following entries.
# For example, if you want AWStats to filter access to keep only stats that
# match a particular string, like a particular directory, you can add this
# directory name in this parameter.
# The opposite parameter of "OnlyFiles" is "SkipFiles".
# Note: Use space between each value. This parameter is or not case sensitive
# depending on URLNotCaseSensitive parameter.
# Note: You can use regular expression values writing value with REGEX[value].
# Change : Effective for new updates only
# Example: "REGEX[marketing_directory] REGEX[office\/.*\.(csv|sxw)$]"
# Default: ""
#
OnlyFiles=""


# Add here a list of kind of url (file extension) that must be counted as
# "Hit only" and not as a "Hit" and "Page/Download". You can set here all
# image extensions as they are hit downloaded that must be counted but they
# are not viewed pages. URLs with such extensions are not included in the TOP
# Pages/URL report.
# Note: If you want to exclude particular URLs from stats (No Pages and no
# Hits reported), you must use SkipFiles parameter.
# Change : Effective for new updates only
# Example: "css js class gif jpg jpeg png bmp ico rss xml swf zip arj rar gz z bz2 wav mp3 wma mpg avi"
# Example: ""
# Default: "css js class gif jpg jpeg png bmp ico rss xml swf eot woff woff2"
#
NotPageList="css js class gif jpg jpeg png bmp ico rss xml swf eot woff woff2"


# By default, AWStats considers that records found in web log file are
# successful hits if HTTP code returned by server is a valid HTTP code (200
# and 304). Any other code are reported in HTTP status chart.
# Note that HTTP 'control codes', like redirection (302, 305) are not added by
# default in this list as they are not pages seen by a visitor but are
# protocol exchange codes to tell the browser to ask another page. Because
# this other page will be counted and seen with a 200 or 304 code, if you
# add such codes, you will have 2 pages viewed reported for only one in facts.
# Change : Effective for new updates only
# Example: "200 304 302 305"
# Default: "200 304"
#
ValidHTTPCodes="200 304"


# By default, AWStats considers that records found in mail log file are
# successful mail transfers if field that represent return code in analyzed
# log file match values defined by this parameter.
# Change : Effective for new updates only
# Example: "1 250 200"
# Default: "1 250"
#
ValidSMTPCodes="1 250"


# By default, AWStats only records info on 404 'Document Not Found' errors.
# At the cost of additional processing time, further info pages can be made
# available by adding codes below.
# Change : Effective for new updates only
# Example: "403 404"
# Default: "404"
#
TrapInfosForHTTPErrorCodes = "400 403 404"


# Some web servers on some Operating systems (IIS-Windows) consider that a
# login with same value but different case are the same login. To tell AWStats
# to also consider them as one, set this parameter to 1.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
AuthenticatedUsersNotCaseSensitive=0


# Some web servers on some Operating systems (IIS-Windows) considers that two
# URLs with same value but different case are the same URL. To tell AWStats to
# also considers them as one, set this parameter to 1.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
URLNotCaseSensitive=0


# Keep or remove the anchor string you can find in some URLs.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
URLWithAnchor=0


# In URL links, "?" char is used to add parameter's list in URLs. Syntax is:
# /mypage.html?param1=value1&param2=value2
# However, some servers/sites use also other chars to isolate dynamic part of
# their URLs. You can complete this list with all such characters.
# Change : Effective for new updates only
# Example: "?;,"
# Default: "?;"
#
URLQuerySeparators="?;"


# Keep or remove the query string to the URL in the statistics for individual
# pages. This is primarily used to differentiate between the URLs of dynamic
# pages. If set to 1, mypage.html?id=x and mypage.html?id=y are counted as two
# different pages.
# Warning, when set to 1, memory required to run AWStats is dramatically
# increased if you have a lot of changing URLs (for example URLs with a random
# id inside). Such web sites should not set this option to 1 or use seriously
# the next parameter URLWithQueryWithOnlyFollowingParameters (or eventually
# URLWithQueryWithoutFollowingParameters).
# Change : Effective for new updates only
# Possible values:
# 0 - URLs are cleaned from the query string (ie: "/mypage.html")
# 1 - Full URL with query string is used     (ie: "/mypage.html?p=x&q=y")
# Default: 0
#
URLWithQuery=0


# When URLWithQuery is on, you will get the full URL with all parameters in
# URL reports. But among thoose parameters, sometimes you don't need a
# particular parameter because it does not identify the page or because it's
# a random ID changing for each access even if URL points to same page. In
# such cases, it is higly recommanded to ask AWStats to keep only parameters
# you need (if you know them) before counting, manipulating and storing URL.
# Enter here list of wanted parameters. For example, with "param", one hit on
# /mypage.cgi?param=abc&id=Yo4UomP9d  and  /mypage.cgi?param=abc&id=Mu8fdxl3r
# will be reported as 2 hits on /mypage.cgi?param=abc
# This parameter is not used when URLWithQuery is 0 and can't be used with
# URLWithQueryWithoutFollowingParameters.
# Change : Effective for new updates only
# Example: "param"
# Default: ""
#
URLWithQueryWithOnlyFollowingParameters=""


# When URLWithQuery is on, you will get the full URL with all parameters in
# URL reports. But among thoose parameters, sometimes you don't need a
# particular parameter because it does not identify the page or because it's
# a random ID changing for each access even if URL points to same page. In
# such cases, it is higly recommanded to ask AWStats to remove such parameters
# from the URL before counting, manipulating and storing URL. Enter here list
# of all non wanted parameters. For example if you enter "id", one hit on
# /mypage.cgi?param=abc&id=Yo4UomP9d  and  /mypage.cgi?param=abc&id=Mu8fdxl3r
# will be reported as 2 hits on /mypage.cgi?param=abc
# This parameter is not used when URLWithQuery is 0 and can't be used with
# URLWithQueryWithOnlyFollowingParameters.
# Change : Effective for new updates only
# Example: "PHPSESSID jsessionid"
# Default: ""
#
URLWithQueryWithoutFollowingParameters=""


# Keep or remove the query string to the referrer URL in the statistics for
# external referrer pages. This is used to differentiate between the URLs of
# dynamic referrer pages. If set to 1, mypage.html?id=x and mypage.html?id=y
# are counted as two different referrer pages.
# Change : Effective for new updates only
# Possible values:
# 0 - Referrer URLs are cleaned from the query string (ie: "/mypage.html")
# 1 - Full URL with query string is used      (ie: "/mypage.html?p=x&q=y")
# Default: 0
#
URLReferrerWithQuery=0


# AWStats can detect setup problems or show you important informations to have
# a better use. Keep this to 1, except if AWStats says you can change it.
# Change : Effective immediately
# Possible values: 0 or 1
# Default: 1
#
WarningMessages=1


# When an error occurs, AWStats outputs a message related to errors. If you
# want (in most cases for security reasons) to have no error messages, you
# can set this parameter to your personalized generic message.
# Change : Effective immediately
# Example: "An error occurred. Contact your Administrator"
# Default: ""
#
ErrorMessages=""


# AWStat can be run with debug=x parameter to output various informations
# to help in debugging or solving troubles. If you want to allow this (not
# enabled by default for security reasons), set this parameter to 0.
# Change : Effective immediately
# Possible values: 0 or 1
# Default: 0
#
DebugMessages=0


# To help you to detect if your log format is good, AWStats reports an error
# if all the first NbOfLinesForCorruptedLog lines have a format that does not
# match the LogFormat parameter.
# However, some worm virus attack on your web server can result in a very high
# number of corrupted lines in your log. So if you experience awstats stop
# because of bad virus records at the beginning of your log file, you can
# increase this parameter (very rare).
# Change : Effective for new updates only
# Default: 50
#
NbOfLinesForCorruptedLog=50


# For some particular integration needs, you may want to have CGI links to
# point to another script than awstats.pl.
# Use the name of this script in WrapperScript parameter.
# Change : Effective immediately
# Example: "awstatslauncher.pl"
# Example: "awstatswrapper.cgi?key=123"
# Default: ""
#
WrapperScript=""


# DecodeUA must be set to 1 if you use Roxen web server. This server converts
# all spaces in user agent field into %20. This make the AWStats robots, OS
# and browsers detection fail in some cases. Just change it to 1 if and only
# if your web server is Roxen.
# Change : Effective for new updates only
# Possible values: 0 or 1
# Default: 0
#
DecodeUA=0


# MiscTrackerUrl can be used to make AWStats able to detect some miscellaneous
# things, that can not be tracked on other way, like:
# - Javascript disabled
# - Java enabled
# - Screen size
# - Color depth
# - Macromedia Director plugin
# - Macromedia Shockwave plugin
# - Realplayer G2 plugin
# - QuickTime plugin
# - Mediaplayer plugin
# - Acrobat PDF plugin
# To enable all these features, you must copy the awstats_misc_tracker.js file
# into a /js/ directory stored in your web document root and add the following
# HTML code at the end of your index page (but before </BODY>) :
#
# <script type="text/javascript" src="/js/awstats_misc_tracker.js"></script>
# <noscript><img src="/js/awstats_misc_tracker.js?nojs=y" height=0 width=0 border=0 style="display: none"></noscript>
#
# If code is not added in index page, all those detection capabilities will be
# disabled. You must also check that ShowScreenSizeStats and ShowMiscStats
# parameters are set to 1 to make results appear in AWStats report page.
# If you want to use another directory than /js/, you must also change the
# awstatsmisctrackerurl variable into the awstats_misc_tracker.js file.
# Change : Effective for new updates only.
# Possible value: URL of javascript tracker file added in your HTML code.
# Default: "/js/awstats_misc_tracker.js"
#
MiscTrackerUrl="/js/awstats_misc_tracker.js"


# AddLinkToExternalCGIWrapper can be used to add a link to a wrapper script
# into each title of Dolibarr reports. This can be used to add a wrapper
# to download data into a CSV file for example.
#
# AddLinkToExternalCGIWrapper="/awstats/awdownloadcsv.pl"



#-----------------------------------------------------------------------------
# OPTIONAL ACCURACY SETUP SECTION (Not required but increase AWStats features)
#-----------------------------------------------------------------------------

# The following values allow you to define accuracy of AWStats entities
# (robots, browsers, os, referers, file types) detection.
# It might be a good idea for large web sites or ISP that provides AWStats to
# high number of customers, to set this parameter to 1 (or 0), instead of 2.
# Possible values:
#    0      = No detection,
#    1      = Medium/Standard detection
#    2      = Full detection
# Change : Effective for new updates only
# Note   : LevelForBrowsersDetection can also accept value "allphones". This
#          enable detailed detection of phone/pda browsers.
# Default: 2 (0 for LevelForWormsDetection)
#
LevelForBrowsersDetection=2         # 0 disables Browsers detection.
                                    # 2 reduces AWStats speed by 2%
                                    # allphones reduces AWStats speed by 5%
LevelForOSDetection=2               # 0 disables OS detection.
                                    # 2 reduces AWStats speed by 3%
LevelForRefererAnalyze=2            # 0 disables Origin detection.
                                    # 2 reduces AWStats speed by 14%
LevelForRobotsDetection=2           # 0 disables Robots detection.
                                    # 2 reduces AWStats speed by 2.5%
LevelForSearchEnginesDetection=2    # 0 disables Search engines detection.
                                    # 2 reduces AWStats speed by 9%
LevelForKeywordsDetection=2         # 0 disables Keyphrases/Keywords detection.
                                    # 2 reduces AWStats speed by 1%
LevelForFileTypesDetection=2        # 0 disables File types detection.
                                    # 2 reduces AWStats speed by 1%
LevelForWormsDetection=0            # 0 disables Worms detection.
                                    # 2 reduces AWStats speed by 15%



#-----------------------------------------------------------------------------
# OPTIONAL APPEARANCE SETUP SECTION (Not required but increase AWStats features)
#-----------------------------------------------------------------------------

# When you use AWStats as a CGI, you can have the reports shown in HTML frames.
# Frames are only available for report viewed dynamically. When you build
# pages from command line, this option is not used and no frames are built.
# Possible values: 0 or 1
# Default: 1
#
UseFramesWhenCGI=1


# This parameter asks your browser to open detailed reports into a different
# window than the main page.
# Possible values:
# 0 - Open all in same browser window
# 1 - Open detailed reports in another window except if using frames
# 2 - Open always in a different window even if reports are framed
# Default: 1
#
DetailedReportsOnNewWindows=1


# You can add, in the HTML report page, a cache lifetime (in seconds) that
# will be returned to the browser in HTTP header answer by server.
# This parameter is not used when reports are built with -staticlinks option.
# Example: 3600
# Default: 0
#
Expires=0


# To avoid too large web pages, you can ask AWStats to limit number of rows of
# all reported charts to this number when no other limits apply.
# Default: 10000
#
MaxRowsInHTMLOutput=10000


# Set your primary language (ISO-639-1 language codes).
# Possible values:
#  Albanian=al, Bosnian=ba, Bulgarian=bg, Catalan=ca,
#  Chinese (Taiwan)=tw, Chinese (Simpliefied)=cn, Croatian=hr, Czech=cz,
#  Danish=dk, Dutch=nl, English=en, Estonian=et, Euskara=eu, Finnish=fi,
#  French=fr, Galician=gl, German=de, Greek=gr, Hebrew=he, Hungarian=hu,
#  Icelandic=is, Indonesian=id, Italian=it, Japanese=jp, Korean=ko,
#  Latvian=lv, Norwegian (Nynorsk)=nn, Norwegian (Bokmal)=nb, Polish=pl,
#  Portuguese=pt, Portuguese (Brazilian)=br, Romanian=ro, Russian=ru,
#  Serbian=sr, Slovak=sk, Slovenian=si, Spanish=es, Swedish=se, Turkish=tr,
#  Ukrainian=ua, Welsh=cy.
#  First available language accepted by browser=auto
# Default: "auto"
#
Lang="auto"


# Set the location of language files.
# Example: "/usr/share/awstats/lang"
# Default: "./lang" (means lang directory is in same location than awstats.pl)
#
DirLang="./lang"


# Show menu header with reports' links
# Possible values: 0 or 1
# Default: 1
#
ShowMenu=1


# You choose here which reports you want to see in the main page and what you
# want to see in those reports.
# Possible values:
#  0  - Report is not shown at all
#  1  - Report is shown in main page with an entry in menu and default columns
# XYZ - Report shows column informations defined by code X,Y,Z...
#       X,Y,Z... are code letters among the following:
#        U = Unique visitors
#        V = Visits
#        P = Number of pages
#        H = Number of hits (or mails)
#        B = Bandwidth (or total mail size for mail logs)
#        L = Last access date
#        E = Entry pages
#        X = Exit pages
#        C = Web compression (mod_gzip,mod_deflate)
#        M = Average mail size (mail logs)
#

# Show monthly summary
# Context: Web, Streaming, Mail, Ftp
# Default: UVPHB, Possible column codes: UVPHB
ShowSummary=UVPHB

# Show monthly chart
# Context: Web, Streaming, Mail, Ftp
# Default: UVPHB, Possible column codes: UVPHB
ShowMonthStats=UVPHB

# Show days of month chart
# Context: Web, Streaming, Mail, Ftp
# Default: VPHB, Possible column codes: VPHB
ShowDaysOfMonthStats=VPHB

# Show days of week chart
# Context: Web, Streaming, Mail, Ftp
# Default: PHB, Possible column codes: PHB
ShowDaysOfWeekStats=PHB

# Show hourly chart
# Context: Web, Streaming, Mail, Ftp
# Default: PHB, Possible column codes: PHB
ShowHoursStats=PHB

# Show domains/country chart
# Context: Web, Streaming, Mail, Ftp
# Default: PHB, Possible column codes: UVPHB
ShowDomainsStats=PHB

# Show hosts chart
# Context: Web, Streaming, Mail, Ftp
# Default: PHBL, Possible column codes: PHBL
ShowHostsStats=PHBL

# Show authenticated users chart
# Context: Web, Streaming, Ftp
# Default: 0, Possible column codes: PHBL
ShowAuthenticatedUsers=0

# Show robots chart
# Context: Web, Streaming
# Default: HBL, Possible column codes: HBL
ShowRobotsStats=HBL

# Show worms chart
# Context: Web, Streaming
# Default: 0 (If set to other than 0, see also LevelForWormsDetection), Possible column codes: HBL
ShowWormsStats=0

# Show email senders chart (For use when analyzing mail log files)
# Context: Mail
# Default: 0, Possible column codes: HBML
ShowEMailSenders=0

# Show email receivers chart (For use when analyzing mail log files)
# Context: Mail
# Default: 0, Possible column codes: HBML
ShowEMailReceivers=0

# Show session chart
# Context: Web, Streaming, Ftp
# Default: 1, Possible column codes: None
ShowSessionsStats=1

# Show pages-url chart.
# Context: Web, Streaming, Ftp
# Default: PBEX, Possible column codes: PBEX
ShowPagesStats=PBEX

# Show file types chart.
# Context: Web, Streaming, Ftp
# Default: HB, Possible column codes: HBC
ShowFileTypesStats=HB

# Show file size chart (Not yet available)
# Context: Web, Streaming, Mail, Ftp
# Default: 1, Possible column codes: None
ShowFileSizesStats=0

# Show downloads chart.
# Context: Web, Streaming, Ftp
# Default: HB, Possible column codes: HB
ShowDownloadsStats=HB

# Show operating systems chart
# Context: Web, Streaming, Ftp
# Default: 1, Possible column codes: None
ShowOSStats=1

# Show browsers chart
# Context: Web, Streaming
# Default: 1, Possible column codes: None
ShowBrowsersStats=1

# Show screen size chart
# Context: Web, Streaming
# Default: 0 (If set to 1, see also MiscTrackerUrl), Possible column codes: None
ShowScreenSizeStats=0

# Show origin chart
# Context: Web, Streaming
# Default: PH, Possible column codes: PH
ShowOriginStats=PH

# Show keyphrases chart
# Context: Web, Streaming
# Default: 1, Possible column codes: None
ShowKeyphrasesStats=1

# Show keywords chart
# Context: Web, Streaming
# Default: 1, Possible column codes: None
ShowKeywordsStats=1

# Show misc chart
# Context: Web, Streaming
# Default: a (See also MiscTrackerUrl parameter), Possible column codes: anjdfrqwp
ShowMiscStats=a

# Show http errors chart
# Context: Web, Streaming
# Default: 1, Possible column codes: None
ShowHTTPErrorsStats=1

# Show http error page details
# Context: Web, Streaming
# Default: R, Possible column codes: RH
ShowHTTPErrorsPageDetail=R

# Show smtp errors chart (For use when analyzing mail log files)
# Context: Mail
# Default: 0, Possible column codes: None
ShowSMTPErrorsStats=0

# Show the cluster report (Your LogFormat must contains the %cluster tag)
# Context: Web, Streaming, Ftp
# Default: 0, Possible column codes: PHB
ShowClusterStats=0


# Some graphical reports are followed by the data array of values.
# If you don't want this array (to reduce the report size for example), you
# can set thoose options to 0.
# Possible values: 0 or 1
# Default: 1
#
# Data array values for the ShowMonthStats report
AddDataArrayMonthStats=1
# Data array values for the ShowDaysOfMonthStats report
AddDataArrayShowDaysOfMonthStats=1
# Data array values for the ShowDaysOfWeekStats report
AddDataArrayShowDaysOfWeekStats=1
# Data array values for the ShowHoursStats report
AddDataArrayShowHoursStats=1


# In the Origin chart, you have stats on where your hits came from. You can
# include hits on pages that come from pages of same sites in this chart.
# Possible values: 0 or 1
# Default: 0
#
IncludeInternalLinksInOriginSection=0


# The following parameters can be used to choose the maximum number of lines
# shown for the particular following reports.
#
# Stats by countries/domains
MaxNbOfDomain = 10
MinHitDomain  = 1
# Stats by hosts
MaxNbOfHostsShown = 10
MinHitHost    = 1
# Stats by authenticated users
MaxNbOfLoginShown = 10
MinHitLogin   = 1
# Stats by robots
MaxNbOfRobotShown = 10
MinHitRobot   = 1
# Stats for Downloads
MaxNbOfDownloadsShown = 10
MinHitDownloads = 1
# Stats by pages
MaxNbOfPageShown = 10
MinHitFile    = 1
# Stats by OS
MaxNbOfOsShown = 10
MinHitOs      = 1
# Stats by browsers
MaxNbOfBrowsersShown = 10
MinHitBrowser = 1
# Stats by screen size
MaxNbOfScreenSizesShown = 5
MinHitScreenSize = 1
# Stats by window size (following 2 parameters are not yet used)
MaxNbOfWindowSizesShown = 5
MinHitWindowSize = 1
# Stats by referers
MaxNbOfRefererShown = 10
MinHitRefer   = 1
# Stats for keyphrases
MaxNbOfKeyphrasesShown = 10
MinHitKeyphrase = 1
# Stats for keywords
MaxNbOfKeywordsShown = 10
MinHitKeyword = 1
# Stats for sender or receiver emails
MaxNbOfEMailsShown = 20
MinHitEMail   = 1


# Choose if you want the week report to start on sunday or monday
# Possible values:
# 0 - Week starts on sunday
# 1 - Week starts on monday
# Default: 1
#
FirstDayOfWeek=1


# List of visible flags that link to other language translations.
# See Lang parameter for list of allowed flag/language codes.
# If you don't want any flag link, set ShowFlagLinks to "".
# This parameter is used only if ShowMenu parameter is set to 1.
# Possible values: "" or "language_codes_separated_by_space"
# Example: "en es fr nl de"
# Default: ""
#
ShowFlagLinks=""


# Each URL, shown in stats report views, are links you can click.
# Possible values: 0 or 1
# Default: 1
#
ShowLinksOnUrl=1


# When AWStats builds HTML links in its report pages, it starts those links
# with "http://". However some links might be HTTPS links, so you can enter
# here the root of all your HTTPS links. If all your site is a SSL web site,
# just enter "/".
# This parameter is not used if ShowLinksOnUrl is 0.
# Example: "/shopping"
# Example: "/"
# Default: ""
#
UseHTTPSLinkForUrl=""


# Maximum length of URL part shown on stats page (number of characters).
# This affects only URL visible text, links still work.
# Default: 64
#
MaxLengthOfShownURL=64


# You can enter HTML code that will be added at the top of AWStats reports.
# Default: ""
#
HTMLHeadSection=""


# You can enter HTML code that will be added at the end of AWStats reports.
# Great to add advert ban.
# Default: ""
#
HTMLEndSection=""


# By default AWStats page contains meta tag robots=noindex,nofollow
# If you want to have your statistics to be indexed, set this option to 1.
# Default: 0
#
MetaRobot=0


# You can set Logo and LogoLink to use your own logo.
# Logo must be the name of image file (must be in \$DirIcons/other directory).
# LogoLink is the expected URL when clicking on Logo.
# Default: "awstats_logo6.png"
#
Logo="awstats_logo6.png"
LogoLink="http://www.awstats.org"


# Value of maximum bar width/height for horizontal/vertical HTML graphics bars.
# Default: 260/90
#
BarWidth   = 260
BarHeight  = 90


# You can ask AWStats to use a particular CSS (Cascading Style Sheet) to
# change its look. To create a style sheet, you can use samples provided with
# AWStats in wwwroot/css directory.
# Example: "/awstatscss/awstats_bw.css"
# Example: "/css/awstats_bw.css"
# Default: ""
#
StyleSheet=""


# Those color parameters can be used (if StyleSheet parameter is not used)
# to change AWStats look.
# Example: color_name="RRGGBB"	# RRGGBB is Red Green Blue components in Hex
#
color_Background="FFFFFF"		# Background color for main page (Default = "FFFFFF")
color_TableBGTitle="CCCCDD"		# Background color for table title (Default = "CCCCDD")
color_TableTitle="000000"		# Table title font color (Default = "000000")
color_TableBG="CCCCDD"			# Background color for table (Default = "CCCCDD")
color_TableRowTitle="FFFFFF"	# Table row title font color (Default = "FFFFFF")
color_TableBGRowTitle="ECECEC"	# Background color for row title (Default = "ECECEC")
color_TableBorder="ECECEC"		# Table border color (Default = "ECECEC")
color_text="000000"				# Color of text (Default = "000000")
color_textpercent="606060"		# Color of text for percent values (Default = "606060")
color_titletext="000000"		# Color of text title within colored Title Rows (Default = "000000")
color_weekend="EAEAEA"			# Color for week-end days (Default = "EAEAEA")
color_link="0011BB"				# Color of HTML links (Default = "0011BB")
color_hover="605040"			# Color of HTML on-mouseover links (Default = "605040")
color_u="FFAA66"				# Background color for number of unique visitors (Default = "FFAA66")
color_v="F4F090"				# Background color for number of visites (Default = "F4F090")
color_p="4477DD"				# Background color for number of pages (Default = "4477DD")
color_h="66DDEE"				# Background color for number of hits (Default = "66DDEE")
color_k="2EA495"				# Background color for number of bytes (Default = "2EA495")
color_s="8888DD"				# Background color for number of search (Default = "8888DD")
color_e="CEC2E8"				# Background color for number of entry pages (Default = "CEC2E8")
color_x="C1B2E2"				# Background color for number of exit pages (Default = "C1B2E2")



#-----------------------------------------------------------------------------
# PLUGINS
#-----------------------------------------------------------------------------

# Add here all plugin files you want to load.
# Plugin files must be .pm files stored in 'plugins' directory.
# Uncomment LoadPlugin lines to enable a plugin after checking that perl
# modules required by the plugin are installed.

# PLUGIN: Tooltips
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: Add tooltips pop-up help boxes to HTML report pages.
# NOTE: This will increased HTML report pages size, thus server load and bandwidth.
#
#LoadPlugin="tooltips"

# PLUGIN: DecodeUTFKeys
# REQUIRED MODULES: Encode and URI::Escape
# PARAMETERS: None
# DESCRIPTION: Allow AWStats to show correctly (in language charset)
# keywords/keyphrases strings even if they were UTF8 coded by the
# referer search engine.
#
#LoadPlugin="decodeutfkeys"

# PLUGIN: IPv6
# PARAMETERS: None
# REQUIRED MODULES: Net::IP and Net::DNS
# DESCRIPTION: This plugin gives AWStats capability to make reverse DNS
# lookup on IPv6 addresses.
#
#LoadPlugin="ipv6"

# PLUGIN: HashFiles
# REQUIRED MODULES: Storable
# PARAMETERS: None
# DESCRIPTION: AWStats DNS cache files are read/saved as native hash files.
# This increases DNS cache files loading speed, above all for very large web sites.
#
#LoadPlugin="hashfiles"


# PLUGIN: UserInfo
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: Add a text (Firtname, Lastname, Office Department, ...) in
# authenticated user reports for each login value.
# A text file called userinfo.myconfig.txt, with two fields (first is login,
# second is text to show, separated by a tab char) must be created in DirData
# directory.
#
#LoadPlugin="userinfo"

# PLUGIN: HostInfo
# REQUIRED MODULES: Net::XWhois
# PARAMETERS: None
# DESCRIPTION: Add a column into host chart with a link to open a popup window that shows
# info on host (like whois records).
#
#LoadPlugin="hostinfo"

# PLUGIN: ClusterInfo
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: Add a text (for example a full hostname) in cluster reports for each cluster
# number. A text file called clusterinfo.myconfig.txt, with two fields (first is
# cluster number, second is text to show) separated by a tab char. must be
# created into DirData directory.
# Note this plugin is useless if ShowClusterStats is set to 0 or if you don't
# use a personalized log format that contains %cluster tag.
#
#LoadPlugin="clusterinfo"

# PLUGIN: UrlAliases
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: Add a text (Page title, description...) in URL reports before URL value.
# A text file called urlalias.myconfig.txt, with two fields (first is URL,
# second is text to show, separated by a tab char) must be created into
# DirData directory.
#
#LoadPlugin="urlalias"

# PLUGIN: TimeHiRes
# REQUIRED MODULES: Time::HiRes (if Perl < 5.8)
# PARAMETERS: None
# DESCRIPTION: Time reported by -showsteps option is in millisecond. For debug purpose.
#
#LoadPlugin="timehires"

# PLUGIN: TimeZone
# REQUIRED MODULES: Time::Local
# PARAMETERS: [timezone offset]
# DESCRIPTION: Allow AWStats to adjust time stamps for a different timezone
# This plugin reduces AWStats speed of 10% !!!!!!!
# LoadPlugin="timezone"
# LoadPlugin="timezone +2"
# LoadPlugin="timezone CET"
#
#LoadPlugin="timezone +2"

# PLUGIN: Rawlog
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: This plugin adds a form in AWStats main page to allow users to see raw
# content of current log files. A filter is also available.
#
#LoadPlugin="rawlog"

# PLUGIN: GraphApplet
# REQUIRED MODULES: None
# PARAMETERS: [CSS classes to override]
# DESCRIPTION: Supported charts are built by a 3D graphic applet.
#
#LoadPlugin="graphapplet /awstatsclasses"				# EXPERIMENTAL FEATURE

# PLUGIN: GraphGoogleChartAPI
# REQUIRED MODULES: None
# PARAMETERS: None
# DESCRIPTION: Replaces the standard charts with free Google API generated images
# in HTML reports. If country data is available and more than one country has hits,
# a map will be generated using Google Visualizations.
# Note: The machine where reports are displayed must have Internet access for the
# charts to be generated. The only data sent to Google includes the statistic numbers,
# legend names and country names.
# Warning: This plugin is not compatible with option BuildReportFormat=xhtml.
#
#LoadPlugin="graphgooglechartapi"

# PLUGIN: GeoIPfree
# REQUIRED MODULES: Geo::IPfree version 0.2+ (from Graciliano M.P.)
# PARAMETERS: None
# DESCRIPTION: Country chart is built from an Internet IP-Country database.
# This plugin is useless for intranet only log files.
# Note: You must choose between using this plugin (need Perl Geo::IPfree
# module, database is free but not up to date) or the GeoIP plugin (need
# Perl Geo::IP module from Maxmind, database is also free and up to date).
# Note: Activestate provide a corrupted version of Geo::IPfree 0.2 Perl
# module, so install it from elsewhere (from www.cpan.org for example).
# This plugin reduces AWStats speed by up to 10% !
#
#LoadPlugin="geoipfree"

# MAXMIND GEO IP MODULES: Please see documentation for notes on all Maxmind modules

# PLUGIN: GeoIP
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/geoip.dat[+/pathto/override.txt]]
# DESCRIPTION: Builds a country chart and adds an entry to the hosts
# table with country name
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip GEOIP_STANDARD /pathto/GeoIP.dat"

# PLUGIN: GeoIP6
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind, version >= 1.40)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/geoipv6.dat[+/pathto/override.txt]]
# DESCRIPTION: Builds a country chart and adds an entry to the hosts
# table with country name
# works with IPv4 and also IPv6 addresses
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip6 GEOIP_STANDARD /pathto/GeoIPv6.dat"

# PLUGIN: GeoIP_City_Maxmind
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/GeoIPCity.dat[+/pathto/override.txt]]
# DESCRIPTION: This plugin adds a column under the hosts field and tracks the pageviews
# and hits by city including regions.
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /pathto/GeoIPCity.dat"

# PLUGIN: GeoIP_ASN_Maxmind
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/GeoIPASN.dat[+/pathto/override.txt][+http://linktoASlookup]]
# DESCRIPTION: This plugin adds a chart of AS numbers where the host IP address is registered.
# This plugin can display some ISP information if included in the database. You can also provide
# a link that will be used to lookup additional registration data. Put the link at the end of
# the parameter string and the report page will include the link with the full AS number at the end.
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip_asn_maxmind GEOIP_STANDARD /usr/local/geoip.dat+http://enc.com.au/itools/autnum.php?asn="

# PLUGIN: GeoIP_Region_Maxmind
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/GeoIPRegion.dat[+/pathto/override.txt]]
# DESCRIPTION:This plugin adds a chart of hits by regions. Only regions for US and
# Canada can be detected.
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip_region_maxmind GEOIP_STANDARD /pathto/GeoIPRegion.dat"

# PLUGIN: GeoIP_ISP_Maxmind
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/GeoIPISP.dat[+/pathto/override.txt]]
# DESCRIPTION: This plugin adds a chart of hits by ISP.
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip_isp_maxmind GEOIP_STANDARD /pathto/GeoIPISP.dat"

# PLUGIN: GeoIP_Org_Maxmind
# REQUIRED MODULES: Geo::IP or Geo::IP::PurePerl (from Maxmind)
# PARAMETERS: [GEOIP_STANDARD | GEOIP_MEMORY_CACHE] [/pathto/GeoIPOrg.dat[+/pathto/override.txt]]
# DESCRIPTION: This plugin add a chart of hits by Organization name
# Replace spaces in the path of geoip data file with string "%20".
#
#LoadPlugin="geoip_org_maxmind GEOIP_STANDARD /pathto/GeoIPOrg.dat"


#-----------------------------------------------------------------------------
# EXTRA SECTIONS
#-----------------------------------------------------------------------------

# You can define your own charts, you choose here what are rows and columns
# keys. This feature is particularly useful for marketing purpose, tracking
# products orders for example.
# For this, edit all parameters of Extra section. Each set of parameter is a
# different chart. For several charts, duplicate section changing the number.
# Note: Each Extra section reduces AWStats speed by 8%.
#
# WARNING: A wrong setup of Extra section might result in too large arrays
# that will consume all your memory, making AWStats unusable after several
# updates, so be sure to setup it correctly.
# In most cases, you don't need this feature.
#
# ExtraSectionNameX is title of your personalized chart.
# ExtraSectionCodeFilterX is list of codes the record code field must match.
#   Put an empty string for no test on code.
# ExtraSectionConditionX are conditions you can use to count or not the hit,
#   Use one of the field condition
#   (URL,URLWITHQUERY,QUERY_STRING,REFERER,UA,HOSTINLOG,HOST,VHOST,extraX)
#   and a regex to match, after a coma. Use "||" for "OR".
# ExtraSectionFirstColumnTitleX is the first column title of the chart.
# ExtraSectionFirstColumnValuesX is a string to tell AWStats which field to
#   extract value from
#   (URL,URLWITHQUERY,QUERY_STRING,REFERER,UA,HOSTINLOG,HOST,VHOST,extraX)
#   and how to extract the value (using regex syntax). Each different value
#   found will appear in first column of report on a different row. Be sure
#   that list of different possible values will not grow indefinitely.
# ExtraSectionFirstColumnFormatX is the string used to write value.
# ExtraSectionStatTypesX are things you want to count. You can use standard
#   code letters (P for pages,H for hits,B for bandwidth,L for last access).
# ExtraSectionAddAverageRowX add a row at bottom of chart with average values.
# ExtraSectionAddSumRowX add a row at bottom of chart with sum values.
# MaxNbOfExtraX is maximum number of rows shown in chart.
# MinHitExtraX is minimum number of hits required to be shown in chart.
#

# Example to report the 20 products the most ordered by "order.cgi" script
#ExtraSectionName1="Product orders"
#ExtraSectionCodeFilter1="200 304"
#ExtraSectionCondition1="URL,\/cgi\-bin\/order\.cgi||URL,\/cgi\-bin\/order2\.cgi"
#ExtraSectionFirstColumnTitle1="Product ID"
#ExtraSectionFirstColumnValues1="QUERY_STRING,productid=([^&]+)"
#ExtraSectionFirstColumnFormat1="%s"
#ExtraSectionStatTypes1=PL
#ExtraSectionAddAverageRow1=0
#ExtraSectionAddSumRow1=1
#MaxNbOfExtra1=20
#MinHitExtra1=1


# There is also a global parameter ExtraTrackedRowsLimit that limits the
# number of possible rows an ExtraSection can report. This parameter is
# here to protect too much memory use when you make a bad setup in your
# ExtraSection. It applies to all ExtraSection independently meaning that
# none ExtraSection can report more rows than value defined by ExtraTrackedRowsLimit.
# If you know an ExtraSection will report more rows than its value, you should
# increase this parameter or AWStats will stop with an error.
# Example: 2000
# Default: 500
#
ExtraTrackedRowsLimit=500


#-----------------------------------------------------------------------------
# INCLUDES
#-----------------------------------------------------------------------------

# You can include other config files using the directive with the name of the
# config file.
# This is particularly useful for users who have a lot of virtual servers, so
# a lot of config files and want to maintain common values in only one file.
# Note that when a variable is defined both in a config file and in an
# included file, AWStats will use the last value read for parameters that
# contains one value and AWStats will concat all values from both files for
# parameters that are lists of values.
#

#Include ""

HERE
