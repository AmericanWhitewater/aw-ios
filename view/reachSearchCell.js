'use strict'
import React from 'react';
import { StyleSheet, Text, View, Image } from 'react-native';

const color = require('./resources/color')

module.exports = class ReachSearchCell extends React.Component {
    render() {
        console.log(this.props)
        const reach = this.props.reach
        
        const levelText = `Level: ${reach.lastGageReading}, Class: ${reach.difficulty}`
        
        return (
            <View style={styles.V}>
                <View style={styles.cell_run_highlight} backgroundColor={reach.flowLevel.colorCode}/>
                <View style={styles.GNK}>
                    <Text style={styles.cell_run_title}>
                        {reach.river}
                    </Text>
                    <Text numberOfLines={1} style={styles.cell_run_detail}>
                        {reach.name}
                    </Text>
                    <Text style={ [styles.cell_run_level, { color: reach.flowLevel.colorCode }] }>
                        {levelText}
                    </Text>
                    <View style={styles.SXRMCLP}/>
                    <View style={styles.XZMWGUOA}/>
                </View>
                <View style={styles.SKVRAMWGI}>
                    <View style={styles.YCOSOVOZPPL}/>
                    <Image style={styles.cell_run_favorite}/>
                    <View style={styles.YVXYOKSHVWXPY}/>
                </View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    V: {
    //     width: match_parent,
        height: 100,
        flexDirection: 'row',
    },
    cell_run_highlight: {
        width: 8,
    //     height: match_parent,
    },
    GNK: {
        width: 0,
    //     height: match_parent,
        marginLeft: 14,
        flex: 1,
        flexDirection: 'column',
    },
    cell_run_title: {
    //     style: '@style/Headline1',
    //     width: match_parent,
    //     height: wrap_content,
        marginTop: 16,
    },
    cell_run_detail: {
    //     style: '@style/Text1',
    //     width: match_parent,
    //     height: wrap_content,
    },
    cell_run_level: {
    //     style: '@style/Label1',
    //     width: match_parent,
    //     height: wrap_content,
        marginBottom: 16,
        marginTop: 6,
    },
    SXRMCLP: {
    //     width: match_parent,
        height: 0,
        flex: 1,
    },
    XZMWGUOA: {
    //     width: match_parent,
        height: .5,
        opacity: .2,
        backgroundColor: color.font_grey,
    },
    SKVRAMWGI: {
    //     width: wrap_content,
    //     height: match_parent,
        flexDirection: 'column',
    },
    cell_run_length: {
    //     style: '@style/Headline1',
    //     width: wrap_content,
    //     height: wrap_content,
        marginRight: 16,
        marginTop: 16,
    },
    YCOSOVOZPPL: {
    //     width: match_parent,
        height: 0,
        flex: 1,
    },
    cell_run_favorite: {
        width: 32,
        height: 32,
        marginBottom: 16,
        marginRight: 16,
        opacity: .5,
    //     scaleType: 'centerInside',
    //     source: '@drawable/ic_fav_no',
    },
    YVXYOKSHVWXPY: {
    //     width: match_parent,
        height: .5,
        opacity: .2,
        backgroundColor: color.font_grey,
    },
});
