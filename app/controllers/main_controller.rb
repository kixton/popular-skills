require 'date'

class MainController < ApplicationController
  include HTTParty
  
  def index
    if Job.last.nil?
      days_since_last_query = 8
    else
      last_api_query = Job.last.updated_at.to_datetime
      days_since_last_query = (DateTime.now - last_api_query).to_i
    end

    api_query if (days_since_last_query > 7)

    @companies = Company.all
    @jobs = Job.all
    @skills = Skill.all
    @jobroles = Jobrole.all
    @jobskills = JobSkill.all
    @jobjobrole = JobJobrole.all

    puts "first job"
    puts Job.first
  end

  private

  def api_query
    i = 1; max = false
    # API response is paginated so must call all pages individually
    until i == 2 do
      data = HTTParty.get("https://api.angel.co/1/tags/1692/jobs?access_token=" +
        ENV["ANGELLIST_TOKEN"] + "&page=" + i.to_s)
      max = data["last_page"]
      # iterate jobs array on each page (50 jobs per array)
      data["jobs"].each do |job|
        # if company does not exist, add to database
        if !Company.exists?(:angellist_id => job["startup"]["id"])
          company = Company.create(
            :angellist_id => job["startup"]["id"],
            :name => job["startup"]["name"],
            :company_url => job["startup"]["company_url"],
            :angellist_url => job["startup"]["angellist_url"]
          )
          Logo.create(
            :company_id => company.angellist_id,
            :thumb_url => job["startup"]["thumb_url"]
          )
        else
          company = Company.where(:angellist_id => job["startup"]["id"]).first
        end
          
        if !Job.exists?(:angellist_id => job["id"])
          jobtype = Jobtype.where(:name => job["job_type"]).first
          new_job = Job.create(
            :angellist_id => job["id"],
            :title => job["title"],
            :created => job["created_at"],
            :last_updated => job["updated_at"],
            :company => company,
            :jobtype => jobtype
          )
          # ...and add compensation
          Compensation.create(
            :job => new_job,
            :salary_min => job["salary_min"],
            :salary_max => job["salary_max"],
            :equity_min => job["equity_min"],
            :equity_max => job["equity_max"]
          )
          # ...and add related skills/role to database
          job["tags"].each do |tag|
            if tag["tag_type"] == "SkillTag"
              skill = Skill.where(
                :angellist_id => tag["id"]
              ).first_or_create(
                :name => tag["display_name"]
              )
              JobSkill.create(
                :skill => skill,
                :job => new_job
              )
            elsif tag["tag_type"] == "RoleTag"
              jobrole = Jobrole.where(
                :angellist_id => tag["id"]
              ).first_or_create(
                :name => tag["display_name"]
              )
              JobJobrole.create(
                :jobrole => jobrole,
                :job => new_job
              )
            end
          end
        end
      end
      i += 1
    end
  end
end