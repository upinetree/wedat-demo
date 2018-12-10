import React from 'react';
import { Field, Fields, FieldArray, reduxForm } from 'redux-form';
import styled from 'styled-components';

import colors from '../../colors';
import Label from './Label';
import NameField from './NameField';
import AttendanceField from './AttendanceField';
import additionalAttendeesField from './additionalAttendeesField';

const TextArea = styled(Field).attrs({
  className: 'shadow appearance-none text-grey-darker leading-tight'
})`
  width: 100%;
  padding: 0.5rem 0.75rem;
  border: 1px solid;
  border-radius: 0.25rem;
`;

const Button = styled.button.attrs({
  className: 'py-2 px-4 shadow rounded'
})`
  width: 100%;
  border: 1px solid;
  color: ${colors['white']};
  background-color: ${colors['blue-dark']};
  border: 1px solid;

  &:hover {
    color: ${colors['blue-dark']};
    background-color: ${colors['white']};
  }

  &:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
`;

const InvitationForm = ({ handleSubmit, pristine, submitting }) => {
  return (
    <form onSubmit={handleSubmit} className="w-full max-w-sm">
      <Field name="attendance" component={AttendanceField} />
      <Fields names={['lastName', 'firstName']} component={NameField} />
      <FieldArray
        name="additionalAttendees"
        component={additionalAttendeesField}
      />
      <div className="mb-4">
        <Label htmlFor="message">メッセージ</Label>
        <TextArea name="message" id="message" component="textarea" />
      </div>
      <div className="mb-4">
        <Label htmlFor="note">備考</Label>
        <TextArea name="note" id="note" component="textarea" />
        <p className="mt-2 text-sm leading-tight">
          お食事や飲料に関してアレルギー等による制限がありましたら詳細をお書きください
        </p>
      </div>
      <div className="mb-4">
        <Button type="submit" disabled={pristine || submitting}>
          登録
        </Button>
      </div>
    </form>
  );
};

export default reduxForm({
  form: 'invitation',
  validate: values => {
    const errors = {};
    if (!values.attendance) errors.attendance = '出欠を選んでちょんまげ';
    if (!values.lastName) errors.lastName = '姓を入れてちょんまげ';
    if (!values.firstName) errors.firstName = '名を入れてちょんまげ';
    return errors;
  }
})(InvitationForm);
