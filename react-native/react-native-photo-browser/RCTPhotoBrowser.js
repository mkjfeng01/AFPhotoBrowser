'use strict';

import PropTypes from 'prop-types';
import React, { Component } from 'react';
import {
    View,
    requireNativeComponent,
    NativeModules
} from 'react-native';

let RNPhotoBrowser = requireNativeComponent('RCTPhotoBrowser', null);

export default class PhotoBrowser extends React.Component {
    render() {
        return <RNPhotoBrowser {...this.props} >
            {this.props.children}
        </RNPhotoBrowser>;
    }
}