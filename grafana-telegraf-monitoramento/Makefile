stress-cpu:
	stress-ng -c 0 -l 95

create-big-file:
	dd if=/dev/zero of=arquivo.img bs=1M count=3000

stress-ram:
	stress-ng --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1
