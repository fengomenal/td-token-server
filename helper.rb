require 'rest-client'
require 'cgi'

module Helper
  module_function

  def provision_auth_token(code, client_id, redirect)
    RestClient::Request.execute(
      method: :POST,
      url: 'https://api.tdameritrade.com/v1/oauth2/token',
      payload: "grant_type=authorization_code&code=#{CGI.escape(code)}&redirect_uri=#{CGI.escape(redirect)}&access_type=offline&client_id=#{client_id}",
      header: {
        accept: '*/*',
        content_type: 'application/x-www-form-urlencoded'
      }
    ) { |res| res }
  end

  def provision_refresh_token(refresh, client_id)
    RestClient::Request.execute(
      method: :POST,
      url: 'https://api.tdameritrade.com/v1/oauth2/token',
      payload: "grant_type=refresh_token&refresh_token=#{CGI.escape(refresh)}&access_type=offline&client_id=#{client_id}",
      header: {
        accept: '*/*',
        content_type: 'application/x-www-form-urlencoded'
      }
    ) { |res| res }
  end
end
