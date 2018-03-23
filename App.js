import React from 'react';
import { StyleSheet, Text, View, FlatList, SafeAreaView} from 'react-native';

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
        
        return (
            <SafeAreaView style={styles.container}>
                <FlatList
                    style={styles.reachList}
                    data={this.state.reaches}
                    keyExtractor={(item) => item.id}
                    renderItem={(item) => <ReachSearchCell reach={item.item} />}
                />
            </SafeAreaView>
        )
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  reachList: {
      flex: 1,
      width: "100%"
  }
});
