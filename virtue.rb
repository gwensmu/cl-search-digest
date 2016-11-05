require "sequel"

class Virtue
  attr_accessor :description, :is_active

  def initialize(params)
    @description = params[:description]
    @is_active = params[:is_active]
  end

  def create(db, params)
    virtues = db[:virtues]
    virtues.insert(description: params[:description],
                   is_active: true)
  end

  def update(db, params, values)
    db[:virtues].filter(params).update(values)
  end

  def delete(db, filter)
    db[:virtues].where(filter).delete
  end

  def find(db, id)
    db[:virtues].filter(id: id).first
  end

  def self.all(db)
    db[:virtues].all
  end
end
