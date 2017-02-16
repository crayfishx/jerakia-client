### 0.5.1

* Removed gem dependency for rest-client

## 0.5.0

* Removed rest-client gem and replaced with native `Net::HTTP` - this fixes several performance issues when running the client under jRuby

* Added `Jerakia::Client::ScopeNotFoundError` exception to catch instances of the scope not being available
