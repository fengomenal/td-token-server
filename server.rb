require 'cgi'
require 'json'
require 'sinatra'
require_relative './helper.rb'

config = JSON.parse(File.read('./tmp/config.json'))
client_id = config['client_id']
redirect_uri = config['redirect_uri']
callback_uri = "https://auth.tdameritrade.com/auth?response_type=code&redirect_uri=#{CGI.escape(redirect_uri)}&client_id=#{client_id}%40AMER.OAUTHAP"
$code = nil
$token = nil
$refresh = nil
$debug = 'up and running'

Thread.new {
  loop do
    begin
      sleep($code ? 1500 : 5)
      next unless $code
      if $token
        res = Helper.provision_refresh_token($refresh, client_id)
      else
        res = Helper.provision_auth_token($code, client_id, redirect_uri)
      end
      body = JSON.parse(res.body)
      $token = body['access_token']
      $refresh = body['refresh_token']
      $debug = res.code
    rescue StandardError => e
      $debug = e.to_s
    end
  end
}

set :port, 8080

get '/' do
  $debug
end

get '/auth' do
  callback_uri
end

get '/code' do
  $code = CGI.unescape(params['code']).gsub("\s", '+')
end

get '/token' do
  $token
end
