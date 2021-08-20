import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { areaUpdate, areaMsg } from './pollresultupdate';
import { fetchAreas } from './effects';
import { Fetching } from './fetching';

const fetchData = async setAreas => {
  setAreas(await fetchAreas());
};


const Areas = ({ linkTo }) => {
  const [areas, setAreas] = useState(null);

  useEffect(() => {
    fetchData(setAreas);
  }, []);

  if (areas === null) return <Fetching />;

  return (
    <ul className="list ph2">
      {areas &&
        areas.map(area => (
          <li className="f4 mv2" key={area.id}>
            <Link
              to={`${linkTo}/${area.id}`}
              className="link pointer dark-gray"
            >
              {area.name}
            </Link>
          </li>
        ))}
    </ul>
  );
};

export default Areas;
