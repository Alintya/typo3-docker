# typo3-docker

Docker files for newer Typo3 versions, closely following the official [manual installation docs](https://docs.typo3.org/m/typo3/guide-contributionworkflow/main/en-us/Appendix/Linux/SettingUpTypo3ManuallyLinux.html)

## Managing Extensions via Composer

- Attach to container
  `docker exec -it typo3-web bash`

- Run `composer require <vendor>/<extension>` inside the container

[See docs](https://docs.typo3.org/m/typo3/tutorial-getting-started/main/en-us/Extensions/Management.html#extensions_management)

## Additional settings

### Reverse Proxy

Set reverseProxyHeaderMultiValue, reverseProxyIP, reverseProxySSL and trustedHostsPattern in `config/system/additional.php`

Example:

```php
'reverseProxyHeaderMultiValue' =>; 'last',
'reverseProxyIP' =>; '127.0.0.1',
'reverseProxySSL' =>; '*',
'trustedHostsPattern' =>; '.*\.mypage\.com',
```

[See docs](https://docs.typo3.org/m/typo3/reference-coreapi/main/en-us/Configuration/Typo3ConfVars/SYS.html#reverseproxyip)

### PHP Settings (file upload limit)

mount an .ini into `/usr/local/etc/php/conf.d/` with for example `upload_max_filesize = 100M`

## TODO

- [ ] Add production version
