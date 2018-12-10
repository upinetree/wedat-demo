import React from 'react';
import styled from 'styled-components';

import toriImage from '../tori.png';

const Title = styled.h1`
  font-size: 100px;
  margin-top: 150px;
  margin-top: calc(50vh - 125px);
`;

const Tori = styled.img.attrs({
  src: toriImage
})`
  height: 100px;
`;

const Error404 = () => (
  <div className="text-white text-center">
    <Title className="flex items-center justify-center">
      4<Tori />4
    </Title>
    <p className="text-lg">Page Not Found...</p>
  </div>
);

export default Error404;
