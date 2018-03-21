'use strict'

const color = require('../view/resources/color')

const FlowLevel = {
    Low: {
        apiQueryCode: "low",
        colorCode: color.status_yellow
    },
    Runnable: {
        apiQueryCode: "run",
        colorCode: color.status_green
    },
    High: {
        apiQueryCode: "hig",
        colorCode: color.status_red
    },
    Frozen: {
        apiQueryCode: null,
        colorCode: color.status_blue
    },
    NoInfo: {
        apiQueryCode: null,
        colorCode: color.status_grey
    },
}

function fromAWApiCondField(cond) {
    switch (cond) {
        case "low":
            return FlowLevel.Low;
        case "med":
            return FlowLevel.Runnable;
        case "high":
            return FlowLevel.High;
        default:
            return FlowLevel.NoInfo;
    }
}

function fromAWApiRCField(rc) {
        if (rc == null) {
            return FlowLevel.NoInfo;
        }

        if (rc < 0) {
            return FlowLevel.Low;
        } else if (rc > 1) {
            return FlowLevel.High;
        } else {
            return FlowLevel.Runnable;
        }
    }

module.exports = FlowLevel
module.exports.fromAWApiCondField = fromAWApiCondField
module.exports.fromAWApiRCField = fromAWApiRCField
