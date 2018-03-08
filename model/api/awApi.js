'use strict'

const _ = require('lodash')


const BASE_URL = 'https://www.americanwhitewater.org/content/'

const PHOTO_BASE_URL = 'https://www.americanwhitewater.org/photos/archive/'
const ARTICLE_PHOTO_BASE_URL = 'https://www.americanwhitewater.org/resources/images/abstract/'
const FLOW_GRAPH_URL = 'https://www.americanwhitewater.org/content/Gauge2/graph/id/%s/metric/%d/.raw'

const SEARCH_ENDPOINT = 'River/search/.json'
const GEO_SEARCH_ENDPOINT = 'River/geo-summary/.json'
const REACH_LIST_ENDPOINT = 'River/list/list/{reachIdList}/.json'
const REACH_DETAIL_ENDPOINT = 'River/detail/id/{reachId}/.json'
const GAGE_DETAIL_ENDPOINT = 'Gauge2/detail/id/{gageId}/.json'
const ARTICLE_LIST_ENDPOINT = 'News/all/type/frontpagenews/subtype//page/0/.json?limit=10'
const ARTICLE_ENDPOINT = 'Article/view/articleid/{articleId}/.json'

module.exports.getReachesBySearch = getReachesBySearch

async function getReachesBySearch(searchText) {
    const response = await fetch(BASE_URL + SEARCH_ENDPOINT)
    const searchResponses = await response.json()
    
    const results = _.map(searchResponses, function(response) {
        const name = response.altname ? response.altname : response.section
        return {
            id: response.id,
            name: name,
            river: response.river,
            difficulty: response.class,
            lastGageReading: response.reading_formatted,
            // flowLevel: ,
            // putInLatLng: 
        }
    })
    
    return results
}

async function getReachesByGeo(bounds) {
    
}

async function getReachesByFilter(filter) {
    
}

async function getReachList(reachIds) {
    
}

async function getReach(reachId) {
    
}

async function getGageReaches(gage) {
    
}

async function getArticlesList() {
    
}

async function getArticlePhotoUrl() {
    
}

async function getFlowGraphUrl(gage) {
    
}
