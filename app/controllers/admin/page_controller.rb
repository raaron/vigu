class Admin::PageController < Admin::ApplicationController

  before_filter :admin_user

  def update
    check_is_change_image_request
    check_is_add_link_request
    redirect_to request.referrer
  end

protected

  # Check, whether the pressed submit button was a "Change picture" button.
  # Delete the image in this case.
  # IMPORTANT NOTE: Call this method after the +update_attributes()+ call,
  # otherwise, the changes get owerridden.
  def check_is_change_image_request
    if params[:change_img]
      p = Paragraph.find(params[:change_img].keys.first)
      p.images = []
      p.save
    end
  end


  # Check, whether the pressed submit button was a "Add Link" button.
  # Append the link text to the body in this case.
  # IMPORTANT NOTE: Call this method after the +update_attributes()+ call,
  # otherwise, the changes get owerridden.
  def check_is_add_link_request
    if params[:add_link]
      link_text = " link(#{t(:visible_text)}, #{t(:invisible_url)}) "
      p = Paragraph.find(params[:add_link].keys.first)
      p.update_attributes({title: p.get_title, body: p.get_body + link_text})
    end
  end

end
