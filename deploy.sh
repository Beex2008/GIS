#!/usr/bin/env bash
echo "Content-type: text/plain"
echo

#chmod u+x backend/
#chmod 755 /usr/lib/cgi-bin/backend/*.sh

echo -e "deploy is starting ...\n"
if cp -r -v api/ /$USER/usr/lib/cgi-bin/; then 
  echo -e "copy in cgi-bin/ folder is successful  $(/usr/lib/cgi-bin/api/) \n"
else 
  echo "Error of copy in cgi-bin/ folder"
fi

if cp -r -v frontend/ /var/www/html/$USER/; then
  echo -e "copy was succesful in webspace $(/var/www/html/$USER/frontend)"
else 
  echo "error copy $(date) "
fi
