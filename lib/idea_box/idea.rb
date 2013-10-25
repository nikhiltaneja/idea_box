class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :tags

  def initialize(attributes = {})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @tags = attributes["tags"].to_s.split(",").collect do |tag|
      tag.strip
    end
  end

  def has_tags?
    ! tags.empty?
  end

  def tag_list
    tags.join(",")
  end

  def save
    IdeaStore.create(to_h)
  end
  
  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "tags" => tag_list
    }
  end

  def up_vote!
    @rank += 1
  end

  def down_vote!
    @rank -= 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end
