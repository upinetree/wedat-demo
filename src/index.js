// initialize bugsnag ASAP, before other imports
import bugsnagClient from './bugsnag';
import createPlugin from 'bugsnag-react';
import '@babel/polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { createStore, combineReducers } from 'redux';
import { reducer as reduxFormReducer } from 'redux-form';
import { Settings as LuxonSettings } from 'luxon';
import Amplify from 'aws-amplify';
import { AmplifyTheme } from 'aws-amplify-react';
import { injectGlobal } from 'styled-components';

import App from './components/App';
import authReducer from './reducers/authReducer';
import alertReducer from './reducers/alertReducer';
import invitationAnswerReducer from './reducers/invitationAnswerReducer';
import * as serviceWorker from './serviceWorker';
import conf from './configuration';

import './index.css';

LuxonSettings.defaultLocale = 'ja';

Amplify.configure({
  Auth: conf.amplifyAuth,
  API: conf.amplifyAPI
});
Amplify.I18n.setLanguage('ja');
Amplify.I18n.putVocabularies(conf.amplifyVocabularies);

const theme = {
  ...AmplifyTheme,
  container: {
    ...AmplifyTheme.container,
    height: '100vh',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center'
  },
  formSection: {
    ...AmplifyTheme.formSection,
    width: '100%',
    maxWidth: '400px'
  },
  sectionFooter: {
    display: 'none'
  },
  input: {
    ...AmplifyTheme.input,
    fontSize: '16px'
  }
};

injectGlobal`
  @font-face {
    font-family: 'CoalhandLuke';
    src: url("/fonts/CoalhandLuke TRIAL.woff");
  }
`;

const reducer = combineReducers({
  auth: authReducer,
  alert: alertReducer,
  invitationAnswer: invitationAnswerReducer,
  form: reduxFormReducer
});

const store = createStore(
  reducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

const ErrorBoundary = bugsnagClient.use(createPlugin(React));

ReactDOM.render(
  <ErrorBoundary>
    <Provider store={store}>
      <App theme={theme} />
    </Provider>
  </ErrorBoundary>,
  document.getElementById('root')
);

serviceWorker.unregister();
