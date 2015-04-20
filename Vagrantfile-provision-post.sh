if [[ -f /usr/local/bin/vv ]]; then
	echo "vv already installed"
else
	echo "Installing vv"
	rm -rf /usr/local/bin/vv-temp
	rm /usr/local/bin/vv
	git clone https://github.com/bradp/vv.git /usr/local/bin/vv-temp
	mv /usr/local/bin/vv-temp/vv /usr/local/bin/vv
	sudo chmod +x /usr/local/bin/vv
	rm -rf /usr/local/bin/vv-temp
fi
echo -e '{\n        "path":"'$PWD'"\n}' > ~/.vv-config