import React, { useState, useEffect } from 'react';
import { Link, withRouter, Redirect } from 'react-router-dom';
import * as R from 'ramda';
import axios from './axios';
import { partyName, partyColor } from './util';
import { Fetching } from './fetching';
import { fetchArea, fetchQuestions, vote } from './effects';

const fetchData = async (state, setState, areaId) => {
  const [area, questions] = await Promise.all([
    fetchArea(areaId),
    fetchQuestions(areaId),
  ]);
  setState({ area, questions });
};

const Poller = ({ match, history }) => {
  const { areaId } = match.params;
  const idx = parseInt(match.params.idx);
  const [state, setState] = useState(null);
  useEffect(() => {
    fetchData(state, setState, areaId);
  }, []);
  if (!state) return <Fetching />;
  if (idx >= state.questions.length)
    return <Redirect to={`/app/polls/${areaId}`} />;
  return (
    <>
      <h1>Poll for {state.area.name}</h1>
      {idx > -1 ? (
        <Question state={state} idx={idx} history={history} />
      ) : (
        <StartButton areaId={areaId} />
      )}
    </>
  );
};

const Question = ({ state, idx, history }) => {
  const question = state.questions[idx];
  const { area } = state;
  return (
    <section className="mh2">
      <h3 className="f3 fw4">{question.description}</h3>
      <Choices
        choices={question.choices}
        idx={idx}
        areaId={area.id}
        history={history}
      />
      <CancelButton areaId={area.id} />
    </section>
  );
};

const Choices = props => {
  const { choices } = props;
  return (
    <div className="flex justify-between flex-wrap mb3">
      {R.map(
        choice => (
          <Choice key={choice.id} choice={choice} {...props} />
        ),
        choices,
      )}
    </div>
  );
};

const handleChoice = async (history, idx, areaId, choice) => {
  await vote(areaId, choice.id);
  history.push(`/app/polls/${areaId}/${idx + 1}`);
};

const Choice = ({ history, idx, areaId, choice }) => {
  return (
    <a
      className={`w-100 w-40-ns link dim pv3 mb2 dib white ${partyColor(
        choice.partyId,
      )} br1
        pointer`}
      onClick={() => {
        handleChoice(history, idx, areaId, choice);
      }}
    >
      <div className="f3 tc mb2">{choice.description}</div>
      <div className="f5 tc mb2">{partyName(choice.partyId)}</div>
    </a>
  );
};

const StartButton = ({ areaId }) => (
  <Link
    to={`/app/polls/${areaId}/0`}
    className="ml2 link dim pv3 ph4 mb2 dib white bg-blue ba b--blue br1
        pointer"
  >
    Start
  </Link>
);

const CancelButton = ({ areaId }) => (
  <Link
    to={`/app/polls/${areaId}`}
    className="
    link dim pv3 ph4 mb2 dib dark-gray ba b--black-80 br1 pointer"
  >
    Cancel
  </Link>
);

export default withRouter(Poller);
