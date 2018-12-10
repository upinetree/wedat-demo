import styled from 'styled-components';
import toriImage from '../../tori.png';

export default styled.p.attrs({
  className: 'mt-2 text-pink text-sm italic'
})`
  &:before {
    display: inline-block;
    content: '';
    background: url(${toriImage}) no-repeat;
    background-size: 3rem;
    width: 3rem;
    height: 3rem;
    margin-right: 0.5rem;
    vertical-align: middle;
  }
`;
