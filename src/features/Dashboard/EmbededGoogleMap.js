import React from 'react';

import { eventInfo } from '../../configuration';

const src = `https://www.google.com/maps/embed/v1/place?q=${
  eventInfo.googleMapQuery
}&key=AIzaSyD2TlCx8WNxmu39R9ZKcv2fJFoYkIkRuZE`;

const EmbededGoogleMap = () => (
  <iframe
    title="googlemap"
    height="450"
    frameBorder="0"
    className="border-none w-full"
    src={src}
    allowFullScreen
  />
);

export default EmbededGoogleMap;
