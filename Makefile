build: rsync.md
	pandoc -t man rsync.md -s > rsync.1
	sed -i '1s/^/.ad l\n/' rsync.1
show: build
	man ./rsync.1

