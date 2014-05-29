# GitHub Comsat URI: github://<api_key>:X@github.com/user/repo
module Comsat
  class Github < Service::Base
    def send_notice(data)
      issue = github_client.issues(github_repo, {
        :state => 'open',
      }).select { |i|
        i.title.start_with? issue_title(data)
      }.first

      if issue.nil?
        create_issue(data)
      else
        update_issue(data)
      end
    end
    alias :send_alert :send_notice

    def send_resolve(data)
      issue = github_client.issues(github_repo, {
        :state => 'open',
      }).select { |i|
        i.title.start_with? issue_title(data)
      }.first

      unless issue.nil?
        close_issue(issue.number, data)
      end
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

    def issue_title(data)
      "[#{data[:source]}] #{data[:message_id]}"
    end

    def issue_body(data)
      "\n#{data[:message]}\n"
    end

    def issue_comment(data)
      "[#{data[:source]}] #{data[:message_id]}\n#{data[:message]}"
    end

    def create_issue(data)
      title = issue_title(data)
      body  = issue_body(data)
      github_client.create_issue(github_repo, title, body)
    end

    def update_issue(issue, data)
      body = issue_comment(data)
      github_client.add_comment(github_repo, issue, body)
    end

    def close_issue(issue, data)
      github_client.add_comment(github_repo, issue, data[:message])
      github_client.close_issue(github_repo, issue)
    end
  end
end
