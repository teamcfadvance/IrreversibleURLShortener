<cfparam name="FORM.keyLength" default="6" type="numeric" />
<cfparam name="FORM.method" default="hash" type="string" />

<!--- check if the form was submitted --->
<cfif IsDefined('FORM.btnSubmit')>

	<!--- it was, check if the key length is greater than 24 --->
	<cfif FORM.keyLength GT 24>
		<!--- it is, set the key length to 24 --->
		<cfset FORM.keyLength = 24 />
	</cfif>
	
	<!--- check if the method is one of hash, alpha, numeric or alphanumeric --->
	<cfif NOT ReFindNoCase('(hash|alpha|numeric|alphanum)',FORM.method)>
		<!--- it isn't, set it to use the hash method --->
		<cfset FORM.method = 'hash' />
	</cfif>
	
	<!--- call the getShortUrl() function, passing in the demo db table and column, --->
	<!--- along with the keyLength and method selected by the user, set to 'thisResult' --->
	<cfset thisResult = APPLICATION.iusObject.getShortUrl(
		table		= APPLICATION.iusTable,
		column		= APPLICATION.iusColumn,
		keyLength	= FORM.keyLength,
		method		= FORM.method
	) />

<!--- otherwise --->
<cfelse>

	<!--- form not submitted, set result to null --->
	<cfset thisResult = '' />
	
<!--- end checking if the form was submitted --->
</cfif>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>IrreversibleURLShortener Demo</title>
<style type="text/css">
body {
	font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
	font-size:1em;
}

#main-text {
	width:500px;
}

#result-input {
	width:300px;
}
</style>
</head>

<body>
<cfoutput>
<h2>IrreversibleURLShortener Demo</h2>
<div id="main-text">
	<p>Use this page to select the key length and generation method to see the <a href="https://github.com/teamcfadvance/IrreversibleURLShortener" target="_blank">IrreversibleURLShortener component on GitHub</a> at work. Results are returned below the form after you submit.</p>
</div>
<form action="#CGI.SCRIPT_NAME#" method="post">
	<table>
		<thead>
			<tr>
				<th>Key Length</th>
				<th>&nbsp;</th>
				<th>Generation Method</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><select name="keyLength">
						<cfloop from="6" to="24" index="iX">
							<option value="#iX#"<cfif FORM.keyLength EQ iX> selected</cfif>>#iX#</option>
						</cfloop>
					</select></td>
				<td>&nbsp;</td>
				<td><select name="method">
						<option value="hash"<cfif FORM.method EQ 'hash'> selected</cfif>>hash</option>
						<option value="alpha"<cfif FORM.method EQ 'alpha'> selected</cfif>>alpha</option>
						<option value="numeric"<cfif FORM.method EQ 'numeric'> selected</cfif>>numeric</option>
						<option value="alphanum"<cfif FORM.method EQ 'alphanum'> selected</cfif>>alphanum</option>
					</select></td>
			</tr>
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="3"><input type="submit" name="btnSubmit" value="Generate Key" /></td>
			</tr>
		</tbody>
	</table>
	<h2>Result:</h2>
	<p>
		<input type="text" id="result-input" name="result" value="#thisResult#" size="30" />
	</p>
</form>
</cfoutput>
</body>
</html>