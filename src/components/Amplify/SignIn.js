import React from 'react';
import { SignIn as OrigSignIn } from 'aws-amplify-react';
import { I18n } from 'aws-amplify';
import {
  FormSection,
  SectionHeader,
  SectionBody,
  InputRow,
  ButtonRow
} from 'aws-amplify-react';

class SignIn extends OrigSignIn {
  constructor(props) {
    super(props);
    this.handlePasswordChange = this.handlePasswordChange.bind(this);
  }

  signIn(e) {
    super.signIn();
    e.preventDefault();
  }

  handlePasswordChange(e) {
    this.inputs = this.inputs || {};
    const { value } = e.target;
    this.inputs['password'] = value;
    this.inputs['username'] = value;
  }

  showComponent(theme) {
    const { hide } = this.props;
    if (hide && hide.includes(SignIn)) {
      return null;
    }

    return (
      <form>
        <FormSection theme={theme}>
          <SectionHeader theme={theme}>
            {I18n.get('Sign In Account')}
          </SectionHeader>
          <SectionBody theme={theme}>
            <InputRow
              placeholder={I18n.get('Password')}
              theme={theme}
              key="password"
              type="text"
              name="password"
              onChange={this.handlePasswordChange}
            />
            <ButtonRow theme={theme} onClick={this.signIn}>
              {I18n.get('Sign In')}
            </ButtonRow>
          </SectionBody>
        </FormSection>
      </form>
    );
  }
}

export default SignIn;
