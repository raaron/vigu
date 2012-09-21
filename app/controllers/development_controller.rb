class DevelopmentController < ApplicationController

  def roadmap
    @items = File.readlines(Rails.root.join("developer", "roadmap.txt")).map{|i| i[2..-1]}
  end

  def todo
    @items = File.readlines(Rails.root.join("developer", "todo.txt")).map{|i| i[2..-1]}
  end

  def done
    @items = File.readlines(Rails.root.join("developer", "done.txt")).map{|i| i[2..-1]}
  end

end
