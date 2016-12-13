# jerakia-client

## Description

A ruby client library and CLI for integrating with Jerakia Server (Jerakia 1.2.0+)

For more details on Jerakia Server please see [The official Jerakia site](http://jerakia.io)

This client is for use with Jerakia Server, which ships in 1.2.0, it does not integrate with Jerakia 1.1 or below

## Usage

### Command line

```
Usage:
  jerakia-client lookup [KEY]

Options:
  H, [--host=HOST]                 # Hostname or IP to connect to
  P, [--port=PORT]                 # Port to connect to
  T, [--token=TOKEN]               # Token to use for authorization, if not provided a jerakia.yaml will be searched for (see docs)
  a, [--api=API]                   # API Version to implement (see docs)
  p, [--policy=POLICY]             # Lookup policy
                                   # Default: default
  n, [--namespace=NAMESPACE]       # Lookup namespace
  t, [--type=TYPE]                 # Lookup type
                                   # Default: first
  s, [--scope=SCOPE]               # Scope handler
                                   # Default: metadata
      [--scope-options=key:value]  # Key/value pairs to be passed to the scope handler
  m, [--merge-type=MERGE_TYPE]     # Merge type
                                   # Default: array
  v, [--verbose], [--no-verbose]   # Print verbose information
  D, [--debug], [--no-debug]       # Debug information to console, implies --log-level debug
  o, [--output=OUTPUT]             # Output format, yaml or json
                                   # Default: json

Lookup [KEY] with Jerakia
```

### Ruby bindings

#### `Jeraia::Client.new`

Initiate a new client instance.

```
client = Jerakia::Client.new(opts)
```

Options can be given as a hash of:

`host`: Hostname or IP to connect to (default localhost)
`port`: Port to connect to (default 9843)
`api`: The Jerakia Server API version impemented on the server (default v1)
`proto`: The protocol to use, `http` or `https` are supported, `http` is the default.
`token`: The authentication token to use in the request,  if no token is specified jerakia-client will look for a `jerakia.yaml` file in `/etc/jerakia` and `~/.jerakia` for a key called `client_token`


#### Instance methods

Once initiated the client can be used with the following instance methods

##### lookup(key, params)

```
client.lookup("port", { :namespace => 'apache' })
```

`params` is a hash of all of the options specified in the Jerakia Server API for the `/v1/lookup` endpoint


## LICENSE

This software is licensed under the Apache 2.0 license, please see the `LICENSE` file for full details

## Author

Written and maintained by Craig Dunn <craig@craigdunn.org>




