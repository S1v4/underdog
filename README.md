## Underdog Backend Coding Challenge

To get a base level understanding of how you approach real life problems, we’d like you to complete this small code challenge. We don’t want to waste your time, so while we’re interested in how you can tackle this creatively, we don’t want you to use more than 3 or 4 hours. We’re interested in how you structure your code for organization and extensibility purposes as well clarity. You can use any technology you’d like.

### Step 1

Import and persist the players from the following CBS api for baseball, football, and basketball.

http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON

### Step 2

Create a JSON api endpoint for a player. Like seen below:
```json
{
  "id": "123",
  "name_brief": "P. Mahomes",
  "first_name": "Patrick",
  "last_name": "Mahomes",
  "position": "QB",
  "age": "26",
  "average_position_age_diff": "1"
}
```

Each element in the JSON should be self explanatory except for the following two:
```
● name_brief
  ○ For football players it should be the first initial and their last name like “P.
  Manning”.
  ○ For basketball players it should be first name plus last initial like “Kobe B.”.
  ○ For baseball players it should just be the first initial and the last initial like “G. S.”.

● average_position_age_diff
  ○ This value should be the difference between the age of the player vs the average age for the player’s position.
```

### Step 3

Create a basic search JSON api endpoint that will return player based on any combination of the following parameters:
```
  ● Sport
  ● First letter of last name
  ● A specific age (ex. 25)
  ● A range of ages (ex. 25 - 30)
  ● The player’s position (ex: “QB”)
```

### Reference

http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON

### Setup

- Install and set Ruby 2.7.5 in working directory.
- Run `bundle install`
- Run `rails db:setup` (includes db seeds from "http://api.cbssports.com/fantasy/players/list?version=3.0&SPORT=baseball&response_format=JSON")
- Start server on port 3000: `rails server -p 3000`
- To run the test suite, use `bundle exec rspec`

### Notes

- JSON API endpoint supports single record by ID or collection filterable by query parameters per requirements. Example requests:

`GET /api/v1/players?age=45`

Result:
```json
[{"id":1910,"sport_id":1,"name_brief":"F. R.","first_name":"Fernando","last_name":"Rodney","position":"RP","age":45,"average_position_age_diff":16}]
```

`GET /api/v1/players/1910`

Result:
```json
{"id":1910,"sport_id":1,"name_brief":"F. R.","first_name":"Fernando","last_name":"Rodney","position":"RP","age":45,"average_position_age_diff":16}
```

- Names, position, and age are required fields for imported players.
- Tests are under `/spec`
# underdog
# underdog
