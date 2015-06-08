require 'date'

class MainController < ApplicationController
  include HTTParty
  attr_accessor :stats

  def index
    if Job.last.nil?
      api_query
    end
    # jobs
  end

  def jobs
    @stats = {}

    # @top = JobSkill.select("job_skills.skill_id, COUNT(skill_id) as skill_count").group("job_skills.skill_id").order("skill_count DESC").limit(10)
    @top_skills = {
      'Javascript' => ['Javascript', 'Javascript Frameworks', 'Javascript-JS Library'],
      'Python / Django' => ['Python', 'Django', 'Django/Flask'],
      'Ruby / Ruby on Rails' => ['Ruby on Rails', 'Ruby\Rails', 'Ruby', 'Rails', 'Backend Rails Development'],
      'HTML & CSS' => ['CSS', 'HTML', 'HTML5 & CSS3', 'HTML5  CSS3', 'HTML/CSS', 'HTML5/CSS3'],
      'iOS Development' => ['iOS Development', 'iOS', 'Objective C', 'Objective-C', 'Swift'],
      'Java' => ['Java', 'Java Based Infrastructure And Frameworks', 'Java Based Infrastructure', 'Java Based Frameworks'],
      'Node.js' => ['Node.js', 'Nodejs', 'NodeJs/Express', 'Node.js Developer', 'Node JS', 'Node'],
      'Sales and Marketing' => ['Sales', 'Sales and Marketing'],
      'PHP' => ['PHP', 'PHP5', 'PHP Frameworks', 'Laravel']
    }
    
    # calculate @stats of top skills + PHP
    @top_skills.each do |skill_name, skills_array|
      skill_ids_array = Skill.where(:name => skills_array).pluck(:id)
      add_stats(skill_name, skill_ids_array)
    end

    render json: @stats
  end

  def add_stats(skill_name, skills_array)
    # find all jobs matching skill => returns array of job_ids
    job_ids = JobSkill.where(:skill_id => skills_array).pluck('DISTINCT job_id')
    # find compensation for jobs => returns array of compensation objects
    comps = Compensation.where(:job_id => job_ids)

    # loop through compensation data to set skill data
    comps.each do |comp|
      if !@stats.has_key?(skill_name) # add skill to @stats if does not yet exist
        @stats[skill_name] = {
          total_salary_min: comp.salary_max,
          total_salary_max: comp.salary_max,
          count: 1,
        }
      else # update @stats if it already exists
        @stats[skill_name][:total_salary_min] += comp.salary_min
        @stats[skill_name][:total_salary_max] += comp.salary_max
        @stats[skill_name][:count] += 1
      end
    end
  end

  private

  def api_query
    i = 1; max = 2
    # API response is paginated so must call all pages individually
    until i > max do
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
          
        # Save any new full-time SF job that does not yet exist in the database
        if !Job.exists?(:angellist_id => job["id"]) && job["job_type"] == "full-time" &&
            # discard salary outliers (based on analysis of all data)
            !job["salary_min"].nil? && !job["salary_max"].nil? &&
            job["salary_min"].between?(1, 300000) && job["salary_max"].between?(1, 500000)

          new_job = Job.create(
            :angellist_id => job["id"],
            :title => job["title"],
            :created => job["created_at"],
            :last_updated => job["updated_at"],
            :company => company,
          )
          # ...and add related compensation
          Compensation.create(
            :job => new_job,
            :salary_min => job["salary_min"],
            :salary_max => job["salary_max"],
            :equity_min => job["equity_min"],
            :equity_max => job["equity_max"]
          )
          # add tags (skill or role) to database
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