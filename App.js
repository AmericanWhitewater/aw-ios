import React from 'react';
import { StyleSheet, Text, View, FlatList, SafeAreaView, TabBarIOS } from 'react-native';

const ReachSearchCell = require('./view/reachSearchCell')
const FilterRegionCell = require('./view/filterRegionCell')
// const RunsListView = require('./view/runsListView')
const RunsListView = require('./view/runsListView')
const MapView = require('./view/mapView')

const color = require('./view/resources/color')

const awApi = require('./model/api/awApi')

export default class App extends React.Component {
    
    constructor(props){
        super(props)
        this.state = { isLoading: true, selectedTab: 'runs' }
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
                <TabBarIOS 
                    selectedTab={this.state.selectedTab} 
                    style={styles.tabBar} 
                    barTintColor={color.primary}
                    tintColor={color.white}
                    unselectedTintColor={color.font_grey}>
                    <TabBarIOS.Item
                        title="News"
                        selected={this.state.selectedTab === 'news'}
                        onPress={() => {
                            this.setState({
                                selectedTab: 'news'
                            })
                        }}>
                        <Text>News</Text>
                    </TabBarIOS.Item>
                    <TabBarIOS.Item
                        title="Runs"
                        selected={this.state.selectedTab === 'runs'}
                        onPress={() => {
                            this.setState({
                                selectedTab: 'runs'
                            });
                        }}>
                        <RunsListView reaches={this.state.reaches} />
                    </TabBarIOS.Item>
                    <TabBarIOS.Item
                        title="Favorites"
                        selected={this.state.selectedTab === 'favorites'}
                        onPress={() => {
                            this.setState({
                                selectedTab: 'favorites'
                            })
                        }}>
                        <Text>Favorites</Text>
                    </TabBarIOS.Item>
                    <TabBarIOS.Item
                        title="Map"
                        selected={this.state.selectedTab === 'map'}
                        onPress={() => {
                            this.setState({
                                selectedTab: 'map'
                            })
                        }}>
                        <Text>Map</Text>
                    </TabBarIOS.Item>
                </TabBarIOS>
            </SafeAreaView>
        )
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: color.primary
  },
  reachList: {
      flex: 1,
      backgroundColor: color.background
  },
  tabBar: {
     flex: 1,
     width: '100%'
  }
});
