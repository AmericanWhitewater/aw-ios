'use strict'

const moment = require('moment')

const FlowLevel = require('./FlowLevel')
const GageUnit = require('./api/GageUnit')

module.exports.fromResponse = fromResponse

function fromResponse(gageDetailResponse) {
    const currentReading = parseFloat(gageDetailResponse.gauge_reading)
    const lastReading = parseFloat(gageDetailResponse.last_gauge_reading)
    
    const delta = _getGageDelta(currentReading, lastReading)
    
    const lastUpdateInterval_s = parseInt(gageDetailResponse.last_gauge_updated)
    
    const unit = GageUnit.findById(gageDetailResponse.metricid).unit
    
    return {
        id: gageDetailResponse.gauge_id,
        name: gageDetailResponse.gauge_name,
        currentLevel: gageDetailResponse.gauge_reading,
        lastUpdated: _getLastUpdated(lastUpdateInterval_s),
        unit: unit,
        delta: delta,
        deltaTimeInterval: isNaN(lastUpdateInterval_s) ? undefined : lastUpdateInterval_s,
        gageComment: gageDetailResponse.gauge_comment,
        min: gageDetailResponse.min,
        max: gageDetailResponse.max,
        source: gageDetailResponse.source,
        sourceId: gageDetailResponse.source_id,
        awGageMetricId: gageDetailResponse.gauge_metric,
        flowLevel: FlowLevel.fromAWApiRCField(gageDetailResponse.rc),
    }
}

function _getGageDelta(currentReading, lastReading) {
    if (isNaN(currentReading) || isNaN(lastReading)) {
        return undefined
    }
    
    return currentReading - lastReading
}

function _getLastUpdated(lastUpdateInterval_s) {
    if (isNaN(lastUpdateInterval_s)) {
        return undefined
    }
    
    return moment().subtract(lastUpdateInterval_s, 'seconds')
}
