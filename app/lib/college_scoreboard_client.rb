class CollegeScoreboardClient
  # API Documentation
  # https://github.com/RTICWDT/open-data-maker/blob/master/API.md

  include HTTParty
  base_uri "https://api.data.gov/ed/collegescorecard"

  def initialize(api_key="hFeLJ71u78CwDdx9qJ5De8GWkXOMEheN7a56QF50")
    @api_key = api_key
  end

  def schools_by_name(name_query, page: 0, per_page: 100)
    default_fields = ['id', 'school.name', 'location.lat', 'location.lon']
    path = '/v1/schools'
    query = {
      'api_key': @api_key,
      'school.name': name_query,
      'fields': default_fields.join(','),
      'page': page,
      'per_page': per_page
    }
    self.class.get(path, query: query.to_param)
  end
end
