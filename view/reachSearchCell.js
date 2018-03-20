'use strict'
import React from 'react';
import { StyleSheet, Text, View, Image } from 'react-native';

const color = require('./resources/color')

module.exports = class ReachSearchCell extends React.Component {
    render() {
        return (
            <View styles={styles.V}>
                <View styles={styles.cell_run_highlight}/>
                <View styles={styles.GNK}>
                    <Text styles={styles.cell_run_title}/>
                    <Text styles={styles.cell_run_detail}/>
                    <Text styles={styles.cell_run_level}/>
                    <View styles={styles.SXRMCLP}/>
                    <View styles={styles.XZMWGUOA}/>
                </View>
                <View styles={styles.SKVRAMWGI}>
                    <Text styles={styles.cell_run_length}/>
                    <View styles={styles.YCOSOVOZPPL}/>
                    <Image styles={styles.cell_run_favorite}/>
                    <View styles={styles.YVXYOKSHVWXPY}/>
                </View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    V: {
        width: 'match_parent',
        height: '100dp',
        flexDirection: 'row',
    },
    cell_run_highlight: {
        width: '8dp',
        height: 'match_parent',
    },
    GNK: {
        width: '0dp',
        height: 'match_parent',
        marginLeft: '14dp',
        flex: 1,
        flexDirection: 'column',
    },
    cell_run_title: {
        // style: '@style/Headline1',
        width: 'match_parent',
        height: 'wrap_content',
        marginTop: '16dp',
    },
    cell_run_detail: {
        // style: '@style/Text1',
        width: 'match_parent',
        height: 'wrap_content',
        ellipsize: 'end',
        numberOfLines: '1',
    },
    cell_run_level: {
        // style: '@style/Label1',
        width: 'match_parent',
        height: 'wrap_content',
        marginBottom: '16dp',
        marginTop: '6dp',
    },
    SXRMCLP: {
        width: 'match_parent',
        height: '0dp',
        flex: 1,
    },
    XZMWGUOA: {
        width: 'match_parent',
        height: '.5dp',
        alpha: '.2',
        background: '@color/font_grey',
    },
    SKVRAMWGI: {
        width: 'wrap_content',
        height: 'match_parent',
        flexDirection: 'column',
    },
    cell_run_length: {
        // style: '@style/Headline1',
        width: 'wrap_content',
        height: 'wrap_content',
        marginRight: '16dp',
        marginTop: '16dp',
    },
    YCOSOVOZPPL: {
        width: 'match_parent',
        height: '0dp',
        flex: 1,
    },
    cell_run_favorite: {
        width: '32dp',
        height: '32dp',
        marginBottom: '16dp',
        marginRight: '16dp',
        alpha: '.5',
        scaleType: 'centerInside',
        srcCompat: '@drawable/ic_fav_no',
    },
    YVXYOKSHVWXPY: {
        width: 'match_parent',
        height: '.5dp',
        alpha: '.2',
        background: '@color/font_grey',
    },
});
