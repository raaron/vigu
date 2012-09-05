class DevelopmentController < ApplicationController
  def home
  end

  def roadmap
    @items = File.readlines(Rails.root.join("developer", "roadmap.txt"))
    render :layout => "development_not_home.html.erb"
  end

  def todo
    @items = File.readlines(Rails.root.join("developer", "todo.txt"))
    render :layout => "development_not_home.html.erb"
  end

  def done
    @items = File.readlines(Rails.root.join("developer", "done.txt"))
    render :layout => "development_not_home.html.erb"
  end

end
