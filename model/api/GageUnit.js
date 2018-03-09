'use strict'

const _ = require('lodash')

const GageUnit = {
    RC: {
        id: 1,
        unit: "r.c.",
        label: "Status (r.c.)"
    },
    CFS: {
        id: 2,
        unit: "cfs",
        label: "Flow (cfs)"
    },
    Precip12H: {
        id: 3,
        unit: "in/12h",
        label: "Precip. in 12h (in/12h)"
    },
    Precip15Min: {
        id: 4,
        unit: "in/15min",
        label: "Precip. in 15m (in/15min)"
    },
    Precip24H: {
        id: 5,
        unit: "in/24h",
        label: "Precip. in 24h (in/24h)"
    },
    Precip6H: {
        id: 6,
        unit: "in/6h",
        label: "Precip. in 6h (in/6h)"
    },
    PrecipPerYear: {
        id: 7,
        unit: "in/yr",
        label: "Yearly Precip. (in/yr)"
    },
    Feet: {
        id: 8,
        unit: "ft",
        label: "Feet Stage (ft)"
    },
    Fahrenheit: {
        id: 9,
        unit: "? F",
        label: "Temperature (? F)"
    },
    AltCFS: {
        id: 10,
        unit: "cfs",
        label: "Alt. Flow (cfs)"
    },
    AltFt: {
        id: 11,
        unit: "ft",
        label: "Alt. Stage in Feet (ft)"
    },
    M: {
        id: 2,
        unit: "m",
        label: "Meters Stage (m)"
    },
    CMS: {
        id: 13,
        unit: "cms",
        label: "Metric Volumentric Flow (cm/s)"
    },
    Percent: {
        id: 14,
        unit: "%",
        label: "Percent (%)"
    },
    Inches: {
        id: 15,
        unit: "inches",
        label: "Inches Stage (inches)"
    }
}

function findById(id) {
    return _.find(GageUnit, function(gageUnit) {
        return gageUnit.id === id
    })
}

module.exports = GageUnit
module.exports.findById = findById
