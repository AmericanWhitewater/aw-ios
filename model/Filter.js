'use strict'

module.exports = class {
    constructor() {
        this.regions // List AWRegion
        this.currentLocation // Object with lat, lng
        this.radius = 0 // int
        this.flowLevel // FlowLevel
        this.difficultyLowerBound // Difficulty
        this.difficultyUpperBound // Difficulty
    }
    
    hasRadius() {
        return this.radius > 0
    }
    
    hasCurrentLocation() {
        return Boolean(this.currentLocation)
    }
}
