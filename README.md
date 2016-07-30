# Pokemon Go 3 Step Fix

## New Readme

While updating the script for removing unused/less-than-appealing code as well as the database, I got a notification to alerting me of this pull request:

[Adds 3 Step Fix to Pokemon-Go-MITM-Node's Examples](https://github.com/rastapasta/pokemon-go-mitm-node/pull/66)

Needless to say, I was happy to see [trisk](https://github.com/trisk) adding my idea to his code for the main Pokemon Go MITM Repo.

Instead of using this (even if I finished updating it), I recommend you going there and use that instead.

From the beginning I had planned on trying to add this to the main repo when the code was much cleaner, so it's nice to see this idea potentially being added there ahead of schedule.

## Old Readme

### Hardware Prerequisites

This script has been tested on an Ubuntu server, but these instructions should be able to be modified for any Unix server.

The preferred method to use this script for most people would be to grab a Free Tier Ubuntu Server from the Amazon Web Services.
 * No need to have a server at your house
 * Doesn't expose your home computer/network to the world
 * Easy to configure and setup

### Installing

Go to rastapasta's [Pokemon Go MITM project](https://github.com/rastapasta/pokemon-go-mitm-node) page, and follow the instructions to install his project on your server.

Inside of the pokemon-go-mitm-node folder, install node's mysql client:

```
npm install mysql
```

Next, install php5, mysql:

```
apt-get install libapache2-mod-php5 mysql-server libapache2-mod-auth-mysql php5-mysql
```

During the install, you will be asked to create a root password for your database software.

Grab this github:

```
git clone https://github.com/zaksabeast/pokemon-go-3-step-fix.git
```

Move radar.coffee and radar.php to the pokemon-go-mitm-node folder you obtained in the first step.

Create the "pogo" database with the table "nearby".

```
mysql -p
CREATE DATABASE pogo;
USE pogo;
CREATE TABLE nearby (type VARCHAR(20), encounterID VARCHAR(30), latitude VARCHAR(20), longitude VARCHAR(20), expirationMs BIGINT(11), PRIMARY KEY (encounterID));
exit;
```

Edit the radar.coffee and radar.php files with your database username and password where the files say "YOUR_USER_HERE" and "YOUR_PASSWORD_HERE".

Run the script!

```
coffee radar.coffee
```

### Connecting your server

On Wifi: edit your wifi settings to add your server's IP address and (default) port 8081 to the proxy settings.

On Android: write down the information found in Settings->Cellular Networks->Access Point Names, then make a new APN with the same settings, except with the Proxy IP as your server's IP, and port set to 8081; this will allow you to switch easily between the two APNs.

On iPhone: add your Server's IP and Port to the settings found in Settings->Cellular->Cellular Data Network.

### Disconnecting from your server

Remove the added settings

### License

Part of this code was borrowed from rastapasta's In Game Radar example, where PokeStops are populated with Pokemon's information, and is to be used with his main program.  As such, the licenses are the same.

### Credits

Special thanks to rastapasta for the Pokemon Go mitm, and everyone who helped with that project!
