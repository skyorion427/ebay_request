class EbayRequest::Shopping < EbayRequest::Base
  include EbayRequest::Xml

  def initialize(options = {})
    super
    options[:siteid] ||=
      EbayRequest.config.site_from_globalid(options[:globalid]) || 0
  end

  private

  def payload(callname, request)
    request = Gyoku.xml(request)

    %(<?xml version="1.0" encoding="utf-8"?><#{callname}Request\
xmlns="urn:ebay:apis:eBLBaseComponents">#{request}</#{callname}Request>)
  end

  def endpoint
    "http://open.api%{sandbox}.ebay.com/shopping?"
  end

  def headers(callname)
    super.merge(
      "X-EBAY-API-APP-ID" => EbayRequest.config.appid,
      "X-EBAY-API-VERSION" => EbayRequest.config.version.to_s,
      "X-EBAY-API-CALL-NAME" => callname,
      "X-EBAY-API-REQUEST-ENCODING" => "XML",
      "X-EBAY-API-SITE-ID" => options[:siteid].to_s
    )
  end

  def error_message_for(r)
    r["Errors"]["LongMessage"]
  end
end