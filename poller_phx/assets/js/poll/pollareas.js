import React from 'react';
import Areas from './areas';

const PollAreas = ({ match }) => {
  return (
    <>
      <h1>Poll Areas</h1>
      <Areas linkTo="/app/polls" />
    </>
  );
};

export default PollAreas;
