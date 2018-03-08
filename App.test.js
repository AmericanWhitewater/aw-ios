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
    
    it.skip('should get reaches by geo', async function() {
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
})
