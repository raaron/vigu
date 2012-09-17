class DevelopmentController < ApplicationController

  def roadmap
    @items = File.readlines(Rails.root.join("developer", "roadmap.txt"))
    render :layout => "_development_list.html.erb"
  end

  def todo
    @items = File.readlines(Rails.root.join("developer", "todo.txt"))
    render :layout => "_development_list.html.erb"
  end

  def done
    @items = File.readlines(Rails.root.join("developer", "done.txt"))
    render :layout => "_development_list.html.erb"
  end

end
