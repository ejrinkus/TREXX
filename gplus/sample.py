# -*- coding: utf-8 -*-
#
# Copyright (C) 2013 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Command-line skeleton application for Google+ API.
Usage:
  $ python sample.py

You can also get help on all the command-line flags the program understands
by running:

  $ python sample.py --help

"""

import argparse
import httplib2
import sys

from apiclient import discovery
from oauth2client import file
from oauth2client import client
from oauth2client import tools

# Parser for command-line arguments.
parser = argparse.ArgumentParser(
    description=__doc__,
    formatter_class=argparse.RawDescriptionHelpFormatter,
    parents=[tools.argparser])

# Set up a Flow object to be used for authentication.
# Add one or more of the following scopes. PLEASE ONLY ADD THE SCOPES YOU
# NEED. For more information on using scopes please see
# <https://developers.google.com/+/best-practices>.
FLOW = client.flow_from_clientsecrets('client_secrets.json',
                                      scope=[
                                          'https://www.googleapis.com/auth/plus.login',
                                          'https://www.googleapis.com/auth/plus.me',
                                          'email',
                                          'profile',
                                      ],
                                      redirect_uri='urn:ietf:wg:oauth:2.0:oob',
                                      message=tools.message_if_missing('client_secrets.json'))


def main(argv):
    # Parse the command-line flags.
    flags = parser.parse_args(argv[1:])

    # If the credentials don't exist or are invalid run through the native client
    # flow. The Storage object will ensure that if successful the good
    # credentials will get written back to the file.
    storage = file.Storage('sample.dat')
    credentials = tools.run_flow(FLOW, storage, flags)

    # Create an httplib2.Http object to handle our HTTP requests and authorize it
    # with our good Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    # Construct the service object for the interacting with the Google+ API.
    service = discovery.build('plus', 'v1', http=http)

    try:
        # This example shows how to create moment that does not have a URL.
        moment = {"type": "http://schemas.google.com/AddActivity",
                  "target": {
                      "id": "target-id-1",
                      "type": "http://schemas.google.com/AddActivity",
                      "name": "The Google+ Platform",
                      "description": "A page that describes just how awesome Google+ is!",
                      "image": "https://developers.google.com/+/plugins/snippet/examples/thing.png"
                  }
        }
        google_request = service.moments().insert(userId='me', collection='vault', body=moment)
        result = google_request.execute()
        print 'win'

    except client.AccessTokenRefreshError:
        print ("The credentials have been revoked or expired, please re-run"
               "the application to re-authorize")


# For more information on the Google+ API you can visit:
#
#   https://developers.google.com/+/api/
#
# For more information on the Google+ API Python library surface you
# can visit:
#
#   https://developers.google.com/resources/api-libraries/documentation/plus/v1/python/latest/
#
# For information on the Python Client Library visit:
#
#   https://developers.google.com/api-client-library/python/start/get_started
if __name__ == '__main__':
    main(sys.argv)
