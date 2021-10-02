# PwnBox-Kali Configuration:

## Panel Configuration:

### CPU Graph:
* Right click on the panel and select `Add New Item` <br>

![](Twiking_Pic/Panel_Edit-1.png)

* On the search bar search CPU graph and click add <br>

![](Twiking_Pic/Panel_Edit-2.png)

* Right click on the `Graph` icon and move it to the left side of the panael <br>
![](Twiking_Pic/Panel_Edit-3.png)

* Right click on the `Graph` icon and change the properties to: <br>

![](Twiking_Pic/CPU-Graph_properties-2.png)

<br>

![](Twiking_Pic/CPU-Graph_properties-3.png)

* Remove workspace-switcher <br>
![](Twiking_Pic/Panel_Edit-5.png) 

### Separators:
* Right click on the seperator and change is properits <br>
![](Twiking_Pic/separator-3.png)

* Move the seperator to the right side of the panael <br>

![](Twiking_Pic/separator-4.png)

<br>

![](Twiking_Pic/separator-5.png)

* Do the same to the second separator and place it next to the cpu graph on the right side <br>

![](Twiking_Pic/separator-7.png)

* Add New separator and place it next to the clock icon <br>

![](Twiking_Pic/add-separator-4.png)


### Clock Format:
* Right click on the clock icon and select properties <br>

![](Twiking_Pic/5-12.png)

### Panel Icons:

* Remove show desktop icon <br>

![](Twiking_Pic/icon-1.png)

* change directory menu properties by right click <br>

![](Twiking_Pic/icon-2.png)

* change them to: <br>

![](Twiking_Pic/icon-4.png)

* Remove gedit launcher and Internet icon by right click and select remove <br>

![](Twiking_Pic/icon-5.png)

<br>

![](Twiking_Pic/icon-6.png)

* add new item and search for laucher <br>

![](Twiking_Pic/launcher-1.png) 

* Change launcher properties by right click <br>
![](Twiking_Pic/launcher-3.png)

* Click on the `+` icon and search firefox <br>

![](Twiking_Pic/launcher-4.png)

<br>

![](Twiking_Pic/firefox.png)

* add new launcher and insted of click on `+` click on `paper and +` icon <br>
* add the following command: `gnome-terminal -e pwsh` <br>

![](Twiking_Pic/pwsh-1.png)

* change the icon by clicking it and select from the list `image file` and eneter the following path `/opt/Customize-Kali/htb`  <br>

![](Twiking_Pic/icons.png)

* change termial icon by right click select properites click on icon  <br>
* from the list select `Application icon` and select kali-menu  <br>

![](Twiking_Pic/terminal-3.png)

### VPN Monitor:
* add new item and select `Generic Monitor`  <br>

![](Twiking_Pic/vpnpanel.png)

* Right click on the `xxx` icon and change propeties <br>
* set the command `/opt/Customize-Kali/htb/vpnpanel.sh` <br> 

![](Twiking_Pic/5-16.png)

<br>

![](Twiking_Pic/final-panel.png)

---

## Desktop Settings: 

* Right click on the dekstop and select dekstop settings <br> 

![](Twiking_Pic/desktop-settings-1.png)

* Go to the icon tab and chage to the following: <br> 

![](Twiking_Pic/desktop-settings-3.png)

---

## Startup Apps:

* Go to settings manager <br> 

![](Twiking_Pic/startup-1.png)

* Go to `Session And Startup`

![](Twiking_Pic/startup-2.png)

* Click on `+` icon and set the command `plank` <br> 

![](Twiking_Pic/plank-doc.png)

* Set up login banner by clicking on `+` icon and set the command `gnome-terminal -e /opt/Customize-Kali/htb/banner.sh` <br> 

![](Twiking_Pic/login-banner.png)

* Set up guake termianl startup by clicking on `+` icon and set the command `guake` <br> 

![](Twiking_Pic/5-35.png)

---

## Guake Configuration:

* on the terminal type guake and right click on guake icon on the right side <br> 

![](Twiking_Pic/guake-1.png)

* In `General` tab set the following config: <br> 

![](Twiking_Pic/guake-3.png)

* In `Main Windows` tab set the following config: <br> 

![](Twiking_Pic/guake-5.png)

* In `Appearence` tab set the following config: <br> 

![](Twiking_Pic/guake-7.png)

* In `keyborad Shortcuts` tab set the following config: <br> 

![](Twiking_Pic/guake-9.png)

---

## Default App:

* Go to settings and click on `Default Application` and on utiliti tab change to `gnome terminal` <br> 

![](Twiking_Pic/preferd-app-3.png)

---

## Plank Doc

* On the terminal type plank and hit enter and edit this has you like this is mine: <br> 

![](Twiking_Pic/plankdoc-2.png)

---

## Terminal Configuration:

* Open terminal and right clikc on it and select `Preferences` and change to the following: <br> 

![](Twiking_Pic/terminal-pref-3.png)

* go to `color` tab and change to the following: <br> 

![](Twiking_Pic/terminal-pref-5.png)

---

![](Twiking_Pic/banner.png)