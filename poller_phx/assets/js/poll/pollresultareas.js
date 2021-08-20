import React from 'react';
import Areas from './areas';

const PollResultAreas = ({ match }) => {
  return (
    <>
      <h1>Poll Results</h1>
      <Areas linkTo="/app/results" />
    </>
  );
};

export default PollResultAreas;
