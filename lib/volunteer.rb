class Volunteer
  attr_accessor :name, :id

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def ==(volunteer_to_compare)
    if volunteer_to_compare != nil
      self.name() == volunteer_to_compare.name()
    else
      false
    end
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers")
    volunteers = []
    returned_volunteers.each() do |city|
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({name: name, id: id}))
    end
    volunteers
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def self.find(id)
    volunteer = DB.exec("SELECT * FROM volunteers WHERE id = #{id};").first
    if volunteer
      name = volunteer.fetch("name")
      id = volunteer.fetch("id").to_i
      Volunteers.new({name: name, id: id})
    else
      nil
    end
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes[:name] != nil)
      @name = attributes[:name]
      DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:project_name)) && (attributes[:project_name] != nil)
      project_name = attributes[:project_name]
      project = DB.exec("SELECT * FROM projects WHERE lower(name)='#{project_name.downcase}';").first
    end
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

  def self.clear
    DB.exec("DELETE FROM volunteers *;")
  end

  def projects
    projects = []
    results = DB.exec("SELECT project_id FROM projects WHERE city_id = #{@id};")
    results.each do |result|
      project_id = result.fetch("project_id").to_i
      project = DB.exec("SELECT * FROM projects WHERE id = #{project_id};")
      name = project.first.fetch("name")
      projects.push(Project.new({name: name, id: project_id}))
    end
    projects
  end

end