import React, { Component } from 'react';
import { API } from 'aws-amplify';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { DateTime } from 'luxon';
import _ from 'lodash';
import styled from 'styled-components';

import bugsnagClient from '../../bugsnag';
import InvitationForm from './InvitationForm';
import { submitInvitationAnswer } from '../../actions/invitationAnswer';
import { openAlertSuccess, openAlertDanger } from '../../actions/alert';

const Title = styled.h1.attrs({
  className: 'mt-12 mb-8 text-white'
})`
  font-family: 'CoalhandLuke';
  font-weight: normal;
  letter-spacing: 0.5rem;
`;

function thanksMessage(attendance) {
  return attendance === 'true'
    ? 'ご回答ありがとうございました\n当日お会いできるのを楽しみにしています！'
    : 'ご回答ありがとうございました\n残念ですがまた別の機会にでもお会いしましょう！';
}

function sanitizeArrayField(values) {
  const additionalAttendees = _.compact(values.additionalAttendees);
  if (additionalAttendees.length === 0)
    return _.omit(values, 'additionalAttendees');

  return { ...values, additionalAttendees };
}

// temporary fix for missing api gateway escapes
function removeJSONInvalidChars(values) {
  const safeValues = _.clone(values);

  if (safeValues.message) {
    safeValues.message = safeValues.message.replace(/[\n"{}]/g, '');
  }
  if (safeValues.note) {
    safeValues.note = safeValues.note.replace(/[\n"{}]/g, '');
  }

  return safeValues;
}

class Invitation extends Component {
  constructor(props) {
    super(props);

    this.submit = this.submit.bind(this);
  }

  submit(values) {
    const createdAt = DateTime.local().toString();
    const body = {
      userId: this.props.userId,
      ...removeJSONInvalidChars(sanitizeArrayField(values)),
      createdAt
    };

    API.post('wedat', '/invitation-answers', { body })
      .then(() => {
        this.props.submitInvitationAnswer();
        this.props.history.push('/');
        this.props.openAlertSuccess(thanksMessage(values.attendance));
      })
      .catch(error => {
        this.props.openAlertDanger(
          'エラーが発生しました\nお手数ですが時間をおいて再度お試しください'
        );
        bugsnagClient.notify(error, {
          metaData: { response: error.response },
          user: { id: this.props.userId }
        });
        console.log(error.response);
      });
  }

  render() {
    return (
      <div className="flex flex-col items-center">
        <Title>Invitation</Title>
        <div className="mb-12 p-4 bg-grey-lightest sm:rounded">
          {this.props.submitted ? (
            <div>回答済みです</div>
          ) : (
            <InvitationForm onSubmit={this.submit} />
          )}
        </div>
      </div>
    );
  }
}

export default connect(
  ({ auth, invitationAnswer }) => ({
    userId: auth.username,
    submitted: invitationAnswer.submitted
  }),
  dispatch =>
    bindActionCreators(
      { submitInvitationAnswer, openAlertSuccess, openAlertDanger },
      dispatch
    )
)(Invitation);
