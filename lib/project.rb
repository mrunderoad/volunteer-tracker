class Project
  attr_accessor :id, :name

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      name = project.fetch("name")
      id = project.fetch("id")
      projects.push(Project.new({name: name, id: id}))
    end
    projects
  end

  def self.find(id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{id};").first
    name = project.fetch("name")
    id = project.fetch("id").to_i
    Project.new({name: name, id: id})
  end

  def save
    result = DB.exec("INSERT INTO projects (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(other_project)
    self.name.eql?(other_project.name)
  end

  def self.clear
    DB.exec("DELETE FROM projects *;")
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes[:name] != nil)
      @name = attributes[:name]
      DB.exec("UPDATE projects SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:volunteer_name)) && (attributes[:volunteer_name] != nil)
      volunteer_name = attributes[:city_name]
      volunteer = DB.exec("SELECT * FROM volunteers WHERE lower(name)='#{volunteer_name.downcase}';").first
    end
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
  end

end