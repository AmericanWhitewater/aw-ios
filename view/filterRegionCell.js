'use strict'
import React from 'react';
import { StyleSheet, Text, View, Image } from 'react-native';

const color = require('./resources/color')

module.exports = class FilterRegionCell extends React.Component {
    render() {
        return (
            <View style={styles.V}>
                <Text style={styles.letter}>{this.props.letter}</Text>
                <Text style={styles.title}>{this.props.title}</Text>
                <Image style={styles.checkbox}/>
            </View>
        )
    }
}


const styles = StyleSheet.create({
    V: {
    //     width: match_parent,
        height: 56,
        flexDirection: 'row',
        alignItems: 'center'
    },
    letter: {
        width: 24,
    //     height: match_parent,
        marginLeft: 16,
    //     gravity: 'center_vertical',
        color: color.font_blue,
        fontSize: 24,
    },
    title: {
        width: 0,
    //     height: match_parent,
        marginLeft: 32,
        flex: 1,
        textAlign: 'left',
        color: color.font_black,
        fontSize: 16,
    },
    checkbox: {
        width: 20,
        height: 16,
    //     layout_gravity: 'center_vertical',
        marginLeft: 4,
        marginRight: 20,
    //     visibility: 'gone',
    //     source: '@drawable/ic_check',
    },
})
