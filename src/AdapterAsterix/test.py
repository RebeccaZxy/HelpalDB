import tornado.httpclient

request_url = "http://localhost:19002/aql?aql=create+dataverse+bigdb+if+not+exists%3B"
httpclient = tornado.httpclient.AsyncHTTPClient()

try:
    request = tornado.httpclient.HTTPRequest(request_url, method='GET')
    response = httpclient.fetch(request)
except tornado.httpclient.HTTPError as e:
    print("ERROR:" + str(e))
except Exception as e:
    print("Error:" + str(e))
