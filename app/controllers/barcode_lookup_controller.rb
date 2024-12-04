class BarcodeLookupController < ApplicationController
  require 'net/http'
  require 'uri'

  def search
    barcode = params[:barcode]
    url = URI("https://api.barcodelookup.com/v3/products?barcode=#{barcode}&formatted=y&key=xk20p949g0ia2vbqkbegd40xhuhczz")
    response = Net::HTTP.get_response(url)
    render json: response.body, status: response.code
  end
end
