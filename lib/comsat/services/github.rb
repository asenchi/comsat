# GitHub Comsat URI: github://<api_key>:X@github.com/user/repo
module Comsat
  class Github < Service::Base
    def send_notice(data)
    end
    alias :send_alert :send_notice

    def send_resolve(data)
    end

    private

    def github_token
      @credentials.api_key
    end

    def github_repo
      @credentials.scope
    end

    def github_client
      @client = Octokit::Client.new(:access_token => github_token)
    end

    def create_issue(data)
      title = "[#{data[:source]}] #{data[:message_id]}"
      body = "\n#{data[:message]}\n"
      github_client.create_issue(github_repo, title, body)
    end

    def update_issue(issue, data)
      body = "[#{data[:source]}] #{data[:message_id]}\n#{data[:message]}"
      github_client.add_comment(github_repo, issue, body)
    end

    def close_issue(issue, data)
      body = "[#{data[:source]}] #{data[:message_id]}\n#{data[:message]}"
      github_client.add_comment(github_repo, issue, body)
      github_client.close_issue(github_repo, issue)
    end
  end
end
