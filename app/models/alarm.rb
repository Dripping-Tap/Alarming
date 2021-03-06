class Alarm < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', inverse_of: :alarms

  DAYS = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
  before_validation :hour, :minute, :set_alarm, on: :create
  validates :name, :days, :time, presence: true

  # For alarming people
  scope :set, -> { where(set: true)}
  scope :this_hour, -> { set.where(time:  Time.now.beginning_of_hour..Time.now.end_of_hour)}

  scope :next, ->  { set.where("hour <= ?", DateTime.now.hour) }

  def alarm_hour_now
    self[:time].hour
  end

  def days=(days)
    self[:days] = days.select { |day| DAYS.include?(day) }
  end

  def minute
    self.time.min
  end

  def hour
    self.time.hour
  end

  protected

  def set_alarm
    days.each do |day|
      if day == DateTime.now.strftime("%A")
        self[:set] = true
      end
    end
  end
end