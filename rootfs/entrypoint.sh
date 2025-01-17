#!/bin/bash

umount /sys/fs/cgroup
mount -t cgroup2 -o rw,relatime,nsdelegate,memory_recursiveprot cgroup2 /sys/fs/cgroup

exec "$@"
