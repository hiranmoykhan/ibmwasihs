# ibmwasihs #

This is the IBM HTTP Server 7.0 Installation Module. 
Packages are required to transfer under files directory.

It uses a response file to proceed with installation.
It requires users input on the agent box to place following details in /tmp/ihs-details.txt file.

-OPT installLocation=/app/IBM/HTTPServer
-OPT adminAuthUser=ihsadmin
-OPT adminAuthPassword=ihsadmin
-OPT washostname=master.example.com
-OPT setupAdminUser=build
-OPT setupAdminGroup=build
-OPT webserverDefinition=webserver1
