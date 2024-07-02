=============
Configuration
=============

External Network Configuration
------------------------------

.. list-table:: External Network Configuration
   :widths: 20 40 40 50 50 10
   :header-rows: 1

   * - IP Address
     - Port
     - Subnet Mask
     - Gateway
     - DNS
     - Status (Open/Closed)
   * - localhost
     - 22
     - 
     - 
     - 
     - Open
   * - localhost
     - 80
     - 
     - 
     - 
     - Open
   * - localhost
     - 33050
     - 
     - 
     - 
     - Open


LAN Ports Configuration
-----------------------

.. list-table:: Ports Configuration
   :widths: 20 40 40 50
   :header-rows: 1

   * - Port 
     - Description
     - Type
     - Link
   * - 90
     - Sphinx Documentation
     - HTTP
     - `http://localhost/docs <http://localhost/docs>`_
   * - 7070
     - Adminer Database Management
     - HTTP
     - `http://localhost/adminer <http://localhost/adminer>`_
   * - 8088
     - Superset Web Server
     - HTTP
     - `http://localhost/superset <http://localhost/superset>`_
   * - 8087
     - PyPi Server
     - HTTP
     - `http://localhost/pypi <http://localhost/pypi>`_
   * - 22
     - Secure Shell port 
     - TCP/IP
     - `SSH <http://localhost:22>`_
   * - 54320
     - PostgreSQL database port
     - TCP/IP
     - `PostgreSQL <http://localhost:5432>`_
   * - 33050
     - MySQL Database
     - TCP/IP
     - `MySQL <http://localhost:33050>`_


Links Access
------------

.. list-table:: WAN Open Ports
   :widths: 20 40 40  50 50
   :header-rows: 1

   * - Port 
     - Description
     - TYpe
     - Internal Link
     - External Link
   * - 90
     - Sphinx Documentation
     - HTTP
     - `http://localhost/docs <http://localhost/docs>`_
     - `http://www.embeddedsource.es/docs <http://www.embeddedsource.es/docs>`_
   * - 7070
     - Adminer Database Management
     - HTTP
     - `http://localhost/adminer <http://localhost/adminer>`_
     - `http://www.embeddedsource.es/adminer <http://www.embeddedsource.es/adminer>`_
   * - 8088
     - Superset Web Server
     - HTTP
     - `http://localhost/superset <http://localhost/superset>`_
     - `http://superset.embeddedsource.es <http://superset.embeddedsource.es>`_
   * - 8087
     - PyPi Server
     - HTTP
     -
     - `http://pypi.embeddedsource.es <http://pypi.embeddedsource.es>`_
   * - 22
     - SSH port
     - TCP/IP
     - 
     - ssh <user>@ordiso.embeddedsource.es
   * - 5432
     - PostgreSQL database port
     - TCP/IP
     - psql -h localhost -p 54320 -U <user> -d <database>
     - psql -h ordiso.embeddedsource.es -p 54320 -U <user> -d <database>
   * - 33050
     - MySQL Database
     - TCP/IP
     - mysql -u <user> -p -h localhost -P 33050
     - mysql -u <user> -p -h ordiso.embeddedsource.es -P 33040
