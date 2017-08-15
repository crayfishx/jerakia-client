
# 1.0.0

Stable release.

* Feature: Now supports `msgpack` as a data serialization format - msgpack was introduced into Jerakia in version 2.4, although JSON is still the default.
* This release is stable, that means strict semantic versioning will apply from 1.0 onwards

### 0.5.3

* Bugfix: previously, nested namespaces were being sent twice in the URL as different fields rather than slash delimited as per the API docs.

### 0.5.2

* Fixed error with earlier versions of Puppetserver that unset the HOME environment variable, this caused jerakia-client to throw an error when searching for configuration files.

### 0.5.1

* Removed gem dependency for rest-client

## 0.5.0

* Removed rest-client gem and replaced with native `Net::HTTP` - this fixes several performance issues when running the client under jRuby

* Added `Jerakia::Client::ScopeNotFoundError` exception to catch instances of the scope not being available
