require 'sequel'

DB = Sequel.connect('sqlite://daimon.db')
#
# one = DB[:virtues].insert(description: "compassion", is_active: true)
# two = DB[:virtues].insert(description: "wisdom", is_active: true)
# three = DB[:virtues].insert(description: "thoughtfulness", is_active: true)
#
# DB[:virtues_habits].insert(habit_id: 1, virtue_id: one)
# DB[:virtues_habits].insert(habit_id: 1, virtue_id: two)
# DB[:virtues_habits].insert(habit_id: 2, virtue_id: three)
#
#
# DB.create_table :practices do
#   primary_key :id
#   String :comment
#   Date :timestamp
#   Integer :habit_id
# end
#
# DB.create_table :habits do
#   primary_key :id
#   String :description
#   Boolean :is_active
# end
#
# DB.create_table :virtues do
#   primary_key :id
#   String :description
#   Boolean :is_active
# end
#
# DB.create_table :virtues_habits do
#   primary_key :id
#   Integer :habit_id
#   Integer :virtue_id
# end
