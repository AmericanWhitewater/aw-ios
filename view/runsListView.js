'use strict'
import React from 'react'
import { StyleSheet, FlatList } from 'react-native'

const ReachSearchCell = require('./reachSearchCell')

const color = require('./resources/color')

module.exports = class RunsListView extends React.Component {
    render() {
        return (
            <FlatList
                style={styles.reachList}
                data={this.props.reaches}
                keyExtractor={(item) => item.id}
                renderItem={(item) => <ReachSearchCell reach={item.item} />}
            />
        )
    }
}

const styles = StyleSheet.create({
    reachList: {
        flex: 1,
        backgroundColor: color.background
    }
})
