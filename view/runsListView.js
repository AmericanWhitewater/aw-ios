'use strict'
import React from 'react'
import { StyleSheet, FlatList, NavigatorIOS } from 'react-native'

const ReachSearchCell = require('./reachSearchCell')

const color = require('./resources/color')

module.exports = class RunsListView extends React.Component {
    render() {
        return (
            <NavigatorIOS
                initialRoute={{
                    component: RunList,
                    title: "American Whitewater",
                    passProps: {reaches: this.props.reaches}
                }}
                style={styles.navigator} />
        )
    }
}

class RunList extends React.Component {
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
    },
    navigator: {
        flex: 1
    }
})
