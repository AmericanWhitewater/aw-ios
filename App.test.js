import React from 'react';
import App from './App';

import renderer from 'react-test-renderer';
const awApi = require('./model/api/awApi')

it('renders without crashing', () => {
  const rendered = renderer.create(<App />).toJSON();
  expect(rendered).toBeTruthy();
});

describe('awApi', function() {
    it.skip('should get reaches by search', async function() {
        const result = await awApi.getReachesBySearch('tuolumne')
        
        console.log(result)
    })
    
    it('should get reaches by geo', async function() {
        // const latLngBounds = [ 
        //     -72.63562390909091,
        //     43.31350409090909,
        //     -71.9121920909091,
        //     44.036935909090914
        // ]
        const latLngBounds = {
            sw: {
                lat: 43.513041,
                lng: -72.550036
            },
            ne: {
                lat: 43.810774,
                lng: -72.000467
            }
        }
        
        const result = await awApi.getReachesByGeo(latLngBounds)
        
        console.log(result)
    })
    
    it('should get reaches by filter', async function() {
        
    })
    
    it.skip('should get a list of reaches', async function() {
        const reachIds = ['10386', '3242']
        const result = await awApi.getReachList(reachIds)
        
        console.log(result)
    })
    
    it.skip('should get a reach', async function() {
        const reachId = '1074'
        const result = await awApi.getReach(reachId)
        
        console.log(result)
    })
    
    it.skip('should get reaches for a gage', async function() {
        const gage = {
            id: '68'
        }
        const result = await awApi.getGageReaches(gage)
        
        console.log(result)
    })
    
    it.skip('should get articles list', async function() {
        const result = await awApi.getArticlesList()
        
        console.log(result)
    })
    
    const turf = require('turf')
    it.skip('should turf', function() {
        var point = turf.point([43.675220, -72.273908])
        var buffered = turf.buffer(point, 25, 'miles');
        var bbox = turf.bbox(buffered);
        
        console.log(bbox)
    })
})
