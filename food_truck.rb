require 'httparty'

# queries the SF FoodTruck API and gets results
# API link: https://dev.socrata.com/foundry/data.sfgov.org/bbb8-hzi6
class FoodTruck

  BASE_URL = 'http://data.sfgov.org/resource/bbb8-hzi6.json?'

  def initialize
    # set the timezone for this process to SF's timezone, so that time.now
    # returns SF local time and we get food trucks that are open now
    # even if that program is run in a different time zone
    # for example this class might be use in a webserver that is not in that timezone
    ENV['TZ'] = 'America/Los_Angeles'
    # gets local time
    time = Time.now
    hour = time.strftime "%H:%M"
    day = time.wday

    # request food trucks that are open now and sorted alphabetically
    # application requirements state that the program should return
    # "food trucks that are open at the current date, when the program is being run"
    # but give example with a specific time, which is ambiguous;
    # so I interpet this as meaning current date and time
    url = BASE_URL + "$where=dayorder=#{day} AND start24 <= '#{hour}' AND end24 > '#{hour}'&$order=applicant"

    @response = HTTParty.get(url, follow_redirects: true)

    # httparty handles redirects, 400 and 500 are treated as an error
    if @response.code != 200
      raise "error loading food truck data"
    end

    # modify the name to be more readable
    trim_name(@response)

    # sorts truck names alphabetically
    @response.sort_by! { |truck| truck['applicant'] }

    # set initial position to use in next_page
    @position = 0
  end

  # returns 10 results per page, if there are no results returns nil
  def next_page
    if @position >= @response.length
      return nil
    end

    page = @response[@position...(@position + 10)]
    @position += 10

    return page
  end

  def trim_name(trucks)
    trucks.each do |truck|
      # strip everything before dba (doing business as)
      truck["applicant"].gsub!(/.* dba[.:]? /i, '')
      # strip trailing LLC
      truck["applicant"].gsub!(/,? llc\.?/i, '')
      # strip trailing INC
      truck["applicant"].gsub!(/,? inc\.?/i, '')
    end
  end
end
