Network Configuration
=====================

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
     - `Sphinx <http://localhost:90>`_
   * - 7070
     - Adminer Database Management
     - HTTP
     - `Adminer <http://localhost:7070>`_
   * - 8088
     - Superset Web Server
     - HTTP
     - `Superset <http://localhost:8088>`_
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

WAN Ports Configuration
-----------------------

.. list-table:: WAN Open Ports
   :widths: 20 40 40 50 50 
   :header-rows: 1

   * - Port 
     - Description
     - Usage
     - External Link
     - Internal Link
   * - 8088
     - Main HTTP port
     - Main port for the web server
     - `Main Web <http://superset.embeddedsource.es>`_
     - `Superset <http://192.168.0.31:8088>`_
   * - 5432
     - PostgreSQL database port
     - Database port
     - `PostgreSQL <http://localhost:5432>`_
     - efwe
   * - 22
     - SSH port
     - Secure Shell port 
     - `SSH <http://localhost:22>`_
     - ewef
   * - 80
     - Another HTTP port
     - Another port for the web server
     - `<http://localhost:80>`_
     - ewf
   * - 7070
     - Adminer
     - Adminer Database Management
     - `Adminer <http://localhost:7070>`_
     - efwe
