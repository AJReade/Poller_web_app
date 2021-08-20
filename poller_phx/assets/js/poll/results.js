import React from 'react';
import { Switch, Route } from 'react-router';
import PollResultAreas from './pollresultareas';
import PollResults from './pollresults';

const path = (url = '') => `/app/${url}`;

const Result = ({ match }) => {
  return (
    <>
      <Switch>
        <Route exact path={path('results')} component={PollResultAreas} />
        <Route exact path={path('results/:id')} component={PollResults} />
      </Switch>
    </>
  );
};

export default Result;
