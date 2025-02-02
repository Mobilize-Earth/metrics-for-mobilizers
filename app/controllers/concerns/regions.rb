module Regions

  def self.us_regions
    {
      region_1: {
        name: 'Upper East Coast',
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
        name: 'Middle Atlantic',
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
        name: 'Southeast',
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
        name: 'Big Heartland',
        states: %w[Illinois Indiana Iowa Kentucky Michigan Minnesota Ohio Wisconsin]
      },
      region_5: {
        name: 'Central Keystone',
        states: %w[Arkansas Kansas Louisiana Missouri Oklahoma Texas]
      },
      region_6: {
        name: 'InterMountain',
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
        name: 'Pacific',
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