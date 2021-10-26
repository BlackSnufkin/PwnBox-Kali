#! /bin/bash
## Parse Domain user output from ldapdomaindump to generate a users list for passwordspray and etc.
cat domain_users.json|grep -i samaccountname -A 1 >> ../users.lst;sed -i '1 i\t' ../users.lst;sed -i -n '0~3p' ../users.lst;sed -i 's/ *//g' ../users.lst ;sed -i 's/"//g' ../users.lst;cat ../users.lst | sort > ../Domain_Users.lst;rm ../users.lst
