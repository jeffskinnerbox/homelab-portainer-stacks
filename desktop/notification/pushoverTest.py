# -*- coding: utf-8 -*-
"""

Pushover App Test
@author: AdamGetbags

"""

# import modules
import http.client, urllib

# create connection
conn = http.client.HTTPSConnection("api.pushover.net:443")

# make POST request to send message
conn.request("POST", "/1/messages.json",
  urllib.parse.urlencode({
    "token": "tokenGoesHere",
    "user": "userGoesHere",
    "title": "Title",
    "message": "Body",
    "url": "",
    "priority": "0" 
  }), { "Content-type": "application/x-www-form-urlencoded" })

# get response
conn.getresponse()
