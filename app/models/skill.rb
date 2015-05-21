class Skill < ActiveRecord::Base
  has_many :jobs, through: :job_skill
end
