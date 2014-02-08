<cfcomponent displayname="Datasource" output="false" hint="I am the Datasource class.">

	<cfproperty name="DSN" type="string" default="" />
	<cfproperty name="username" type="string" default="" />
	<cfproperty name="password" type="string" default="" />
	
	<!--- Pseudo-contructor --->
	<cfset variables.instance = {
		DSN = '',
		username = '',
		password = ''
	} />
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the Datasource class.">
	<cfargument name="DSN" type="string" required="true" default="" hint="I am the name of the datasource." />
	<cfargument name="username" type="string" required="true" default="" hint="I am the username of the datasource." />
	<cfargument name="password" type="string" required="true" default="" hint="I am the password of the datasource." />
	
		<cfscript>
			variables.instance.DSN = ARGUMENTS.DSN;
			variables.instance.username = ARGUMENTS.username;
			variables.instance.password = ARGUMENTS.password;
		</cfscript>
		
	<cfreturn this>
	</cffunction>
	
	<!--- getters --->
	<cffunction name="getDSN" access="public" output="false" hint="I return the name of the datasource.">
	  <cfreturn variables.instance.DSN>
	</cffunction>
	
	<cffunction name="getUsername" access="public" output="false" hint="I return the name of the datasource.">
	  <cfreturn variables.instance.username>
	</cffunction>
	
	<cffunction name="getPassword" access="public" output="false" hint="I return the name of the datasource.">
	  <cfreturn variables.instance.password>
	</cffunction>
	
</cfcomponent>