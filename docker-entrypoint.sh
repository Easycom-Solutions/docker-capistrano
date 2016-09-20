#!/bin/bash

if [[ ! -z $DEFAULT_USERNAME && ! -z $DEFAULT_UID ]]; then
	if [[ -z $DEFAULT_GROUPNAME ]]; then
		DEFAULT_GROUPNAME=$DEFAULT_USERNAME
	fi
	if [[ -z $DEFAULT_GID ]]; then
		DEFAULT_GID=$DEFAULT_UID
	fi

	# If accesses does not match
	# nb lines <= 0
	if [[ `grep $DEFAULT_USERNAME:x:$DEFAULT_UID:$DEFAULT_GID: /etc/passwd | wc -l` -le 0 ]]; then
		# Edit or create group
		if [[ `getent group $DEFAULT_GROUPNAME | wc -l` -le 0 || `getent group $DEFAULT_GID | wc -l` -le 0 ]]; then
			if [[ `getent group $DEFAULT_GROUPNAME | wc -l` -gt 0 ]]; then
				groupmod -g $DEFAULT_GID $DEFAULT_GROUPNAME
			elif [[ `getent group $DEFAULT_GID | wc -l` -gt 0 ]]; then
				groupmod -n $DEFAULT_GROUPNAME `getent group $DEFAULT_GID | cut -d: -f1`
			else
				groupadd -g $DEFAULT_GID $DEFAULT_GROUPNAME
			fi
		fi

		# Edit or create user
		if [[ `getent passwd $DEFAULT_USERNAME | wc -l` -le 0 || `getent passwd $DEFAULT_UID | wc -l` -le 0 ]]; then
			if [[ `getent passwd $DEFAULT_USERNAME | wc -l` -gt 0 ]]; then
				usermod -u $DEFAULT_UID $DEFAULT_USERNAME
			elif [[ `getent passwd $DEFAULT_UID | wc -l` -gt 0 ]]; then
				usermod -l $DEFAULT_USERNAME `getent passwd $DEFAULT_UID | cut -d: -f1`
			else
				# Do not create home (-m), it must be shared!
				useradd -u $DEFAULT_UID -g $DEFAULT_GID $DEFAULT_USERNAME
			fi
		fi

		usermod -g $DEFAULT_GID $DEFAULT_USERNAME
		adduser $DEFAULT_USERNAME www-data

		# Edit FPM file access
		if [[ -f /etc/php5/fpm/pool.d/www.conf ]]; then
			sed -i -r "s,^user = .+,user = $DEFAULT_USERNAME," /etc/php5/fpm/pool.d/www.conf
			sed -i -r "s,^group = .+,group = $DEFAULT_GROUPNAME," /etc/php5/fpm/pool.d/www.conf
		fi
	fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- /usr/sbin/sshd "$@"
fi

exec "$@"
