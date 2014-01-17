Eprints-LDAP-Users-Import
=========================

Import LDAP users into EPrints

0. !Backup eprints database (and table 'user')!
1. (As eprints user) copy import and export plugins into archive plugins directory
2. (OPTIONAL) ln -s path_to_bin/ldap_fetch.pl /usr/local/bin/ldap_fetch.pl
3. ldap_fetch.pl > ldapForEprintsOut
4. (As eprints user) bin/import irb user UsersOnePerLine ./ldapForEprintsOut --verbose --verbose
5. login and search for users ..
