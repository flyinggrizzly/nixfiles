require 'net/http'
require 'json'

ENV = "production"

if ENV == "development"
  HOST = "http://alfred-workflow-package-manager.dev"
  WORKFLOW_PATH = "~/Sites/alfred-workflow-package-manager-workflow/tmp"
else
  HOST = "http://flow.lab.io"
  WORKFLOW_PATH = "~/Library/Application\\ Support/Alfred\\ 2/Alfred.alfredpreferences/workflows"
end

module Workflow
  require "./lib/workflow/list"
  require "./lib/workflow/remote"
  require "./lib/workflow/git"

  def self.index
    workflows = Workflow::Remote.index()
    puts Workflow::List.generate_xml(workflows)
  end

  def self.search
    query = ARGV[1]
    if query && query != ""
      workflows = Workflow::Remote.search(query)
      puts Workflow::List.generate_xml(workflows)
    else
      self.index()
    end
  end

  def self.download
    id = ARGV[1]
    workflow = Workflow::Remote.get(id)
    git_repository_url = workflow["git_repository_url"]
    Workflow::Git.download git_repository_url
  end
end

case ARGV[0]
  when "index"
    if ARGV[1].nil?
      Workflow.index
    else
      Workflow.search
    end

  when "download"
    Workflow.download
end
