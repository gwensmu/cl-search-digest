require "sequel"

class Practice
  attr_accessor :comment, :habit_id, :timestamp

  def initialize(params)
    @comment = params[:comment]
    @timestamp = params[:timestamp]
    @habit_id = params[:habit_id]
  end

  def self.create(db, params)
    db[:practices].insert(comment: params[:comment],
                          timestamp: Time.now,
                          habit_id: params[:habit_id])
  end

  def self.update(db, id, values)
    # todo: can I remove this if i use a different db? i just want my changes returned,
    # not an ID
    # todo: handle no-op updates well
    db[:practices].filter(id: id).update(values) if values.keys.any?
    db[:practices].filter(id: id).first
  end

  def self.delete(db, filter)
    db[:practices].where(filter).delete
  end

  def self.find(db, id)
    db[:practices].filter(id: id).first
  end

  # necessary?
  def self.all(db)
    db[:practices].all
  end
end
