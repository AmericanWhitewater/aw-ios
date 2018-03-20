'use strict'
import React from 'react';
import { StyleSheet, Text, View, Image } from 'react-native';

const color = require('./resources/color')

module.exports = class FilterRegionCell extends React.Component {
    render() {
        return (
            <View styles={styles.V}>
                <Text styles={styles.letter}/>
                <Text styles={styles.title}/>
                <Image styles={styles.checkbox}/>
            </View>
        )
    }
}


const styles = StyleSheet.create({
    V: {
        width: 'match_parent',
        height: '56dp',
        flexDirection: 'row',
    },
    letter: {
        width: '24dp',
        height: 'match_parent',
        marginLeft: '16dp',
        // gravity: 'center_vertical',
        textColor: color.font_blue,
        textSize: '24sp',
    },
    title: {
        width: '0dp',
        height: 'match_parent',
        marginLeft: '32dp',
        flex: 1,
        // gravity: 'center_vertical',
        textColor: color.font_black,
        textSize: '16sp',
    },
    checkbox: {
        width: '20dp',
        height: '16dp',
        layout_gravity: 'center_vertical',
        marginLeft: '4dp',
        marginRight: '20dp',
        visibility: 'gone',
        srcCompat: '@drawable/ic_check',
    },
})
