# == Schema Information
# Schema version: 20100330111833
#
# Table name: events
#
#  id              :integer(4)      not null, primary key
#  title           :string(255)
#  starttime       :datetime
#  endtime         :datetime
#  all_day         :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#  description     :text
#  event_series_id :integer(4)
#

class Event < ActiveRecord::Base
  
  attr_accessor :period, :frequency, :commit_button, :backgroundColor, :textColor
  
  validates_presence_of :title, :description
  
  belongs_to :event_series
  belongs_to :event_type
  has_many :proposals, :class_name => 'Proposal', :foreign_key => 'vote_period_id'
  has_many :meetings, :class_name => 'Meeting'
  has_one :place, :through => :meetings, :class_name => 'Place'
  
  scope :vote_period, { :conditions => {:event_type_id => 2 }}
  
  REPEATS = ["Non ripetere",
             "Ogni giorno",
             "Ogni settimana",
             "Ogni mese",
             "Ogni anno"]
  
  
  def backgroundColor
    return "#DFEFFC"
  end
  
  def textColor
    return "#333333"
  end
  
  def validate
    if (starttime >= endtime) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
  
  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.starttime, e.endtime
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{e.starttime.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{e.endtime.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
        #puts "#{nst}           :::::::::          #{net}"
      rescue
        nst = net = nil
      end
      if nst and net
        #          e.attributes = event
        e.starttime, e.endtime = nst, net
        e.save
      end
    end
    
    event_series.attributes = event
    event_series.save
  end
  
  
  
end