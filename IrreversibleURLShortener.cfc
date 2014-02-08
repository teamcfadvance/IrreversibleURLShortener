<cfcomponent displayname="IrreversibleURLShortener" hint="I provide functions for generating an irreversible key of variable length to be used as a shortened URL variable.">

	<!--- Pseudo-constructor --->
	<cfset variables.instance = {
		datasource = ''
	} />

	<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the IrreversibleURLShortener class.">
		<cfargument name="datasource" type="any" required="true" hint="I am the Datasource model/bean, with functions getDSN(), getUsername() and getPassword()." />
		
		<!--- Set the initial values of the instance --->
		<cfset variables.instance.datasource = ARGUMENTS.datasource />
	  
	  <cfreturn this>
	</cffunction>

	<!---               --->
	<!--- GET SHORT URL --->
	<!---               --->
	<cffunction name="getShortURL" access="public" returntype="string" output="false" hint="I return a random, verified short URL.">
		<cfargument name="table" type="string" required="true" hint="I am the name of the table in the database where [column] is stored." />
		<cfargument name="column" type="string" required="true" hint="I am the name of the column in [table] where the generated key is compared." />
		<cfargument name="keyLength" type="numeric" required="false" default="6" hint="I am the length of the random key you wish to return." />
		<cfargument name="method" type="string" required="false" default="hash" hint="I am the method of key generation, one of: hash, alphanum." />
		
		<!--- var scope and get the first key from the getKey() function --->
		<cfset var thisKey = getKey( 
			keyLength	= ARGUMENTS.keyLength, 
			method		= ARGUMENTS.method 
		) />
		<!--- var scope and check the first key using the checkKey() function --->
		<cfset var isValidKey = checkKey(
			checkKey	= thisKey,
			table		= ARGUMENTS.table,
			column		= ARGUMENTS.column
		) />
		
		<!--- loop while there is already a matching key already used in [table].[column] --->
		<cfloop condition="#NOT isValidKey#">		
			<!--- get the next iteration of a generated key to check --->
			<cfset var thisKey = getKey( 
				keyLength	= ARGUMENTS.keyLength, 
				method		= ARGUMENTS.method 
			) />
			<!--- check if this key is valid (not matching one already used in [table].[column]) --->
			<cfset var isValidKey = checkKey(
				checkKey	= thisKey,
				table		= ARGUMENTS.table,
				column		= ARGUMENTS.column
			) />
		</cfloop>
		
		<!--- return the generated, validated, random key --->
		<cfreturn thisKey />
	</cffunction>
	
	<!---         --->
	<!--- GET KEY --->
	<!---         --->
	<cffunction name="getKey" access="private" returntype="string" output="false" hint="I return a random key to use for the URL.">
		<cfargument name="keyLength" type="numeric" required="true" hint="I am the length of the random key you wish to return." />
		<cfargument name="method" type="string" required="true" hint="I am the method of key generation, one of: hash, alphanum." />
		
		<!--- var scope set up a list of alpha-numeric characters to use for generating an alphanum key --->
		<cfset var alphaNum = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9' />
		<cfset var thisKey = '' />
		<cfset var keySeed = '' />
		<cfset var iX = 0 />
		
		<!--- check if we're using the 'hash' or 'alphanum' method of key generation --->
		<cfif FindNoCase('hash',ARGUMENTS.method)>
		
			<!--- using the 'hash' method, generate a hashed variable to work with --->
			<cfset keySeed = Hash(CreateUUID(),'SHA-384') />
			<!--- get a random string of [keyLength] characters from the generated hash --->
			<cfset thisKey = Mid(keySeed,RandRange(1,Len(keySeed)-(ARGUMENTS.keyLength+1)),ARGUMENTS.keyLength) />
		
		<!--- otherwise, check if we're using the 'alphanum' method of key generation --->
		<cfelseif FindNoCase('alphanum',ARGUMENTS.method)>
		
			<!--- using the 'alphanum' method, loop through [keyLength] times --->
			<cfloop from="1" to="#ARGUMENTS.keyLength#" index="iX">
				<!--- and add a random char from the [alphaNum] list --->
				<cfset thisKey = thisKey & LisGetAt(alphaNum,RandRange(1,ListLen(alphaNum))) />
			</cfloop>
		
		</cfif>
		
		<!--- return the generated key --->
		<cfreturn thisKey />
	</cffunction>
	
	<!---           --->
	<!--- CHECK KEY --->
	<!---           --->
	<cffunction name="checkKey" access="private" returntype="boolean" output="false" hint="I check a passed key and return true or false.">
		<cfargument name="checkKey" type="string" required="true" hint="I am the key to check for the existence of." />
		<cfargument name="table" type="string" required="true" hint="I am the name of the table in the database where [column] is stored." />
		<cfargument name="column" type="string" required="true" hint="I am the name of the column in [table] where the generated key is compared." />
		
		<!--- var scope --->
		<cfset var qGetKey = '' />
		
		<!--- query the [table].[column] passed in for the existence of the passed in key --->
		<cfquery name="qGetKey" datasource="#variables.instance.datasource.getDSN()#" username="#variables.instance.datasource.getUsername()#" password="#variables.instance.datasource.getPassword()#">
			SELECT #ARGUMENTS.column#
			FROM #ARGUMENTS.table#
			WHERE #ARGUMENTS.column# = <cfqueryparam value="#ARGUMENTS.checkKey#" cfsqltype="cf_sql_varchar" />
		</cfquery>
		
		<!--- check if the key exists (there is a record returned) --->
		<cfif qGetKey.RecordCount>
			<!--- a key of this value already exists in the database, return 'false' --->
			<cfreturn false />
		<!--- otherwise --->
		<cfelse>
			<!--- this key does not exist in the database, return 'true' --->
			<cfreturn true />
		</cfif>
	</cffunction>		
	
</cfcomponent>
