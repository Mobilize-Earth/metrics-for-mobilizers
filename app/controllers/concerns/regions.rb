module Regions

  def self.us_regions
    {
      region_1: {
        name: 'Region 1',
        states: [
          'Connecticut',
          'Maine',
          'Massachusetts',
          'New Hampshire',
          'New Jersey',
          'New York',
          'Rhode Island',
          'Vermont'
        ]
      },
      region_2: {
        name: 'Region 2',
        states: [
          'Delaware',
          'District of Columbia',
          'Maryland',
          'North Carolina',
          'South Carolina',
          'Virginia',
          'West Virginia',
          'Pennsylvania'
        ]
      },
      region_3: {
        name: 'Region 3',
        states: [
          'Alabama',
          'Florida',
          'Georgia',
          'Mississippi',
          'PuertoRico',
          'Tennessee',
          'US Virgin Islands'
        ]
      },
      region_4: {
        name: 'Region 4',
        states: %w[Illinois Indiana Iowa Kentucky Michigan Minnesota Ohio Wisconsin]
      },
      region_5: {
        name: 'Region 5',
        states: %w[Arkansas Kansas Louisiana Missouri Oklahoma Texas]
      },
      region_6: {
        name: 'Region 6',
        states: [
          'Arizona',
          'Colorado',
          'Idaho',
          'Montana',
          'Nebraska',
          'Nevada',
          'New Mexico',
          'North Dakota',
          'South Dakota',
          'Utah',
          'Wyoming'
        ]
      },
      region_7: {
        name: 'Region 7',
        states: [
          'Alaska',
          'American Samoa',
          'California',
          'Guam',
          'Hawaii',
          'Northern Mariana Islands',
          'Oregon',
          'Washington'
        ]
      }
    }
  end
end