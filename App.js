import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const ReachSearchCell = require('./view/reachSearchCell')
const FilterRegionCell = require('./view/filterRegionCell')
// const RunsListView = require('./view/runsListView')

const awApi = require('./model/api/awApi')

export default class App extends React.Component {
    
    constructor(props){
        super(props)
        this.state = { isLoading: true }
    }
    
    async componentDidMount() {
        const reaches = await awApi.getReachesBySearch()
        this.setState({
          isLoading: false,
          reaches: reaches,
        })
    }
    
    render() {
        if (this.state.isLoading) {
            return (
                <View style={styles.container}>
                    <FilterRegionCell letter='A' title='hello'/>
                </View>
            )
        }
        
        console.log(this.state.reaches[0])
        return (
            <View style={styles.container}>
                <ReachSearchCell reach={this.state.reaches[0]}/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
