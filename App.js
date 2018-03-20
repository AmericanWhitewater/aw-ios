import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const ReachSearchCell = require('./view/reachSearchCell')
const FilterRegionCell = require('./view/filterRegionCell')

export default class App extends React.Component {
  render() {
          
    return (
        // <View style={styles.container}>
            <FilterRegionCell/>
        // </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // alignItems: 'center',
    // justifyContent: 'center',
  },
});
