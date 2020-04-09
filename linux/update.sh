cd /tmp
rm -rf fractal-protocol 2> /dev/null
mkdir fractal-protocol
cd fractal-protocol

wget -O version https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/version

if cmp -s version "/usr/share/fractal/version"
then
	:
else
	mv -f version "/usr/share/fractal/"
	wget -O FractalServer https://fractal-cloud-setup-s3bucket.s3.amazonaws.com/FractalServer

	if cmp -s FractalServer "/usr/share/fractal/FractalServer"
	then
		:
	else
		immortalctl -k Fractal
		killall FractalServer
		mv -f FractalServer "/usr/share/fractal/"
        immortal /usr/share/fractal/./FractalServer Fractal
	fi
fi

cd /usr/share/fractal
