require 'yaml/store'

class IdeaStore

  def self.database
    if ENV['RACK_ENV'] == 'test'
      return @database if @database
      @database ||= YAML::Store.new('db/ideabox_test')
      @database.transaction do
        @database['ideas'] ||= []
      end
    else
      return @database if @database
      @database ||= YAML::Store.new('db/ideabox')
      @database.transaction do
        @database['ideas'] ||= []
      end
    end
    @database
  end

  def database
    Idea.database
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.invalid_data?(data)
    data["title"].empty? 
  end

  def self.create(data)
    return if invalid_data?(data)

    database.transaction do
      database['ideas'] << data
    end
  end

  def self.find_ideas(phrase)
    if phrase == ""
      return []
    end

    all.find_all do |idea|
      idea.title.downcase.include?(phrase) || idea.description.downcase.include?(phrase) || idea.tags.to_s.downcase.include?(phrase)
    end
  end

  def self.delete_all
    @all = []
  end

end
