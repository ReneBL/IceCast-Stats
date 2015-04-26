module RequestsHelper
  def get_with_token(path, params={}, headers={})
    headers.merge!('HTTP_ACCESS_TOKEN' => retrieve_access_token)
    xhr :get path, params, :format => :json
  end

  def post_with_token(path, params={}, headers={})
    headers.merge!('HTTP_ACCESS_TOKEN' => retrieve_access_token)
    xhr :post path, params, :format => :json
  end

  # similarly for xhr..
end