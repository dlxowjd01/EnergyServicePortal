import React from "react";
import { StyleSheet, Text, View, WebView } from "react-native";

export default class App extends React.Component {
  render() {
    return (
      <WebView
        source={{ uri: "http://derms.enertalk.com:8080" }}
      />
    );
  }
}

const styles = StyleSheet.create({  
});
