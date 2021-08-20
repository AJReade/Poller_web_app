import React from 'react';

export const partyName = partyId => {
  switch (partyId) {
    case 1:
      return 'Labour';
    case 2:
      return 'Conservative';
  }
};

export const partyColor = partyId => {
  switch (partyId) {
    case 1:
      return 'bg-dark-red';
    case 2:
      return 'bg-navy';
  }
};

export const Fetching = () => <i className="fas fa-spinner fa-spin blue f3" />;
