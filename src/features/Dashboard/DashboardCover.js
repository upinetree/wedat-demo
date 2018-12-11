import styled from 'styled-components';
import coverImage from '../../cover.jpg';

export default styled.div`
  position: relative;
  display: flex;
  align-items: flex-end;
  background: url(${coverImage}) no-repeat center top;
  background-color: #222;
  background-size: cover;
  height: 600px;
  color: white;
  z-index: 0;

  @media screen and (max-width: 576px) {
    height: 400px;
    background-size: auto 100%;
  }

  &:before {
    content: '';
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    background: linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, 0.3));
    z-index: -1;
  }
`;
