'use strict'

const _ = require('lodash')
const queryString = require('query-string')


const BASE_URL = 'https://www.americanwhitewater.org/content/'

const PHOTO_BASE_URL = 'https://www.americanwhitewater.org/photos/archive/'
const ARTICLE_PHOTO_BASE_URL = 'https://www.americanwhitewater.org/resources/images/abstract/'
const FLOW_GRAPH_URL = 'https://www.americanwhitewater.org/content/Gauge2/graph/id/%s/metric/%d/.raw'

const SEARCH_ENDPOINT = 'River/search/.json'
const GEO_SEARCH_ENDPOINT = 'River/geo-summary/.json'
const ARTICLE_LIST_ENDPOINT = 'News/all/type/frontpagenews/subtype//page/0/.json?limit=10'
function getReachListEndpoint(reachIds) {
    return `River/list/list/${reachIds}/.json`
}
function getReachDetailEndpoint(reachId) {
    return `River/detail/id/${reachId}/.json`
}
function getGageDetailEndpoint(gageId) {
    return `Gauge2/detail/id/${gageId}/.json`
}

module.exports.getReachesBySearch = getReachesBySearch
module.exports.getReachesByGeo = getReachesByGeo
module.exports.getReachesByFilter = getReachesByFilter
module.exports.getReachList = getReachList
module.exports.getReach = getReach
module.exports.getGageReaches = getGageReaches
module.exports.getArticlesList = getArticlesList
module.exports.getArticlePhotoUrl = getArticlePhotoUrl
module.exports.getFlowGraphUrl = getFlowGraphUrl


async function getReachesBySearch(searchText) {
    const url = urlWithParams(BASE_URL + SEARCH_ENDPOINT, {
        river: searchText
    })
    
    const searchResponses = await _fetchJson(url)
    const results = _parseReachSearchResults(searchResponses)
    
    return results
}

async function getReachesByGeo(bounds) {
    const boundsString = [bounds.sw.lng, bounds.sw.lat, bounds.ne.lng, bounds.ne.lat].join()
    const url = urlWithParams(BASE_URL + GEO_SEARCH_ENDPOINT, {
        BBOX: boundsString
    })
    
    const searchResponses = await _fetchJson(url)
    const results = _parseReachSearchResults(searchResponses)
    
    return results
}

async function getReachesByFilter(filter) {
    
}

/**
* @param {Array} reachIds
*/
async function getReachList(reachIds) {
    const url = BASE_URL + getReachListEndpoint(reachIds.join())
    const responses = await _fetchJson(url)
    
    return _parseReachSearchResults(responses)
}

async function getReach(reachId) {
    const url = BASE_URL + getReachDetailEndpoint(reachId)
    const response = await _fetchJson(url)
    
    const reachDetailResponse = response.CContainerViewJSON_view.CRiverMainGadgetJSON_main.info
    
    const name = response.altname ? response.altname : response.section
    return {
        id: reachDetailResponse.id,
        name: name,
        sectionName: reachDetailResponse.section,
        river: reachDetailResponse.river,
        photoId: reachDetailResponse.photoid,
        length: reachDetailResponse.length,
        difficulty: reachDetailResponse.class,
        avgGradient: reachDetailResponse.avggradient,
        maxGradient: reachDetailResponse.maxgradient,
        // putinLatLng: reachDetailResponse.putinLatLng,
        // takeoutLatLng: reachDetailResponse.takeoutLatLng,
        description: reachDetailResponse.description,
        shuttleDetails: reachDetailResponse.shuttledetails,
        // gages: reachDetailResponse,
        // rapids: reachDetailResponse,
    }
}

async function getGageReaches(gage) {
    
}

async function getArticlesList() {
    
}

async function getArticlePhotoUrl() {
    
}

async function getFlowGraphUrl(gage) {
    
}

function _parseReachSearchResults(reachSearchResponses) {
    return _.map(reachSearchResponses, function(response) {
        const name = response.altname ? response.altname : response.section
        return {
            id: response.id,
            name: name,
            river: response.river,
            difficulty: response.class,
            lastGageReading: response.reading_formatted,
            // TODO flowLevel: ,
            // putInLatLng: 
        }
    })
}

function urlWithParams(url, params) {
    return url + '?' + queryString.stringify(params)
}

async function _fetchJson(url, options) {
    try {
        const response = await fetch(url, options)
        return await response.json()
    } catch (err) {
        console.log(err)
    }
}
