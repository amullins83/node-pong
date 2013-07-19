
    'use strict'

    # Services


    # Demonstrate how to register services
    # In this case it is a simple value service.
    mod = angular.module('nodePong.services', [])
    mod.value('version', '0.1').value('minWords', 150).value('maxWords', 300)

