# 0.4.0 (2019-12-17)
- Support Kong 1.1 ([#38](https://github.com/kontena/kong-client-ruby/pull/38))

# 0.3.4 (2018-09-12)
- Re-built gem package

# 0.3.3 (2018-09-07)
- Switch to application json content type ([#28](https://github.com/kontena/kong-client-ruby/pull/28))
- Flatten nested plugin config items ([#27](https://github.com/kontena/kong-client-ruby/pull/27))

# 0.3.2 (2018-02-05)
- Remove Excon version dependency ([#25](https://github.com/kontena/kong-client-ruby/pull/25))

# 0.3.1 (2017-10-02)
- Use consumer id to retrieve auth keys and tokens ([#19](https://github.com/kontena/kong-client-ruby/pull/19))
- Add methods to kong api base attributes ([#21](https://github.com/kontena/kong-client-ruby/pull/21))
# 0.3.0 (2017-07-31)
- Add support for Upstream and Target resources ([#15](https://github.com/kontena/kong-client-ruby/pull/15))

# 0.2.0 (2017-04-20)
- Add Server information support ([#14](https://github.com/kontena/kong-client-ruby/pull/14))
- Add optional attributes to Api
 ([#13](https://github.com/kontena/kong-client-ruby/pull/13))
- Fix Plugin#create and #update to save config properly
([#12](https://github.com/kontena/kong-client-ruby/pull/12))

# 0.1.2 (2017-01-12)
- Add JWT support ([#2](https://github.com/kontena/kong-client-ruby/pull/2))
- Allow to properly set a custom api_url ([#4](https://github.com/kontena/kong-client-ruby/pull/4))
- Allow to redefine api_url
([#6](https://github.com/kontena/kong-client-ruby/pull/6))
- Add ACL support
([#9](https://github.com/kontena/kong-client-ruby/pull/9))

# 0.1.1 (2016-10-10)
- Fix Kong::Base.respond_to? to return true for find_by_* methods
