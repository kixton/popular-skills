class Job < ActiveRecord::Base
  belongs_to :company
  belongs_to :jobtype
  
  has_many :job_skills
  has_many :skills, through: :job_skills

  has_many :job_jobroles
  has_many :jobroles, through: :job_jobroles

  has_one :compensation
  has_one :salary_max, through: :compensation
end
