IrreversibleURLShortener
========================

Provides functions for generating an irreversible key of variable length to be used as a shortened URL variable. In response to a question in the [TACFUG google group](https://groups.google.com/forum/#!msg/tacfug/d4mFhPLzFUU/ezbeMV539XkJ), I have created this project to demonstrate a few ways in which to generate shortened URL variables to use in place of longer (e.g. CreateUUID()) variables.

This package relies on having a database table with a column that stores the generated keys produced by this code. As such, this package includes two CFC's:

* Datasource.cfc
* IrreversibleURLShortener.cfc

The Datasource.cfc is consumed (required) by the IrreversibleURLShortener.cfc.

--------------

To use, first initialize the datasource model/bean and the IrrversibleURLShortener component:

```ColdFusion
<cfset db = CreateObject('component','Datasource').init(
  dsn       = 'mydsn', 
  username  = 'myusername', 
  password  = 'mypassword') 
/>
<cfset urlShortMethod = CreateObject('component','IrreversibleURLShortener').init(datasource = db) />
```

-----------

Then, call the method passing in the [table] and [column] that stores the key to check the existence of in the database, optionally specifying the length of the generated key (6 chars by default) using one of the available methods (hash, aplha, alphanum or numeric, 'hash' by default):


```ColdFusion
<cfset myShortUrl = urlShortMethod(
  table     = 'mytable',
  column    = 'mycolumn',
  keyLength = myNumericKeyLength,
  method    = 'hash'
) />
```

**OR**

```ColdFusion
<cfset myShortUrl = urlShortMethod(
  table     = 'mytable',
  column    = 'mycolumn',
  keyLength = myNumericKeyLength,
  method    = 'alpha'
) />
```

**OR**

```ColdFusion
<cfset myShortUrl = urlShortMethod(
  table     = 'mytable',
  column    = 'mycolumn',
  keyLength = myNumericKeyLength,
  method    = 'alphanum'
) />
```

**OR**

```ColdFusion
<cfset myShortUrl = urlShortMethod(
  table     = 'mytable',
  column    = 'mycolumn',
  keyLength = myNumericKeyLength,
  method    = 'numeric'
) />
```
