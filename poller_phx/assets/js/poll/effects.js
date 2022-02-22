import { Socket } from 'phoenix';
import * as R from 'ramda';
import axios from './axios';
import {
  setAreasMsg,
  pollMsg,
  voteUpdateMsg,
  areaUpdateMsg,
} from './pollresultupdate';

// TODO: Implement rest endpoint /api/areas
export const fetchAreas = async () => {
  const request = await axios.get('/api/areas');
  return request.data;
};

// TODO: Implement rest endpoint /api/area/<areaId>
export const fetchArea = async areaId => {
  const request = await axios.get(`/api/areas/${areaId}`);
  return request.data;
};

// TODO: Implement rest endpoint /api/area/<areaId>/questions
// TODO: Implement rest endpoint /api/questions/<questionId>/choices
export const fetchQuestions = async areaId => {
  const questions = (await axios.get(`/api/areas/${areaId}/questions`))
    .data;
  const choicesPromise = R.map(
    question => axios.get(`/api/questions/${question.id}/choices`),
    questions,
  );
  const allChoices = (await Promise.all(choicesPromise))
    .map(result => result.data)
    .flat();
  const questionsWithChoices = R.map(question => {
    const choices = R.filter(
      choice => choice.questionId == question.id,
      allChoices,
    );
    return { ...question, choices };
  }, questions);
  return questionsWithChoices;
};

export const vote = async (areaId, choiceId) => {
  const url = `/api/areas/${areaId}/choices/${choiceId}`;
  await axios.put(url);
};

// TODO: Implement phoenix channel for realtime updates
export const pollResultEffects = (areaId, dispatch) => () => {
  fetchArea(areaId).then(area =>
    dispatch(areaUpdateMsg(area)),
  );
  // TODO: connect phoenix channel
  const socket = new Socket('/socket');
  socket.connect();
  const channel = socket.channel(`area:${areaId}`);
  channel
    .join()
    .receive('ok', ({poll}) => {
      dispatch(pollMsg(poll));
    })
    .receive('error', reason => {
      console.log({reason});
    });
  // channel.on('msg', ({msg}) => {
  //   console.log('msg', msg);
  // });
  channel.on('area_update', ({choice_id, votes}) => {
    dispatch(voteUpdateMsg(choice_id, votes));
  });
  return () => {
    channel.leave();
    socket.disconnect();
  };

};
