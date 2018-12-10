import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

import colors from '../../colors';

const AnswerButton = styled.div.attrs({
  className: 'py-2 px-4 rounded shadow'
})`
  color: ${colors['white']};
  background-color: ${colors['blue-dark']};
  border: 1px solid;

  &:hover {
    color: ${colors['blue-dark']};
    background-color: ${colors['white']};
  }
`;

const InvitationMessage = () => (
  <div className="flex justify-center">
    <div className="px-4 py-8 max-w-md w-full bg-grey-lightest">
      <div className="mb-2 leading-normal">
        ようこそお越しくださいました
        <br className="block sm:hidden" />
        出欠のご回答をお願いいたします
      </div>
      <div className="my-4">
        <Link to="invitation" className="text-lg hover:no-underline">
          <AnswerButton>出欠を回答する</AnswerButton>
        </Link>
      </div>
      <p className="text-sm leading-tight text-pink">
        ※誠に勝手ながら11月1日までにご回答ください
      </p>
    </div>
  </div>
);

export default InvitationMessage;
