<cfcomponent>
<!--- configure this Application.cfm options --->
<cfscript>
THIS.name = "IUSDemo_v1";
THIS.clientmanagement="True";
THIS.loginstorage="session";
THIS.sessionmanagement="True";
THIS.sessiontimeout="#createtimespan(0,15,0,0)#";
THIS.applicationtimeout="#createtimespan(0,0,0,0)#";
THIS.scriptprotect="all";
</cfscript>
<!---                    --->
<!--- onApplicationStart --->
<!---                    --->
<cffunction name="onApplicationStart">
	<!--- set application variables --->
	<cfscript>
        APPLICATION.ds = "[your datasource]";
		APPLICATION.iusTable = 'iusDemo';
		APPLICATION.iusColumn = 'demoId';
    </cfscript>
	
	<!--- INITIALIZE OBJECTS --->
  	<cfset datasourceObject = createObject('component','Datasource').init(DSN = APPLICATION.ds) />
	<cfset APPLICATION.iusObject = createObject('component','IrreversibleURLShortener').init(datasource = datasourceObject) />
	
	<!--- log the application start --->
	<cflog text="#THIS.name# Application Started" type="Information" file="#THIS.name#" thread="yes" date="yes" time="yes" application="yes">
	<cfreturn True>
</cffunction>
<!---                 --->
<!--- onSessiontStart --->
<!---                 --->
<cffunction name="onSessionStart">
</cffunction>
<!---                --->
<!--- onRequestStart --->
<!---                --->
<cffunction name="onRequestStart">
	<!--- set up a tick counter --->
	<cfset tickBegin = GetTickCount()>
</cffunction>
<cffunction name="onRequestEnd">
	<!--- set up another tick counter --->
	<cfset tickEnd = GetTickCount()>
	<!--- calculate ticks it took to process this page --->
	<cfset totalTicks = tickEnd - tickBegin>
</cffunction>
<!---              --->
<!--- onSessionEnd --->
<!---              --->
<cffunction name="onSessionEnd" returnType="void">
	<cfargument name="SessionScope" required=True/>
	<cfargument name="ApplicationScope" required=False/>
</cffunction>
<!---                  --->
<!--- onApplicationEnd --->
<!---                  --->
<cffunction name="onApplicationEnd">
	<cfargument name="ApplicationScope" required=true/>
	<cflog file="#This.Name#" type="Information" text="Application #ApplicationScope.applicationname# Ended">
</cffunction>
</cfcomponent>