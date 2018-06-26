/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  requireNativeComponent
} from 'react-native';

let RNPhotoBrowser = requireNativeComponent('RCTPhotoBrowser', null);

type Props = {};
export default class App extends Component<Props> {
  render() {
    return (
      <RNPhotoBrowser photos={[
        ["https://cdn57.androidauthority.net/wp-content/uploads/2017/10/android-authority-google-pixel-2-official-photos-3-1340x754.jpg",
          "https://www.istockphoto.com/resources/images/PhotoFTLP/img_67920257.jpg",
          "https://timedotcom.files.wordpress.com/2017/12/cristina-mittermeier-polar-bear-top-100-photos-2017.jpg?quality=85&w=2160",
          "https://timedotcom.files.wordpress.com/2017/12/cristina-mittermeier-polar-bear-top-100-photos-2017.jpg?quality=85&w=2160",
          "https://picjumbo.com/wp-content/uploads/young-woman-showing-heart-symbol-with-hands_free_stock_photos_picjumbo_DSC09172-1080x720.jpg",
          "http://files.all-free-download.com//downloadfiles/wallpapers/1280_960/rainbow_drip_wallpaper_abstract_other_2092.jpg",
          "https://iso.500px.com/wp-content/uploads/2016/02/stock-photo-114337435-1500x1000.jpg",
          "https://iso.500px.com/wp-content/uploads/2015/06/pedro_cover-1500x1000.jpeg"],
        ["https://drscdn.500px.org/photo/81890739/m%3D900/v2?webp=true&sig=4b68b3de981ce01a66680c81c6cc197a6cabd430d8d7256139e4b10c397e921d",
          "https://dsx.weather.com/util/image/w/ap_18145543411898.jpg?v=ap&w=980&h=551&api=7db9fe61-7414-47b5-9871-e17d87b8b6a0",
          "https://www.androidcentral.com/sites/androidcentral.com/files/styles/xlarge/public/article_images/2016/06/backup-photos-google-photos-hero-02.jpg?itok=reTPEvtF",
          "https://cdn57.androidauthority.net/wp-content/uploads/2017/10/android-authority-google-pixel-2-official-photos-3-1340x754.jpg",
          "https://www.istockphoto.com/resources/images/PhotoFTLP/img_67920257.jpg",
          "https://cdn.cnn.com/cnnnext/dam/assets/180208155400-09-week-in-photos-0209-restricted-super-169.jpg",
          "https://timedotcom.files.wordpress.com/2017/12/cristina-mittermeier-polar-bear-top-100-photos-2017.jpg?quality=85&w=2160",
          "https://picjumbo.com/wp-content/uploads/young-woman-showing-heart-symbol-with-hands_free_stock_photos_picjumbo_DSC09172-1080x720.jpg",
          "http://files.all-free-download.com//downloadfiles/wallpapers/1280_960/rainbow_drip_wallpaper_abstract_other_2092.jpg",
          "https://iso.500px.com/wp-content/uploads/2016/02/stock-photo-114337435-1500x1000.jpg"],
        ["https://drscdn.500px.org/photo/81890739/m%3D900/v2?webp=true&sig=4b68b3de981ce01a66680c81c6cc197a6cabd430d8d7256139e4b10c397e921d",
          "https://dsx.weather.com/util/image/w/ap_18145543411898.jpg?v=ap&w=980&h=551&api=7db9fe61-7414-47b5-9871-e17d87b8b6a0",
          "https://images.pexels.com/photos/196666/pexels-photo-196666.jpeg"],
        ["https://media.defense.gov/2018/Feb/16/2001878914/-1/-1/0/180209-F-PM645-983.JPG"]
      ]} style={styles.container}>

      </RNPhotoBrowser>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  }
});
