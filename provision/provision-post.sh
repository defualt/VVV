# Network Detection
#
# Make an HTTP request to google.com to determine if outside access is available
# to us. If 3 attempts with a timeout of 5 seconds are not successful, then we'll
# skip a few things further in provisioning rather than create a bunch of errors.
if [[ "$(wget --tries=3 --timeout=5 --spider http://google.com 2>&1 | grep 'connected')" ]]; then
	echo "Network connection detected..."
	ping_result="Connected"
else
	echo "Network connection not detected. Unable to reach google.com..."
	ping_result="Not Connected"
fi

if [[ $ping_result == "Connected" ]]; then

	# wordmove
	#
	# This is for deployment.
	if [[ -f /usr/bin/wordmove ]]; then
		echo "wordmove already installed"
	else
		echo "Installing wordmove"
		apt-get install -y ruby-dev
		gem install rubygems-update
		update_rubygems
		gem install wordmove
	fi

	# sshpass
	#
	# This is a dependency for wordmove
	if [[ -f /usr/bin/sshpass ]]; then
		echo "sshpass already installed"
	else
		echo "Installing sshpass"
		apt-get install sshpass
	fi

	# lftp
	#
	# This is a dependency for wordmove
	if [[ -f /usr/bin/lftp ]]; then
		echo "lftp already installed"
	else
		echo "Installing lftp"
		apt-get install lftp
	fi

	# lftp
	#
	# This makes a setting for lftp
	if grep -q "set ssl:verify-certificate no" /etc/lftp.conf ; then
		echo "/etc/lftp.conf all set"
	else
		echo "append to /etc/lftp.conf ... set ssl:verify-certificate no"
		echo 'set ssl:verify-certificate no' | tee --append /etc/lftp.conf
	fi

	# vvv Dashboard
	#
	# Nice dashboard for vvv
	if [ -f /srv/www/default/dashboard-custom.php ]; then
	    echo "HAS VVV-DASHBOARD ALREADY"
	else
		git clone https://github.com/leogopal/VVV-Dashboard.git /srv/www/default/VVV-Dash-Files-tmp
		mv /srv/www/default/VVV-Dash-Files-tmp/dashboard /srv/www/default/dashboard/
		mv /srv/www/default/VVV-Dash-Files-tmp/dashboard-custom.php /srv/www/default/dashboard-custom.php
		rm -rf /srv/www/default/VVV-Dash-Files-tmp
		echo "VVV-DASHBOARD INSTALLED"
	fi
else
	echo -e "\nNo network available, skipping network installations"
fi