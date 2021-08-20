import React from 'react';
import { Switch, Route } from 'react-router';
import PollAreas from './pollareas';
import Poller from './poller';

const Poll = ({ match }) => {
  return (
    <>
      <Switch>
        <Route exact path="/app/polls" component={PollAreas} />
        <Route exact path="/app/polls/:areaId" component={Poller} />
        <Route exact path="/app/polls/:areaId/:idx" component={Poller} />
      </Switch>
    </>
  );
};

export default Poll;
