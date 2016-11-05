require "sequel"

class Habit
  attr_accessor :description, :is_active

  def initialize(params)
    @id = params[:id]
    @description = params[:description]
    @is_active = params[:is_active]
  end

  def create(db, params)
    habits = db[:habits]
    habits.insert(description: params[:description], is_active: true)
  end

  def update(db, params, values)
    db[:habits].filter(params).update(values)
  end

  def delete(db, filter)
    db[:habits].where(filter).delete
  end

  def self.find(db, id)
    db[:habits].filter(id: id).first
  end

  def self.virtues(db, id)
    db[:virtues].join(:virtues_habits, :virtue_id => :id).where(habit_id: id)
  end

  def self.all(db)
    db[:habits].all
  end
end
