class Admin::AboutController < Admin::MultiParagraphPageController

  def initialize
    @page = Page.find_by_name(:about).becomes(About)
    @people_collection = @page.get_paragraph_collection(:people)
    @work_collection = @page.get_paragraph_collection(:work)
    super
  end

private
  # Force absolute URLs on the profile tab.
  def rewrite_options(options)
    puts "REWRITE"
    super(action_name == 'profile' ? options.merge(:only_path => false) : options)
  end

end