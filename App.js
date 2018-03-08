import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const awApi = require('./model/api/awApi')

export default class App extends React.Component {
  render() {
      
      awApi.getReach('10386')
      .then(function(results){
          console.log(results)
      })
          
    return (
      <View style={styles.container}>
        <Text>This is American Whitewater</Text>
        <Text>Changes you make will automatically reload.</Text>
        <Text>Shake your phone to open the developer menu.</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
