'use strict'

import "isomorphic-fetch";
const awApi = require('../../../model/api/awApi')

describe('awApi', function() {
    it('should get reaches by search', async function() {
        const result = await awApi.getReachesBySearch()
        console.log(result)
    })
})
