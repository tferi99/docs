Tasks before building
---------------------

- Install Java(TM) Web Services Developer Pack ("D:\inst\java\webservices\Java Web Services Developer Pack\jwsdp-2_0-windows-i586.exe")

- Copy the file server/lib/catalina-ant.jar from your Tomcat 5 installation into Ant's library directory ($ANT_HOME/lib).

- Set JAXRPC_HOME pointing to jaxrpc under Java(TM) Web Services Developer Pack (to find bin/wscompile.bat), e.g:

	set JAXRPC_HOME=c:\apps\jwsdp-2.0\jaxrpc
	
- Edit jwsnutExamples.properties, uncomment variables and WSROOT to Web Services Developer Pack, e.g.:

	USING_JWSDP=true
	WSROOT=c:/apps/jwsdp-2.0
	
- Copy these files into your home directory:

		jwsnutExamples.properties
		jwsnutJaxrExamples.properties
		
		