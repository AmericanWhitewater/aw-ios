'use strict'
import React from 'react'
import { StyleSheet, NavigatorIOS, Text } from 'react-native'

const color = require('./resources/color')

module.exports = class MapView extends React.Component {
    render() {
        return (
            <NavigatorIOS
                initialRoute={{
                    component: Map,
                    title: 'American Whitewater',
                    passProps: {reaches: this.props.reaches}
                }}
                style={styles.navigator}
            />
        )
    }
}

class Map extends React.Component {
    render() {
        return (
            <Text>Map</Text>
        )
    }
}

const styles = StyleSheet.create({
    navigator: {
        flex: 1
    }
})