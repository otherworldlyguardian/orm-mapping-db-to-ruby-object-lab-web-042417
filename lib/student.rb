require "pry"

class Student
  attr_accessor :id, :name, :grade

  @all = []

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    @all.clear
    sql = <<-SQL
      SELECT * FROM students
      SQL
    array = DB[:conn].execute(sql)
    array.each do |row|
      @all << new_from_db(row)
    end
    @all
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      SQL
    new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    self.all.select { |student| student.grade == "9" }
  end

  def self.students_below_12th_grade
    self.all.select { |student| student.grade.to_i < 12 }
  end

  def self.first_x_students_in_grade_10(num)
    self.all.select { |student| student.grade == "10" }[0..num-1]
  end

  def self.first_student_in_grade_10
    self.all.select { |student| student.grade == "10" }[0]
  end

  def self.all_students_in_grade_x(num)
    self.all.select { |student| student.grade.to_i == num }
  end
end
