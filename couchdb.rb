require 'json'
require 'couchrest'

module CouchDB

  def self.get(env)
    creds = get_credentials(env)
    url = creds['url']
    if !url.end_with?('/')
      url = url + '/'
    end
    url = url + 'bluemix-todo'

    puts "URL: #{url}"
    CouchRest.database!(url)
  end


  def self.create_view(db, name, view, reduce)
    begin
      db.get("_design/#{name}")
    rescue RestClient::ResourceNotFound => nfe
      db.save_doc({
        "_id" => "_design/#{name}",
        :views => {
          name.to_s => {
            :reduce => reduce,
            :map => view
          }
        }
      })
    end
  end

  private

  def self.get_credentials(env)
    if env['VCAP_SERVICES']
      svcs = JSON.parse env['VCAP_SERVICES']
      cloudant = svcs.detect { |k,v| k =~ /^cloudantNoSQLDB/ }.last.first
      creds = cloudant['credentials']
    else
      raise 'Missing VCAP_SERVICES env variable'
    end
  end

end
