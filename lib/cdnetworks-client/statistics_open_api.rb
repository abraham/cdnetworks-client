module StatisticsOpenApi
  include AuthOpenApi
  include OpenApiKeys

  BANDWIDTH_PATH = "/api/rest/traffic/edge"

  class StatsHelper
    def self.handle_error_response(code, body)
      raise "Error #{resp[:code]}: #{desc}"
    end

    def self.handle_bandwidth_response(resp)
      if resp[:code] == "200"
        parsed = JSON.parse(resp[:body])
        return_code = parsed['trafficResponse']['returnCode'].to_s

        unless %w{0 200 404}.include? return_code
          OpenApiError::ErrorHandler.handle_error_response(return_code, resp[:body])
        end

        if return_code == "404"
          nil
        else
          Array.wrap(parsed['trafficResponse']['trafficItem']).map{|i| i['dataTransferred']}.inject(&:+)
        end

      else
        OpenApiError::ErrorHandler.handle_error_response(resp[:code], resp[:body])
      end
    end
  end

  def bandwidth_usage(service_name, from, to, time_interval = 2)
    session_token = get_session_token

    api_key = get_api_key(session_token, service_name)

    opts = {
      sessionToken: session_token,
      apiKey: api_key,
      fromDate: from.strftime("%Y%m%d"),
      toDate: to.strftime("%Y%m%d"),
      timeInterval: time_interval,
      output: "json"
    }

    response = call(BANDWIDTH_PATH, opts)

    StatsHelper.handle_bandwidth_response(response)
  end
end
