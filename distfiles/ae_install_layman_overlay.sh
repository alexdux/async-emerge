#!/bin/bash
# ae_install_layman_overlay.sh

echo "- Emerge dependancies"
emerge -uv aufs2 gentoolkit layman
echo "- Update '/usr/local/portage/layman/overlays.xml'"
(
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?> 
 <repositories version="1.0"> 
   <repo priority="50" quality="experimental" status="unofficial"> 
     <name>async-emerge</name> 
     <description>Asynchronous multiple binaries cooker for Gentoo. Comments and bugreports are welcome!</description> 
     <homepage>http://code.google.com/p/async-emerge/</homepage> 
     <owner> 
       <email>alexdu.com.a2e@g33mail.com</email> 
     </owner> 
     <source type="svn">http://async-emerge.googlecode.com/svn/trunk/</source> 
   </repo> 
 </repositories> 
EOF
) >> /usr/local/portage/layman/overlays.xml
echo "- Update '/usr/local/portage/layman/make.conf'"
(
cat <<EOF
PORTDIR_OVERLAY=" 
/usr/local/portage/layman/async-emerge 
\$PORTDIR_OVERLAY 
"
EOF
) >>  /usr/local/portage/layman/make.conf
echo "- checkout AE SVN"
cd /usr/local/portage/layman 
svn checkout http://async-emerge.googlecode.com/svn/overlay/ async-emerge 
echo "- Sync layman"
layman -S
echo "- Unmask AE"
if [ -d "/etc/portage/package.keywords/" ]; then
    echo "app-portage/async-emerge" > /etc/portage/package.keywords/async-emerge
else
    echo "app-portage/async-emerge" >> /etc/portage/package.keywords
fi
echo "- Emerge AE"
emerge -av -j1 app-portage/async-emerge
echo "- Check AE"
ae_vcs df -h
echo "- Edit crontab with mcedit"
VISUAL=mcedit crontab -e
