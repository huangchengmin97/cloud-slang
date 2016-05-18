#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

namespace: user.flows

imports:
 ops: user.ops

flow:
  name: on_failure_more_steps
  inputs:
    - navigationType
    - emailHost
    - emailPort
    - emailSender
    - emailRecipient
  workflow:
    - produce_default_navigation:
        do:
          ops.produce_default_navigation:
            - navigationType

    - check_weather: # default navigation: go to this step on success
        do:
          ops.check_weather:
            - city: 'AwesomeCity'
        navigate:
          - SUCCESS: SUCCESS # end flow with success result

    - on_failure: # default navigation: go to this step on failure
        - send_error_mail:
            do:
              ops.send_email_mock:
                - hostname: ${ emailHost }
                - port: ${ emailPort }
                - sender: ${ emailSender }
                - recipient: ${ emailRecipient }
                - subject: 'Flow failure'
                - body: 'Default failure navigation here'
            navigate:
              - SUCCESS: FAILURE # end flow with failure result
              - FAILURE: FAILURE
        - send_another_error_mail:
            do:
              ops.send_email_mock:
                - hostname: ${ emailHost }
                - port: ${ emailPort }
                - sender: ${ emailSender }
                - recipient: ${ emailRecipient }
                - subject: 'Flow failure'
                - body: 'Default failure navigation here'
            navigate:
              - SUCCESS: FAILURE # end flow with failure result
              - FAILURE: FAILURE