import React from "react";
import { StyleSheet, Text, View, BackHandler, Platform, WebView } from "react-native";

export default class App extends React.Component {
  state = {
    canGoBack : false,
    webView: null,
  }
  onAnroidBackPress = () =>{
    if(this.state.canGoBack && this.state.webView){
      this.state.webView.goBack();
      return true;
    }
    return false;
  }
  componentWillMount(){
    if(Platform.OS == 'android'){
      BackHandler.addEventListener('hardwareBackPress', this.onAnroidBackPress);
    }
  }
  componentWillUnmount(){
    if(Platform.OS == 'android'){
      BackHandler.removeEventListener('hardwareBackPress');
    }
  }  
  render() {
    return (
      <WebView
        source={{ uri: "http://derms.enertalk.com:8080" }}
        ref={(webView) => {this.state.webView = webView;}}
        onNavigationStateChange={(navState)=>{this.state.canGoBack = navState.canGoBack;}}
      />
    );
  }
}

const styles = StyleSheet.create({
});
