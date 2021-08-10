#! /bin/bash
#parse domain user output from ldapdomaindump to generate a users list for passwordspray and etc.
cat domain_users.json|grep -i samaccountname -A 1 >> ../domain_users.lst;sed -i '1 i\t' ../domain_users.lst;sed -i -n '0~3p' ../domain_users.lst;sed -i 's/ *//g' ../domain_users.lst;sed -i 's/"//g' ../domain_users.lst
