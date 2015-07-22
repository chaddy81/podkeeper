VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

IMAGE_EXTENSIONS = %w(jpg jpeg gif png)

TIME_ZONE_OPTIONS = [
    ['Eastern', 'Eastern Time (US & Canada)'],
    ['Central', 'Central Time (US & Canada)'],
    ['Mountain', 'Mountain Time (US & Canada)'],
    ['Arizona', 'Arizona'],
    ['Pacific', 'Pacific Time (US & Canada)'],
    ['Alaska', 'Alaska'],
    ['Hawaii', 'Hawaii'],
    ['line'],
    ['(GMT +12:00) Auckland, Wellington, Fiji, Kamchatka', 'Auckland'],
    ['(GMT +11:00) Magadan, Solomon Islands, New Caledonia', 'Magadan'],
    ['(GMT +10:00) Eastern Australia, Guam, Vladivostok', 'Vladivostok'],
    ['(GMT +9:30) Adelaide, Darwin', 'Darwin'],
    ['(GMT +9:00) Tokyo, Seoul, Osaka, Sapporo, Yakutsk', 'Tokyo'],
    ['(GMT +8:00) Beijing, Perth, Singapore, Hong Kong', 'Singapore'],
    ['(GMT +7:00) Bangkok, Hanoi, Jakarta', 'Jakarta'],
    ['(GMT +6:00) Almaty, Dhaka, Colombo', 'Dhaka'],
    ['(GMT +5:30) Bombay, Calcutta, Madras, New Delhi', 'New Delhi'],
    ['(GMT +5:00) Ekaterinburg, Islamabad, Karachi, Tashkent', 'Tashkent'],
    ['(GMT +4:30) Kabul', 'Kabul'],
    ['(GMT +4:00) Abu Dhabi, Muscat, Baku, Tbilisi', 'Tbilisi'],
    ['(GMT +3:30) Tehran', 'Tehran'],
    ['(GMT +3:00) Baghdad, Riyadh, Moscow, St. Petersburg', 'Baghdad'],
    ['(GMT +2:00) Athens, Istanbul, Israel, South Africa', 'Athens'],
    ['(GMT +1:00) Brussels, Copenhagen, Madrid, Paris', 'Paris'],
    ['(GMT -0:00) London, Dublin, Western Europe, Casablanca', 'Casablanca'],
    ['(GMT -1:00) Azores, Cape Verde Islands', 'Azores'],
    ['(GMT -2:00) Mid-Atlantic', 'Mid-Atlantic'],
    ['(GMT -3:00) Brazil, Buenos Aires, Georgetown, Greenland', 'Georgetown'],
    ['(GMT -3:30) Newfoundland', 'Newfoundland'],
    ['(GMT -4:00) Atlantic Time (Canada), Caracas, La Paz', 'Atlantic Time (Canada)'],
    ['(GMT -11:00) Midway Island, Samoa', 'Midway Island'],
    ['(GMT -12:00) International Date Line West', 'International Date Line West']
]

LONG_STATES = [
    ['Alabama', 'AL'],
    ['Alaska', 'AK'],
    ['Arizona', 'AZ'],
    ['Arkansas', 'AR'],
    ['California', 'CA'],
    ['Colorado', 'CO'],
    ['Connecticut', 'CT'],
    ['Delaware', 'DE'],
    ['District of Columbia', 'DC'],
    ['Florida', 'FL'],
    ['Georgia', 'GA'],
    ['Hawaii', 'HI'],
    ['Idaho', 'ID'],
    ['Illinois', 'IL'],
    ['Indiana', 'IN'],
    ['Iowa', 'IA'],
    ['Kansas', 'KS'],
    ['Kentucky', 'KY'],
    ['Louisiana', 'LA'],
    ['Maine', 'ME'],
    ['Maryland', 'MD'],
    ['Massachusetts', 'MA'],
    ['Michigan', 'MI'],
    ['Minnesota', 'MN'],
    ['Mississippi', 'MS'],
    ['Missouri', 'MO'],
    ['Montana', 'MT'],
    ['Nebraska', 'NE'],
    ['Nevada', 'NV'],
    ['New Hampshire', 'NH'],
    ['New Jersey', 'NJ'],
    ['New Mexico', 'NM'],
    ['New York', 'NY'],
    ['North Carolina', 'NC'],
    ['North Dakota', 'ND'],
    ['Ohio', 'OH'],
    ['Oklahoma', 'OK'],
    ['Oregon', 'OR'],
    ['Pennsylvania', 'PA'],
    ['Puerto Rico', 'PR'],
    ['Rhode Island', 'RI'],
    ['South Carolina', 'SC'],
    ['South Dakota', 'SD'],
    ['Tennessee', 'TN'],
    ['Texas', 'TX'],
    ['Utah', 'UT'],
    ['Vermont', 'VT'],
    ['Virginia', 'VA'],
    ['Washington', 'WA'],
    ['West Virginia', 'WV'],
    ['Wisconsin', 'WI'],
    ['Wyoming', 'WY']
  ]

STATES =
  [
    ['AL', 'AL'],
    ['AK', 'AK'],
    ['AZ', 'AZ'],
    ['AR', 'AR'],
    ['CA', 'CA'],
    ['CO', 'CO'],
    ['CT', 'CT'],
    ['DE', 'DE'],
    ['DC', 'DC'],
    ['FL', 'FL'],
    ['GA', 'GA'],
    ['HI', 'HI'],
    ['ID', 'ID'],
    ['IL', 'IL'],
    ['IN', 'IN'],
    ['IA', 'IA'],
    ['KS', 'KS'],
    ['KY', 'KY'],
    ['LA', 'LA'],
    ['ME', 'ME'],
    ['MD', 'MD'],
    ['MA', 'MA'],
    ['MI', 'MI'],
    ['MN', 'MN'],
    ['MS', 'MS'],
    ['MO', 'MO'],
    ['MT', 'MT'],
    ['NE', 'NE'],
    ['NV', 'NV'],
    ['NH', 'NH'],
    ['NJ', 'NJ'],
    ['NM', 'NM'],
    ['NY', 'NY'],
    ['NC', 'NC'],
    ['ND', 'ND'],
    ['OH', 'OH'],
    ['OK', 'OK'],
    ['OR', 'OR'],
    ['PA', 'PA'],
    ['PR', 'PR'],
    ['RI', 'RI'],
    ['SC', 'SC'],
    ['SD', 'SD'],
    ['TN', 'TN'],
    ['TX', 'TX'],
    ['UT', 'UT'],
    ['VT', 'VT'],
    ['VA', 'VA'],
    ['WA', 'WA'],
    ['WV', 'WV'],
    ['WI', 'WI'],
    ['WY', 'WY']
  ]

def mod_time_zone_options
    options = {}
    ActiveSupport::TimeZone::MAPPING.each do |key, value|
      offset = DateTime.now.in_time_zone(key).utc_offset
      # if offset > -18000 || offset < -36000
      if offset > DateTime.now.in_time_zone('Eastern Time (US & Canada)').utc_offset || offset < DateTime.now.in_time_zone('Hawaii').utc_offset
        formatted_offset = DateTime.now.in_time_zone(key).formatted_offset
        if options[offset]
          options[offset][0] = "#{options[offset][0]}, #{key.to_s}"
        else
          options[offset] = ["(GMT #{formatted_offset}) #{key}", key]
        end
      end
    end

    time_zone_options = []
    options.each do |o|
      time_zone_options << o[1]
    end

    time_zone_options.unshift ['line']
    time_zone_options.unshift ['Hawaii', 'Hawaii']
    time_zone_options.unshift ['Alaska', 'Alaska']
    time_zone_options.unshift ['Pacific', 'Pacific Time (US & Canada)']
    time_zone_options.unshift ['Arizona', 'Arizona']
    time_zone_options.unshift ['Mountain', 'Mountain Time (US & Canada)']
    time_zone_options.unshift ['Central', 'Central Time (US & Canada)']
    time_zone_options.unshift ['Eastern', 'Eastern Time (US & Canada)']

    time_zone_options
end