export const INVITATION_ANSWER_SUBMIT = 'INVITATION_ANSWER_SUBMIT';
export const INVITATION_ANSWER_FETCH_SUCCESS =
  'INVITATION_ANSWER_FETCH_SUCCESS';

export function submitInvitationAnswer() {
  return { type: INVITATION_ANSWER_SUBMIT };
}

export function fetchInvitationAnswerSuccess(invitationAnswer) {
  const submitted = invitationAnswer.userId !== undefined;

  return {
    type: INVITATION_ANSWER_FETCH_SUCCESS,
    invitationAnswer,
    submitted
  };
}
